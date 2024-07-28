import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_media/resources/auth_methods.dart';
import 'package:social_media/responsive/responsive_layout_screen.dart';
import 'package:social_media/responsive/mobile_Screen_Layout.dart';
import 'package:social_media/responsive/web_Screen_Layout.dart';
import 'package:social_media/screen/login_screen.dart';
import 'package:social_media/utils/colors.dart';
import 'package:social_media/utils/utils.dart';
import 'package:social_media/widgets/text_field_input.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _emailAddController = TextEditingController();
  final TextEditingController _passAddController = TextEditingController();
  final TextEditingController _usernameAddController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  Uint8List? _image;
  bool _isloading = false;

  @override
  void dispose() {
    super.dispose();
    _emailAddController.dispose();
    _passAddController.dispose();
    _bioController.dispose();
    _usernameAddController.dispose();
  }

  // Select Image for Profile
  void selectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);
    setState(() {
      _image = im;
    });
  }

// SignUp user button Functionality
  void signUpuser() async {
    setState(() {
      _isloading = true;
    });
    String res = await AuthMethods().signUpUser(
        email: _emailAddController.text,
        username: _usernameAddController.text,
        password: _passAddController.text,
        bio: _bioController.text,
        file: _image!);
    // Loading Completed
    setState(() {
      _isloading = false;
    });
    // showSnackBar for Signup Message
    if (res != "Success") {
      if (_image == null) {
        showSnackBar("Please select an image", context);
      } else {
        showSnackBar(res, context);
      }
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const Responsive(
              webScreenLayout: WebScreenLayout(),
              mobileScreenLayout: MobileScreenLayout()),
        ),
      );
    }
  }

  void navigateToLogin() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                flex: 2,
                child: Container(),
              ),
              //Image Logo
              Image.asset(
                'assets/wmfcagency-logo.jpg',
                height: 64,
              ),
              const SizedBox(
                height: 64,
              ),
              Stack(
                children: [
                  _image != null
                      ? CircleAvatar(
                          radius: 64,
                          backgroundImage: MemoryImage(_image!),
                        )
                      : const CircleAvatar(
                          radius: 64,
                          backgroundImage: NetworkImage(
                              'https://images.pexels.com/photos/1207875/pexels-photo-1207875.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500'),
                        ),
                  Positioned(
                    bottom: -10,
                    left: 80,
                    child: IconButton(
                      onPressed: selectImage,
                      icon: const Icon(Icons.add_a_photo),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 26,
              ),
              //TextField Username
              TextFieldInput(
                textEditingController: _usernameAddController,
                hintText: 'Enter Your UserName',
                textInputType: TextInputType.text,
              ),
              const SizedBox(
                height: 26,
              ),
              //TextField BIo
              TextFieldInput(
                textEditingController: _bioController,
                hintText: 'Enter Your Bio',
                textInputType: TextInputType.text,
              ),
              const SizedBox(
                height: 26,
              ),
              //TextField for Email
              TextFieldInput(
                textEditingController: _emailAddController,
                hintText: 'Enter Your Email',
                textInputType: TextInputType.emailAddress,
              ),
              //TExtField for Password
              const SizedBox(
                height: 26,
              ),
              TextFieldInput(
                textEditingController: _passAddController,
                hintText: 'Enter Your Password',
                isPass: true,
                textInputType: TextInputType.emailAddress,
              ),
              const SizedBox(
                height: 26,
              ),
              //SignUp
              InkWell(
                onTap: signUpuser,
                child: _isloading
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : Container(
                        width: double.infinity,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: const ShapeDecoration(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                          ),
                          color: blueColor,
                        ),
                        child: const Text('SignUp'),
                      ),
              ),
              const SizedBox(
                height: 12,
              ),
              Flexible(
                flex: 2,
                child: Container(),
              ),
              //Transitions to signup screen
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: const Text("Already Have Account"),
                  ),
                  GestureDetector(
                    onTap: navigateToLogin,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: const Text(
                        " Login",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
