// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data_model_edificio.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DMEdificio _$DMEdificioFromJson(Map<String, dynamic> json) {
  return DMEdificio(
    id: json['id'] as int,
    idDeLaEntidad: json['idDeLaEntidad'] as int,
    edificio: json['edificio'] as String,
    informacionDelEdificio: json['informacionDelEdificio'] as String,
  );
}

Map<String, dynamic> _$DMEdificioToJson(DMEdificio instance) =>
    <String, dynamic>{
      'id': instance.id,
      'idDeLaEntidad': instance.idDeLaEntidad,
      'edificio': instance.edificio,
      'informacionDelEdificio': instance.informacionDelEdificio,
    };
