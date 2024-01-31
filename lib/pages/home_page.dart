import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shop/components/my_drawer.dart';
import 'package:shop/components/my_post_button.dart';
import 'package:shop/components/my_textfield.dart';
import 'package:shop/database/firestore.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  //create a controller
  final TextEditingController newPostController = TextEditingController();

  // firestore access
  final FirestoreDatabase database = FirestoreDatabase();

  //post message
  void postMessage() {
    //only post message if there is something in the textfield
    if (newPostController.text.isNotEmpty) {
      String message = newPostController.text;
      database.addPost(message);
    }
    //after done we need to clear
    newPostController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Home',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
        elevation: 0,
      ),
      drawer: const MyDrawer(),
      body: Column(
        children: [
          //Textfield box for user to type
          Padding(
            padding: const EdgeInsets.all(25.0),
            child: Row(
              children: [
                //textfield
                Expanded(
                  child: MyTextField(
                    hintText: "Say something...",
                    obscureText: false,
                    controller: newPostController,
                  ),
                ),
                //post button

                PostButton(
                  onTap: postMessage,
                ),
              ],
            ),
          ),
          //POSTS
          StreamBuilder(
              stream: database.getPostsStream(),
              builder: (context, snapshot) {
                //show loading circle

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                //get all posts
                final posts = snapshot.data!.docs;

                //no data ?
                if (snapshot.data == null || posts.isEmpty) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(25),
                      child: Text("No posts... Post something!"),
                    ),
                  );
                }

                // return to a list
                return Expanded(
                    child: ListView.builder(
                        itemCount: posts.length,
                        itemBuilder: (context, index) {
                          //get each individual posts
                          final post = posts[index];

                          //get data from each posts
                          String message = post['postMessages'];
                          String userEmail = post['UserEmail'];
                          Timestamp timestamp = post['TimeStamp'];


                          //return a list tile
                          return ListTile(
                            title: Text(
                                message,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                                userEmail,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.inversePrimary,
                              ),
                            ),
                          );
                        }));
              }),
        ],
      ),
    );
  }
}
