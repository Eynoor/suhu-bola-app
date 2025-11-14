import 'package:flutter/foundation.dart';

/// Helper class untuk mengelola pagination
class PaginationHelper<T> extends ChangeNotifier {
  final List<T> _fullList;
  final int itemsPerPage;

  late List<T> _currentPage;
  int _currentPageIndex = 0;

  PaginationHelper({
    required List<T> fullList,
    this.itemsPerPage = 10,
  }) : _fullList = fullList {
    _updateCurrentPage();
  }

  /// Get current page items
  List<T> get currentPageItems => _currentPage;

  /// Get current page index (0-indexed)
  int get currentPageIndex => _currentPageIndex;

  /// Get total pages
  int get totalPages => (_fullList.isEmpty
      ? 1
      : (_fullList.length + itemsPerPage - 1) ~/ itemsPerPage);

  /// Check if has next page
  bool get hasNextPage => _currentPageIndex < totalPages - 1;

  /// Check if has previous page
  bool get hasPreviousPage => _currentPageIndex > 0;

  /// Go to next page
  void nextPage() {
    if (hasNextPage) {
      _currentPageIndex++;
      _updateCurrentPage();
      notifyListeners();
    }
  }

  /// Go to previous page
  void previousPage() {
    if (hasPreviousPage) {
      _currentPageIndex--;
      _updateCurrentPage();
      notifyListeners();
    }
  }

  /// Go to specific page
  void goToPage(int pageIndex) {
    if (pageIndex >= 0 && pageIndex < totalPages) {
      _currentPageIndex = pageIndex;
      _updateCurrentPage();
      notifyListeners();
    }
  }

  /// Reset to first page
  void reset() {
    _currentPageIndex = 0;
    _updateCurrentPage();
    notifyListeners();
  }

  /// Update full list and reset pagination
  void updateFullList(List<T> newList) {
    _fullList.clear();
    _fullList.addAll(newList);
    _currentPageIndex = 0;
    _updateCurrentPage();
    notifyListeners();
  }

  void _updateCurrentPage() {
    final startIndex = _currentPageIndex * itemsPerPage;
    final endIndex =
        ((startIndex + itemsPerPage).clamp(0, _fullList.length)) as int;
    _currentPage = _fullList.sublist(startIndex, endIndex);
  }
}
