import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreTest {
  static Future<bool> testConnection() async {
    try {
      // Try to read from a test collection
      await FirebaseFirestore.instance.collection('test').limit(1).get();
      return true;
    } catch (e) {
      print('Firestore test failed: $e');
      return false;
    }
  }

  static Future<bool> testWrite() async {
    try {
      print('Testing Firestore write operation...');
      // Try to write to a test collection
      await FirebaseFirestore.instance.collection('test').doc('test-doc').set({
        'test': true,
        'timestamp': FieldValue.serverTimestamp(),
      });
      print('Firestore write test successful');
      return true;
    } catch (e) {
      print('Firestore write test failed with error: $e');
      print('Error type: ${e.runtimeType}');
      if (e.toString().contains('permission')) {
        print('This appears to be a permissions/security rules issue');
      }
      return false;
    }
  }
}
