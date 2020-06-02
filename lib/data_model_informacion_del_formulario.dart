
import 'package:json_annotation/json_annotation.dart';

part 'data_model_informacion_del_formulario.g.dart';

@JsonSerializable()
class DMInformacionDelFormulario{
  final int id;
  final int idDeLaEntidad;
  final int idDelEdificio;
  final int idDelNivel;
  final int idDelEspacio;
  final int idDelFormulario;
  final int idDeLaCategoria;
  final String informacionDelFormulario;
  DMInformacionDelFormulario({
    this.id,
    this.idDeLaEntidad,
    this.idDelEdificio,
    this.idDelNivel,
    this.idDelEspacio,
    this.idDelFormulario,
    this.idDeLaCategoria,
    this.informacionDelFormulario,
});

  factory DMInformacionDelFormulario.fromJson(Map<String, dynamic> json) => _$DMInformacionDelFormularioFromJson(json);
  Map<String, dynamic> toJson() => _$DMInformacionDelFormularioToJson(this);
}