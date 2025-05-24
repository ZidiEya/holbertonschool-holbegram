import 'package:cloud_firestore/cloud_firestore.dart';

class Users {
  String uid;
  String email;
  String username;
  String bio;
  String photoUrl;
  List<dynamic> followers;
  List<dynamic> following;
  List<dynamic> posts;
  List<dynamic> saved;
  String searchKey;

  Users({
    required this.uid,
    required this.email,
    required this.username,
    required this.bio,
    required this.photoUrl,
    required this.followers,
    required this.following,
    required this.posts,
    required this.saved,
    required this.searchKey,
  });

  static Users fromSnap(DocumentSnapshot<Map<String, dynamic>> snap) {
    var snapshot = snap.data(); 
    if (snapshot == null) {
      throw Exception('Document does not exist');
    }
    var userData = snapshot; 

    return Users(
      uid: userData['uid'],
      email: userData['email'],
      username: userData['username'],
      bio: userData['bio'],
      photoUrl: userData['photoUrl'],
      followers: List<dynamic>.from(userData['followers'] ?? []),
      following: List<dynamic>.from(userData['following'] ?? []),
      posts: List<dynamic>.from(userData['posts'] ?? []),
      saved: List<dynamic>.from(userData['saved'] ?? []),
      searchKey: userData['searchKey'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'username': username,
      'bio': bio,
      'photoUrl': photoUrl,
      'followers': followers,
      'following': following,
      'posts': posts,
      'saved': saved,
      'searchKey': searchKey,
    };
  }
}
