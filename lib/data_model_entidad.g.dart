// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data_model_entidad.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DMEntidad _$DMEntidadFromJson(Map<String, dynamic> json) {
  return DMEntidad(
    id: json['id'] as int,
    entidad: json['entidad'] as String,
  );
}

Map<String, dynamic> _$DMEntidadToJson(DMEntidad instance) => <String, dynamic>{
      'id': instance.id,
      'entidad': instance.entidad,
    };
