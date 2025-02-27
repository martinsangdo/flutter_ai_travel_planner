import 'package:ai_travel_planner/constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AiChatScreen extends StatefulWidget {
  const AiChatScreen({super.key});

  @override
  State<AiChatScreen> createState() => _AiChatScreenState();
}

class _AiChatScreenState extends State<AiChatScreen> {
  String _newSessionId = '';
  final TextEditingController _textController = TextEditingController();
  final List<ChatMessage> _messages = [ChatMessage(text: 'I am an AI assistant specializing in information about travel matters.', isUser: false)];
  final ScrollController _scrollController = ScrollController();

  Future<void> _sendMessage() async {
    final userMessage = _textController.text;
    if (userMessage.isEmpty) return;

    setState(() {
      _messages.add(ChatMessage(text: userMessage, isUser: true));
      _textController.clear(); // Clear input field
    });

    try {
      final aiResponse = await _getAiResponse(userMessage);
      setState(() {
        _messages.add(ChatMessage(text: aiResponse, isUser: false));
      });
      // Scroll to the bottom after the build is complete
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300), // Adjust duration as needed
          curve: Curves.easeOut, // Adjust curve as needed
        );
      });
    } catch (e) {
      setState(() {
        _messages.add(ChatMessage(text: 'Error: Could not get AI response.', isUser: false));
      });
      debugPrint('Error getting AI response: $e');
    }
  }

  Future<String> _getAiResponse(String message) async {
    await Future.delayed(const Duration(milliseconds: 1000)); // Simulate API delay
    //call our backend to get content
    final headers = {'Content-Type': 'application/json'}; // Important for JSON requests
    
    final response = await http.Client().post(Uri.parse(glb_backend_uri + postGetChatboxContent), 
        headers: headers, body: jsonEncode({
          'text': message,
          'session_id': _newSessionId
    }));
    //debugPrint(response.body.toString());
    if (response.statusCode != 200){
      //debugPrint('Cannot get content from cloud');
      return CHATBOT_UNAVAILABLE;
    } else {
      Map<String, dynamic> objFromCloud = jsonDecode(response.body);
      //debugPrint(objFromCloud.toString());
      if (objFromCloud['result'] == 'OK'){
        //get text ok
        return objFromCloud['text'];
      } else {
        debugPrint(objFromCloud.toString());
        return CHATBOT_UNAVAILABLE;
      }
    }
  }

  @override
  void initState() {
    super.initState();
    //generate new session id
    setState(() {
      _newSessionId = generateUuid();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Column(
            children: [
              Text(
                "AI Assistant"
              )
            ],
          )
        )
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController, // Assign the ScrollController
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return ChatBubble(message: message);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: const InputDecoration(
                      hintText: 'Ask me anything ...',
                    ),
                  ),
                ),
                IconButton(
                  onPressed: _sendMessage,
                  icon: const Icon(Icons.send),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ChatMessage {
  final String text;
  final bool isUser;

  ChatMessage({required this.text, required this.isUser});
}

class ChatBubble extends StatelessWidget {
  final ChatMessage message;

  const ChatBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Align(
        alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: message.isUser ? Colors.blue[100] : Colors.grey[200],
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Text(message.text),
        ),
      ),
    );
  }
}