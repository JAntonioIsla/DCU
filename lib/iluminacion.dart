import 'dart:math';

import 'package:camera/camera.dart';
import 'package:dcu/camera_manager.dart';
import 'package:dcu/growing_table.dart';
import 'package:dcu/levantamiento.dart';
import 'package:dcu/login.dart';
import 'package:dcu/main.dart';
import 'package:dcu/texfields.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

const String SALON = 'Salón';
const String PASILLO = 'Pasillo';

class Iluminacion extends StatefulWidget{

  @override
  _IluminacionState createState() => _IluminacionState();

}

class _IluminacionState extends State<Iluminacion> {
  var description;
  var paths;

  var roundedShape;
  CameraDescription camera;

  var groupValue;
  List<String> measures;

  var alto;
  var largo;
  var ancho;
  var luzDirecta;
  var reflejo;

  var generarMatriz = false;

  @override
  void initState() {
    super.initState();
    camera = obtainCameraAtPosition(0);
    roundedShape = new RoundedRectangleBorder(
        borderRadius: new BorderRadius.circular(18.0),
        side: BorderSide(color: Colors.grey[50]));
    groupValue = '';
    measures = new List<String>();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(
                    left: 50.0, right: 50.0, top: 30.0),
                child: Text('Iluminación',
                  style: TextStyle(fontSize: 45.0,
                    fontWeight: FontWeight.w600,),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(
                    left: 50.0, right: 50.0, bottom: 30.0),
                child: Text(ESPACIO,
                  style: TextStyle(fontSize: 35.0,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[700]
                  ),
                ),
              ),
              Card(
                margin: const EdgeInsets.symmetric(horizontal: 50.0),
                child: Container(
                  alignment: Alignment.centerLeft,
                  margin: const EdgeInsets.symmetric(
                      horizontal: 40.0, vertical: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      RadioListTile(
                        value: SALON,
                        groupValue: groupValue,
                        title: Text(SALON,
                          textAlign: TextAlign.start,
                          style: TextStyle(fontSize: 30.0, color: hoverColor,
                            fontWeight: groupValue == SALON? FontWeight.w600 : FontWeight.normal,
                          ),
                        ),
                        onChanged: groupValueChanged,
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 30.0),
                        child: Column(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Expanded(child: verticalMeasureInput(tag:'Alto', onChanged: (text){setState(() => alto = text);})),
                                Expanded(child: verticalMeasureInput(tag:'Ancho', onChanged: (text){setState(() => ancho = text);})),
                                Expanded(child: verticalMeasureInput(tag:'Largo', onChanged: (text){setState(() => largo = text);})),
                              ],
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 30.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Expanded(flex: 14,child: horizontalMeasureInput(tag: 'Luz directa', onChanged: (text){
                                    setState(() => luzDirecta = text);
                                  })),
                                  Expanded(flex: 12,child: horizontalMeasureInput(tag: 'Reflejo', onChanged: (text){
                                    setState(() => reflejo = text);
                                  }))
                                ],
                              ),
                            ),
                            groupValue == SALON? Padding(
                              padding: const EdgeInsets.only(top: 35.0, bottom: 10.0),
                              child: appButton(text: 'Generar', onPressed: (){
                                var height = double.tryParse(alto);
                                var width = double.tryParse(ancho);
                                var length = double.tryParse(largo);

                                var validNumbers = height != null && width != null && length != null;

                                if(validNumbers) setState(() => generarMatriz = true);

                              }),
                            ) : Container(),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                shape: roundedShape,
              ),

            ],
          ),
        ),
        SliverList(delegate:
        SliverChildListDelegate([
          Container(
            child: Row(
              children: <Widget>[
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          matrixOfMeasures()
                        ],
                      ),
                  )
                ),
              ],
            ),
          )
        ]
        )
        ),
        SliverToBoxAdapter(
          child: Column(
            children: <Widget>[
              Card(
                margin: const EdgeInsets.symmetric(
                    horizontal: 50.0, vertical: 40.0),
                child: Container(
                  alignment: Alignment.centerLeft,
                  margin: const EdgeInsets.symmetric(
                      horizontal: 50.0, vertical: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      RadioListTile(
                        value: PASILLO,
                        groupValue: groupValue,
                        title: Text(PASILLO,
                          textAlign: TextAlign.start,
                          style: TextStyle(fontSize: 30.0, color: hoverColor,
                            fontWeight: groupValue == PASILLO? FontWeight.w600 : FontWeight.normal,
                          ),
                        ),
                        onChanged: groupValueChanged,
                      ),
                      groupValue == PASILLO? Container(
                        margin: EdgeInsets.only(top: 20.0, bottom: 20.0, left: 50.0, right: 150.0),
                        child: GrowingTable(
                          initialNumberOfRows: 3,
                          onChanged: measureUpdate,
                          onSubmitted: measureUpdate,
                          textPrefix: 'Measure ',
                          onIncreasePressed: increaseNumberOfMeasures,
                          onDecreasePressed: decreaseNumberOfMeasures,
                        ),
                      ) : Container(),
                    ],
                  ),
                ),
                shape: roundedShape,
              ),
              Container(
                margin: const EdgeInsets.only(top: 10.0, bottom: 50.0),
                alignment: Alignment.center,
                child: appButton(onPressed: () {}),
              )
            ],
          ),
        )
      ],
    );
  }

  void groupValueChanged(dynamic changedValue){
    setState(() {
      groupValue = changedValue;
      onPasilloSelected(changedValue);
    });
  }

  void onPasilloSelected(dynamic changedValue){
    if(changedValue == PASILLO){
      generarMatriz = false;
      measures.clear();
      measures.addAll(<String>['','','']);
    }

  }


  Widget verticalMeasureInput({String tag, ValueChanged<String> onChanged }){
    final textBoldStyle = TextStyle(fontSize: 25.0, fontWeight: FontWeight.w600, color: Colors.grey[600]);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
                margin: EdgeInsets.only(left: 50.0),
                child: Text(tag, style: textBoldStyle, textAlign: TextAlign.center,)),
          ],
        ),
        NumericTextField(onChanged: onChanged, numericIcon: false,)
      ],
    );
  }

  Widget horizontalMeasureInput({String tag, ValueChanged<String> onChanged}){
    final measureTextStyle = TextStyle(fontSize: 25.0, fontWeight: FontWeight.normal, color: Colors.grey[600]);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(margin: EdgeInsets.only(left: 40.0, right: 10.0),
            child: Text(tag, style: measureTextStyle,)
        ),
        Expanded(
            child: NumericTextField(
              width: '',
              onChanged: onChanged, numericIcon: false,)
        )
      ],
    );
  }

  void measureUpdate(String measure, int measureIndex){
    measures.removeAt(measureIndex);
    measures.insert(measureIndex, measure);
    print(measures);
  }

  void increaseNumberOfMeasures(){
    setState(() {
      measures.add('');
    });
  }

  void decreaseNumberOfMeasures(){
    setState(() {
      measures.removeLast();
    });
  }
  
  Widget matrixOfMeasures(){
    if (generarMatriz == true) {
      var rowElements = rowSize();
      var tableWidth = rowElements * 315.0;
      return Card(
        margin: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 30.0),
        shape: roundedShape,
        child: Container(
          constraints: BoxConstraints(minWidth: tableWidth),
          margin: EdgeInsets.only(top: 30.0, bottom: 30.0, right: 40.0),
          child: Table(
          children: rowsForTheMeasureMatrix(),
    ),
        ),
      );
    } else {
      return Container();
    }
  }
  
  List<TableRow> rowsForTheMeasureMatrix(){
    var sizeOfRows = rowSize();
    measures.clear();
    if(sizeOfRows != null) {
      return List<TableRow>.generate(sizeOfRows, (rowIndex) {
        var measureWidgets = List<Widget>.generate(sizeOfRows, (columnIndex) {
          var entryNumber = (columnIndex + 1) + (sizeOfRows * rowIndex);
          measures.add('');
          return verticalMeasureInput(tag: 'Medición $entryNumber',
              onChanged: (measure) {
                measureUpdate(measure, entryNumber - 1);
              });
        });

        return TableRow(
          children: measureWidgets,
        );
      });
    }else{
      return List<TableRow>();
    }
  }
  
  double roomIndex(){
    var height = double.tryParse(alto);
    var width = double.tryParse(ancho);
    var length = double.tryParse(largo);

    var validNumbers = height != null && width != null && length != null;

    return validNumbers ? (width*length)/(height*(width+length)) : null;
  }



  int numberOfMeasuresToApply(){
    var rowSizeNumber = rowSize();
    return rowSizeNumber != null? pow(rowSize(),2) : null;
  }

  int rowSize(){
    var roomIndexNumber = roomIndex();
    int roomIndexCeil = roomIndexNumber != null? roomIndexNumber.ceil(): null;
    return roomIndexCeil != null? roomIndexCeil + 1 : 0;
  }

}

typedef TwoParamsCallback<T,V> = void Function(T stringValue,V intValue);

List<TableRow> generateTableInputs({
  int numberOfMeasures,
  TwoParamsCallback<String, int> onChanged,
  TwoParamsCallback<String, int> onSubmitted,
  String textPrefix,
  TextInputType keyboardType
}){
  return List<TableRow>.generate(numberOfMeasures, (measureIndex){

    List<Widget> rowWidgets = new List<Widget>();
    var measureText = measureIndex + 1;
    rowWidgets.add(Text('$textPrefix$measureText',
      style: TextStyle(fontSize: 20.0, color: Colors.grey[600]),
      textAlign: TextAlign.center,
    ));
    rowWidgets.add(
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: NumericTextField(numericIcon: false, width: "",
            onChanged: (value){
            onChanged(value, measureIndex);
            },
            onSubmitted:  (value){
              onSubmitted(value, measureIndex);
            },
            keyboardType: keyboardType,
          ),
        ));
    return TableRow(
      children: rowWidgets,
    );
  });
}