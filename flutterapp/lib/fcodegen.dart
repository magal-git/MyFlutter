import 'package:flutterapp/constants.dart';
import 'package:flutterapp/fmodelcontroller.dart';
import 'package:flutterapp/fobjects.dart';
import 'package:flutterapp/utils.dart';
import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math';

import 'fcodeviewpanel.dart';
import 'fmodelview.dart';


class Codegen {
  
List<FModelView> eltemp = [];
List<FModelView> fmvList = [];
//!TreeViewLevels
 Widget codeTree(List<FModelView> alist, int lev){
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
    return FCodeView(eltemp);
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
//!TreeViewLevels***************************************************************






}