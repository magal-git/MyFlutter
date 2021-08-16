import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutterapp/fmodelview.dart';
import 'package:get/get.dart';


class FModelController extends GetxController{
  
  /*final*/ int moid = Random().nextInt(1000)+1;
  var bradius = 0.obs;
  var caddchildCol = false.obs;//!Set color to object if column is selected (in main)
  final colModel = ColModel().obs;

  var fbHeight = 50.obs;
  var fbWidth = 180.obs;

  var hpb = HelperBtn().obs;
  var marked = false.obs;

  final objectModel = ObjectModel().obs;
  //!1109
  var positionX = 300.0.obs;
  var positionY = 300.0.obs;
  
  setPosition(Offset o){
    positionX.value = o.dx;
    positionY.value = o.dy;
  }
  //!1109

  Color prevcol = Colors.white;//!PRV

  markTrue() => marked.value = true;
  markFalse() => marked.value = false;

  chText(String txt) {
     hpb.value = HelperBtn(btntext: txt);
  }

 //*ObjectModel methods
  incSpacing(){
    objectModel.update((val) {
      val!.spacing++;
    });
  }

  decSpacing(){
    objectModel.update((val) {
      val!.spacing--;
    });
  }

 //*ObjectModel methods

  chElevation(){
    hpb.update((val) {
      val!.elevation +=2;
    });
  }

  incBradius() => bradius++;

  addChild(FModelView f){
    objectModel.update((val) {
      val!.childlist.add(f);
    });
  }

  removeChild(FModelView ch){
    objectModel.update((val) {
      val!.childlist.remove(ch);
    });
  }

  List<Widget> get getChildList{
      return objectModel.value.childlist;
  }

  chCol(Color c) {
     colModel.update((val) { 
       val!.btncol = c;
     });
  }

  chTextCol(Color tc){
    colModel.update((val) {
      val!.txtcol = tc;
    });
  }

  Color get getCurCol{
      prevcol = colModel.value.btncol;
    return prevcol;
  }

  incW() => fbWidth += 2;
  decW() => fbWidth -= 2;
  incH() => fbHeight += 2;
  decH() => fbHeight -= 2;
}

class ColModel{
  Color btncol = Colors.amber;
  Color txtcol = Colors.white;
}

class ObjectModel{
  String catName = '';
  List<FModelView> childlist = [];
  double spacing = 4.0;
}

class HelperBtn {
  HelperBtn({this.btntext = 'Button', this.borderRadius = 0, this.elevation = 0});

  double borderRadius;
  String btntext;
  double elevation;
}