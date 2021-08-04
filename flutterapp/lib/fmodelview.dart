import 'package:flutterapp/constants.dart';
import 'package:flutterapp/fmodelcontroller.dart';
import 'package:flutterapp/utils.dart';
import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math';

typedef void midCallback(int id);


class FModelView extends StatelessWidget{
      FModelView({required this.mcallback});


  //*Members
  FModelController fmc = FModelController();
  bool isparent = false;
  int level = 0;
  int catId = 0;

  List<Widget> twList = [];
  int type = 0; //1=Expansion; 2=Tile; 3=Expansion_inside; 4=Solo

  final _position = const Offset(300,300).obs;

  //*Constructer member
  final midCallback mcallback;

  //*Methods

  //!TREEVIEW PROPS
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
  //!TREEVIEW PROPS

  int get getMoid{
    return fmc.moid;
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
      value.fmc.markFalse();//?Unmark all objects
    });
        fmv.fmc.markTrue();//?Now mark the selected one
  }

  @override
  Widget build(BuildContext context){
    print('in instanceobject');

    return
    Obx(() {
      
      return 
      //Positioned(left: _position.value.dx, top: _position.value.dy, child://! 1109
      Positioned(left: fmc.positionX.value, top: fmc.positionY.value, child:
        Draggable(child:
            instanceObject(catId, this),
        feedback:
            instanceObject(catId, this),
        onDragEnd: (details){
            //_position.value = details.offset - const Offset(0.0, 56.0);//! 1109
            fmc.positionX.value = details.offset.dx;// - const Offset(0.0, 56.0);
            fmc.positionY.value = details.offset.dy;
            Offset of = Offset(fmc.positionX.value, fmc.positionY.value);
            fmc.setPosition(of);//! 1109
        },
        ),
      );

   });
  }
}