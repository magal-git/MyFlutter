import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutterapp/constants.dart';
import 'package:flutterapp/fmodelview.dart';
import 'package:get/get.dart';

typedef void midCallbac(int id);

class StartObjectPanel extends StatelessWidget{
      StartObjectPanel({required this.fmodelview, required this.addobject});

final midCallbac addobject;
FModelView fmodelview;


  @override
  Widget build(BuildContext context){

    return
    Align(alignment: const Alignment(-1, 0), child: 
      Column(children: //!SingleChildScrollView here
        [
              Card(color: Colors.grey.shade100, child: 
                Column(children: [
              const SizedBox(width: 230, height: 32, child: 
                      ListTile(tileColor: Colors.grey, title: 
                        Center(child: Padding(padding: EdgeInsets.fromLTRB(0, 0, 0, 14), child: Text('Standard Widgets', 
                        style: TextStyle(fontSize: 12, color: Colors.black, fontWeight: FontWeight.w800),)),
                      )),
                    ),
                  ]
                )
              ),
              //!
              //Obx(() => Text(fmodelview.fmc.caddchild.toString())),
Obx((){return
              Card(color: fmodelview.fmc.caddchildCol.value ? Colors.amber : Colors.grey.shade100, child: //!ADDCHILD
                Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(width: 230, height: 45,
                      child: ListTile(title: Text('Textbutton', style: TextStyle(fontSize: 18),),
                        trailing: Icon(Icons.add, color: Colors.black, size: 30,), leading: Icon(Icons.smart_button_rounded),
                        onTap: () => addobject(fBUTTON),//!ADDCHILD
                      ),
                    ),
                  ]
                )
              );
}),
              Card(color: Colors.grey.shade100, child: 
                Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(width: 230, height: 45,
                      child: ListTile(title: Text('Iconbutton',style: TextStyle(fontSize: 18)),
                        trailing: Icon(Icons.add, color: Colors.black, size: 30,), leading: Icon(Icons.info),
                        onTap: () => addobject(fICBUTTON),
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
                        onTap: () => addobject(fTEXTFIELD),
                      ),
                    ),
                  ]
                )
              ),
              //!UDEV
              //Card(color: Colors.grey.shade100, child:
              //!COLUMN
                Container(color:  Colors.lightGreen, width: 230, height: 30, child: 
                  Row(mainAxisSize: MainAxisSize.min, children: 
                    [
                        Icon(Icons.view_column, size: 20,),
                        SizedBox(width: 50,),
                        Text('Column',style: TextStyle(fontSize: 16)),
                        SizedBox(width: 50,),
                        IconButton(icon: Icon(Icons.add), color: Colors.black, iconSize: 20,
                          onPressed: () => addobject(fCOLUMN),),
                    ]
                  ),
                ),
                //!ROW
                Container(color:  Colors.lightGreen, width: 230, height: 30, child: 
                  Row(mainAxisSize: MainAxisSize.min, children: 
                    [
                        Icon(Icons.view_column, size: 20,),
                        SizedBox(width: 50,),
                        Text('Row',style: TextStyle(fontSize: 16)),
                        SizedBox(width: 50,),
                        IconButton(icon: Icon(Icons.add), color: Colors.black, iconSize: 20,
                          onPressed: () => addobject(fROW),),
                    ]
                  ),
                ),
         ]
      ),
    );
  }
}