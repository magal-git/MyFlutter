import 'package:flutter/material.dart';
import 'package:flutterapp/fcodegen.dart';
import 'package:flutterapp/fcomponent.dart';
import 'package:flutterapp/fmodelview.dart';
import 'package:flutterapp/fobjects.dart';
import 'package:flutterapp/fstartobjectpanel.dart';
import 'package:flutterapp/ftreeviewpanel.dart';
import 'package:flutterapp/serializer.dart';
import 'package:get/get.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:flutterapp/utils.dart';

import '../../fserialtreegen.dart';
import 'fcompserializergen.dart';

//!NOTES
//! 1109 = Serializer
//! 599  = Component
//! 734  = onEnter
//! 778  = Painter 

void main () => runApp(GetMaterialApp(home: RunApp()));

//#region [Main]
class RunApp extends StatelessWidget { @override Widget build(BuildContext context){ return HomePageWidget();}}
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
  Map objmap = <int, FModelView>{};
  final scaffoldKey = GlobalKey<ScaffoldState>();
  List<FModelView> stackobj = [];

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
  //!OBS! Check Serialize and Component beacuse we changed FModelView constructor there aswell
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
      fmv = getCurObj(_mid, objmap);
      
      if(fmv.isMultiWidget()){
        fmv.fmc.caddchildCol.value = true;//!Set color to object if column/Row is selected
      }
      fmv.markSelObj(fmv, objmap);//!Revisite
      //_tree = false;//?Think its ok here. Go from codepanelview to startpanelview when click on obj  #ffbb
    });
  }

  addToStack(FModelView f){
    if(stackobj.isEmpty) stackobj.add(f);

    if(!stackobj.contains(f) && f.catId != 0){
      stackobj.add(f);
    }
  }

  addToObjmap(FModelView fv){
    if(objmap.isEmpty) objmap[_mid] = fv;

    if(!objmap.containsValue(fv) && fv.catId != 0){
      objmap[_mid] = fv;
    }
  }

//&All add...Object func = render the object to the screen
  addObject(int catId){
    setState(() {
      fmv = FModelView(mcallback: handleId, onChangePos: onChangeDraggPos,);//#f0f
      print('in addobject');
      
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
      fmv.markSelObj(fmv, objmap);
      
    });
  }

  addChildObject(int catId){
    setState(() {
      FModelView theParentFmv = getCurObj(_mid, objmap);

      fmv = FModelView(mcallback: handleId, onChangePos: onChangeDraggPos,);//#f0f
      fmv.setCatId = catId;
      
      _mid = fmv.getMoid;//#Identifies the object
      objmap[_mid] = fmv;

      //! 1109 *****************************************************************
      fmv.parentId = theParentFmv.getMoid;
      //! (child)fmv.isCacheChild = true; ????
      //! 1109 *****************************************************************

      theParentFmv.fmc.addChild(fmv);//! Add fobject to parent(fmv)children list
      fmv.isMultiWidget() ? fmv.fmc.caddchildCol.value = true : fmv.fmc.caddchildCol.value = false;
      
    fmv.markSelObj(fmv, objmap);
    fmv.fmc.setfmcObjmap = objmap;//#734
    });
  }

  void _removeObj(){
    setState(() {

      if(fmv.parentId > 0){
        fmv = getCurObj(fmv.getMoid, objmap);
        FModelView parent = getCurObj(fmv.parentId, objmap);
        int pos = stackobj.indexOf(parent);
        if(pos > -1){//!is the parent in stackobj?
          for(var child in stackobj[pos].childlist()){
            if(child.getMoid == fmv.getMoid){
              objmap.remove(child.getMoid);
              stackobj[pos].childlist().remove(child);
              parent.fmc.removeChild(child);
            }
          }
        }else{
          FModelView parent_in_objmap = getCurObj(parent.getMoid, objmap);
          for(var child in parent_in_objmap.childlist()){
            if(child.getMoid == fmv.getMoid){
              objmap.remove(child.getMoid);
              parent_in_objmap.fmc.removeChild(child);
            }
          }
        }
      }else{
        stackobj.removeAt(stackobj.indexOf(fmv));
      }
    unselect(objmap);
    });
  }

  //#ff5
  addSerObjectmap(FModelView fv){
    if(objmap.isEmpty) objmap[fv.getMoid] = fv;

    if(!objmap.containsValue(fv) && fv.catId != 0){
      objmap[fv.getMoid] = fv;
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
          //print('thechildt' + child.getMoid.toString());
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
         //print('OBJECTO ' + alist[i].getMoid.toString());//!Tabort
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
       print(element.getMoid.toString() + ':(Expansion)' + element.level.toString());//!Tabort
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
        print(space + element.getMoid.toString() + ':(Expansion_inside)' + plev.toString());//!Tabort
        element.type = 3;
        fmvList.add(element);
        _runIt(element.childlist(), plev);
      }else{//!The same?
        int chlev = curlev + 1;
        String space = getPrintOut(chlev);//!Tabort
        if(/*element.fmc.objectModel.value.isMultiWidget*/element.isMultiWidget()){//!Even if element has no children? Check it!
          print(space + element.getMoid.toString() + ':(Expansion_inside)' + chlev.toString());//!Tabort
          element.type = 3;
          fmvList.add(element);
        }else{
          print(space + element.getMoid.toString() + ':(Tile)' + chlev.toString());//!Tabort
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

  shuff(){//#734
    setState(() {
      /*stackobj.shuffle();
      for(var c in fmv.childlist()){
        print(c.getMoid);
      }*/
      
      fmv.childlist().insert(0, fmv.childlist().removeAt(1));
      //fmv.childlist().insert(0, fmv.childlist().indexWhere((element) => false);
      //unselect(objmap);
      fmv.markSelObj(fmv, objmap);
    });//#734
  
  }

  @override
  Widget build(BuildContext context) {//#region [ rgba(180, 120, 120, 0.2) ]//#endregion
  print('in build');

//!1109
//if(gogo<1) getcache();
//if(gogo<1) getcacheComp();
//sz.writeToAPI(objmap);
//!1109

    return
    GestureDetector(onTap: () {
      unselect(objmap);
      addObject(0);
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
                        if(stackobj.isNotEmpty)
                        for(int i=0; i<stackobj.length; i++)
                          Positioned(left: stackobj[i].fmc.positionX.value, top: stackobj[i].fmc.positionY.value, child: stackobj[i],),
                       

                    //!UDEV PUT IN SEP WIDGET?
                    //#10123
                    if(_tree)//!TODO Revisit
                    _showTree(stackobj, 0),
                    //cgen.codeTree(stackobj, 0),
                    Visibility(visible: !_tree, child:
                      StartObjectPanel(fmodelview: fmv, addobject: selFunc),
                    ),

                    //#10123
                    //!PUT IN SEP WIDGET

                     Align(alignment: Alignment(1, 0), child: 
                       Column( mainAxisSize: MainAxisSize.max, children: 
                            [
                              fmv.makeSidePanel(),
                              GFButton(onPressed: /*_showTree(stackobj, 0))*/shuff),//!TREETEST
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