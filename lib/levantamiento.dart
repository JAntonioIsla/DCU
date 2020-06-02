
import 'package:dcu/data_model_edificio.dart';
import 'package:dcu/data_model_entidad.dart';
import 'package:dcu/data_model_espacio.dart';
import 'package:dcu/data_model_nivel.dart';
import 'package:dcu/database_manager.dart';
import 'package:dcu/formulario.dart';
import 'package:dcu/json_data.dart';
import 'package:dcu/main.dart';
import 'package:dcu/main_menu.dart';
import 'package:dcu/texfields.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const ENTIDAD = 'Entidad';
const EDIFICIO = 'Edificio';
const NIVEL = 'Nivel';
const ESPACIO = 'Espacio';
const NINGUNO = 'Ninguno';

String entidad = NINGUNO;
String edificio = NINGUNO;
String nivel = NINGUNO;
String espacio = NINGUNO;

DMEntidad entity;
DMEdificio building;
DMNivel level;
DMEspacio space;

class Levantamiento extends StatefulWidget {
  Levantamiento({Key key,
    this.pageViewChildren,
    this.pageViewController
  })
      :super(key:key);

  final List<Widget> pageViewChildren;
  final PageController pageViewController;

  @override
  _LevantamientoState createState() => _LevantamientoState();
}

class _LevantamientoState extends State<Levantamiento> {

  bool displayAreaSelectionMenu;
  bool refresh;

  String dropdownValue = 'Entidad';

  var entityModels = <DMEntidad>[];
  var edificioModels = <DMEdificio>[];
  var nivelModels = <DMNivel>[];
  var espacioModels = <DMEspacio>[];

  List<String> entidadSpinnerValues;

  PageController _pageController;
  PageView _pageView;

  @override
  void initState() {
    entidad = NINGUNO;
    edificio = NINGUNO;
    nivel = NINGUNO;
    espacio = NINGUNO;
    displayAreaSelectionMenu = false;
    refresh = false;

    _pageController = PageController(
      initialPage: 0,
    );

    super.initState();
  }

  @override
  void didChangeDependencies() async{
    var entityMapsList = await selectAll(ENTIDADES);
    entityModels = getEntitiesFromList(entityMapsList);
    entidadSpinnerValues = entityModels.map<String>((entidad){
      print(fromBase64Url(entidad.entidad));
      return fromBase64Url(entidad.entidad);
    }
    ).toList();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    if(_pageView == null){_pageView = PageView(
      controller: widget.pageViewController == null? _pageController : widget.pageViewController,
      children: widget.pageViewChildren == null? <Widget>[
        FormFromJSON(buildingInformationPath: 'json/formulario_de_espacio.json',),
        FormFromJSON(buildingInformationPath: 'json/formulario_medidor_de_energia_electrica.json',),
        FormFromJSON(buildingInformationPath: 'json/formulario_cilindro_de_gas.json',),
        FormFromJSON(buildingInformationPath: 'json/formulario_luminaria.json',),
        FormFromJSON(buildingInformationPath: 'json/formulario_computadora.json',),
        FormFromJSON(buildingInformationPath: 'json/formulario_miscelaneo.json',),
        FormFromJSON(buildingInformationPath: 'json/formulario_computo_miscelaneo.json',),
        FormFromJSON(buildingInformationPath: 'json/formulario_refrigerador.json',),
        FormFromJSON(buildingInformationPath: 'json/formulario_aire_acondicionado.json',),
        FormFromJSON(buildingInformationPath: 'json/formulario_equipo_de_fuerza.json',),
        FormFromJSON(buildingInformationPath: 'json/formulario_equipo_de_laboratorio.json',),
        FormFromJSON(buildingInformationPath: 'json/formulario_biciestacionamiento.json',),
        FormFromJSON(buildingInformationPath: 'json/formulario_lugar_de_estacionamiento_para_uso_compartido_automovil.json',),
        FormFromJSON(buildingInformationPath: 'json/formulario_estacionamiento.json',),
        FormFromJSON(buildingInformationPath: 'json/formulario_lockers_para_usuarios_de_transporte_no_motorizado.json',),
        FormFromJSON(buildingInformationPath: 'json/formulario_medidores_de_agua.json',),
        FormFromJSON(buildingInformationPath: 'json/formulario_llave_lavamanos.json',),
        FormFromJSON(buildingInformationPath: 'json/formulario_inodoros.json',),
        FormFromJSON(buildingInformationPath: 'json/formulario_mingitorios.json',),
        FormFromJSON(buildingInformationPath: 'json/formulario_regaderas.json',),
        FormFromJSON(buildingInformationPath: 'json/formulario_llaves_de_servicios.json',),
        FormFromJSON(buildingInformationPath: 'json/formulario_area_verde.json',),
        FormFromJSON(buildingInformationPath: 'json/formulario_sistema_de_riego.json',),
        FormFromJSON(buildingInformationPath: 'json/formulario_deposito_de_almacenamiento_de_agua_potable.json',),
        FormFromJSON(buildingInformationPath: 'json/formulario_escorrentias_en_azoteas.json',),
        FormFromJSON(buildingInformationPath: 'json/formulario_dispensador_de_agua_para_beber.json',),
        FormFromJSON(buildingInformationPath: 'json/formulario_residuos.json',),

      ]
          : widget.pageViewChildren,
    );}
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        drawer: navigationMenu(),
        drawerScrimColor: Colors.transparent,
        body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints viewportConstraints) {
            return ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: viewportConstraints.minHeight,
                maxHeight: viewportConstraints.maxHeight,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      topPlaceholder(ENTIDAD.toUpperCase()),
                      topPlaceholder(EDIFICIO.toUpperCase()),
                      topPlaceholder(NIVEL.toUpperCase()),
                      topPlaceholder(ESPACIO.toUpperCase()),
                    ],
                  ),
                  Container(
                    color: hoverColor,
                    child: Row(
                      children: <Widget>[
                        bottomPlaceholder(entidad),
                        whiteVerticalDivider(),
                        bottomPlaceholder(edificio),
                        whiteVerticalDivider(),
                        bottomPlaceholder(nivel),
                        whiteVerticalDivider(),
                        bottomPlaceholder(espacio),
                      ],
                    ),
                  ),
                  areaSelectionMenu(),
                  Expanded(
                    child: _pageView
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget topPlaceholder(String text) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(top: 30.0),
        child: Text(
          text,
          style: TextStyle(
            color: hoverColor,
            fontSize: 24.0,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget bottomPlaceholder(String text) {
    return Expanded(
      child: RaisedButton(
        elevation: 0.0,
        splashColor: accentColor,
        color: Colors.transparent,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 10.0),
          child: Text(
            text,
            style: TextStyle(
                color: accentColor,
                fontSize: text.length < 24? text.length < 15? 24.0 : 22.0 : 21.0,
                fontWeight: FontWeight.w600),
            textAlign: TextAlign.center,
          ),
        ),
        onPressed: () {
          setState(() {
            displayAreaSelectionMenu = !displayAreaSelectionMenu;
          });
        },
      ),
    );
  }

  Widget whiteVerticalDivider() {
    return Container(
      width: 2.0,
      height: 40.0,
      color: Colors.white,
    );
  }

  Widget areaSelectionMenu() {
    if (displayAreaSelectionMenu) {
      return Expanded(
        flex: 5,
          child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
            margin:
                const EdgeInsets.symmetric(horizontal: 200.0, vertical: 10.0),
            child: autocompleteForStructuralComponents(
              title: ENTIDAD,
              suggestions: entidadSpinnerValues,
              onChanged: (valueChanged){
                setState(() {
                  changeSpinnersByEntityValue(valueChanged);
                });
              },
            ),
              ),
              Container(
            margin:
                const EdgeInsets.symmetric(horizontal: 200.0, vertical: 10.0),
            child: edificioModels != null
                ? autocompleteForStructuralComponents(
              title: EDIFICIO,
              suggestions: edificioModels.map<String>((edificio){
                return fromBase64Url(edificio.edificio);
              }
              ).toList(),
              onChanged: (valueChanged){
                setState(() {
                  changeSpinnersByBuildingValue(valueChanged);
                });
              }
            )
                : CircularProgressIndicator(),
              ),
              Container(
            margin:
                const EdgeInsets.symmetric(horizontal: 200.0, vertical: 10.0),
            child: nivelModels != null
                ? autocompleteForStructuralComponents(
              title: NIVEL,
                suggestions: nivelModels.map<String>((nivel){
                  return fromBase64Url(nivel.nivel);
                }
                ).toList(),
                onChanged: (valueChanged){
                  setState(() {
                    changeSpinnersByLevelValue(valueChanged);
                  });
                }
            )
                : CircularProgressIndicator(),
              ),
              Container(
            margin:
                const EdgeInsets.symmetric(horizontal: 200.0, vertical: 10.0),
            child: espacioModels != null
                ? autocompleteForStructuralComponents(
              title: ESPACIO,
                suggestions: espacioModels.map<String>((espacio){
                  return fromBase64Url(espacio.espacio);
                }
                ).toList(),
                onChanged: (valueChanged){
                  setState(() {
                    changeSpinnersBySpaceValue(valueChanged);
                  });
                }
            )
                : CircularProgressIndicator(),
              ),
            ],
          ),
        ),
      ));
    } else {
      return Container();
    }
  }

  Widget autocompleteForStructuralComponents({
    String title,
    List<String> suggestions,
    ValueChanged<String> onChanged,
  }){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(title, style: TextStyle(fontSize: 24.0),),
        Container(
          child: AutoCompleteTextField(
            suggestions: suggestions,
            onChanged: onChanged,
            onSubmitted: onChanged,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.w600, color: hoverColor,height: 1),
            suggestionsTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w600, color: hoverColor,height: 1),
            suggestionColor: Colors.white,
            suggestionsMargin: EdgeInsets.only(top: 5.0),
            suggestionSplashColor: hoverColor,
            suggestionHighlightColor: hoverColor,
            suggestionElevation: 0.0,
            selectionAreaElevation: 0.0,
            selectionAreaColor: Colors.white,
          ),
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(20.0),
          ),
        ),
      ],
    );
  }

  void changeSpinnersByEntityValue(String entityValue) {
    entityModels.forEach((entityModel) async{
      var entityCode = fromBase64Url(entityModel.entidad);
      if(entityCode == entityValue){
        entidad = entityValue;
        entity = entityModel;
        var edificioMapsList = await selectFrom(EDIFICIOS, where: '$ID_DE_LA_ENTIDAD = ?', whereArgs: [entity.id]);
        edificioModels = getBuildingsFromList(edificioMapsList);
      }
    });
    edificio = '';
    nivel = '';
    espacio = '';
  }

  void changeSpinnersByBuildingValue(String buildingValue){
    edificioModels.forEach((buildingModel) async{
      var buildingCode = fromBase64Url(buildingModel.edificio);
      if(buildingCode == buildingValue){
        edificio = buildingValue;
        building = buildingModel;
        var nivelMapsList = await selectFrom(NIVELES, where: '$ID_DE_LA_ENTIDAD = ? AND $ID_DEL_EDIFICIO = ?',
            whereArgs: [entity.id, building.id]);
        nivelModels = getLevelsFromList(nivelMapsList);
        nivelModels.forEach((levelModel){
          print(fromBase64Url(levelModel.nivel));
        });
      }
    });
    nivel = '';
    espacio = '';
  }

  void changeSpinnersByLevelValue(String levelValue){
    nivelModels.forEach((nivelModel) async{
      var levelCode = fromBase64Url(nivelModel.nivel);
      if(levelCode == levelValue){
        nivel = levelValue;
        level = nivelModel;
        var espacioMapsList = await selectFrom(ESPACIOS, where: '$ID_DE_LA_ENTIDAD = ? AND $ID_DEL_EDIFICIO = ? AND $ID_DEL_NIVEL = ?',
            whereArgs: [entity.id, building.id, level.id]);
        espacioModels = getSpacesFromList(espacioMapsList);
      }
    });

    espacio = '';
  }

  void changeSpinnersBySpaceValue(String spaceValue){
    espacioModels.forEach((espacioModel) async{
      var spaceCode = fromBase64Url(espacioModel.espacio);
      if(spaceCode == spaceValue){
        espacio = spaceValue;
        space = espacioModel;
        print(fromBase64Url(space.espacio));
      }
    });
  }

}
