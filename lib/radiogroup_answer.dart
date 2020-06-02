import 'package:dcu/main.dart';
import 'package:dcu/texfields.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const String OTRO = 'OTRO';
const String OTRA = 'OTRA';
const String OTROS = 'OTROS';
const String OTRAS = 'OTRAS';
const List<String> selectableDefaultValues = <String>[''];
class RadiogroupAnswer extends StatefulWidget{
  RadiogroupAnswer({Key key,
    this.selectableValues = selectableDefaultValues,
    @required this.onChanged})
      : super(key:key);
  final List<String> selectableValues;
  final ValueChanged<String> onChanged;
  @override
  _RadiogroupAnswerState createState() => _RadiogroupAnswerState();

}

class _RadiogroupAnswerState extends State<RadiogroupAnswer>{

  Column column1;
  Column column2;
  List<Widget> widgets1;
  List<Widget> widgets2;
  String gropuValue;

  bool groupOtro;
  bool groupOtra;
  bool groupOtros;
  bool groupOtras;
  bool groupValueIsOtro;

  @override
  void initState() {
    widgets1 = new List<Widget>();
    widgets2 = new List<Widget>();
    widget.selectableValues == null? gropuValue = ''
        : gropuValue = widget.selectableValues[0];
    otroToggle();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    otroToggle();
    asignWidgets();
    return Table(
      children: <TableRow>[
        TableRow(
          children: <Widget>[
            column1,column2,
          ],
        )
      ],
    );
  }

  void asignWidgets(){
    try {
      if(widget.selectableValues!= null && widget.selectableValues.length >= 2){
        for (int elementIndex = 0;
        elementIndex < widget.selectableValues.length;
        elementIndex++) {
          if ((widgets1.length + widgets2.length) <
              widget.selectableValues.length) {
            if (elementIndex % 2 == 0) {
              widgets1.add(radio(widget.selectableValues[elementIndex]));
            } else {
              widgets2.add(radio(widget.selectableValues[elementIndex]));
            }
          } else {
            if (elementIndex % 2 == 0) {
              int startIndex = (elementIndex / 2).round();
              int endIndex = startIndex + 1;
              widgets1.replaceRange(startIndex, endIndex,
                  <Widget>[radio(widget.selectableValues[elementIndex])]);
            } else {
              int endIndex = (elementIndex / 2).round();
              int startIndex = endIndex - 1;
              widgets2.replaceRange(startIndex, endIndex,
                  <Widget>[radio(widget.selectableValues[elementIndex])]);
            }
          }
        }
      }else{
        widgets1 = <Widget>[];
        widgets2 = <Widget>[];
      }
    }on Exception{
      widgets1 = <Widget>[];
      widgets2 = <Widget>[];
    }
    column1 = Column(crossAxisAlignment: CrossAxisAlignment.start,children: widgets1,);
    column2 = Column(crossAxisAlignment: CrossAxisAlignment.start,children: widgets2,);
  }

  Widget radio(String value){

    bool otro = value == OTRO || value == 'Otro' || value == OTRO.toUpperCase() || value == OTRO.toLowerCase();
    bool otra = value == OTRA || value == 'Otra' || value == OTRA.toUpperCase() || value == OTRA.toLowerCase();
    bool otros = value == OTROS || value == 'Otros' || value == OTROS.toUpperCase() || value == OTROS.toLowerCase();
    bool otras = value == OTRAS || value == 'Otras' || value == OTRAS.toUpperCase() || value == OTRAS.toLowerCase();
    bool valueIsOtro = otro || otra || otros || otras;
    if(valueIsOtro){
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          RadioListTile<String>(
              value: value,
              groupValue: gropuValue,
              title: Text(value, style: TextStyle(fontSize: 28.0,color: hoverColor),),
              onChanged: (selectedValue){
                setState(() {
                  gropuValue = selectedValue;
                });
              }
          ),
          Container(
            margin: const EdgeInsets.only(left: 60.0),
              child: groupValueIsOtro?TextInputField(
                labelText: 'Especificar',
                onChanged: (value){
                  widget.onChanged(gropuValue + ': ' + value);
                },
                onSubmitted: (value){
                  widget.onChanged(gropuValue + ': ' + value);
                },
              ):null)
        ],
      );
    }else{
      return RadioListTile<String>(
          value: value,
          groupValue: gropuValue,
          title: Text(value, style: TextStyle(fontSize: 28.0,color: hoverColor),),
          onChanged: (selectedValue){
            setState(() {
              gropuValue = selectedValue;
            });
            widget.onChanged(selectedValue);
          }
      );
    }

  }

  void otroToggle(){
    groupOtro = gropuValue == OTRO || gropuValue == 'Otro' || gropuValue == OTRO.toUpperCase() || gropuValue == OTRO.toLowerCase();
    groupOtra = gropuValue == OTRA || gropuValue == 'Otra' || gropuValue == OTRA.toUpperCase() || gropuValue == OTRA.toLowerCase();
    groupOtros = gropuValue == OTROS || gropuValue == 'Otros' || gropuValue == OTROS.toUpperCase() || gropuValue == OTROS.toLowerCase();
    groupOtras = gropuValue == OTRAS || gropuValue == 'Otras' || gropuValue == OTRAS.toUpperCase() || gropuValue == OTRAS.toLowerCase();
    groupValueIsOtro = groupOtro || groupOtra || groupOtros || groupOtras;
  }

}