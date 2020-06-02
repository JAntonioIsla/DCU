import 'package:dcu/asignacion_de_informacion_estructural.dart';
import 'package:dcu/database_manager.dart';
import 'package:dcu/iluminacion.dart';
import 'package:dcu/json_data.dart';
import 'package:dcu/levantamiento.dart';
import 'package:dcu/login.dart';
import 'package:dcu/main_menu.dart';
import 'package:dcu/reporte_de_incidentes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(MyApp());

const accentColor = Color(0xFF8DCE3A);
const hoverColor = Color(0xFF0056B8);
const actionHiglightColor = Color(0xFFF9D523);
const placeholderColor = Color(0xFF345D7C);

const MENU_PRINCIPAL = '/menu';
const LEVANTAMIENTO = '/levantamiento';
const REPORTE_DE_INCIDENTES = '/reporteDeIncidentes';
const ILUMINACION = '/iluminacion';
const ASIGNACION_DE_INFORMACION_ESTRUCTURAL = '/asignacionDeInformacionEstructural';

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  final _reporteDeIncidentes = <Widget>[ReporteDeIncidentes()];
  final _iluminacion = <Widget>[Iluminacion()];
  @override
  Widget build(BuildContext context) {
    uniqueInfoInsertion(context);
    //Oculta todas las capas de UI que no sean de la App, como la Notification Bar
    SystemChrome.setEnabledSystemUIOverlays([]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      routes: {
        // Cuando naveguemos hacia la ruta "/", crearemos el Widget FirstScreen
        '/': (context) => Login(),
        // Cuando naveguemos hacia la ruta "/menu", crearemos el Widget SecondScreen
        MENU_PRINCIPAL: (context) => MainMenu(),
        LEVANTAMIENTO: (context) => Levantamiento(),
        REPORTE_DE_INCIDENTES: (context) => Levantamiento(pageViewChildren: _reporteDeIncidentes,),
        ILUMINACION: (context) => Levantamiento(pageViewChildren: _iluminacion,),
        ASIGNACION_DE_INFORMACION_ESTRUCTURAL: (context) => AsignacionDeInformacionEstructural(),
      },
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        fontFamily: 'TitilliumWeb',
        primaryColor: Colors.white,
        accentColor: accentColor,
        hoverColor: hoverColor,
        primaryIconTheme: IconThemeData(
          color: accentColor,
          size: 50.0
        )
      ),
    );
  }



}

void goTo(BuildContext context,String routeName){
  Navigator.pushNamed(context, routeName);
}
