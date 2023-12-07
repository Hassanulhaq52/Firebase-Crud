
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EditDataScreen extends StatefulWidget {
  const EditDataScreen(
      {Key? key,
        required this.docID,
        required this.title,
        required this.description})
      : super(key: key);

  final String docID;
  final String title;
  final String description;

  @override
  State<EditDataScreen> createState() => _EditDataScreenState();
}

class _EditDataScreenState extends State<EditDataScreen> {
  String? titleValue;
  String? descValue;

  @override
  void initState() {
    super.initState();
    titleValue = widget.title;
    descValue = widget.description;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TextField(
            onChanged: (value) {
              titleValue = value;
            },
          ),
          TextField(
            onChanged: (value) {
              descValue = value;
            },
          ),
          ElevatedButton(
              onPressed: () async {
                if (titleValue != '' && descValue != '') {
                  await FirebaseFirestore.instance
                      .collection('Data')
                      .doc(widget.docID)
                      .update({'title': titleValue, 'description': descValue});
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Center(child: Text('Changes has been Saved')),
                      backgroundColor: Colors.green,
                    ),
                  );
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(const SnackBar(content: Text('Error')));
                }
              },
              child: const Text('Save Changes'))
        ],
      ),
    );
  }
}
