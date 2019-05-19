import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

// TODO CODE分割
class ProductCreateScreen extends StatefulWidget {
  ProductCreateScreen(this.code);
  final String code;
  @override
  _ProductCreateState createState() => new _ProductCreateState();

}
 

class _ProductCreateState extends State<ProductCreateScreen> {
  @override
  void initState() {
    super.initState();

  }
  @override
  Widget build(BuildContext context) => new Scaffold(
    appBar: new AppBar(title: new Text('商品作成(実装中)')),
    body: new Center(
      child: new Container(
        child: Card(
          child: Column(            
            children: <Widget>[
              Container(
                margin: EdgeInsets.all(10.0),
                child: TextFormField(
                  decoration: const InputDecoration(
                    icon: const Icon(Icons.card_travel),
                    hintText: 'code',
                    labelText: 'code',
                  ),
                  enabled: false,
                  // 初期値
                  initialValue: widget.code,
                ),
              ),
              Container(
                margin: EdgeInsets.all(10.0),
                child: TextFormField(
                  decoration: const InputDecoration(
                  icon: const Icon(Icons.perm_identity),
                  hintText: '商品名',
                  labelText: '商品名',
                  ),
                  initialValue: "",
                ),
              ),
              Container(
                margin: EdgeInsets.all(10.0),
                child: TextFormField(
                  decoration: const InputDecoration(
                  icon: const Icon(Icons.add_shopping_cart),
                  hintText: '金額',
                  labelText: '金額',
                  ),
                  initialValue: "0",
                ),
              ),
              Container(
                margin: EdgeInsets.all(10.0),
                child: FlatButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  ),
                  onPressed: (){
                    Fluttertoast.showToast(
                      msg: '実装中',
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIos: 1,
                      fontSize: 16.0
                    );
                  },
                  color: Colors.blue,
                  child: Text('保存'),
                ),
              ),
            ],
          ),
        ),
      ),
    )
  );
}