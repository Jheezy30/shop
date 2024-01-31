/*
This database stores posts that the users have published in the app.
it is stored in a collection called posts in firebase

each post contains:
- a message
- email or user
- timestamp
 */

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreDatabase {
  //current logged in user
  User? user = FirebaseAuth.instance.currentUser;

  //get collection of posts from user
  final CollectionReference posts =
      FirebaseFirestore.instance.collection("Posts");

  //post a message
  Future<void> addPost(String message) {
    return posts.add({
      'UserEmail': user!.email,
      'postMessages': message,
      'TimeStamp': Timestamp.now(),
    });
  }

  // read posts from database
  Stream<QuerySnapshot> getPostsStream() {
    final postsStream = FirebaseFirestore.instance
        .collection('Posts')
         .orderBy('TimeStamp', descending: true)
        .snapshots();

    return postsStream;
  }
}
