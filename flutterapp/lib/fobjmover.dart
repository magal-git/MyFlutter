import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutterapp/fmodelview.dart';
import 'package:flutterapp/fobjects.dart';
import 'package:flutterapp/utils.dart';
import 'package:hive/hive.dart';

class FObjMover extends StatefulWidget {
  const FObjMover({required this.child, required this.fm});

  final Draggable child;
  final FModelView fm;

  @override
  _FObjMoverState createState() => _FObjMoverState();
}//#region [ rgba(100, 200, 120, 0.2) ]//#endregion


class _FObjMoverState extends State<FObjMover> {

int startobj = 0;
int swapobj = 0;
int frominx = -1;
int toinx = -1;
bool doit = false;
bool isMoving = false;
int cur = 0;
int r = 0;

var box = Hive.box('myBox');

/*var box = Hive.box('myBox');
    box.put('name', 'David');
    var name = box.get('name');
    print('Name: $name');*/

_onEnter(PointerEnterEvent e){
  
  setState(() {
    if(widget.fm.parentId != 0){
      FModelView parent = getCurObj(widget.fm.parentId, widget.fm.fmc.fmcObjmap);

      toinx = parent.childlist().indexWhere((element) => element.getMoid == widget.fm.getMoid);
      //print('from: ' + toinx.toString() + ' to');
      //print(parent.childlist().indexWhere((element) => element.getMoid == widget.fm.getMoid));
      
      box.put('toinx', toinx);

      //print('saveit: ' + toinx.toString());
      
    }
    
  });
}

_onthemove(PointerMoveEvent m){
  if(widget.fm.parentId != 0){
      FModelView parent = getCurObj(widget.fm.parentId, widget.fm.fmc.fmcObjmap);

      frominx = parent.childlist().indexWhere((element) => element.getMoid == widget.fm.getMoid);
      //print('from: ' + frominx.toString() + ' to');
      //print(parent.childlist().indexWhere((element) => element.getMoid == widget.fm.getMoid));
      
    }
}

_listener(PointerDownEvent p){

  if(widget.fm.parentId != 0){
    FModelView parent = getCurObj(widget.fm.parentId, widget.fm.fmc.fmcObjmap);

    frominx = parent.childlist().indexWhere((element) => element.getMoid == widget.fm.getMoid);
  }
  
}

_swapit(PointerUpEvent u){
  
  setState(() {
   
    if(widget.fm.parentId != 0){
       var inx = box.get('toinx');

       /*print('from: ' + frominx.toString());
       print('to: ' + inx.toString());*/
       
      //print('from: ' + frominx.toString() + ' to: ' + toinx.toString());

      FModelView parent = getCurObj(widget.fm.parentId, widget.fm.fmc.fmcObjmap);
      parent.childlist().insert(inx, parent.childlist().removeAt(frominx));
      parent.markSelObj(parent, widget.fm.fmc.fmcObjmap);
    }

    //if(widget.fm.parentId != 0){
      
      //print('pointer up ' + widget.fm.fmc.positionX.toString());
    //}

    //print('start*: ' + startobj.toString());
    //print('swap: ' + swapobj.toString());
    //print('in swapit---------');
    /*if(widget.fm.parentId == 0){
      //print('parent: ' + widget.fm.getMoid.toString());
      parent = widget.fm;
    }else{
      parent = getCurObj(widget.fm.parentId, widget.fm.fmc.fmcObjmap);
      frominx = parent.childlist().indexWhere((element) => element.getMoid == startobj);
      //print('FROMINX*****************' + frominx.toString());
    }*/
    /*if(isMoving){
      frominx = parent.childlist().indexWhere((element) => element.getMoid == startobj);
      toinx = parent.childlist().indexWhere((element) => element.getMoid == swapobj);
      parent.childlist().insert(toinx, widget.fm.childlist().removeAt(frominx));
      //print(startobj.toString() + ' : ' + swapobj.toString());
    }*/
    
    //print(isMoving.toString());
  });
}

  @override
  Widget build(BuildContext context) {


    return 
    Column(
      children: [
        Listener(child: 
            MouseRegion(onEnter: _onEnter, child: widget.child,), 
            onPointerDown: _listener,
            onPointerUp: _swapit,
            onPointerMove: _onthemove,
        ),
        //CustomPaint(painter: widget.fm.parentId != 0 ? SwapPainter(rect) : OpenPainter(),)
      ],
    );
      
  }
}