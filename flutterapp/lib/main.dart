import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp/colorpicker.dart';
import 'package:flutterapp/fmodelview.dart';
import 'package:flutterapp/fstartobjectpanel.dart';
import 'package:get/get.dart';
import 'package:getwidget/components/button/gf_button.dart';
import '../../utils.dart';


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

//!TreeViewLevels
  _showTree(List<FModelView> alist, int lev){
  List<FModelView> coalist = [];
        
          for(int i=0; i<alist.length; i++){
            if(!alist[i].haveChildren()){
              print(alist[i].getMoid.toString());
            }
          }
        
          for (var element in alist) {
            if(element.haveChildren()){
              coalist.add(element);
            }
          }
        
        coalist.forEach((element) {
          if(element.haveChildren()){
            element.isparent = true;
            print(element.getMoid.toString() + ':' + element.level.toString());
            _runIt(element.childlist(), element.level);
          }else{
              int clev = lev + 1;
              String space = getPrintOut(clev);
              print(space + element.getMoid.toString() + ':' + clev.toString());
          }
        });
  }

  _runIt(List<FModelView> cl, int curlev){

    cl.forEach((element) {
      if(element.haveChildren()){
        int plev = curlev + 1;
        String space = getPrintOut(plev);
        print(space + element.getMoid.toString() + ':' + plev.toString());
        //_showTree(element.childlist(), false, plev);
        _runIt(element.childlist(), plev);
      }else{
        element.ischild = true;
        int chlev = curlev + 1;
        String space = getPrintOut(chlev);
        print(space + element.getMoid.toString() + ':' + chlev.toString());
      }
    }); 
  }
//!TreeViewLevels

String getPrintOut(int t){
  switch (t) {
    case 1:
      return ' |--';
    case 2:
    return '   |--';
      break;
    default:
    return '';
  }
}

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
                            GFButton(onPressed: () => _showTree(stackobj, 0)),//!TREETEST
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


