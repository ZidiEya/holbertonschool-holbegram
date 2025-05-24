import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import './user_storage.dart';

class PostStorage {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final StorageMethods _storageMethods = StorageMethods();

  Future<String> uploadPost(
    String caption,
    String uid,
    String username,
    String profImage,
    Uint8List image,
  ) async {
    try {
      // Upload image to storage
      String imageUrl = await _storageMethods.uploadImageToStorage(true, 'posts', image);

      // Save post data to Firestore
      await _firestore.collection('posts').add({
        'caption': caption,
        'uid': uid,
        'username': username,
        'profImage': profImage,
        'imageUrl': imageUrl,
        'timestamp': DateTime.now(),
      });

      return 'Ok';
    } catch (error) {
      return error.toString();
    }
  }

  Future<void> deletePost(String postId) async {
    try {
      // Delete post from Firestore
      await _firestore.collection('posts').doc(postId).delete();
    } catch (error) {
      throw error;
    }
  }
}
