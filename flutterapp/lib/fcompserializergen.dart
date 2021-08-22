import 'fmodelview.dart';
import 'fserializeview.dart';

typedef void addCallback(FModelView fvc);

class FCompSerializeGen {
      FCompSerializeGen(this.addobjmap);

final addCallback addobjmap;
  
List<FModelView> eltemp = [];
List<FModelView> fmvList = [];


 List<FModelView> serializeComponentTree(List<FModelView> alist, int lev,){
   
    
     for (var element in alist) {//!Do it one more time so we render all the type 4 from above at the top of the canvas later
       if(element.haveChildren() && element.parentId == 0){//!find the top parent
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
    
    return showComptree(eltemp);
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

  List<int> donelist = [];
  List<FModelView> fli = [];

  List<FModelView> showComptree(List<FModelView> fmvlist){
    for(int p=0; p<fmvlist.length; p++){

      fmvlist[p].twList.removeRange(0, fmvlist[p].twList.length);//&Clean list every render to avoid duplicates

      if(fmvlist[p].type == 1 && !donelist.contains(fmvlist[p].getMoid)){
        donelist.add(fmvlist[p].getMoid);
        //return ExpansionTile(backgroundColor: Colors.yellow,title: Text('Expansion: ' + fmvlist[p].getMoid.toString()),children: [
          fli.add(fmvlist[p]);
            /*funcCL(fmvlist[p], fmvlist[p].childlist()),
            for(int r=0; r<fmvlist[p].twList.length; r++)
              fmvlist[p].twList[r],*/
       //]);
      }else{//&if(fmvlist[p].type == 4 (Solo) Have no children
        if(fmvlist[p].type == 4 && !donelist.contains(fmvlist[p].getMoid)) {
          //return SizedBox(height: 30, child: Card(child: Text(fmvlist[p].fmc.objectModel.value.catName +':'+ fmvlist[p].getMoid.toString())));
          fli.add(fmvlist[p]);
        }
      }
    }
    return fli;
  }

}