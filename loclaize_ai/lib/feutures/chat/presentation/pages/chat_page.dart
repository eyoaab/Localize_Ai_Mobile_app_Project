
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loclaize_ai/core/commonWidgets/store.dart';
import 'package:loclaize_ai/feutures/chat/domain/entity/message_entity.dart';
import 'package:loclaize_ai/feutures/chat/presentation/bloc/chat_bloc.dart';
import 'package:loclaize_ai/feutures/chat/presentation/bloc/chat_event.dart';
import 'package:loclaize_ai/feutures/chat/presentation/bloc/chat_state.dart';

class ChatPage extends StatefulWidget {
  final String name;
  final String email;

  const ChatPage({Key? key, required this.name, required this.email}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final List<Message> _messages = [
    Message(text: 'የሚፈልጉትን ማንኛውንም ነገር ይጠይቁ, እርስዎን ለመርዳት ዝግጁ ነኝ', isUser: false),
  ];

  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;
  String? _errorMessage;

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
        _errorMessage = null;
      });
      _scrollToBottom();

      FocusScope.of(context).unfocus();

      BlocProvider.of<ChatBloc>(context).add(GetChatEvent(message: userMessage));
    }
  }

  void _handleLogout() {
    messageForLogOut(context, const Icon(Icons.question_mark_outlined, color: Colors.red, size: 40), widget.name);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 238, 238, 238),
          title: const Text("Localize-Ai", style: TextStyle(color: Colors.black)),
          actions: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.name,
                  style: GoogleFonts.balthazar(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  widget.email,
                  style: const TextStyle(fontSize: 16, color: Colors.blueAccent),
                ),
              ],
            ),
            IconButton(
              icon: const Icon(Icons.logout, color: Color.fromARGB(255, 155, 2, 2)),
              onPressed: _handleLogout,
            ),
          ],
        ),
        body: Stack(
          children: [
            Opacity(
              opacity: 0.3,
              child: Image.asset(
                'assets/logo1.jpg',
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
                          _errorMessage = null; 
                        });
                        _scrollToBottom();
                      } else if (state is ChatErrorState) {
                        setState(() {
                          _errorMessage = state.errorMessage; 
                          _isLoading = false;
                        });
                        _scrollToBottom();
                      }
                    },
                    child: ListView.builder(
                      controller: _scrollController,
                      itemCount: _messages.length + (_isLoading ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (_isLoading && index == _messages.length) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const SpinKitWave(
                                  color: Colors.greenAccent,
                                  size: 20.0,
                                ),
                                const SizedBox(width: 10),
                                const Text(
                                  "ረዳትዎ  እየጻፈ ነው....",
                                  style: TextStyle(color: Colors.black, fontSize: 16),
                                ),
                                if (_errorMessage != null) ...[
                                  const SizedBox(width: 10),
                                  Icon(Icons.error, color: Colors.red), // Show error icon
                                  const SizedBox(width: 5),
                                  Text(
                                    _errorMessage!,
                                    style: const TextStyle(color: Colors.red, fontSize: 16),
                                  ),
                                ],
                              ],
                            ),
                          );
                        }

                        final message = _messages[index];
                        bool isUserMessage = message.isUser;

                        return Align(
                          alignment: isUserMessage ? Alignment.centerRight : Alignment.centerLeft,
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                            padding: const EdgeInsets.all(12.0),
                            decoration: BoxDecoration(
                              color: isUserMessage
                                  ? Colors.blueAccent.withOpacity(0.9)
                                  : Colors.greenAccent.withOpacity(0.9),
                              borderRadius: BorderRadius.only(
                                topLeft: const Radius.circular(20),
                                topRight: const Radius.circular(20),
                                bottomLeft: isUserMessage ? const Radius.circular(20) : const Radius.circular(0),
                                bottomRight: isUserMessage ? const Radius.circular(0) : const Radius.circular(20),
                              ),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 4,
                                  offset: Offset(2, 2),
                                ),
                              ],
                            ),
                            child: Text(
                              message.text,
                              style: TextStyle(
                                color: isUserMessage
                                    ? const Color.fromARGB(255, 255, 255, 255).withOpacity(0.9)
                                    : const Color.fromARGB(255, 0, 0, 0).withOpacity(0.9),
                                fontSize: 16,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _messageController,
                          decoration: createMessageInputDecoration(),
                          onSubmitted: (_) => _sendMessage(),
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
