import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

import 'fetch_image_screen.dart';

class AddImageScreen extends StatefulWidget {
  const AddImageScreen({super.key});

  @override
  State<AddImageScreen> createState() => _AddImageScreenState();
}

class _AddImageScreenState extends State<AddImageScreen> {
  String? userName = '';
  String? userEmail = '';

  File? userProfile;

  void sendWithImage() async {
    String userID = const Uuid().v1();
    UploadTask uploadTask = FirebaseStorage.instance
        .ref()
        .child("User-Image")
        .child(userID)
        .putFile(userProfile!);
    TaskSnapshot taskSnapshot = await uploadTask;
    String userImageURL = await taskSnapshot.ref.getDownloadURL();
    addUser(imgURL: userImageURL, userid: userID);
  }

  void addUser({String? imgURL, String? userid}) async {
    Map<String, dynamic> userDetails = {
      "User-ID": userid,
      "User-Image": imgURL,
      "User-Name": userName,
      "User-Email": userEmail,
    };
    await FirebaseFirestore.instance
        .collection("userImageData")
        .doc(userid)
        .set(userDetails);
    // Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () async {
                XFile? selectedImage =
                    await ImagePicker().pickImage(source: ImageSource.gallery);
                if (selectedImage != null) {
                  File convertedImage = File(selectedImage!.path);
                  setState(() {
                    userProfile = convertedImage;
                  });
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Image Not Selected")));
                }
              },
              child: CircleAvatar(
                radius: 40,
                backgroundColor: Colors.blue,
                backgroundImage:
                    userProfile != null ? FileImage(userProfile!) : null,
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              onChanged: (value) {
                userName = value;
              },
            ),
            const SizedBox(height: 10),
            TextField(
              onChanged: (value) {
                userEmail = value;
              },
            ),
            const SizedBox(height: 10),
            ElevatedButton(
                onPressed: () {
                  if (userEmail != null && userName != null) {
                    sendWithImage();

                    ScaffoldMessenger.of(context)
                        .showSnackBar(const SnackBar(content: Text('Added')));
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const FetchImageScreen(),
                        ));
                  } else {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(const SnackBar(content: Text('Error')));
                  }
                },
                child: const Text("Insert"))
          ],
        ),
      ),
    );
  }
}
