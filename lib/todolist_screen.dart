import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart';

import 'datbases.dart';
import 'list.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  
  TextEditingController todocontroler = TextEditingController();

  bool personal = true ,college = false, office = false ;
  bool suggest = false;

  Stream?otstream;

  getonload()async{
    otstream = await Database()
          .getTask(personal?"personal":
      office?"office":"college");
    setState(() {

    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Widget getwork(){
    return StreamBuilder(stream: otstream, builder: (context,AsyncSnapshot snapshot){
      return snapshot.hasData?
          Expanded(
            child: ListView.builder(
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context,index){
                  DocumentSnapshot documentSnapshot = snapshot.data.docs[index];
                  return Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12)
                      ),
                      margin: EdgeInsets.only(bottom: 20),
                      child: CheckboxListTile(
                        activeColor: Colors.lightBlue,
                        controlAffinity: ListTileControlAffinity.leading,
                        title: Text(documentSnapshot["Work"],style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500),),
                        value: documentSnapshot["yes"], onChanged: (newValue)async {
                          await Database().tickmethod(documentSnapshot["id"], personal?"personal":
                          office?"office":"college");
                        setState(() {
                          Future.delayed(Duration(seconds: 2),(){
                            Database().removemethod(documentSnapshot["id"],  personal?"personal":
                            office?"office":"college");
                          });
                        });
                      },
                      )
                  );
                }),
          ):Center(child: CircularProgressIndicator());

    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(Icons.menu),
            Container(
              height: 40,
                width: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25)
                ),
                child: Icon(Icons.supervised_user_circle_rounded))
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(onPressed: () {
        openbox();
      },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        backgroundColor: Colors.blue,
        child: Icon(Icons.add,size: 35,color: Colors.white,),
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12)
              ),
              child: TextField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  prefixIcon: Icon(Icons.search),
                  hintText: "Search"
                ),
              ),
            ),
            SizedBox(height: 20,),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
              personal ? Material(
                elevation: 5,
                borderRadius: BorderRadius.circular(15),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 18,vertical: 7),
                  decoration: BoxDecoration(
                    color: Colors.greenAccent,
                    borderRadius: BorderRadius.circular(15)
                  ),
                  child: Text('Personal',style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold),),
                ),
              ) : GestureDetector(
                  onTap: ()async{
                    personal = true;
                    office = false;
                    college = false;
                    await getonload();
                    setState(() {

                    });
                  },
                  child: Text('Personal',style: TextStyle(fontSize: 20),)),

                office ? Material(
                  elevation: 5,
                  borderRadius: BorderRadius.circular(15),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 18,vertical: 7),
                    decoration: BoxDecoration(
                        color: Colors.greenAccent,
                        borderRadius: BorderRadius.circular(15)
                    ),
                    child: Text('Office',style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold),),
                  ),
                ) : GestureDetector(
                    onTap: ()async{
                      personal = false;
                      office = true;
                      college = false;
                      await getonload();
                      setState(() {

                      });
                    },
                    child: Text('Office',style: TextStyle(fontSize: 20),)),

                college ? Material(
                  elevation: 5,
                  borderRadius: BorderRadius.circular(15),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 18,vertical: 7),
                    decoration: BoxDecoration(
                        color: Colors.greenAccent,
                        borderRadius: BorderRadius.circular(15)
                    ),
                    child: Text('College',style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold),),
                  ),
                ) : GestureDetector(
                    onTap: ()async{
                      personal = false;
                      office = false;
                      college = true;
                      await getonload();
                      setState(() {

                      });
                    },
                    child: Text('College',style: TextStyle(fontSize: 20),)),

            ],),

            SizedBox(height: 20,),

            getwork(),
          ],
        ),
      ),
    );
  }

 Future openbox(){
    return showDialog(context: context, builder: (context)=>AlertDialog(
      content: Container(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(onPressed: (){
                    Navigator.pop(context);
                  }, icon: Icon(Icons.cancel)),
                  SizedBox(width: 30,),
                  Text("Add TODO Task",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                ],
              ),
              SizedBox(height: 15,),
              Text("Add Text",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w600)),
              SizedBox(height: 10,),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  border: Border.all(width: 2,color: Colors.blue)
                ),
                child: TextField(
                  controller: todocontroler,
                  decoration: InputDecoration(
                    hintText: "Enter the Task",
                    border: InputBorder.none
                  ),
                ),
              ),
              SizedBox(height: 15,),
              Center(
                child: GestureDetector(
                  onTap: (){
                    String id = randomAlphaNumeric(10);
                    Map<String,dynamic> userTODO = {
                      "Work" : todocontroler.text,
                      "id" : id,
                      "yes" : false,
                    };
                    personal ?  Database().addpersonalData(userTODO, id):
                        office ? Database().addofficeData(userTODO, id):
                        Database().addcollegeData(userTODO, id);
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.blue[300],
                    ),
                    child: Text('Add Task',style: TextStyle(fontWeight: FontWeight.bold),),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    ));
  }

}
