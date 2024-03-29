import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../firebase/auth.dart';
import '../../firebase/profiles/client.dart';
import '../../main.dart';
import '../../widget_builder.dart';

class ClientSignInPage extends StatefulWidget {
  const ClientSignInPage({super.key});

  @override
  State<ClientSignInPage> createState() => _ClientSignInPageState();
}

class _ClientSignInPageState extends State<ClientSignInPage> {
  final GlobalKey<FormState> _formkey = GlobalKey();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formkey,
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Welcome,                         Create an account",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2),
            ),
            whiteSpace(20),
            createInput(
              context,
              300,
              "Email",
              controller: emailController,
              validator: (email) {
                if (email == null || email.isEmpty) {
                  return "Email is empty";
                }
                if (!emailValidationExpression.hasMatch(email)) {
                  return '\u26A0 Email is empty';
                }
                return null;
              },
            ),
            whiteSpace(10),
            SizedBox(
                width: 300,
                child: PasswordField(
                    hintText: "Password", controller: passwordController)),
            whiteSpace(15),
            actionButton(
              context,
              "Sign Up",
              width: 250,
              onPressed: signUp,
            ),
            whiteSpace(5),
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Login Instead"))
          ],
        )),
      ),
    );
  }

  Future signUp() async {
    if (!_formkey.currentState!.validate()) {
      return;
    }
    showToast("Sign in up... Please wait");
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("userType", "client");
    // create the data
    Map<String, dynamic> data = {
      "email": emailController.text.trim(),
    };
    await Client().setProfile(data, email: emailController.text);
    String result = await Auth().createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim());
    if (result == "Success") {
      showToast("Sign up success");
      Navigator.pop(context);
      replacePage(context, MyApp());
    } else {
      if (!mounted) {
        return;
      }
      showAlert(context, result);
    }
  }
}
