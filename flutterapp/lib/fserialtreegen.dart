import 'fmodelview.dart';
import 'fserializeview.dart';

typedef void addCallback(FModelView fvc);

class FSerializeTreeGen {
      FSerializeTreeGen(this.addobjmap);

final addCallback addobjmap;
  
List<FModelView> eltemp = [];
List<FModelView> fmvList = [];


 List<FModelView> serializeTree(List<FModelView> alist, int lev,){
    List<FModelView> coalist = [];
        
    for(int i=0; i<alist.length; i++){//! alist is not stackobj this time, so we must refactor.
       
      if(alist[i].type == 4){//!We got all objtypes from the database, so sort the out.
        fmvList.add(alist[i]);
      }
    }
     for (var element in alist) {//!Do it one more time so we render all the type 4 from above at the top of the canvas later
       if(element.haveChildren() && element.parentId == 0){//!find the top parent
         coalist.add(element);
        fmvList.add(element);
        _runIt(element.childlist(), /*element.level*/0);
       }
     }

    //!Fill list with the new value. Copy them to a new templist and send. 
    //!Clear out the list, so it not updates with the old values
    if(eltemp.isNotEmpty){
      eltemp.removeRange(0, eltemp.length);
    }
    for(var items in fmvList){
      eltemp.add(items);
      ////print('gen type ' + items.getMoid.toString() + ' ' + items.type.toString());
    }
    fmvList.removeRange(0, fmvList.length);
    //print('in serialtree');
    FSerializeView fsv = FSerializeView(eltemp);
    return fsv.tree();
  }

 _runIt(List<FModelView> cl, int curlev){

    cl.forEach((element) {
      if(element.haveChildren()){
        int plev = curlev + 1;
        element.type = 3;
        element.level = plev;
        fmvList.add(element);
        addobjmap(element);//#ff5
        _runIt(element.childlist(), plev);
      }else{//!The same, remove?
        int chlev = curlev + 1;
        if(element.isMultiWidget()){//!Even if element has no children? Check it!
          element.type = 3;
          element.level = chlev;
          addobjmap(element);//#ff5
          fmvList.add(element);
        }else{
          element.type = 2;
          element.level = chlev;
          addobjmap(element);//#ff5
          fmvList.add(element);
        }
      }
    });
  }

}