import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MaterialApp(
    home: Home(),
    theme: ThemeData(
        hintColor: Colors.teal,
        primaryColor: Colors.white,
        inputDecorationTheme: const InputDecorationTheme(
          enabledBorder:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
          focusedBorder:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.teal)),
          hintStyle: TextStyle(color: Colors.teal),
        )),
  ));
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String _result = 'Resultado';

  int _count = 0;

  final totalAController = TextEditingController();
  final totalBController = TextEditingController();
  final fracaoAController = TextEditingController();
  final fracaoBController = TextEditingController();

  bool _isEmpty(TextEditingController controller) {
    if (controller.text == '') {
      return true;
    } else {
      return false;
    }
  }

  void _resetFields(){
    setState(() {
      totalAController.text = '';
      totalBController.text = '';
      fracaoAController.text = '';
      fracaoBController.text = '';
      _result = 'Resultado';
      _count = 0;
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Regra de Tres'),
        centerTitle: true,
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            onPressed: _resetFields,
            icon: const Icon(Icons.refresh),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(
              width: 100.0,
              height: 100.0,
              child: FittedBox(
                child: Text(
                  _result,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Padding(padding: EdgeInsets.all(20)),
            Row(
              children: [
                Flexible(
                    child: textFields(
                        'Total A', totalAController, numberOfActiveTextFields)),
                SizedBox(width: 20.0),
                Flexible(
                    child: textFields(
                        'Total B', totalBController, numberOfActiveTextFields))
              ],
            ),
            Padding(padding: EdgeInsets.all(20)),
            Row(
              children: [
                Flexible(
                    child: textFields('Fração A', fracaoAController,
                        numberOfActiveTextFields)),
                SizedBox(width: 20.0),
                Flexible(
                    child: textFields('Fração B', fracaoBController,
                        numberOfActiveTextFields))
              ],
            ),
          ],
        ),
      ),
    );
  }

  void numberOfActiveTextFields(String s) {
    _count = 0;
    _count = _isEmpty(totalAController) ? _count - 1 : _count + 1;
    _count = _isEmpty(totalBController) ? _count - 1 : _count + 1;
    _count = _isEmpty(fracaoAController) ? _count - 1 : _count + 1;
    _count = _isEmpty(fracaoBController) ? _count - 1 : _count + 1;
    setState(() {});
  }

  void calculoRegraDeTres() {
    double resultado = 0;
    if (_isEmpty(totalAController)) {
      resultado = regraDeTres(
          primeiroA: double.parse(fracaoBController.text),
          segundoA: double.parse(totalBController.text),
          valorB: double.parse(fracaoAController.text));
    } else if (_isEmpty(totalBController)) {
      resultado = regraDeTres(
          primeiroA: double.parse(fracaoAController.text),
          segundoA: double.parse(totalAController.text),
          valorB: double.parse(fracaoBController.text));
    } else if (_isEmpty(fracaoAController)) {
      resultado = regraDeTres(
          primeiroA: double.parse(totalBController.text),
          segundoA: double.parse(fracaoBController.text),
          valorB: double.parse(totalAController.text));
    } else if (_isEmpty(fracaoBController)) {
      resultado = regraDeTres(
          primeiroA: double.parse(totalAController.text),
          segundoA: double.parse(fracaoAController.text),
          valorB: double.parse(totalBController.text));
    }
    setState(() {
      _result = resultado.toStringAsFixed(2);
    });
  }

  double regraDeTres(
      {required double primeiroA,
      required double segundoA,
      required double valorB}) {
    return (segundoA * valorB) / primeiroA;
  }

  Widget textFields(String label, TextEditingController controller, function) {
    if (_count >= 2 && _isEmpty(controller)) {
      return TextButton(
        onPressed: calculoRegraDeTres,
        style: TextButton.styleFrom(
          backgroundColor: Colors.teal,
          fixedSize: Size.fromWidth(200),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        ),
        child: const Text(
          'Calcular',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 25,
          ),
        ),
      );
    } else {
      return TextField(
        controller: controller,
        onChanged: function,
        decoration: InputDecoration(
            labelText: label,
            labelStyle: const TextStyle(
              color: Colors.teal,
            ),
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.all(10)),
        style: const TextStyle(
          color: Colors.teal,
          fontSize: 25.0,
        ),
        keyboardType: TextInputType.numberWithOptions(decimal: true),
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.digitsOnly,
        ],
      );
    }
  }
}
