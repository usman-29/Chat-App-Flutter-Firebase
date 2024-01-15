import 'package:chat_app/api/apis.dart';
import 'package:chat_app/main.dart';
import 'package:chat_app/models/chat_users.dart';
import 'package:chat_app/models/message.dart';
import 'package:chat_app/widgets/message_card.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  final ChatUser user;
  const ChatScreen({super.key, required this.user});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  // for saving all the user messages
  late List<Message> _list;
  // for handling message text changes
  final TextEditingController _textController = TextEditingController();
  ScrollController listScrollController = ScrollController();

  void scrollToEndListView() {
    if (listScrollController.hasClients) {
      final position = listScrollController.position.maxScrollExtent;
      listScrollController.jumpTo(position);
    }
  }

  @override
  void initState() {
    super.initState();
    scrollToEndListView();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        elevation: 1,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.blue[600],
        flexibleSpace: SafeArea(
          child: Row(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(
                width: 2,
              ),
              Text(
                widget.user.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
                stream: APIs.getAllMessages(widget.user),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    // if data is loading
                    case ConnectionState.waiting:
                    case ConnectionState.none:
                      return const Center(
                        // when tapping the chat, while messages are loading show nothing
                        child: SizedBox(),
                      );
                    // if some or all of the data is loaded
                    case ConnectionState.active:
                    case ConnectionState.done:
                      final data = snapshot.data?.docs;
                      // receive all the json data, iterate with map and convert it into list
                      _list = data
                              ?.map((e) => Message.fromJson(e.data()))
                              .toList() ??
                          [];
                      // if contacts exist
                      if (_list.isNotEmpty) {
                        return ListView.builder(
                            reverse: true,
                            controller: listScrollController,
                            padding: EdgeInsets.only(top: mq.height * 0.01),
                            itemCount: _list.length,
                            itemBuilder: (context, index) {
                              return MessageCard(
                                message: _list[_list.length - index - 1],
                              );
                            });
                      }
                      // if no connection is found
                      else {
                        return const Center(
                          child: Text(
                            'Start conversation',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.black54,
                            ),
                          ),
                        );
                      }
                  }
                }),
          ),
          _chatInput(),
        ],
      ),
    );
  }

  // bottom chat input field
  Widget _chatInput() {
    return Padding(
      padding: EdgeInsets.only(
        top: mq.height * 0.01,
        bottom: mq.height * 0.01,
        left: mq.height * 0.01,
      ),
      child: Row(
        children: [
          // input field & buttons
          Expanded(
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _textController,
                      keyboardType: TextInputType.multiline,
                      maxLines: 3,
                      minLines: 1,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.only(left: 15),
                        hintText: 'Message',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  // adding space between camera and send button
                  SizedBox(
                    width: mq.width * 0.02,
                  ),
                ],
              ),
            ),
          ),

          // send message button
          MaterialButton(
            onPressed: () {
              if (_textController.text.isNotEmpty) {
                APIs.sendMessage(widget.user, _textController.text, Type.text);
                // when widget rebuilt it must not have any value else it will send it
                _textController.text = '';
              }
            },
            padding: const EdgeInsets.only(
              top: 10,
              bottom: 10,
              right: 5,
              left: 10,
            ),
            minWidth: 0,
            shape: const CircleBorder(),
            color: Colors.blueAccent,
            child: const Icon(
              Icons.send,
              color: Colors.white,
              size: 28,
            ),
          ),
        ],
      ),
    );
  }
}
