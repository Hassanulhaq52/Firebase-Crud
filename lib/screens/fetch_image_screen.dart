// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
//
// import 'add_image_screen.dart';
// import 'update_image_screen.dart';
//
// class FirebaseImageFetch extends StatefulWidget {
//   const FirebaseImageFetch({super.key});
//
//   @override
//   State<FirebaseImageFetch> createState() => _FirebaseImageFetchState();
// }
//
// class _FirebaseImageFetchState extends State<FirebaseImageFetch> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         body: Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//         StreamBuilder(
//             stream: FirebaseFirestore.instance
//                 .collection("userImageData")
//                 .snapshots(),
//             builder: (BuildContext context, snapshot) {
//               if (snapshot.connectionState == ConnectionState.waiting) {
//                 return const Center(
//                   child: CircularProgressIndicator(),
//                 );
//               }
//
//               if (snapshot.hasError) {
//                 return Center(
//                   child: Icon(
//                     Icons.error,
//                     size: 24,
//                     color: Colors.red,
//                   ),
//                 );
//               }
//
//               if (snapshot.hasData) {
//                 var dataLength = snapshot.data!.docs.length;
//                 return ListView.builder(
//                   itemCount: dataLength,
//                   shrinkWrap: true,
//                   scrollDirection: Axis.vertical,
//                   physics: const ScrollPhysics(),
//                   itemBuilder: (context, index) {
//                     String username = snapshot.data!.docs[index]['User-Name'];
//                     String userimage = snapshot.data!.docs[index]['User-Image'];
//                     String useremail = snapshot.data!.docs[index]['User-Email'];
//                     String userId = snapshot.data!.docs[index].id;
//                     print(username + useremail);
//                     return GestureDetector(
//                       onDoubleTap: () async {
//                         print("Deleting user with ID: $userId");
//                         FirebaseFirestore.instance
//                             .collection("userData")
//                             .doc(userId)
//                             .delete()
//                             .then((_) {
//                           ScaffoldMessenger.of(context).showSnackBar(
//                               SnackBar(content: Text("User Deleted")));
//                         }).catchError((error) {
//                           ScaffoldMessenger.of(context).showSnackBar(
//                               SnackBar(
//                                 content: Text("User is not Deleted"),
//                                 backgroundColor: Colors.red,
//                               ));
//                         });
//
//                       },
//                       onTap: () {
//                         Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => FirebaseImageUpdate(
//                                   ID: userId,
//                                   Email: useremail,
//                                   Name: username,
//                                   UImage: userimage),
//                             ));
//                       },
//                       child: Container(
//                         width: double.infinity,
//                         height: 90.0,
//                         margin: EdgeInsets.symmetric(horizontal: 20),
//                         decoration: BoxDecoration(
//                             color: Colors.green,
//                             border: Border.all(color: Colors.white, width: 2),
//                             borderRadius: BorderRadius.circular(20)),
//                         child: Row(
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           children: [
//                             CircleAvatar(
//                               radius: 30,
//                               backgroundColor: Colors.blue,
//                               backgroundImage: NetworkImage(userimage),
//                             ),
//
//                             // User Details
//                             Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 Text(username),
//                                 Text(useremail),
//                               ],
//                             )
//                           ],
//                         ),
//                       ),
//                     );
//                   },
//                 );
//               }
//
//               return Container();
//             }),
//         // ElevatedButton(
//         //   onPressed: () {
//         //     Navigator.push(
//         //         context,
//         //         MaterialPageRoute(
//         //           builder: (context) => FirebaseImageAdd(),
//         //         ));
//         //   },
//         //   child: Text("Add Data"),
//         // ),
//       ],
//     ));
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'update_image_screen.dart';

class FetchImageScreen extends StatefulWidget {
  const FetchImageScreen({Key? key}) : super(key: key);

  @override
  State<FetchImageScreen> createState() => _FetchImageScreenState();
}

class _FetchImageScreenState extends State<FetchImageScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("userImageData")
            .snapshots(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Icon(
                Icons.error,
                size: 24,
                color: Colors.red,
              ),
            );
          }

          if (snapshot.hasData) {
            var dataLength = snapshot.data!.docs.length;
            return ListView.builder(
              itemCount: dataLength,
              // shrinkWrap: true,
              // scrollDirection: Axis.vertical,
              // physics: const ScrollPhysics(),
              itemBuilder: (context, index) {
                String username = snapshot.data!.docs[index]['User-Name'];
                String userimage = snapshot.data!.docs[index]['User-Image'];
                String useremail = snapshot.data!.docs[index]['User-Email'];
                String userId = snapshot.data!.docs[index].id;
                print(username + useremail);
                return GestureDetector(
                  onDoubleTap: () async {
                    print("Deleting user with ID: $userId");
                    await FirebaseFirestore.instance
                        .collection("userData")
                        .doc(userId)
                        .delete()
                        .then((_) {
                      print("User deleted successfully!");
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("User Deleted")),
                      );
                      // Trigger a rebuild of the UI
                      setState(() {});
                    }).catchError((error) {
                      print("Error deleting user: $error");
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("User is not Deleted"),
                          backgroundColor: Colors.red,
                        ),
                      );
                    });
                  },
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UpdateImageScreen(
                          ID: userId,
                          Email: useremail,
                          Name: username,
                          UImage: userimage,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    width: double.infinity,
                    height: 90.0,
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      border: Border.all(color: Colors.white, width: 2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.blue,
                          backgroundImage: NetworkImage(userimage),
                        ),
                        // User Details
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(username),
                            Text(useremail),
                          ],
                        )
                      ],
                    ),
                  ),
                );
              },
            );
          }

          return Container();
        },
      ),
    );
  }
}
