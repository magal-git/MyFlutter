import 'fmodelview.dart';



class FObjRepo {

static List<FModelView> stackobj = [];//#f75
static Map objmap = <int, FModelView>{};

static FModelView getCurObj(int curid, Map tmap){

  if(tmap.containsKey(curid)){
    return tmap[curid];
  }else{
    //print('no oki');
  }

  return tmap[0];
}

static void removeObj(FModelView fmv){

  if(fmv.parentId > 0){
        fmv = getCurObj(fmv.getMoid, FObjRepo.objmap);
        FModelView parent = getCurObj(fmv.parentId, FObjRepo.objmap);
        int pos = FObjRepo.stackobj.indexOf(parent);//#f75
        if(pos > -1){//!is the parent in stackobj?
          for(var child in FObjRepo.stackobj[pos].childlist()){//#f75
            if(child.getMoid == fmv.getMoid){
              FObjRepo.objmap.remove(child.getMoid);
              FObjRepo.stackobj[pos].childlist().remove(child);//#f75
              parent.fmc.removeChild(child);
            }
          }
        }else{
          FModelView parent_in_objmap = getCurObj(parent.getMoid, FObjRepo.objmap);
          for(var child in parent_in_objmap.childlist()){
            if(child.getMoid == fmv.getMoid){
              FObjRepo.objmap.remove(child.getMoid);
              parent_in_objmap.fmc.removeChild(child);
            }
          }
        }
      }else{
        FObjRepo.stackobj.removeAt(FObjRepo.stackobj.indexOf(fmv));//#f75
        FObjRepo.objmap.remove(fmv.getMoid);
      }
  }
}