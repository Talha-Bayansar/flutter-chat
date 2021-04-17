import 'package:chat/services/auth.dart';
import 'package:chat/state/chat_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MessageInputRow extends StatelessWidget {
  final TextEditingController messageController = TextEditingController();
  final bool shouldAutoscroll;
  final bool firstAutoscrollExecuted;
  Function scrollToBottom;
  ScrollController scrollController;
  MessageInputRow(
      {this.firstAutoscrollExecuted,
      this.scrollController,
      this.scrollToBottom,
      this.shouldAutoscroll});
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: TextField(
              onTap: () {
                if (scrollController.hasClients && shouldAutoscroll) {
                  scrollToBottom();
                }

                if (!firstAutoscrollExecuted && scrollController.hasClients) {
                  scrollToBottom();
                }
              },
              controller: messageController,
              keyboardType: TextInputType.text,
              minLines: 1,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: 'Type a message',
                contentPadding: EdgeInsets.all(15),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
        ),
        TextButton(
          onPressed: () async {
            if (messageController.text.isNotEmpty) {
              print(messageController.text);
              await Provider.of<ChatData>(context, listen: false)
                  .firestore
                  .collection("messages")
                  .add({
                'chatId':
                    Provider.of<ChatData>(context, listen: false).activeChat,
                'message': messageController.text,
                'sender': AuthMethods().auth.currentUser.uid,
                "ts": FieldValue.serverTimestamp(),
              });

              if (scrollController.hasClients && shouldAutoscroll) {
                scrollToBottom();
              }

              if (!firstAutoscrollExecuted && scrollController.hasClients) {
                scrollToBottom();
              }

              messageController.clear();
            }
          },
          child: Padding(
            padding: EdgeInsets.all(5),
            child: Icon(
              Icons.send_rounded,
              color: Colors.white,
            ),
          ),
          style: ButtonStyle(
            shape: MaterialStateProperty.all(CircleBorder()),
            backgroundColor: MaterialStateProperty.all(Colors.yellow[800]),
            elevation: MaterialStateProperty.all(2),
          ),
        )
      ],
    );
  }
}
