
import 'package:json_annotation/json_annotation.dart';

part 'data_model_espacio.g.dart';

@JsonSerializable()
class DMEspacio{
  final int id;
  final int idDeLaEntidad;
  final int idDelEdificio;
  final int idDelNivel;
  final String espacio;
  DMEspacio({this.id,this.idDeLaEntidad,this.idDelEdificio,this.idDelNivel,this.espacio});

  factory DMEspacio.fromJson(Map<String, dynamic> json) => _$DMEspacioFromJson(json);
  Map<String, dynamic> toJson() => _$DMEspacioToJson(this);
}