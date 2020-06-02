
import 'package:dcu/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';

const _accessButtonColor = Color(0xFF999999);
const _textColor = Color(0xFF666666);
const _textSize = 24.0;

class Login extends StatefulWidget{
  @override
  LoginState createState() => LoginState();

}

class LoginState extends State<Login>{
  final _principalContainerRadius = Radius.circular(80.0);
  final _bootomPadding = const EdgeInsets.only(bottom: 60.0);
  final _padding = const EdgeInsets.all(16.0);
  final _paddingColumn = const EdgeInsets.only(top: 100.0, left: 120.0, right:  120.0);
  final _paddingIcon = const EdgeInsets.only(bottom: 30.0, top: 20.0);
  final _paddingAccessButton = const EdgeInsets.only(top: 50.0, left: 60.0, right: 60.0);

  final _textInputBorder = UnderlineInputBorder(
      borderSide: BorderSide(color: accentColor, width: 3.0,)
  );

  final _loginInputStyle = TextStyle(
    color: _textColor,
    fontSize: _textSize,
  );

  String _userValue = '';
  String _passValue = '';

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: SafeArea(
        child: Scaffold(
          body: Container(
            child: Container(
              child: Center(
                child: Padding(
                  padding: _padding,
                  child: Container(
                    margin: _paddingColumn,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Container(
                            margin: _paddingIcon,
                            child: AspectRatio(
                              child: Image.asset(
                                'icons/login_icon.png',
                              ),
                              aspectRatio: 2.0,
                            ),
                          ),
                          Container(
                            margin: _paddingIcon,
                            child: TextField(
                              textAlign: TextAlign.center,
                              style: _loginInputStyle,
                              decoration: InputDecoration(
                                hintStyle: Theme.of(context).textTheme.display1,
                                hintText: 'email',
                                focusedBorder: _textInputBorder,
                                enabledBorder: _textInputBorder,
                                border: _textInputBorder,
                              ),
                              // Since we only want numerical input, we use a number keyboard. There
                              // are also other keyboards for dates, emails, phone numbers, etc.
                              keyboardType: TextInputType.emailAddress,
                              onChanged: _updateUserValue,
                            ),
                          ),
                          Container(
                            margin: _paddingIcon,
                            child: TextField(
                              obscureText: true,
                              textAlign: TextAlign.center,
                              style: _loginInputStyle,
                              decoration: InputDecoration(
                                hintStyle: Theme.of(context).textTheme.display1,
                                hintText: 'contraseña',
                                focusedBorder: _textInputBorder,
                                enabledBorder: _textInputBorder,
                                border: _textInputBorder,
                              ),
                              // Since we only want numerical input, we use a number keyboard. There
                              // are also other keyboards for dates, emails, phone numbers, etc.
                              keyboardType: TextInputType.visiblePassword,
                              onChanged: _updatePassValue,
                            ),
                          ),
                          Container(
                              margin: _paddingAccessButton,
                              child: appButton(text:'Acceder', onPressed: _access)
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              margin: _bootomPadding,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(bottomLeft: _principalContainerRadius, bottomRight: _principalContainerRadius),
                color: Colors.white,
                boxShadow: <BoxShadow>[BoxShadow(blurRadius: 8.0, spreadRadius: 0.0)],
              ),
            ),
            color: accentColor,
          ),
        ),
      ),
    );
  }

  void _updateUserValue(String newUserValue){
    setState(() {
      _userValue = newUserValue;
      print(_userValue);
    });
  }

  void _updatePassValue(String newPasswordValue){
    setState(() {
      _passValue = newPasswordValue;
      print(_passValue);
    });
  }

  void _access(){
    Navigator.popAndPushNamed(context, '/menu');
  }

}

RaisedButton appButton({String text, VoidCallback onPressed,
  Color aHoverColor = hoverColor,
  Color buttonColor = _accessButtonColor
}){
  return RaisedButton(
    shape: new RoundedRectangleBorder(
        borderRadius: new BorderRadius.circular(18.0),

    ),
    onPressed: onPressed,
    color: buttonColor,
    hoverColor: aHoverColor,
    focusColor: hoverColor,
    highlightColor: aHoverColor,
    textColor: Colors.white,
    child: Text(text == null? 'Guardar' : text,
        style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
  );
}