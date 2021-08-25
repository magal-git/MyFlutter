import 'dart:html';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterapp/fcodegen.dart';
import 'package:flutterapp/fcomponent.dart';
import 'package:flutterapp/fmodelview.dart';
import 'package:flutterapp/fobjects.dart';
import 'package:flutterapp/fobjrepo.dart';
import 'package:flutterapp/fstartobjectpanel.dart';
import 'package:flutterapp/ftreeviewpanel.dart';
import 'package:flutterapp/myfiles/listviewtest.dart';
import 'package:flutterapp/myfiles/mycard.dart';
import 'package:flutterapp/serializer.dart';
import 'package:get/get.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:flutterapp/utils.dart';
import 'package:hive/hive.dart';

import '../../fserialtreegen.dart';
import 'fcompserializergen.dart';

//!NOTES
//! 1109 = Serializer
//! 599  = Component
//! 734  = onEnter
//! 778  = Painter 

void main () {
  Hive.init('');
  Hive.openBox('myBox');
  runApp(GetMaterialApp(home: RunApp()));
}

//#region [Main]
class RunApp extends StatelessWidget { @override Widget build(BuildContext context){ return HomePageWidget();/*MyApp();*/}}
//#endregion

class HomePageWidget extends StatefulWidget {//#region [ rgba(70, 70, 80, 0.1) ]
  HomePageWidget({Key? key}) : super(key: key);

  @override
  _HomePageWidgetState createState() => _HomePageWidgetState();
}//#endregion


class _HomePageWidgetState extends State<HomePageWidget> {

  Codegen cgen = Codegen();
  List<FModelView> comp = [];
  bool done = false;

  List<FModelView> eltemp = [];
  List<FModelView> fmvList = [];

  //*Members
  late FModelView fmv;
  late FComponent fc;
  late FSerializeTreeGen sztrgen;
  late FCompSerializeGen compszgen;

  int gogo = 0;
  int gotest = 0;
  //Map objmap = <int, FModelView>{};
  final scaffoldKey = GlobalKey<ScaffoldState>();
  //List<FModelView> stackobj = [];

  List<FModelView> vall = [];//#599
  List<FModelView> szvall = [];//!1109

   int _mid = 0;
   bool _tree = false;

  //*Methods
  @override
  initState(){
    super.initState();
    fmv = FModelView(mcallback: handleId, onChangePos: onChangeDraggPos);//#f0f
    fc = FComponent(callback: handleId, onChangePos: onChangeDraggPos);//#f0f
    sztrgen = FSerializeTreeGen(addSerObjectmap);//#ff5
    compszgen = FCompSerializeGen(addSerObjectmap);//#ff5
  }

  onChangeDraggPos(DraggableDetails details, FModelView dfmv){//!Position terminal error message resolved.
  //!OBS! Check Serialize and Component beacuse we changed FModelView constructor there as well
    setState(() {
      dfmv.fmc.positionX.value = details.offset.dx;// - const Offset(0.0, 56.0);
      dfmv.fmc.positionY.value = details.offset.dy - Offset(0.0, 56.0).dy;
      Offset of = Offset(dfmv.fmc.positionX.value, dfmv.fmc.positionY.value);
      dfmv.fmc.setPosition(of);
    });
    
  }

  handleId(int pid){
    setState(() {
      _mid = pid;
      fmv = FObjRepo.getCurObj(_mid, FObjRepo.objmap);//#f75
      
      if(fmv.isMultiWidget()){
        fmv.fmc.caddchildCol.value = true;//!Set color to object if column/Row is selected
      }
      fmv.markSelObj(fmv, FObjRepo.objmap);//!Revisite
      //_tree = false;//?Think its ok here. Go from codepanelview to startpanelview when click on obj  #ffbb
    });
  }

  addToStack(FModelView f){
    if(FObjRepo.stackobj.isEmpty) FObjRepo.stackobj.add(f);//#f75

    if(!FObjRepo.stackobj.contains(f) && f.catId != 0){
      FObjRepo.stackobj.add(f);//#f75
    }
  }

  addToObjmap(FModelView fv){
    if(FObjRepo.objmap.isEmpty) FObjRepo.objmap[_mid] = fv;

    if(!FObjRepo.objmap.containsValue(fv) && fv.catId != 0){
      FObjRepo.objmap[_mid] = fv;
    }
  }

//&All add...Object func = render the object to the screen
  addObject(int catId){
    setState(() {
      fmv = FModelView(mcallback: handleId, onChangePos: onChangeDraggPos,);//#f0f
      //print('in addobject');
      
      fmv.setCatId = catId;
      _mid = fmv.getMoid;//#Identifies the object

      //stackobj.add(fmv);
      addToStack(fmv);//?TEMP Seems to work. Prevents duplicate in the stackobj + FDummy obj (0)
      //objmap[_mid] = fmv;
      addToObjmap(fmv);//?TEMP Seems to work. Prevents duplicate in the objmap + FDummy obj (0). 
      //?For now addToObjmap is only needed in here(addObject) to prevent duplicate fv FDummy(0)

      if(fmv.isMultiWidget()){
        fmv.fmc.caddchildCol.value = true;//!Set color to object if column/Row is added
      }
      fmv.markSelObj(fmv, FObjRepo.objmap);
       fmv.fmc.setfmcObjmap = FObjRepo.objmap;//#734
    });
  }

  addChildObject(int catId){
    setState(() {
      FModelView theParentFmv = FObjRepo.getCurObj(_mid, FObjRepo.objmap);//#f75

      fmv = FModelView(mcallback: handleId, onChangePos: onChangeDraggPos,);//#f0f
      fmv.setCatId = catId;
      
      _mid = fmv.getMoid;//#Identifies the object
      FObjRepo.objmap[_mid] = fmv;

      //! 1109 *****************************************************************
      fmv.parentId = theParentFmv.getMoid;
      //! (child)fmv.isCacheChild = true; ????
      //! 1109 *****************************************************************

      theParentFmv.fmc.addChild(fmv);//! Add fobject to parent(fmv)children list
      fmv.isMultiWidget() ? fmv.fmc.caddchildCol.value = true : fmv.fmc.caddchildCol.value = false;
      
    fmv.markSelObj(fmv, FObjRepo.objmap);
    fmv.fmc.setfmcObjmap = FObjRepo.objmap;//#734
    });
  }

  void _removeObj(){//!Deprecte! Erase!
    setState(() {

      FObjRepo.removeObj(fmv);

      /*if(fmv.parentId > 0){
        fmv = getCurObj(fmv.getMoid, FObjRepo.objmap);
        FModelView parent = getCurObj(fmv.parentId, FObjRepo.objmap);
        int pos = FObjRepo.stackobj.indexOf(parent);//#f75
        if(pos > -1){//!is the parent in stackobj?
          for(var child in FObjRepo.stackobj[pos].childlist()){//#f75
            if(child.getMoid == fmv.getMoid){
              FObjRepo.objmap.remove(child.getMoid);
              FObjRepo.stackobj[pos].childlist().remove(child);//#f75
              parent.fmc.removeChild(child);
            }
          }
        }else{
          FModelView parent_in_objmap = getCurObj(parent.getMoid, FObjRepo.objmap);
          for(var child in parent_in_objmap.childlist()){
            if(child.getMoid == fmv.getMoid){
              FObjRepo.objmap.remove(child.getMoid);
              parent_in_objmap.fmc.removeChild(child);
            }
          }
        }
      }else{
        FObjRepo.stackobj.removeAt(FObjRepo.stackobj.indexOf(fmv));//#f75
      }
    unselect(FObjRepo.objmap);*/
    });
  }

  //#ff5
  addSerObjectmap(FModelView fv){
    if(FObjRepo.objmap.isEmpty) FObjRepo.objmap[fv.getMoid] = fv;

    if(!FObjRepo.objmap.containsValue(fv) && fv.catId != 0){
      FObjRepo.objmap[fv.getMoid] = fv;
    }
  }
  //#ff5

  //! with addSerObject and addSerChildObject there is no instanciazion
  addSerObject(FModelView szFmv){//!Received from serializer // 
    setState(() {

        _mid = szFmv.getMoid;//#Identifies the object

        //stackobj.add(szFmv);//!?TEMP
        addToStack(szFmv);
        //objmap[_mid] = szFmv;
        addToObjmap(szFmv);//!add type 4 and type 1

      if(szFmv.type == 1){//#ff5
        for(var child in szFmv.childlist()){
          ////print('thechildt' + child.getMoid.toString());
          addSerObjectmap(child);//!add type 2 and type 3 (d.v.s. the children)
        }
      }

        if(szFmv.isMultiWidget()){//!ADDCHILD
          szFmv.fmc.caddchildCol.value = true;//!Set color to object if column/Row is added
        }
        //szFmv.markSelObj(szFmv, objmap);//!TEST it

    });
  }

List<FModelView> prontlist = [];
List<FModelView> prontcomplist = [];
getcache() async {
  gogo++;//! To reviset
  Serializer sz = Serializer(callback: handleId, onChangePos: onChangeDraggPos);//#f0f
  await sz.readData().then((value) {//!serializer reads in all objects
    
    setState(() {
     prontlist = sztrgen.serializeTree(value, 0);
     for(var obj in prontlist) {
       addSerObject(obj);
     }
     //szvall.addAll(value);//!old
    });

  });
}

//#ff5
getcacheComp() async {
  gogo++;//! To reviset
  FComponent fcomp = FComponent(callback: handleId, onChangePos: onChangeDraggPos);//#f0f
  await fcomp.readComponentData().then((value) {//!serializer reads in all objects
    
    setState(() {
     prontcomplist = compszgen.serializeComponentTree(value, 0);
     for(var obj in prontcomplist) {
       addSerObject(obj);//! Use this?
     }
     //szvall.addAll(value);//!old
    });

  });
}
//#ff5


//!TreeViewLevels//#123//#123//#123//#123/#123//#123//#123//#123//#123//#123
 Widget _showTree(List<FModelView> alist, int lev){
    List<FModelView> coalist = [];
        
     for(int i=0; i<alist.length; i++){
       if(!alist[i].haveChildren()){
         ////print('OBJECTO ' + alist[i].getMoid.toString());//!Tabort
         if(alist[i].catId != 0){//!Dummy in FObject with catid 0. Its a dummy for when one unselect object 
           alist[i].type = 4;
           
           fmvList.add(alist[i]);
         }
       }
     }
     for (var element in alist) {
       if(element.haveChildren()){
         coalist.add(element);
       }
     }
   
     coalist.forEach((element) {
     if(element.haveChildren()){
       //element.isparent = true;
       //print(element.getMoid.toString() + ':(Expansion)' + element.level.toString());//!Tabort
       element.type = 1;
       fmvList.add(element);
       _runIt(element.childlist(), /*element.level*/0);
     }
   });

    //!Fill list with the new value. Copy them to a new templist and send. 
    //!Clear out the list, so it not updates with the old values
    if(eltemp.isNotEmpty){
      eltemp.removeRange(0, eltemp.length);
    }
    for(var items in fmvList){
      eltemp.add(items);
    }
    fmvList.removeRange(0, fmvList.length);
    return FTreeView(eltemp);
  }
 _runIt(List<FModelView> cl, int curlev){

    cl.forEach((element) {
      if(element.haveChildren()){
        int plev = curlev + 1;
        String space = getPrintOut(plev);//!Tabort
        //print(space + element.getMoid.toString() + ':(Expansion_inside)' + plev.toString());//!Tabort
        element.type = 3;
        fmvList.add(element);
        _runIt(element.childlist(), plev);
      }else{//!The same?
        int chlev = curlev + 1;
        String space = getPrintOut(chlev);//!Tabort
        if(/*element.fmc.objectModel.value.isMultiWidget*/element.isMultiWidget()){//!Even if element has no children? Check it!
          //print(space + element.getMoid.toString() + ':(Expansion_inside)' + chlev.toString());//!Tabort
          element.type = 3;
          fmvList.add(element);
        }else{
          //print(space + element.getMoid.toString() + ':(Tile)' + chlev.toString());//!Tabort
          element.type = 2;
          fmvList.add(element);
        }
      }
    });
  }

//!END TreeViewLevels//#123//#123//#123//#123/#123//#123//#123//#123//#123//#123

String getPrintOut(int t){//!TABORT
  switch (t) {
    case 1:
      return ' |--';
    case 2:
    return '   |--';
    case 3:
    return '     |--';
      break;
    default:
    return '';
  }
}//!TABORT

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
    //_tree = false;
  }

  _viewTree(){
    setState(() {
      _tree = !_tree;//#ffbb
    });
  }

  _copySW(FModelView f1){//#848 Still testing! Seems to work.
    FModelView newf = FModelView(mcallback: handleId, onChangePos: onChangeDraggPos);
    int id = newf.getMoid;

    newf.catId = f1.catId;
    newf.fmc.colModel.value.btncol = f1.fmc.colModel.value.btncol;
    newf.setMoid = id;
    addSerObject(newf);

  }//#848


  @override
  Widget build(BuildContext context) {//#region [ rgba(180, 120, 120, 0.2) ]//#endregion
  //print('in build');

//!1109
//if(gogo<1) getcache();
//if(gogo<1) getcacheComp();
//sz.writeToAPI(objmap);
//!1109

    return
    GestureDetector(onTap: () {
      addObject(0);//? Caused problem when click on empty stack. Resolved when changing FDummy to a copy of FBuObject! See FDummy2
      unselect(FObjRepo.objmap);
    },

      child: Scaffold( key: scaffoldKey, floatingActionButton: FloatingActionButton(onPressed: _removeObj, child: Text('Del') ), appBar: 
          AppBar( backgroundColor: 
            Colors.lightBlue, leading: 
            FloatingActionButton(onPressed: () => _viewTree(), child: Text('Tree')),
          ),
      body:
          SafeArea(child:
              Stack(children: [
                Container(color: Colors.grey.shade400, width: 240,),
                        if(FObjRepo.stackobj.isNotEmpty)
                        for(int i=0; i<FObjRepo.stackobj.length; i++)//#f75
                          Positioned(left: FObjRepo.stackobj[i].fmc.positionX.value, top: FObjRepo.stackobj[i].fmc.positionY.value, child: FObjRepo.stackobj[i],),//#f75
                       


                    //!UDEV PUT IN SEP WIDGET?
                    //#10123
                    if(_tree)//!TODO Revisit
                    //_showTree(FObjRepo.stackobj, 0),
                    cgen.codeTree(FObjRepo.stackobj, 0),
                    Visibility(visible: !_tree, child:
                      StartObjectPanel(fmodelview: fmv, addobject: selFunc),
                    ),

                    //#10123
                    //!PUT IN SEP WIDGET

                     Align(alignment: Alignment(1, 0), child: 
                       Column( mainAxisSize: MainAxisSize.max, children: 
                            [
                              fmv.makeSidePanel(),
                              GFButton(onPressed: () => _copySW(fmv)/*_showTree(stackobj, 0)*/),//!TREETEST
                            ],
                       ),
                     ),
                     
                     /*Align(alignment: Alignment(0,0), child: //#599 TODO TODO TODO TODO
                        done ? createComp() : const CircularProgressIndicator(),
                     ),*/
                 ],),
            ),
          drawer: Container(width: 150, child: Drawer(child: Text('im a drawer'),)),
      ),
    );
  }
}