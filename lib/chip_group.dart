import 'package:dcu/main.dart';
import 'package:dcu/texfields.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChipGroup extends StatefulWidget {
  ChipGroup({
    Key key,
    this.options,
    this.minWidth = 0.0,
    this.maxWidth,
    this.onChanged,
  }) : super(key: key);
  final List<String> options;
  final minWidth;
  final maxWidth;
  final ValueChanged<String> onChanged;
  @override
  _ChipGroupState createState() => _ChipGroupState();
}

class _ChipGroupState extends State<ChipGroup> {
  List<Widget> _chips;
  double _childMargin = 15.0;
  var _screenSize;
  var _maxWidth;
  var _values = <String>[];

  @override
  void initState() {
    _chips = createChips();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if(widget.maxWidth == null){
      _screenSize = MediaQuery.of(context).size;
      _maxWidth = _screenSize.width;
    }else{
      _maxWidth = widget.maxWidth;
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: childrenRows(),
    );
  }

  List<Widget> createChips() {
    return widget.options.map<Widget>((option) {
      return Container(
        margin: EdgeInsets.only(left: _childMargin),
        child: ToogleChip(
            label: option,
            offStateColor: hoverColor,
            onStateColor: accentColor,
            onChanged: (valueChanged) {
              if(option == 'Otro' || option == 'Otra' ){
                if(valueChanged != ''){
                  _values.removeWhere((value){
                    return value.contains('Otro');
                  });
                  _values.add(valueChanged);
                }else{
                  _values.removeWhere((value){
                    return value.contains('Otro');
                  });
                }
              }else{
                if(valueChanged != ''){
                  _values.add(valueChanged);
                }else{
                  _values.remove(option);
                }
              }
              widget.onChanged(_values.toString());
            }),
      );
    }).toList();
  }

  List<Widget> childrenRows() {
    var childrenWidth = 0.0;
    var rows = <Widget>[];
    var chipsAux = List<Widget>();
    chipsAux.addAll(_chips);
    var endIndexForSublistChip;
    var startIndexForSublistChip = 0;
    var childrenSublist;
    var chipIndex;
    var option;
    chipsAux.forEach((chip) {
      chipIndex = _chips.indexOf(chip);
      option = widget.options.elementAt(chipIndex);
      childrenWidth += (_childMargin + option.length * 10 + 100);
      var screenOverflow = overflowIndicator(childrenWidth);
      if (screenOverflow) {
        if(chip == _chips.last){
          print('Overflow and Last');
          childrenSublist = _chips.sublist(startIndexForSublistChip);
          childrenSublist.removeLast();
          rows.add(widgetsRow(children: childrenSublist));
          rows.add(widgetsRow(children: <Widget>[chip]));
        }else{
          print('Overflow');
          option = widget.options.elementAt(chipIndex - 1);
          childrenWidth -= (_childMargin + option.length * 10 + 100);
          screenOverflow = overflowIndicator(childrenWidth);
          if(screenOverflow){
            endIndexForSublistChip = chipIndex -1;
            childrenSublist = _chips.sublist(startIndexForSublistChip,endIndexForSublistChip);
            rows.add(widgetsRow(children: childrenSublist));
            startIndexForSublistChip = chipIndex -1;
            childrenWidth = 0.0;
          }else{
            endIndexForSublistChip = chipIndex;
            childrenSublist = _chips.sublist(startIndexForSublistChip,endIndexForSublistChip);
            rows.add(widgetsRow(children: childrenSublist));
            startIndexForSublistChip = chipIndex;
            childrenWidth = 0.0;
          }

        }
      }else{
        print('NOT Overflow');
        if(chip == _chips.last){
          print('NOT Overflow AND LAST');
          childrenSublist = _chips.sublist(startIndexForSublistChip);
          rows.add(widgetsRow(children: childrenSublist));
        }
      }

    });
    return rows;
  }

  Widget widgetsRow({List<Widget> children}){
    return Container(
      constraints: BoxConstraints(minWidth: widget.minWidth, maxWidth: _maxWidth, maxHeight: 80.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: children,
      ),
    );
  }

  bool overflowIndicator(childrenWidth) {
    if(childrenWidth > _maxWidth * 0.7){
      return true;
    }else{
      return false;
    }

  }
}

class ToogleChip extends StatefulWidget {
  ToogleChip({
    Key key,
    this.initialValue = false,
    this.label,
    this.offStateColor,
    this.onStateColor,
    this.onChanged,
  }) : super(key: key);

  final initialValue;
  final label;
  final Color offStateColor;
  final Color onStateColor;
  final ValueChanged<String> onChanged;

  @override
  _ToogleChipState createState() => _ToogleChipState();
}

class _ToogleChipState extends State<ToogleChip> {
  var _toogle;
  var _text;

  @override
  void initState() {
    _toogle = widget.initialValue;
    _text = _toogle == true? widget.label : '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if(widget.label == 'Otro' || widget.label == 'Otra'){
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          GestureDetector(
            child: Chip(
              label: Text(
                widget.label,
                style: TextStyle(
                    fontSize: _toogle == true ? 24.0 : 22.0,
                    fontWeight: FontWeight.w600,
                    color: Colors.white),
              ),
              backgroundColor:
              _toogle == true ? widget.onStateColor : widget.offStateColor,
              elevation: _toogle == true ? 10.0 : 0.0,
            ),
            onTap: () {
              setState(() => _toogle = !_toogle);
              _text = _toogle == true? widget.label : '';
              widget.onChanged(_text);
            },
          ),
           Expanded(
             child: Container(
               constraints: BoxConstraints(maxWidth: 200.0),
               margin: const EdgeInsets.only(left: 60.0),
               child: _toogle == true?TextInputField(
                 labelText: 'Especificar',
                 onChanged: (value){
                   widget.onChanged(_text + ': $value');
                 },
                 onSubmitted: (value){
                   widget.onChanged(_text + ': $value');
                 },
               ):null,
             ),
           )
        ],
      );
    }else{
      return GestureDetector(
        child: Chip(
          label: Text(
            widget.label,
            style: TextStyle(
                fontSize: _toogle == true ? 24.0 : 22.0,
                fontWeight: FontWeight.w600,
                color: Colors.white),
          ),
          backgroundColor:
          _toogle == true ? widget.onStateColor : widget.offStateColor,
          elevation: _toogle == true ? 10.0 : 0.0,
        ),
        onTap: () {
          setState(() => _toogle = !_toogle);
          _text = _toogle == true? widget.label : '';
          widget.onChanged(_text);
        },
      );
    }
  }
}
