import 'package:dcu/lienzo_para_formato.dart';
import 'package:dcu/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ToogleGroup extends StatefulWidget{ // ignore: must_be_immutable

  ToogleGroup({Key key,@required this.onChanged,
    this.affirmativeValue,
    this.negativeValue
  })
      : super(key:key);
  List<String> items;
  ValueChanged<String> onChanged;
  String affirmativeValue;
  String negativeValue;
  bool selected;
  String value;

  @override
  _ToogleGroupState createState() => _ToogleGroupState();

}

class _ToogleGroupState extends State<ToogleGroup>{
  var selectedState;
  var selectedValue;
  @override
  Widget build(BuildContext context) {
    setState(() {
      widget.selected = selectedState;
      widget.value = selectedValue;
    });
    Row row;
    row = Row(children: <Widget>[
      Expanded(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal:20.0),
          child: RaisedButton(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical:2.0),
              child: Text(widget.affirmativeValue == null? SI : widget.affirmativeValue,
                style: TextStyle(
                    fontSize: 32.0,
                    color: Colors.white,
                    fontWeight: FontWeight.w600
                ),
              ),
            ),
            onPressed: (){
              setState(() {
                widget.value = widget.affirmativeValue == null? SI : widget.affirmativeValue;
                selectedValue = widget.value;
                widget.selected = true;
                selectedState = widget.selected;
              });
              widget.onChanged(widget.value);
            },
            color:affirmativeButtonColor(),),
        ),
      ),
      Expanded(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal:20.0),
          child: RaisedButton(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical:2.0),
              child: Text(widget.negativeValue == null? NO : widget.negativeValue,
                style: TextStyle(
                    fontSize: 32.0,
                    color: Colors.white,
                    fontWeight: FontWeight.w600
                ),
              ),
            ),
            onPressed: (){
              setState(() {
                widget.value = widget.negativeValue == null? NO : widget.negativeValue;
                selectedValue = widget.value;
                widget.selected = false;
                selectedState = widget.selected;
              });
              widget.onChanged(widget.value);
            },
            color: negativeButtonColor(),),
        ),
      ),
    ],);
    return row;
  }

  @override
  void initState() {
    widget.affirmativeValue = SI;
    widget.negativeValue = NO;
    widget.selected = null;
    super.initState();
  }

  Color affirmativeButtonColor(){
    return widget.selected == true && widget.value == widget.affirmativeValue? accentColor : hoverColor;
  }
  Color negativeButtonColor(){
    return widget.selected == false  && widget.value == widget.negativeValue? accentColor : hoverColor;
  }


}