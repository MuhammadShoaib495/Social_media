import 'package:flutter/material.dart';
import 'package:social_media/resources/auth_methods.dart';
import 'package:social_media/screen/signup_screen.dart';
import 'package:social_media/utils/colors.dart';
import 'package:social_media/utils/global_variables.dart';
import 'package:social_media/utils/utils.dart';
import 'package:social_media/widgets/text_field_input.dart';

class LoginScreen extends StatefulWidget{
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final TextEditingController _emailAddController = TextEditingController();
  final TextEditingController _passAddController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _emailAddController.dispose();
    _passAddController.dispose();
  }

  void loginUser() async{
    setState(() {
      _isLoading = true;
    });
    String res = await AuthMethods().loginUser(email: _emailAddController.text, password: _passAddController.text);
    if(res == "Success"){
    showSnackBar(res, context);
    } else {
      setState(() {
        _isLoading =false;
      });
    showSnackBar(res, context);
    }
  }
  void navigateToSignUp(){
    Navigator.of(context).push(MaterialPageRoute(builder: (context) =>  SignupScreen(),),);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: MediaQuery.of(context).size.width > webScreenSize ? EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/3) :
          const EdgeInsets.symmetric(horizontal: 32),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Flexible(flex: 2,child: Container(),),
              //Image Logo
              Image.asset('assets/wmfcagency-logo.jpg', height: 64,),
             const SizedBox(
                height: 64,
              ),
              //TextField for Email
              TextFieldInput(
                  textEditingController: _emailAddController,
                  hintText: 'Enter Your Email',
                  textInputType: TextInputType.emailAddress,),
              //TExtField for Password
              const SizedBox(
                height: 26,
              ),
              TextFieldInput(
                textEditingController: _passAddController,
                hintText: 'Enter Your Password',
                isPass: true,
                textInputType: TextInputType.text,
              ),
              const SizedBox(
                height: 26,
              ),
              //Login Button
              InkWell(
                onTap: loginUser,
                child: _isLoading ? const Center(
                  child: CircularProgressIndicator(),
                ) : Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: const ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                      ),
                    color: blueColor,
                  ),
                  child: const Text('Login'),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              Flexible(flex: 2,child: Container(),),
              //Transitions to signup screen
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: const Text("Dont have an account?"),
                  ),
                  GestureDetector(
                    onTap: navigateToSignUp,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: const Text(" SignUp", style: TextStyle(fontWeight: FontWeight.bold,),),
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