
import 'package:flutter/material.dart';
import 'package:folding_cell/folding_cell.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

Future<toSend> sendPackets(List<String> component, int effect) async {
  final response = await http.post(
    Uri.http('192.168.0.130:8082', '/'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, dynamic>{
      'component': component,
      'effect': effect,
    }),
  );
}

class toSend {
  final String component;
  final int effect;

  toSend({this.component, this.effect});

  factory toSend.fromJson(Map<String, dynamic> json) {
    return toSend(
      component: json['component'],
      effect: json['effect'],
    );
  }
}

void main() => runApp(
      MaterialApp(
        home: SafeArea(
          child: Scaffold(
            body: Material(
              child: FoldingCellListViewDemo(),
            ),
          ),
        ),
      ),
    );  

 class FoldingCellListViewDemo extends StatefulWidget {
  FoldingCellListViewDemo({Key key}) : super(key: key); 
  @override
  _FoldingCellListViewDemoState createState() {
    return _FoldingCellListViewDemoState();
  }
}

class _FoldingCellListViewDemoState extends State<FoldingCellListViewDemo> {
  final List<String> effects = ["Scroll", "Energy", "Spectrum", "Color_wipe", "Theater_chase", "Rainbow", "Theater_chase_rainbow", "Fire", "Clear"];
  //final List<bool> colorpicker = [false, false, false, true, true, false, false, false, false];
  final List<String> components = [];
  var _hasBeenPressed1 = false;
  var _hasBeenPressed2 = false;
  var _hasBeenPressed3 = false;
  Future<toSend> _futuretoSend;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFF2e282a),
      child: ListView.builder(
        itemCount: effects.length,
        itemBuilder: (context, index) {
          return SimpleFoldingCell.create(
            frontWidget: _buildFrontWidget(index, effects),
            innerWidget: _buildInnerWidget(index, effects),
            cellSize: Size(MediaQuery.of(context).size.width, 125),
            padding: EdgeInsets.all(15),
            animationDuration: Duration(milliseconds: 300),
            borderRadius: 10,
            onOpen: () => print('$index cell opened'),
            onClose: () => print('$index cell closed'),
          );
        },
      ),
    );
  }

  Widget _buildFrontWidget(int index, List<String> effects) {
    return Builder(
      builder: (BuildContext context) {
        return Container(
          color: Color(0xFFffcd3c),
          alignment: Alignment.center,
          child: Stack(
            children: <Widget>[
              Align(
                alignment: Alignment.center,
                child: Text(
                  effects[index],
                  style: GoogleFonts.aldrich(
                    color: Color(0xFF2e282a),
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Positioned(
                right: 10,
                bottom: 10,
                child: TextButton(
                  onPressed: () {
                    final foldingCellState = context
                        .findAncestorStateOfType<SimpleFoldingCellState>();
                    foldingCellState?.toggleFold();
                  },
                  child: Text(
                    "OPEN",
                  ),
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.white,
                    minimumSize: Size(80, 40),
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  Widget _buildInnerWidget(int index, List<String> effects) {
    return Builder(
      builder: (context) {
        return Container(
          color: Color(0xFFecf2f9),
          padding: EdgeInsets.only(top: 10),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: Text(
                  effects[index],
                  style: GoogleFonts.aldrich(
                    color: Color(0xFF2e282a),
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget> [
                 ElevatedButton(
                   style: ElevatedButton.styleFrom(
                    primary: _hasBeenPressed1 ? Colors.grey : Colors.blue
                  ),
                   child: Text("Led strip 1"),
                   onPressed: () {
                     setState(() {
                       if (_hasBeenPressed1 == false ) {
                        components.add("\"192.168.0.150\"");
                       }
                       else {
                        components.remove("\"192.168.0.150\"");
                       }
                        _hasBeenPressed1 = !_hasBeenPressed1;
                    }
                     );
                   }
                 ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                    primary: _hasBeenPressed2 ? Colors.grey : Colors.blue
                  ),
                   child: Text("Led strip 2"),
                   onPressed: () {
                     setState(() {
                       if (_hasBeenPressed2 == false ) {
                        components.add("\"192.168.0.151\"");
                       }
                       else {
                        components.remove("\"192.168.0.151\"");
                       }
                        _hasBeenPressed2 = !_hasBeenPressed2;
                    }
                     );
                   }
                    ),
                  ElevatedButton(
                   style: ElevatedButton.styleFrom(
                    primary: _hasBeenPressed3 ? Colors.grey : Colors.blue
                  ),
                   child: Text("Led strip 3"),
                   onPressed: () {
                     setState(() {
                       if (_hasBeenPressed3 == false ) {
                        components.add("\"192.168.0.152\"");
                       }
                       else {
                        components.remove("\"192.168.0.152\"");
                       }
                        _hasBeenPressed3 = !_hasBeenPressed3;
                    }
                     );
                   }
                 ),
                  ElevatedButton(
                    child: Text("Send!"),
                    onPressed: () {
                      setState(() {
                          _futuretoSend = sendPackets(components, index + 1);
                          components.removeRange(0,2);
                          _hasBeenPressed1 = false;
                          _hasBeenPressed2 = false;
                          _hasBeenPressed3 = false;
                      });
                    },
                    ),   
                  //colorpicker[index] ? 
                  /*ElevatedButton(
                    child: Text("Modify color"),
                    onPressed: () {
                      Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => colorPicker()),
                      );
                    }
                  ) : Container()*/
                ]
              ),  
              Positioned(
                right: 10,
                bottom: 10,
                child: TextButton(
                  onPressed: () {
                    final foldingCellState = context
                        .findAncestorStateOfType<SimpleFoldingCellState>();
                    foldingCellState?.toggleFold();
                  },
                  child: Text(
                    "Close",
                  ),
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.white,
                    minimumSize: Size(80, 40),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class colorPicker extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _colorPickerState();
}

class _colorPickerState extends State<colorPicker> {
  bool lightTheme = false;
  Color currentColor = Colors.limeAccent;
  List<Color> currentColors = [Colors.limeAccent, Colors.green];

  void changeColor(Color color) => setState(() => currentColor = color);
  void changeColors(List<Color> colors) => setState(() => currentColors = colors);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: lightTheme ? ThemeData.light() : ThemeData.dark(),
        child: Scaffold(
        body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Column(
                children: <Widget>[
                  RaisedButton(
                    elevation: 3.0,
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            titlePadding: const EdgeInsets.all(0.0),
                            contentPadding: const EdgeInsets.all(0.0),
                            content: SingleChildScrollView(
                              child: ColorPicker(
                                pickerColor: currentColor,
                                onColorChanged: changeColor,
                                colorPickerWidth: 300.0,
                                pickerAreaHeightPercent: 0.7,
                                enableAlpha: true,
                                displayThumbColor: true,
                                showLabel: true,
                                paletteType: PaletteType.hsv,
                                pickerAreaBorderRadius: const BorderRadius.only(
                                  topLeft: const Radius.circular(2.0),
                                  topRight: const Radius.circular(2.0),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                    child: const Text('Change me'),
                    color: currentColor,
                    textColor: useWhiteForeground(currentColor)
                        ? const Color(0xffffffff)
                        : const Color(0xff000000),
                  ),
                  RaisedButton(
                    elevation: 3.0,
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            titlePadding: const EdgeInsets.all(0.0),
                            contentPadding: const EdgeInsets.all(0.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                            content: SingleChildScrollView(
                              child: SlidePicker(
                                pickerColor: currentColor,
                                onColorChanged: changeColor,
                                paletteType: PaletteType.rgb,
                                enableAlpha: false,
                                displayThumbColor: true,
                                showLabel: false,
                                showIndicator: true,
                                indicatorBorderRadius:
                                const BorderRadius.vertical(
                                  top: const Radius.circular(25.0),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                    child: const Text('Change me again'),
                    color: currentColor,
                    textColor: useWhiteForeground(currentColor)
                        ? const Color(0xffffffff)
                        : const Color(0xff000000),
                  ),
                ],
              ),
                    ]
                ),
              ),
    );
  }
}