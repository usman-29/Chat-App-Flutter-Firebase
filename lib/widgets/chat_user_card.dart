import 'package:chat_app/models/chat_users.dart';
import 'package:chat_app/screens/chat_screen.dart';
import 'package:flutter/material.dart';

class ChatUserCard extends StatefulWidget {
  final ChatUser user;
  const ChatUserCard({super.key, required this.user});

  @override
  State<ChatUserCard> createState() => _ChatUserCardState();
}

class _ChatUserCardState extends State<ChatUserCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // navigating to chat screen
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: ((context) => ChatScreen(
                      user: widget.user,
                    ))));
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.blue,
          ),
          padding:
              const EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Row(
                  children: <Widget>[
                    CircleAvatar(
                      backgroundImage: NetworkImage(widget.user.image),
                      maxRadius: 30,
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    Expanded(
                      child: Container(
                        color: Colors.transparent,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              widget.user.name,
                              style: const TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(
                              height: 6,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
