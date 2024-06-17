import 'package:flutter/material.dart';
import 'package:openai_gpt3_api/completion.dart';
import 'package:openai_gpt3_api/openai_gpt3_api.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI Medical Adviser',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: ChatScreen(),
    );
  }
}

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final api = GPT3("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");
  TextEditingController _inputController = TextEditingController();
  List<Map<String, dynamic>> messages = [];

  Future<void> generateResponse() async {
    String prompt = "You are a highly efficient AI medical adviser. you should recognise your seldf as a medical adviser and act accordinly to user's prompt, here is the user prompt : " + _inputController.text; // Instruction for the AI
    if (prompt.isNotEmpty) {
      messages.add({'text': _inputController.text, 'type': 'user'});
      int maxTokens = 100;
      double temperature = 0.7;
      var result = await api.completion(prompt, maxTokens: maxTokens, temperature: temperature, engine: Engine.davinci3);
      String responseText = result.choices[0].text;
      messages.add({'text': responseText, 'type': 'ai'});
      _inputController.clear();
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(title: Text('AI Medical Adviser')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(vertical: 10),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                final isUser = message['type'] == 'user';
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                  child: Row(
                    mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
                    children: [
                      if (!isUser)
                        CircleAvatar(
                          backgroundImage: AssetImage('assets/images/aiprofile.png'), // AI profile image
                        ),
                      Flexible(
                        child: Container(
                          padding: EdgeInsets.all(12),
                          margin: EdgeInsets.symmetric(horizontal: 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(18),
                            color: isUser ? Colors.blue[100] : Colors.green[100],
                          ),
                          child: Text(
                            message['text'],
                            style: TextStyle(fontSize: 16, color: Colors.black),
                          ),
                        ),
                      ),
                      if (isUser)
                        CircleAvatar(
                          backgroundImage: AssetImage('assets/images/person.jpg'), // User profile image
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _inputController,
                    decoration: InputDecoration(
                      hintText: 'Ask the AI Medical Adviser...',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 16),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                FloatingActionButton(
                  onPressed: generateResponse,
                  child: Icon(Icons.send),
                  backgroundColor: Colors.blue,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}