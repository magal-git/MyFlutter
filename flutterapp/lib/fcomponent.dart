import 'package:dart_airtable/dart_airtable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'fmodelview.dart';

typedef void idCallback(int id);

class FComponent {
      FComponent({required this.callback});

  final idCallback callback;
  
  List<FModelView> fmComponentlist = [];
  List<Widget> startcomp = [];

  final apikey = 'keyBNkvqtAmKUSvfy';
  final base = 'appfVzPdfG0Rt9OgN';
  final table = 'comptable';

  saveComponent(FModelView fmv){
  //sz.writeToAPI(objmap);
  }


  Future<List<FModelView>> readComponentData() async {
    
    var airtable = Airtable(apiKey: apikey, projectBase: base);
    var records = await airtable.getAllRecords(table);

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

}