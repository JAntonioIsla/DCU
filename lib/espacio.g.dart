// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'espacio.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Espacio _$EspacioFromJson(Map<String, dynamic> json) {
  return Espacio(
    controlDeIluminacion: json['controlDeIluminacion'] as String,
    cantidadDeControlesDeIluminacion:
        json['cantidadDeControlesDeIluminacion'] as String,
    colorDelTecho: json['colorDelTecho'] as String,
    colorDeLasParedes: json['colorDeLasParedes'] as String,
    entradasDeLuzNatural: json['entradasDeLuzNatural'] as String,
    tiposDeEntradasDeLuzNatural: json['tiposDeEntradasDeLuzNatural'] as String,
    lumenesPromedio: json['lumenesPromedio'] as String,
    uso: json['uso'] as String,
    espacioNoLevantado: json['espacioNoLevantado'] as String,
    entidad: json['entidad'] as String,
    edificio: json['edificio'] as String,
    nivel: json['nivel'] as String,
    espacio: json['espacio'] as String,
  );
}

Map<String, dynamic> _$EspacioToJson(Espacio instance) => <String, dynamic>{
      'controlDeIluminacion': instance.controlDeIluminacion,
      'cantidadDeControlesDeIluminacion':
          instance.cantidadDeControlesDeIluminacion,
      'colorDelTecho': instance.colorDelTecho,
      'colorDeLasParedes': instance.colorDeLasParedes,
      'entradasDeLuzNatural': instance.entradasDeLuzNatural,
      'tiposDeEntradasDeLuzNatural': instance.tiposDeEntradasDeLuzNatural,
      'lumenesPromedio': instance.lumenesPromedio,
      'uso': instance.uso,
      'espacioNoLevantado': instance.espacioNoLevantado,
      'entidad': instance.entidad,
      'edificio': instance.edificio,
      'nivel': instance.nivel,
      'espacio': instance.espacio,
    };
