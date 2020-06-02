
import 'package:dcu/json_data.dart';
import 'package:dcu/levantamiento.dart';
import 'package:dcu/lienzo_para_formato.dart';
import 'package:dcu/dropdown_default_selector.dart';
import 'package:dcu/radiogroup_answer.dart';
import 'package:dcu/toogle_group.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:dcu/formulario.dart';
import 'texfields.dart';
import 'espacio.dart';

const String CONTROL_DE_ILUMINACION = 'Control de iluminación';
const String CANTIDAD_DE_CONTROLES_DE_ILUMINACION =
    'Cantidad de controles de iluminación';
const String COLOR_DEL_TECHO = 'Color del techo';
const String COLOR_DE_LAS_PAREDES = 'Color de las paredes';
const String ENTRADAS_DE_LUZ_NATURAL = 'Entradas de luz natural';
const String TIPOS_DE_ENTRADAS_DE_LUZ_NATURAL =
    'Tipos de entradas de luz natural';
const String LUMENES_PROMEDIO = 'Lúmenes promedio';
const String USO = 'Uso';
const String ESPACIO_NO_LEVANTADO = 'Espacio no levantado';



class FormatoEspacio extends StatefulWidget {
  FormatoEspacio({
    Key key,
    @required this.entidad,
    @required this.edificio,
    @required this.nivel,
    @required this.espacio,
  })
      : super(key:key);
  final String entidad;
  final String edificio;
  final String nivel;
  final String espacio;
  @override
  _FormatoEspacioState createState() => _FormatoEspacioState();
}

class _FormatoEspacioState extends State<FormatoEspacio> {

  final _paddingQuestion =
      const EdgeInsets.only(left: 60.0, top: 0.0, bottom: 60.0);

  dynamic controlDeIluminacion;
  dynamic cantidadDeControlesDeIluminacion;
  dynamic colorDelTecho;
  dynamic colorDeLasParedes;
  dynamic entradasDeLuzNatural;
  dynamic tiposDeEntradasDeLuzNatural;
  dynamic lumenesPromedio;
  dynamic uso;
  dynamic espacioNoLevantado;


  //Variables de prueba
  dynamic testValue;
  List<String> textItems;
  ValueChanged<dynamic> onChangedTest;

  //Variables de prueba de para llamado a JSON
  List<String> catalogoControlDeIluminacion;
  List<String> catalogoColorDelTecho;
  List<String> catalogoColorDeLasParedes;
  List<String> catalogoEntradaDeLuzNatural;
  List<String> catalogoUso;
  List<String> catalogoEspacioNoLevantado;

  @override
  void initState() {
    super.initState();
  }

  @override
  Future<void> didChangeDependencies() async{
    super.didChangeDependencies();
    _retrieveCatalogs();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: FormLayout(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(left: 60.0, top: 30.0, bottom: 60.0),
            child: Text(
              ESPACIO,
              textAlign: TextAlign.start,
              style: TextStyle(
                  fontSize: 50.0,
                  color: Colors.black,
                  fontWeight: FontWeight.w600),
            ),
          ),
          catalogoControlDeIluminacion == null?CircularProgressIndicator()
              : Table(
            children: upperTableRows(),
          ),
          questionText(questionTag: TIPOS_DE_ENTRADAS_DE_LUZ_NATURAL,freeTag: true),
          catalogoControlDeIluminacion == null?CircularProgressIndicator()
              : Container(
              margin: _paddingQuestion,
              child: RadiogroupAnswer(selectableValues: catalogoEntradaDeLuzNatural, onChanged: onChangedTiposDeEntradasDeLuzNatural,)),
          catalogoControlDeIluminacion == null?CircularProgressIndicator()
              : Table(
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            children: lowerTableRows(),
          )
        ],
        onTap: saveInfo,
      ),
    );
  }

  void saveInfo() {
    var espacio = new Espacio(
        controlDeIluminacion:controlDeIluminacion,
        cantidadDeControlesDeIluminacion:cantidadDeControlesDeIluminacion,
        colorDelTecho:colorDelTecho,
        colorDeLasParedes:colorDeLasParedes,
        entradasDeLuzNatural:entradasDeLuzNatural,
        tiposDeEntradasDeLuzNatural:tiposDeEntradasDeLuzNatural,
        lumenesPromedio:lumenesPromedio,
        uso:uso,
        espacioNoLevantado:espacioNoLevantado,
        entidad: widget.entidad,
        edificio: widget.edificio,
        nivel: widget.nivel,
        espacio: widget.espacio,
    );

    String json = espacio.toJason().toString();
    print(json);
  }

  List<TableRow> upperTableRows() {
    List<TableRow> tableRows = new List<TableRow>();
    tableRows = [
      TableRow(
          children: tableQuestion(
              CONTROL_DE_ILUMINACION,
              DropdownDefaultSelector(textItems: catalogoControlDeIluminacion, value: controlDeIluminacion, onChanged: onChangedControlDeIluminacion),
          )
      ),
      TableRow(
          children: tableQuestion(
              CANTIDAD_DE_CONTROLES_DE_ILUMINACION,
              NumericTextField(decimal: false, maxLength: 3,onChanged: onChangedCantidadDeControlesDeIluminacion, onSubmitted: onChangedCantidadDeControlesDeIluminacion,),
          )
      ),
      TableRow(
          children: tableQuestion(
              COLOR_DEL_TECHO,
              DropdownDefaultSelector(textItems: catalogoColorDelTecho, value: colorDelTecho, onChanged: onChangedColorDelTecho),
          )
      ),
      TableRow(
          children: tableQuestion(
              COLOR_DE_LAS_PAREDES,
              DropdownDefaultSelector(textItems: catalogoColorDeLasParedes, value: colorDeLasParedes, onChanged: onChangedColorDeLasParedes),
          )
      ),
      TableRow(
          children: tableQuestion(
            ENTRADAS_DE_LUZ_NATURAL,
            ToogleGroup(onChanged: onPressedEntradasDeLuzNatural,affirmativeValue: SI, negativeValue: NO,),
          )
      ),
    ];

    return tableRows;
  }
  List<TableRow> lowerTableRows() {
    List<TableRow> tableRows = new List<TableRow>();
    tableRows = [
      TableRow(
          children: tableQuestion(
            LUMENES_PROMEDIO,
            NumericTextField(decimal: false, maxLength: 5,onChanged: onChangedLumenesPromedio, onSubmitted: onChangedLumenesPromedio,),
          )
      ),
      TableRow(
          children: tableQuestion(
              USO,
            DropdownDefaultSelector(textItems: catalogoUso, value: uso, onChanged: onChangedUso),
          )
      ),
      TableRow(
          children: tableQuestion(
            ESPACIO_NO_LEVANTADO,
            DropdownDefaultSelector(textItems: catalogoEspacioNoLevantado, value: espacioNoLevantado, onChanged: onChangedEspacioNoLevantado),
            'MOTIVO',
          )
      ),
    ];

    return tableRows;
  }

  Future<void> _retrieveCatalogs() async{
    List<List<String>> catalog = await retrieveStringCatalog(context, 'json/espacio.json');
    setState(() {
      catalogoControlDeIluminacion = catalog[0];
      controlDeIluminacion = catalog[0][0];

      catalogoColorDelTecho = catalog[1];
      colorDelTecho = catalog[1][0];

      catalogoColorDeLasParedes = catalog[1];
      colorDeLasParedes = catalog[1][0];

      catalogoEntradaDeLuzNatural = catalog[2];

      catalogoUso = catalog[3];
      uso = catalog[3][0];

      catalogoEspacioNoLevantado = catalog[4];
      espacioNoLevantado = catalog[4][0];

    });
  }
  void onChangedControlDeIluminacion(dynamic) {
    setState(() {
      controlDeIluminacion = dynamic;
    });
  }
  void onChangedCantidadDeControlesDeIluminacion(String valueChanged){
    setState(() {
      cantidadDeControlesDeIluminacion = valueChanged;
    });
  }
  void onChangedColorDelTecho(dynamic) {
    setState(() {
      colorDelTecho = dynamic;
    });
  }
  void onChangedColorDeLasParedes(dynamic) {
    setState(() {
      colorDeLasParedes = dynamic;
    });
  }
  void onPressedEntradasDeLuzNatural(String valueChanged){
    entradasDeLuzNatural = valueChanged;
  }
  void onChangedTiposDeEntradasDeLuzNatural(String valueChanged){
    setState(() {
      tiposDeEntradasDeLuzNatural = valueChanged;
    });
  }
  void onChangedLumenesPromedio(String valueChanged){
    setState(() {
      lumenesPromedio = valueChanged;
    });
  }
  void onChangedUso(dynamic) {
    setState(() {
      uso = dynamic;
    });
  }
  void onChangedEspacioNoLevantado(dynamic) {
    setState(() {
      espacioNoLevantado = dynamic;
    });
  }

}
