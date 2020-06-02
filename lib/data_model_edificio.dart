import 'package:json_annotation/json_annotation.dart';

part 'data_model_edificio.g.dart';

@JsonSerializable()
class DMEdificio{
  final int id;
  final int idDeLaEntidad;
  final String edificio;
  final String informacionDelEdificio;
  DMEdificio({this.id,this.idDeLaEntidad,this.edificio,this.informacionDelEdificio});

  factory DMEdificio.fromJson(Map<String, dynamic> json) => _$DMEdificioFromJson(json);
  Map<String, dynamic> toJson() => _$DMEdificioToJson(this);
}