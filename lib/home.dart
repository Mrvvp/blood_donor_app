import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final CollectionReference donor = FirebaseFirestore.instance.collection('donor');

  void deleteDonor(docID){
    donor.doc(docID).delete();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Donors",style: TextStyle(color: Colors.white,fontSize: 30)),
        backgroundColor: Colors.black,
      ),
      floatingActionButton: FloatingActionButton(onPressed: (){
        Navigator.pushNamed(context, '/add');
      },
        backgroundColor: Colors.white,
        child: const Icon(Icons.add,color:Colors.black,size: 40,),),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndTop,
      body: StreamBuilder(
        stream: donor.orderBy('Name').snapshots(),
        builder: (context,AsyncSnapshot snapshot){
          if(snapshot.hasData){
            return ListView.builder(
              itemCount: snapshot!.data.docs.length,
              itemBuilder:(context,index){
                final DocumentSnapshot donorSnap = snapshot.data.docs[index];
                return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    height: 80,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade300,
                            blurRadius: 10,
                            spreadRadius: 15,
                          )
                        ]
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            child: CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: 30,
                              child:
                              Text(donorSnap['group'],
                                style: TextStyle(fontSize: 25,color: Colors.red,fontWeight: FontWeight.bold),
                              ),

                            ),
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(donorSnap['Name'],style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),),
                            Text(donorSnap['Phone'].toString(),
                              style: TextStyle(fontSize: 18),),
                          ],
                        ),
                        Row(
                          children: [
                            IconButton(onPressed: (){
                              Navigator.pushNamed(context, '/update',
                                  arguments: {
                                    'Name' : donorSnap['Name'],
                                    'Phone': donorSnap['Phone'].toString(),
                                    'group': donorSnap['group'],
                                    'id'  : donorSnap.id,

                                  }
                              );
                            }, icon: Icon(Icons.edit),
                              iconSize: 30,
                              color: Colors.blue,),
                            IconButton(onPressed: (){
                              deleteDonor(donorSnap.id);
                            }, icon: Icon(Icons.delete),
                              iconSize: 30,
                              color: Colors.blue,),
                          ],
                        )

                      ],
                    ),
                  ),
                );
              },);
          }
          return Container();
        },
      ),
    );
  }
}
