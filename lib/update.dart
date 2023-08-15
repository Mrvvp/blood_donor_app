import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class UpdateDonor extends StatefulWidget {
  const UpdateDonor({super.key});

  @override
  State<UpdateDonor> createState() => _UpdateDonorState();
}

class _UpdateDonorState extends State<UpdateDonor> {
  final bloodGroups = ["A+", "A-", "B+", "B-", "AB+", "AB-", "O+", "O-"];
  String? selectedGroup;
  final CollectionReference donor = FirebaseFirestore.instance.collection('donor');
  TextEditingController donorName = TextEditingController();
  TextEditingController donorPhone = TextEditingController();

  void updateDonor(docID){
    final data = {
      'Name' : donorName.text,
      'Phone' : donorPhone.text,
      'group' : selectedGroup,
    };
    donor.doc(docID).update(data).then((value) => Navigator.pop(context));
  }


  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map;
    donorName.text = args['Name'];
    donorPhone.text = args['Phone'];
    selectedGroup = args['group'];
    final docId = args['id'];
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Donors'),
        backgroundColor: Colors.black,
      ),
      body:  Padding(
        padding: EdgeInsets.all(15.0),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: TextField(
                controller: donorName,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    label: Text("Donor Name")
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: TextField(
                controller: donorPhone,
                keyboardType: TextInputType.number,
                maxLength: 10,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    label: Text("Phone Number")
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownButtonFormField(
                  value: selectedGroup,
                  decoration: InputDecoration(
                      label: Text("Select Blood Group")
                  ),
                  items: bloodGroups.map((e) => DropdownMenuItem(child: Text(e),
                    value: e,
                  )).toList(), onChanged: (val){
                selectedGroup =val;
              }),
            ),
            ElevatedButton(onPressed: (){

              updateDonor(docId);
            },
                style: ButtonStyle(
                    minimumSize: MaterialStateProperty.all(Size(double.infinity, 50)),
                    backgroundColor: MaterialStateProperty.all(Colors.black)
                ),
                child: Text("Update",style: TextStyle(fontSize: 20),))

          ],
        ),
      ),
    );
  }
}
