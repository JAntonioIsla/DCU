import 'package:flutter/material.dart';
import 'main.dart';
import 'lienzo_para_formato.dart';

class DropdownDefaultSelector extends StatefulWidget {
  DropdownDefaultSelector({Key key, this.textItems, this.value, this.onChanged})
      : super(key: key);
  final List<String> textItems;
  final dynamic value;
  final ValueChanged<dynamic> onChanged;

  @override
  _DropdownDefaultSelectorState createState() => _DropdownDefaultSelectorState();
}

class _DropdownDefaultSelectorState extends State<DropdownDefaultSelector>{

  dynamic innerValue;

  @override
  void didChangeDependencies() {
    setState(() {
      innerValue = widget.value;
    });
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    innerValue = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    return dropdownSelector(widget.textItems, innerValue, widget.onChanged);
  }

  Widget dropdownSelector(
      List<String> textItems, dynamic value, ValueChanged<dynamic> onChanged) {
    List<DropdownMenuItem> items = dropdownItems(textItems);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10.0),
      child: DropdownButtonHideUnderline(
        child: ButtonTheme(
          alignedDropdown: true,
          child: DropdownButton(
            items: items,
            onChanged: (valueChanged){
              setState(() {
                innerValue = valueChanged;
                onChanged(valueChanged);
              });
            },
            underline: Container(),
            focusColor: hoverColor,
            iconEnabledColor: accentColor,
            iconDisabledColor: hoverColor,
            iconSize: 40.0,
            isDense: true,
            hint: dropdownHint(value),
            isExpanded: true,
          ),
        ),
      ),
    );
  }

  List<DropdownMenuItem> dropdownItems(List<String> textItems) {
    if(textItems == null){
      textItems = widget.textItems;
    }
    return textItems.map((value) {
      return DropdownMenuItem(
        value: value,
        child: Row(
          children: <Widget>[
            Expanded(
              child: Container(
                alignment: Alignment.bottomCenter,
                child: Column(
                  children: <Widget>[
                    Text(
                      value,
                      style: TextStyle(
                        fontSize: 28.0,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Divider()
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }).toList();
  }

  Widget dropdownHint(dynamic value) {
    if(value == null) value = widget.textItems[0];
    String text = value;
    var textLength = text.length;
    bool isTextLarge = textLength > 13;
    bool isTextExtraLarge = textLength > 18;
    bool isTextSuperExtraLarge = textLength > 23;
    return answerContainer(
      child: Padding(
        padding: isTextLarge ?
        (isTextExtraLarge ?
        (isTextSuperExtraLarge ?
        const EdgeInsets.symmetric(vertical: 0.0) : const EdgeInsets.symmetric(vertical: 6.0)
        ) : const EdgeInsets.symmetric(vertical: 3.0)
        ) : const EdgeInsets.symmetric(vertical: 0.0),
        child: Text(
          value,
          textAlign: TextAlign.center,
          style: TextStyle(
              color: hoverColor,
              fontSize: isTextLarge ?
              (isTextExtraLarge ?
              (isTextSuperExtraLarge ?
              14.0 : 18.0
              ) : 21.0
              ) : 28.0,
              fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
