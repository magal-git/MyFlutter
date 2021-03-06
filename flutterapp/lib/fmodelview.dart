import 'package:flutterapp/fmodelcontroller.dart';
import 'package:flutterapp/utils.dart';
import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math';

typedef void midCallback(int id);


class FModelView extends StatelessWidget{
      FModelView({required this.mcallback});

  int catId = 0;
  //*Members
  FModelController fmc = FModelController();

  //*Constructer member
  final midCallback mcallback;

  //*Methods
  final int moid = Random().nextInt(100);

  final _position = const Offset(300,300).obs;

  int get getMoid{
    return moid;
  }

  set setCatId(var catid){
    catId = catid;
    //print('setcatid: $catId');
    if(catid == 101) {//!TABORT?
      fmc.fbWidth.value = 150;
      fmc.fbHeight.value = 30;
    }else if(catid == 102){
      fmc.fbWidth.value = 60;
      fmc.fbHeight.value = 60;
    }else if(catid == 103){
      fmc.fbWidth.value = 150;
      fmc.fbHeight.value = 40;
    }//!TABORT?
  }

  Widget makeSidePanel(){
    return Obx(() =>
    createSidePanel(this, catId));
  }

  chClickCol(FModelView fmv, int curid, Map tmap){
    
    tmap.forEach((key, value) {
      //value.fmc.curColor.value = value.fmc.bufColor.value;
      value.fmc.markFalse();
    });
      //fmv.fmc.curColor.value = Colors.grey;
        fmv.fmc.markTrue();
  }

  chClickVoid(FModelView fmv, Map tmap){
    tmap.forEach((key, value) {
      //value.fmc.curColor.value = value.fmc.bufColor.value;
      value.fmc.markFalse();
    });
  }

  @override
  Widget build(BuildContext context){
    print('in instanceobject');

    return
    Obx(() {
      
      return 
      Positioned(left: _position.value.dx, top: _position.value.dy, child:
        Draggable(child:
            instanceObject(catId, this),
        feedback:
            instanceObject(catId, this),
        onDragEnd: (details){
            _position.value = details.offset - Offset(0.0, 56.0);
        },
        ),
      );

   });
  }
}