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
  final List<Message> _messages = [];
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;
  bool _hasError = false; 

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
    if (_messageController.text.isNotEmpty) {
      final userMessage = _messageController.text;

      setState(() {
        _messages.add(Message(text: userMessage, isUser: true));
        _isLoading = true; 
        _hasError = false; 
        _messageController.clear();
      });

      BlocProvider.of<ChatBloc>(context).add(GetChatEvent(message: userMessage));
      _scrollToBottom(); 
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
        title: const Text("Chat Page"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _handleLogout, 
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocListener<ChatBloc, ChatState>(
              listener: (context, state) {
                if (state is ChatLoadedState) {
                  setState(() {
                    _messages.add(Message(text: state.chatData.message, isUser: false));
                    _isLoading = false; 
                    _hasError = false; 
                  });
                  _scrollToBottom();
                } else if (state is ChatErrorState) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.errorMessage)),
                  );
                  setState(() {
                    _isLoading = false; 
                    _hasError = true; 
                  });
                }
              },
              child: ListView.builder(
                controller: _scrollController,
                itemCount: _messages.length + (_isLoading || _hasError ? 1 : 0),
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
                              style: TextStyle(color: Colors.grey, fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    );
                  } else if (_hasError && index == _messages.length) {
                    return const Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                        child: Row(
                          children: [
                            Icon(Icons.error, color: Colors.red),
                            SizedBox(width: 10),
                            Text(
                              "An error occurred. Please try again.",
                              style: TextStyle(color: Colors.red, fontSize: 16),
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
                        style: const TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 30.0, left: 8.0, right: 8.0), 
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: "Type a message",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
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
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
