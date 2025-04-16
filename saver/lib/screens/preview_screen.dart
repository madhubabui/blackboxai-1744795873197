import 'dart:io';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:video_player/video_player.dart';
import 'package:share_plus/share_plus.dart';
import '../models/status_model.dart';
import '../config/constants.dart';

class PreviewScreen extends StatefulWidget {
  final Status status;

  const PreviewScreen({
    super.key,
    required this.status,
  });

  @override
  State<PreviewScreen> createState() => _PreviewScreenState();
}

class _PreviewScreenState extends State<PreviewScreen> {
  VideoPlayerController? _videoController;
  bool _isPlaying = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    if (widget.status.isVideo) {
      _initializeVideo();
    }
  }

  Future<void> _initializeVideo() async {
    _videoController = VideoPlayerController.file(File(widget.status.filePath));
    try {
      await _videoController!.initialize();
      setState(() {});
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading video: $e')),
      );
    }
  }

  Future<void> _saveStatus() async {
    if (_isSaving) return;

    setState(() {
      _isSaving = true;
    });

    try {
      final success = await widget.status.save();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              success
                  ? AppConstants.successStatusSaved
                  : AppConstants.errorSavingStatus,
            ),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  Future<void> _shareStatus() async {
    try {
      await Share.shareFiles(
        [widget.status.filePath],
        text: 'Shared via ${AppConstants.appName}',
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error sharing status: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_rounded),
            onPressed: _shareStatus,
          ),
          IconButton(
            icon: Icon(
              widget.status.isSaved
                  ? Icons.download_done_rounded
                  : Icons.download_rounded,
            ),
            onPressed: _isSaving ? null : _saveStatus,
          ),
        ],
      ),
      body: Stack(
        children: [
          // Content
          Center(
            child: widget.status.isVideo
                ? _buildVideoPlayer()
                : _buildImageViewer(),
          ),

          // Loading Indicator
          if (_isSaving)
            const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            ),

          // Video Controls
          if (widget.status.isVideo && _videoController?.value.isInitialized == true)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: _buildVideoControls(),
            ),
        ],
      ),
    );
  }

  Widget _buildImageViewer() {
    return PhotoView(
      imageProvider: FileImage(File(widget.status.filePath)),
      minScale: PhotoViewComputedScale.contained,
      maxScale: PhotoViewComputedScale.covered * 2,
      backgroundDecoration: const BoxDecoration(color: Colors.black),
      errorBuilder: (context, error, stackTrace) {
        return const Center(
          child: Icon(
            Icons.error_outline,
            color: Colors.white,
            size: 48,
          ),
        );
      },
    );
  }

  Widget _buildVideoPlayer() {
    if (_videoController?.value.isInitialized != true) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.white),
      );
    }

    return AspectRatio(
      aspectRatio: _videoController!.value.aspectRatio,
      child: Stack(
        alignment: Alignment.center,
        children: [
          VideoPlayer(_videoController!),
          if (!_isPlaying)
            IconButton(
              icon: const Icon(
                Icons.play_circle_fill_rounded,
                size: 64,
                color: Colors.white,
              ),
              onPressed: () {
                _videoController!.play();
                setState(() {
                  _isPlaying = true;
                });
              },
            ),
        ],
      ),
    );
  }

  Widget _buildVideoControls() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            Colors.black.withOpacity(0.7),
          ],
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Progress Bar
          VideoProgressIndicator(
            _videoController!,
            allowScrubbing: true,
            colors: const VideoProgressColors(
              playedColor: Colors.white,
              bufferedColor: Colors.white24,
              backgroundColor: Colors.white12,
            ),
          ),

          const SizedBox(height: 8),

          // Controls Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: const Icon(Icons.replay_10_rounded),
                color: Colors.white,
                onPressed: () {
                  final newPosition = _videoController!.value.position -
                      const Duration(seconds: 10);
                  _videoController!.seekTo(newPosition);
                },
              ),
              IconButton(
                icon: Icon(
                  _isPlaying
                      ? Icons.pause_rounded
                      : Icons.play_arrow_rounded,
                ),
                color: Colors.white,
                onPressed: () {
                  setState(() {
                    _isPlaying = !_isPlaying;
                    _isPlaying
                        ? _videoController!.play()
                        : _videoController!.pause();
                  });
                },
              ),
              IconButton(
                icon: const Icon(Icons.forward_10_rounded),
                color: Colors.white,
                onPressed: () {
                  final newPosition = _videoController!.value.position +
                      const Duration(seconds: 10);
                  _videoController!.seekTo(newPosition);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }
}
