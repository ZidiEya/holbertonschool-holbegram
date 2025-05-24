import 'package:flutter/material.dart';
import '../widgets/text_field.dart';
import 'login_screen.dart';
import 'upload_image_screen.dart';

class SignUp extends StatefulWidget {
  final TextEditingController emailController;
  final TextEditingController usernameController;
  final TextEditingController passwordController;
  final TextEditingController passwordConfirmController;
  final bool passwordVisible;

  const SignUp({
    Key? key,
    required this.emailController,
    required this.usernameController,
    required this.passwordController,
    required this.passwordConfirmController,
    this.passwordVisible = true,
  }) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  late bool _passwordVisible;

  @override
  void initState() {
    super.initState();
    _passwordVisible = widget.passwordVisible;
  }

  @override
  Widget build(BuildContext context) {
    final passwordVisibleIcons = IconButton(
      alignment: Alignment.bottomLeft,
      color: const Color.fromARGB(218, 226, 37, 24),
      onPressed: () => setState(() {
        _passwordVisible = !_passwordVisible;
      }),
      icon: Icon(_passwordVisible ? Icons.visibility : Icons.visibility_off),
    );

    return Scaffold(
      body: Column(
        children: <Widget>[
    
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: () {
         
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => AddPicture(
                      email: widget.emailController.text,
                      username: widget.usernameController.text,
                      password: widget.passwordController.text,
                    ),
                  ),
                );
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                  const Color.fromARGB(218, 226, 37, 24),
                ),
              ),
              child: const Text(
                'Sign up',
                style: TextStyle(
                  color: Color.fromARGB(255, 255, 255, 255),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          
        ],
      ),
    );
  }
}
