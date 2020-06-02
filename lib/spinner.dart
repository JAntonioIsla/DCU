import 'package:dcu/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Spinner extends StatefulWidget{ // ignore: must_be_immutable

  Spinner({
    Key key,
    @required this.spinnerItems,
    @required this.defaultValue,
    @required this.onTapItem,
    this.icon = Icons.arrow_drop_down,
    this.iconSize = 40.0,
    this.iconColor = Colors.black,
    this.decoration,
    this.textSize = 30.0,
    this.label,
  }):super(key:key);

  final List<SpinnerItem> spinnerItems;
  String defaultValue;
  final VoidCallback onTapItem;
  final dynamic icon;
  final double iconSize;
  final Color iconColor;
  final Decoration decoration;
  final double textSize;
  final String label;

  @override
  _SpinnerState createState() => _SpinnerState();

}

class _SpinnerState extends State<Spinner>{

  bool _displayList = true;
  String actualValue;

  @override
  void initState() {
    actualValue = widget.defaultValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if(_displayList){
      return Container(
        margin: EdgeInsets.zero,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(widget.label, textAlign: TextAlign.start,style: TextStyle(color: Colors.grey[600],fontSize: 20.0)),
            RaisedButton(
              hoverColor: hoverColor,
              splashColor: accentColor,
              highlightColor: hoverColor,
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(widget.defaultValue,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: widget.textSize, fontWeight: FontWeight.w600, color: Colors.black,),
                  ),
                  Icon(widget.icon,
                    size: widget.iconSize,
                    color: widget.iconColor,
                  )
                ],
              ),
              onPressed: (){
                setState(() {
                  _displayList = !_displayList;
                });
              },
            ),
          ],
        )
      );
    }else{
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(widget.label, textAlign: TextAlign.start,style: TextStyle(color: Colors.grey[600],fontSize: 20.0)),
          Material(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
            elevation: 6.0,
            color: Colors.white,
            child: Container(
              decoration:  widget.decoration == null?
              BoxDecoration(
                color: Colors.transparent,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(18.0),
              ) : widget.decoration,
              child: SingleChildScrollView(
                child: Column(
                  children: widget.spinnerItems.map((SpinnerItem spinnerItem){
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical:12.0, horizontal: 8.0),
                      child: Material(
                        type: MaterialType.transparency,
                        elevation: 6.0,
                        color: Colors.transparent,
                        shadowColor: Colors.grey[50],
                        child: InkWell(
                          splashColor: accentColor,
                          hoverColor: hoverColor,
                          highlightColor: hoverColor,
                          focusColor: accentColor,
                          child: spinnerItem,
                          onTap: (){
                            setState(() {
                              _displayList = !_displayList;
                              widget.defaultValue = spinnerItem.value;
                            });
                            widget.onTapItem();
                          },
                          borderRadius: BorderRadius.circular(18.0),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          )
        ],
      );
    }
  }

}

class SpinnerItem extends StatelessWidget{

  SpinnerItem({Key key,@required this.child,@required this.value}):super(key:key);

  final Widget child;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.zero,
      padding: EdgeInsets.zero,
      color: Colors.transparent,
      child: child,
    );
  }

}