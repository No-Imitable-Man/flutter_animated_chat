import 'package:flutter/material.dart';

class ReactionMenu extends StatelessWidget {
  final Function(String) onReaction;
  const ReactionMenu({super.key, required this.onReaction});

  @override
  Widget build(BuildContext context) {
    final reactions = ['😎', '😓', '😀', '🥰', '😜', '😰'];
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: reactions.map((reaction) {
          return GestureDetector(
            onTap: () => onReaction(reaction),
            child: Container(
              padding: EdgeInsets.all(8),
              child: Text(reaction, style: TextStyle(fontSize: 20)),
            ),
          );
        }).toList(),
      ),
    );
  }
}
