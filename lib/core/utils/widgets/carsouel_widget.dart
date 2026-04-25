import 'dart:io';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class CarsouelWidget extends StatelessWidget {
  final List<String> truckImages;
  final String? truckVideo;

  const CarsouelWidget({
    super.key,
    required this.truckImages,
    this.truckVideo,
  });

  @override
  Widget build(BuildContext context) {
    // دمج الصور والفيديو في قائمة واحدة
    final List<String> mediaPaths = [...truckImages];
    if (truckVideo != null) {
      mediaPaths.add(truckVideo!);
    }

    return CarouselSlider.builder(
      itemCount: mediaPaths.length,
      itemBuilder: (context, index, realIndex) {
        final path = mediaPaths[index];
        final isRemote = path.startsWith('http');
        final isVideo = path.endsWith('.mp4') || path.endsWith('.mov');

        if (isVideo) {
          // استخدام الويدجت الجديدة التي تدير الإغلاق تلقائياً
          return CarouselVideoItem(path: path, isRemote: isRemote);
        } else {
          return isRemote 
              ? Image.network(path, fit: BoxFit.fill) 
              : Image.file(File(path), fit: BoxFit.fill);
        }
      },
      options: CarouselOptions(
        height: 200,
        autoPlay: false,
        enlargeCenterPage: true,
        viewportFraction: 0.8,
      ),
    );
  }
}

/// --- هذه هي الويدجت السحرية التي ستحل مشكلة الصوت ---
class CarouselVideoItem extends StatefulWidget {
  final String path;
  final bool isRemote;

  const CarouselVideoItem({super.key, required this.path, required this.isRemote});

  @override
  State<CarouselVideoItem> createState() => _CarouselVideoItemState();
}

class _CarouselVideoItemState extends State<CarouselVideoItem> {
  VideoPlayerController? _videoPlayerController;
  ChewieController? _chewieController;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    // تجهيز المشغل بناءً على نوع الرابط (إنترنت أو ملف محلي)
    _videoPlayerController = widget.isRemote
        ? VideoPlayerController.networkUrl(Uri.parse(widget.path))
        : VideoPlayerController.file(File(widget.path));

    try {
      await _videoPlayerController!.initialize();
      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController!,
        autoPlay: false, // لا يبدأ العمل تلقائياً حتى لا يزعج المستخدم
        looping: false,
        aspectRatio: _videoPlayerController!.value.aspectRatio,
      );
      if (mounted) setState(() {});
    } catch (e) {
      debugPrint("Error loading video: $e");
    }
  }

  @override
  void dispose() {
    // أهم جزء: إيقاف الصوت فوراً وتدمير المشغل عند الخروج من الصفحة
    _videoPlayerController?.pause();
    _videoPlayerController?.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_chewieController != null && 
        _chewieController!.videoPlayerController.value.isInitialized) {
      return Chewie(controller: _chewieController!);
    }
    return const Center(
      child: CircularProgressIndicator(color: Colors.amber),
    );
  }
}