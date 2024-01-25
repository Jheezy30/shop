import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({super.key});

  //current logged in user
  // current logged in user
  final User? currentUser = FirebaseAuth.instance.currentUser;

// future to fetch user details
  Future<DocumentSnapshot<Map<String, dynamic>>> getUserDetails() async {

    return await FirebaseFirestore.instance
        .collection("users")
        .doc(currentUser!.email)
        .get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        elevation: 0.0,
        title: const Text("profile"),
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          future: getUserDetails(),
          builder: (context, snapshot) {
            //loading....
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            //error
            else if (snapshot.hasError) {
              return Text("Error: ${snapshot.error}");
            }
            //data received
            else if (snapshot.hasData) {
              //extract data
              Map<String, dynamic>? user = snapshot.data!.data();
              print(snapshot.data!.data());

              return Column(
                children: [
                  Text(user!['email']),
                  Text(user['username']),
                ],
              );
            } else {
              return Text("No data");
            }
          }),
    );
  }
}
