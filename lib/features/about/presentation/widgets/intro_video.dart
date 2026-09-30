import 'dart:async';

import 'package:flutter/material.dart';
import 'package:my_portfolio/app/navigation/site_navigation.dart';
import 'package:my_portfolio/app/navigation/site_text_link.dart';
import 'package:my_portfolio/constants/sns_links.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

/// Thumbnail first; the YouTube iframe (a platform view) is created only when
/// play is pressed, so the page pays for the player only when it is wanted.
/// The YouTube link below doubles as the fallback if the player fails.
class IntroVideo extends StatefulWidget {
  const IntroVideo({super.key});

  static const String videoId = 'jRT0dsBE3Tg';
  static const String thumbnail = 'assets/images/intro_video_thumb.jpg';

  @override
  State<IntroVideo> createState() => _IntroVideoState();
}

class _IntroVideoState extends State<IntroVideo> {
  YoutubePlayerController? _controller;

  void _play() {
    final controller = YoutubePlayerController(
      params: const YoutubePlayerParams(
        showFullscreenButton: true,
        showVideoAnnotations: false,
        strictRelatedVideos: true,
      ),
    );
    unawaited(controller.loadVideoById(videoId: IntroVideo.videoId));
    setState(() => _controller = controller);
  }

  @override
  void dispose() {
    unawaited(_controller?.close());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = _controller;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: controller == null
                ? Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.asset(IntroVideo.thumbnail, fit: BoxFit.cover),
                      Center(
                        child: IconButton(
                          tooltip: 'Play intro video',
                          iconSize: 72,
                          icon: const Icon(
                            Icons.play_circle_fill_rounded,
                            color: Colors.white,
                          ),
                          onPressed: _play,
                        ),
                      ),
                    ],
                  )
                : YoutubePlayerScaffold(
                    controller: controller,
                    builder: (context, player) => player,
                  ),
          ),
        ),
        const SizedBox(height: 8),
        SiteTextLink(
          label: 'Watch on YouTube ↗',
          onTap: () => unawaited(openExternal(SnsLinks.introVideo)),
        ),
      ],
    );
  }
}
