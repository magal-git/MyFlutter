import 'package:flutter/material.dart';
import 'package:flutterapp/fmodelview.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';


class FModelController extends GetxController{
  var positionX = 300.0.obs;
  var positionY = 300.0.obs;

  var fbWidth = 100.obs;
  var fbHeight = 50.obs;

  Color prevcol = Colors.white;//!PRV

  //#Mark
  var marked = false.obs;

  markTrue() => marked.value = true;
  markFalse() => marked.value = false;
  //#

  //#Helper
  var hpb = HelperBtn().obs;

  chText(String txt) {
     hpb.value = HelperBtn(btntext: txt);
  }
  //#

  //#ELV
  chElevation(){
    hpb.update((val) {
      val!.elevation +=2;
    });
  }
  //#ELV

  var bradius = 0.obs;
  incBradius() => bradius++;

  //!ADDC
  final columnModel = ColumnModel().obs;

  addChild(FModelView f){
    columnModel.update((val) {
      val!.childlist.add(f);
    });
  }
  //!ADDC

  //#COLOR MODEL
  final colModel = ColModel().obs;

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
  Color get getCurCol{//!PRV
      prevcol = colModel.value.btncol;
    return prevcol;
  }
  //#COLOR MODEL

  incW() => fbWidth += 2;
  decW() => fbWidth -= 2;

  incH() => fbHeight += 2;
  decH() => fbHeight -= 2;
  
}

class ColModel{
  Color btncol = Colors.amber;
  Color txtcol = Colors.white;
}
//!ADDC
class ColumnModel{
  List<Widget> childlist = [];
}

//!

class HelperBtn {
  HelperBtn({this.btntext = 'Button', this.borderRadius = 0, this.elevation = 0});

  String btntext;
  double borderRadius;

  double elevation;
}