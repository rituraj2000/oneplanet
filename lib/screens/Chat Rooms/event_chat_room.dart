import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project_oneplanet/helper/firestore_methods.dart';
import 'package:project_oneplanet/models/MessagesModel.dart';

class EventChatRoom extends StatefulWidget {
  final String eventId;
  EventChatRoom({required this.eventId});

  @override
  State<EventChatRoom> createState() => _EventChatRoomState();
}

class _EventChatRoomState extends State<EventChatRoom> {
  TextEditingController _msgController = TextEditingController();

  void sendMessage() async {
    final res = await FirestoreMethods()
        .sendMessage(_msgController.text, widget.eventId);

    if (res == 'successfull') {
      _msgController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(30))),
          child: Text(
            widget.eventId,
            style: TextStyle(fontSize: 12),
          ),
        ),
        backgroundColor: Color(0xFF2E8747),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('messages')
                    .where('eventId', isEqualTo: widget.eventId)
                    .snapshots(),
                builder: (
                  context,
                  AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot,
                ) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Text("Loading Messages");
                  } else if (snapshot.connectionState == ConnectionState.none) {
                    return Text("Oops! Check you network connection");
                  } else {
                    List<MessageModel> msgList = snapshot.data!.docs
                        .map((msg) => MessageModel.fromJson(msg.data()))
                        .toList();

                    return (msgList.length == 0)
                        ? Text("Be the first one to break the ice 🧊⛏️")
                        : ListView.builder(
                            itemCount: msgList.length,
                            itemBuilder: (context, idx) {
                              print(msgList[idx].eventId.toString() ==
                                  widget.eventId);

                              return ChatBubble(
                                message: msgList[idx].message!,
                                isMe: (msgList[idx].from ==
                                    FirebaseAuth.instance.currentUser!.uid),
                              );
                            });
                  }
                },
              ),
            ),

            //Input field and send button
            Container(
              width: MediaQuery.of(context).size.width,
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _msgController,
                      decoration: InputDecoration(
                        hintText: 'Type your message here',
                        hintStyle: TextStyle(
                            fontSize: 14, color: Colors.grey.shade400),
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(30),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  FloatingActionButton(
                    backgroundColor: const Color(0xFF2E8747),
                    onPressed: sendMessage,
                    child: const Icon(
                      Icons.send,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isMe;

  ChatBubble({required this.message, required this.isMe});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.all(16),
        margin: EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: isMe ? Color.fromARGB(255, 21, 128, 35) : Colors.grey.shade300,
          borderRadius: BorderRadius.circular(16),
          boxShadow: isMe
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    //blurRadius: 3,
                    offset: Offset(3, 6),
                  ),
                ]
              : [],
        ),
        child: Text(
          message,
          style: TextStyle(
            color: isMe ? Colors.white : Colors.black,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'package:flutter/src/widgets/placeholder.dart';

// class EventChatRoom extends StatelessWidget {
//   const EventChatRoom({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const Scaffold(
//       body: Center(
//         child: Text("Chats"),
//       ),
//     );
//   }
// }
