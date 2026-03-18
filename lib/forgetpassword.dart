import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {

  final emailController = TextEditingController();
  final otpController = TextEditingController();
  final passwordController = TextEditingController();

  bool otpSent = false;

  // 🔥 SEND OTP
  Future<void> sendOTP() async {

    SharedPreferences sp = await SharedPreferences.getInstance();
    String url = sp.getString('url') ?? '';

    final response = await http.post(
        Uri.parse('$url/send_forgot_otp/'),
        body: {
          'email': emailController.text
        }
    );

    var data = jsonDecode(response.body);

    if(data['status'] == 'ok'){
      setState(() {
        otpSent = true;
      });

      Fluttertoast.showToast(msg: "OTP sent to email");
    }
    else{
      Fluttertoast.showToast(msg: data['message']);
    }

  }


  // 🔥 RESET PASSWORD
  Future<void> resetPassword() async {

    SharedPreferences sp = await SharedPreferences.getInstance();
    String url = sp.getString('url') ?? '';

    final response = await http.post(
        Uri.parse('$url/reset_password/'),
        body: {
          'email': emailController.text,
          'otp': otpController.text,
          'password': passwordController.text
        }
    );

    var data = jsonDecode(response.body);

    if(data['status']=='ok'){
      Fluttertoast.showToast(msg: "Password Reset Successful");

      Navigator.pop(context);
    }
    else{
      Fluttertoast.showToast(msg: "Invalid OTP");
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: const Text("Forgot Password"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(

          children: [

            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder()
              ),
            ),

            const SizedBox(height:20),

            if(!otpSent)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: sendOTP,
                  child: const Text("Send OTP"),
                ),
              ),

            if(otpSent)...[

              TextField(
                controller: otpController,
                decoration: const InputDecoration(
                    labelText: "Enter OTP",
                    border: OutlineInputBorder()
                ),
              ),

              const SizedBox(height:20),

              TextField(
                controller: passwordController,
                decoration: const InputDecoration(
                    labelText: "New Password",
                    border: OutlineInputBorder()
                ),
              ),

              const SizedBox(height:20),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: resetPassword,
                  child: const Text("Reset Password"),
                ),
              ),

            ]

          ],
        ),
      ),
    );
  }
}