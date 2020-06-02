import 'dart:async';
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

List<CameraDescription> cameras;


void ensureThatPluginServicesAreInitialized() => WidgetsFlutterBinding.ensureInitialized();

FutureOr<void> obtainListOfAvailableCamerasOnTheDivice() async{
 cameras = await availableCameras();
}


CameraDescription obtainCameraAtPosition(int cameraPosition){
  ensureThatPluginServicesAreInitialized();
  obtainListOfAvailableCamerasOnTheDivice();
  return cameras != null? cameras.elementAt(cameraPosition)
      : null;
}

CameraController obtainControllerForTheCamera(CameraDescription camera, ResolutionPreset resolution){
  return  CameraController(
      camera,
      resolution
  );
}

Future<void> initializeCameraController(CameraController controller){
  return controller.initialize();
}

FutureBuilder<void> displayCamerasPreview(Future<void> future, CameraController controller){
  return FutureBuilder<void>(
    future: future,
    builder: (context, snapshot){
      if(snapshot.connectionState == ConnectionState.done){
        return Container(
          margin: EdgeInsets.only(bottom: 30.0),
          constraints: BoxConstraints(maxHeight: 600.0, maxWidth: 500.0),
          child: CameraPreview(controller),
          decoration: BoxDecoration(
              boxShadow: <BoxShadow>[BoxShadow(blurRadius: 8.0, spreadRadius: 0.0)],

              color: Colors.white
          ),
        );
      }else {
        return Center(child: CircularProgressIndicator(),);
      }
    },
  );
}

