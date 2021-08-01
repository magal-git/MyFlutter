import 'package:flutterapp/fmodelcontroller.dart';
import 'package:flutterapp/utils.dart';
import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math';

typedef void midCallback(int id);


class FModelView extends StatelessWidget{
      FModelView({required this.mcallback});

  //!TREEVIEW PROPS
  bool haveChildren(){
    return fmc.columnModel.value.childlist.isNotEmpty;
  }
  List<FModelView> childlist(){
    return fmc.columnModel.value.childlist;
  }
  bool isparent = false;
  //bool ischild = false;
  //bool ischildandparent = false;
  bool isMultiChild() => catId == 104;//!Change 104 to all MCW
  int level = 0;
  //!TREEVIEW PROPS


  int catId = 0;
  //*Members
  FModelController fmc = FModelController();
  //bool addchild = false;
  int type = 0; //1=Expansion; 2=Tile; 3=Expansion_inside; 4=Solo
  List<Widget> twList = [];

  //*Constructer member
  final midCallback mcallback;

  //*Methods
  final int moid = Random().nextInt(1000);

  final _position = const Offset(300,300).obs;

  int get getMoid{
    return moid;
  }

  set setCatId(var catid){
    catId = catid;
    //print('setcatid: $catId');
    if(catid == 101) {
      fmc.fbWidth.value = 150;
      fmc.fbHeight.value = 30;
    }else if(catid == 102){
      fmc.fbWidth.value = 60;
      fmc.fbHeight.value = 60;
    }else if(catid == 103){
      fmc.fbWidth.value = 150;
      fmc.fbHeight.value = 40;
    }
  }

  Widget makeSidePanel(){
    return Obx(() =>
    createSidePanel(this, catId));
  }

  chClickCol(FModelView fmv, int curid, Map tmap){
    tmap.forEach((key, value) {
      value.fmc.markFalse();
    });
        fmv.fmc.markTrue();
  }
  /*chClickVoid(/*FModelView fmv,*/ Map tmap){
    tmap.forEach((key, value) {
      value.fmc.markFalse();
    });
    
    fmc.caddchild.value = false;
    
  }*/

  /*bool get getAddchild{
    return addchild;
  }*/

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