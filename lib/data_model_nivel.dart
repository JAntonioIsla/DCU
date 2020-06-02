
import 'package:json_annotation/json_annotation.dart';

part 'data_model_nivel.g.dart';

@JsonSerializable()
class DMNivel{
  final int id;
  final int idDeLaEntidad;
  final int idDelEdificio;
  final String nivel;
  DMNivel({this.id,this.idDeLaEntidad,this.idDelEdificio,this.nivel});

  factory DMNivel.fromJson(Map<String, dynamic> json) => _$DMNivelFromJson(json);
  Map<String, dynamic> toJson() => _$DMNivelToJson(this);
}