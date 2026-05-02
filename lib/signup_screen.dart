import 'package:flutter/material.dart';
import 'package:practise/home_screen.dart';
import 'package:practise/login_screen.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});
  @override
  State<SignupScreen> createState() => _SignupScreen();
}

class _SignupScreen extends State<SignupScreen> {
  String email="", password="", name="";
  TextEditingController emailController=new TextEditingController();
  TextEditingController passwordController=new TextEditingController();
  TextEditingController nameController=new TextEditingController();
  final _formkey=GlobalKey<FormState>();

  
  Future<void> signup() async {
  final url = Uri.parse(
    "https://poodle-flexible-carefully.ngrok-free.app/accounts/register/"
  );

  try {
    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "email": emailController.text.trim(),
        "password": passwordController.text,
        "first_name": nameController.text,
        "last_name": "User" // backend requires it
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      print("📥 Status Code: ${response.statusCode}");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } else {
      final error = jsonDecode(response.body);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.toString())),
      );
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Something went wrong")),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Image.asset(""),
            Padding(
              padding: const EdgeInsets.only(left: 30.0, right: 30.0),
              child: Form(
                key: _formkey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Welcome"),
                    Text("Create Your Account"),
                    Text("Full Name"),
                    TextFormField(
                      controller: nameController,
                      validator: (value)
                      {
                        if(value==null || value.isEmpty)
                        {
                          return "Please enter your name";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: "Enter Name",
                      ),
                    ),
                    SizedBox(height: 20),
                    Text("Email"),
                    TextFormField(
                      controller: emailController,
                      validator: (value)
                      {
                        if(value==null || value.isEmpty)
                        {
                          return "Please enter your email";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: "Enter Email",
                      ),
                    ),
                    SizedBox(height: 20),
                    Text("Password"),
                    TextFormField(
                      controller: passwordController,
                      obscureText: true,
                      validator: (value)
                      {
                        if(value==null || value.isEmpty)
                        {
                          return "Please enter password";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: "Enter Password",
                        suffixIcon: Icon(Icons.password),
                      ),
                    ),
                    SizedBox(height: 20),
                    Text("Confirm Password"),
                    TextFormField(
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: "Rewrite Password",
                        suffixIcon: Icon(Icons.password),
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                          ),
                          child: Text(
                            'SIGN UP',
                            style: TextStyle(color: Colors.black),
                          ),
                          onPressed: () {
                            if(_formkey.currentState!.validate())
                            {
                              setState(() {
                                email=emailController.text;
                                name=nameController.text;
                                password=passwordController.text;
                              });
                            }
                            signup();
                          },
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [Text("Already Sign Up?")],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginScreen()));
                          },
                          child: Text("Login", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold))
                          )
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
}