import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutterapp/fmodelview.dart';
import 'package:flutterapp/utils.dart';
import 'package:get/get.dart';


class FSerializeView{ //extends StatelessWidget {
  FSerializeView( this.fmvlist );

  final List<FModelView> fmvlist;

  List<int> donelist = [];
  List<FModelView> fli = [];

  List<FModelView> tree(){
    for(int p=0; p<fmvlist.length; p++){

      fmvlist[p].twList.removeRange(0, fmvlist[p].twList.length);//&Clean list every render to avoid duplicates

      if(fmvlist[p].type == 1 && !donelist.contains(fmvlist[p].getMoid)){
        donelist.add(fmvlist[p].getMoid);
        //return ExpansionTile(backgroundColor: Colors.yellow,title: Text('Expansion: ' + fmvlist[p].getMoid.toString()),children: [
          fli.add(fmvlist[p]);
            /*funcCL(fmvlist[p], fmvlist[p].childlist()),
            for(int r=0; r<fmvlist[p].twList.length; r++)
              fmvlist[p].twList[r],*/
       //]);
      }else{//&if(fmvlist[p].type == 4 (Solo) Have no children
        if(fmvlist[p].type == 4 && !donelist.contains(fmvlist[p].getMoid)) {
          //return SizedBox(height: 30, child: Card(child: Text(fmvlist[p].fmc.objectModel.value.catName +':'+ fmvlist[p].getMoid.toString())));
          fli.add(fmvlist[p]);
        }
      }
    }
    return fli;
    //return SizedBox.shrink();//!Have no children
  }
  
}
  /*@override
  Widget build(BuildContext context) {
  
    return 
    Container(width: 230, child:
      Column(children: [
        for(int y=0; y<fmvlist.length; y++)
          _tree(y)
      ],
      )
    );
  }
}*/





/*
funcCL(FModelView fv, List<FModelView> list){//! Enter this func only if multichild object in _tree func above
    for(var obj in list){
      if(obj.type == 2){
        donelist.add(obj.getMoid);
        fv.twList.add(ListTile(title: Text('Tile: ' + obj.getMoid.toString())));
      }
      if(obj.type == 3){
        //print('object type 3 ' + obj.getMoid.toString());
        donelist.add(obj.getMoid);
        fv.twList.add(ExpansionTile(backgroundColor: Colors.blueGrey.shade200, title: Text('Expansion_inside: ' + obj.getMoid.toString()),children: [
           funcCL(obj, obj.childlist()),
           for(int r=0; r<obj.twList.length; r++)
               obj.twList[r],
         ]));
      }
    }
    return SizedBox.shrink();
  }

*/