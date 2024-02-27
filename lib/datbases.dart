import 'package:cloud_firestore/cloud_firestore.dart';

class Database {
  Future addpersonalData(Map<String,dynamic> userpersonaldata,String id)async{
    return await FirebaseFirestore.instance.collection("personal").doc(id).set(userpersonaldata);
  }
  Future addofficeData(Map<String,dynamic> userpersonaldata,String id)async{
    return await FirebaseFirestore.instance.collection("office").doc(id).set(userpersonaldata);
  }
  Future addcollegeData(Map<String,dynamic> userpersonaldata,String id)async{
    return await FirebaseFirestore.instance.collection("college").doc(id).set(userpersonaldata);
  }
  Future<Stream<QuerySnapshot>>getTask(String task)async{
    return await FirebaseFirestore.instance.collection(task).snapshots();
  }
  tickmethod(String id ,String task)async{
    return await FirebaseFirestore.instance
        .collection(task).doc(id)
        .update(
        {"yes": true});
  }
  removemethod(String id ,String task)async{
    return await FirebaseFirestore.instance
        .collection(task).doc(id)
        .delete();
  }
}