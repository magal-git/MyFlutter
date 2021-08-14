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
print('in codeview');//// Tabort
        fmvlist[p].twList.removeRange(0, fmvlist[p].twList.length);//&Clean list every render to avoid duplicates

        if(fmvlist[p].type == 1 && !donelist.contains(fmvlist[p].getMoid)){
          donelist.add(fmvlist[p].getMoid);
          FDummytest exp = instanceFObject(fmvlist[p].catId, fmvlist[p]);//!1200 //&#445588 //&FDummy #445588
          return Column( children: [exp.codeit(fmvlist[p]),
              funcCL(fmvlist[p], fmvlist[p].childlist()),
              for(int r=0; r<fmvlist[p].twList.length; r++)
                fmvlist[p].twList[r],

            Row(
              // ignore: prefer_const_literals_to_create_immutables
              children: [
                const SizedBox(width: 15,),
                const Text(']', style: TextStyle(fontSize: 10),),
              ],
            ),
         ]);
        }else{//&if(fmvlist[p].type == 4 (Solo) Have no children
          if(!donelist.contains(fmvlist[p].getMoid)) {
            FDummytest solo = instanceFObject(fmvlist[p].catId, fmvlist[p]);//&#445588 //&This is a comment #445588
            return Column(children: [solo.codeit(fmvlist[p])],);
            //SizedBox(height: 30, child: Card(child: Text(fmvlist[p].fmc.objectModel.value.catName +':'+ fmvlist[p].getMoid.toString() + fmvlist[p].type.toString())));
          }
        }
    }
    return Text('');//SizedBox.shrink();//!Have no children
  }
  funcCL(FModelView fv, List<FModelView> list){//! Enter this func only if multichild object in _tree func above
    for(var obj in list){
      if(obj.type == 2){
        print('level: ' + obj.level.toString());//// Tabort
        donelist.add(obj.getMoid);
        FDummytest fbo = instanceFObject(obj.catId, obj);//!1200//&#445588 //&FDummy #445588
        fv.twList.add(Column(children: [fbo.codeit(obj)],));
      }
      if(obj.type == 3){
        donelist.add(obj.getMoid);
        int endtag = obj.level;
        endtag++;//&#445588 endtag(]) should always be 1 more den starttag([) for type 3
        FDummytest expin = instanceFObject(obj.catId, obj);
        fv.twList.add(Column(children: [expin.codeit(obj),       //&#445588 //&This is a comment #445588
           funcCL(obj, obj.childlist()),
           for(int r=0; r<obj.twList.length; r++)
               obj.twList[r],
               
          //Row(children: [SizedBox(width: obj.level*35,), Text(']', style: TextStyle(fontSize: 10)),],)
          Row(children: [
            obj.haveChildren() ? Container(width: 300, padding: EdgeInsets.only(left: endtag*14), child: Text(']', style: TextStyle(fontSize: 10))) : Container()
          ]),

         ]));
      }
    }
    return SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
  
    return 
    Container(width: 320, child:
      Column(children: [
        for(int y=0; y<fmvlist.length; y++)
          _tree(y)
      ],
      )
    );
  }
}