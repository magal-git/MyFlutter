import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutterapp/fmodelview.dart';
import 'package:flutterapp/fobjects.dart';
import 'package:flutterapp/utils.dart';
import 'package:get/get.dart';


class FCodeView extends StatelessWidget {
  FCodeView( this.fmvlist );


  final List<FModelView> fmvlist;

  List<int> donelist = [];
  List<Widget> tmpch = [];

  Widget _tree(int a){
    for(int p=a; p<fmvlist.length; p++){
print('in codeview');
        fmvlist[p].twList.removeRange(0, fmvlist[p].twList.length);//?Clean list every render to avoid duplicates

        if(fmvlist[p].type == 1 && !donelist.contains(fmvlist[p].getMoid)){
          donelist.add(fmvlist[p].getMoid);
          return ExpansionTile(backgroundColor: Colors.yellow,title: Text('Expansion: ' + fmvlist[p].getMoid.toString()),children: [
              funcCL(fmvlist[p], fmvlist[p].childlist()),
              for(int r=0; r<fmvlist[p].twList.length; r++)
                fmvlist[p].twList[r],
         ]);
        }else{//?if(fmvlist[p].type == 4 (Solo) Have no children
          if(!donelist.contains(fmvlist[p].getMoid)) {
            return SizedBox(height: 30, child: Card(child: Text(fmvlist[p].fmc.objectModel.value.catName +':'+ fmvlist[p].getMoid.toString())));
          }
        }
    }
    return SizedBox.shrink();//!Have no children
  }
  funcCL(FModelView fv, List<FModelView> list){//! Enter this func only if multichild object in _tree func above
    for(var obj in list){
      if(obj.type == 2){
        print('type: ' + obj.type.toString());
        donelist.add(obj.getMoid);
        FDummytest fbo = instanceFObject(obj.catId, obj);
        fv.twList.add(ListTile(title: fbo.codeit() /*Text('Tile: ' + obj.getMoid.toString())*/));
      }
      if(obj.type == 3){
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

  @override
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
}