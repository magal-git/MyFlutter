import 'package:flutter/material.dart';
import 'package:getwidget/components/border/gf_border.dart';
import 'package:getwidget/getwidget.dart';
import 'fmodelcontroller.dart';

typedef void idCallback(int id);

//#region [ rgba(90, 150, 40, 0.2) ]//#endregion
class FBuObject extends StatelessWidget {
  FBuObject({required this.callback, required this.thisid,
             required this.bw, required this.bh, required this.colModel, /*this.col = Colors.green,*/
             this.marked = false, required this.hlpb, this.borderradius = 0.0,
            });

double bw, bh;
double borderradius;
final idCallback callback;
//Color col;
ColModel colModel;

HelperBtn hlpb;
bool marked = true;
final int thisid;

  @override
  Widget build(BuildContext context){
    print('in fobjects');
    
    return 
    SizedBox(width: bw, height: bh,   child: 
      Material(child: marked ? 
        Container(decoration: BoxDecoration(border: Border.all(
          color: Color.fromRGBO(50, 52, 50, 1),
          width: 2,
        ),
        ), child: TextButton(child: Text('- Edit mode -', style: TextStyle(fontStyle: FontStyle.italic, fontSize: 12, color: colModel.txtcol),),
          onPressed: () => callback(thisid),
        )
        ) :
        TextButton(child: Text(hlpb.btntext +': id ' + thisid.toString(), style: TextStyle(fontSize: 12, color: colModel.txtcol),),
          onPressed: () => callback(thisid),
        ),
        color: colModel.btncol, /*col,*/
        borderRadius: BorderRadius.circular(borderradius),
        elevation: hlpb.elevation,
      ),
    );
  }
}
//#region [ rgba(30, 30, 40, 0.2) ]//#endregion
class FIcBuObject extends StatelessWidget {
  FIcBuObject({required this.callback, required this.thisid,
              required this.bw, required this.bh, this.col = Colors.green,
              this.marked = false
            });

double bw, bh;
final idCallback callback;
Color col;
bool marked = true;//!Marked
final int thisid;

  @override
  Widget build(BuildContext context){
    return 
    SizedBox(width: bw, height: bh,   child: 
      Material(child: marked ?
        Container(decoration: BoxDecoration(border: Border.all(
          color: Color.fromRGBO(240, 252, 3, 1),
          width: 3,
        ),
        ), child: IconButton(icon: Icon(Icons.access_alarm),
          onPressed: () => callback(thisid),
        )
        ) :
        IconButton(icon: Icon(Icons.access_alarm),
          onPressed: () => callback(thisid),
        ),
      color: col,
    ),
    );
  }
}
//#region [ rgba(30, 30, 40, 0.2) ]//#endregion
class FTextFObject extends StatelessWidget {
  FTextFObject({required this.callback, required this.thisid,
              required this.bw, required this.bh, this.col = Colors.green,
              this.marked = false//!Marked
            });

double bw, bh;
final idCallback callback;
Color col;
bool marked = true;//!Marked
final int thisid;

  @override
  Widget build(BuildContext context){
    return
      SizedBox(width: bw, height: bh,   child: 
        Material(child: marked ?
          Container(decoration: BoxDecoration(border: Border.all(
            color: Color.fromRGBO(240, 252, 3, 1),
            width: 3,
          ),
          ), child: 
              TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter text'
                ),
              onTap: () => callback(thisid),
              ),
          ) :
              TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter text'
                ),
              onTap: () => callback(thisid),
              ),
        color: col,
      ),
    );
  }
}

//#region [ rgba(30, 30, 40, 0.2) ]//#endregion
class FColumnObject extends StatelessWidget {
  FColumnObject({required this.callback, required this.thisid,
              this.marked = false, required this.columnModel, 
            });


final idCallback callback;
bool marked = true;
final int thisid;
ColumnModel columnModel;
bool checked = true;

  @override
  Widget build(BuildContext context){
    return
      GestureDetector(child: marked ?
          Container(/*width: 100, height: 100,*/ decoration: BoxDecoration(border: Border.all(color: const Color.fromRGBO(240, 252, 3, 1), width: 3,),), child: 
              Column(mainAxisSize: MainAxisSize.max, children: 
                  [
                    Checkbox(value: checked, onChanged: (value) => print(!checked)),//!TODO
                    Text(thisid.toString()),
                    for(int i=0; i<columnModel.childlist.length; i++)
                      columnModel.childlist[i], 
                  ],
              ),
          ) :
              Column(children: 
                  [
                    Text('column: id $thisid'),
                    for(int i=0; i<columnModel.childlist.length; i++)
                      columnModel.childlist[i],
                  ],
              ),
        onTap: () => callback(thisid),
      );
  }
}
//#region [ rgba(30, 30, 40, 0.2) ]//#endregion
class FRowObject extends StatelessWidget {
  FRowObject({required this.callback, required this.thisid,
              this.marked = false, required this.columnModel, 
            });


final idCallback callback;
bool marked = true;
final int thisid;
ColumnModel columnModel;
bool checked = true;

  @override
  Widget build(BuildContext context){
    return
      GestureDetector(child: marked ?
          Container(width: 100, height: 100, decoration: BoxDecoration(border: Border.all(color: const Color.fromRGBO(240, 252, 3, 1), width: 3,),), child: 
              Row(mainAxisSize: MainAxisSize.max, children: 
                  [
                    Checkbox(value: checked, onChanged: (value) => print(!checked)),//!TODO
                    Text(thisid.toString()),
                    for(int i=0; i<columnModel.childlist.length; i++)
                      columnModel.childlist[i], 
                  ],
              ),
          ) :
              Row(children: 
                  [
                    Text('row: id $thisid'),
                    for(int i=0; i<columnModel.childlist.length; i++)
                      columnModel.childlist[i],
                  ],
              ),
        onTap: () => callback(thisid),
      );
  }
}
