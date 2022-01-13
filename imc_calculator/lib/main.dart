import 'dart:ffi';

import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    home: HomePage(),
  ));
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController weightController = TextEditingController();
  TextEditingController heightController = TextEditingController();

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _infoText = 'I';

  void _resetFields() {
    setState(() {
      weightController.text = '';
      heightController.text = '';
      _infoText = 'Informe seus dados';
    });
  }

  void _calculateImc() {
    setState(() {
      double weight = double.parse(weightController.text);
      double height = double.parse(heightController.text) / 100;
      double imc = weight / (height * height);
      if (imc < 18.6) {
        _infoText = "Abaixo do peso (${imc.toStringAsPrecision(4)})";
      } else if (imc >= 18.6 && imc < 24.9) {
        _infoText = "Peso ideial (${imc.toStringAsPrecision(4)})";
      } else if (imc >= 24.9 && imc < 29.9) {
        _infoText = "Levemente acima do peso (${imc.toStringAsPrecision(4)})";
      } else if (imc >= 29.9 && imc < 34.9) {
        _infoText = "Obesidade Grau I (${imc.toStringAsPrecision(4)})";
      } else if (imc >= 34.9 && imc < 39.9) {
        _infoText = "Obesidade Grau II (${imc.toStringAsPrecision(4)})";
      } else if (imc >= 40.0) {
        _infoText = "Obesidade Grau III (${imc.toStringAsPrecision(4)})";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Caulculadora de IMC'),
          centerTitle: true,
          actions: <Widget>[
            IconButton(
              onPressed: _resetFields,
              icon: const Icon(Icons.refresh),
            )
          ],
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Icon(
                  Icons.person_outline,
                  size: 120.0,
                  color: Colors.lightBlue,
                ),
                TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                      labelText: "Peso (kg)",
                      labelStyle: TextStyle(color: Colors.lightBlue)),
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.lightBlue, fontSize: 25.0),
                  controller: weightController,
                  validator: (value){
                    if(value!.isEmpty){
                      return 'Insira seu Peso!';
                    }
                  },
                ),
                TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                      labelText: "Altura (cm)",
                      labelStyle: TextStyle(color: Colors.lightBlue)),
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.lightBlue, fontSize: 25.0),
                  controller: heightController,
                  validator: (value) {
                    if(value!.isEmpty){
                      return 'Insira sua altura!';
                    }
                  },
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                  child: Container(
                    height: 50.0,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.lightBlue,
                      ),
                      onPressed: (){
                        if(_formKey.currentState!.validate()){
                          _calculateImc();
                        }
                      },
                      child: const Text(
                        'Calcular',
                        style: TextStyle(fontSize: 25.0),
                      ),
                    ),
                  ),
                ),
                Text(
                  _infoText.toString(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.lightBlue,
                    fontSize: 25,
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
