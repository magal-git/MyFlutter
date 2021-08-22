import 'package:flutter/cupertino.dart';
import 'package:flutterapp/fobjrebuilder.dart';

import 'fmodelview.dart';
import 'package:dart_airtable/dart_airtable.dart';

typedef void idCallback(int id);
typedef void changepos(DraggableDetails d, FModelView dfmv);//#f0f

class Serializer {
      Serializer({required this.callback, required this.onChangePos});//#f0f

  final apikey = 'keyBNkvqtAmKUSvfy';
  final base = 'appfVzPdfG0Rt9OgN';
  final table = 'fairmodel';

  final idCallback callback;
  final changepos onChangePos;//#f0f

  List<FModelView> fmlist = [];
  List<FModelView> rebuildlist = [];
  FObjRebuilder fobr = FObjRebuilder();

  //DB records
  //moid, position, color, width, height, catId, text, borderradius, elevation, parent

  /*writeToAPI(Map objmap) async {//! check isCacheChild???
  var airtable = Airtable(apiKey: apikey, projectBase: base);

    for(var key in objmap.keys){
      FModelView objf = objmap[key];
      var test = await airtable.createRecord(table, AirtableRecord(fields: [AirtableRecordField(fieldName: 'moid', value: objf.getMoid)]));
    }
  }*/

  Future<List<FModelView>> readData() async {
    //print('in readdata');
    var airtable = Airtable(apiKey: apikey, projectBase: base);
    var records = await airtable.getAllRecords(table);
    //var rec = await airtable.getRecord(table, 'recVqX3XPTailZYmm');
    //var test = await airtable.createRecord(record, AirtableRecord(fields: [AirtableRecordField(fieldName: 'moid', value: 500)]));

    for(var rec in records){
      FModelView tmpf = FModelView(mcallback: callback, onChangePos: onChangePos,);//#f0f
      tmpf.setMoid = int.parse(rec.getField('moid')!.value.toString());
      tmpf.fmc.fbWidth.value = int.parse(rec.getField('width')!.value.toString());
      tmpf.parentId = int.parse(rec.getField('parent')!.value.toString());
      tmpf.type = int.parse(rec.getField('type')!.value.toString());
      tmpf.catId = int.parse(rec.getField('catid')!.value.toString());


      fmlist.add(tmpf);
    }

    rebuildlist = fobr.reBuildWithChildren(fmlist);

    return rebuildlist;
  }

}