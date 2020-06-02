// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data_model_informacion_del_formulario.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DMInformacionDelFormulario _$DMInformacionDelFormularioFromJson(
    Map<String, dynamic> json) {
  return DMInformacionDelFormulario(
    id: json['id'] as int,
    idDeLaEntidad: json['idDeLaEntidad'] as int,
    idDelEdificio: json['idDelEdificio'] as int,
    idDelNivel: json['idDelNivel'] as int,
    idDelEspacio: json['idDelEspacio'] as int,
    idDelFormulario: json['idDelFormulario'] as int,
    idDeLaCategoria: json['idDeLaCategoria'] as int,
    informacionDelFormulario: json['informacionDelFormulario'] as String,
  );
}

Map<String, dynamic> _$DMInformacionDelFormularioToJson(
        DMInformacionDelFormulario instance) =>
    <String, dynamic>{
      'id': instance.id,
      'idDeLaEntidad': instance.idDeLaEntidad,
      'idDelEdificio': instance.idDelEdificio,
      'idDelNivel': instance.idDelNivel,
      'idDelEspacio': instance.idDelEspacio,
      'idDelFormulario': instance.idDelFormulario,
      'idDeLaCategoria': instance.idDeLaCategoria,
      'informacionDelFormulario': instance.informacionDelFormulario,
    };
