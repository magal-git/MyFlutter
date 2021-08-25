import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutterapp/fmodelview.dart';
import 'package:flutterapp/fobjects.dart';
import 'package:flutterapp/fobjrepo.dart';
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

      FModelView parent = FObjRepo.getCurObj(widget.fm.parentId, FObjRepo.objmap);//#f75 - widget.fm.fmc.fmcObjmap
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
    FModelView parent = FObjRepo.getCurObj(widget.fm.parentId, FObjRepo.objmap);//#f75 - widget.fm.fmc.fmcObjmap
    frominx = parent.childlist().indexWhere((element) => element.getMoid == widget.fm.getMoid);
  }
  
}

_swapit(PointerUpEvent u){//!TODO works but more todo here! 
//!TODO Err 1. With MW2 in a MW1. Moving the child of MW2 make the child dissappaire
//!TODO Err 2. When moving a obj, (over the objects in the MW), makes it move into the MW, even if its outside the MW when the move is done( d.v.s PointeUp).
  
  setState(() {
   
    if(widget.fm.parentId != 0){
      var inx = box.get('toinx');

      FModelView parent = FObjRepo.getCurObj(widget.fm.parentId, FObjRepo.objmap);//#f75 - widget.fm.fmc.fmcObjmap
      parent.childlist().insert(inx, parent.childlist().removeAt(frominx));
      parent.markSelObj(parent, widget.fm.fmc.fmcObjmap);
    }

    if(widget.fm.parentId == 0 && !widget.fm.isMultiWidget()){//! For now only singlewidget can be moved
      var pid = box.get('pid');
      if(pid > -1){
        FModelView mw = FObjRepo.getCurObj(pid, FObjRepo.objmap);//#f75 - widget.fm.fmc.fmcObjmap
        var inx = box.get('toinx');
        widget.fm.parentId = mw.getMoid;//! The obj that we want to move is not a child of the multiwidget. Make it that!!

        int mvbix = FObjRepo.stackobj.indexWhere((element) => element.getMoid == widget.fm.getMoid);//!Get the position in the global stackobjlist
        mw.childlist().insert(inx, FObjRepo.stackobj.removeAt(mvbix));//! Now, remove it from the stacklist and add it to the multiwidget childlist
        //!As a child its no longer in the stacklist but only in the objmap as part of the parents childlist.

        mw.markSelObj(mw, FObjRepo.objmap);//#f75 - widget.fm.fmc.fmcObjmap
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