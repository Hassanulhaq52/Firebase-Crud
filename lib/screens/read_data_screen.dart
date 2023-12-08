import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'edit_data_screen.dart';

class ReadDataScreen extends StatelessWidget {
  const ReadDataScreen({super.key});

  void deleteData(String docID) async {
    await FirebaseFirestore.instance.collection('Data').doc(docID).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder(
      stream: FirebaseFirestore.instance.collection('Data').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.hasError) {
          return const Center(
            child: Icon(Icons.error, size: 24, color: Colors.red),
          );
        }

        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(snapshot.data!.docs[index]['title']),
                subtitle: Text(snapshot.data!.docs[index]['description']),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditDataScreen(
                                  docID: snapshot.data!.docs[index].id,
                                  title: snapshot.data!.docs[index]['title'],
                                  description: snapshot.data!.docs[index]
                                      ['description']),
                            ));
                      },
                      icon: const Icon(Icons.edit),
                    ),
                    IconButton(
                      onPressed: () {
                        deleteData(snapshot.data!.docs[index].id);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Center(child: Text('Data Deleted')),
                            backgroundColor: Colors.red,
                          ),
                        );
                      },
                      icon: const Icon(Icons.delete, color: Colors.red),
                    ),
                  ],
                ),
              );
            },
          );
        }
        return const Center(
          child: Text('No Data Found'),
        );
      },
    ));
  }
}
