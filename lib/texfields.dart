
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'lienzo_para_formato.dart';
import 'main.dart';

InputDecoration defaultInputDecoration = InputDecoration(enabledBorder: UnderlineInputBorder(
  borderSide: BorderSide(color: Colors.white,width: 1.0, style: BorderStyle.solid),
),
);

TextStyle defaultTextStyle = TextStyle(fontSize: 24.0, fontWeight: FontWeight.w600, color: hoverColor,height: 1);

class NumericTextField extends StatelessWidget{
  NumericTextField({Key key,
    this.enabled = true,
    this.decimal=true,
    this.signed=false,
    this.numericIcon=true,
    this.maxLength,
    this.width,
    this.onSubmitted,
    this.keyboardType,
    @required this.onChanged,
  })
      :super(key:key);
  final bool enabled;
  final bool decimal;
  final bool signed;
  final bool numericIcon;
  final int maxLength;
  final dynamic width;
  final ValueChanged<String> onSubmitted;
  final ValueChanged<String> onChanged;
  final TextInputType keyboardType;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          flex: numericIcon == true? 5 : 1,
          child: Container(
            margin: numericIcon == true? const EdgeInsets.only(left: 23.0) : const EdgeInsets.only(left: 0.0),
            child: answerContainer(
              width: width,
              child: TextField(
                keyboardType: keyboardType == null? TextInputType.numberWithOptions(decimal: this.decimal, signed: this.signed)
                    : keyboardType,
                textAlign: TextAlign.center,
                decoration: defaultInputDecoration,
                style: defaultTextStyle,
                maxLength: maxLength,
                onChanged: onChanged,
                onSubmitted: onSubmitted,
                enabled: enabled,
              ),
            ),
          ),
        ),
        numericIcon == true? Expanded(
            child: Container(
                alignment: Alignment.bottomLeft,
                margin: const EdgeInsets.only(left: 8.0),
                child: Image.asset('icons/boton_numerico.png', width: imageIconSize, height: imageIconSize,)
            )
        ) : Container(),
      ],
    );
  }

}

class TextInputField extends StatefulWidget{ // ignore: must_be_immutable
  TextInputField({Key key,
    @required this.labelText,
    @required this.onChanged,
    this.onSubmitted
  })
  : super(key:key);
  String labelText;
  bool isFocused=false;
  ValueChanged<String> onChanged;
  ValueChanged<String> onSubmitted;

  @override
  TextInputFieldState createState() => TextInputFieldState();

}

class TextInputFieldState extends State<TextInputField>{
  @override
  void initState() {
    widget.isFocused = false;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    final UnderlineInputBorder _underlineEnabledBorder = _underlineBorder(color: hoverColor);
    final UnderlineInputBorder _underlineFocusedBorder = _underlineBorder(color: accentColor);
    return TextField(
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        enabledBorder: _underlineEnabledBorder,
        focusedBorder: _underlineFocusedBorder,
        labelText: widget.labelText,
        labelStyle: TextStyle(
            color: !widget.isFocused?Colors.grey[600]:accentColor,
            fontStyle: FontStyle.italic
        )
      ),
      textAlignVertical: TextAlignVertical.bottom,
      onTap: (){
        setState(() {
          widget.isFocused = true;
        });

      },
      onSubmitted: (value){
        setState(() {
          widget.isFocused = false;
        });
        widget.onSubmitted(value);
      },
      onChanged: (value){
        widget.onChanged(value);
        },
    );
  }

  UnderlineInputBorder _underlineBorder({Color color}){
    return UnderlineInputBorder(
      borderSide: BorderSide(color: color,width: 1.0, style: BorderStyle.solid),
    );
  }
}

class MultilineTextInputField extends StatelessWidget{

  MultilineTextInputField({Key key,
    this.decoration,
    this.style,
    this.onChanged,
    this.onSubmitted,
  })
      : super(key:key);

  final InputDecoration decoration;
  final TextStyle style;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onSubmitted;

  final noBorder = UnderlineInputBorder(borderSide: const BorderSide(style: BorderStyle.none));
  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: TextInputType.multiline,
      maxLines: 3,
      maxLength: 500,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      decoration: decoration == null? InputDecoration(
        hintText: 'Escribe aquí',
        border: noBorder,
        focusedBorder: noBorder,
        enabledBorder: noBorder,
      ) : decoration,
      scrollPadding: const EdgeInsets.all(50.0),
      style: style == null? TextStyle(fontSize: 24.0, color: Colors.grey[600]) : style,
    );
  }
}

class AutoCompleteTextField extends StatefulWidget{

  AutoCompleteTextField({Key key,
    this.selectionAreaHeight = 200.0,
    this.selectionAreaWidth,
    this.selectionAreaElevation = 4.0,
    this.selectionAreaLeftOffset = 0.0,
    this.selectionAreaTopOffset = 5.0,
    this.selectionAreaAlignCenter = false,
    this.selectionAreaColor,
    this.selectionAreaDecoration,
    this.suggestionHoverColor,
    this.suggestionSplashColor,
    this.suggestionHighlightColor,
    this.suggestionHighlightElevation,
    this.suggestionElevation,
    this.suggestionColor,
    this.children,
    @required this.suggestions,
    @required this.onChanged,
    this.completionThreshold = 0,
    this.style,
    this.suggestionsMargin,
    this.suggestionsDecoration,
    this.suggestionsTextStyle = const TextStyle(fontSize: 24.0, color: Colors.black,),
    this.suggestionsContainerElevation,
    this.decoration,
    this.keyboardType,
    this.textInputAction,
    this.textCapitalization = TextCapitalization.none,
    this.strutStyle,
    this.textAlign = TextAlign.start,
    this.textAlignVertical,
    this.textDirection,
    this.readOnly = false,
    this.toolbarOptions,
    this.showCursor,
    this.autofocus = false,
    this.obscureText = false,
    this.autocorrect = true,
    this.enableSuggestions = true,
    this.maxLines = 1,
    this.minLines,
    this.expands = false,
    this.maxLength,
    this.maxLengthEnforced = true,
    this.onEditingComplete,
    this.onSubmitted,
    this.inputFormatters,
    this.enabled,
    this.cursorWidth = 2.0,
    this.cursorRadius,
    this.cursorColor,
    this.keyboardAppearance,
    this.scrollPadding = const EdgeInsets.all(20.0),
    this.dragStartBehavior = DragStartBehavior.start,
    this.enableInteractiveSelection = true,
    this.onTap,
    this.buildCounter,
    this.scrollController,
    this.scrollPhysics,
  }) : super(key:key);

  final double selectionAreaHeight;
  final double selectionAreaWidth;
  final double selectionAreaElevation;
  final double selectionAreaLeftOffset;
  final double selectionAreaTopOffset;
  final bool selectionAreaAlignCenter;
  final Color selectionAreaColor;
  final Decoration selectionAreaDecoration;
  final Color suggestionHoverColor;
  final Color suggestionSplashColor;
  final Color suggestionHighlightColor;
  final double suggestionHighlightElevation;
  final double suggestionElevation;
  final Color suggestionColor;
  final List<Widget> children;
  final List<String> suggestions;
  final ValueChanged<String> onChanged;
  final int completionThreshold;
  final TextStyle style;
  final EdgeInsets suggestionsMargin;
  final Decoration suggestionsDecoration;
  final TextStyle suggestionsTextStyle;
  final double suggestionsContainerElevation;
  final InputDecoration decoration;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final TextCapitalization textCapitalization;
  final StrutStyle strutStyle;
  final TextAlign textAlign;
  final TextAlignVertical textAlignVertical;
  final TextDirection textDirection;
  final bool readOnly;
  final ToolbarOptions toolbarOptions;
  final bool showCursor;
  final bool autofocus;
  final bool obscureText;
  final bool autocorrect;
  final bool enableSuggestions;
  final int maxLines;
  final int minLines;
  final bool expands;
  final int maxLength;
  final bool maxLengthEnforced;
  final VoidCallback onEditingComplete;
  final ValueChanged<String> onSubmitted;
  final List<TextInputFormatter> inputFormatters;
  final bool enabled;
  final double cursorWidth;
  final Radius cursorRadius;
  final Color cursorColor;
  final Brightness keyboardAppearance;
  final EdgeInsets scrollPadding;
  final DragStartBehavior dragStartBehavior;
  final bool enableInteractiveSelection;
  final VoidCallback onTap;
  final InputCounterWidgetBuilder buildCounter;
  final ScrollController scrollController;
  final ScrollPhysics scrollPhysics;

  @override
  _AutoCompleteTextFieldState createState() => _AutoCompleteTextFieldState();

}

class _AutoCompleteTextFieldState extends State<AutoCompleteTextField>{
  final FocusNode _focusNode = FocusNode();
  OverlayEntry _overlayEntry;
  TextEditingController _controller;

  var inputValue = '';
  List<Widget> childrenList;

  var isOverlayDisplayed = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _focusNode.addListener((){
      if(_focusNode.hasFocus){
        this._overlayEntry = this._createOverlayEntry();
        if(inputValue.length >= widget.completionThreshold) insertOverlay();
      }else{
        removeOverlay();
      }
    });
    childrenList =  widget.children == null?
    createSuggestionsFromList(widget.suggestions) : wrapWidgetsWithRaisedButton(widget.children);
  }
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      focusNode: this._focusNode,
      style: widget.style == null? defaultTextStyle : widget.style,
      onChanged: onTextChanged,
      decoration: widget.decoration == null? defaultInputDecoration : widget.decoration,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      textCapitalization: widget.textCapitalization,
      strutStyle: widget.strutStyle,
      textAlign: widget.textAlign,
      textAlignVertical: widget.textAlignVertical,
      textDirection: widget.textDirection,
      readOnly: widget.readOnly,
      toolbarOptions: widget.toolbarOptions,
      showCursor: widget.showCursor,
      autofocus: widget.autofocus,
      obscureText: widget.obscureText,
      autocorrect: widget.autocorrect,
      enableSuggestions: widget.enableSuggestions,
      maxLines: widget.maxLines,
      minLines: widget.minLines,
      expands: widget.expands,
      maxLength: widget.maxLength,
      maxLengthEnforced: widget.maxLengthEnforced,
      onEditingComplete: widget.onEditingComplete,
      onSubmitted: widget.onSubmitted,
      inputFormatters: widget.inputFormatters,
      enabled: widget.enabled,
      cursorWidth: widget.cursorWidth,
      cursorRadius: widget.cursorRadius,
      cursorColor: widget.cursorColor,
      keyboardAppearance: widget.keyboardAppearance,
      scrollPadding: widget.scrollPadding,
      dragStartBehavior: widget.dragStartBehavior,
      enableInteractiveSelection: widget.enableInteractiveSelection,
      onTap: widget.onTap,
      buildCounter: widget.buildCounter,
      scrollController: widget.scrollController,
      scrollPhysics: widget.scrollPhysics,
    );
  }

  void onTextChanged(String textChanged){
    setState(() {
      inputValue = textChanged;
      childrenList =  widget.children == null?
      createSuggestionsFromList(widget.suggestions) : wrapWidgetsWithRaisedButton(widget.children);
      removeOverlay();
      if(inputValue.length >= widget.completionThreshold) insertOverlay();
    });
    widget.onChanged(textChanged);

  }

  void autoCompleteWith(String selectedSuggestion){
    onTextChanged(selectedSuggestion);
    _controller.value = TextEditingValue(
        text: selectedSuggestion,
        selection: TextSelection(
            baseOffset: selectedSuggestion.length,
            extentOffset: selectedSuggestion.length,
            affinity: TextAffinity.downstream,
            isDirectional: false
        ),
        composing: TextRange(start: 0, end: selectedSuggestion.length)
    );
  }

  OverlayEntry _createOverlayEntry(){
    RenderBox renderBox = context.findRenderObject();
    var size = renderBox.size;
    var offset = renderBox.localToGlobal(Offset.zero);
    var topOffset;
    var leftOffset;
    var screenHeight = MediaQuery.of(context).size.height;

    if(widget.selectionAreaAlignCenter){
      leftOffset = (MediaQuery.of(context).size.width - size.width)/2;
    }else{
      leftOffset = offset.dx + widget.selectionAreaLeftOffset;
    }
    var heightThreshold = screenHeight*0.4;
    if(offset.dy < heightThreshold){
      topOffset = offset.dy + size.height + widget.selectionAreaTopOffset;
    }else if( offset.dy <= (0.55*screenHeight) && offset.dy >= screenHeight*0.4){
      topOffset = screenHeight/3.3 - size.height;
    }else {
      topOffset = screenHeight/2.8;
    }
    return OverlayEntry(
        builder: (context) => Positioned(
          left: leftOffset,
          top: topOffset,
          width: widget.selectionAreaWidth == null? size.width : widget.selectionAreaWidth,
          child: Material(
            elevation: widget.selectionAreaElevation,
            color: widget.selectionAreaColor,
            child: Container(
              constraints: BoxConstraints(maxHeight: widget.selectionAreaHeight),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: childrenList,
                ),
              ),
              color: widget.selectionAreaDecoration == null? widget.selectionAreaColor : null,
              decoration: widget.selectionAreaDecoration,
            ),
          ),
        )
    );
  }


  List<Widget> wrapWidgetsWithRaisedButton(List<Widget> widgets){
    return List<Widget>.generate(widget.children.length, (childIndex){
      var filterConditions = widget.suggestions.elementAt(childIndex).contains(inputValue) && inputValue.length >= widget.completionThreshold;
      var secondFilterConditions = inputValue == '' && widget.completionThreshold == 0;
      if(filterConditions || secondFilterConditions){
        return RaisedButton(
          child: widget.children.elementAt(childIndex),
          onPressed: (){
            autoCompleteWith(widget.suggestions.elementAt(childIndex));
          },
          color: widget.suggestionColor,
          hoverColor: widget.suggestionHoverColor,
          splashColor: widget.suggestionSplashColor,
          highlightColor: widget.suggestionHighlightColor,
          highlightElevation: widget.suggestionHighlightElevation,
          elevation: widget.suggestionElevation,
        );
      }else{
        return Container();
      }

    });
  }

  List<Widget> createSuggestionsFromList(List<String> suggestionText){
    return suggestionText.map<Widget>((String suggestion){
      var filterConditions = suggestion.contains(inputValue) && inputValue.length >= widget.completionThreshold;
      var secondFilterConditions = inputValue == '' && widget.completionThreshold == 0;
      if(filterConditions || secondFilterConditions){
        return Container(
          margin: widget.suggestionsMargin,
          child: RaisedButton(
            child: Text(suggestion, style: widget.suggestionsTextStyle,),
            onPressed: (){
              autoCompleteWith(suggestion);
            },
            color: widget.suggestionColor,
            hoverColor: widget.suggestionHoverColor,
            splashColor: widget.suggestionSplashColor,
            highlightColor: widget.suggestionHighlightColor,
            highlightElevation: widget.suggestionHighlightElevation,
            elevation: widget.suggestionElevation,
          ),
          decoration: widget.suggestionsDecoration,
        );
      }else{
        return Container();
      }
    }).toList();
  }

  void insertOverlay(){
    if(isOverlayDisplayed == false){
      Overlay.of(context).insert(this._overlayEntry);
      isOverlayDisplayed = true;
    }
  }

  void removeOverlay(){
    if(isOverlayDisplayed == true){
      this._overlayEntry.remove();
      isOverlayDisplayed = false;
    }
  }

}