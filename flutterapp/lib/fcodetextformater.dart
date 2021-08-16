import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp/constants.dart';
import 'package:flutterapp/fmodelview.dart';
import 'package:flutterapp/fobjects.dart';


class FCodeTextFormater extends StatelessWidget {
    // ignore: use_key_in_widget_constructors
    const FCodeTextFormater({required this.fmv, required this.objcp,});

    final ObjectCodeProps objcp;
    final FModelView fmv;

  @override
  Widget build(BuildContext context) {
    if(fmv.catId == fBUTTON){
      if(fmv.level == 0)fmv.level = 1;

      return Column(children: [
       FTexter.formit('TextButton(', '\n  child:', ' Text("' + objcp.btnText + '"),', fmv.type == 4 ? 0 : fmv.level*15, Colors.black, Colors.green, Colors.black),
       FTexter.formit('style: ', objcp.btnTextColor.toString(), ',', fmv.level*20, Colors.green, Colors.black, Colors.black),
       FTexter.formit('borderradius: ', objcp.borderradius.toString() , ',', fmv.level*20, Colors.green, Colors.black, Colors.black),
       FTexter.formit(')', ',', '', fmv.level*15, Colors.black, Colors.black, Colors.green),
       //FTexter.formit(fmv.isLast && fmv.level>1 ? ']' : '', '', '', fmv.level*12, Colors.black, Colors.black, Colors.green),
      ]);
    }else if(fmv.catId == fCOLUMN){
      if(fmv.haveChildren() && fmv.type != 4){
        return Column(children: [
          FTexter.formit(fmv.parentId > 0 ? 'Column_(' : 'Column('  , ' children:', '\n[', fmv.parentId > 0 ? fmv.level*15 : fmv.level*15, Colors.black, Colors.green, Colors.black),
        ]);
      }else{
        return Column(children: [
          FTexter.formit(fmv.parentId > 0 ? 'Column_(' : 'Column('  ,' children:', ' [] ),', fmv.parentId > 0 ? fmv.level*15 : fmv.level*15, Colors.black, Colors.green, Colors.black),
          //FTexter.formit(fmv.isLast ? ']' : '', '', '', fmv.level*12, Colors.black, Colors.black, Colors.black),
        ]);
      }
    }
    
    return Container();
  }
}

class FTexter{
  static Container formit(String str1, String str2, String str3, double inset, Color col1, Color col2, Color col3){

    return Container(width: 300, padding: EdgeInsets.only(left: inset), child: RichText(text: TextSpan(children: [
      TextSpan(text: str1, style: TextStyle(fontSize: 10, color: col1)),
      TextSpan(text: str2, style: TextStyle(fontSize: 10, color: col2)),
      TextSpan(text: str3, style: TextStyle(fontSize: 10, color: col3)),
    ])));
  }
}

class Colorize {
  static TextSpan txtspan(String str, Color col,){
    return TextSpan(text: str, style: TextStyle(fontSize: 12, color: col));
  }
}



//return Container(width: 300, padding: EdgeInsets.only(left: fmv.level*15), child: Text(fmv.isLast && fmv.level>1 ? 'TextButton\n]' : 'TextButton',));//&OLD
//Text(str, style: TextStyle(color: col))

//return Container(width: 300, padding: EdgeInsets.only(left: fmv.level*5), child: Text(fmv.type > 1 ? 'Column_inside(children:\n [' : 'Column(children:\n[',));
//return Container(width: 300, padding: EdgeInsets.only(left: fmv.level*5), child: Text(fmv.type > 1 ? 'Column_inside([]' : 'Column('),);