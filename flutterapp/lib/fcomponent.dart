import 'package:dart_airtable/dart_airtable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'fmodelview.dart';

typedef void idCallback(int id);

class FComponent {//!Change name? FCompnentSerializer?
      FComponent({required this.callback});

  final idCallback callback;
  
  final apikey = 'keyBNkvqtAmKUSvfy';
  final base = 'appfVzPdfG0Rt9OgN';
  final table = 'comptable';

  List<FModelView> fmComponentlist = [];
  List<FModelView> compList = [];
  List<FModelView> topCompList = [];


  saveComponent(FModelView fmv){
  //sz.writeToAPI(objmap);
  }


  Future<List<FModelView>> readComponentData() async {
    
    var airtable = Airtable(apiKey: apikey, projectBase: base);
    var records = await airtable.getAllRecords(table);//!records means all records, not only top components but also its children

    for(var rec in records){
      FModelView tmpf = FModelView(mcallback: callback);
      tmpf.setMoid = int.parse(rec.getField('moid')!.value.toString());
      tmpf.fmc.fbWidth.value = int.parse(rec.getField('width')!.value.toString());
      tmpf.parentId = int.parse(rec.getField('parent')!.value.toString());
      tmpf.type = int.parse(rec.getField('type')!.value.toString());
      tmpf.catId = int.parse(rec.getField('catid')!.value.toString());
      tmpf.name = rec.getField('name')!.value.toString();
      //print(tmpf.name);
      fmComponentlist.add(tmpf);
    }
    
    return fmComponentlist;
  }

  /*addToCompList(List<FModelView> fl){
    /*compList.addAll(fl);

    for(var obj in compList){ 
      if(obj.parentId == 0){//!get the components top object
        for(int i=0; i<compList.length; i++){//!if it has child iterate and add them to the childlist
          if(compList[i].parentId == obj.getMoid){
            obj.fmc.addChild(compList[i]);
          }
        }*/
        for(var comp in fl){
          topCompList.add(comp);//!Only top components inkl. their children in here.
        }
      //}
   // }


  }*/

}