import 'dart:async';

import 'package:dcu/data_model_edificio.dart';
import 'package:dcu/data_model_entidad.dart';
import 'package:dcu/data_model_nivel.dart';
import 'package:dcu/database_manager.dart';
import 'package:dcu/dropdown_default_selector.dart';
import 'package:dcu/growing_table.dart';
import 'package:dcu/json_data.dart';
import 'package:dcu/levantamiento.dart';
import 'package:dcu/lienzo_para_formato.dart';
import 'package:dcu/login.dart';
import 'package:dcu/texfields.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dcu/formulario.dart';

import 'data_model_espacio.dart';

const String CANTIDAD = 'Cantidad';
const String SELECCIONAR = 'Seleccionar';
const String AGREGAR_NIVEL = 'Los niveles sin título no se agregarán';

class AsignacionDeInformacionEstructural extends StatefulWidget {
  @override
  _AsignacionDeInformacionEstructuralState createState() =>
      _AsignacionDeInformacionEstructuralState();
}

class _AsignacionDeInformacionEstructuralState
    extends State<AsignacionDeInformacionEstructural> {
  final _formBodyPadding = const EdgeInsets.all(50.0);
  final _titulo = 'Asignación de información estructural';
  bool areBuildingsAreAssigned = false;
  List<DMEntidad> entidades = new List<DMEntidad>();
  List<DMEdificio> edificios = new List<DMEdificio>();
  List<DMNivel> niveles = new List<DMNivel>();
  List<DMNivel> nivelesForSpaces = new List<DMNivel>();


  List<String> nombresDeEntidades = <String>[];
  List<String> nombresDeEdificios = <String>[];
  List<String> nombresDeNiveles = <String>[];

  List<String> specificNamesOfSpaceBuildings = <String>[];
  List<String> specificNamesOfLevels = <String>[];

  var selectedEntity = SELECCIONAR;
  var selectedBuilding = SELECCIONAR;
  var selectedLevelBuilding = SELECCIONAR;
  var selectedLevel = SELECCIONAR;
  var selectedSpaceBuilding = SELECCIONAR;

  var amountOfBuildings = 0;
  var showAddBuildingsButton = false;

  var amountOfSimpleLevels = 0;
  var amountOfBasements = 0;
  var specialLevels = <String>[];
  var showAddGeneralLevelsButton = false;

  var showSpecificLevelsPerBuilding = false;
  var amountOfSpecificSimpleLevels = 0;
  var amountOfSpecificBasements = 0;
  var specificSpecialLevels = <String>[];
  var showAddSpecificLevelsButton = false;

  var amountOfSimpleSpaces = 0;
  var amountOfStairs = 0;
  var specialSpaces = <String>[];
  var showAddGeneralSpacesButton = false;

  var showSpecificSpacesPerLevel = false;
  var amountOfSpecificSimpleSpaces = 0;
  var amountOfSpecificStairs = 0;
  var specificSpecialSpaces = <String>[];
  var showAddSpecificSpacesButton = false;

  var waitForSpacesInsertion = false;

  @override
  void didChangeDependencies() async {
    var entitiesMap = await selectAll(ENTIDADES);
    entidades = getEntitiesFromList(entitiesMap);
    setState(() =>
    nombresDeEntidades = entidades
        .map<String>((DMEntidad entidad) => fromBase64Url(entidad.entidad))
        .toList());
    nombresDeEntidades.insert(0, SELECCIONAR);
    setState(() =>
    nombresDeNiveles = niveles
        .map<String>((DMNivel nivel) => fromBase64Url(nivel.nivel))
        .toList());
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
            child: Container(
              margin: _formBodyPadding,
              child: Column(
                children: <Widget>[
                  Card(
                    child: Container(
                      constraints: BoxConstraints(
                          minHeight: MediaQuery
                              .of(context)
                              .size
                              .height * 0.9),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Container(
                            margin: const EdgeInsets.only(
                                left: 60.0, top: 30.0, bottom: 60.0),
                            child: Text(
                              _titulo,
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  fontSize: 50.0,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                          Table(
                            children: <TableRow>[
                              rowField(
                                  title: ENTIDAD,
                                  child: nombresDeEntidades != null
                                      ? DropdownDefaultSelector(
                                    textItems: nombresDeEntidades,
                                    onChanged: (valueChanged) {
                                      setState(() {
                                        selectedEntity = valueChanged;
                                        showAddBuildingsButton =
                                        amountOfBuildings != 0 &&
                                            amountOfBuildings != null
                                            ? true
                                            : false;
                                      });
                                    },
                                  )
                                      : CircularProgressIndicator()),
                              rowField(
                                  title: EDIFICIOS,
                                  child: NumericTextField(
                                    enabled: selectedEntity != SELECCIONAR
                                        ? true
                                        : false,
                                    decimal: false,
                                    maxLength: 3,
                                    onChanged: (valueChanged) {
                                      setState(() {
                                        amountOfBuildings =
                                            int.tryParse(valueChanged);
                                        showAddBuildingsButton =
                                        amountOfBuildings != 0 &&
                                            amountOfBuildings != null
                                            ? true
                                            : false;
                                      });
                                    },
                                  ),
                                  info: CANTIDAD.toUpperCase())
                            ],
                          ),
                          Container(
                            alignment: Alignment.center,
                            child: showAddBuildingsButton == true &&
                                selectedEntity != SELECCIONAR
                                ? appButton(
                                text: 'Agregar edificios',
                                onPressed: () {
                                  setState(() {
                                    createNewBuildings(amountOfBuildings)
                                        .then((value) async {
                                      var selectedEntityId =
                                          obtainSelectedEntityModel().id;
                                      edificios = await buildingsFromEntity(
                                          selectedEntityId);
                                      setState(() {
                                        nombresDeEdificios = edificios
                                            .map<String>((DMEdificio building) {
                                          return fromBase64Url(
                                              building.edificio);
                                        }).toList();
                                      });
                                    });
                                    showAddBuildingsButton = false;
                                  });
                                })
                                : null,
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            margin: const EdgeInsets.only(
                                left: 0.0, top: 30.0, bottom: 60.0),
                            child: showAddBuildingsButton == false &&
                                selectedEntity != SELECCIONAR &&
                                amountOfBuildings != 0 &&
                                amountOfBuildings != null
                                ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 60.0, top: 30.0, bottom: 60.0),
                                  child: Text(
                                    NIVELES,
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        fontSize: 50.0,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: 50.0, left: 60.0),
                                  child: Text(
                                    '$NIVELES comunes a todos los edificios',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        fontSize: 30.0,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                                Table(
                                  children: <TableRow>[
                                    rowField(
                                        title: 'Simples',
                                        child: NumericTextField(
                                          decimal: false,
                                          maxLength: 3,
                                          onChanged: (valueChanged) {
                                            setState(() {
                                              amountOfSimpleLevels =
                                                  int.tryParse(valueChanged);
                                              areAnyCommonLevelNumberIsNotEmpty()
                                                  ? showAddGeneralLevelsButton =
                                              true
                                                  : showAddGeneralLevelsButton =
                                              false;
                                            });
                                          },
                                        ),
                                        info: CANTIDAD.toUpperCase()),
                                    rowField(
                                        title: 'Sotanos',
                                        child: NumericTextField(
                                          decimal: false,
                                          maxLength: 3,
                                          onChanged: (valueChanged) {
                                            setState(() {
                                              amountOfBasements =
                                                  int.tryParse(valueChanged);
                                              areAnyCommonLevelNumberIsNotEmpty()
                                                  ? showAddGeneralLevelsButton =
                                              true
                                                  : showAddGeneralLevelsButton =
                                              false;
                                            });
                                          },
                                        ),
                                        info: CANTIDAD.toUpperCase()),
                                    rowField(
                                      title: 'Especiales',
                                      child: Container(
                                        margin: EdgeInsets.only(right: 30.0),
                                        child: GrowingTable(
                                          initialNumberOfRows: 0,
                                          onChanged: specialLevelsUpdate,
                                          onSubmitted: specialLevelsUpdate,
                                          onIncreasePressed:
                                          increaseNumberOfSpecialLevelsFields,
                                          onDecreasePressed:
                                          decreaseNumberOfSpecialLevelsFields,
                                          textPrefix: '$NIVEL ',
                                          keyboardType: TextInputType.text,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  child: showAddGeneralLevelsButton == true &&
                                      selectedEntity != SELECCIONAR
                                      ? appButton(
                                      text: 'Agregar niveles',
                                      onPressed: () {
                                        setState(() {
                                          createNewLevels(
                                            amountOfSimpleLevels:
                                            amountOfSimpleLevels,
                                            amountOfBasements:
                                            amountOfBasements,
                                            specialLevels: specialLevels,
                                          ).then((value) async {
                                            niveles.clear();
                                            nombresDeNiveles.clear();
                                            var selectedEntityId =
                                                obtainSelectedEntityModel()
                                                    .id;
                                            edificios.forEach((DMEdificio
                                            building) async {
                                              Future.delayed(
                                                  Duration(
                                                      milliseconds: 10),
                                                      () async {
                                                    var buildingLevels =
                                                    await levelsFrom(
                                                        selectedEntityId,
                                                        building.id);
                                                    niveles.addAll(
                                                        buildingLevels);
                                                    didChangeDependencies();
                                                  });
                                            });
                                          });
                                          showAddGeneralLevelsButton =
                                          false;
                                        });
                                      })
                                      : null,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 50.0, bottom: 50.0, left: 60.0),
                                  child: Row(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Checkbox(
                                        value: showSpecificLevelsPerBuilding,
                                        onChanged: (valueChanged) {
                                          setState(() =>
                                          showSpecificLevelsPerBuilding =
                                              valueChanged);
                                        },
                                      ),
                                      Text(
                                        '$NIVELES específicos por edificio',
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                            fontSize: 30.0,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  ),
                                ),
                                showSpecificLevelsPerBuilding
                                    ? Table(
                                  children: <TableRow>[
                                    rowField(
                                        title: EDIFICIO,
                                        child: nombresDeEdificios !=
                                            null
                                            ? answerContainer(
                                          child:
                                          AutoCompleteTextField(
                                            keyboardType:
                                            TextInputType
                                                .number,
                                            suggestions:
                                            nombresDeEdificios,
                                            onChanged:
                                                (valueChanged) {
                                              setState(() {
                                                selectedBuilding =
                                                    valueChanged;
                                              });
                                            },
                                          ),
                                        )
                                            : CircularProgressIndicator()),
                                    rowField(
                                        title: 'Simples',
                                        child: NumericTextField(
                                          decimal: false,
                                          maxLength: 3,
                                          onChanged: (valueChanged) {
                                            setState(() {
                                              amountOfSpecificSimpleLevels =
                                                  int.tryParse(
                                                      valueChanged);
                                              swipeShowAddSpecificLevelButton();
                                            });
                                          },
                                        ),
                                        info: CANTIDAD.toUpperCase()),
                                    rowField(
                                        title: 'Sotanos',
                                        child: NumericTextField(
                                          decimal: false,
                                          maxLength: 3,
                                          onChanged: (valueChanged) {
                                            setState(() {
                                              amountOfSpecificBasements =
                                                  int.tryParse(
                                                      valueChanged);
                                              swipeShowAddSpecificLevelButton();
                                            });
                                          },
                                        ),
                                        info: CANTIDAD.toUpperCase()),
                                    rowField(
                                      title: 'Especiales',
                                      child: Container(
                                        margin: EdgeInsets.only(
                                            right: 30.0),
                                        child: GrowingTable(
                                          initialNumberOfRows: 0,
                                          onChanged:
                                          specificSpecialLevelUpdate,
                                          onSubmitted:
                                          specificSpecialLevelUpdate,
                                          onIncreasePressed:
                                          increaseNumberOfSpecificSpecialLevelsFields,
                                          onDecreasePressed:
                                          decreaseNumberOfSpecificSpecialLevelsFields,
                                          textPrefix: '$NIVEL ',
                                          keyboardType:
                                          TextInputType.text,
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                                    : Container(),
                                Container(
                                  alignment: Alignment.center,
                                  child: showAddSpecificLevelsButton ==
                                      true &&
                                      selectedEntity != SELECCIONAR
                                      ? appButton(
                                      text: 'Agregar $NIVELES',
                                      onPressed: () {
                                        var selectedBuildingModel =
                                        obtainSelectedBuildingModel();
                                        setState(() {
                                          if (selectedBuildingModel !=
                                              null) {
                                            createNewLevels(
                                                amountOfSimpleLevels:
                                                amountOfSpecificSimpleLevels,
                                                amountOfBasements: amountOfSpecificBasements,
                                                specialLevels: specificSpecialLevels,
                                                buildingModels: <DMEdificio>[
                                                  selectedBuildingModel
                                                ]).then((value) async {
                                              niveles.clear();
                                              nombresDeNiveles.clear();
                                              var selectedEntityId =
                                                  obtainSelectedEntityModel()
                                                      .id;
                                              edificios.forEach(
                                                      (DMEdificio
                                                  building) async {
                                                    Future.delayed(
                                                        Duration(
                                                            milliseconds: 10),
                                                            () async {
                                                          var buildingLevels =
                                                          await levelsFrom(
                                                              selectedEntityId,
                                                              building.id);
                                                          niveles.addAll(
                                                              buildingLevels);
                                                          didChangeDependencies();
                                                        });
                                                  });
                                            });
                                          }
                                        });
                                      })
                                      : null,
                                ),
                              ],
                            )
                                : null,
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            margin: const EdgeInsets.only(
                                left: 0.0, top: 30.0, bottom: 60.0),
                            child: showAddBuildingsButton == false &&
                                selectedEntity != SELECCIONAR &&
                                amountOfBuildings != 0 &&
                                amountOfBuildings != null &&
                                niveles != null
                                ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 60.0, top: 30.0, bottom: 60.0),
                                  child: Text(
                                    ESPACIOS,
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        fontSize: 50.0,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: 50.0, left: 60.0),
                                  child: Text(
                                    '$ESPACIOS comunes a todos los $NIVELES',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        fontSize: 30.0,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                                Table(
                                  children: <TableRow>[
                                    rowField(
                                        title: 'Simples',
                                        child: NumericTextField(
                                          decimal: false,
                                          maxLength: 3,
                                          onChanged: (valueChanged) {
                                            setState(() {
                                              amountOfSimpleSpaces =
                                                  int.tryParse(valueChanged);
                                              swipeShowAddGeneralSpaceButton();
                                            });
                                          },
                                        ),
                                        info: CANTIDAD.toUpperCase()),
                                    rowField(
                                        title: 'Escaleras',
                                        child: NumericTextField(
                                          decimal: false,
                                          maxLength: 3,
                                          onChanged: (valueChanged) {
                                            setState(() {
                                              amountOfBasements =
                                                  int.tryParse(valueChanged);
                                              swipeShowAddGeneralSpaceButton();
                                            });
                                          },
                                        ),
                                        info: CANTIDAD.toUpperCase()),
                                    rowField(
                                        title: 'Especiales',
                                        child: Container(
                                          margin:
                                          EdgeInsets.only(right: 30.0),
                                          child: GrowingTable(
                                            initialNumberOfRows: 0,
                                            onChanged: specialSpacesUpdate,
                                            onSubmitted: specialSpacesUpdate,
                                            onIncreasePressed:
                                            increaseNumberOfSpecialSpacesFields,
                                            onDecreasePressed:
                                            decreaseNumberOfSpecialSpacesFields,
                                            textPrefix: '$NIVEL ',
                                            keyboardType: TextInputType.text,
                                          ),
                                        ),
                                        info: AGREGAR_NIVEL),
                                  ],
                                ),
                                waitForSpacesInsertion == false
                                    ? Container(
                                  alignment: Alignment.center,
                                  child: showAddGeneralSpacesButton ==
                                      true &&
                                      showAddGeneralLevelsButton == false &&
                                      selectedEntity != SELECCIONAR
                                      ? appButton(
                                      text: 'Agregar $ESPACIOS',
                                      onPressed: () {
                                        setState(() {
                                          createNewSpaces(
                                            amountOfSimpleSpaces:
                                            amountOfSimpleSpaces,
                                            amountOfStairs:
                                            amountOfStairs,
                                            specialSpaces:
                                            specialSpaces,
                                          ).then((value) {
                                            setState(() {
                                              waitForSpacesInsertion =
                                              false;
                                            });
                                          });
                                          showAddGeneralSpacesButton =
                                          false;
                                        });
                                      })
                                      : null,
                                )
                                    : Container(
                                  alignment: Alignment.center,
                                  child: CircularProgressIndicator(),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 50.0, bottom: 50.0, left: 60.0),
                                  child: Row(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Checkbox(
                                        value: showSpecificSpacesPerLevel,
                                        onChanged: (valueChanged) {
                                          setState(() =>
                                          showSpecificSpacesPerLevel =
                                              valueChanged);
                                        },
                                      ),
                                      Text(
                                        '$ESPACIOS específicos por $NIVEL',
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                            fontSize: 30.0,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  ),
                                ),
                                showSpecificSpacesPerLevel
                                    ? Table(
                                  children: <TableRow>[
                                    rowField(
                                        title: EDIFICIO,
                                        child: nombresDeNiveles != null
                                            ? answerContainer(
                                          child:
                                          AutoCompleteTextField(
                                            keyboardType:
                                            TextInputType
                                                .number,
                                            suggestions:
                                            specificNamesOfSpaceBuildings,
                                            onChanged:
                                                (valueChanged) {
                                              setState(() {
                                                selectedSpaceBuilding =
                                                    valueChanged;
                                              });
                                            },
                                            onTap: () async{
                                              var entityId = obtainSelectedEntityModel().id;
                                              var specificSelectedBuildings = await buildingsFromEntity(entityId);
                                              setState(() {
                                                specificNamesOfSpaceBuildings = specificSelectedBuildings.map<String>((building){
                                                  return fromBase64Url(building.edificio);
                                                }).toList();
                                              });
                                            },
                                            onSubmitted: (valueChanged) async{
                                              var entityId = obtainSelectedEntityModel().id;
                                              selectedSpaceBuilding = valueChanged;
                                              var buildingId = obtainSelectedBuildingModel(buildingCode: selectedSpaceBuilding).id;
                                              nivelesForSpaces = await levelsFrom(entityId, buildingId);
                                              setState(() {
                                                specificNamesOfLevels = nivelesForSpaces.map<String>((level){
                                                  return fromBase64Url(level.nivel);
                                                }).toList();
                                              });
                                            },
                                          ),
                                        )
                                            : CircularProgressIndicator()),
                                    rowField(
                                        title: NIVEL,
                                        child: nombresDeNiveles != null
                                            ? answerContainer(
                                          child:
                                          AutoCompleteTextField(
                                            keyboardType:
                                            TextInputType
                                                .number,
                                            suggestions:
                                            specificNamesOfLevels,
                                            onChanged:
                                                (valueChanged) {
                                              setState(() {
                                                selectedLevel =
                                                    valueChanged;
                                              });
                                            },
                                          ),
                                        )
                                            : CircularProgressIndicator()),
                                    rowField(
                                        title: 'Simples',
                                        child: NumericTextField(
                                          decimal: false,
                                          maxLength: 3,
                                          onChanged: (valueChanged) {
                                            setState(() {
                                              amountOfSpecificSimpleSpaces =
                                                  int.tryParse(
                                                      valueChanged);
                                              swipeShowAddSpecificSpaceButton();
                                            });
                                          },
                                        ),
                                        info: CANTIDAD.toUpperCase()),
                                    rowField(
                                        title: 'Escaleras',
                                        child: NumericTextField(
                                          decimal: false,
                                          maxLength: 3,
                                          onChanged: (valueChanged) {
                                            setState(() {
                                              amountOfSpecificBasements =
                                                  int.tryParse(
                                                      valueChanged);
                                              swipeShowAddSpecificSpaceButton();
                                            });
                                          },
                                        ),
                                        info: CANTIDAD.toUpperCase()),
                                    rowField(
                                        title: 'Especiales',
                                        child: Container(
                                          margin: EdgeInsets.only(
                                              right: 30.0),
                                          child: GrowingTable(
                                            initialNumberOfRows: 0,
                                            onChanged:
                                            specificSpecialLevelUpdate,
                                            onSubmitted:
                                            specificSpecialLevelUpdate,
                                            onIncreasePressed:
                                            increaseNumberOfSpecificSpecialSpacesFields,
                                            onDecreasePressed:
                                            decreaseNumberOfSpecificSpecialSpacesFields,
                                            textPrefix: '$NIVEL ',
                                            keyboardType:
                                            TextInputType.text,
                                          ),
                                        ),
                                        info: AGREGAR_NIVEL),
                                  ],
                                )
                                    : Container(),
                                waitForSpacesInsertion == false
                                    ? Container(
                                  alignment: Alignment.center,
                                  child: showAddSpecificSpacesButton ==
                                      true &&
                                      showAddGeneralLevelsButton == false &&
                                      selectedEntity != SELECCIONAR
                                      ? appButton(
                                      text: 'Agregar $ESPACIOS',
                                      onPressed: () {
                                        var selectedLevelModel;
                                        nivelesForSpaces.forEach((level){
                                          if(fromBase64Url(level.nivel) == selectedLevel){
                                           selectedLevelModel = level;
                                          }
                                        });
                                        setState(() {
                                          if (selectedLevelModel !=
                                              null) {
                                            createNewSpaces(
                                                amountOfSimpleSpaces:
                                                amountOfSimpleSpaces,
                                                amountOfStairs: amountOfStairs,
                                                specialSpaces: specialSpaces,
                                                levelModels: <DMNivel>[
                                                  selectedLevelModel
                                                ]).then((value) {
                                              setState(() {
                                                waitForSpacesInsertion =
                                                false;
                                              });
                                            });
                                          }
                                        });
                                      })
                                      : null,
                                )
                                    : Container(
                                  alignment: Alignment.center,
                                  child: CircularProgressIndicator(),
                                ),
                              ],
                            )
                                : null,
                          ),
                        ],
                      ),
                    ),
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(18.0),
                        side: BorderSide(color: Colors.grey[50])),
                  ),
                ],
              ),
            )),
      ),
    );
  }

  TableRow rowField({String title, Widget child, String info}) {
    return TableRow(children: tableQuestion(title, child, info));
  }

  Future<void> createNewBuildings(int amountOfBuildings) async {
    var selectedEntityId = obtainSelectedEntityModel().id;
    var entityBuildings = await buildingsFromEntity(selectedEntityId);
    var entityBuildingsCode =
    entityBuildings.map<String>((building) => building.edificio).toList();
    var buildings = List.generate(amountOfBuildings + 1, (int buildingIndex) {
      var buildingCode = simpleStructureCodeGenerator(buildingIndex);
      buildingCode = toBase64Url(buildingCode);
      return DMEdificio(
        idDeLaEntidad: selectedEntityId,
        edificio: buildingCode,
      );
    });
    buildings.forEach((DMEdificio building) {
      if (entityBuildings == null ||
          entityBuildings.length == 0 ||
          !entityBuildingsCode.contains(building.edificio)) {
        insertInTable(building, EDIFICIOS);
      }
    });

    if (entityBuildings != null && buildings.length < entityBuildings.length) {
      var extrabuildings = entityBuildings.sublist(buildings.length);
      extrabuildings.forEach((DMEdificio building) {
        deleteById(table: EDIFICIOS, id: building.id);
        delete(
            table: NIVELES,
            where: '$ID_DE_LA_ENTIDAD = ? AND $ID_DEL_EDIFICIO = ?',
            whereArgs: [selectedEntityId, building.id]);
        delete(
            table: ESPACIOS,
            where: '$ID_DE_LA_ENTIDAD = ? AND $ID_DEL_EDIFICIO = ?',
            whereArgs: [selectedEntityId, building.id]);
      });
    }
  }

  Future<void> createNewLevels({int amountOfSimpleLevels,
    int amountOfBasements,
    List<String> specialLevels,
    List<DMEdificio> buildingModels}) async {
    if (buildingModels == null) {
      buildingModels = edificios;
    }
    var selectedEntityId = obtainSelectedEntityModel().id;

    buildingModels.forEach((DMEdificio building) {
      var buildingId = building.id;
      delete(
          table: NIVELES,
          where: '$ID_DE_LA_ENTIDAD = ? AND $ID_DEL_EDIFICIO = ?',
          whereArgs: [selectedEntityId, buildingId]);
      delete(
          table: ESPACIOS,
          where: '$ID_DE_LA_ENTIDAD = ? AND $ID_DEL_EDIFICIO = ?',
          whereArgs: [selectedEntityId, buildingId]);

      if (specialLevels.length > 0) {
        specialLevels.forEach((String levelCode) {
          levelCode = toBase64Url(levelCode);
          if (levelCode != null || levelCode != '') {
            Future.delayed(Duration(milliseconds: 100), () {
              insertInTable(
                  DMNivel(
                      idDeLaEntidad: selectedEntityId,
                      idDelEdificio: buildingId,
                      nivel: levelCode),
                  NIVELES);
            });
          }
        });
      }

      var generatedBasements =
      List.generate(amountOfBasements + 1, (int levelIndex) {
        var levelCode;
        levelCode = basementCodeGenerator(levelIndex);
        levelCode = toBase64Url(levelCode);
        return DMNivel(
            idDeLaEntidad: selectedEntityId,
            idDelEdificio: buildingId,
            nivel: levelCode);
      });

      generatedBasements.forEach((DMNivel level) {
        Future.delayed(Duration(milliseconds: 100), () {
          insertInTable(level, NIVELES);
        });
      });

      var generatedLevels =
      List.generate(amountOfSimpleLevels + 1, (int levelIndex) {
        var levelCode;
        levelCode = simpleStructureCodeGenerator(levelIndex);
        levelCode = toBase64Url(levelCode);
        return DMNivel(
            idDeLaEntidad: selectedEntityId,
            idDelEdificio: buildingId,
            nivel: levelCode);
      });

      generatedLevels.forEach((DMNivel level) {
        Future.delayed(Duration(milliseconds: 100), () {
          insertInTable(level, NIVELES);
        });
      });
    });
  }

  Future<void> createNewSpaces({int amountOfSimpleSpaces,
    int amountOfStairs,
    List<String> specialSpaces,
    List<DMNivel> levelModels}) async {

    waitForSpacesInsertion = true;
    var buildingId;
    var levelId;
    if (levelModels == null) {
      levelModels = niveles;
    }
    var selectedEntityId = obtainSelectedEntityModel().id;
    levelModels.forEach((DMNivel level) {
      if(levelModels == niveles){
        buildingId = level.idDelEdificio;

      }
      levelId = level.id;

      delete(
          table: ESPACIOS,
          where:
          '$ID_DE_LA_ENTIDAD = ? AND $ID_DEL_EDIFICIO = ? AND $ID_DEL_NIVEL = ?',
          whereArgs: [selectedEntityId, buildingId, levelId]);

      if (specialSpaces.length > 0) {
        specialSpaces.forEach((String spaceCode) {
          spaceCode = toBase64Url(spaceCode);
          if (spaceCode != null || spaceCode != '') {
            Future.delayed(Duration(milliseconds: 100), () {
              insertInTable(
                  DMEspacio(
                      idDeLaEntidad: selectedEntityId,
                      idDelEdificio: buildingId,
                      idDelNivel: levelId,
                      espacio: spaceCode),
                  ESPACIOS);
            });
          }
        });
      }

      var generatedStairs = List.generate(amountOfStairs + 1, (int levelIndex) {
        var spaceCode;
        spaceCode = stairCodeGenerator(levelIndex);
        spaceCode = toBase64Url(spaceCode);
        return DMEspacio(
            idDeLaEntidad: selectedEntityId,
            idDelEdificio: buildingId,
            idDelNivel: levelId,
            espacio: spaceCode);
      });

      generatedStairs.forEach((DMEspacio space) {
        Future.delayed(Duration(milliseconds: 10), () {
          insertInTable(space, ESPACIOS);
        });
      });

      var generatedSpaces =
      List.generate(amountOfSimpleSpaces + 1, (int levelIndex) {
        var spaceCode;
        spaceCode = simpleStructureCodeGenerator(levelIndex);
        spaceCode = toBase64Url(spaceCode);
        return DMEspacio(
            idDeLaEntidad: selectedEntityId,
            idDelEdificio: buildingId,
            idDelNivel: levelId,
            espacio: spaceCode);
      });

      generatedSpaces.forEach((DMEspacio space) {
        Future.delayed(Duration(milliseconds: 10), () {
          insertInTable(space, ESPACIOS);
        });
      });
    });

    var selectedMapsSpaces = await selectAll(ESPACIOS);
    var selectedSpaces = getSpacesFromList(selectedMapsSpaces);
    selectedSpaces.forEach((space){
      var spaceId = space.id;
      var entityId = space.idDeLaEntidad;
      var buildingId = space.idDelEdificio;
      var levelId = space.idDelNivel;
      var code = space.espacio;
      print('id $spaceId');
      print('$ID_DE_LA_ENTIDAD $entityId');
      print('$ID_DEL_EDIFICIO $buildingId');
      print('$ID_DEL_NIVEL $levelId');
      print('$ESPACIO $code');
    });

  }

  bool areAnyCommonLevelNumberIsNotEmpty() {
    return (amountOfSimpleLevels != null && amountOfSimpleLevels != 0) ||
        (amountOfBasements != null && amountOfBasements != 0) ||
        (specialLevels.length > 0);
  }

  bool areAnySpecificLevelNumberIsNotEmpty() {
    return (amountOfSpecificSimpleLevels != null &&
        amountOfSpecificSimpleLevels != 0) ||
        (amountOfSpecificBasements != null && amountOfSpecificBasements != 0) ||
        (specificSpecialLevels.length > 0);
  }

  bool areAnyCommonSpaceNumberIsNotEmpty() {
    return (amountOfSimpleSpaces != null && amountOfSimpleSpaces != 0) ||
        (amountOfStairs != null && amountOfStairs != 0) ||
        (specialSpaces.length > 0);
  }

  bool areAnySpecificSpaceNumberIsNotEmpty() {
    return (amountOfSpecificSimpleSpaces != null &&
        amountOfSpecificSimpleSpaces != 0) ||
        (amountOfSpecificStairs != null && amountOfSpecificStairs != 0) ||
        (specificSpecialSpaces.length > 0);
  }

  DMEntidad obtainSelectedEntityModel() {
    var entityNameIndex = obtainSelectedEntityIndex();
    return entidades.elementAt(entityNameIndex - 1);
  }

  int obtainSelectedEntityIndex() {
    return nombresDeEntidades.indexOf(selectedEntity);
  }

  DMEdificio obtainSelectedBuildingModel({String buildingCode}) {
    var buildingNameIndex = obtainSelectedBuildingIndex(buildingCode: buildingCode);
    if (buildingNameIndex >= 0) {
      return edificios.elementAt(buildingNameIndex);
    }
    return null;
  }

  int obtainSelectedBuildingIndex({String buildingCode}) {
    if(buildingCode == null) {
      return nombresDeEdificios.indexOf(selectedBuilding);
    }else{
      return nombresDeEdificios.indexOf(buildingCode);
    }
  }

  DMNivel obtainSelectedLevelModel({String levelCode}) {
    var levelNameIndex = obtainSelectedLevelIndex();
    if (levelNameIndex >= 0) {
      if(levelCode == null){
        return niveles.elementAt(levelNameIndex);
      }else{
        return nivelesForSpaces.elementAt(levelNameIndex);
      }

    } else {
      return null;
    }
  }

  int obtainSelectedLevelIndex({String levelCode}) {
    if(levelCode == null){
      return nombresDeNiveles.indexOf(selectedLevel);
    }else{
      return specificNamesOfLevels.indexOf(levelCode);
    }

  }

  void specialLevelsUpdate(String level, int levelIndex) {
    specialLevels.removeAt(levelIndex);
    specialLevels.insert(levelIndex, level);
  }

  void swipeShowAddGeneralLevelButton() {
    areAnySpecificLevelNumberIsNotEmpty()
        ? showAddGeneralLevelsButton = true
        : showAddGeneralLevelsButton = false;
  }

  void increaseNumberOfSpecialLevelsFields() {
    setState(() => specialLevels.add(''));
  }

  void decreaseNumberOfSpecialLevelsFields() {
    setState(() => specialLevels.removeLast());
  }

  void specificSpecialLevelUpdate(String level, int levelIndex) {
    specificSpecialLevels.removeAt(levelIndex);
    specificSpecialLevels.insert(levelIndex, level);
    swipeShowAddSpecificLevelButton();
  }

  void swipeShowAddSpecificLevelButton() {
    areAnySpecificLevelNumberIsNotEmpty()
        ? showAddSpecificLevelsButton = true
        : showAddSpecificLevelsButton = false;
  }

  void increaseNumberOfSpecificSpecialLevelsFields() {
    setState(() => specificSpecialLevels.add(''));
  }

  void decreaseNumberOfSpecificSpecialLevelsFields() {
    setState(() => specificSpecialLevels.removeLast());
  }

  void specialSpacesUpdate(String level, int levelIndex) {
    specialSpaces.removeAt(levelIndex);
    specialSpaces.insert(levelIndex, level);
    swipeShowAddGeneralSpaceButton();
  }

  void swipeShowAddGeneralSpaceButton() {
    areAnyCommonSpaceNumberIsNotEmpty()
        ? showAddGeneralSpacesButton = true
        : showAddGeneralSpacesButton = false;
  }

  void increaseNumberOfSpecialSpacesFields() {
    setState(() => specialSpaces.add(''));
  }

  void decreaseNumberOfSpecialSpacesFields() {
    setState(() => specialSpaces.removeLast());
  }

  void specificSpecialSpaceUpdate(String level, int levelIndex) {
    specificSpecialSpaces.removeAt(levelIndex);
    specificSpecialSpaces.insert(levelIndex, level);
    swipeShowAddSpecificSpaceButton();
  }

  void swipeShowAddSpecificSpaceButton() {
    areAnySpecificSpaceNumberIsNotEmpty()
        ? showAddSpecificSpacesButton = true
        : showAddSpecificSpacesButton = false;
  }

  void increaseNumberOfSpecificSpecialSpacesFields() {
    setState(() => specificSpecialSpaces.add(''));
  }

  void decreaseNumberOfSpecificSpecialSpacesFields() {
    setState(() => specificSpecialSpaces.removeLast());
  }
}

Future<List<DMEdificio>> buildingsFromEntity(int entityId) async {
  var buildingsMapList = await selectFrom(EDIFICIOS,
      where: '$ID_DE_LA_ENTIDAD = ?', whereArgs: [entityId]);

  return getBuildingsFromList(buildingsMapList);
}

Future<List<DMNivel>> levelsFrom(int entityId, int buildingId) async {
  var buildingsMapList = await selectFrom(NIVELES,
      where: '$ID_DE_LA_ENTIDAD = ? AND $ID_DEL_EDIFICIO = ?',
      whereArgs: [entityId, buildingId]);

  return getLevelsFromList(buildingsMapList);
}

String simpleStructureCodeGenerator(int structureIndex) {
  if (structureIndex < 10) {
    return '00$structureIndex';
  } else if (structureIndex < 100) {
    return '0$structureIndex';
  } else {
    return structureIndex.toString();
  }
}

String basementCodeGenerator(int basementIndex) {
  if (basementIndex < 10) {
    return 'S0$basementIndex';
  } else {
    return 'S$basementIndex';
  }
}

String stairCodeGenerator(int stairIndex) {
  return 'CV$stairIndex';
}
