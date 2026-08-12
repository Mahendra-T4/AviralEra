import 'dart:async';
import 'package:flutter/material.dart';
import 'package:online_course/core/service/connectivity/connectivity_checker.dart';
import 'package:online_course/core/service/connectivity/no_internat_page.dart';
import 'package:online_course/core/service/logger/logger.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class VideoPlayerPanel extends StatefulWidget {
  const VideoPlayerPanel({super.key});
  static const String routeName = '/video-player';

  @override
  State<VideoPlayerPanel> createState() => _VideoPlayerPanelState();
}

class _VideoPlayerPanelState extends State<VideoPlayerPanel> {
  late VideoPlayerController _videoPlayerController;
  bool _showControls = true;
  Timer? _hideTimer;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _initVideo();
  }

  Future<void> _initVideo() async {
    try {
      final yt = YoutubeExplode();
      const videoUrl = 'https://youtu.be/3bEkaRUVOeU?si=UoeD8NAJ8RkhIUAi';

      // Extract the direct stream URL from YouTube
      final manifest = await yt.videos.streamsClient.getManifest(videoUrl);
      final streamInfo = manifest.muxed.withHighestBitrate();
      yt.close();

      final actualUrl = streamInfo.url.toString();
      logger.d("Extracted Video URL: $actualUrl");

      _videoPlayerController = VideoPlayerController.networkUrl(
        Uri.parse(actualUrl),
        httpHeaders: {
          'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64)',
        },
      );

      await _videoPlayerController.initialize();

      _videoPlayerController.addListener(() {
        if (mounted) setState(() {});
      });

      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        _startHideTimer();
      }
    } catch (e) {
      logger.d("Error loading YouTube video, falling back to direct MP4: $e");

      // FALLBACK TO DIRECT MP4 if YouTube extraction fails or blocks
      try {
        _videoPlayerController = VideoPlayerController.networkUrl(
          Uri.parse(
            'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
          ),
        );
        await _videoPlayerController.initialize();
        _videoPlayerController.addListener(() {
          if (mounted) setState(() {});
        });
        if (mounted) {
          setState(() {
            _isLoading = false;
            _errorMessage = "YouTube video blocked. Playing sample video.";
          });
          _startHideTimer();
        }
      } catch (fallbackError) {
        if (mounted) {
          setState(() {
            _isLoading = false;
            _errorMessage = fallbackError.toString();
          });
        }
      }
    }
  }

  @override
  void dispose() {
    _hideTimer?.cancel();
    if (!_isLoading) {
      _videoPlayerController.dispose();
    }
    super.dispose();
  }

  void _startHideTimer() {
    _hideTimer?.cancel();
    _hideTimer = Timer(const Duration(seconds: 3), () {
      if (mounted && _videoPlayerController.value.isPlaying) {
        setState(() {
          _showControls = false;
        });
      }
    });
  }

  void _toggleControls() {
    setState(() {
      _showControls = !_showControls;
    });
    if (_showControls) {
      _startHideTimer();
    }
  }

  void _seekRelative(Duration duration) {
    final currentPosition = _videoPlayerController.value.position;
    final newPosition = currentPosition + duration;
    _videoPlayerController.seekTo(newPosition);
    _startHideTimer();
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "${duration.inHours > 0 ? '${duration.inHours}:' : ''}$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator(color: Colors.white)),
      );
    }

    // Show fatal error if initialization completely failed
    if (!_videoPlayerController.value.isInitialized) {
      return StreamBuilder(
       stream: InternetConnectivityChecker().connectionStream,
        initialData: true, // Assume connected initially
        builder: (context, snapshot) {
          // Handle error state
          if (snapshot.hasError) {
            return const NoInternetPage();
          }

          // Handle disconnected state
          if (snapshot.data == false) {
            return const NoInternetPage();
          }

          // Handle loading state
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          return Scaffold(
            backgroundColor: Colors.black,
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Text(
                  _errorMessage ?? "Failed to initialize video.",
                  style: const TextStyle(color: Colors.redAccent, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          );
        }
      );
    }

    final isBuffering = _videoPlayerController.value.isBuffering;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Center(
          child: AspectRatio(
            aspectRatio: _videoPlayerController.value.aspectRatio,
            child: GestureDetector(
              onTap: _toggleControls,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // The Video Player
                  VideoPlayer(_videoPlayerController),

                  // Display fallback warning message at the top right if we had to fallback
                  if (_errorMessage != null)
                    Positioned(
                      top: 64,
                      right: 16,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.redAccent.withValues(alpha:0.8),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          _errorMessage!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),

                  // Gradient Overlay & Controls
                  AnimatedOpacity(
                    opacity: _showControls ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 300),
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.black87,
                            Colors.transparent,
                            Colors.transparent,
                            Colors.black87,
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          stops: [0.0, 0.2, 0.8, 1.0],
                        ),
                      ),
                      child: Stack(
                        children: [
                          // Top Bar (Back Button & Title)
                          Positioned(
                            top: 16,
                            left: 16,
                            right: 16,
                            child: Row(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    if (Navigator.of(context).canPop()) {
                                      Navigator.of(context).pop();
                                    }
                                  },
                                  icon: const Icon(
                                    Icons.arrow_back_ios_new_rounded,
                                  ),
                                  color: Colors.white,
                                ),
                                const SizedBox(width: 8),
                                const Expanded(
                                  child: Text(
                                    "Video Player",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'PoppinsMedium',
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Center Play/Pause button
                          Center(
                            child: isBuffering
                                ? const CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      // Rewind 10s
                                      IconButton(
                                        onPressed: () => _seekRelative(
                                          const Duration(seconds: -10),
                                        ),
                                        icon: const Icon(
                                          Icons.replay_10_rounded,
                                        ),
                                        color: Colors.white,
                                        iconSize: 40,
                                      ),
                                      const SizedBox(width: 40),
                                      // Play / Pause
                                      GestureDetector(
                                        onTap: () {
                                          if (_videoPlayerController
                                              .value
                                              .isPlaying) {
                                            _videoPlayerController.pause();
                                            _startHideTimer();
                                          } else {
                                            _videoPlayerController.play();
                                            _startHideTimer();
                                          }
                                          setState(() {});
                                        },
                                        child: AnimatedContainer(
                                          duration: const Duration(
                                            milliseconds: 200,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Theme.of(
                                              context,
                                            ).primaryColor.withValues(alpha:0.8),
                                            shape: BoxShape.circle,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Theme.of(
                                                  context,
                                                ).primaryColor.withValues(alpha:0.4),
                                                blurRadius: 16,
                                                spreadRadius: 4,
                                              ),
                                            ],
                                          ),
                                          padding: const EdgeInsets.all(20),
                                          child: Icon(
                                            _videoPlayerController
                                                    .value
                                                    .isPlaying
                                                ? Icons.pause_rounded
                                                : Icons.play_arrow_rounded,
                                            color: Colors.white,
                                            size: 48,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 40),
                                      // Forward 10s
                                      IconButton(
                                        onPressed: () => _seekRelative(
                                          const Duration(seconds: 10),
                                        ),
                                        icon: const Icon(
                                          Icons.forward_10_rounded,
                                        ),
                                        color: Colors.white,
                                        iconSize: 40,
                                      ),
                                    ],
                                  ),
                          ),

                          // Bottom Controls (Progress bar, Timer)
                          Positioned(
                            bottom: 24,
                            left: 24,
                            right: 24,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20.0,
                                vertical: 16.0,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha:0.6),
                                borderRadius: BorderRadius.circular(24),
                                border: Border.all(
                                  color: Colors.white24,
                                  width: 1,
                                ),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        _formatDuration(
                                          _videoPlayerController.value.position,
                                        ),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                          fontFamily: 'PoppinsMedium',
                                        ),
                                      ),
                                      Text(
                                        _formatDuration(
                                          _videoPlayerController.value.duration,
                                        ),
                                        style: const TextStyle(
                                          color: Colors.white70,
                                          fontSize: 13,
                                          fontFamily: 'PoppinsMedium',
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  SizedBox(
                                    height: 8,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(4),
                                      child: VideoProgressIndicator(
                                        _videoPlayerController,
                                        allowScrubbing: true,
                                        colors: VideoProgressColors(
                                          playedColor: Theme.of(
                                            context,
                                          ).primaryColor,
                                          bufferedColor: Colors.white24,
                                          backgroundColor: Colors.white12,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
