import 'package:flutter/material.dart';
import 'package:flutter_animated_chat/models/message.dart';
import 'package:flutter_animated_chat/widgets/reaction_menu.dart';
import 'package:flutter_animated_chat/widgets/voice_message_waveform.dart';

class MessageBubble extends StatefulWidget {
  final Message message;
  final Function(String, String) onReaction;
  const MessageBubble({
    super.key,
    required this.message,
    required this.onReaction,
  });

  @override
  State<MessageBubble> createState() => _MessageBubbleState();
}

class _MessageBubbleState extends State<MessageBubble>
    with SingleTickerProviderStateMixin {
  late AnimationController _reactionController;
  bool _showReactionMenu = false;

  @override
  void initState() {
    super.initState();
    _reactionController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
  }

  @override
  dispose() {
    _reactionController.dispose();
    super.dispose();
  }

  void _toggleReactionMenu() {
    setState(() {
      _showReactionMenu = !_showReactionMenu;
      if (_showReactionMenu) {
        _reactionController.forward();
      } else {
        _reactionController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: _toggleReactionMenu,
      child: Stack(
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 16),
            child: Column(
              crossAxisAlignment: widget.message.isMe
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: widget.message.isMe
                      ? MainAxisAlignment.end
                      : MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if (!widget.message.isMe)
                      CircleAvatar(
                        radius: 16,
                        backgroundImage: NetworkImage(
                          "https://picsum.photos/100/100?random=person",
                        ),
                      ),
                    SizedBox(width: 8),
                    Flexible(
                      child: Container(
                        constraints: BoxConstraints(maxWidth: 280),
                        child: Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: widget.message.isMe
                                ? Colors.blueAccent
                                : Colors.grey[300],
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: _buildMessageContent(),
                        ),
                      ),
                    ),
                  ],
                ),
                if (widget.message.reactions.isNotEmpty)
                  Container(
                    margin: EdgeInsets.only(top: 4),
                    child: Wrap(
                      children: widget.message.reactions.map((reaction) {
                        return Container(
                          margin: EdgeInsets.only(right: 4),
                          padding: EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(reaction, style: TextStyle(fontSize: 12)),
                        );
                      }).toList(),
                    ),
                  ),
              ],
            ),
          ),
          if (_showReactionMenu)
            Positioned(
              top: 30,
              left: widget.message.isMe ? null : 50,
              right: widget.message.isMe ? 0 : null,
              child: ScaleTransition(
                scale: _reactionController,
                child: ReactionMenu(
                  onReaction: (emoji) {
                    widget.onReaction(widget.message.id, emoji);
                    _toggleReactionMenu();
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildMessageContent() {
    switch (widget.message.type) {
      case MessageType.text:
        return Text(
          widget.message.text,
          style: TextStyle(
            color: widget.message.isMe ? Colors.white : Colors.black87,
            fontSize: 16,
          ),
        );
      case MessageType.image:
        return Hero(
          tag: widget.message.id,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              widget.message.imageUrl!,
              fit: BoxFit.cover,
              height: 150,
              width: 200,
            ),
          ),
        );
      case MessageType.voice:
        return VoiceMessageWaveForm(
          duration: widget.message.voiceDuration ?? 0,
          isMe: widget.message.isMe,
        );
    }
  }
}
