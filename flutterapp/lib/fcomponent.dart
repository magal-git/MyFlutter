import 'package:dart_airtable/dart_airtable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'fmodelview.dart';
import 'fobjrebuilder.dart';

typedef void idCallback(int id);
typedef void changepos(DraggableDetails d, FModelView dfmv);//#f0f

class FComponent {//!Change name? FCompnentSerializer?
      FComponent({required this.callback, required this.onChangePos});//#f0f

  final idCallback callback;
  final changepos onChangePos;
  
  final apikey = 'keyBNkvqtAmKUSvfy';
  final base = 'appfVzPdfG0Rt9OgN';
  final table = 'comptable';

  List<FModelView> fmComponentlist = [];
  List<FModelView> compList = [];
  List<FModelView> topCompList = [];

  //#ff5
  List<FModelView> rebuildlist = [];
  FObjRebuilder fobr = FObjRebuilder();


  saveComponent(FModelView fmv){
  //sz.writeToAPI(objmap);
  }

  Future<List<FModelView>> readComponentData() async {
    
    var airtable = Airtable(apiKey: apikey, projectBase: base);
    var records = await airtable.getAllRecords(table);//!records means all component records, not only top components but also their children

    for(var rec in records){
      FModelView tmpf = FModelView(mcallback: callback, onChangePos: onChangePos,);//#f0f
      tmpf.setMoid = int.parse(rec.getField('moid')!.value.toString());
      tmpf.fmc.fbWidth.value = int.parse(rec.getField('width')!.value.toString());
      tmpf.parentId = int.parse(rec.getField('parent')!.value.toString());
      tmpf.type = int.parse(rec.getField('type')!.value.toString());
      tmpf.catId = int.parse(rec.getField('catid')!.value.toString());
      tmpf.name = rec.getField('name')!.value.toString();
      //print(tmpf.name);
      fmComponentlist.add(tmpf);
    }
    rebuildlist = fobr.reBuildComponentWithChildren(fmComponentlist);
    for(var item in rebuildlist){
      FModelView newid = FModelView(mcallback: callback, onChangePos: onChangePos,);//#f0f
      item.setMoid = newid.getMoid;
      //print(item.name);
      for(var child in item.childlist()){
        FModelView newchid = FModelView(mcallback: callback, onChangePos: onChangePos,);//#f0f  
        child.parentId = item.getMoid;
        child.setMoid = newchid.getMoid;
      }       
    }
    return rebuildlist;
  }

}