import 'package:flutterapp/fmodelview.dart';

class FObjRebuilder {
  List<FModelView> reblist = [];

List<FModelView> reBuildWithChildren(List<FModelView> fmvlist){

    for(var obj in fmvlist){
      for(int i=0; i<fmvlist.length; i++){
        if(fmvlist[i].parentId == obj.getMoid){
          obj.fmc.addChild(fmvlist[i]);
        }
      }
      reblist.add(obj);
    }

  return reblist;
}


List<FModelView> reBuildComponentWithChildren(List<FModelView> fmvlist){

    for(var obj in fmvlist){
      for(int i=0; i<fmvlist.length; i++){
        if(fmvlist[i].parentId == obj.getMoid){
          obj.fmc.addChild(fmvlist[i]);
        }
      }
      obj.parentId == 0 ? reblist.add(obj) : '';
    }

  return reblist;
  }



}