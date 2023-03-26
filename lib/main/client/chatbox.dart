import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class Message {
  final String sender;
  final String text;
  final DateTime time;

  const Message({
    required this.sender,
    required this.text,
    required this.time,
  });

  Message.fromJson(Map<dynamic, dynamic> json)
      : sender = json['sender'],
        text = json['text'],
        time = DateTime.fromMillisecondsSinceEpoch(json['time']);

  Map<dynamic, dynamic> toJson() => {
        'sender': sender,
        'text': text,
        'time': time.millisecondsSinceEpoch,
      };
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late final DatabaseReference _messagesRef;
  final List<Message> _messages = [];
  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _messagesRef = FirebaseDatabase.instance.reference().child('messages');
    _messagesRef.onChildAdded.listen((event) {
      final message =
          Message.fromJson(event.snapshot.value as Map<dynamic, dynamic>);
      setState(() {
        _messages.insert(0, message);
      });
    });
  }

  void _sendMessage() {
    final text = _textController.text;
    final message = Message(
      sender: 'You',
      text: text,
      time: DateTime.now(),
    );
    _messagesRef.push().set(message.toJson());
    _textController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return ListTile(
                  title: Text(message.sender),
                  subtitle: Text(message.text),
                  trailing: Text(message.time.toString()),
                );
              },
            ),
          ),
          TextField(
            controller: _textController,
            decoration: const InputDecoration(
              hintText: 'Enter message',
            ),
            onSubmitted: (value) => _sendMessage(),
          ),
        ],
      ),
    );
  }
}
