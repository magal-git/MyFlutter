import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutterapp/fmodelview.dart';
import 'package:flutterapp/fobjects.dart';
import 'package:flutterapp/utils.dart';

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


_onEnter(PointerEnterEvent e){
  setState(() {

    if(widget.fm.parentId != 0){
      swapobj = widget.fm.getMoid;
      //print('startobj ' + startobj.toString());
      //Rect rect = const Offset(100, 100) & const Size(10,10);
      
    }

  });
}


_onthemove(PointerMoveEvent m){
  Rect rect;
  List<Rect> rectlist = [];
  if(widget.fm.parentId != 0){
    FModelView parent = getCurObj(widget.fm.parentId, widget.fm.fmc.fmcObjmap);
    for(var child in parent.childlist()){
      rect = const Offset(-90, -50) & Size(child.fmc.fbWidth.value.toDouble(), 10);
      rectlist.add(rect);
    }
    Map mr = rectlist.asMap();
    //print(mr);
    Rect r = rectlist[0];
      //for(int i=1; i<3; i++){
      Rect irect = r.intersect(rectlist[1]);
        print(irect.width);
      //}
       return;
    //}
  }
}

_listener(PointerDownEvent p){
  //setState(() {

    if(widget.fm.parentId != 0){
      startobj = widget.fm.getMoid;
      //print(swapobj);
      //FModelView parent = getCurObj(widget.fm.parentId, widget.fm.fmc.fmcObjmap);
    }
    
  //});
}

_swapit(PointerUpEvent u){
  
  setState(() {
    if(widget.fm.parentId != 0){
      
      //print('pointer up ' + swapobj.toString());
    }

    //print('start*: ' + startobj.toString());
    //print('swap: ' + swapobj.toString());
    //print('in swapit---------');
    /*if(widget.fm.parentId == 0){
      //print('parent: ' + widget.fm.getMoid.toString());
      parent = widget.fm;
    }else{
      parent = getCurObj(widget.fm.parentId, widget.fm.fmc.fmcObjmap);
      frominx = parent.childlist().indexWhere((element) => element.getMoid == startobj);
      print('FROMINX*****************' + frominx.toString());
    }*/
    /*if(isMoving){
      frominx = parent.childlist().indexWhere((element) => element.getMoid == startobj);
      toinx = parent.childlist().indexWhere((element) => element.getMoid == swapobj);
      parent.childlist().insert(toinx, widget.fm.childlist().removeAt(frominx));
      print(startobj.toString() + ' : ' + swapobj.toString());
    }*/
    
    //print(isMoving.toString());
  });
}

  @override
  Widget build(BuildContext context) {
    //print('in mover');
    
    return 
    Column(
      children: [
        Listener(child: 
            MouseRegion(onEnter: _onEnter, child: widget.child,), 
            onPointerDown: _listener,
            onPointerUp: _swapit,
            onPointerMove: _onthemove,
        ),
        //CustomPaint(painter: OpenPainter(),)
      ],
    );
      
  }
}