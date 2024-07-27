import 'package:cloud_firestore/cloud_firestore.dart';

class ContentService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<Map<String, dynamic>>> getContent() {
    print("Attempting to connect to Firestore");
    return _firestore.collection("content").snapshots().map((snapshot) {
      print("Received snapshot: ${snapshot.docs.length} documents");
      return snapshot.docs.map((doc) {
        final content = doc.data();
        print("Document data: $content");
        return content;
      }).toList();
    });
  }
}
