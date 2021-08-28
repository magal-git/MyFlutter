import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class MyCard extends StatefulWidget {
  const MyCard({ Key? key }) : super(key: key);

  @override
  _MyCardState createState() => _MyCardState();
}

class _MyCardState extends State<MyCard> {


  _update(DraggableDetails d){
    setState(() {
      //x = (d.offset.dx - 400/2)*0.005;
      //y = (d.offset.dy - 400/2)*0.005;

      x = d.offset.dx - 4.0;
      y = d.offset.dy - 60.0;

      //print(MediaQuery.of(context).size);
      //print(d.offset.dx);
      //print(x);
      
    });
  }
  _loc(PointerHoverEvent p){
    setState(() {
      print(p.localPosition);
    });
    
  }

  double x = 0.0;
  double y = 0.0;

  @override
  Widget build(BuildContext context) {
    return 
    /*MaterialApp(
      title: 'My Card',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('My Card'),
        ),
        body:*/ Stack(children: [
          Align(alignment: Alignment(-1, -1), child: 
            Card(color: Colors.grey, child:
              Container(width: 200, height: 100, child:
                Stack(children: [
                  //Align(alignment: Alignment(x, y), child:
                  Positioned(left: x, top: y, child:
                    Draggable(child:
                      Image.network('https://picsum.photos/100', width: 80, height: 80,),
                      feedback: Image.network('https://picsum.photos/100', width: 80, height: 80,),
                      onDragEnd: (details) => _update(details),
                    ),
                  ),
                ],)
              ),
            ),
          ),
        ],);
      /*)
    );*/
  }
}