import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:my_portfolio/presentation/widgets/custom_text_heading.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class YoutubePlayerScreen extends StatefulWidget {
  const YoutubePlayerScreen({super.key});

  @override
  YoutubePlayerScreenState createState() => YoutubePlayerScreenState();
}

class YoutubePlayerScreenState extends State<YoutubePlayerScreen> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController.fromVideoId(
      videoId: "jRT0dsBE3Tg",
      autoPlay: false,
      params: const YoutubePlayerParams(
        showControls: true,
        mute: false,
        showFullscreenButton: true,
        loop: false,
      ),
    );

    _controller.setFullScreenListener(
      (isFullScreen) {
        log('${isFullScreen ? 'Entered' : 'Exited'} Fullscreen.');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFe0eafc), Color(0xFFcfdef3)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 32),
          const CustomSectionHeading(
            text: "Intro Video",
            subText: "Know me in less than 60 seconds",
          ),
          const SizedBox(height: 32),
          Center(
            child: Container(
              constraints: const BoxConstraints(
                maxWidth: 700,
                maxHeight: 400,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(16),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: YoutubePlayerScaffold(
                  controller: _controller,
                  builder: (context, player) {
                    return player;
                  },
                ),
              ),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }
}
