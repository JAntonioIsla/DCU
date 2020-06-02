import 'dart:io';

import 'package:camera/camera.dart';
import 'package:dcu/camera_manager.dart';
import 'package:dcu/main.dart';
import 'package:dcu/main_menu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class PhotoRecord extends StatefulWidget{
  PhotoRecord({Key key,
    this.size,
    this.margin,
    this.onPictureHasBeenTaken,
    this.camera
  })
      : super(key:key);

  final double size;
  final EdgeInsetsGeometry margin;
  final ValueChanged<String> onPictureHasBeenTaken;
  final camera;

  @override
  _PhotoRecordState createState() => _PhotoRecordState();

}

class _PhotoRecordState extends State<PhotoRecord>{
  var buildContext;

  var _photoNameSize;
  var _sideIconSize;
  CameraController controller;
  Future<void> initializeControllerForCamera;
  List<String> paths;
  var returnedPicturePath;
  VoidCallback onPressed;

  Widget cameraPreview;
  bool displayPreview = false;

  @override
  void initState() {
    super.initState();
    onPressed = (){};
    paths = new List<String>();
    initializingCameraUsageVariables();
  }


  @override
  void dispose() {
    if(controller != null) controller.dispose();
    returnedPicturePath = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    buildContext = context;
    final _size = widget.size == null? 180.0 : widget.size;
    final _captureButtonSize = _size * 0.8;
    _sideIconSize = _captureButtonSize/3.2;
    _photoNameSize = _sideIconSize * 0.4;
    addPath();
    widget.onPictureHasBeenTaken(paths.toString());
    return Container(
      margin: widget.margin,
      child: Column(
        children: <Widget>[
          cameraPreview = displayPreview==false? Container() : displayCamerasPreview(initializeControllerForCamera, controller),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: ImageButton(
                  icon: 'icons/boton_capturar_Active.png',
                  hoverIcon: 'icons/boton_capturar_Hover.png',
                  onPressed: () {
                    if (displayPreview==false) {
                      setState(() => displayPreview = true);
                    } else {
                      onCameraButtonPressed(
                          context, initializeControllerForCamera, controller);
                      setState(() => displayPreview = false);
                    }
                  },
                  iconSize: _captureButtonSize,
                ),
              ),
              Container(
                height: _size,
                width: 1.0,
                color: Colors.grey[700],
              ),
              Expanded(
                flex: 2,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: _size/30.0),
                  height: _size,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: pathsOfTakedPictures(),
                    ),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );

  }

  void initializingCameraUsageVariables(){
    if(widget.camera != null){
      controller = obtainControllerForTheCamera(widget.camera, ResolutionPreset.high);
      initializeControllerForCamera = initializeCameraController(controller);
    }
  }

  List<Widget> pathsOfTakedPictures(){
    return paths.map<Widget>((String path) {
      if(path != null) {
        return photoNameShower(picturePath: path);
      }else return Container();

    }).toList();

  }

  String slicePathToGetThePictureName(String path){
    var pathSlices = path.split("/");
    return pathSlices.last;
  }

  void addPath(){
    if(!isThePathList(returnedPicturePath) && returnedPicturePath != null){
      paths.add(returnedPicturePath);
    }
  }

  bool isThePathList(String path){
    return paths != null ? paths.contains(path)
    : true;
  }

  Widget photoNameShower({String picturePath}){
    var text = slicePathToGetThePictureName(picturePath);
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5.0),
      child: RaisedButton(
        splashColor: hoverColor,
        color: Colors.transparent,
        elevation: 0.0,
        padding: EdgeInsets.zero,
        child: Row(
          children: <Widget>[
            Expanded(
              child: Image.asset('icons/nombre_foto.png',
                width: _sideIconSize,
                height: _sideIconSize,
              ),
            ),
            Expanded(
              flex: 3,
              child: Text(text,
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: _photoNameSize,
                  color: Colors.grey[700],
                ),
              ),
            )
          ],
        ),
        onPressed: (){
          imageDialog(picturePath);
        },
      ),
    );
  }

  void imageDialog(String picturePath){
    showDialog(
        context: buildContext,
        builder: (BuildContext buildContext){
          return Column(
            children: <Widget>[
              Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Container(
                  margin: EdgeInsets.all(10.0),
                  constraints: BoxConstraints(maxWidth: 630.0, maxHeight: 730.0),
                  child: Image.file(File(picturePath)),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0)
                  ),
                ),
              ),
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.only(top: 60.0),
                color: Colors.transparent,
                child: FloatingActionButton(
                  backgroundColor: Colors.red,
                  child: Icon(Icons.delete, color: Colors.white, size: 40.0,),
                  onPressed: (){
                    deleteFile(picturePath);
                  },
                ),
              )
            ],
          );
      }
    );
  }

  void deleteFile(String filePath) {
    final file = File(filePath);
    file.delete();
    setState(() => paths.remove(filePath));
    Navigator.pop(buildContext);
  }

  void onCameraButtonPressed(
      BuildContext context,
      Future<void> cameraInitialization,
      CameraController controller) async{
      // Take the Picture in a try / catch block. If anything goes wrong,
      // catch the error.
      try {
        // Ensure that the camera is initialized.
        await cameraInitialization;

        // Construct the path where the image should be saved using the path
        // package.
        var pictureName = 'DCU_${DateTime.now()}.png'
            .replaceAll("-", "")
            .replaceAll(".", "")
            .replaceAll("png", ".png")
            .replaceAll(":", "");
        final path = join(
          // Store the picture in the temp directory.
          // Find the temp directory using the `path_provider` plugin.
          (await getExternalStorageDirectories(type: StorageDirectory.pictures)).elementAt(0).path,
          pictureName,
        );

        // Attempt to take a picture and log where it's been saved.
        await controller.takePicture(path);
        setState(() => returnedPicturePath = path);
      } catch (e) {
        // If an error occurs, log the error to the console.
        print(e);
      }

  }

}