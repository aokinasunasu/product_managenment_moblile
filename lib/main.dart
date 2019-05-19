import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';
import 'package:product_managenment_moblile/ProductCreateScreen.dart';

void main() => runApp(new MyApp());
final String baseUrl = 'http://192.168.11.3:8000';

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
  // String makeUrl = ba;

  List data;
  Future makeRequest() async {
    var response = await http
        .get(Uri.encodeFull(baseUrl + '/api/product'), headers: {"Accept": "application/json"});

    setState(() {
      print(response);
      var extractdata = json.decode(response.body);
      print(extractdata);
      data = extractdata;
    });
  }

  Future codeRequest(String code) async {
    var response = await http
      .get(Uri.encodeFull(baseUrl + '/api/product/code/show?code=' + code), headers: {"Accept": "application/json"});
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      Navigator.push(
        context,
        new MaterialPageRoute(
        builder: (BuildContext context) =>
        new ProductShowPage(data)));
    } else if (response.statusCode == 404) {
      tostMessage('商品が見つかりません');
      Navigator.push(
        context, 
        MaterialPageRoute(builder: (context) => ProductCreateScreen(code)),
      );
    }
  }

  Future _scanQR() async {
    try {
      String qrResult = await BarcodeScanner.scan();
      tostMessage(qrResult);
      codeRequest(qrResult);
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
          IconButton(icon: Icon(Icons.add), onPressed: () {
            String code = "";
            Navigator.push(
            context,
            new MaterialPageRoute(
            builder: (BuildContext context) =>
            new ProductCreateScreen(code)));
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
                new ProductShowPage(data[i])));
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

class ProductShowPage extends StatelessWidget {
  ProductShowPage(this.data);
  final data;
  @override
  Widget build(BuildContext context) => new Scaffold(
    appBar: new AppBar(title: new Text('商品詳細ページ')),
    body: new Center(
      child: new SingleChildScrollView(
        child: Card(
          child: Column(            
            children: <Widget>[
              Image.network(baseUrl + '/storage/' + data['picture']),
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
                  title: Text(data['updated_at']),
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

