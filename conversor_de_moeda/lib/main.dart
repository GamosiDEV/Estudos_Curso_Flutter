import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

const request = 'https://api.hgbrasil.com/finance?format=json&key=d2224e9d';

void main() async {
  runApp(MaterialApp(
    home: Home(),
    theme: ThemeData(
        hintColor: Colors.yellow,
        primaryColor: Colors.white,
        inputDecorationTheme: const InputDecorationTheme(
          enabledBorder:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
          focusedBorder:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.yellow)),
          hintStyle: TextStyle(color: Colors.yellow),
        )),
  ));
}

Future<Map> getData() async {
  http.Response response = await http.get(request);
  return json.decode(response.body);
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final realController = TextEditingController();
  final dolarController = TextEditingController();
  final euroController = TextEditingController();

  late double dolar;
  late double euro;

  void _realIsChanged(String text) {
    double real = double.parse(text);
    dolarController.text = (real / dolar).toStringAsFixed(2);
    euroController.text = (real / euro).toStringAsFixed(2);
  }

  void _dolarIsChanged(String text) {
    double _dolar = double.parse(text);
    realController.text = (dolar * _dolar).toStringAsFixed(2);
    euroController.text = ((dolar * _dolar) / euro).toStringAsFixed(2);
  }

  void _euroIsChanged(String text) {
    double _euro = double.parse(text);
    realController.text = (euro * _euro).toStringAsFixed(2);
    dolarController.text = ((euro * _euro) / dolar).toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: const Text(
            'Conversor de Moeda',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          backgroundColor: Colors.yellow,
          centerTitle: true,
        ),
        body: FutureBuilder<Map>(
            future: getData(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.waiting:
                  return const Center(
                    child: Text(
                      'Carregando dados',
                      style: TextStyle(color: Colors.yellow, fontSize: 25.0),
                      textAlign: TextAlign.center,
                    ),
                  );
                default:
                  if (snapshot.hasError) {
                    return const Center(
                      child: Text(
                        'Erro ao carregar dados :(',
                        style: TextStyle(color: Colors.yellow, fontSize: 25.0),
                        textAlign: TextAlign.center,
                      ),
                    );
                  } else {
                    dolar =
                        snapshot.data!["results"]["currencies"]["USD"]["buy"];
                    euro =
                        snapshot.data!["results"]["currencies"]["EUR"]["buy"];

                    return SingleChildScrollView(
                      padding: EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          const Icon(
                            Icons.monetization_on,
                            size: 150.0,
                            color: Colors.yellow,
                          ),
                          const Divider(),
                          buildTextField(
                              'Real', "R\$", realController, _realIsChanged),
                          const Divider(),
                          buildTextField('Dolar', "US\$", dolarController,
                              _dolarIsChanged),
                          const Divider(),
                          buildTextField(
                              'Euro', '€', euroController, _euroIsChanged),
                        ],
                      ),
                    );
                  }
              }
            }));
  }
}

Widget buildTextField(
    String label, String prefix, TextEditingController controller, function) {
  return TextField(
    decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(
          color: Colors.yellow,
        ),
        border: OutlineInputBorder(),
        prefixText: prefix,
        prefixStyle: const TextStyle(color: Colors.yellow, fontSize: 25.0)),
    style: const TextStyle(
      color: Colors.yellow,
      fontSize: 25.0,
    ),
    controller: controller,
    onChanged: function,
    // Por algum motivo a linguagem não aceitou eu colocar um tipo para esta variavel, e o app fucionou apenas quando eu removi o mesmo dos parametros da função
    keyboardType: TextInputType.number,
  );
}
