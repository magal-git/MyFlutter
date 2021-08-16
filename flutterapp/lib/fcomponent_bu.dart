import 'package:dart_airtable/dart_airtable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../fmodelview.dart';

typedef void idCallback(int id);
typedef void compCallback(FModelView f);

class FComponent {
      FComponent({required this.callback, required this.compcallback});
  

  final idCallback callback;
  final compCallback compcallback;
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
      print('in airtable/*/*//*/*/*//*/*/*/*/*/*/*');
      FModelView tmpf = FModelView(mcallback: callback);
      tmpf.setMoid = int.parse(rec.getField('moid')!.value.toString());
      tmpf.fmc.fbWidth.value = int.parse(rec.getField('width')!.value.toString());
      tmpf.parentId = int.parse(rec.getField('parent')!.value.toString());
      tmpf.type = int.parse(rec.getField('type')!.value.toString());
      tmpf.catId = int.parse(rec.getField('catid')!.value.toString());
      tmpf.name = rec.getField('name')!.value.toString();
      print(tmpf.name);
      fmComponentlist.add(tmpf);
    }
    return fmComponentlist;
  }

  getCachedComp() async{
    
    //List<FModelView> complist = await readComponentData();
    await readComponentData().then((value) {
      print('in readcomp');
      for(var obj in value){ 
        if(obj.parentId == 0){
          for(int i=0; i<value.length; i++){
            if(value[i].parentId == obj.getMoid){
              obj.fmc.addChild(value[i]);
            }
          }
        }
        //obj.parentId == 0 ? startcomp.add(TextButton(child: Text(obj.name), onPressed: () => compcallback(obj))) : Container();
      }
    });
    //startcomp.addAll(await readComponentData());
  }


  /*@override
  Widget build(BuildContext context) {
    
    return //getCachedComp();
    Container(width: 100, height: 100, color: Colors.yellow,);
  }*/
}



/*

//callback(FModelView comp){
    /*
    
     if(comp.type == 4 || comp.type == 1){
       addSerObject(comp);//!<-use this or make new func?
     }
     for(var child in comp.childList()){//!if havechild 
      if(child.type == 2 || child.type == 3){
        addSerChildObject(child);//!<-use this or make new func?
      }
     }
    
    */
  //}

*/