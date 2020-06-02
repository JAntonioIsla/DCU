// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data_model_formulario.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DMFormulario _$DMFormularioFromJson(Map<String, dynamic> json) {
  return DMFormulario(
    id: json['id'] as int,
    nombreDelFormulario: json['nombreDelFormulario'] as String,
  );
}

Map<String, dynamic> _$DMFormularioToJson(DMFormulario instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nombreDelFormulario': instance.nombreDelFormulario,
    };
