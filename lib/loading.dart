import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'invoice.dart';

import 'invoice.dart';
import 'main_page.dart';
class Loading extends StatefulWidget {
  @override
  _LoadingState createState() => _LoadingState();
}
void fetchInvoices(BuildContext context) async{
  http.Response response = await http.get('https://jsonkeeper.com/b/K8P7');
  List<Invoice> _invoices = [];
  if(response.statusCode == 200) {
    var jsonArray = jsonDecode(response.body)['invoices'] as List;
    _invoices = jsonArray.map((e) => Invoice.fromJson(e)).toList();
  }
  Navigator.pushReplacement(context,
      MaterialPageRoute(builder: (context) => MainPage(_invoices),));

}

class _LoadingState extends State<Loading> {
  @override
  void initState() {
    super.initState();
    fetchInvoices(context);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Center(
          child: SpinKitPouringHourglass(
            color: Colors.white,
            size: 50.0,
          )
      ),
    );
  }
}
