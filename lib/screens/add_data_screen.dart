import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_project/screens/read_data_screen.dart';
import 'package:flutter/material.dart';

class AddDataScreen extends StatefulWidget {
  const AddDataScreen({super.key});

  @override
  State<AddDataScreen> createState() => _AddDataScreenState();
}

class _AddDataScreenState extends State<AddDataScreen> {
  String? title;

  String? desc;

  static String data = 'Data';

  CollectionReference info = FirebaseFirestore.instance.collection(data);

  Future<dynamic> addData() {
    return info.add({'title': title, 'description': desc});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextField(
            onChanged: (value) {
              title = value;
            },
          ),
          TextField(
            onChanged: (value) {
              desc = value;
            },
          ),
          ElevatedButton(
              onPressed: () async {
                if (title != null && desc != null) {
                  final ad = await addData();
                  if (ad != null) {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ReadDataScreen(),
                        ));
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Center(child: Text('Data Added')),
                        backgroundColor: Colors.green));
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content:
                          Center(child: Text('Please Fill All the Fields')),
                      backgroundColor: Colors.red));
                  print('Error');
                }
              },
              child: const Text('Add'))
        ],
      ),
    );
  }
}
