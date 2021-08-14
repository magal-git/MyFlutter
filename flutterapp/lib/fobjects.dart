import 'package:flutter/material.dart';
import 'package:flutterapp/constants.dart';
import 'package:flutterapp/fcodetextformater.dart';
import 'package:flutterapp/fmodelview.dart';
import 'package:get/get.dart';
import 'fmodelcontroller.dart';

typedef void idCallback(int id);

class FDummy extends StatelessWidget implements FDummytest{
    FDummy({required this.callback});
    final idCallback callback;
    Widget codeit(FModelView fmv){return SizedBox.shrink();}
    @override
  Widget build(BuildContext context){
    return SizedBox.shrink();
    }
}

abstract class FDummytest extends StatelessWidget{
    FDummytest(/*{required this.callback}*/);
    //final idCallback callback;
    Widget codeit(FModelView fmv);

  @override
  Widget build(BuildContext context){
    return SizedBox.shrink();
    }
}

//#region [ rgba(90, 150, 40, 0.2) ]//#endregion
class FBuObject extends StatelessWidget implements FDummytest {
  FBuObject({required this.callback, required this.thisid,
             required this.bw, required this.bh, required this.colModel, /*this.col = Colors.green,*/
             this.marked = false, required this.hlpb, this.borderradius = 0.0, required this.objectModel,
            });
            

double bw, bh;
double borderradius;
final idCallback callback;
//Color col;
ColModel colModel;
ObjectModel objectModel;

HelperBtn hlpb;
bool marked = true;
final int thisid;

@override
Widget codeit(FModelView fmv){//!1200

  return FCodeTextFormater(fmv: fmv, objcp: ObjectCodeProps.fbutton(btnText: hlpb.btntext, btnTextColor: colModel.txtcol, borderradius: borderradius),);
}


  @override
  Widget build(BuildContext context){
    print('in fobjects');
    objectModel.catName = 'Button';
    
    return 
    SizedBox(width: bw, height: bh,   child: 
      Material(child: marked ? 
        Container(decoration: BoxDecoration(border: Border.all(
          color: const Color.fromRGBO(50, 52, 50, 1),
          width: 2,
        ),
        ), child: TextButton(child: Text(hlpb.btntext +': id ' + thisid.toString(), style: TextStyle(fontSize: 12, color: colModel.txtcol),),
          onPressed: () => callback(thisid),
        )
        ) :
        TextButton(child: Text(hlpb.btntext, style: TextStyle(fontSize: 12, color: colModel.txtcol),),
          onPressed: () => callback(thisid),
        ), /*codeit(),*/
        color: colModel.btncol, /*col,*/
        borderRadius: BorderRadius.circular(borderradius),
        elevation: hlpb.elevation,
      ),
    );
  }
}
//#region [ rgba(30, 30, 40, 0.2) ]//#endregion
class FIcBuObject extends StatelessWidget implements FDummytest {
  FIcBuObject({required this.callback, required this.thisid,
              required this.bw, required this.bh, this.col = Colors.green,
              this.marked = false, required this.objectModel
            });

double bw, bh;
final idCallback callback;
Color col;
bool marked = true;//!Marked
final int thisid;
ObjectModel objectModel;

@override
Widget codeit(FModelView fmv){
  return Text('This is a iconbutton code \n ]');
}

  @override
  Widget build(BuildContext context){
    objectModel.catName = 'IconButton';

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
class FTextFObject extends StatelessWidget implements FDummytest {
  FTextFObject({required this.callback, required this.thisid,
              required this.bw, required this.bh, this.col = Colors.green,
              this.marked = false, required this.objectModel
            });

double bw, bh;
final idCallback callback;
Color col;
bool marked = true;//!Marked
final int thisid;
ObjectModel objectModel;

Widget codeit(FModelView fmv){return SizedBox.shrink();}

  @override
  Widget build(BuildContext context){
    objectModel.catName = 'Textfield';

    return
      SizedBox(width: bw, height: bh,   child: 
        Material(child: marked ?
          Container(decoration: BoxDecoration(border: Border.all(
            color: Color.fromRGBO(240, 252, 3, 1),
            width: 3,
          ),
          ), child: 
              TextField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter text'
                ),
              onTap: () => callback(thisid),
              ),
          ) :
              TextField(
                decoration: const InputDecoration(
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
class FColumnObject extends StatelessWidget implements FDummytest {
  FColumnObject({required this.callback, required this.thisid,
              this.marked = false, required this.objectModel,
            });


final idCallback callback;
bool marked = true;
final int thisid;
ObjectModel objectModel;
bool checked = true;

@override
Widget codeit(FModelView fmv){

  return FCodeTextFormater(fmv: fmv, objcp: ObjectCodeProps.fcolumn(spacing: objectModel.spacing));
  
}

  @override
  Widget build(BuildContext context){
    objectModel.catName = 'Column';
    
    return
      GestureDetector(child: marked ?
          Container(/*width: 100, height: 100,*/ decoration: BoxDecoration(border: Border.all(color: const Color.fromRGBO(50, 52, 50, 1), width: 3,),), child: 
              //Column(mainAxisSize: MainAxisSize.max, children:
              Wrap( direction: Axis.vertical, spacing: objectModel.spacing, children://!Column 
                  [
                    //Checkbox(value: checked, onChanged: (value) => print(!checked)),//!TODO
                    Text(objectModel.catName + ' id: $thisid'),
                    for(int i=0; i<objectModel.childlist.length; i++)
                      objectModel.childlist[i], 
                  ],
              ),
          ) :
              Wrap( direction: Axis.vertical, spacing: objectModel.spacing, children://!Column 
                  [
                    Text(objectModel.catName + ' id: $thisid'),
                    for(int i=0; i<objectModel.childlist.length; i++)
                      objectModel.childlist[i],
                  ],
              ),
        onTap: () => callback(thisid),
      );
  }
}
//#region [ rgba(30, 30, 40, 0.2) ]//#endregion
class FRowObject extends StatelessWidget implements FDummytest {
  FRowObject({required this.callback, required this.thisid,
              this.marked = false, required this.objectModel, 
            });


final idCallback callback;
bool marked = true;
final int thisid;
ObjectModel objectModel;
bool checked = true;

  Rect rect = const Offset(1.0, 2.0) & const Size(3.0, 4.0);//!1200

Widget codeit(FModelView fmv){return SizedBox.shrink();}

  @override
  Widget build(BuildContext context){
    objectModel.catName = "Row";

    return
      GestureDetector(child: marked ?
          Container(/*width: 100, height: 100,*/ decoration: BoxDecoration(border: Border.all(color: const Color.fromRGBO(240, 252, 3, 1), width: 3,),), child: 
              //Row(mainAxisSize: MainAxisSize.max, children:
              Wrap( direction: Axis.horizontal, spacing: objectModel.spacing, children://!Column 
                  [
                    Container(child: CustomPaint(painter: OpenPainter(),),),//!1200
                    Text(objectModel.catName + ' id: $thisid'),
                    for(int i=0; i<objectModel.childlist.length; i++)
                      objectModel.childlist[i], 
                  ],
              ),
          ) :
              //Row(children: 
              MouseRegion(onHover: (e) => callback(thisid),//!#554433
                child: Wrap( direction: Axis.horizontal, spacing: objectModel.spacing, children://!Column 
                    [
                      Text(objectModel.catName + ' id: $thisid'),
                      for(int i=0; i<objectModel.childlist.length; i++)
                        objectModel.childlist[i],
                    ],
                ),
              ),
        onTap: () => callback(thisid),
      );
  }
}

class OpenPainter extends CustomPainter {//!1200

  @override
  void paint(Canvas canvas, Size size) {
    var paint1 = Paint()
      ..color = Color(0xff638965)
      ..style = PaintingStyle.stroke;
    //a rectangle
    canvas.drawRect(Offset(0, -40) & Size(300, 100), paint1);
    //canvas.drawLine(Offset(100, 100), Offset(200,200), paint1);
  }
 
  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class ObjectCodeProps{
      ObjectCodeProps.fbutton({required this.btnText, required this.btnTextColor, required this.borderradius}) : spacing = 0.0;
      ObjectCodeProps.fcolumn({required this.spacing}) : btnText = '', btnTextColor = Colors.transparent, borderradius = 0.0;

  String btnText;
  Color btnTextColor;
  double borderradius;

  double spacing;
}
