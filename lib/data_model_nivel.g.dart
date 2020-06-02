// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data_model_nivel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DMNivel _$DMNivelFromJson(Map<String, dynamic> json) {
  return DMNivel(
    id: json['id'] as int,
    idDeLaEntidad: json['idDeLaEntidad'] as int,
    idDelEdificio: json['idDelEdificio'] as int,
    nivel: json['nivel'] as String,
  );
}

Map<String, dynamic> _$DMNivelToJson(DMNivel instance) => <String, dynamic>{
      'id': instance.id,
      'idDeLaEntidad': instance.idDeLaEntidad,
      'idDelEdificio': instance.idDelEdificio,
      'nivel': instance.nivel,
    };
