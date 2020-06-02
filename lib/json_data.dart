import 'dart:async';
import 'dart:convert';
import 'package:dcu/data_model_categoria.dart';
import 'package:dcu/data_model_formulario.dart';
import 'package:dcu/data_model_entidad.dart';
import 'package:dcu/database_manager.dart';
import 'package:flutter/material.dart';

final Codec<String, String> codecBase64Url = utf8.fuse(base64Url);

String toBase64Url(String stringToEncode) => codecBase64Url.encode(stringToEncode);
String fromBase64Url(String stringToDecode) => codecBase64Url.decode(stringToDecode);

Future<dynamic> retrieveJsonData(BuildContext context,String assetPath) async {
  final json = DefaultAssetBundle
      .of(context)
      .loadString(assetPath);
  return JsonDecoder().convert(await json);
}

Future<List<List<String>>> retrieveStringCatalog(BuildContext context,String assetPath,[String caltalogKey]){
  Future<List<List<String>>> catalog;
  final Future<dynamic> futureData = retrieveJsonData(context, assetPath);
  catalog = futureData.then<List<List<String>>>((dynamic data){
    var listOfCatalogs = new List<List<String>>();
    var actualCatalog;
    for(var key in data.keys){
      if(data is! Map){
        throw('Data retrieved from API is not a Map');
      }
      actualCatalog = data[key].map<String>((dynamic data){
        String item = data['item'].toString();
        return item;
      }
        ).toList();
      listOfCatalogs.add(actualCatalog);
    }
    return listOfCatalogs;
  });
  return catalog;
}

Future<void> insertGatheringCategories(BuildContext context) async{
  String jsonCategoriesAssetPath = 'json/categorias_del_levantamiento.json';
  final dynamic data = await retrieveJsonData(context, jsonCategoriesAssetPath);
  for(var key in data.keys){
    if(data is! Map){
      throw('Json data retrieved is not a Map');
    }
    data[key].map<void>((dynamic categoryItems) async{
      String categoryName = categoryItems['item'];
      final encodedCategoryName = toBase64Url(categoryName);
      var categoryMaps = await selectFrom(CATEGORIAS,
          where: "$NOMBRE_DE_LA_CATEGORIA = ?", whereArgs: [encodedCategoryName]);
      var categoryNameDoesNotExist = categoryMaps.length == 0;
      if(categoryNameDoesNotExist) {
        var category = DMCategoria(
            nombreDeLaCategoria: encodedCategoryName
        );
        await insertInTable(category, CATEGORIAS);
      }
    }).toList();
  }
}

Future<void> insertFormNames(BuildContext context) async{
  String jsonCategoriesAssetPath = 'json/nombres_de_formularios.json';
  final dynamic data = await retrieveJsonData(context, jsonCategoriesAssetPath);
  for(var key in data.keys){
    if(data is! Map){
      throw('Json data retrieved is not a Map');
    }
    data[key].map<void>((dynamic formItems) async{
      String formName = formItems['item'];
      final encodedFormName = toBase64Url(formName);
      var formMaps = await selectFrom(FORMULARIOS,
          where: "$NOMBRE_DEL_FORMULARIO = ?", whereArgs: [encodedFormName]);
      final formNameDoesNotExist = formMaps.length == 0;
      if(formNameDoesNotExist) {
        var form = DMFormulario(
            nombreDelFormulario: encodedFormName
        );
        await insertInTable(form, FORMULARIOS);
      }
    }).toList();
  }
}

Future<void> insertEntities(BuildContext context) async{
  String jsonCategoriesAssetPath = 'json/entidades.json';
  final dynamic data = await retrieveJsonData(context, jsonCategoriesAssetPath);
  for(var key in data.keys){
    if(data is! Map){
      throw('Json data retrieved is not a Map');
    }
    data[key].map<void>((dynamic formItems) async{
      String entityName = formItems['item'];
      final encodedEntityName = toBase64Url(entityName);
      var entityMaps = await selectFrom(ENTIDADES,
          where: "$ENTIDAD_ = ?", whereArgs: [encodedEntityName]);
      final formNameDoesNotExist = entityMaps.length == 0;
      if(formNameDoesNotExist) {
        var entity = DMEntidad(
            entidad: encodedEntityName
        );
        await insertInTable(entity, ENTIDADES);
      }
    }).toList();
  }
}

Future<Map<String,dynamic>> retrieveFormBuildingInformation(BuildContext context,String assetPath) async{
  final dynamic data = await retrieveJsonData(context, assetPath);
  var buildingInfo;
  for(var key in data.keys){
    if(data is! Map){
      throw('Json data retrieved is not a Map');
    }
    Map<String, dynamic> form = data[key];

    buildingInfo = form;

  }
  return buildingInfo;
}
