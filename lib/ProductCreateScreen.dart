import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ProductCreateScreen extends StatefulWidget {
  ProductCreateScreen(this.code);
  final String code;
  @override
  _ProductCreateState createState() => new _ProductCreateState();

}
 
class _FormData {
  String code = "";
  String name = "";
  String price = "";
  DateTime date = DateTime.now();
}

class _ProductCreateState extends State<ProductCreateScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _FormData _data = _FormData();

  @override
  void initState() {
    super.initState();
    _data.code = widget.code;
  }
  @override
  Widget build(BuildContext context) => new Scaffold(
    appBar: new AppBar(title: new Text('商品作成(実装中)')),
    body: SafeArea(
      child: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20.0),
          children: <Widget>[
            TextFormField(
              decoration: const InputDecoration(
                icon: const Icon(Icons.code),
                hintText: 'コードs',
                labelText: 'コード',
              ),
              onSaved: (String value){
                _data.code = value;
              },
              validator: (value) {
                if (value.isEmpty) {
                  return '名前は必須入力項目です';
                }
              },
              //初期値
              initialValue: _data.name,
            ),
            TextFormField(
              decoration: const InputDecoration(
                icon: const Icon(Icons.person),
                hintText: '商品名',
                labelText: '名前',
              ),
              onSaved: (String value){
                _data.name = value;
              },
              validator: (value) {
                if (value.isEmpty) {
                  return '名前は必須入力項目です';
                }
              },
              //初期値
              initialValue: _data.name,
            ),
            TextFormField(
              decoration: const InputDecoration(
                icon: const Icon(Icons.card_travel),
                hintText: '金額',
                labelText: '金額',
              ),
              inputFormatters: <TextInputFormatter> [
                WhitelistingTextInputFormatter.digitsOnly,
              ],
          
              onSaved: (String value){
                _data.price = value;
              },
              validator: (value) {
                if (value.isEmpty) {
                  return '数値は必須入力項目です';
                }
              },
              //初期値
              initialValue: _data.price,
            ),
            RaisedButton(
                
                padding: EdgeInsets.all(20.0),
                color: Colors.lightBlue,
                onPressed: () {
                 if(_formKey.currentState.validate()) {
                   _formKey.currentState.save();
                   print('-----------');
                   print(_data);
                 }
                },
                child: Text('保存',style: TextStyle(
                  color: Colors.white
                ),),
              ),
          ],
        ),
      ),
    )
  );
}