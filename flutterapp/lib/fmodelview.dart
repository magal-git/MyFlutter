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

  //!TREEVIEW PROPS
  bool haveChildren(){
    return fmc.objectModel.value.childlist.isNotEmpty;
  }
  List<FModelView> childlist(){
    return fmc.objectModel.value.childlist;
  }
  bool isparent = false;
  
  bool isMultiWidget() {
    //List<int> mwlist = [104,105];//!Change 104/105 to all MCW-TODO
    if(mwCatIds.contains(catId)){
      return true;
    }
    return false;
  }

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
    print('in fmv setcatid '+ catId.toString());
    if(catid == fBUTTON) {
      fmc.fbWidth.value = 150;
      fmc.fbHeight.value = 30;
    }else if(catid == fICBUTTON){
      fmc.fbWidth.value = 60;
      fmc.fbHeight.value = 60;
    }else if(catid == fTEXTFIELD){
      fmc.fbWidth.value = 150;
      fmc.fbHeight.value = 40;
    }
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
      Positioned(left: _position.value.dx, top: _position.value.dy, child:
        Draggable(child:
            instanceObject(catId, this),
        feedback:
            instanceObject(catId, this),
        onDragEnd: (details){
            _position.value = details.offset - const Offset(0.0, 56.0);
        },
        ),
      );

   });
  }
}