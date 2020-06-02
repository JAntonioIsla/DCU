import 'package:dcu/main.dart';
import 'package:dcu/texfields.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class GrowingTable extends StatefulWidget{

  GrowingTable({Key key,
  this.initialNumberOfRows = 3,
  this.onChanged,
  this.onSubmitted,
  this.textPrefix,
  this.keyboardType,
  this.onIncreasePressed,
  this.onDecreasePressed,
  }) : super(key:key);

  final int initialNumberOfRows;
  final TwoParamsCallback<String, int> onChanged;
  final TwoParamsCallback<String, int> onSubmitted;
  final String textPrefix;
  final TextInputType keyboardType;
  final VoidCallback onIncreasePressed;
  final VoidCallback onDecreasePressed;

  @override
  _GrowingTableState createState() => _GrowingTableState();

}

class _GrowingTableState extends State<GrowingTable>{
  var numberOfRows;



  @override
  void initState() {
    super.initState();
    numberOfRows = widget.initialNumberOfRows;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    flex: 4,
                    child: Container(
                      child: Table(
                        children: generateTableInputs(
                            numberOfRows: numberOfRows,
                            onChanged: widget.onChanged,
                            onSubmitted: widget.onSubmitted,
                            textPrefix: widget.textPrefix,
                            keyboardType: widget.keyboardType,
                        ),
                        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                        border: TableBorder(
                          horizontalInside: BorderSide(color: Colors.grey[600],width: 2.0),
                          verticalInside: BorderSide(color: Colors.grey[600],width: 2.0),
                        ),
                      ),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30.0),
                            border: Border.all(color: Colors.grey[600],width: 2.0)
                        )
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: 20.0, bottom: 30.0, right: 40.0),
                    child: FloatingActionButton(
                      heroTag: 'removeMeasureFab',
                      backgroundColor: Colors.red,
                      splashColor: hoverColor,
                      hoverColor: hoverColor,
                      child: Icon(Icons.remove,color: Colors.white,),
                      onPressed: (){
                        setState(() => decreaseNumberOfRows());
                        widget.onDecreasePressed();
                      },
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 20.0, bottom: 30.0),
                    child: FloatingActionButton(
                      heroTag: 'addMeasureFab',
                      backgroundColor: actionHiglightColor,
                      splashColor: hoverColor,
                      hoverColor: hoverColor,
                      child: Icon(Icons.add,color: Colors.white,),
                      onPressed: (){
                        setState(() => increaseNumberOfRows());
                        widget.onIncreasePressed();
                      },
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ],
    );
  }

  void increaseNumberOfRows(){
    setState(() {
      numberOfRows++;
      print(numberOfRows);
    });
  }

  void decreaseNumberOfRows(){
    setState(() {
      numberOfRows--;
    });
  }

}

typedef TwoParamsCallback<T,V> = void Function(T tValue, V vValue);

List<TableRow> generateTableInputs({
  int numberOfRows,
  String textPrefix,
  TextInputType keyboardType,
  TwoParamsCallback<String, int> onChanged,
  TwoParamsCallback<String, int> onSubmitted,
}){
  return List<TableRow>.generate(numberOfRows, (rowIndex){

    List<Widget> rowWidgets = new List<Widget>();
    var measureText = rowIndex + 1;
    rowWidgets.add(Text('$textPrefix$measureText',
      style: TextStyle(fontSize: 20.0, color: Colors.grey[600]),
      textAlign: TextAlign.center,
    ));
    rowWidgets.add(
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: NumericTextField(numericIcon: false, width: "",
            onChanged: (value){
              onChanged(value, rowIndex);
            },
            onSubmitted:  (value){
              onSubmitted(value, rowIndex);
            },
            keyboardType: keyboardType,
          ),
        ));
    return TableRow(
      children: rowWidgets,
    );
  });
}