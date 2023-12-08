import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

import 'fetch_image_screen.dart';

class UpdateImageScreen extends StatefulWidget {
  String ID;
  String Name;
  String UImage;
  String Email;

  UpdateImageScreen(
      {super.key,
      required this.ID,
      required this.Name,
      required this.UImage,
      required this.Email});

  @override
  State<UpdateImageScreen> createState() => _UpdateImageScreenState(
      Email: Email, Name: Name, UImage: UImage, ID: ID);
}

class _UpdateImageScreenState extends State<UpdateImageScreen> {
  String ID;
  String Name;
  String UImage;
  String Email;

  _UpdateImageScreenState(
      {required this.ID,
      required this.Name,
      required this.UImage,
      required this.Email});

  File? userProfile;

  TextEditingController userName = TextEditingController();
  TextEditingController userEmail = TextEditingController();

  void updateWithImage() async {
    String userID = Uuid().v1();
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
      "User-Name": userName.text.toString(),
      "User-Email": userEmail.text.toString()
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    userName.text = widget.Name;
    userEmail.text = widget.Email;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(
              height: 10
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
              child: userProfile == null
                  ? CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.blue,
                      backgroundImage: NetworkImage(UImage),
                    )
                  : CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.blue,
                      backgroundImage:
                          userProfile != null ? FileImage(userProfile!) : null,
                    ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              decoration: InputDecoration(label: Text("Enter Your Name")),
              controller: userName,
            ),
            const SizedBox(height: 10),
            TextFormField(
              decoration: InputDecoration(label: Text("Enter Your Email")),
              controller: userEmail,
            ),
            const SizedBox(height: 10),
            ElevatedButton(
                onPressed: () {
                  updateWithImage();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FetchImageScreen(),
                      ));
                },
                child: Text("Update"))
          ],
        ),
      ),
    );
  }
}
