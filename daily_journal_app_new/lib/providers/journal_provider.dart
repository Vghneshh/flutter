import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import '../models/journal_entry.dart';

class JournalProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Uuid _uuid = const Uuid();

  List<JournalEntry> _entries = [];
  bool _isLoading = false;
  String? _error;

  List<JournalEntry> get entries => _entries;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Get entries for a specific user
  Future<void> loadEntries(String userId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final querySnapshot = await _firestore
          .collection('journal_entries')
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();

      _entries = querySnapshot.docs
          .map((doc) => JournalEntry.fromMap({'id': doc.id, ...doc.data()}))
          .toList();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to load entries: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  // Create a new journal entry
  Future<bool> createEntry({
    required String userId,
    required String title,
    required String content,
    required EmotionType emotion,
    List<String> tags = const [],
    String? imageUrl,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final entry = JournalEntry(
        id: _uuid.v4(),
        userId: userId,
        title: title,
        content: content,
        emotion: emotion,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        tags: tags,
        imageUrl: imageUrl,
        wordCount: content.split(' ').length,
      );

      await _firestore
          .collection('journal_entries')
          .doc(entry.id)
          .set(entry.toMap());

      _entries.insert(0, entry);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Failed to create entry: $e';
      _isLoading = false;
      notifyListeners();
    }
    return false;
  }

  // Update an existing journal entry
  Future<bool> updateEntry({
    required String entryId,
    String? title,
    String? content,
    EmotionType? emotion,
    List<String>? tags,
    String? imageUrl,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final entryIndex = _entries.indexWhere((entry) => entry.id == entryId);
      if (entryIndex == -1) {
        _error = 'Entry not found';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      final oldEntry = _entries[entryIndex];
      final updatedEntry = oldEntry.copyWith(
        title: title,
        content: content,
        emotion: emotion,
        tags: tags,
        imageUrl: imageUrl,
        updatedAt: DateTime.now(),
        wordCount: content?.split(' ').length ?? oldEntry.wordCount,
      );

      await _firestore
          .collection('journal_entries')
          .doc(entryId)
          .update(updatedEntry.toMap());

      _entries[entryIndex] = updatedEntry;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Failed to update entry: $e';
      _isLoading = false;
      notifyListeners();
    }
    return false;
  }

  // Delete a journal entry
  Future<bool> deleteEntry(String entryId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _firestore.collection('journal_entries').doc(entryId).delete();

      _entries.removeWhere((entry) => entry.id == entryId);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Failed to delete entry: $e';
      _isLoading = false;
      notifyListeners();
    }
    return false;
  }

  // Get entries by emotion
  List<JournalEntry> getEntriesByEmotion(EmotionType emotion) {
    return _entries.where((entry) => entry.emotion == emotion).toList();
  }

  // Get entries by date range
  List<JournalEntry> getEntriesByDateRange(DateTime start, DateTime end) {
    return _entries
        .where(
          (entry) =>
              entry.createdAt.isAfter(start) && entry.createdAt.isBefore(end),
        )
        .toList();
  }

  // Get emotion statistics
  Map<EmotionType, int> getEmotionStats() {
    final stats = <EmotionType, int>{};
    for (final emotion in EmotionType.values) {
      stats[emotion] = _entries
          .where((entry) => entry.emotion == emotion)
          .length;
    }
    return stats;
  }

  // Get entries by search query
  List<JournalEntry> searchEntries(String query) {
    if (query.isEmpty) return _entries;

    final lowercaseQuery = query.toLowerCase();
    return _entries.where((entry) {
      return entry.title.toLowerCase().contains(lowercaseQuery) ||
          entry.content.toLowerCase().contains(lowercaseQuery) ||
          entry.tags.any((tag) => tag.toLowerCase().contains(lowercaseQuery));
    }).toList();
  }

  // Get recent entries (last 7 days)
  List<JournalEntry> getRecentEntries() {
    final weekAgo = DateTime.now().subtract(const Duration(days: 7));
    return _entries.where((entry) => entry.createdAt.isAfter(weekAgo)).toList();
  }

  // Get monthly entries
  List<JournalEntry> getMonthlyEntries(int year, int month) {
    return _entries.where((entry) {
      return entry.createdAt.year == year && entry.createdAt.month == month;
    }).toList();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  void clearEntries() {
    _entries.clear();
    notifyListeners();
  }
}
