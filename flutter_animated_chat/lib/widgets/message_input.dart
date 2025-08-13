import 'package:flutter/material.dart';

class MessageInput extends StatefulWidget {
  final TextEditingController controller;
  final VoidCallback onSendMessage;
  final VoidCallback onAddPhoto;
  final VoidCallback onAddVoiceMessage;
  const MessageInput({
    super.key,
    required this.controller,
    required this.onSendMessage,
    required this.onAddPhoto,
    required this.onAddVoiceMessage,
  });

  @override
  State<MessageInput> createState() => _MessageInputState();
}

class _MessageInputState extends State<MessageInput> {
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    setState(() {
      _hasText = widget.controller.text.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          if (!_hasText) ...[
            IconButton(
              onPressed: widget.onAddPhoto,
              icon: Icon(Icons.photo_camera),
              color: Colors.grey[600],
            ),
            IconButton(
              onPressed: widget.onAddVoiceMessage,
              icon: Icon(Icons.mic),
              color: Colors.grey[600],
            ),
          ],
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(25),
              ),
              child: TextField(
                controller: widget.controller,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Type a Message",
                  contentPadding: EdgeInsets.symmetric(vertical: 8),
                ),
                onSubmitted: (_) => widget.onSendMessage(),
              ),
            ),
          ),
          SizedBox(width: 8),
          GestureDetector(
            onTap: widget.onSendMessage,
            child: Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Color(0xff007aff),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.send, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
