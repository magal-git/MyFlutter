import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp/colorpicker.dart';
import 'package:flutterapp/fmodelview.dart';
import 'package:flutterapp/fstartobjectpanel.dart';
import 'package:get/get.dart';
import 'package:getwidget/components/button/gf_button.dart';
import '../../../../utils.dart';


void main () => runApp(GetMaterialApp(home: RunApp()));

//#region [Main]
class RunApp extends StatelessWidget { @override Widget build(BuildContext context){ return HomePageWidget();}}
//#endregion

class HomePageWidget extends StatefulWidget {//#region [ rgba(30, 30, 40, 0.2) ]
  HomePageWidget({Key? key}) : super(key: key);

  @override
  _HomePageWidgetState createState() => _HomePageWidgetState();
}//#endregion


class _HomePageWidgetState extends State<HomePageWidget> {
   //bool addchild = false;//!ADDCHILD
  //*Members
   late FModelView fmv;

  Map objmap = <int, FModelView>{};
  final scaffoldKey = GlobalKey<ScaffoldState>();
  //!was Widget before
  List<FModelView> stackobj = [];

  //*Methods
  int _mid = 0;

  @override
  initState(){
    super.initState();
    fmv = FModelView(mcallback: handleId);
  }

  handleId(int pid){
    setState(() {
      print('id = $pid');
      _mid = pid;
      fmv = getCurObj(_mid, objmap);
      
      if(fmv.catId == 104){//!ADDCHILD
        fmv.fmc.caddchildCol.value = true;
        //addchild = true;
      }
  });
}

  addObject(int catId){
    setState(() {
      fmv = FModelView(mcallback: handleId,);
      fmv.setCatId = catId;
      _mid = fmv.getMoid;//#Identifies the object
      stackobj.add(fmv);
      objmap[_mid] = fmv;

      if(fmv.catId == 104){//!ADDCHILD
        fmv.fmc.caddchildCol.value = true;
        //addchild = true;
      }
    });
  }

  //! ADDCHILDTOLIST
    
  addChildObject(int catId){
    setState(() {
      FModelView colrowFmv = getCurObj(_mid, objmap);

      fmv = FModelView(mcallback: handleId,);
      fmv.setCatId = catId;
      _mid = fmv.getMoid;//#Identifies the object
      objmap[_mid] = fmv;

      colrowFmv.fmc.addChild(fmv);
      fmv.fmc.caddchildCol.value = false;//!ADDCHILD
      //addchild = false;
      
    });
  }

  //! ADDCHILDTOLIST

  _removeObj(){
    setState(() {
      stackobj.removeAt(stackobj.indexOf(fmv));
    });
  }

int depth = 0;
  _showTree(List<FModelView> alist){//!TREETEST
  List<FModelView> childlist = [];
  
    if(alist.isNotEmpty){
       for(int i=0; i<alist.length; i++){

         if(alist[i].catId != 104 || (alist[i].catId == 104 && alist[i].fmc.columnModel.value.childlist.isEmpty)){
           print(depth.toString() + ':' + alist[i].getMoid.toString());
         }else{
           print(depth.toString() + ':' + alist[i].getMoid.toString());
           childlist = alist[i].fmc.columnModel.value.childlist;
           depth++;
           _showTree(childlist);
         }

//func(alist)//!ITER
         if(alist[i].catId == 104){//?isMultiWidget
            childlist = alist[i].fmc.columnModel.value.childlist;
            if(childlist.isNotEmpty){
              print(depth.toString() + ':' + alist[i].getMoid.toString()); //(2)columnB, (3)columnC, (6)columnD
              depth++;
  _showTree(childlist);//!ITER

            }else{//?isMultiWidget_WithNoChild
              print(depth.toString() + ':' + alist[i].getMoid.toString()); //(1)columnA, (8)columnE
            }
         }else {//?isSingleWidget
              print(depth.toString() + ':' + alist[i].getMoid.toString()); //(4)iconbutton2,> (5)textfield2, (7)image, (9)iconbutton, (10)textfield
          }
        }
    }
  }//!TREETEST


//isParent[ columnB ]
//isChild[ columnC, icon2, text2 ]
//hasnoChildren[ columnA. icon, text ]
  /*
  columnA
  columnB
    > columnC
      > iconbutton2
      > columnD
        > image
        > columnE 
    > textfield2
  iconbutton
  textfield

  */


  selFunc(int id){
    if (fmv.fmc.caddchildCol.value){
      addChildObject(id);
    }else{
      addObject(id);
    }
  }

  unselect(Map tmap){
  
    tmap.forEach((key, value) {
        value.fmc.markFalse();
    });
    fmv.fmc.caddchildCol.value = false;
  }

  //*Methods
  
  @override
  Widget build(BuildContext context) {//#region [ rgba(180, 120, 120, 0.2) ]//#endregion
  print('in build');
  
    fmv.chClickCol(fmv, _mid, objmap);//!Revisite

    return 
    GestureDetector(onTap: () => unselect(objmap),//?CLICKVOID TODO

      child: Scaffold( key: scaffoldKey, floatingActionButton: FloatingActionButton(onPressed: _removeObj,), appBar: 
          AppBar( backgroundColor: 
            Colors.lightBlue, //leading: 
            //FloatingActionButton(onPressed: () => fmv.chClickVoid(/*fmv,*/ objmap),),//!Revisite2
          ),
      body:
          SafeArea(child:
            Stack(children: [
              Container(color: Colors.grey, width: 240,),
                      if(stackobj.isNotEmpty)
                      for(int i=0; i<stackobj.length; i++)
                          stackobj[i],    
                        

                  //!UDEV PUT IN SEP WIDGET?
                  //#10123
                  
                  StartObjectPanel(fmodelview: fmv, addobject: selFunc),

                  //#10123
                  //!PUT IN SEP WIDGET

                
                   Align(alignment: Alignment(1, 0), child: 
                     Column( mainAxisSize: MainAxisSize.max, children: 
                          [
                            fmv.makeSidePanel(),
                            GFButton(onPressed: () => _showTree(stackobj)),//!TREETEST
                          ],
                     ),
                   )
               ],),
          ),
          
          drawer: Container(width: 150, child: Drawer(child: Text('im a drawer'),)),
      ),
    );
  }
}


