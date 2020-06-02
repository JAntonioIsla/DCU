import 'package:flutter/material.dart';
import 'login.dart';
const double imageIconSize = 25.0;

const String SI = 'Sí';
const String NO = 'No';
class FormLayout extends StatelessWidget{
  FormLayout({Key key,@required this.children, @required this.onTap}) : super(key:key);
  final List<Widget> children;
  final VoidCallback onTap;

  final _paddingSaveButton = const EdgeInsets.only(top: 50.0, left: 60.0, right: 60.0);
  final _formBodyPadding = const EdgeInsets.all(50.0);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: _formBodyPadding,
      child: Column(
        children: <Widget>[
          Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: this.children,
            ),
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(18.0),
                side: BorderSide(color: Colors.grey[50])),
          ),
          Container(
              margin: _paddingSaveButton,
              child: appButton(onPressed: this.onTap)
          ),
        ],
      ),
    );
  }

}
Widget answerContainer({Widget child, dynamic width = 250.0}){
  var leftMargin = 50.0;
  if(width == ''){
    width = null;
    leftMargin = 0.0;
  }
  return Container(
    width: width,
    margin: EdgeInsets.only(left: leftMargin),
    child: child,
    decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: new BorderRadius.circular(5.0)),
  );
}