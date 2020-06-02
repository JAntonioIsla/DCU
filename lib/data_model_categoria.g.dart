// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data_model_categoria.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DMCategoria _$DMCategoriaFromJson(Map<String, dynamic> json) {
  return DMCategoria(
    id: json['id'] as int,
    nombreDeLaCategoria: json['nombreDeLaCategoria'] as String,
  );
}

Map<String, dynamic> _$DMCategoriaToJson(DMCategoria instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nombreDeLaCategoria': instance.nombreDeLaCategoria,
    };
