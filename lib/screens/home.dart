import 'package:chat/components/customAvatar.dart';
import 'package:chat/screens/chat.dart';
import 'package:chat/screens/login.dart';
import 'package:chat/services/auth.dart';
import 'package:chat/state/chat_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[700],
      appBar: AppBar(
        title: Text("Chats"),
        backgroundColor: Color(0xc8f0f03c),
        shadowColor: Colors.transparent,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              return showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text("Are you sure you want to sign out?"),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text("Cancel"),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            AuthMethods().signOut().then((value) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Login(),
                                ),
                              );
                            });
                          },
                          child: Text("Sign Out"),
                        ),
                      ],
                    );
                  });
            },
          )
        ],
        leading: Padding(
            padding: EdgeInsets.all(8),
            child: CustomAvatar(
              backgroundColor: Colors.grey[100],
              foregroundColor: Colors.red[400],
              letter: "T",
            )),
      ),
      body: SafeArea(
        child: Container(
          height: double.infinity,
          width: double.infinity,
          color: Colors.white,
          child: StreamBuilder(
            stream: Provider.of<ChatData>(context)
                .firestore
                .collection("chats")
                .where("users",
                    arrayContains: AuthMethods().auth.currentUser.uid)
                .snapshots(),
            builder: chatsStream,
          ),
        ),
      ),
    );
  }
}

Widget chatsStream(context, AsyncSnapshot<QuerySnapshot> snapshot) {
  if (!snapshot.hasData) {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  if (snapshot.hasError) {
    Center(
      child: Text("Oops, something went wrong."),
    );
  }
  List<dynamic> chats = [];
  for (var chat in snapshot.data.docs) {
    chats.add(chat);
  }

  return ListView.separated(
    separatorBuilder: (context, index) => Divider(
      height: 1,
      thickness: 1,
    ),
    itemCount: chats.length,
    itemBuilder: (context, index) {
      return Material(
        child: ListTile(
          onTap: () {
            print(chats[index].data());
            Provider.of<ChatData>(context, listen: false)
                .setActiveChat(chats[index].id);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Chat(),
              ),
            );
          },
          title: Text(getUsername(context, chats[index].data())),
          subtitle: FutureBuilder(
            future: getLastMessage(context, chats[index].data()),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Text("Loading...");
              }
              if (snapshot.hasError) {
                return Text("Could not load!");
              }
              return Text(
                snapshot.data,
                overflow: TextOverflow.ellipsis,
              );
            },
          ),
          trailing: Icon(Icons.arrow_forward_ios_rounded),
          leading: CircleAvatar(
            backgroundColor: Colors.yellow[400],
            foregroundColor: Colors.red[400],
            child: CustomAvatar(
              backgroundColor: Colors.yellow[400],
              foregroundColor: Colors.red[400],
              letter:
                  getUsername(context, chats[index].data())[0].toUpperCase(),
            ),
          ),
        ),
      );
    },
  );
}

String getUsername(BuildContext context, dynamic chat) {
  String username = "No Name Found";
  for (var user in chat["users"]) {
    if (!(AuthMethods().auth.currentUser.uid == user)) {
      String receiverId = user;
      for (var infoUser in chat["infoUsers"]) {
        if (receiverId == infoUser["uid"]) {
          username = infoUser["username"];
        }
      }
    }
  }
  return username;
}

Future<String> getLastMessage(BuildContext context, dynamic chat) async {
  QuerySnapshot messageSnapshot = await Provider.of<ChatData>(context)
      .firestore
      .collection("messages")
      .orderBy('ts')
      .limitToLast(1)
      .get();
  String message;
  for (var msg in messageSnapshot.docs) {
    message = msg["message"];
  }
  return message;
}
