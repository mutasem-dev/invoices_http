import 'dart:convert';
import 'package:flutter/material.dart';
import 'all_invoices_page.dart';
import 'invoice.dart';
import 'product.dart';
import 'product_list_item.dart';
import 'package:toast/toast.dart';
class MainPage extends StatefulWidget {
  final List<Invoice> invoices;

  MainPage(this.invoices);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  _showDialog(BuildContext context) {
    showDialog(
        context: context,
      builder: (context) {
        TextEditingController nameController = TextEditingController();
        TextEditingController quantityController = TextEditingController();
        TextEditingController priceController = TextEditingController();
        return AlertDialog(

          title: Text('Product Info'),
          content: Container(
            height: 130,
            child: ListView(
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                      hintText: 'Product Name'
                  ),
                ),
                TextField(
                  controller: quantityController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      hintText: 'Quantity'
                  ),
                ),
                TextField(
                  controller: priceController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      hintText: 'Price'
                  ),
                ),
              ],
            ),
          ),
          actions: [
            RaisedButton(
              child: Text('add'),
                onPressed: () {
                  products.add(Product(
                    pname: nameController.text,
                    quantity: int.parse(quantityController.text),
                    price: double.parse(priceController.text)
                  ));
                  Navigator.of(context).pop();
                  setState(() {

                  });

                }
            ),
            RaisedButton(
                child: Text('cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                }
            ),
          ],
        );
      },
    );
  }

  int invoiceNo = 1;
  List<Product> products = [];
  TextEditingController cnameController = TextEditingController();
  @override
  void initState() {
    super.initState();
    if(widget.invoices.isNotEmpty)
      invoiceNo = widget.invoices[widget.invoices.length-1].invoiceNo+1;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Invoice#: $invoiceNo"),
      ),
      body: Column(
        children: [
          TextField(
            controller: cnameController,
            decoration: InputDecoration(
              labelText: 'Customer Name'
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text('Products: '),
              RaisedButton(
                child: Text('add product'),
                  onPressed: () {
                    _showDialog(context);
                  }
              ),
            ],
          ),
          Expanded(
              child: ListView.builder(
                itemCount: products.length,
                  itemBuilder: (context, index) {
                     return ProductListItem(
                       product: products[index],
                         deleteProduct: () {
                           products.removeAt(index);
                           setState(() {

                           });
                         },
                     );
                  },
              ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              RaisedButton(
                  child: Text('add invoice'),
                  onPressed: () {
                    if(cnameController.text.isEmpty ) {
                      Toast.show("please enter customer name", context);
                      return;
                    }
                    if(products.isEmpty) {
                      Toast.show("please add at least one product", context);
                      return;
                    }
                    widget.invoices.add(Invoice(
                      invoiceNo: invoiceNo,
                      customerName: cnameController.text,
                      products: products
                    ));
                    setState(() {
                      invoiceNo++;
                      cnameController.clear();
                      products = [];
                    });
                  }
              ),
              RaisedButton(
                  child: Text('show all invoices'),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => AllInvoicesPage(widget.invoices),));
                  }
              ),
            ],
          ),
        ],
      ),
    );
  }
}
