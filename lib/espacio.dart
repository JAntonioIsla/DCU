import 'package:json_annotation/json_annotation.dart';

part 'espacio.g.dart';

@JsonSerializable()

class Espacio{
  final String controlDeIluminacion;
  final String cantidadDeControlesDeIluminacion;
  final String colorDelTecho;
  final String colorDeLasParedes;
  final String entradasDeLuzNatural;
  final String tiposDeEntradasDeLuzNatural;
  final String lumenesPromedio;
  final String uso;
  final String espacioNoLevantado;
  final String entidad;
  final String edificio;
  final String nivel;
  final String espacio;

  const Espacio({
      this.controlDeIluminacion,
      this.cantidadDeControlesDeIluminacion,
      this.colorDelTecho,
      this.colorDeLasParedes,
      this.entradasDeLuzNatural,
      this.tiposDeEntradasDeLuzNatural,
      this.lumenesPromedio,
      this.uso,
      this.espacioNoLevantado,
      this.entidad,
      this.edificio,
      this.nivel,
      this.espacio,
      }) :  assert(controlDeIluminacion != null),
            assert(cantidadDeControlesDeIluminacion != null),
            assert(colorDelTecho != null),
            assert(colorDeLasParedes != null),
            assert(entradasDeLuzNatural != null),
            assert(tiposDeEntradasDeLuzNatural != null),
            assert(lumenesPromedio != null),
            assert(uso != null),
            assert(espacioNoLevantado != null),
            assert(entidad != null),
            assert(edificio != null),
            assert(nivel != null),
            assert(espacio != null);

  factory Espacio.fromJson(Map<String, dynamic> json) => _$EspacioFromJson(json);
  Map<String, dynamic> toJason() => _$EspacioToJson(this);
}