import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

import 'image_fetch.dart';

class FirebaseImageAdd extends StatefulWidget {
  const FirebaseImageAdd({super.key});

  @override
  State<FirebaseImageAdd> createState() => _FirebaseImageAddState();
}

class _FirebaseImageAddState extends State<FirebaseImageAdd> {
  TextEditingController userName = TextEditingController();
  TextEditingController userEmail = TextEditingController();

  File? userProfile;

  void sendWithImage() async {
    String userID = Uuid().v1();
    UploadTask uploadTask = FirebaseStorage.instance
        .ref()
        .child("User-Image")
        .child(userID)
        .putFile(userProfile!);
    TaskSnapshot taskSnapshot = await uploadTask;
    String userImageURL = await taskSnapshot.ref.getDownloadURL();
    addUser(imgurl: userImageURL, userid: userID);
  }

  void addUser({String? imgurl, String? userid}) async {
    Map<String, dynamic> userDetails = {
      "User-ID": userid,
      "User-Image": imgurl,
      "User-Name": userName.text.toString(),
      "User-Email": userEmail.text.toString()
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
        margin: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 10,
            ),
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
                      SnackBar(content: Text("Image Not Selected")));
                }
              },
              child: CircleAvatar(
                radius: 40,
                backgroundColor: Colors.blue,
                backgroundImage:
                userProfile != null ? FileImage(userProfile!) : null,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              decoration: InputDecoration(label: Text("Enter Your Name")),
              controller: userName,
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              decoration: InputDecoration(label: Text("Enter Your Email")),
              controller: userEmail,
            ),
            SizedBox(
              height: 10,
            ),
            ElevatedButton(
                onPressed: () {
                  if (userEmail != null && userName != null) {
                    sendWithImage();

                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text('Added')));
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FirebaseImageFetch(),
                        ));
                  } else {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text('Error')));
                  }
                },
                child: Text("Insert"))
          ],
        ),
      ),
    );
  }
}
