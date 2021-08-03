//import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp/fmodelview.dart';
import 'package:flutterapp/fstartobjectpanel.dart';
import 'package:flutterapp/ftreeviewpanel.dart';
import 'package:get/get.dart';
import 'package:getwidget/components/button/gf_button.dart';
//import '../../utils.dart';
import 'package:flutterapp/utils.dart'; 


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
   //bool addchild = true;//!ADDCHILD
  //*Members
   late FModelView fmv;
   int _mid = 0;
   bool _tree = false;

  Map objmap = <int, FModelView>{};
  final scaffoldKey = GlobalKey<ScaffoldState>();
  //!was Widget before
  List<FModelView> stackobj = [];

  //*Methods
  
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
      
      if(fmv.isMultiWidget()){//!ADDCHILD
        fmv.fmc.caddchildCol.value = true;
        //addchild = false;
      }
      fmv.markSelObj(fmv, objmap);//!Revisite
  });
}

  addObject(int catId){
    setState(() {
      fmv = FModelView(mcallback: handleId,);
      fmv.setCatId = catId;
      _mid = fmv.getMoid;//#Identifies the object
      stackobj.add(fmv);
      objmap[_mid] = fmv;

      if(fmv.isMultiWidget()){//!ADDCHILD
        fmv.fmc.caddchildCol.value = true;
      }
      fmv.markSelObj(fmv, objmap);
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

      colrowFmv.fmc.addChild(fmv);//!?????
      fmv.fmc.caddchildCol.value = false;//!ADDCHILD
      //addchild = false;
    fmv.markSelObj(fmv, objmap);
    });
  }

  //! ADDCHILDTOLIST

  _removeObj(){
    setState(() {
      stackobj.removeAt(stackobj.indexOf(fmv));
    });
  }

List<FModelView> eltemp = [];
List<FModelView> fmvList = [];
//!TreeViewLevels
 Widget _showTree(List<FModelView> alist, int lev){
    List<FModelView> coalist = [];
        
          for(int i=0; i<alist.length; i++){
            if(!alist[i].haveChildren()){
              print(alist[i].getMoid.toString());//!Tabort
              if(alist[i].catId != 0){//!Dummy in FObject with catid 0. Its a dummy for when one select object 
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
            element.isparent = true;
            print(element.getMoid.toString() + ':(Expansion)' + element.level.toString());//!Tabort
            element.type = 1;
            fmvList.add(element);
            _runIt(element.childlist(), element.level);
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
//!TreeViewLevels

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
  }

  _viewTree(){
    setState(() {
      _tree = !_tree;
    });
  }
  //*Methods

  @override
  Widget build(BuildContext context) {//#region [ rgba(180, 120, 120, 0.2) ]//#endregion
  print('in build');
  

    return 
    //GestureDetector(onTap: () => unselect(objmap),//?CLICKVOID TODO
    GestureDetector(onTap: () {
      unselect(objmap);
      addObject(0);
    },

      child: Scaffold( key: scaffoldKey, floatingActionButton: FloatingActionButton(onPressed: _removeObj,), appBar: 
          AppBar( backgroundColor: 
            Colors.lightBlue, leading: 
            FloatingActionButton(onPressed: () => _viewTree()),
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


