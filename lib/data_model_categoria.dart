
import 'package:json_annotation/json_annotation.dart';

part 'data_model_categoria.g.dart';

@JsonSerializable()
class DMCategoria{
  final int id;
  final String nombreDeLaCategoria;

  DMCategoria({this.id,this.nombreDeLaCategoria});

  factory DMCategoria.fromJson(Map<String, dynamic> json) => _$DMCategoriaFromJson(json);
  Map<String, dynamic> toJson() => _$DMCategoriaToJson(this);
}

