import 'dart:io';
import 'package:path/path.dart' as path;
import '../config/constants.dart';

class Status {
  final String filePath;
  final DateTime createdTime;
  final bool isVideo;
  bool isSelected;
  bool isSaved;

  Status({
    required this.filePath,
    required this.createdTime,
    required this.isVideo,
    this.isSelected = false,
    this.isSaved = false,
  });

  File get file => File(filePath);
  String get fileName => path.basename(filePath);
  String get extension => path.extension(filePath).toLowerCase();
  
  bool get exists => file.existsSync();
  
  Future<int> get fileSize async => (await file.stat()).size;

  String get formattedSize async {
    final size = await fileSize;
    if (size < 1024) return '$size B';
    if (size < 1024 * 1024) return '${(size / 1024).toStringAsFixed(1)} KB';
    return '${(size / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  String get formattedDate {
    return '${createdTime.day}/${createdTime.month}/${createdTime.year} ${createdTime.hour}:${createdTime.minute.toString().padLeft(2, '0')}';
  }
  
  static bool isVideoFile(String filePath) {
    final ext = path.extension(filePath).toLowerCase();
    return AppConstants.supportedVideoExtensions.contains(ext);
  }

  static bool isImageFile(String filePath) {
    final ext = path.extension(filePath).toLowerCase();
    return AppConstants.supportedImageExtensions.contains(ext);
  }

  Future<String> getSavedPath() async {
    final fileName = path.basename(filePath);
    return path.join(AppConstants.savedStatusPath, fileName);
  }

  Future<bool> save() async {
    try {
      final savedPath = await getSavedPath();
      final savedFile = File(savedPath);
      
      if (await savedFile.exists()) {
        return true; // Already saved
      }

      await file.copy(savedPath);
      isSaved = true;
      return true;
    } catch (e) {
      print('Error saving status: $e');
      return false;
    }
  }

  Future<bool> delete() async {
    try {
      if (await exists) {
        await file.delete();
        return true;
      }
      return false;
    } catch (e) {
      print('Error deleting status: $e');
      return false;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'filePath': filePath,
      'createdTime': createdTime.toIso8601String(),
      'isVideo': isVideo,
      'isSaved': isSaved,
    };
  }

  factory Status.fromJson(Map<String, dynamic> json) {
    return Status(
      filePath: json['filePath'],
      createdTime: DateTime.parse(json['createdTime']),
      isVideo: json['isVideo'],
      isSaved: json['isSaved'] ?? false,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Status &&
          runtimeType == other.runtimeType &&
          filePath == other.filePath;

  @override
  int get hashCode => filePath.hashCode;
}
