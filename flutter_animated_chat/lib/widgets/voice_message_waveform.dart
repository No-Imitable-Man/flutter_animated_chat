import 'package:flutter/material.dart';
import 'package:flutter_animated_chat/widgets/waveform_painter.dart';

class VoiceMessageWaveForm extends StatefulWidget {
  final double duration;
  final bool isMe;
  const VoiceMessageWaveForm({
    super.key,
    required this.duration,
    required this.isMe,
  });

  @override
  State<VoiceMessageWaveForm> createState() => _VoiceMessageWaveFormState();
}

class _VoiceMessageWaveFormState extends State<VoiceMessageWaveForm>
    with SingleTickerProviderStateMixin {
  late AnimationController _playController;
  bool _isPlaying = false;
  double _currentPosition = 0;

  @override
  void initState() {
    super.initState();
    _playController = AnimationController(
      vsync: this,
      duration: Duration(seconds: widget.duration.toInt()),
    );
  }

  @override
  void dispose() {
    _playController.dispose();
    super.dispose();
  }

  void _togglePlay() {
    setState(() {
      if (_isPlaying) {
        _playController.stop();
      } else {
        _playController.forward(from: _currentPosition / widget.duration);
      }
      _isPlaying = !_isPlaying;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: _togglePlay,
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: widget.isMe ? Colors.white.withOpacity(0.2) : Colors.blue,
              shape: BoxShape.circle,
            ),
            child: Icon(
              _isPlaying ? Icons.pause : Icons.play_arrow,
              color: Colors.white,
            ),
          ),
        ),
        SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomPaint(
                size: Size(120, 30),
                painter: WaveFormPainter(
                  progress: _playController.value,
                  isMe: widget.isMe,
                ),
              ),
              SizedBox(height: 4),
              Text(
                "${widget.duration.toInt()}s",
                style: TextStyle(
                  fontSize: 12,
                  color: widget.isMe
                      ? Colors.white.withOpacity(0.8)
                      : Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
