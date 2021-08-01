import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutterapp/fmodelview.dart';
import 'package:get/get.dart';


class FTreeView extends StatelessWidget {
  FTreeView( this.fmvlist );

  final List<FModelView> fmvlist;

  List<int> donelist = [];
  List<Widget> tmpch = [];

  Widget _tree(int a){
    for(int p=a; p<fmvlist.length; p++){

        fmvlist[p].twList.removeRange(0, fmvlist[p].twList.length);

        if(fmvlist[p].type == 1 && !donelist.contains(fmvlist[p].getMoid)){
          donelist.add(fmvlist[p].getMoid);
          return ExpansionTile(title: Text('Expansion: ' + fmvlist[p].getMoid.toString()),children: [
              funcCL(fmvlist[p], fmvlist[p].childlist()),
              for(int r=0; r<fmvlist[p].twList.length; r++)
                fmvlist[p].twList[r],
         ]);
        }else{
          if(!donelist.contains(fmvlist[p].getMoid)) {
            return Card(child: Text('Card ' + fmvlist[p].getMoid.toString()));
          }//!Have no children
        }
    }
    return Card();//!Have no children
  }
  funcCL(FModelView fv, List<FModelView> list){
    for(var obj in list){
      if(obj.type == 2){
        donelist.add(obj.getMoid);
        fv.twList.add(ListTile(title: Text('Tile: ' + obj.getMoid.toString())));
      }
      if(obj.type == 3){
        donelist.add(obj.getMoid);
        fv.twList.add(ExpansionTile(title: Text('Expansion_inside: ' + obj.getMoid.toString()),children: [
           funcCL(obj, obj.childlist()),
           for(int r=0; r<obj.twList.length; r++)
               obj.twList[r],
         ]));
      }
    }
    return Text('out of');
  }


  @override
  Widget build(BuildContext context) {
    //_tree();
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

/*
donelist.add(ExpansionTile(title: Text(typelist[p]),
                        children: [
                          ListTile(title: Text(typelist[p+1]), contentPadding: EdgeInsets.fromLTRB(60,0,0,0),)
                        ],
                      )
          
         );

         donelist.add(ExpansionTile(title: Text('Expansion')));
        }else if(typelist[p] == 'Expansion_inside'){
          donelist.add(ExpansionTile(title: Text('Expansion_inside')));
        }else if(typelist[p] == 'Tile'){
          donelist.add(ListTile(title: Text('Tile')));
        }else{
          donelist.add(Card(child: Text('SoloMC')));
        }
*/