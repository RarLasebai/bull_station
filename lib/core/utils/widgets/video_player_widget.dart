import 'dart:io';
import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerWidget extends StatefulWidget {
  final dynamic videoFile;

  const VideoPlayerWidget({super.key, required this.videoFile});

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidget();
}

class _VideoPlayerWidget extends State<VideoPlayerWidget>
    with WidgetsBindingObserver {
  VideoPlayerController? _videoPlayerController;
  ChewieController? _chewieController;

  @override
  void initState() {
    super.initState();
    // الآن سيعمل هذا السطر بدون أخطاء
    WidgetsBinding.instance.addObserver(this);
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    if (widget.videoFile is File) {
      _videoPlayerController = VideoPlayerController.file(widget.videoFile);
    } else {
      _videoPlayerController = VideoPlayerController.networkUrl(
        Uri.parse(widget.videoFile),
      );
    }
  }

  @override
  void dispose() {
    // إزالة المراقب عند مسح الصفحة
    WidgetsBinding.instance.removeObserver(this);
    // إيقاف وتفريغ المشغلات لضمان عدم استمرار الصوت
    _videoPlayerController?.pause();
    _videoPlayerController?.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    // إذا خرج المستخدم للرئيسية أو أغلق الشاشة
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      _videoPlayerController?.pause(); // إيقاف الصوت فوراً
    }
  }

  // باقي دالة _initializePlayer و build كما هي في كودك...

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 250,
          width: double.infinity,
          color: Colors.black,
          child:
              _chewieController != null &&
                  _chewieController!.videoPlayerController.value.isInitialized
              ? Chewie(controller: _chewieController!)
              : const Center(child: CircularProgressIndicator()),
        ),
      ],
    );
  }
}
