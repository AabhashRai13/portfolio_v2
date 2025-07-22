import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:my_portfolio/presentation/widgets/custom_text_heading.dart';
import 'package:my_portfolio/presentation/widgets/frosted_container_widget.dart';
import 'package:my_portfolio/resources/size_config.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class YoutubePlayerScreen extends StatefulWidget {
  const YoutubePlayerScreen({required this.isMobile, super.key});
  final bool isMobile;

  @override
  YoutubePlayerScreenState createState() => YoutubePlayerScreenState();
}

class YoutubePlayerScreenState extends State<YoutubePlayerScreen> {
  bool isPlaying = false;
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      params: const YoutubePlayerParams(
        showFullscreenButton: true,
        showVideoAnnotations: false,
        strictRelatedVideos: true,
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
      height: widget.isMobile
          ? getProportionateScreenHeight(400)
          : getProportionateScreenHeight(600),
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          const CustomSectionHeading(
            text: 'Intro Video',
            subText: 'Know me in less than 60 seconds',
            isVideoHeading: true,
          ),
          const SizedBox(height: 20),
          Expanded(
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: isPlaying
                  ? YoutubePlayerScaffold(
                      controller: _controller,
                      builder: (context, player) {
                        return player;
                      },
                    )
                  : Stack(
                      alignment: Alignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            'https://i3.ytimg.com/vi/jRT0dsBE3Tg/maxresdefault.jpg',
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.play_circle_filled,
                            size: 64,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            setState(() {
                              isPlaying = true;
                              _controller.loadVideoById(
                                videoId: 'jRT0dsBE3Tg',
                                startSeconds: 0,
                              );
                            });
                          },
                        ),
                      ],
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
