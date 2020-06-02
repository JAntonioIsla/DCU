
import 'package:json_annotation/json_annotation.dart';

part 'data_model_entidad.g.dart';

@JsonSerializable()
class DMEntidad{
  final int id;
  final String entidad;
  DMEntidad({this.id, this.entidad});

  factory DMEntidad.fromJson(Map<String, dynamic> json) => _$DMEntidadFromJson(json);
  Map<String, dynamic> toJson() => _$DMEntidadToJson(this);
}