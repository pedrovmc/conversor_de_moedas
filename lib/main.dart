import "package:flutter/material.dart";
import 'package:http/http.dart' as http;
import "dart:async";
import 'dart:convert';

const request = "https://api.hgbrasil.com/finance/quotations?key=10055c6b";


void main() async {
  runApp(MaterialApp(
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Future<Map> getData() async {
    http.Response response = await http.get(request);
    return json.decode(response.body);
  }
  double dolar;
  double euro;

  TextEditingController realController = TextEditingController();
  TextEditingController dolarController = TextEditingController();
  TextEditingController euroController = TextEditingController();


  _realChanged(String valor) {
    double real = double.parse(valor);
    dolarController.text = (real/dolar).toStringAsFixed(2);
    euroController.text = (real/dolar).toStringAsFixed(2);
  }

  _dolarChanged(String valor) {
    double dolar = double.parse(valor);
    realController.text = (dolar * this.dolar).toStringAsFixed(2);
    euroController.text = (dolar * this.dolar / euro).toStringAsFixed(2);

  }

  _euroChanged(String valor) {
    double euro = double.parse(valor);
    realController.text = (euro * this.euro).toStringAsFixed(2);
    dolarController.text = (euro * this.euro / dolar).toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("\$ Conversor \$"),
        centerTitle: true,
        backgroundColor: Colors.amber,
      ),
      body: FutureBuilder<Map>(
        future: getData(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(child: buildTextTile("Carregando dados..."));
            default:
              if (snapshot.hasError) {
                return Center(child: buildTextTile("Erro ao carregar dados!"));
              } else {
                dolar = snapshot.data["results"]["currencies"]["USD"]["buy"];
                euro = snapshot.data["results"]["currencies"]["EUR"]["buy"];
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Icon(Icons.monetization_on,
                          color: Colors.amber, size: 150.00),
                      buildTextField("Reais", "R\$ ", realController, _realChanged),
                      Divider(),
                      buildTextField("Dólares", "US\$ ", dolarController, _dolarChanged),
                      Divider(),
                      buildTextField("Euros", "€ ", euroController, _euroChanged),
                    ],
                  ),
                );
              }
          }
        },
      ),
    );
  }
}

buildTextField(
    String label, String prefix, TextEditingController controller, change) {
  return TextField(
    controller: controller,
    onChanged: change,
    keyboardType: TextInputType.number,
    decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color: Colors.amber,
          fontSize: 25.00,
        ),
        enabledBorder:
            OutlineInputBorder(borderSide: BorderSide(color: Colors.amber)),
        focusedBorder:
            OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
        prefixText: prefix,
        prefixStyle: TextStyle(color: Colors.amber)),
    style: TextStyle(color: Colors.amber),
  );
}

buildTextTile(String text) {
  return Text(text,
      textAlign: TextAlign.center,
      style: TextStyle(color: Colors.amber, fontSize: 23.00));
}
