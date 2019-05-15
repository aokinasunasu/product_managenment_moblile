import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String url = 'http://192.168.100.20:8000//api/product';
  List data;
  Future<String> makeRequest() async {
    var response = await http
        .get(Uri.encodeFull(url), headers: {"Accept": "application/json"});

    setState(() {
      print(response);
      var extractdata = json.decode(response.body);
      print(extractdata);
      data = extractdata;
    });
  }

  Future _scanQR() async{
    try {
      String qrResult = await BarcodeScanner.scan();
      tostMessage(qrResult);
      setState(() {
        // result = qrResult;
        // qrResult.codeUnits;
        // listItem.add(qrResult);
      });
    } on PlatformException catch (ex) {
      // 不許可
      if(ex.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          tostMessage('Camera Permission was denisd');
        });
      } else {
        setState(() {
          tostMessage('Unknown Error $ex');
        });
      }
    } on FormatException {
      setState(() {
        tostMessage('読み取り形式エラー');
      });
    } catch (ex) {
      setState(() {
        tostMessage('Unknown Error $ex');
      });
    }
  }

  void tostMessage(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIos: 1,
      fontSize: 16.0
    );
  }

  @override
  void initState() {
    this.makeRequest();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('商品リスト'),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.search), onPressed: () {
            tostMessage('not implemented');
          },)
        ],
      ),
      body: new ListView.builder(
        itemCount: data == null ? 0 : data.length,
        itemBuilder: (BuildContext context, i) {
          return Container(
            decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.black38),
                ),
              ),
            child: ListTile(
              title: new Text(data[i]["name"]),
              subtitle: new Text('code:' + data[i]["code"] + ' ' +'値段:' + data[i]["unit_selling_price"] + '円'),
              onTap: () {
                Navigator.push(
                context,
                new MaterialPageRoute(
                builder: (BuildContext context) =>
                new SecondPage(data[i])));
              },
            ),
          );
        }
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon:Icon(Icons.camera_alt),
        label: Text("Scan"),
        onPressed: _scanQR,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class SecondPage extends StatelessWidget {
  SecondPage(this.data);
  final data;
  @override
  Widget build(BuildContext context) => new Scaffold(
    appBar: new AppBar(title: new Text('商品詳細ページ')),
    body: new Center(
      child: new Container(
        child: Card(
          child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.all(10.0),
                child: ListTile(
                  title: Text(data['code']),
                  leading: Icon(Icons.card_travel),
                ),
              ),
              Container(
                margin: EdgeInsets.all(10.0),
                child: ListTile(
                  title: Text(data['name']),
                  leading: Icon(Icons.perm_identity),
                ),
              ),
              Container(
                margin: EdgeInsets.all(10.0),
                child: ListTile(
                  title: Text(data['unit_selling_price'] + '円'),
                  leading: Icon(Icons.add_shopping_cart),
                ),
              ),
              Container(
                margin: EdgeInsets.all(10.0),
                child: ListTile(
                  title: Text(data['created_at']),
                  leading: Icon(Icons.create),
                ),
              ),
              Container(
                margin: EdgeInsets.all(10.0),
                child: ListTile(
                  title: Text(data['created_at']),
                  leading: Icon(Icons.update),
                ),
              ),
            ],
          ),
        ),
      ),
    )
  );
}