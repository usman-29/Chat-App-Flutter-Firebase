import 'package:chat_app/api/apis.dart';
import 'package:chat_app/helper.dart/dialogs.dart';
import 'package:chat_app/models/chat_users.dart';
import 'package:chat_app/screens/auth/login_screen.dart';
import 'package:chat_app/widgets/chat_user_card.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // for storing all users
  List<ChatUser> _list = [];
  // for storing searched items
  final List<ChatUser> _searchList = [];
  // for storing search status
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    APIs.getUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // app bar
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.blue[600],
        title: _isSearching
            ? TextField(
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Name, Email...',
                ),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  letterSpacing: 0.5,
                ),
                // when search text changes update search list
                onChanged: (val) {
                  //search logic
                  //clear search list first
                  _searchList.clear();
                  // find matching users and add them in searching list
                  for (var i in _list) {
                    if (i.name.toLowerCase().contains(val.toLowerCase()) ||
                        i.email.toLowerCase().contains(val.toLowerCase())) {
                      _searchList.add(i);
                    }
                    setState(() {
                      _searchList;
                    });
                  }
                },
              )
            : const Text(
                'Chat App',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
        centerTitle: true,
        // home icon button
        actions: [
          // search icon button
          IconButton(
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
              });
            },
            icon: Icon(
              _isSearching ? Icons.cancel : Icons.search,
              color: Colors.white,
            ),
          ),
          // logout button
          IconButton(
            onPressed: () async {
              // for showing progress indicator loading circle
              Dialogs.showProgress(context);
              // for sign out user
              await APIs.auth.signOut().then((value) async {
                await GoogleSignIn().signOut().then((value) {
                  // replacing home screen with login because if we do not do it then home screen remains in the stack
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: ((context) => const LoginScreen())));
                });
              });
            },
            icon: const Icon(
              Icons.logout,
              color: Colors.white,
            ),
          ),
        ],
      ),
      // chats list
      body: StreamBuilder(
          stream: APIs.getAllUsers(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              // if data is loading
              case ConnectionState.waiting:
              case ConnectionState.none:
                return const SizedBox();
              // if some or all of the data is loaded
              case ConnectionState.active:
              case ConnectionState.done:
                final data = snapshot.data?.docs;
                _list =
                    data?.map((e) => ChatUser.fromJson(e.data())).toList() ??
                        [];
                // if contacts exist
                if (_list.isNotEmpty) {
                  return ListView.builder(
                      padding: const EdgeInsets.all(8),
                      itemCount:
                          _isSearching ? _searchList.length : _list.length,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        return ChatUserCard(
                          user:
                              // if searching show searching list else all users
                              _isSearching ? _searchList[index] : _list[index],
                        );
                      });
                }
                // if no connection is found
                else {
                  return const Center(
                    child: Text(
                      'No connections found',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black54,
                      ),
                    ),
                  );
                }
            }
          }),
    );
  }
}
