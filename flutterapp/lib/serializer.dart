import 'fmodelview.dart';
import 'package:dart_airtable/dart_airtable.dart';

typedef void idCallback(int id);

class Serializer {
      Serializer({required this.callback});

  final apikey = 'keyBNkvqtAmKUSvfy';
  final base = 'appfVzPdfG0Rt9OgN';
  final table = 'fairmodel';

  final idCallback callback;
  List<FModelView> fmlist = [];
  //DB records
  //moid, position, color, width, height, catId, text, borderradius, elevation, parent

  writeToAPI(Map objmap) async {//! check isCacheChild???
  var airtable = Airtable(apiKey: apikey, projectBase: base);

    for(var key in objmap.keys){
      FModelView objf = objmap[key];
      var test = await airtable.createRecord(table, AirtableRecord(fields: [AirtableRecordField(fieldName: 'moid', value: objf.getMoid)]));
      print(test);
    }
  }

  Future<List<FModelView>> readData() async {
    print('in readdata');
    var airtable = Airtable(apiKey: apikey, projectBase: base);
    var records = await airtable.getAllRecords(table);
    //var test = await airtable.createRecord(record, AirtableRecord(fields: [AirtableRecordField(fieldName: 'moid', value: 500)]));

    
    //print('*1tmpf*' + tmpf.getMoid.toString());

    for(var rec in records){
      FModelView tmpf = FModelView(mcallback: callback);
      tmpf.setMoid = int.parse(rec.getField('moid')!.value.toString());
      tmpf.fmc.fbWidth.value = int.parse(rec.getField('width')!.value.toString());
      fmlist.add(tmpf);
       /*var v = rec.getField('parent')!.value;
       
       if(int.parse(v.toString()) == 210) {
         print('inparse');
         var m = rec.getField('moid')!.value;
         tmpf.setMoid = int.parse(m.toString());
         tmpf.fmc.fbWidth.value = int.parse(rec.getField('width')!.value.toString());

         print('Readad' + tmpf.getMoid.toString());
       }*/
    }

    return fmlist;
  }

}