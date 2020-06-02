
import 'package:json_annotation/json_annotation.dart';

part 'data_model_formulario.g.dart';

@JsonSerializable()
class DMFormulario{
  final int id;
  final String nombreDelFormulario;
  DMFormulario({this.id,this.nombreDelFormulario});

  factory DMFormulario.fromJson(Map<String, dynamic> json) => _$DMFormularioFromJson(json);
  Map<String, dynamic> toJson() => _$DMFormularioToJson(this);
}