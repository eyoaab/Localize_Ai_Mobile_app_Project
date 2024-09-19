import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:loclaize_ai/feutures/authetication/presentation/pages/signin_page.dart';
import 'package:loclaize_ai/feutures/chat/domain/entity/message_entity.dart';
import 'package:loclaize_ai/feutures/chat/presentation/bloc/chat_bloc.dart';
import 'package:loclaize_ai/feutures/chat/presentation/bloc/chat_event.dart';
import 'package:loclaize_ai/feutures/chat/presentation/bloc/chat_state.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final List<Message> _messages = [
    Message(text: 'Ask anything you want, I am here to help you', isUser: false),
  ];

  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
      );
    }
  }

  void _sendMessage() {
    if (_isLoading) return;
    if (_messageController.text.isNotEmpty) {
      final userMessage = _messageController.text;

      setState(() {
        _messages.add(Message(text: userMessage, isUser: true));
        _isLoading = true;
        _messageController.clear();
      });
      _scrollToBottom();

      FocusScope.of(context).unfocus();

      BlocProvider.of<ChatBloc>(context).add(GetChatEvent(message: userMessage));
    }
  }

  void _handleLogout() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SignInPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text("Chat Page"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _handleLogout,
          ),
        ],
      ),
      body: Stack(
        children: [
          Opacity(
            opacity: 0.3,
            child: Image.asset(
              'assets/logo.png',
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
          Column(
            children: [
              Expanded(
                child: BlocListener<ChatBloc, ChatState>(
                  listener: (context, state) {
                    if (state is ChatLoadedState) {
                      setState(() {
                        _messages.add(Message(text: state.chatData.message, isUser: false));
                        _isLoading = false;
                      });
                      _scrollToBottom();
                    } else if (state is ChatErrorState) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(state.errorMessage)),
                      );
                      setState(() {
                        _isLoading = false;
                      });
                    }
                  },
                  child: ListView.builder(
                    controller: _scrollController,
                    itemCount: _messages.length + (_isLoading ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (_isLoading && index == _messages.length) {
                        return const Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                            child: Row(
                              children: [
                                SpinKitWave(
                                  color: Colors.greenAccent,
                                  size: 20.0,
                                ),
                                SizedBox(width: 10),
                                Text(
                                  "Assistant is typing...",
                                  style: TextStyle(color: Color.fromARGB(255, 0, 0, 0), fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                        );
                      }

                      final message = _messages[index];
                      bool isUserMessage = message.isUser;

                      return Align(
                        alignment: isUserMessage ? Alignment.centerRight : Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                          padding: const EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            color: isUserMessage
                                ? Colors.blueAccent.withOpacity(0.8)
                                : Colors.greenAccent.withOpacity(0.8),
                            borderRadius: BorderRadius.only(
                              topLeft: const Radius.circular(20),
                              topRight: const Radius.circular(20),
                              bottomLeft: isUserMessage ? const Radius.circular(20) : const Radius.circular(0),
                              bottomRight: isUserMessage ? const Radius.circular(0) : const Radius.circular(20),
                            ),
                          ),
                          child: Text(
                            message.text,
                            style: const TextStyle(color: Color.fromARGB(255, 25, 25, 25), fontSize: 16),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 30.0, left: 8.0, right: 8.0, top: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _messageController,
                        decoration: InputDecoration(
                          hintText: "Type a message",
                          hintStyle: const TextStyle(color: Colors.grey), 
                          filled: true,
                          fillColor: Colors.white, 
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                            borderSide: BorderSide.none, 
                          ),
                          contentPadding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0), // Padding inside the TextField
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                            borderSide: BorderSide(color: Colors.grey.withOpacity(0.5), width: 1.0), // Light border
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                            borderSide: BorderSide(color: Colors.blueAccent, width: 2.0), // Highlighted border when focused
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.send, color: Colors.blueAccent),
                      onPressed: _sendMessage,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
