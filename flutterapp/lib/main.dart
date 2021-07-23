import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp/colorpicker.dart';
import 'package:flutterapp/fmodelview.dart';
import 'package:get/get.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:logger/logger.dart';
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
  final scaffoldKey = GlobalKey<ScaffoldState>();
  
  //*Members
   late FModelView fmv;

  //!was Widget before
  List<FModelView> stackobj = [];
  Map objmap = <int, FModelView>{};
  bool marked = false;

  //*Methods
  int _mid = 0;
  handleId(int pid){
    setState(() {
      _mid = pid;
      fmv = getCurObj(_mid, objmap);
      marked = true;
  });
}

  @override
  initState(){
    super.initState();
    fmv = FModelView(mcallback: handleId);
  }

  addObject(int catId){
    setState(() {
      fmv = FModelView(mcallback: handleId,);
      fmv.setCatId = catId;
      _mid = fmv.getMoid;//#Identifies the object
      stackobj.add(fmv);
      objmap[_mid] = fmv;
    });
  }

  //! ADDCHILDTOLIST - in addObject?
    /*
  addC(int catId){
    setState(() {
      FModelView colrowFmv = getCurObj(_mid, objmap);

      fmv = FModelView(mcallback: handleId,);
      fmv.setCatId = catId;
      _mid = fmv.getMoid;//#Identifies the object
      objmap[_mid] = fmv;

      if(colrowFmv.catId == 104) TODO getCatId
        colrowFmv.addChild(fmv); TODO addChild
    });
  }
    */
  //!

  _removeObj(){
    setState(() {
      stackobj.removeAt(stackobj.indexOf(fmv));
    });
  }

  _showTree(){//!TREETEST
    if(stackobj.isNotEmpty){
        for(int i=0; i<objmap.length; i++){
          FModelView f = stackobj[i];
        }
    }
  }//!TREETEST
  //*Methods
  
  @override
  Widget build(BuildContext context) {//#region [ rgba(180, 120, 120, 0.2) ]//#endregion
  print('in build');
  
    fmv.chClickCol(fmv, _mid, objmap);//!Revisite


    return 
    Scaffold( key: scaffoldKey, floatingActionButton: FloatingActionButton(onPressed: _removeObj,), appBar: 
        AppBar( backgroundColor: 
          Colors.lightBlue, leading: 
          FloatingActionButton(onPressed: () => fmv.chClickVoid(fmv, objmap),),),//!Revisite2
    body:
        SafeArea(child:
          Stack(children: [
            Container(color: Colors.grey, width: 240,),
                    if(stackobj.isNotEmpty)
                    for(int i=0; i<stackobj.length; i++)
                        stackobj[i],    
                      
            Align(alignment: const Alignment(-1, 0), child: 
              Column(children: //!SingleChildScrollView here
              [

                //!UDEV
                //!
                Card(color: Colors.grey.shade100, child: 
                  Column(children: [
                const SizedBox(width: 230, height: 32, child: 
                        ListTile(tileColor: Colors.grey, title: 
                          Center(child: Text('Standard Widgets', style: TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.w800),)),
                        ),
                      ),
                    ]
                  )
                ),
                //!
                Card(color: Colors.grey.shade100, child: 
                  Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(width: 230, height: 45,
                        child: ListTile(title: Text('Textbutton', style: TextStyle(fontSize: 18),),
                          trailing: Icon(Icons.add, color: Colors.black, size: 30,), leading: Icon(Icons.smart_button_rounded),
                          onTap: () => addObject(101),
                        ),
                      ),
                    ]
                  )
                ),
                Card(color: Colors.grey.shade100, child: 
                  Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(width: 230, height: 45,
                        child: ListTile(title: Text('Iconbutton',style: TextStyle(fontSize: 18)),
                          trailing: Icon(Icons.add, color: Colors.black, size: 30,), leading: Icon(Icons.info),
                          onTap: () => addObject(102),
                        ),
                      ),
                    ]
                  )
                ),
                Card(color: Colors.grey.shade100, child: 
                  Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start,
                    children: 
                    [
                      SizedBox(width: 230, height: 45,
                        child: ListTile(title: Text('Textfield',style: TextStyle(fontSize: 18)),
                          trailing: Icon(Icons.add, color: Colors.black, size: 30,), leading: Icon(Icons.text_fields),
                          onTap: () => addObject(103),
                        ),
                      ),
                    ]
                  )
                ),
                //!UDEV
                //Card(color: Colors.grey.shade100, child: 
                  Container(color:  Colors.lightGreen, width: 230, height: 30, child: 
                    Row(mainAxisSize: MainAxisSize.min, children: 
                      [
                          Icon(Icons.view_column, size: 20,),
                          SizedBox(width: 50,),
                          Text('Column',style: TextStyle(fontSize: 16)),
                          SizedBox(width: 50,),
                          IconButton(icon: Icon(Icons.add), color: Colors.black, iconSize: 20,
                            onPressed: () => addObject(104),),
                      ]
                    ),
                  ),

              ]
              ),
            ),
                 Align(alignment: Alignment(1, 0), child: 
                   Column( mainAxisSize: MainAxisSize.max, children: 
                        [
                          fmv.makeSidePanel(),
                          GFButton(onPressed: _showTree),//!TREETEST
                        ],
                   ),
                 )
             ],),
        ),
    );
  }
}


