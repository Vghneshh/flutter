import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:daily_journal_app/models/user_model.dart';
import 'package:daily_journal_app/models/journal_entry.dart';
import 'package:daily_journal_app/providers/auth_provider.dart';
import 'package:daily_journal_app/providers/journal_provider.dart';
import 'package:daily_journal_app/screens/profile_screen.dart';

// 👇 MOCK PROVIDERS
class MockAuthProvider extends ChangeNotifier implements AuthProvider {
  UserModel? _mockUser;

  @override
  UserModel? get user => _mockUser;

  void setUser(UserModel user) {
    _mockUser = user;
    notifyListeners();
  }

  @override
  Future<void> signOut() async {}

  @override
  bool get isLoading => false;

  @override
  String? get error => null;

  @override
  bool get isAuthenticated => _mockUser != null;

  @override
  Future<bool> signUp({
    required String email,
    required String password,
    required String name,
  }) async => true;

  @override
  Future<bool> signIn({
    required String email,
    required String password,
  }) async => true;

  @override
  Future<void> updateProfile({String? name, String? profileImageUrl}) async {}

  @override
  void clearError() {}

  // ✅ MISSING MEMBER ADDED
  @override
  Stream<UserModel?> get userStream => Stream.value(_mockUser);
}

class MockJournalProvider extends ChangeNotifier implements JournalProvider {
  final List<JournalEntry> _entries = [];

  @override
  List<JournalEntry> get entries => _entries;

  @override
  bool get isLoading => false;

  @override
  String? get error => null;

  @override
  List<JournalEntry> getRecentEntries() => _entries;

  @override
  void clearEntries() {}

  @override
  void clearError() {}

  @override
  Future<void> loadEntries(String userId) async {}

  @override
  Future<bool> createEntry({
    required String userId,
    required String title,
    required String content,
    required EmotionType emotion,
    List<String> tags = const [],
    String? imageUrl,
  }) async => true;

  @override
  Future<bool> updateEntry({
    required String entryId,
    String? title,
    String? content,
    EmotionType? emotion,
    List<String>? tags,
    String? imageUrl,
  }) async => true;

  @override
  Future<bool> deleteEntry(String entryId) async => true;

  @override
  List<JournalEntry> getEntriesByEmotion(EmotionType emotion) => [];

  @override
  List<JournalEntry> getEntriesByDateRange(DateTime start, DateTime end) => [];

  @override
  Map<EmotionType, int> getEmotionStats() => {};

  @override
  List<JournalEntry> searchEntries(String query) => [];

  @override
  List<JournalEntry> getMonthlyEntries(int year, int month) => [];
}

void main() {
  testWidgets('displays user name and email', (WidgetTester tester) async {
    final mockUser = UserModel(
      id: '123',
      name: 'Test User',
      email: 'test@example.com',
      createdAt: DateTime(2023, 1, 1),
      lastLoginAt: DateTime(2023, 1, 1),
      profileImageUrl: null,
    );

    final mockAuthProvider = MockAuthProvider();
    final mockJournalProvider = MockJournalProvider();
    mockAuthProvider.setUser(mockUser);

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<AuthProvider>.value(value: mockAuthProvider),
          ChangeNotifierProvider<JournalProvider>.value(
            value: mockJournalProvider,
          ),
        ],
        child: const MaterialApp(home: ProfileScreen()),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Test User'), findsOneWidget);
    expect(find.text('test@example.com'), findsOneWidget);
    expect(find.textContaining('Member since Jan 2023'), findsOneWidget);
  });
}
