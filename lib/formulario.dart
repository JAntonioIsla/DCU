import 'package:dcu/camera_manager.dart';
import 'package:dcu/chip_group.dart';
import 'package:dcu/data_model_edificio.dart';
import 'package:dcu/data_model_formulario.dart';
import 'package:dcu/data_model_informacion_del_formulario.dart';
import 'package:dcu/database_manager.dart';
import 'package:dcu/dropdown_default_selector.dart';
import 'package:dcu/levantamiento.dart';
import 'package:dcu/lienzo_para_formato.dart';
import 'package:dcu/photo_record.dart';
import 'package:dcu/radiogroup_answer.dart';
import 'package:dcu/texfields.dart';
import 'package:dcu/toogle_group.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'json_data.dart';

const String SPINNER = 'spinner';
const String NUMERIC_TEXT_FIELD = 'numericTextField';
const String NUMERIC_TEXT_FIELD_DECIMAL = 'numericTextFieldDecimal';
const String TIME_TEXT_FIELD = 'timeTextField';
const String AUTOCOMPLETE_TEXT_FIELD = 'autoCompleteTextField';
const String TOOGLE_BUTTON_GROUP = 'toogleGroup';
const String TEXT_FIELD = 'textInputField';
const String MULTILINE_TEXT_FIELD = 'multilineTextInputField';
const String PHOTO_RECORD = 'photoRecord';
const String WIDE_MULTILINE_TEXT_FIELD = 'wideMultilineTextInputField';
const String RADIOGROUP = 'radioGroup';
const String CHIPGROUP = 'chipGroup';

final TextStyle _questionStyle = TextStyle(fontSize: 28.0);
final TextStyle _questionInfoStyle =
TextStyle(fontSize: 23.0, color: Colors.grey[600]);
final _paddingQuestion =
const EdgeInsets.only(left: 60.0, top: 0.0, bottom: 60.0);
final _paddingFreeTag =
const EdgeInsets.only(left: 60.0, top: 0.0, bottom: 0.0);


class FormFromJSON extends StatefulWidget{

  FormFromJSON({Key key,
    this.buildingInformationPath,
    this.category,
  })
      : super(key:key);

  final String buildingInformationPath;
  final String category;

  @override
  _FormFromJSONState createState() => _FormFromJSONState();

}

class _FormFromJSONState extends State<FormFromJSON>{

  Map<String, dynamic> _buildingInformation;
  int _categoryId;
  int _formId;
  String _title = '';
  List<dynamic> _questions = new List<dynamic>();
  List<Widget> _children = new List<Widget>();
  List<String> answers = new List<String>();

  @override
  void didChangeDependencies() async{
    _buildingInformation = await retrieveFormBuildingInformation(context, widget.buildingInformationPath);
    _title = _buildingInformation['nombre'];
    _questions = _buildingInformation['preguntas'];
    obtainCategoryId();
    obtainFormId();
    if(_categoryId == null){
      _categoryId == 1;
    }
    if(_formId == null){

    }

    generateQuestionStructure();
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          FormLayout(
            children: _children,
            onTap: () async{
              Map<String,String> infoMap = convertAnswersToMap();
              if(_title == 'Edificio'){
                var edificioMap = await selectFrom(EDIFICIOS, where: '$ID_DE_LA_ENTIDAD = ? AND id = ?', whereArgs: [entity.id, building.id]);
                var edificioModel = getBuildingsFromList(edificioMap).elementAt(0);
                insertInTable(
                    DMEdificio(
                        id: edificioModel.id,
                        idDeLaEntidad: edificioModel.idDeLaEntidad,
                        edificio: edificioModel.edificio,
                        informacionDelEdificio: infoMap.toString()
                    )
                , EDIFICIOS);
              }else{
                print('$ID_DE_LA_ENTIDAD' + entity.id.toString());
                print('$ID_DEL_EDIFICIO' + building.id.toString());
                print('$ID_DEL_NIVEL' + level.id.toString());
                print('$ID_DEL_ESPACIO' + space.id.toString());
                print('$ID_DE_LA_CATEGORIA $_categoryId');
                print('$ID_DEL_FORMULARIO $_formId');
                print('InfoMap' + infoMap.toString());

                insertInTable(
                  DMInformacionDelFormulario(
                    idDeLaEntidad: entity.id,
                    idDelEdificio: building.id,
                    idDelNivel: level.id,
                    idDelEspacio: space.id,
                    idDeLaCategoria: _categoryId,
                    idDelFormulario: _formId,
                    informacionDelFormulario: toBase64Url(infoMap.toString())
                  ), INFORMACION_DE_LOS_FORMULARIOS
                );

                var infoFormMaps = await selectFrom(INFORMACION_DE_LOS_FORMULARIOS,
                  where: '$ID_DE_LA_ENTIDAD = ? AND $ID_DEL_EDIFICIO = ? AND $ID_DEL_NIVEL = ? AND $ID_DEL_ESPACIO = ? AND $ID_DE_LA_CATEGORIA = ? AND $ID_DEL_FORMULARIO = ?',
                  whereArgs: [entity.id, building.id, level.id, space.id, _categoryId, _formId],
                );
                var infoForms = getInformationOfFormsFromList(infoFormMaps);


                print('RESULTADO DE LA CONSULTA');
                infoForms.forEach((DMInformacionDelFormulario info){
                  print('id: ' + info.id.toString());
                  print('$ID_DE_LA_ENTIDAD ' + info.idDeLaEntidad.toString());
                  print('$ID_DEL_EDIFICIO ' + info.idDelEdificio.toString());
                  print('$ID_DEL_NIVEL ' + info.idDelNivel.toString());
                  print('$ID_DEL_ESPACIO ' + info.idDelEspacio.toString());
                  print('$ID_DE_LA_CATEGORIA ' + info.idDeLaCategoria.toString());
                  print('$ID_DEL_FORMULARIO ' + info.idDelFormulario.toString());
                  print('$INFORMACION_DEL_FORMULARIO ' + fromBase64Url(info.informacionDelFormulario));
                });

              }
            },
          ),
        ],
      ),
    );
  }

  Map<String, String> convertAnswersToMap(){
    var mapEntries = answers.map<MapEntry<String, String>>(
            (element){
          var splitAnswer = element.split('::');
          return MapEntry(splitAnswer[0], splitAnswer[1]);
        }
    );
    return Map.fromEntries(mapEntries);
  }

  void obtainCategoryId() async{
    var categoryName = widget.category != null? widget.category
        : _buildingInformation.containsKey('categoria')? _buildingInformation['categoria']
        : 'Otra';
    var categoryMap = await selectFrom(CATEGORIAS, where: '$NOMBRE_DE_LA_CATEGORIA = ?', whereArgs: [toBase64Url(categoryName)]);
    var categoryModel = getCategoriesFromList(categoryMap);
    if(categoryName != null && categoryModel.length > 0){
      _categoryId = categoryModel.elementAt(0).id;
      debugPrint(_categoryId.toString());
    }

  }

  void obtainFormId() async{
    var formularioMap = await selectFrom(FORMULARIOS, where: '$NOMBRE_DEL_FORMULARIO = ?', whereArgs: [toBase64Url(_title)]);
    var formModel = getFormsFromList(formularioMap);
    if(formModel != null && formModel.length > 0){
      _formId = formModel.first.id;
      debugPrint(_formId.toString());
    }else{
      var auxMap = await selectAll(FORMULARIOS);
      var auxFormsMap = getFormsFromList(auxMap);
      debugPrint("TAMAÑO DE LISTA: " + auxFormsMap.length.toString());
      debugPrint("TITULO: $_title");

      auxFormsMap.forEach((DMFormulario formNameModel){
        debugPrint("NOMBRE DEL FORMULARIO: " + fromBase64Url(formNameModel.nombreDelFormulario));
        /*if(formNameModel.nombreDelFormulario == _title){
          debugPrint("COINCIDENCIA EN: $_title");
          debugPrint("INDICE DE COINCIDENCIA: " + formNameModel.id.toString());
        }*/
      });

    }

  }

  Widget formTitle(){
    return Container(
      margin: const EdgeInsets.only(left: 60.0, top: 30.0, bottom: 60.0),
      child: Text(
        _title,
        textAlign: TextAlign.start,
        style: TextStyle(
            fontSize: 50.0,
            color: Colors.black,
            fontWeight: FontWeight.w600),
      ),
    );
  }

  void generateQuestionStructure(){
    _children.add(formTitle());
    if(_questions.length > 0){
      if(_children.length>1) _children.removeLast();
      _questions.forEach((dynamic questionInfo){ _children.add(Container()); });
      _questions.forEach((dynamic questionInfo){
        var questionIndex = _questions.indexOf(questionInfo);
        Map<String,dynamic> info = questionInfo;
        var nombre = info['pregunta'];
        var tipo = info['tipo'];
        var descripcion;
        var toUppercase = true;
        var catalogo;
        var maxLength;
        var opcion1;
        var opcion2;
        if(info.containsKey('descripcion')) descripcion = info['descripcion'];
        if(info.containsKey('uppercase')) toUppercase = info['uppercase'];
        if(info.containsKey('catalogo')) catalogo = info['catalogo'];
        if(info.containsKey('maxLength')) maxLength = info['maxLength'];
        if(info.containsKey('opcion1')) {
          opcion1 = info['opcion1'];
          opcion2 = info['opcion2'];
        }
        answers.add('');

        buildQuestion(
          nombre: nombre,
          tipo: tipo,
          descripcion: descripcion,
          uppercaseDescription: toUppercase,
          catalogo: catalogo,
          opcion1: opcion1,
          opcion2: opcion2,
          maxLength: maxLength,
          valueIndex: questionIndex,
        );

      });
    }else{
      _children.add(CircularProgressIndicator());
    }
  }

  bool thisQuestionWillBeContainedByTableBecauseOf(String questionType){

    switch(questionType) {
      case SPINNER:
      case NUMERIC_TEXT_FIELD:
      case NUMERIC_TEXT_FIELD_DECIMAL:
      case TIME_TEXT_FIELD:
      case AUTOCOMPLETE_TEXT_FIELD:
      case TOOGLE_BUTTON_GROUP:
      case TEXT_FIELD:
      case MULTILINE_TEXT_FIELD:
        return true;
      case PHOTO_RECORD:
      case WIDE_MULTILINE_TEXT_FIELD:
      case RADIOGROUP:
      case CHIPGROUP:
        return false;
      default:
        return false;
    }

  }


  void buildQuestion({
    String nombre,
    String tipo,
    String descripcion,
    bool uppercaseDescription,
    String catalogo,
    String opcion1,
    String opcion2,
    int maxLength,
    int valueIndex,
  }) async{
    if(thisQuestionWillBeContainedByTableBecauseOf(tipo)){
      print(nombre);
      var childrenRows = List<TableRow>();
      var widget = await widgetOfType(tipo: tipo, nombre: nombre,
          descripcion: descripcion, catalogo: catalogo,
          opcion1: opcion1, opcion2: opcion2,
          maxLength: maxLength, valueIndex: valueIndex
      );

      childrenRows.add(
          TableRow(
              children: tableQuestion(
                nombre,
                widget,
                descripcion != null? uppercaseDescription == true? descripcion.toUpperCase()
                    : descripcion
                    : descripcion
              )
          )
      );
      setState(() {
        _children[valueIndex+1] = Table(children: childrenRows);
      });
    }else{
      print(nombre);
      var widget = await widgetOfType(tipo: tipo, nombre: nombre,
          descripcion: descripcion, catalogo: catalogo,
          opcion1: opcion1, opcion2: opcion2,
          maxLength: maxLength, valueIndex: valueIndex);
      setState(() {
        _children[valueIndex+1] = widget;
      });

    }
  }

  Future<Widget> widgetOfType({@required tipo,
    String nombre,
    String descripcion,
    String catalogo,
    String opcion1,
    String opcion2,
    int maxLength,
    int valueIndex
  }) async{
    var catalog;
    if(catalogo != null) catalog = await retrieveStringCatalog(context, catalogo);
    switch(tipo) {
      case SPINNER:
        answers[valueIndex] = '$nombre::' + catalog[0][0];
        return DropdownDefaultSelector(textItems: catalog[0], value: answers[valueIndex].split('::').elementAt(1),
            onChanged: (valueChanged){
              answers[valueIndex] = '$nombre::$valueChanged';
              print(answers);
            });
      case NUMERIC_TEXT_FIELD:
        answers[valueIndex] = '$nombre::S/I';
        return NumericTextField(decimal: false, maxLength: maxLength,
          onChanged: (valueChanged){
          answers[valueIndex] = valueChanged;
          print(answers);
          },
          onSubmitted: (valueChanged){
            answers[valueIndex] = '$nombre::$valueChanged';
            print(answers);
          },);
      case NUMERIC_TEXT_FIELD_DECIMAL:
        answers[valueIndex] = '$nombre::S/I';
        return NumericTextField(decimal: true, maxLength: maxLength,
          onChanged: (valueChanged){
          answers[valueIndex] = valueChanged;
          print(answers);
          },
          onSubmitted: (valueChanged){
            answers[valueIndex] = '$nombre::$valueChanged';
            print(answers);
          },);
      case TIME_TEXT_FIELD:
        answers[valueIndex] = '$nombre::S/I';
        return NumericTextField(maxLength: maxLength,
          keyboardType: TextInputType.datetime,
          onChanged: (valueChanged){
          answers[valueIndex] = valueChanged;
          print(answers);
          },
          onSubmitted: (valueChanged){
            answers[valueIndex] = '$nombre::$valueChanged';
            print(answers);
          },);
      case AUTOCOMPLETE_TEXT_FIELD:
        answers[valueIndex] = '$nombre::S/I';
        return answerContainer(
          child: AutoCompleteTextField(suggestions: catalog[0],
              onChanged: (valueChanged){
                answers[valueIndex] = '$nombre::$valueChanged';
                print(answers);
              },
            onSubmitted: (valueChanged){
              answers[valueIndex] = '$nombre::$valueChanged';
              print(answers);
            },
          ),
        );
      case TOOGLE_BUTTON_GROUP:
        answers[valueIndex] = '$nombre::S/I';
        return ToogleGroup(onChanged: (valueChanged){
          answers[valueIndex] = '$nombre::$valueChanged';
          print(answers);
        },
          affirmativeValue: opcion1, negativeValue: opcion2,);
      case TEXT_FIELD:
        answers[valueIndex] = '$nombre::S/I';
        return Container(
          margin: EdgeInsets.only(left: 60.0, right: 20.0),
          child: TextInputField(labelText: 'Escribe aquí',
            onChanged: (valueChanged){
              answers[valueIndex] = '$nombre::$valueChanged';
              print(answers);
            },
            onSubmitted:  (valueChanged){
              answers[valueIndex] = '$nombre::$valueChanged';
              print(answers);
            },
          ),
        );
      case MULTILINE_TEXT_FIELD:
        answers[valueIndex] = '$nombre::S/I';
        return answerContainer(
          child: MultilineTextInputField(
            decoration: defaultInputDecoration,
            style: defaultTextStyle,
            onChanged: (valueChanged){
              answers[valueIndex] = '$nombre::$valueChanged';
              print(answers);
            },
            onSubmitted: (valueChanged){
              answers[valueIndex] = '$nombre::$valueChanged';
              print(answers);
            },
          ),
        );
      case PHOTO_RECORD:
        answers[valueIndex] = '$nombre::[S/I]';
        var camera = obtainCameraAtPosition(0);
        return Padding(
          padding: const EdgeInsets.only(left: 60.0, right: 30.0, top: 20.0, bottom: 30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              questionText(
                  questionTag: nombre,
                  freeTag: true,
                  freeTagPadding: EdgeInsets.zero
              ),
              Container(
                margin: EdgeInsets.only(top: 10.0),
                  child: PhotoRecord(
                    onPictureHasBeenTaken: (picturePaths){
                      if(picturePaths != null && picturePaths != ''){
                        answers[valueIndex] = '$nombre::$picturePaths';
                      }
                      },
                    camera: camera,
                  )
              ),
            ],
          ),
        );
      case WIDE_MULTILINE_TEXT_FIELD:
        answers[valueIndex] = '$nombre::S/I';
        return Container();
      case RADIOGROUP:
        answers[valueIndex] = '$nombre::' + catalog[0][0];
        return Container(
          margin: _paddingQuestion,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              questionText(
                  questionTag: nombre,
                  freeTag: true,
                freeTagPadding: EdgeInsets.zero
              ),
              RadiogroupAnswer(selectableValues: catalog[0],
                onChanged: (valueChanged){
                  answers[valueIndex] = '$nombre::$valueChanged';
                  print(answers);
                },
              ),
            ],
          ),
        );
      case CHIPGROUP:
        answers[valueIndex] = '$nombre::[S/I]';
        return Container(
          margin: _paddingQuestion,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              questionText(
                  questionTag: nombre,
                  freeTag: true,
                freeTagPadding: EdgeInsets.zero,
                info: descripcion
              ),
              ChipGroup(options: catalog[0],
                maxWidth: 550.0,
                onChanged: (valueChanged){
                  answers[valueIndex] = '$nombre::$valueChanged';
                  print(answers);
                },
              ),
            ],
          ),
        );
      default:
        return Container();
    }
  }

  void rebuildState(){
    print(answers);
  }

}

List<Widget> tableQuestion(String question, Widget answer, [String info]) {
  List<Widget> widgets = [
    questionText(questionTag: question, info: info),
    Center(child: answer),
  ];
  return widgets;
}

Widget questionText({
  String questionTag,
  String info,
  bool freeTag=false,
  EdgeInsetsGeometry freeTagPadding
}) {
  if (info == null && freeTag==false) {
    return Container(
        margin: _paddingQuestion,
        child: Text(
          questionTag,
          style: _questionStyle,
        )
    );
  } else if(freeTag==true){
    return Container(
        margin: freeTagPadding == null? _paddingFreeTag : freeTagPadding,
        child: Text(
          questionTag,
          style: _questionStyle,
        )
    );
  } else if(freeTag==true && info != null){
    return Container(
        margin: freeTagPadding == null? _paddingFreeTag : freeTagPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              questionTag,
              style: _questionStyle,
            ),
            Text(
              info,
              style: _questionInfoStyle,
            )
          ],
        )
    );
  }else {
    return Container(
        margin: _paddingQuestion,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              questionTag,
              style: _questionStyle,
            ),
            Text(
              info,
              style: _questionInfoStyle,
            )
          ],
        )
    );
  }


}