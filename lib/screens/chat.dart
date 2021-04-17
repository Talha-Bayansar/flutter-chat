import 'dart:async';

import 'package:chat/components/messageInputRow.dart';
import 'package:chat/components/messages/receiverMessage.dart';
import 'package:chat/components/messages/senderMessage.dart';
import 'package:chat/services/auth.dart';
import 'package:chat/state/chat_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

ScrollController _scrollController = new ScrollController();
bool _firstAutoscrollExecuted = false;
bool _shouldAutoscroll = false;
void _scrollToBottom() {
  Timer(
    Duration(milliseconds: 300),
    () => _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 100),
        curve: Curves.easeIn),
  );
}

void _scrollListener() {
  _firstAutoscrollExecuted = true;

  if (_scrollController.hasClients &&
      _scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
    _shouldAutoscroll = true;
  } else {
    _shouldAutoscroll = false;
  }
}

class Chat extends StatefulWidget {
  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    _scrollToBottom();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[700],
      appBar: AppBar(
        title: Text("Chat 1"),
        backgroundColor: Color(0xc8f0f03c),
        shadowColor: Colors.transparent,
      ),
      body: SafeArea(
        child: Container(
          height: double.infinity,
          width: double.infinity,
          color: Colors.white,
          child: StreamBuilder(
            stream: Provider.of<ChatData>(context)
                .firestore
                .collection("messages")
                .orderBy('ts')
                .snapshots(),
            builder: messageStreamBuilder,
          ),
        ),
      ),
    );
  }
}

Widget messageStreamBuilder(context, snapshot) {
  if (!snapshot.hasData) {
    return Center(
      child: CircularProgressIndicator(),
    );
  }
  if (snapshot.hasError) {
    return Text("Something went wrong!");
  }
  List<Widget> messages = [];
  for (var message in snapshot.data.docs) {
    if (message["sender"] == AuthMethods().auth.currentUser.uid) {
      messages.add(
        SenderMessage(
          message: message["message"],
        ),
      );
    } else {
      messages.add(
        ReceiverMessage(
          message: message["message"],
        ),
      );
    }
  }
  return Column(
    children: [
      Expanded(
        child: ListView(
          controller: _scrollController,
          shrinkWrap: true,
          children: messages,
        ),
      ),
      MessageInputRow(
        firstAutoscrollExecuted: _firstAutoscrollExecuted,
        scrollController: _scrollController,
        scrollToBottom: _scrollToBottom,
        shouldAutoscroll: _shouldAutoscroll,
      ),
    ],
  );
}
