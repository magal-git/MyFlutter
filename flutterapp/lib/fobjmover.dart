import 'package:flutterapp/imports.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutterapp/fmodelview.dart';
import 'package:flutterapp/fobjects.dart';


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
  
    if(widget.fm.parentId != 0 && widget.fm.type == 2){
      
      FModelView parent = FObjRepo.getCurObj(widget.fm.parentId, FObjRepo.objmap);//#f75 - widget.fm.fmc.fmcObjmap
      
      if(parent.fmc.marked.value){//!TESTING Must mark the multiwidget before moving! OK?
        toinx = parent.childlist().indexWhere((element) => element.getMoid == widget.fm.getMoid);
        box.put('toinx', toinx);
        _paint = true;
        box.put('pid', parent.getMoid);
      }//!TESTING
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

setState(() {

  if(widget.fm.parentId != 0){
    FModelView parent = FObjRepo.getCurObj(widget.fm.parentId, FObjRepo.objmap);//#f75 - widget.fm.fmc.fmcObjmap
    frominx = parent.childlist().indexWhere((element) => element.getMoid == widget.fm.getMoid);
  }

});
}

_swapit(PointerUpEvent u){//!TODO works but more todo here! 
//!TODO Err 1. When copy a object
  
  setState(() {

    if(widget.fm.parentId != 0 && widget.fm.type == 2){//!TODO Set type other then in main:_showTree. We need to set it before //#f00
      var inx = box.get('toinx');//! OBS You can only move to a index slot in the same multiwidget. From and To object must have the same parent.

      FModelView parent = FObjRepo.getCurObj(widget.fm.parentId, FObjRepo.objmap);//#f75 - widget.fm.fmc.fmcObjmap

      if(parent.fmc.marked.value){//!TEST
        parent.childlist().insert(inx, parent.childlist().removeAt(frominx));
        parent.markSelObj(parent, FObjRepo.objmap);
      }
      
    }

    if(widget.fm.parentId == 0 && !widget.fm.isMultiWidget()){//! For now only singlewidget can be moved
      var pid = box.get('pid');
      if(pid > -1){
        FModelView mw = FObjRepo.getCurObj(pid, FObjRepo.objmap);//#f75 - widget.fm.fmc.fmcObjmap
        var inx = box.get('toinx');
        widget.fm.parentId = mw.getMoid;//! The obj that we want to move is not a child of the multiwidget. Make it that!!

        int mvbix = FObjRepo.stackobj.indexWhere((element) => element.getMoid == widget.fm.getMoid);//!Get the position in the global stackobjlist
        mw.childlist().insert(inx, FObjRepo.stackobj.removeAt(mvbix));//! Now, remove it from the stackobjlist and add it to the multiwidget childlist
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
    TypeTree tr = TypeTree();
    tr.typeTree(FObjRepo.stackobj, 0);

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


class TypeTree {
  
List<FModelView> eltemp = [];
List<FModelView> fmvList = [];

 Widget typeTree(List<FModelView> alist, int lev){
    List<FModelView> coalist = [];
        
      for(int i=0; i<alist.length; i++){
        if(!alist[i].haveChildren()){
          if(alist[i].catId != 0){//Dummy in FObject with catid 0. Its a dummy for when one unselect object 
            alist[i].type = 4;
            fmvList.add(alist[i]);
          }
        }
      }
      for (var element in alist) {
        if(element.haveChildren()){
          coalist.add(element);
        }
      }
      coalist.forEach((element) {
      if(element.haveChildren()){
        element.type = 1;
        fmvList.add(element);
        _runIt(element.childlist(), /*element.level*/0);
      }
    });
    //!Fill list with the new value. Copy them to a new templist and send. 
    //!Clear out the list, so it not updates with the old values
    if(eltemp.isNotEmpty){
      eltemp.removeRange(0, eltemp.length);
    }
    for(var items in fmvList){
      eltemp.add(items);
    }
    fmvList.removeRange(0, fmvList.length);
    //print('in codetree');
    return Container();//FCodeView(eltemp);
  }

 _runIt(List<FModelView> cl, int curlev){

    cl.forEach((element) {
      if(element.haveChildren()){
        int plev = curlev + 1;
        element.type = 3;
        element.level = plev;
        fmvList.add(element);
        _runIt(element.childlist(), plev);
      }else{//!The same?
        int chlev = curlev + 1;
        if(/*element.fmc.objectModel.value.isMultiWidget*/element.isMultiWidget()){//!Even if element has no children? Check it!
          element.type = 3;
          element.level = chlev;
          fmvList.add(element);
        }else{
          element.type = 2;
          element.level = chlev;//&#445588 //&Codegen #445588
          fmvList.add(element);
        }
      }
    });
  }
}