import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as path;
import '../models/status_model.dart';
import '../config/constants.dart';

enum StatusType { image, video, all }
enum SortBy { newest, oldest, size }

class StatusProvider with ChangeNotifier {
  List<Status> _statuses = [];
  bool _isLoading = false;
  bool _inSelectionMode = false;
  StatusType _currentType = StatusType.all;
  SortBy _sortBy = SortBy.newest;
  String _error = '';

  // Getters
  List<Status> get statuses => _filterAndSortStatuses();
  bool get isLoading => _isLoading;
  bool get inSelectionMode => _inSelectionMode;
  StatusType get currentType => _currentType;
  SortBy get sortBy => _sortBy;
  String get error => _error;
  
  List<Status> get selectedStatuses => 
    _statuses.where((status) => status.isSelected).toList();

  int get totalStatuses => _statuses.length;
  int get imageCount => _statuses.where((s) => !s.isVideo).length;
  int get videoCount => _statuses.where((s) => s.isVideo).length;
  int get selectedCount => selectedStatuses.length;

  // Methods for filtering and sorting
  List<Status> _filterAndSortStatuses() {
    List<Status> filtered = List.from(_statuses);
    
    // Apply type filter
    if (_currentType != StatusType.all) {
      filtered = filtered.where((s) => 
        _currentType == StatusType.video ? s.isVideo : !s.isVideo
      ).toList();
    }

    // Apply sorting
    switch (_sortBy) {
      case SortBy.newest:
        filtered.sort((a, b) => b.createdTime.compareTo(a.createdTime));
        break;
      case SortBy.oldest:
        filtered.sort((a, b) => a.createdTime.compareTo(b.createdTime));
        break;
      case SortBy.size:
        filtered.sort((a, b) async {
          final sizeA = await a.fileSize;
          final sizeB = await b.fileSize;
          return sizeB.compareTo(sizeA);
        });
        break;
    }

    return filtered;
  }

  // Status Operations
  Future<void> loadStatuses() async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      final directory = Directory(AppConstants.whatsappStatusPath);
      
      if (!await directory.exists()) {
        _error = 'WhatsApp status folder not found';
        _isLoading = false;
        notifyListeners();
        return;
      }

      final List<FileSystemEntity> files = await directory.list().toList();
      _statuses = [];

      for (var file in files) {
        if (file is File) {
          final filePath = file.path;
          if (Status.isImageFile(filePath) || Status.isVideoFile(filePath)) {
            final status = Status(
              filePath: filePath,
              createdTime: (await file.stat()).modified,
              isVideo: Status.isVideoFile(filePath),
            );
            _statuses.add(status);
          }
        }
      }

      _error = '';
    } catch (e) {
      _error = 'Error loading statuses: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> saveStatus(Status status) async {
    try {
      final success = await status.save();
      if (success) {
        notifyListeners();
      }
      return success;
    } catch (e) {
      _error = 'Error saving status: $e';
      notifyListeners();
      return false;
    }
  }

  Future<void> saveSelectedStatuses() async {
    for (var status in selectedStatuses) {
      await saveStatus(status);
    }
    clearSelection();
  }

  Future<void> deleteStatus(Status status) async {
    try {
      final success = await status.delete();
      if (success) {
        _statuses.remove(status);
        notifyListeners();
      }
    } catch (e) {
      _error = 'Error deleting status: $e';
      notifyListeners();
    }
  }

  Future<void> deleteSelectedStatuses() async {
    for (var status in selectedStatuses) {
      await deleteStatus(status);
    }
    clearSelection();
  }

  // Selection Mode Operations
  void toggleSelectionMode() {
    _inSelectionMode = !_inSelectionMode;
    if (!_inSelectionMode) {
      clearSelection();
    }
    notifyListeners();
  }

  void toggleStatusSelection(Status status) {
    final index = _statuses.indexOf(status);
    if (index != -1) {
      _statuses[index].isSelected = !_statuses[index].isSelected;
      notifyListeners();
    }
  }

  void selectAll() {
    for (var status in _statuses) {
      status.isSelected = true;
    }
    notifyListeners();
  }

  void clearSelection() {
    for (var status in _statuses) {
      status.isSelected = false;
    }
    _inSelectionMode = false;
    notifyListeners();
  }

  // Filter and Sort Operations
  void setStatusType(StatusType type) {
    _currentType = type;
    notifyListeners();
  }

  void setSortBy(SortBy sort) {
    _sortBy = sort;
    notifyListeners();
  }

  void clearError() {
    _error = '';
    notifyListeners();
  }
}
