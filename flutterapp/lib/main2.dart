import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp/constants.dart';
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

import 'fserialtreegen.dart';

//!NOTES
//! 1109 = Serializer
//! 599  = Component
//! 734  = onEnter
//! 778  = Painter 

void main () => runApp(RunApp());

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

  int gogo = 0;
  int gotest = 0;
  Map objmap = <int, FModelView>{};
  //final scaffoldKey = GlobalKey<ScaffoldState>();
  List<FModelView> stackobj = [];

  List<FModelView> vall = [];//#599
  List<FModelView> szvall = [];//!1109

   int _mid = 0;
   bool _tree = false;

  //*Methods
  @override
  initState(){
    super.initState();
    fmv = FModelView(mcallback: handleId);
    fc = FComponent(callback: handleId,);
    sztrgen = FSerializeTreeGen();
  }

  handleId(int pid){
    setState(() {
      
      _mid = pid;
      fmv = getCurObj(_mid, objmap);
      
      if(fmv.isMultiWidget()){
        fmv.fmc.caddchildCol.value = true;//!Set color to object if column/Row is selected
      }
      fmv.markSelObj(fmv, objmap);//!Revisite
      //_tree = false;//#ffbb //?Think its ok here. Go from codepanelview to startpanelview when click on obj  #ffbb
    });
  }

  //#599//#599//#599//#599//#599//#599//#599//#599//#599//#599
  handleComp(FModelView fobj){

    setState(() {
        //!TEST
        if(stackobj.contains(fobj)) {
          //addObject(fobj.catId);
          addCloneObject(fobj);
          //return topComp from addObject
          /*
          for(var child in fobj.childlist()){
            child.parentId = topComp.getMoid;
            addCloneChildObject(child);
          }
          }*/
          return;
        }//!TEST

      if(fobj.type == 4 || fobj.type == 1){
        addSerCompObject(fobj);
      }
    });
  }
//#599
  addSerCompObject(FModelView cFmv){
    setState(() {
        _mid = cFmv.getMoid;//#Identifies the object

        //stackobj.add(cFmv);//!?TEMP
        addToStack(cFmv);
        
        if(cFmv.isMultiWidget()){
          cFmv.fmc.caddchildCol.value = true;//!Set color to object if column/Row is added
        }
        cFmv.markSelObj(cFmv, objmap);
    });
  }

//#599
/*
addCloneChildObject(FModelView cfchild){
    setState(() {
      
      FModelView child = FModelView(mcallback: handleId,);
      child.setCatId = cfchild.catId;//!TODO make cloner class/function! Props depends on category!
      
      _mid = child.getMoid;//#Identifies the object
      objmap[_mid] = child;

      FModelView topComp = getCurObj(child.parentId, objmap);
      topComp.fmc.addChild(child);//! Add fobject to parent(fmv)children list! 
      child.isMultiWidget() ? child.fmc.caddchildCol.value = true : child.fmc.caddchildCol.value = false;
      
    //child.markSelObj(fmv, objmap);
    });
  }
*/
//#599
addCloneObject(FModelView fobj){//!Works only for the top compopnent 
//!you could copy the childlist from fobj but the childs are not separeted. Need todo for the childs to be separeted. 
    setState(() {
      FModelView fmv = FModelView(mcallback: handleId,);
      
      fmv.setCatId = fobj.catId;//!TODO make cloner class/function! Props depends on category!
      fmv.fmc.objectModel.value.spacing = fobj.fmc.objectModel.value.spacing;

      _mid = fmv.getMoid;//#Identifies the object
      addToStack(fmv);
      addToObjmap(fmv);

      if(fmv.isMultiWidget()){
        fmv.fmc.caddchildCol.value = true;//!Set color to object if column/Row is added
      }
      fmv.markSelObj(fmv, objmap);
    });
  }

//#599
  getCcache() {//!Set at startup
    //FComponent fc = FComponent(callback: handleId,);//! its in initState now. Ok?
    gotest++;
    fc.readComponentData().then((val){
      setState(() {
        vall.addAll(val);
        done = true;
      });
    });
  }
//#599
  Widget createComp(){
    for(var obj in vall){ 
      if(obj.parentId == 0){//!get the components top object
        for(int i=0; i<vall.length; i++){//!if it has child iterate and add them to the childlist
          if(vall[i].parentId == obj.getMoid){
            obj.fmc.addChild(vall[i]);
            objmap[vall[i].getMoid] = vall[i];//!put the children in objmap
          }
        }
        comp.add(obj);
        //fc.addToCompList(comp);//!TEST//#ff2#ff2#ff2#ff2#ff2
        objmap[obj.getMoid] = obj;//! put the component itself in objmap
      }
    }

    if(vall.isNotEmpty) vall.removeRange(0, vall.length);

  return//!TODO return TextButtons for multiple components
    Column(children: [
      TextButton(onPressed: () { handleComp(comp[0]); handleId(comp[0].getMoid);}, child: Text(comp[0].name)),
    ],);
  }

//END //#599//#599//#599//#599//#599//#599//#599//#599//#599//#599

  addToStack(FModelView f){
    if(stackobj.isEmpty) stackobj.add(f);

    if(!stackobj.contains(f) && f.catId != 0){
      stackobj.add(f);
    }
  }

  addToObjmap(FModelView of){
    if(objmap.isEmpty) objmap[_mid] = of;

    if(!objmap.containsValue(of) && of.catId != 0){
      objmap[_mid] = of;
    }
  }

//&All add...Object func = render the object to the screen
  addObject(int catId){
    setState(() {
      fmv = FModelView(mcallback: handleId,);
      print('in addobject');
      
      fmv.setCatId = catId;
      _mid = fmv.getMoid;//#Identifies the object

      //stackobj.add(fmv);
      addToStack(fmv);//?TEMP Seems to work. Prevents duplicate in the stackobj + FDummy obj (0)
      //objmap[_mid] = fmv;
      addToObjmap(fmv);//?TEMP Seems to work. Prevents duplicate in the objmap + FDummy obj (0). 
      //?For now addToObjmap is only needed in here(addObject) to prevent duplicate of FDummy(0)

      if(fmv.isMultiWidget()){
        fmv.fmc.caddchildCol.value = true;//!Set color to object if column/Row is added
      }
      fmv.markSelObj(fmv, objmap);
      
    });
  }

  //!
  addChildObject(int catId){
    setState(() {
      FModelView theParentFmv = getCurObj(_mid, objmap);

      fmv = FModelView(mcallback: handleId,);
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

  //! with addSerObject and addSerChildObject there is no instanciazion
  addSerObject(FModelView szFmv){//!Received from serializer // 
    setState(() {
      
        //szFmv.setCatId = 101;//TODO set this in serializer
        print('*addinserobject-btn*' + szFmv.getMoid.toString());
        _mid = szFmv.getMoid;//#Identifies the object

        //stackobj.add(szFmv);//!?TEMP
        addToStack(szFmv);

        objmap[_mid] = szFmv;

        if(szFmv.isMultiWidget()){//!ADDCHILD
          szFmv.fmc.caddchildCol.value = true;//!Set color to object if column/Row is added
        }
        szFmv.markSelObj(szFmv, objmap);

    });
  }
  addSerChildObject(FModelView child){

    setState(() {

      _mid = child.getMoid;//#Identifies the object
      objmap[_mid] = child;

      FModelView parent = getCurObj(child.parentId, objmap);// get the parent
      parent.fmc.addChild(child);//!Look into this, maybe if we put it in addSerObject we dont need this func??
      child.fmc.caddchildCol.value = false;//!Set color to false if column/Row is added

    child.markSelObj(child, objmap);//! Do we need this??
    });
  }

getcache() async {
  gogo++;//! To revisted
  Serializer sz = Serializer(callback: handleId);
  await sz.readData().then((value) {//!serializer reads in all objects
    
    setState(() {
     szvall.addAll(value);
    });

  });
}


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

  @override
  Widget build(BuildContext context) {//#region [ rgba(180, 120, 120, 0.2) ]//#endregion
  print('in build');


  //#599
//if(gotest<1) getCcache();

//!1109
//if(gogo<1) getcache();
//sz.writeToAPI(objmap);
//!1109

    return 
    //GestureDetector(onTap: () => unselect(objmap),
    GestureDetector(onTap: () {
      unselect(objmap);
      addObject(0);
    },

      child: MaterialApp(home:
        Scaffold( /*key: scaffoldKey,*/ floatingActionButton: FloatingActionButton(onPressed: _removeObj, child: Text('Del') ), appBar: 
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
                            stackobj[i],
                          

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
                                GFButton(onPressed: () => _showTree(stackobj, 0)),//!TREETEST
                                sztrgen.serializeTree(szvall, 0),//!1109
                              ],
                         ),
                       ),
                       
                       /*Align(alignment: Alignment(0,0), child:
                          done ? createComp() : const CircularProgressIndicator(),
                       ),*/
                   ],),
              ),
            drawer: Container(width: 150, child: Drawer(child: Text('im a drawer'),)),
        ),
        initialRoute: '/',
        routes: {'/test' : (context) => StartObjectPanel(fmodelview: fmv, addobject: selFunc)},
      ),
    );
  }
}