import 'package:flutter/gestures.dart';
import 'package:flutterapp/constants.dart';
import 'package:flutterapp/fmodelcontroller.dart';
import 'package:flutterapp/fobjects.dart';
import 'package:flutterapp/utils.dart';
import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math';

typedef void midCallback(int id);
typedef void changepos(DraggableDetails d, FModelView dfmv);

class FModelView extends StatelessWidget{
      FModelView({required this.mcallback, required this.onChangePos});//#f0f

//*Constructer member
  final midCallback mcallback;
  final changepos onChangePos;//#f0f

  //*Members
  FModelController fmc = FModelController();

  int catId = 0;
  int level = 0;
  int parentId = 0;
  String name = '';//#599

  List<Widget> twList = [];//! in treeviewpanel this is the link to each fmodelview 
  int type = 0; //1=Expansion; 2=Tile; 3=Expansion_inside; 4=Solo
  final _position = const Offset(300,300).obs;

  //*Methods
  bool haveChildren(){
    return fmc.objectModel.value.childlist.isNotEmpty;
  }

  List<FModelView> childlist(){
    return fmc.objectModel.value.childlist;
  }

  bool isMultiWidget() {
    //List<int> mwlist = [104,105];//!Change 104/105 to all MCW-TODO
    if(mwCatIds.contains(catId)){
      return true;
    }
    return false;
  }

  int get getMoid{
    return fmc.moid;
  }

  set setMoid(int id){
    fmc.moid = id;
  }

  set setCatId(var catid){
    catId = catid;

    /*if(catid == fBUTTON) {//! Use or not use?
      fmc.fbWidth.value = 150;
      fmc.fbHeight.value = 30;
    }else if(catid == fICBUTTON){
      fmc.fbWidth.value = 60;
      fmc.fbHeight.value = 60;
    }else if(catid == fTEXTFIELD){
      fmc.fbWidth.value = 150;
      fmc.fbHeight.value = 40;
    }*/
  }

  Widget makeSidePanel(){
    return Obx(() =>
    createSidePanel(this, catId));
  }

  markSelObj(FModelView fmv, Map tmap){
    tmap.forEach((key, value) {
      value.fmc.markFalse();//&Unmark all objects
    });
        fmv.fmc.markTrue();//&Now mark the selected one
  }


  //#734
  bool down = false;
  int tmpid = 0;
  
  letest(){
    print('Listener: ' + this.getMoid.toString());
    tmpid = this.getMoid;
    down = true;
  }
  letest2(){
    if(down){
      print('MouseRegion: ' + this.getMoid.toString());
      print('tmpid: ' + tmpid.toString());
      down = false;
    }
  }
  //#734

  @override
  Widget build(BuildContext context){
    print('8*8 instanceobject' + catId.toString());

    return
    Obx(() {
      
      return 
      //Positioned(left: _position.value.dx, top: _position.value.dy, child://!Orginalprint('MouseRegion: ' + this.getMoid.toString())
      //Positioned(left: fmc.positionX.value, top: fmc.positionY.value, child://! 1109print('Listener: ' + this.getMoid.toString())
        Listener(onPointerDown: (e) => letest(),//#734
          child: MouseRegion(onEnter: (e) => letest2() ,//#734
            child: Draggable(child:
                instanceObject(catId, this),
                //Container(color: Colors.yellow,),
            feedback:
                instanceObject(catId, this),
                //Container(color: Colors.yellow,),
            onDragEnd: (details){
                //_position.value = details.offset - const Offset(0.0, 56.0);
                onChangePos(details, this);
                //! 1109 ***********************************************************
                /*fmc.positionX.value = details.offset.dx;// - const Offset(0.0, 56.0);
                fmc.positionY.value = details.offset.dy - Offset(0.0, 56.0).dy;
                Offset of = Offset(fmc.positionX.value, fmc.positionY.value);
                fmc.setPosition(of);*/
                //! 1109 ***********************************************************
            },
            
            ),
          ),
        );//#734
      //);

   });
  }
}