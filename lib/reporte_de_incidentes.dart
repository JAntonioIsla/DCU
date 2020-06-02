
import 'package:camera/camera.dart';
import 'package:dcu/camera_manager.dart';
import 'package:dcu/login.dart';
import 'package:dcu/photo_record.dart';
import 'package:dcu/texfields.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'levantamiento.dart';

class ReporteDeIncidentes extends StatefulWidget{

  @override
  _ReporteDeIncidentesState createState() => _ReporteDeIncidentesState();

}

class _ReporteDeIncidentesState extends State<ReporteDeIncidentes>{
  var description;
  var paths;

  var roundedShape;
  CameraDescription camera;

  @override
  void initState() {
    super.initState();
    print(entidad);
    print(edificio);
    print(nivel);
    print(espacio);
    camera = obtainCameraAtPosition(0);
    roundedShape = new RoundedRectangleBorder(
        borderRadius: new BorderRadius.circular(18.0),
        side: BorderSide(color: Colors.grey[50]));
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 30.0),
            child: Text('Reporte de incidentes',
              style: TextStyle(fontSize: 45.0,
                  fontWeight: FontWeight.w600,),
            ),),

          Card(
            margin: const EdgeInsets.symmetric(horizontal: 50.0),
            child: Container(
              alignment: Alignment.centerLeft,
              margin: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text('Descripción',
                    textAlign: TextAlign.start,
                    style: TextStyle(fontSize: 30.0, color: Colors.grey[600],
                      fontWeight: FontWeight.w600
                    ),
                  ),
                  Container(
                      height: 150.0,
                      margin: const EdgeInsets.only(left: 50.0, top: 20.0),
                      child: MultilineTextInputField(
                        onChanged: onMultilineTextChanged,
                        onSubmitted: onMultilineTextChanged,
                      )
                  )
                ],
              ),
            ),
            shape: roundedShape,
          ),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 40.0),
            child: Container(
              alignment: Alignment.centerLeft,
              margin: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text('Soporte fotográfico',
                    textAlign: TextAlign.start,
                    style: TextStyle(fontSize: 30.0, color: Colors.grey[600],
                      fontWeight: FontWeight.w600
                    ),
                  ),
                  Container(

                      margin: const EdgeInsets.only(left: 0.0, top: 20.0),
                      child: PhotoRecord(
                        onPictureHasBeenTaken: (picturePaths){
                          if(picturePaths != null && picturePaths != ''){
                            paths = picturePaths;
                          }
                        },
                        camera: camera,
                      )
                  ),
                ],
              ),
            ),
            shape: roundedShape,
          ),

          Container(
            margin: const EdgeInsets.only(top: 10.0, bottom: 50.0),
            alignment: Alignment.center,
            child: appButton(onPressed: (){
              print(entidad);
              print(edificio);
              print(nivel);
              print(espacio);
            }),
          )
        ],
      ),
    );
  }

  void onMultilineTextChanged(String value){
    setState(() {
      description = value;
    });
  }

}