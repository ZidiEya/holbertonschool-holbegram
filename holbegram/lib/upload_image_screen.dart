import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AddPicture extends StatefulWidget {
  final String email;
  final String password;
  final String username;

  const AddPicture({
    required this.email,
    required this.password,
    required this.username,
  });

  @override
  _AddPictureState createState() => _AddPictureState();
}

class _AddPictureState extends State<AddPicture> {
  Uint8List? _image;
  final picker = ImagePicker();

  Future<void> selectImageFromGallery() async {
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      final Uint8List imageData = await image.readAsBytes();
      setState(() {
        _image = Uint8List.fromList(imageData);
      });
    }
  }

  Future<void> selectImageFromCamera() async {
    final XFile? photo = await picker.pickImage(source: ImageSource.camera);
    if (photo != null) {
      final Uint8List cameraData = await photo.readAsBytes();
      setState(() {
        _image = Uint8List.fromList(cameraData);
      });
    }
  }

 
  void signUpUser() {
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Sign up successful!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 28),
            const Text(
              'Holbegram',
              style: TextStyle(
                fontFamily: 'Billabong',
                fontSize: 50,
              ),
            ),
            Image.asset(
              'assets/images/logo.webp',
              width: 80,
              height: 60,
            ),
            const SizedBox(height: 28),
            Padding(
              padding: const EdgeInsets.only(left: 40, right: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hello, ${widget.username} Welcome to\nHolbegram.',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Choose an image from your gallery or take a new one.',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),
            _image != null
                ? Image.memory(
                    _image!,
                    width: 200,
                    fit: BoxFit.cover,
                  )
                : Image.asset(
                    'assets/images/Sample_User_Icon.png',
                    width: 280,
                    fit: BoxFit.cover,
                  ),
            Padding(
              padding: const EdgeInsets.only(right: 80, left: 80),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.photo_library),
                    color: const Color.fromARGB(218, 226, 37, 24),
                    iconSize: 50,
                    onPressed: () => selectImageFromGallery(),
                  ),
                  IconButton(
                    icon: const Icon(Icons.camera_alt),
                    color: const Color.fromARGB(218, 226, 37, 24),
                    iconSize: 50,
                    onPressed: () => selectImageFromCamera(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 38),
            SizedBox(
              height: 46,
              width: 120,
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                      const Color.fromARGB(218, 226, 37, 24)),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                  ),
                ),
                onPressed: () async {
                  // Call signUpUser method
                  signUpUser();
                  // Upload image to Firebase Storage
                  if (_image != null) {
                    String email = widget.email;
                    String username = widget.username;
                    String password = widget.password;
                    Uint8List file = _image!;
                    StorageMethods storageMethods = StorageMethods();
                    String downloadUrl = await storageMethods.uploadImageToStorage(
                      false,
                      'profile_images', 
                      file,
                    );
                    
                  }
                },
                child: const Text(
                  'Next',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class StorageMethods {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> uploadImageToStorage(
    bool isPost,
    String childName,
    Uint8List file,
  ) async {
    Reference ref = _storage.ref().child(childName).child(_auth.currentUser!.uid);
    if (isPost) {
      String id = const Uuid().v1();
      ref = ref.child(id);
    }
    UploadTask uploadTask = ref.putData(file);
    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }
}
