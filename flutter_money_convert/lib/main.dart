import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:async/async.dart';
import 'dart:convert';

const request_USD_BRL = 'https://api.frankfurter.dev/v2/rate/USD/BRL';
const request_USD_EUR = 'https://api.frankfurter.dev/v2/rate/USD/EUR';
const request_BRL_EUR = 'https://api.frankfurter.dev/v2/rate/BRL/EUR';
const request_USD_IENE = 'https://api.frankfurter.dev/v2/rate/USD/JPY';

void main() async {
  runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Home()));

}

final realControl = TextEditingController();
final dollarControl = TextEditingController();
final euroControl = TextEditingController();
final ieneControl = TextEditingController();

class Home extends StatefulWidget {


  const Home({super.key});


  @override

  State<Home> createState() => _HomeState();

}

class _HomeState extends State<Home> {
  late double usd_brl;
  late double usd_eur;
  late double brl_eur;
  late double usd_iene;

  late Future<Map> data;

  @override
  void initState() {
    super.initState();
    data = getData();
  }

  void _clearAll() {
    realControl.text = '';
    dollarControl.text = '';
    euroControl.text = '';
    ieneControl.text = '';
  }

  void _realFunction(String o) {
    if (o.isEmpty) {
      _clearAll();
      return;
    }
    double money = double.parse(o);
    dollarControl.text = (money / usd_brl).toStringAsFixed(2);
    euroControl.text = (money * brl_eur).toStringAsFixed(2);
    ieneControl.text = (money / usd_brl * usd_iene).toStringAsFixed(2);
  }

  void _dollarFunction(String o) {
    if (o.isEmpty) {
      _clearAll();
      return;
    }
    double money = double.parse(o);
    realControl.text = (money * usd_brl).toStringAsFixed(2);
    euroControl.text = (money * usd_eur).toStringAsFixed(2);
    ieneControl.text = (money * usd_iene).toStringAsFixed(2);
  }

  void _euroFunction(String o) {
    if (o.isEmpty) {
      _clearAll();
      return;
    }
    double money = double.parse(o);
    realControl.text = (money / brl_eur).toStringAsFixed(2);
    dollarControl.text = (money / usd_eur).toStringAsFixed(2);
    ieneControl.text = (money / usd_eur * usd_iene).toStringAsFixed(2);
  }

  void _ieneFunction(String o) {
    if (o.isEmpty) {
      _clearAll();
      return;
    }
    double money = double.parse(o);
    realControl.text = (money / usd_iene * usd_brl).toStringAsFixed(2);
    dollarControl.text = (money / usd_iene).toStringAsFixed(2);
    euroControl.text = (money / usd_iene * usd_eur).toStringAsFixed(2);
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      /*appBar: AppBar(
        backgroundColor: Color.fromRGBO(204, 138, 0, 1),
        title: Text('\$ Converte Moedas \$'),
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontWeight: FontWeight.w500,
          color: Colors.black,
          fontSize: 26,
        ),
      ),*/
      body: FutureBuilder<Map>(
        future: data,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(
                child: Text(
                  'Loading...',
                  style: TextStyle(fontSize: 34, fontWeight: FontWeight.w800),
                ),
              );
            default:
              if (snapshot.hasError) {
                return Center(
                  child: Text('ERRO !!!', style: TextStyle(color: Colors.red,
                  fontSize: 100,
                  fontWeight: FontWeight.w900)),
                );
              } else {
                brl_eur = snapshot.data!['BrlEur']['rate'];
                usd_brl = snapshot.data!['UsdBrl']['rate'];
                usd_eur = snapshot.data!['UsdEur']['rate'];
                usd_iene = snapshot.data!['UsdIene']['rate'];

                return Container(
                  color: Colors.black,

                  child: Padding(
                    padding: EdgeInsetsGeometry.symmetric(horizontal: 50),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Center(
                          child: Padding(
                            padding: EdgeInsetsGeometry.directional(
                              top: 60,
                              bottom: 130,
                            ),
                            child: Text(
                              'Currency Converter',
                              style: TextStyle(
                                fontSize: 80,
                                color: Color.fromRGBO(204, 153, 0, 0.8),
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ),
                        Column(
                          children: [
                            Center(
                              child: Padding(
                                padding: EdgeInsetsGeometry.all(12),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: buildTextField(
                                        'Real',
                                        Icons.attach_money,
                                        Color.fromRGBO(0, 200, 0, 0.6),
                                        realControl,
                                        _realFunction,
                                        Color.fromRGBO(0, 200, 0, 0.1),
                                      ),
                                    ),
                                    SizedBox(width: 30),
                                    Expanded(
                                      child: buildTextField(
                                        'Dollar',
                                        Icons.attach_money,
                                        Color.fromRGBO(0, 0, 153, 1),
                                        dollarControl,
                                        _dollarFunction,
                                        Color.fromRGBO(0, 0, 153, 0.15),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 50),
                            Center(
                              child: Padding(
                                padding: EdgeInsetsGeometry.directional(),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: buildTextField(
                                        'Euro',
                                        Icons.euro,
                                        Color.fromRGBO(150, 0, 0, 1),
                                        euroControl,
                                        _euroFunction,
                                        Color.fromRGBO(150, 0, 0, 0.1),
                                      ),
                                    ),
                                    SizedBox(width: 12),
                                    Expanded(
                                      child: buildTextField(
                                        'Yen',
                                        Icons.currency_yen,
                                        Colors.white54,
                                        ieneControl,
                                        _ieneFunction,
                                        Colors.white10,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }
          }
        },
      ),
    );
  }
}

Widget buildTextField(
  String dinheiro,
  IconData icone,
  Color cor,
  TextEditingController control,
  function,
  Color corfundo,
) {
  return /*SizedBox(
    height: 100,
    child: */ TextField(
    style: TextStyle(
      color: Color.fromRGBO(204, 153, 0, 0.8),
      fontWeight: FontWeight.w600,
      fontSize: 50,
    ),
    controller: control,
    decoration: InputDecoration(
      contentPadding: EdgeInsetsGeometry.directional(top: 80),
      filled: true,
      fillColor: corfundo,
      counterStyle: TextStyle(),
      enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: cor)),
      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: cor)),
      labelStyle: TextStyle(
        color: Color.fromRGBO(204, 153, 0, 0.8),
        fontWeight: FontWeight.w300,
        fontSize: 40,
      ),
      labelText: dinheiro,
      prefixIcon: Icon(icone, size: 30),
      prefixIconColor: Color.fromRGBO(204, 153, 0, 0.8),
    ),
    onChanged: function,
    keyboardType: TextInputType.numberWithOptions(decimal: true),
    inputFormatters: [
      TextInputFormatter.withFunction((oldValue, newValue) {
        final texto = newValue.text;

        if (RegExp(r'^\d*\.?\d*$').hasMatch(texto)) {
          return newValue;
        }

        return oldValue;
      }),
    ],
    // )
  );
}

Future<Map> getData() async {
  print('Começando requisições...');
  final responseUsdBrl = await http.get(Uri.parse(request_USD_BRL));
  print('USD/BRL: ${responseUsdBrl.statusCode}');

  final responseBrlEur = await http.get(Uri.parse(request_BRL_EUR));
  print('BRL/EUR: ${responseBrlEur.statusCode}');

  final responseUsdEur = await http.get(Uri.parse(request_USD_EUR));
  print('USD/EUR: ${responseUsdEur.statusCode}');

  final responseUsdIene = await http.get(Uri.parse(request_USD_IENE));

  return {
    'BrlEur': json.decode(responseBrlEur.body),
    'UsdBrl': json.decode(responseUsdBrl.body),
    'UsdEur': json.decode(responseUsdEur.body),
    'UsdIene': json.decode(responseUsdIene.body),
  };
}
