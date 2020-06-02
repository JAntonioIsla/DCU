import 'dart:convert';

import 'package:dcu/chip_group.dart';
import 'package:dcu/data_model_categoria.dart';
import 'package:dcu/data_model_edificio.dart';
import 'package:dcu/data_model_entidad.dart';
import 'package:dcu/data_model_espacio.dart';
import 'package:dcu/data_model_formulario.dart';
import 'package:dcu/data_model_informacion_del_formulario.dart';
import 'package:dcu/data_model_nivel.dart';
import 'package:dcu/database_manager.dart';
import 'package:dcu/httpRequests.dart';
import 'package:dcu/levantamiento.dart';
import 'package:dcu/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class MainMenu extends StatelessWidget{

  final _cardPadding = const EdgeInsets.symmetric(horizontal: 60.0, vertical: 50.0);
  final _buttonRowPadding = const EdgeInsets.symmetric(vertical: 65.0);
  final _cardElevation = 5.0;

  @override
  Widget build(BuildContext context) {
   return WillPopScope(
     onWillPop: () async => false,
     child: SafeArea(
       child: Scaffold(
         backgroundColor: Colors.white,
         appBar: AppBar(
           elevation: 0.0,
         ),
         drawer: navigationMenu(),
         drawerScrimColor: Colors.transparent,
         body: SingleChildScrollView(
           child: Column(
             crossAxisAlignment: CrossAxisAlignment.center,
             children: <Widget>[
               Card(
                 shape: new RoundedRectangleBorder(
                     borderRadius: new BorderRadius.circular(18.0),
                     side: BorderSide(color: Colors.white)),
                 elevation: _cardElevation,
                 margin: _cardPadding,
                 child: Container(
                   margin: _buttonRowPadding,
                   child: Row(
                     mainAxisAlignment: MainAxisAlignment.center,
                     children: <Widget>[
                       ImageButton(
                         icon: 'icons/levantamiento_Active.png',
                         hoverIcon: 'icons/levantamiento_Hover.png',
                         onPressed: (){goTo(context, LEVANTAMIENTO);},
                       ),
                       ImageButton(
                         icon: 'icons/consulta_Active.png',
                         hoverIcon: 'icons/consulta_Hover.png',
                         onPressed: (){},
                       ),
                       ImageButton(
                         icon: 'icons/reconocimiento_Active.png',
                         hoverIcon: 'icons/reconocimiento_Hover.png',
                         onPressed: (){},
                       ),
                     ],
                   ),
                 ),
               ),
               Card(
                 shape: new RoundedRectangleBorder(
                     borderRadius: new BorderRadius.circular(18.0),
                     side: BorderSide(color: Colors.white)),
                 elevation: _cardElevation,
                 margin: _cardPadding,
                 child: Container(
                   margin: _buttonRowPadding,
                   child: Row(
                     mainAxisAlignment: MainAxisAlignment.center,
                     children: <Widget>[
                       Expanded(
                         child: ImageButton(
                           icon: 'icons/iluminacion_Active.png',
                           hoverIcon: 'icons/iluminacion_Hover.png',
                           onPressed: (){},
                         ),
                       ),
                       Container(height: 250.0, width: 1.0, color: Colors.black,),
                       Expanded(
                         child: ImageButton(
                           icon: 'icons/incidentes_Active.png',
                           hoverIcon: 'icons/incidentes_Active.png',
                           onPressed: (){},
                         ),
                       ),
                     ],
                   ),
                 ),
               ),
               Padding(
                 padding: const EdgeInsets.only(bottom: 30.0),
                 child: ImageButton(icon: buttonInnerChild(
                   icon: Icons.business,
                   iconColor: hoverColor,
                   iconSize: 80.0,
                   text: 'Asignación de información estructural',
                   fontSize: 20.0,
                   fontColor: hoverColor,
                   backGroundColor: Colors.white
                 ),
                   hoverIcon: buttonInnerChild(
                     icon: Icons.business,
                     iconColor: Colors.white,
                     iconSize: 80.0,
                     text: 'Asignación de información estructural',
                     fontSize: 20.0,
                     fontColor: Colors.white,
                     backGroundColor: hoverColor
                   ),
                   onPressed: () => Navigator.pushNamed(context, ASIGNACION_DE_INFORMACION_ESTRUCTURAL),
                   fromAsset: false,
                 ),
               )
             ],
           ),
         ),
       ),
     ),
   );
  }

}

Widget buttonInnerChild({IconData icon,
  Color iconColor,
  double iconSize,
  String text,
  double fontSize,
  Color fontColor,
  Color backGroundColor,
}){
  return Card(
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Icon(icon, color: iconColor, size:iconSize,),
          Text(text,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: fontSize,
              color: fontColor,
              fontWeight: FontWeight.w600
            ),
          )
        ],
      ),
    ),
    color: backGroundColor,
    shape: new RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
    elevation: 10.0,
  );
}

Widget navigationMenu(){
  return Drawer(
    child: Container(
      color: hoverColor,
      constraints: BoxConstraints.expand(width: double.infinity),
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child:  Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Diagnóstico ambiental',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26.0,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Container(
                  width: 30.0,
                  height: 5.0,
                  color: actionHiglightColor,
                ),
              ],
            ),
              decoration: BoxDecoration(
                color: hoverColor,
              ),
          ),
          DrawerMenuOption(
            marginTop: 0.0,
            icon: Icon(Icons.file_upload,
              color: actionHiglightColor,
              size: 35,
            ),
            optionText: 'Levantamiento',
            route: LEVANTAMIENTO,
          ),
          DrawerMenuOption(
            icon: Icon(Icons.youtube_searched_for,
              color: actionHiglightColor,
              size: 35,
            ),
            optionText: 'Consulta',
            onPressed: (){

            },
          ),
          DrawerMenuOption(
            icon: Icon(Icons.remove_red_eye,
              color: actionHiglightColor,
              size: 35,
            ),
            optionText: 'Reconocimiento',
          ),
          DrawerMenuOption(
            icon: Icon(Icons.send,
              color: actionHiglightColor,
              size: 35,
            ),
            optionText: 'Enviar',
            onPressed: (){
              sendInfo();
              debugPrint("CLICK");
            },
          ),
          drawerDivider(),
          DrawerMenuOption(
            icon: Icon(Icons.warning,
              color: actionHiglightColor,
              size: 35,
            ),
            optionText: 'Incidentes',
            route: REPORTE_DE_INCIDENTES,
          ),
          drawerDivider(),
          DrawerMenuOption(
            icon: Icon(Icons.lightbulb_outline,
              color: actionHiglightColor,
              size: 35,
            ),
            optionText: 'Iluminación',
            route: ILUMINACION,
          ),
          drawerDivider(),
          DrawerMenuOption(
            icon: Icon(Icons.exit_to_app,
              color: actionHiglightColor,
              size: 35,
            ),
            optionText: 'Salir',
            route: '/',
          ),
        ],
      ),
    ),
  );
}

void sendInfo() async{
  List<Map<String,dynamic>> infoFromTheForms = await selectAll(INFORMACION_DE_LOS_FORMULARIOS);
  List<DMInformacionDelFormulario> infoObjects = getInformationOfFormsFromList(infoFromTheForms);
  /*debugPrint("CHECKPOINT1: " + infoFromTheForms.length.toString());
  debugPrint("CHECKPOINT2: " + infoObjects.length.toString());*/

  infoObjects.forEach((element) {
    debugPrint(element.idDeLaEntidad.toString());
  });

  var infoMaps = List<Map<String,dynamic>>();
  infoObjects.forEach((DMInformacionDelFormulario formInfo) async{
    Map<String, dynamic> map = <String,dynamic>{
      ENTIDAD : await getEntity(formInfo.idDeLaEntidad),
      EDIFICIO : await getBuilding(formInfo.idDeLaEntidad,formInfo.idDelEdificio),
      NIVEL : await getLevel(formInfo.idDeLaEntidad,formInfo.idDelEdificio,formInfo.idDelNivel),
      ESPACIO : await getSpace(formInfo.idDeLaEntidad,formInfo.idDelEdificio,formInfo.idDelNivel,formInfo.idDelEspacio),
      CATEGORIA : await getCategory(formInfo.idDeLaCategoria),
      FORMULARIO : await getFormName(formInfo.idDelFormulario),
      INFORMACION_DEL_FORMULARIO : formInfo.informacionDelFormulario
    };
//    debugPrint("CHECKPOINT3: " + map.toString());
    infoMaps.add(map);
  });
  var jsonOfInfoFromTheForms = new List<String>();
  infoFromTheForms.forEach((Map<String,dynamic> map){
    debugPrint("MAP: " + map.toString());
    debugPrint("TYPE: " + map.runtimeType.toString());
    String mapToJSON = jsonEncode(map);
    jsonOfInfoFromTheForms.add(mapToJSON);
  });

  debugPrint("JSON: " + jsonOfInfoFromTheForms.length.toString());

  String completedPostMessage = await httpPost(
      body: <String,dynamic>{
        "post": jsonOfInfoFromTheForms.toString()
      }
  );

  debugPrint("MENSAJE DE RESPUESTA" + completedPostMessage);
}

Future<String> getEntity(int id) async{
  List<Map<String,dynamic>> auxMap = await selectFrom(ENTIDADES,
      columns: <String>[ENTIDAD_],
      where: "$ID = ?",
      whereArgs: <dynamic>[id]
  );
  List<DMEntidad> auxObjectList = getEntitiesFromList(auxMap);
  return auxObjectList.first.entidad;
}
Future<String> getBuilding(int entityId, int id) async{
  List<Map<String,dynamic>> auxMap = await selectFrom(EDIFICIOS,
      columns: <String>[EDIFICIO_],
      where: "$ID_DE_LA_ENTIDAD = ? AND $ID = ?",
      whereArgs: <dynamic>[entityId,id]
  );
  List<DMEdificio> auxObjectList = getBuildingsFromList(auxMap);
  return auxObjectList.first.edificio;
}
Future<String> getLevel(int entityId, int buildingId, int id) async{
  List<Map<String,dynamic>> auxMap = await selectFrom(NIVELES,
      columns: <String>[NIVEL_],
      where: "$ID_DE_LA_ENTIDAD = ? AND $ID_DEL_EDIFICIO = ? AND $ID = ?",
      whereArgs: <dynamic>[entityId,buildingId,id]
  );
  List<DMNivel> auxObjectList = getLevelsFromList(auxMap);
  return auxObjectList.first.nivel;
}
Future<String> getSpace(int entityId, int buildingId, int levelId, int id) async{

  List<Map<String,dynamic>> auxMap = await selectFrom(ESPACIOS,
      columns: <String>[ESPACIO_],
      where: "$ID_DE_LA_ENTIDAD = ? AND $ID_DEL_EDIFICIO = ? AND $ID_DEL_NIVEL = ? AND $ID = ?",
      whereArgs: <dynamic>[entityId, buildingId, levelId, id]
  );
  List<DMEspacio> auxObjectList = getSpacesFromList(auxMap);
  return auxObjectList.first.espacio;
}
Future<String> getCategory(int id) async{
  List<Map<String,dynamic>> auxMap = await selectFrom(CATEGORIAS,
      columns: <String>[NOMBRE_DE_LA_CATEGORIA],
      where: "$ID = ?",
      whereArgs: <dynamic>[id]
  );
  List<DMCategoria> auxObjectList = getCategoriesFromList(auxMap);
  return auxObjectList.first.nombreDeLaCategoria;
}

Future<String> getFormName(int id) async{
  List<Map<String,dynamic>> auxMap = await selectFrom(FORMULARIOS,
      columns: <String>[NOMBRE_DEL_FORMULARIO],
      where: "$ID = ?",
      whereArgs: <dynamic>[id]
  );
  List<DMFormulario> auxObjectList = getFormsFromList(auxMap);
  return auxObjectList.first.nombreDelFormulario;
}


Container drawerDivider(){
  final horizontalPadding = 40.0;
  return Container(
      margin: EdgeInsets.only(left: horizontalPadding,right: horizontalPadding,top: 20.0),
      child: Divider(color: actionHiglightColor,thickness: 2.0,)
  );
}

class ImageButton extends StatefulWidget{
  ImageButton({Key key,
    @required this.icon,
    @required this.hoverIcon,
    @required this.onPressed,
    this.fromAsset = true,
    this.iconSize,
  })
      : super(key:key);
  final dynamic icon;
  final dynamic hoverIcon;
  final VoidCallback onPressed;
  final double iconSize;
  final bool fromAsset;

  @override
  _ImageButtonState createState() => _ImageButtonState();

}

class _ImageButtonState extends State<ImageButton>{

  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPressStart: longPressedButtonStart,
      onTapDown: pressedButton,
      onTap: onTapButton,
      onLongPress: longPressedButton,
      onLongPressEnd: longPressedButtonEnd,
      onTapUp: unpressedButton,
      onTapCancel: onCancel,
      child: IconButton(
        icon: iconSelection(),
        iconSize: widget.iconSize == null? 200.0 : widget.iconSize,
        onPressed: widget.onPressed,
        highlightColor: hoverColor,
        splashColor: hoverColor,
        hoverColor: hoverColor,
      ),
    );
  }

  void onTapButton(){
    setState(() {
      _isPressed = true;
    });
  }
  void pressedButton(TapDownDetails tapDownDetails){
    setState(() {
      _isPressed = true;
    });
  }
  void longPressedButtonStart(LongPressStartDetails longPressStartDetails){
    setState(() {
      _isPressed = true;
    });
  }
  void longPressedButton(){
    setState(() {
      _isPressed = true;
    });
  }
  void unpressedButton(TapUpDetails tapUpDetails){
    setState(() {
      _isPressed = false;
    });
  }
  void longPressedButtonEnd(LongPressEndDetails longPressEndDetails){
    setState(() {
      _isPressed = false;
    });
  }
  void onCancel(){
    setState(() {
      _isPressed = false;
    });
  }
  Widget iconSelection(){
    var assetUri;
    setState(() {
      assetUri = widget.fromAsset ? imageAsset() : icon();
    });
    return assetUri;
  }

  Widget imageAsset(){
    return !_isPressed ? Image.asset(widget.icon) : Image.asset(widget.hoverIcon);
  }

  Widget icon(){
    return !_isPressed ? widget.icon : widget.hoverIcon;
  }

}

class DrawerMenuOption extends StatelessWidget{
  DrawerMenuOption({Key key,
    this.icon,
    this.optionText,
    this.route,
    this.onPressed,
    this.style,
    this.textAlign,
    this.marginTop
  })
      :super(key:key);

  final Widget icon;
  final String optionText;
  final String route;
  final VoidCallback onPressed;
  final TextStyle style;
  final TextAlign textAlign;
  final double marginTop;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      margin: EdgeInsets.only(top: marginTop == null? 25.0 : marginTop),
      child: RaisedButton(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: icon,
            ),
            Expanded(
              flex: 2,
              child: Text(optionText,
                textAlign: textAlign == null? TextAlign.start : textAlign,
                style: style == null?
                TextStyle(
                  fontSize: 24.0,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                )
                    : style,),
            )
          ],
        ),
        onPressed: () {
          if(route != null){
            Navigator.popAndPushNamed(context, route,);
          }else if(onPressed != null){
            onPressed();
          }
          },
        color: Colors.transparent,
        elevation: 0.0,
      ),
    );
  }
}