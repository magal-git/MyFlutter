import 'package:flutter/material.dart';
import 'package:flutterapp/colorpicker.dart';
import 'package:flutterapp/constants.dart';
import 'package:flutterapp/fmodelview.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get.dart';
import 'fobjects.dart';

TextEditingController contr = TextEditingController();

//#region [ rgba(30, 30, 40, 0.2) ]//#endregion
FModelView getCurObj(int curid, Map tmap){

  if(tmap.containsKey(curid)){
    return tmap[curid];
  }else{
    print('no oki');
  }

  return tmap[0];
}
//#region [ rgba(90, 150, 40, 0.2) ]//#endregion
Widget instanceObject(int cid, FModelView fmv){//!Refactor. Put in FModelView?
  
    switch (cid){
      case 0:
        return 
          FDummy(callback: fmv.mcallback,);
      case fBUTTON:
        return 
          FBuObject(callback: fmv.mcallback, thisid: fmv.fmc.moid, bw: fmv.fmc.fbWidth.toDouble(), bh: fmv.fmc.fbHeight.toDouble(), colModel: fmv.fmc.colModel.value, 
          marked: fmv.fmc.marked.value, hlpb: fmv.fmc.hpb.value, borderradius: fmv.fmc.bradius.toDouble(), objectModel: fmv.fmc.objectModel.value,); 
      case fICBUTTON:
        return
          FIcBuObject(callback: fmv.mcallback, thisid: fmv.fmc.moid, bw: fmv.fmc.fbWidth.toDouble(), bh: fmv.fmc.fbHeight.toDouble(), col: Colors.amber,
          marked: fmv.fmc.marked.value, objectModel: fmv.fmc.objectModel.value,);
       case fTEXTFIELD:
       return
          FTextFObject(callback: fmv.mcallback, thisid: fmv.fmc.moid, bw: fmv.fmc.fbWidth.toDouble(), bh: fmv.fmc.fbHeight.toDouble(), col: Colors.white,
          marked: fmv.fmc.marked.value, objectModel: fmv.fmc.objectModel.value,);
       case fCOLUMN://!COL
       return
          FColumnObject(callback: fmv.mcallback, thisid: fmv.fmc.moid, marked: fmv.fmc.marked.value, objectModel: fmv.fmc.objectModel.value,);
       case fROW://!ROW
       return
          FRowObject(callback: fmv.mcallback, thisid: fmv.fmc.moid, marked: fmv.fmc.marked.value, objectModel: fmv.fmc.objectModel.value,);
    }

    return Container(child: Text('Empty'),);
    
  }
//#region [ rgba(30, 30, 40, 0.2) ]//#endregion
Widget createSidePanel(FModelView fmv, int catid){

      //#(€4)This occures everytime button text change, must have!
      //! Can it be somewhere else?
      String newtext = fmv.fmc.hpb.value.btntext;
      int offset = newtext.length;
      TextEditingController contr = TextEditingController(text: newtext);
      contr.value = TextEditingValue(text: newtext, selection: TextSelection.fromPosition(TextPosition(offset: offset)));
      //#End(€4)

print('in createsidepanel');
    switch(catid){
        case 0:
        return
        const SizedBox.shrink();
        case fBUTTON:
          return
          Column(children: [
              Text(fmv.fmc.fbWidth.toString()),
              Text(fmv.fmc.hpb.value.btntext),
              IconButton(onPressed: fmv.fmc.incW, icon: Icon(Icons.add, color: Colors.blue, size: 30,), iconSize: 30,),
              IconButton(onPressed: fmv.fmc.decW, icon: Icon(Icons.minimize, color: Colors.blue, size: 30,), iconSize: 30,),
              IconButton(onPressed: fmv.fmc.incH, icon: Icon(Icons.height, color: Colors.blue, size: 30,), iconSize: 30,),
              //IconButton(onPressed: fmv.fmc.chCol, icon: Icon(Icons.color_lens_outlined, color: Colors.blue, size: 30,), iconSize: 30,),
              SizedBox(width: 100,
                child: TextFormField(onChanged: (text) {
                   fmv.fmc.chText(text);
                  }, controller: contr //#(€4)
                ),
              ),
              Text('Borderradius'),
              Text(fmv.fmc.bradius.toString()),
              IconButton(onPressed: fmv.fmc.incBradius, icon: Icon(Icons.add, color: Colors.green, size: 30,), iconSize: 30,),
              //FColorPicker(changeColor: fmv.fmc.chCol),//!ORG
              FColorPicker(changeColor: fmv.fmc.chCol, prevcolor: fmv.fmc.getCurCol,),//!PRV
              IconButton(onPressed: fmv.fmc.chElevation, icon: Icon(Icons.add, color: Colors.green, size: 30,), iconSize: 30,),
              //FColorPicker(changeColor: fmv.fmc.chTextCol),

          ]);
        case fICBUTTON:
          return
          Column(children: [
            Text(fmv.fmc.fbWidth.toString()),
              IconButton(onPressed: fmv.fmc.incW, icon: Icon(Icons.add, color: Colors.blue, size: 30,), iconSize: 30,),
              IconButton(onPressed: fmv.fmc.decW, icon: Icon(Icons.minimize, color: Colors.blue, size: 30,), iconSize: 30,),
              IconButton(onPressed: fmv.fmc.incH, icon: Icon(Icons.height, color: Colors.blue, size: 30,), iconSize: 30,),
              //IconButton(onPressed: fmv.fmc.chCol, icon: Icon(Icons.color_lens_outlined, color: Colors.blue, size: 30,), iconSize: 30,),
          ]);
          case fTEXTFIELD:
          return
          Column(children: [
            Text(fmv.fmc.fbWidth.toString()),
              IconButton(onPressed: fmv.fmc.incW, icon: Icon(Icons.add, color: Colors.blue, size: 30,), iconSize: 30,),
              IconButton(onPressed: fmv.fmc.decW, icon: Icon(Icons.minimize, color: Colors.blue, size: 30,), iconSize: 30,),
              IconButton(onPressed: fmv.fmc.incH, icon: Icon(Icons.height, color: Colors.blue, size: 30,), iconSize: 30,),
          ]);
          case fCOLUMN:
          return
          Column(children: [
              Text('col spacing' + ':' + fmv.fmc.objectModel.value.spacing.toString()),
              IconButton(onPressed: fmv.fmc.incSpacing, icon: Icon(Icons.add, color: Colors.blue, size: 30,), iconSize: 30,),
              IconButton(onPressed: fmv.fmc.decSpacing, icon: Icon(Icons.minimize, color: Colors.blue, size: 30,), iconSize: 30,),
          ]);
          case fROW:
          return
          Column(children: [
              Text('row spacing' + ':' + fmv.fmc.objectModel.value.spacing.toString()),
              IconButton(onPressed: fmv.fmc.incSpacing, icon: Icon(Icons.add, color: Colors.blue, size: 30,), iconSize: 30,),
              IconButton(onPressed: fmv.fmc.decSpacing, icon: Icon(Icons.minimize, color: Colors.blue, size: 30,), iconSize: 30,),
          ]);
      }

      // ignore: avoid_unnecessary_containers
      return Container(child: Text(fmv.fmc.fbWidth.toString()));
  }
  //#region [ rgba(90, 150, 40, 0.2) ]//#endregion



FDummytest instanceFObject(int cid, FModelView fmv){
  
    switch (cid){
      case 0:
        return 
          FDummy(callback: fmv.mcallback,);
      case fBUTTON:
        return 
          FBuObject(callback: fmv.mcallback, thisid: fmv.fmc.moid, bw: fmv.fmc.fbWidth.toDouble(), bh: fmv.fmc.fbHeight.toDouble(), colModel: fmv.fmc.colModel.value, 
          marked: fmv.fmc.marked.value, hlpb: fmv.fmc.hpb.value, borderradius: fmv.fmc.bradius.toDouble(), objectModel: fmv.fmc.objectModel.value,);
      case fICBUTTON:
        return
          FIcBuObject(callback: fmv.mcallback, thisid: fmv.fmc.moid, bw: fmv.fmc.fbWidth.toDouble(), bh: fmv.fmc.fbHeight.toDouble(), col: Colors.amber,
          marked: fmv.fmc.marked.value, objectModel: fmv.fmc.objectModel.value,);
       case fTEXTFIELD:
       return
          FTextFObject(callback: fmv.mcallback, thisid: fmv.fmc.moid, bw: fmv.fmc.fbWidth.toDouble(), bh: fmv.fmc.fbHeight.toDouble(), col: Colors.white,
          marked: fmv.fmc.marked.value, objectModel: fmv.fmc.objectModel.value,);
       case fCOLUMN://!COL
       return
          FColumnObject(callback: fmv.mcallback, thisid: fmv.fmc.moid, marked: fmv.fmc.marked.value, objectModel: fmv.fmc.objectModel.value,);
       case fROW://!ROW
       return
          FRowObject(callback: fmv.mcallback, thisid: fmv.fmc.moid, marked: fmv.fmc.marked.value, objectModel: fmv.fmc.objectModel.value,);
    }

    return FDummy(callback: fmv.mcallback);//Container(child: Text('Empty'),);
    
  }