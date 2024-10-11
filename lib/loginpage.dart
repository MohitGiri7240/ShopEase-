
import 'package:flutter/material.dart';

import 'dart:async';


import 'package:flutter_application_1/AppApi.dart';
import 'package:flutter_application_1/Homepage.dart';

import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  Future<bool> checkIfIdExists() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    bool res = pref.getBool("isLogin") == null ? false : true;
    

    return res;
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({
    super.key,
  });

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
        const Duration(seconds: 2),
        () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => FutureBuilder(
                  future: LocalStorage().checkIfIdExists(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      bool idExists = snapshot.data ?? false;
                      return idExists ? Home() : LoginPage();
                    }
                  }),
            )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        //   color: kbgColor(),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6.5),
                child: Image.asset(
                  'assets/flutterLogo.jpeg',
                  height: 63,
                  width: 348,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isPasswordVisible = false;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>(); // Form key for validation

  @override
  Widget build(BuildContext context) {
    var screenHeight =
        MediaQuery.of(context).size.height; 

    return Scaffold(
      body: SingleChildScrollView(
        
        child: Stack(
          children: <Widget>[
            Container(
              decoration: const BoxDecoration(color: Colors.white),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: screenHeight * 0.05),
                    Image.asset(
                      'assets/login.webp',
                      height: screenHeight * 0.30,
                    ),
                    const SizedBox(height: 15),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: const Text(
                        "Login",
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    _buildTextField(
                      context,
                      emailController,
                      "Email ID",
                      false,
                      Icons.email_outlined,
                    ),
                    const SizedBox(height: 10),
                    _buildTextField(
                      context,
                      passwordController,
                      "Password",
                      true,
                      Icons.lock_outline,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {},
                          child: const Text(
                            "Forgot Password?",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          try {
                            await AppApi().LoginApi(
                              password: passwordController.text.trim(),
                              email: emailController.text.trim(),
                              context: context,
                            );
                          } catch (error) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Login failed: $error")),
                            );
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: const Color.fromARGB(255, 64, 34, 232),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        minimumSize: const Size(350, 50),
                      ),
                      child: const Text(
                        'Login',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Expanded(
                          child: Divider(
                            thickness: 1,
                            color: Color.fromARGB(255, 143, 140, 140),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            "OR",
                            style: TextStyle(fontSize: 16, color: Colors.black),
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            thickness: 1,
                            color: Color.fromARGB(255, 160, 155, 155),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton.icon(
                      onPressed: () async {
                        // Handle login with Google logic
                      },
                      icon: Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Image.network(
                          'http://pngimg.com/uploads/google/google_PNG19635.png',
                          fit: BoxFit.cover,
                          height: 40, // Set a height for the icon
                        ),
                      ),
                      label: const Text(
                        'Login with Google',
                        style: TextStyle(fontSize: 20, color: Colors.black),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(255, 209, 208, 213),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        minimumSize: const Size(350, 50),
                      ),
                    ),
                    const SizedBox(height: 60),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "New to Logistics?",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Color.fromARGB(255, 130, 127, 127),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            // Navigate to the registration page
                          },
                          child: const Text(
                            "Register",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(BuildContext context, TextEditingController controller,
      String hint, bool isPassword, IconData icon) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword ? !_isPasswordVisible : false,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 10.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        prefixIcon: Icon(
          icon,
          color: Colors.grey,
        ),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                  color: Colors.grey,
                ),
                onPressed: () {
                  setState(() {
                    _isPasswordVisible = !_isPasswordVisible;
                  });
                },
              )
            : null,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $hint';
        }
        if (hint == "Email ID" &&
            !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
          return 'Please enter a valid email';
        }
        return null;
      },
    );
  }
}