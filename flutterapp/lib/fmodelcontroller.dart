import 'package:flutterapp/imports.dart';
import 'package:flutterapp/fmodelview.dart';


class FModelController extends GetxController{
  
  /*final*/ int moid = Random().nextInt(1000)+1;
  var bradius = 0.obs;
  var caddchildCol = false.obs;//!Set color to object if column is selected (in main)
  final colModel = ColModel().obs;

  var fbHeight = 50.obs;
  var fbWidth = 180.obs;

  var hpb = HelperBtn().obs;
  var marked = false.obs;

  final objectModel = ObjectModel().obs;
  final textModel = TextModel().obs;
  //!1109
  var positionX = 300.0.obs;
  var positionY = 300.0.obs;
  
  setPosition(Offset o){
    positionX.value = o.dx;
    positionY.value = o.dy;
  }
  //!1109

  Color prevcol = Colors.white;//!PRV
  Map fmcObjmap = <int, FModelView>{}.obs;

  set setfmcObjmap(Map<dynamic, dynamic> map){//#734
    fmcObjmap = map;
  }

  markTrue() => marked.value = true;
  markFalse() => marked.value = false;

  chText(String txt) {
     hpb.value = HelperBtn(btntext: txt);
  }

 //*ObjectModel methods
  incSpacing(){
    objectModel.update((val) {
      val!.spacing++;
    });
  }

  decSpacing(){
    objectModel.update((val) {
      val!.spacing--;
    });
  }

 //*ObjectModel methods

  chElevation(){
    hpb.update((val) {
      val!.elevation +=2;
    });
  }

  incBradius() => bradius++;

  addChild(FModelView f){
    objectModel.update((val) {
      val!.childlist.add(f);
    });
  }

  removeChild(FModelView ch){
    objectModel.update((val) {
      val!.childlist.remove(ch);
    });
  }

  List<Widget> get getChildList{
      return objectModel.value.childlist;
  }

  chCol(Color c) {
     colModel.update((val) { 
       val!.btncol = c;
     });
  }

  chTextCol(Color tc){
    colModel.update((val) {
      val!.txtcol = tc;
    });
  }

  Color get getCurCol{
      prevcol = colModel.value.btncol;
    return prevcol;
  }

  incW() => fbWidth += 2;
  decW() => fbWidth -= 2;
  incH() => fbHeight += 2;
  decH() => fbHeight -= 2;

//*TextModel
  set textData(String data){
    textModel.update((val) {
      val!.txtdata = data;
    });
  }
  incFontSize(){
    textModel.update((val) {
      val!.fontsize += 2;
    });
  }
  //incFontSize() => textModel.value.fontsize += 2;
//*

}

class TextModel{
  String txtdata = 'Text here!';
  double fontsize = 10;
  bool changeobj = false;

}

class ColModel{
  Color btncol = Colors.amber;
  Color selbtncol = Colors.grey.shade400;//#888 Just testing
  Color txtcol = Colors.white;
}

class ObjectModel{
  String catName = '';
  List<FModelView> childlist = [];
  double spacing = 4.0;
}

class HelperBtn {
  HelperBtn({this.btntext = 'Button', this.borderRadius = 0, this.elevation = 0});

  double borderRadius;
  String btntext;
  double elevation;
}