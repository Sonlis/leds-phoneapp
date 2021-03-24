
import 'package:flutter/material.dart';
import 'package:folding_cell/folding_cell.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

Future<toSend> sendPackets(List<String> component, int effect) async {
  final response = await http.post(
    Uri.http('192.168.0.108:8082', '/'),
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
  final List<String> effects = ["Scroll", "Energy", "Spectrum", "Off"];
  final List<String> components = [];
   bool _hasBeenPressed1;
  bool _hasBeenPressed2;
  Future<toSend> _futuretoSend;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFF2e282a),
      child: ListView.builder(
        itemCount: 4,
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
                    primary: _hasBeenPressed2 ? Colors.grey : Colors.blue
                  ),
                   child: Text("Led strip 1"),
                   onPressed: () {
                     setState(() {
                       if (_hasBeenPressed2 == false ) {
                        components.add("\"192.168.0.11\"");
                       }
                       else {
                        components.remove("\"192.168.0.11\"");
                       }
                        _hasBeenPressed2 = !_hasBeenPressed2;
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
                        components.add("\"192.168.0.12\"");
                       }
                       else {
                        components.remove("\"192.168.0.12\"");
                       }
                        _hasBeenPressed2 = !_hasBeenPressed2;
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
                      });
                    },
                    ),   
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
