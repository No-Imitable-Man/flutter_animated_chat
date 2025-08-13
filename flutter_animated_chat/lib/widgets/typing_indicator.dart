import 'dart:math' as math;

import 'package:flutter/material.dart';

class TypingIndicator extends StatelessWidget {
  final AnimationController animation;
  const TypingIndicator({super.key, required this.animation});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundImage: NetworkImage(
              "https://picsum.photos/100/100?random=person",
            ),
          ),
          SizedBox(width: 12),
          Container(
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (int i = 0; i < 3; i++)
                  AnimatedBuilder(
                    animation: animation,
                    builder: (context, child) {
                      return Container(
                        margin: EdgeInsets.only(right: i < 2 ? 4 : 0),
                        child: Transform.scale(
                          scale: math.sin(
                            (animation.value * 4 * math.pi) +
                                (i * 0.5) * 0.3 +
                                0.7,
                          ),
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: Colors.grey[400],
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
