import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

import 'fetch_image_screen.dart';

class UpdateImageScreen extends StatefulWidget {
  String id;
  String name;
  String userImage;
  String email;

  UpdateImageScreen(
      {super.key,
      required this.id,
      required this.name,
      required this.userImage,
      required this.email});

  @override
  State<UpdateImageScreen> createState() => _UpdateImageScreenState(
      email: email, name: name, userImage: userImage, id: id);
}

class _UpdateImageScreenState extends State<UpdateImageScreen> {
  String id;
  String name;
  String userImage;
  String email;

  _UpdateImageScreenState(
      {required this.id,
      required this.name,
      required this.userImage,
      required this.email});

  File? userProfile;

  String userName = '';
  String userEmail = '';

  void updateWithImage() async {
    String userID = const Uuid().v1();
    UploadTask uploadTask = FirebaseStorage.instance
        .ref()
        .child("User-Image")
        .child(userID)
        .putFile(userProfile!);
    TaskSnapshot taskSnapshot = await uploadTask;
    String userImage = await taskSnapshot.ref.getDownloadURL();
    dataUpdate(imgurl: userImage, id: userID);
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FetchImageScreen(),
        ));
  }

  void dataUpdate({String? imgurl, String? id}) async {
    await FirebaseFirestore.instance
        .collection("userImageData")
        .doc(id)
        .update({
      "User-ID": id,
      "User-Image": imgurl,
      "User-Name": userName,
      "User-Email": userEmail
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    userName = widget.name;
    userEmail = widget.email;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
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
              child: userProfile == null
                  ? CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.blue,
                      backgroundImage: NetworkImage(userImage),
                    )
                  : CircleAvatar(
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
                  updateWithImage();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const FetchImageScreen(),
                      ));
                },
                child: const Text("Update"))
          ],
        ),
      ),
    );
  }
}
