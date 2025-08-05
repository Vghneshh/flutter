import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

enum EmotionType {
  happy,
  sad,
  angry,
  neutral,
  excited,
  anxious,
  grateful,
  frustrated,
}

class JournalEntry {
  final String id;
  final String userId;
  final String title;
  final String content;
  final EmotionType emotion;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<String> tags;
  final String? imageUrl;
  final int wordCount;

  JournalEntry({
    required this.id,
    required this.userId,
    required this.title,
    required this.content,
    required this.emotion,
    required this.createdAt,
    required this.updatedAt,
    this.tags = const [],
    this.imageUrl,
    required this.wordCount,
  });

  factory JournalEntry.fromMap(Map<String, dynamic> map) {
    return JournalEntry(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      title: map['title'] ?? '',
      content: map['content'] ?? '',
      emotion: EmotionType.values.firstWhere(
        (e) => e.toString() == 'EmotionType.${map['emotion']}',
        orElse: () => EmotionType.neutral,
      ),
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      updatedAt: (map['updatedAt'] as Timestamp).toDate(),
      tags: List<String>.from(map['tags'] ?? []),
      imageUrl: map['imageUrl'],
      wordCount: map['wordCount'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'content': content,
      'emotion': emotion.toString().split('.').last,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'tags': tags,
      'imageUrl': imageUrl,
      'wordCount': wordCount,
    };
  }

  JournalEntry copyWith({
    String? id,
    String? userId,
    String? title,
    String? content,
    EmotionType? emotion,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<String>? tags,
    String? imageUrl,
    int? wordCount,
  }) {
    return JournalEntry(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      content: content ?? this.content,
      emotion: emotion ?? this.emotion,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      tags: tags ?? this.tags,
      imageUrl: imageUrl ?? this.imageUrl,
      wordCount: wordCount ?? this.wordCount,
    );
  }

  String get emotionEmoji {
    switch (emotion) {
      case EmotionType.happy:
        return '😊';
      case EmotionType.sad:
        return '😢';
      case EmotionType.angry:
        return '😠';
      case EmotionType.neutral:
        return '😐';
      case EmotionType.excited:
        return '🤩';
      case EmotionType.anxious:
        return '😰';
      case EmotionType.grateful:
        return '🙏';
      case EmotionType.frustrated:
        return '😤';
    }
  }

  String get emotionName {
    switch (emotion) {
      case EmotionType.happy:
        return 'Happy';
      case EmotionType.sad:
        return 'Sad';
      case EmotionType.angry:
        return 'Angry';
      case EmotionType.neutral:
        return 'Neutral';
      case EmotionType.excited:
        return 'Excited';
      case EmotionType.anxious:
        return 'Anxious';
      case EmotionType.grateful:
        return 'Grateful';
      case EmotionType.frustrated:
        return 'Frustrated';
    }
  }

  Color get emotionColor {
    switch (emotion) {
      case EmotionType.happy:
        return Colors.yellow;
      case EmotionType.sad:
        return Colors.blue;
      case EmotionType.angry:
        return Colors.red;
      case EmotionType.neutral:
        return Colors.grey;
      case EmotionType.excited:
        return Colors.orange;
      case EmotionType.anxious:
        return Colors.purple;
      case EmotionType.grateful:
        return Colors.green;
      case EmotionType.frustrated:
        return Colors.deepOrange;
    }
  }
}
