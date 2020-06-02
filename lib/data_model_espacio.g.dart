// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data_model_espacio.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DMEspacio _$DMEspacioFromJson(Map<String, dynamic> json) {
  return DMEspacio(
    id: json['id'] as int,
    idDeLaEntidad: json['idDeLaEntidad'] as int,
    idDelEdificio: json['idDelEdificio'] as int,
    idDelNivel: json['idDelNivel'] as int,
    espacio: json['espacio'] as String,
  );
}

Map<String, dynamic> _$DMEspacioToJson(DMEspacio instance) => <String, dynamic>{
      'id': instance.id,
      'idDeLaEntidad': instance.idDeLaEntidad,
      'idDelEdificio': instance.idDelEdificio,
      'idDelNivel': instance.idDelNivel,
      'espacio': instance.espacio,
    };
