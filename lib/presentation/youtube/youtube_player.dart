import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:my_portfolio/presentation/widgets/custom_text_heading.dart';
import 'package:my_portfolio/presentation/widgets/frosted_container_widget.dart';
import 'package:my_portfolio/resources/size_config.dart';
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
    return FrostedGlassContainer(
  height: getProportionateScreenHeight(600),
  width: double.infinity,
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      const SizedBox(height: 20),
      const CustomSectionHeading(
        text: "Intro Video",
        subText: "Know me in less than 60 seconds",
        isVideoHeading: true,
      ),
      const SizedBox(height: 20),
      Container(
        constraints: BoxConstraints(
          maxWidth: double.infinity,
          maxHeight: getProportionateScreenHeight(400),
        ),
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
