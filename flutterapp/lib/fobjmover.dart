import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutterapp/fmodelview.dart';
import 'package:flutterapp/fobjects.dart';
import 'package:flutterapp/main.dart';
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


int frominx = -1;
int toinx = -1;
bool _paint = false;

var box = Hive.box('myBox');


_onEnter(PointerEnterEvent e){
  
  setState(() {
    if(widget.fm.parentId != 0){

      FModelView parent = getCurObj(widget.fm.parentId, widget.fm.fmc.fmcObjmap);
      toinx = parent.childlist().indexWhere((element) => element.getMoid == widget.fm.getMoid);
      
      box.put('toinx', toinx);
      _paint = true;

      box.put('pid', parent.getMoid);
    }else{
      box.put('pid', -1);
    }

  });
}

_noPaint(PointerExitEvent ex){
  setState(() {
    _paint = false;
  });
}

_onthemove(PointerMoveEvent m){

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

      FModelView parent = getCurObj(widget.fm.parentId, widget.fm.fmc.fmcObjmap);
      parent.childlist().insert(inx, parent.childlist().removeAt(frominx));
      parent.markSelObj(parent, widget.fm.fmc.fmcObjmap);
    }

    if(widget.fm.parentId == 0 && !widget.fm.isMultiWidget()){
      var pid = box.get('pid');
     if(pid > -1){
      FModelView mw = getCurObj(pid, widget.fm.fmc.fmcObjmap);
      var inx = box.get('toinx');
      widget.fm.parentId = mw.getMoid;//!
      mw.childlist().insert(inx, widget.fm);
      mw.markSelObj(mw, widget.fm.fmc.fmcObjmap);
      box.put('pid', -1);
      return;
     }

    }

  });
}

  @override
  Widget build(BuildContext context) {


    return 
    Column(
      children: [
        Listener(child: 
            MouseRegion(onEnter: _onEnter, child: widget.child,
              onExit: _noPaint,
            ), 
            onPointerDown: _listener,
            onPointerUp: _swapit,
            onPointerMove: _onthemove,
        ),
        CustomPaint(painter: _paint ? SwapPainter(Offset(-90, -50) & Size(180, 50)) : OpenPainter(),)
      ],
    );
      
  }
}