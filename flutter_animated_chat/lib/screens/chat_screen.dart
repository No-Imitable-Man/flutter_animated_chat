import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_animated_chat/models/message.dart';
import 'package:flutter_animated_chat/widgets/message_bubble.dart';
import 'package:flutter_animated_chat/widgets/message_input.dart';
import 'package:flutter_animated_chat/widgets/typing_indicator.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  List<Message> _messages = [];
  bool _isTyping = false;
  bool _isOnline = true;
  late AnimationController _typingController;
  late AnimationController _onlineStatusController;

  @override
  void initState() {
    super.initState();
    _typingController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1500),
    )..repeat();

    _onlineStatusController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    )..repeat(reverse: true);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadInitialMessages();
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _typingController.dispose();
    _onlineStatusController.dispose();
    super.dispose();
  }

  void _loadInitialMessages() {
    final initialMessage = [
      Message(
        id: '1',
        text: "Hey! How are you doing?",
        isMe: false,
        timestamp: DateTime.now().subtract(Duration(minutes: 5)),
      ),
      Message(
        id: '2',
        text: "I am doing great, thanks for asking!",
        isMe: true,
        timestamp: DateTime.now().subtract(Duration(minutes: 4)),
      ),
      Message(
        id: '3',
        text: "That sounds awesome! Can you share more about your day?",
        isMe: false,
        timestamp: DateTime.now().subtract(Duration(minutes: 3)),
      ),
      Message(
        id: '4',
        text: "I am also doing well, just busy with work.",
        isMe: false,
        timestamp: DateTime.now().subtract(Duration(minutes: 2)),
        type: MessageType.image,
        imageUrl: "https://picsum.photos/300/200?random=1",
      ),
      Message(
        id: '5',
        text: "Voice Message",
        isMe: true,
        timestamp: DateTime.now().subtract(Duration(minutes: 1)),
        type: MessageType.voice,
        voiceDuration: 15.0,
      ),
    ];

    setState(() {
      _messages = initialMessage;
    });

    for (int i = 0; i < initialMessage.length; i++) {
      Future.delayed(Duration(milliseconds: i * 100), () {
        if (mounted && _listKey.currentState != null) {
          _listKey.currentState!.insertItem(i);
        }
      });
    }
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;
    final message = Message(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: _messageController.text.trim(),
      isMe: true,
      timestamp: DateTime.now(),
    );

    setState(() {
      _messages.add(message);
      _messageController.clear();
    });

    if (_listKey.currentState != null) {
      _listKey.currentState!.insertItem(_messages.length - 1);
    }

    _scrollToBottom();

    _simulateTypingResponse();
  }

  void _simulateTypingResponse() {
    setState(() {
      _isTyping = true;
    });

    Future.delayed(Duration(seconds: 2), () {
      if (mounted) {
        final responses = [
          'Thanks for your message! I will get bask to you shortly.',
          'I apprecieate your patience, I am typing a response now.',
          'Your message is important to me, I am working on it.',
        ];

        final response = Message(
          id: DateTime.now().microsecondsSinceEpoch.toString(),
          text: responses[math.Random().nextInt(responses.length)],
          isMe: false,
          timestamp: DateTime.now(),
        );
        setState(() {
          _messages.add(response);
          _isTyping = false;
        });

        if (_listKey.currentState != null) {
          _listKey.currentState!.insertItem(_messages.length - 1);
        }
        _scrollToBottom();
      }
    });
  }

  void _scrollToBottom() {
    Future.delayed(Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _addReaction(String messageId, String emoji) {
    setState(() {
      final messageIndex = _messages.indexWhere((msg) => msg.id == messageId);
      if (messageIndex != -1) {
        final message = _messages[messageIndex];
        final reactions = List<String>.from(message.reactions);
        if (reactions.contains(emoji)) {
          reactions.remove(emoji);
        } else {
          reactions.add(emoji);
        }

        _messages[messageIndex] = Message(
          id: message.id,
          text: message.text,
          isMe: message.isMe,
          timestamp: message.timestamp,
          type: message.type,
          imageUrl: message.imageUrl,
          voiceDuration: message.voiceDuration,
          reactions: message.reactions,
        );
      }
    });
  }

  void _addPhoto() {
    final message = Message(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      text: '',
      isMe: true,
      timestamp: DateTime.now(),
      type: MessageType.image,
      imageUrl:
          "https://picsum.photos/300/200?random=${math.Random().nextInt(100)}",
    );

    setState(() {
      _messages.add(message);
    });

    if (_listKey.currentState != null) {
      _listKey.currentState!.insertItem(_messages.length - 1);
    }
    _scrollToBottom();
  }

  void _addVoiceMessage() {
    final message = Message(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: 'Voice Message',
      isMe: true,
      timestamp: DateTime.now(),
      type: MessageType.voice,
      voiceDuration: math.Random().nextDouble() * 60,
    );

    setState(() {
      _messages.add(message);
    });

    if (_listKey.currentState != null) {
      _listKey.currentState!.insertItem(_messages.length - 1);
    }
    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xff007aff),
        elevation: 0,
        title: Row(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(
                    "https://picsum.photos/100/100?random=person}",
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: AnimatedBuilder(
                    animation: _onlineStatusController,
                    builder: (context, child) {
                      return Container(
                        width: 14,
                        height: 14,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _isOnline ? Colors.green : Colors.grey,
                        ),
                        child: _isOnline
                            ? ScaleTransition(
                                scale: Tween(begin: 0.8, end: 1.0).animate(
                                  CurvedAnimation(
                                    parent: _onlineStatusController,
                                    curve: Curves.easeInOut,
                                  ),
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.green,
                                  ),
                                ),
                              )
                            : null,
                      );
                    },
                  ),
                ),
              ],
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Sara Johnson",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    _isOnline ? "Online" : "Offline",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.video_call, color: Colors.white),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.call, color: Colors.white),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: AnimatedList(
              key: _listKey,
              controller: _scrollController,
              padding: EdgeInsets.all(16),
              initialItemCount: 0,
              itemBuilder: (context, index, animation) {
                if (index >= _messages.length) return SizedBox.shrink();
                return SlideTransition(
                  position: animation.drive(
                    Tween<Offset>(
                      begin: Offset(0, 1),
                      end: Offset.zero,
                    ).chain(CurveTween(curve: Curves.easeOutCubic)),
                  ),
                  child: FadeTransition(
                    opacity: animation,
                    child: MessageBubble(
                      message: _messages[index],
                      onReaction: _addReaction,
                    ),
                  ),
                );
              },
            ),
          ),
          if (_isTyping) TypingIndicator(animation: _typingController),
          MessageInput(
            controller: _messageController,
            onSendMessage: _sendMessage,
            onAddPhoto: _addPhoto,
            onAddVoiceMessage: _addVoiceMessage,
          ),
        ],
      ),
    );
  }
}
