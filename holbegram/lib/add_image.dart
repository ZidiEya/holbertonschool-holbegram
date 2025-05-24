import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';
import '../auth/methods/post_storage.dart';
import '../../methods/auth_methods.dart';
import '../../models/user.dart';
import '../home.dart';


class AddImage extends StatefulWidget {
  const AddImage({super.key});
  
  @override
  AddImageState createState() => AddImageState();
}

class AddImageState extends State<AddImage> {
  Uint8List? _image;
  final picker = ImagePicker();
  final _postStorage = PostStorage();
  final authMethod = AuthMethode();
  TextEditingController captionController = TextEditingController();

  @override
  void dispose() {
    captionController.dispose();
    super.dispose();
  }


  Future<void> selectImageFromGallery() async {
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      final Uint8List imageData = await image.readAsBytes();
      setState(() {
        _image = imageData;
      });
    }
  }

  Future<void> selectImageFromCamera() async {
    final XFile? photo = await picker.pickImage(source: ImageSource.camera);
    if (photo != null) {
      final Uint8List cameraData = await photo.readAsBytes();
      setState(() {
        _image = cameraData;
      });
    }
  }

  void _postImage() async {
    debugPrint('Caption: ${captionController.text}');
    debugPrint('Image selected: ${_image != null}');
    if (_image == null || captionController.text.isEmpty) {
      debugPrint('something is missing');
      return;
    }
    try {
      Users userData = await authMethod.getUserDetails();
      String caption = captionController.text; 
      String uid = userData.uid;
      String username = userData.username;
      String profImage = userData.photoUrl;

      debugPrint('uid: $uid');
      debugPrint('username: $username');
      debugPrint('profImage: $profImage');

     
      String result = await _postStorage.uploadPost(caption, uid, username, profImage, _image!);
      
      if (!mounted) return;
      if (result == 'Ok') {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Home()),
        );
      } else {
        debugPrint(result);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
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
              GestureDetector(
                onTap: () => selectImageFromGallery(),
                child: Container(
                  width: 258,
                  height: 135.21,
                  decoration: BoxDecoration(
                    color: _image != null ? Colors.transparent : Colors.red.withOpacity(0.1),
                    border: _image != null ? null : Border.all(color: Colors.red, width: 3),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  alignment: Alignment.center,
                  child: _image != null
                      ? Image.memory(_image!, fit: BoxFit.cover)
                      : Padding(
                          padding: const EdgeInsets.all(5),
                          child: Image.asset(
                            'assets/images/add-2935429_960_720.webp',
                            fit: BoxFit.contain, 
                          ),
                        ),
                ),
              ),
          const SizedBox(height: 20),
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
          const SizedBox(height: 20),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: TextField(
                controller: captionController,
                decoration: const InputDecoration(
                  hintText: 'Type caption',
                ),
              ),
            ),
          const SizedBox(height: 38),
            SizedBox(
              height: 46,
              width: 120,
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(const Color.fromARGB(218, 226, 37, 24)),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                  ),
                ),
                onPressed: () async => _postImage(),
                child: const Text('Post',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                  ),
                ),
              ),
            ),
        ],
      ),
      )
    );
  }
}
