// import 'package:flutter/material.dart';

// class EventChatRoom extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Container(
//           padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//           decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.all(Radius.circular(30))),
//           child: const Text(
//             'Cleaning drive in California',
//             style: TextStyle(fontSize: 12),
//           ),
//         ),
//         backgroundColor: Color(0xFF2E8747),
//         centerTitle: true,
//       ),
//       body: Container(
//         padding: EdgeInsets.all(16),
//         child: Column(
//           children: [
//             Expanded(
//               child: ListView(
//                 children: [
//                   // Chat bubble 1
//                   ChatBubble(
//                     message: 'Hello!',
//                     isMe: false,
//                   ),

//                   // Chat bubble 2
//                   ChatBubble(
//                     message: 'Hi, how are you?',
//                     isMe: true,
//                   ),

//                   // Chat bubble 3
//                   ChatBubble(
//                     message: 'I am good, thanks for asking!',
//                     isMe: false,
//                   ),

//                   ChatBubble(
//                     message: 'Looking Forward to meet you guys',
//                     isMe: true,
//                   ),
//                 ],
//               ),
//             ),

//             // Input field and send button
//             Row(
//               children: [
//                 Expanded(
//                   child: TextFormField(
//                     decoration: InputDecoration(
//                       hintText: 'Type your message here',
//                       hintStyle:
//                           TextStyle(fontSize: 14, color: Colors.grey.shade400),
//                       border: const OutlineInputBorder(
//                         borderRadius: BorderRadius.all(
//                           Radius.circular(30),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 16),
//                 FloatingActionButton(
//                   backgroundColor: const Color(0xFF2E8747),
//                   onPressed: () {},
//                   child: const Icon(
//                     Icons.send,
//                     color: Colors.white,
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class ChatBubble extends StatelessWidget {
//   final String message;
//   final bool isMe;

//   ChatBubble({required this.message, required this.isMe});

//   @override
//   Widget build(BuildContext context) {
//     return Align(
//       alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
//       child: Container(
//         padding: EdgeInsets.all(16),
//         margin: EdgeInsets.symmetric(vertical: 8),
//         decoration: BoxDecoration(
//           color: isMe ? Color.fromARGB(255, 21, 128, 35) : Colors.grey.shade300,
//           borderRadius: BorderRadius.circular(16),
//           boxShadow: isMe
//               ? [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.1),
//                     //blurRadius: 3,
//                     offset: Offset(3, 6),
//                   ),
//                 ]
//               : [],
//         ),
//         child: Text(
//           message,
//           style: TextStyle(
//             color: isMe ? Colors.white : Colors.black,
//             fontSize: 12,
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class EventChatRoom extends StatelessWidget {
  const EventChatRoom({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("Chats"),
      ),
    );
  }
}
