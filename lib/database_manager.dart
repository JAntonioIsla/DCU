import 'dart:async';
import 'package:dcu/data_model_categoria.dart';
import 'package:dcu/data_model_edificio.dart';
import 'package:dcu/data_model_entidad.dart';
import 'package:dcu/data_model_espacio.dart';
import 'package:dcu/data_model_formulario.dart';
import 'package:dcu/data_model_informacion_del_formulario.dart';
import 'package:dcu/data_model_nivel.dart';
import 'package:dcu/json_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

const CREATE_TABLE = 'CREATE TABLE';
const PRIMARY_KEY = 'PRIMARY KEY';
const UNIQUE = 'UNIQUE';
const INTEGER = 'INTEGER';
const TEXT = 'TEXT';

const ID = 'id';
const ID_DE_LA_ENTIDAD = 'idDeLaEntidad';
const ID_DEL_EDIFICIO = 'idDelEdificio';
const ID_DEL_NIVEL = 'idDelNivel';
const ID_DEL_ESPACIO = 'idDelEspacio';
const ID_DEL_FORMULARIO = 'idDelFormulario';
const ID_DE_LA_CATEGORIA = 'idDeLaCategoria';

const FORMULARIOS = 'Formularios';
const CATEGORIAS = 'Categorias';
const ENTIDADES = 'Entidades';
const EDIFICIOS = 'Edificios';
const NIVELES = 'Niveles';
const ESPACIOS = 'Espacios';
const INFORMACION_DE_LOS_FORMULARIOS = 'InformacionDeLosFormularios';

const ENTIDAD_ = 'entidad';
const EDIFICIO_ = 'edificio';
const NIVEL_ = 'nivel';
const ESPACIO_ = 'espacio';
const CATEGORIA = 'Categoria';
const FORMULARIO = 'Formulario';
const NOMBRE_DEL_FORMULARIO = 'nombreDelFormulario';
const NOMBRE_DE_LA_CATEGORIA = 'nombreDeLaCategoria';
const INFORMACION_DEL_EDIFICIO = 'informacionDelEdificio';
const INFORMACION_DEL_FORMULARIO = 'informacionDelFormulario';

const TABLA_FORMULARIOS =
    '$CREATE_TABLE $FORMULARIOS($ID $INTEGER $PRIMARY_KEY, $NOMBRE_DEL_FORMULARIO $TEXT $UNIQUE)';
const TABLA_CATEGORIAS =
    '$CREATE_TABLE $CATEGORIAS($ID $INTEGER $PRIMARY_KEY, $NOMBRE_DE_LA_CATEGORIA $TEXT $UNIQUE)';
const TABLA_ENTIDADES =
    '$CREATE_TABLE $ENTIDADES($ID $INTEGER $PRIMARY_KEY, $ENTIDAD_ $TEXT $UNIQUE)';
const TABLA_EDIFICIOS =
    '$CREATE_TABLE $EDIFICIOS($ID $INTEGER $PRIMARY_KEY, $ID_DE_LA_ENTIDAD $INTEGER, '
        + '$EDIFICIO_ $TEXT, $INFORMACION_DEL_EDIFICIO $TEXT)';
const TABLA_NIVELES =
    '$CREATE_TABLE $NIVELES($ID $INTEGER $PRIMARY_KEY, $ID_DE_LA_ENTIDAD $INTEGER, '
        +'$ID_DEL_EDIFICIO $INTEGER, $NIVEL_ $TEXT)';
const TABLA_ESPACIOS =
    '$CREATE_TABLE $ESPACIOS($ID $INTEGER $PRIMARY_KEY, $ID_DE_LA_ENTIDAD $INTEGER, '
        +'$ID_DEL_EDIFICIO $INTEGER, $ID_DEL_NIVEL $INTEGER, $ESPACIO_ $TEXT)';
const TABLA_INFORMACION_DE_LOS_FORMULARIOS =
    '$CREATE_TABLE $INFORMACION_DE_LOS_FORMULARIOS($ID $INTEGER $PRIMARY_KEY, $ID_DE_LA_ENTIDAD $INTEGER, '
        +'$ID_DEL_EDIFICIO $INTEGER, $ID_DEL_NIVEL $INTEGER, $ID_DEL_ESPACIO $INTEGER, '
        +'$ID_DEL_FORMULARIO $INTEGER, $ID_DE_LA_CATEGORIA $INTEGER, $INFORMACION_DEL_FORMULARIO $TEXT)';

final List<String> tables =
<String>[
  TABLA_FORMULARIOS,
  TABLA_CATEGORIAS,
  TABLA_ENTIDADES,
  TABLA_EDIFICIOS,
  TABLA_NIVELES,
  TABLA_ESPACIOS,
  TABLA_INFORMACION_DE_LOS_FORMULARIOS,
];

final Future<Database> database = _openDatabase();

Future<Database> _openDatabase() async{
  return openDatabase(
    join(await getDatabasesPath(), 'dcu_database.db'),
    onCreate: (database,version){
      tables.forEach((String table){ _createTable(table, database); });
    },
    version: 1,
  );
}

void _createTable(String tableSpecifications ,Database database) => database.execute(tableSpecifications);

Future<void> insertInTable(var dataModelObject, String table) async {

  final Database db = await database;
  return await db.insert(
    table,
    dataModelObject.toJson(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}


FutureOr<List<Map<String,dynamic>>> selectAll(String table) async {
  final Database db = await database;
  return await db.query(table);
}

FutureOr<List<Map<String, dynamic>>> selectFrom(String table,{
  bool distinct,
  List<String> columns,
  String where,
  List<dynamic> whereArgs,
  String groupBy,
  String having,
  String orederBy,
  int limit,
  int offset
}) async{
  final Database db = await database;
  return await db.query(table,
    distinct: distinct,
    columns: columns,
    where: where,
    whereArgs: whereArgs,
    groupBy: groupBy,
    having: having,
    orderBy: orederBy,
    limit: limit,
    offset: offset
  );
}

Future<void> delete({String table, String where, List<dynamic> whereArgs}) async{
  final Database db = await database;
  db.delete(table, where: where, whereArgs: whereArgs);
}

Future<void> deleteById({String table, int id}) async{
  final Database db = await database;
  db.delete(table, where:  'id = ?', whereArgs: [id]);
}

List<DMCategoria> getCategoriesFromList(List<Map<String,dynamic>> mapList){
  return List.generate(mapList.length, (i) {
    return DMCategoria.fromJson(mapList[i]);
  });
}

List<DMEntidad> getEntitiesFromList(List<Map<String,dynamic>> mapList){
  return List.generate(mapList.length, (i) {
    return DMEntidad.fromJson(mapList[i]);
  });
}

List<DMEdificio> getBuildingsFromList(List<Map<String,dynamic>> mapList){
  return List.generate(mapList.length, (i) {
    return DMEdificio.fromJson(mapList[i]);
  });
}

List<DMNivel> getLevelsFromList(List<Map<String,dynamic>> mapList){
  return List.generate(mapList.length, (i) {
    return DMNivel.fromJson(mapList[i]);
  });
}

List<DMEspacio> getSpacesFromList(List<Map<String,dynamic>> mapList){
  return List.generate(mapList.length, (i) {
    return DMEspacio.fromJson(mapList[i]);
  });
}

List<DMFormulario> getFormsFromList(List<Map<String,dynamic>> mapList){
  return List.generate(mapList.length, (i) {
    return DMFormulario.fromJson(mapList[i]);
  });
}

List<DMInformacionDelFormulario> getInformationOfFormsFromList(List<Map<String,dynamic>> mapList){
  return List.generate(mapList.length, (i) {
    return DMInformacionDelFormulario.fromJson(mapList[i]);
  });
}

Future<void> uniqueInfoInsertion(BuildContext context) async{
  insertGatheringCategories(context);
  insertFormNames(context);
  insertEntities(context);
}