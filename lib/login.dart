// // import 'package:flutter/material.dart';
// // import 'package:fluttertoast/fluttertoast.dart';
// // import 'package:http/http.dart' as http;
// // import 'dart:convert';
// // import 'package:shared_preferences/shared_preferences.dart';
// // import 'package:geolocator/geolocator.dart';
// // import 'package:permission_handler/permission_handler.dart';
// //
// // import 'usersignup.dart';
// // import 'workerssignup.dart';
// // import 'userhome.dart';
// // import 'workershome.dart';
// //
// // class MyLoginPage extends StatefulWidget {
// //   const MyLoginPage({super.key, required this.title});
// //   final String title;
// //
// //   @override
// //   State<MyLoginPage> createState() => _MyLoginPageState();
// // }
// //
// // class _MyLoginPageState extends State<MyLoginPage> {
// //   final _formKey = GlobalKey<FormState>();
// //   bool _loading = false;
// //
// //   final TextEditingController usernameController = TextEditingController();
// //   final TextEditingController passwordController = TextEditingController();
// //
// //   Future<void> login() async {
// //     if (!_formKey.currentState!.validate()) return;
// //
// //     setState(() => _loading = true);
// //
// //     try {
// //       SharedPreferences sp = await SharedPreferences.getInstance();
// //       String url = sp.getString('url') ?? '';
// //
// //       if (url.isEmpty) {
// //         Fluttertoast.showToast(msg: 'Server URL not set');
// //         setState(() => _loading = false);
// //         return;
// //       }
// //
// //       final response = await http.post(
// //         Uri.parse('$url/user_login/'),
// //         body: {
// //           'email': usernameController.text.trim(),
// //           'password': passwordController.text.trim(),
// //         },
// //       );
// //
// //       setState(() => _loading = false);
// //
// //       if (response.statusCode == 200) {
// //         final data = jsonDecode(response.body);
// //
// //         if (data['status'] == 'ok') {
// //           String type = data['type'] ?? '';
// //           String lid = data['lid'].toString();
// //
// //           // 🔐 SAVE SESSION (No data loss)
// //           await sp.setBool('isLoggedIn', true);
// //           await sp.setString('user_type', type);
// //           await sp.setString('lid', lid);
// //
// //           Fluttertoast.showToast(msg: 'Login successful');
// //
// //           // 🎯 ROLE BASED NAVIGATION (MATCHES YOUR DJANGO GROUPS)
// //           if (type == 'users') {
// //             Navigator.pushReplacement(
// //               context,
// //               MaterialPageRoute(
// //                 builder: (_) => const UserHomePage(),
// //               ),
// //             );
// //           }
// //           else if (type == 'worker') {
// //             Navigator.pushReplacement(
// //               context,
// //               MaterialPageRoute(
// //                 builder: (_) => const WorkerHomePage(),
// //               ),
// //             );
// //           }
// //           else {
// //             Fluttertoast.showToast(msg: 'User not allowed');
// //           }
// //         } else {
// //           Fluttertoast.showToast(
// //             msg: data['message'] ?? 'Login failed',
// //           );
// //         }
// //       } else {
// //         Fluttertoast.showToast(msg: 'Server error');
// //       }
// //     } catch (e) {
// //       setState(() => _loading = false);
// //       Fluttertoast.showToast(msg: 'Error: $e');
// //     }
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       body: Padding(
// //         padding: const EdgeInsets.all(20),
// //         child: Form(
// //           key: _formKey,
// //           child: Column(
// //             mainAxisAlignment: MainAxisAlignment.center,
// //             children: [
// //               Text(
// //                 widget.title,
// //                 style: const TextStyle(
// //                   fontSize: 24,
// //                   fontWeight: FontWeight.bold,
// //                 ),
// //               ),
// //               const SizedBox(height: 20),
// //
// //               // EMAIL FIELD
// //               TextFormField(
// //                 controller: usernameController,
// //                 decoration: const InputDecoration(
// //                   labelText: 'Email',
// //                   border: OutlineInputBorder(),
// //                 ),
// //                 validator: (v) =>
// //                 v == null || v.isEmpty ? 'Email required' : null,
// //               ),
// //
// //               const SizedBox(height: 15),
// //
// //               // PASSWORD FIELD
// //               TextFormField(
// //                 controller: passwordController,
// //                 decoration: const InputDecoration(
// //                   labelText: 'Password',
// //                   border: OutlineInputBorder(),
// //                 ),
// //                 obscureText: true,
// //                 validator: (v) =>
// //                 v == null || v.length < 4
// //                     ? 'Minimum 4 characters'
// //                     : null,
// //               ),
// //
// //               const SizedBox(height: 20),
// //
// //               // LOGIN BUTTON
// //               SizedBox(
// //                 width: double.infinity,
// //                 height: 50,
// //                 child: ElevatedButton(
// //                   onPressed: _loading ? null : login,
// //                   child: _loading
// //                       ? const CircularProgressIndicator(
// //                     color: Colors.white,
// //                   )
// //                       : const Text(
// //                     'LOGIN',
// //                     style: TextStyle(fontSize: 18),
// //                   ),
// //                 ),
// //               ),
// //
// //               const SizedBox(height: 20),
// //
// //               const Text(
// //                 "Don't have an account?",
// //                 style: TextStyle(fontSize: 16),
// //               ),
// //
// //               const SizedBox(height: 10),
// //
// //               // USER SIGNUP
// //               SizedBox(
// //                 width: double.infinity,
// //                 child: OutlinedButton(
// //                   child: const Text('Create User Account'),
// //                   onPressed: () {
// //                     Navigator.push(
// //                       context,
// //                       MaterialPageRoute(
// //                         builder: (_) => const MyMySignup(),
// //                       ),
// //                     );
// //                   },
// //                 ),
// //               ),
// //
// //               const SizedBox(height: 10),
// //
// //               // WORKER SIGNUP
// //               SizedBox(
// //                 width: double.infinity,
// //                 child: OutlinedButton(
// //                   child: const Text('Register as Worker'),
// //                   onPressed: () {
// //                     Navigator.push(
// //                       context,
// //                       MaterialPageRoute(
// //                         builder: (_) => const WorkerssignupPage(),
// //                       ),
// //                     );
// //                   },
// //                 ),
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// //   // ✅ Update location function
// //   void updateLoc(String lid) async {
// //     SharedPreferences sh = await SharedPreferences.getInstance();
// //
// //     PermissionStatus status = await Permission.location.request();
// //
// //     if (status.isGranted) {
// //       try {
// //         Position position = await Geolocator.getCurrentPosition(
// //           desiredAccuracy: LocationAccuracy.high,
// //         );
// //         String lat = position.latitude.toString();
// //         String lon = position.longitude.toString();
// //
// //         await sh.setString('lat', lat);
// //         await sh.setString('lon', lon);
// //
// //         String url = sh.getString('url') ?? '';
// //         final urls = Uri.parse('$url/updatelocation/');
// //
// //         final response = await http.post(urls, body: {
// //           'lid': lid,
// //           'lat': lat,
// //           'lon': lon,
// //         });
// //
// //         if (response.statusCode != 200) {
// //           debugPrint('Location update failed');
// //         }
// //       } catch (e) {
// //         debugPrint('Location error: $e');
// //       }
// //     } else {
// //       debugPrint('Location permission denied');
// //     }
// //   }
// // // // }
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:permission_handler/permission_handler.dart';
//
// import 'usersignup.dart';
// import 'workerssignup.dart';
// import 'userhome.dart';
// import 'workershome.dart';
//
// class MyLoginPage extends StatefulWidget {
//   const MyLoginPage({super.key, required this.title});
//   final String title;
//
//   @override
//   State<MyLoginPage> createState() => _MyLoginPageState();
// }
//
// class _MyLoginPageState extends State<MyLoginPage> {
//   final _formKey = GlobalKey<FormState>();
//   bool _loading = false;
//
//   final TextEditingController usernameController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
//
//   // 🔥 FULL LOGIN FUNCTION (UPDATED)
//   Future<void> login() async {
//     if (!_formKey.currentState!.validate()) return;
//
//     setState(() => _loading = true);
//
//     try {
//       SharedPreferences sp = await SharedPreferences.getInstance();
//       String url = sp.getString('url') ?? '';
//
//       if (url.isEmpty) {
//         Fluttertoast.showToast(msg: 'Server URL not set');
//         setState(() => _loading = false);
//         return;
//       }
//
//       final response = await http.post(
//         Uri.parse('$url/user_login/'),
//         body: {
//           'email': usernameController.text.trim(),
//           'password': passwordController.text.trim(),
//         },
//       );
//
//       if (response.statusCode != 200) {
//         setState(() => _loading = false);
//         Fluttertoast.showToast(msg: 'Server error');
//         return;
//       }
//
//       final data = jsonDecode(response.body);
//       setState(() => _loading = false);
//
//       if (data['status'] == 'ok') {
//         String type = data['type'] ?? '';
//         String lid = data['lid'].toString();
//
//         // 🔐 SAVE SESSION
//         await sp.setBool('isLoggedIn', true);
//         await sp.setString('user_type', type);
//         await sp.setString('lid', lid);
//
//         // 📍 VERY IMPORTANT: UPDATE LOCATION FOR BOTH USER & WORKER
//         await updateLoc(lid);
//
//         Fluttertoast.showToast(msg: 'Login successful');
//
//         // 🎯 ROLE BASED NAVIGATION
//         if (type == 'users') {
//           Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(
//               builder: (_) => const UserHomePage(),
//             ),
//           );
//         } else if (type == 'worker') {
//           Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(
//               builder: (_) => const WorkerHomePage(),
//             ),
//           );
//         } else {
//           Fluttertoast.showToast(msg: 'User not allowed');
//         }
//       } else {
//         Fluttertoast.showToast(
//           msg: data['message'] ?? 'Login failed',
//         );
//       }
//     } catch (e) {
//       setState(() => _loading = false);
//       Fluttertoast.showToast(msg: 'Error: $e');
//     }
//   }
//
//   // 📍 FULL UPDATED LOCATION FUNCTION (FIXED FOR WORKER + USER)
//   Future<void> updateLoc(String lid) async {
//     try {
//       SharedPreferences sh = await SharedPreferences.getInstance();
//
//       // Check GPS service
//       bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
//       if (!serviceEnabled) {
//         Fluttertoast.showToast(msg: "Please enable GPS");
//         return;
//       }
//
//       // Request permission
//       PermissionStatus permission = await Permission.location.request();
//
//       if (!permission.isGranted) {
//         Fluttertoast.showToast(msg: "Location permission denied");
//         return;
//       }
//
//       // Get current position
//       Position position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high,
//       );
//
//       String lat = position.latitude.toString();
//       String lon = position.longitude.toString();
//
//       // Save locally (optional)
//       await sh.setString('lat', lat);
//       await sh.setString('lon', lon);
//
//       String url = sh.getString('url') ?? '';
//       if (url.isEmpty) return;
//
//       final uri = Uri.parse('$url/updatelocation/');
//
//       final response = await http.post(uri, body: {
//         'lid': lid,
//         'lat': lat,
//         'lon': lon,
//       });
//       if (response.statusCode == 200) {
//         debugPrint("Location Updated: $lat , $lon");
//       } else {
//         debugPrint("Location update failed");
//       }
//     } catch (e) {
//       debugPrint("Location error: $e");
//     }
//   }
//
//   @override
//   void dispose() {
//     usernameController.dispose();
//     passwordController.dispose();
//     super.dispose();
//   }
//
//   // 🎨 UI (UNCHANGED + CLEAN)
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         body: Padding(
//       padding: const EdgeInsets.all(20),
//       child: Form(
//         key: _formKey,
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(
//               widget.title,
//               style: const TextStyle(
//                 fontSize: 26,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(height: 30),
//
//             // EMAIL
//             TextFormField(
//               controller: usernameController,
//               decoration: const InputDecoration(
//                 labelText: 'Email',
//                 border: OutlineInputBorder(),
//                 prefixIcon: Icon(Icons.email),
//               ),
//               validator: (v) =>
//                   v == null || v.isEmpty ? 'Email required' : null,
//             ),
//
//             const SizedBox(height: 15),
//
//             // PASSWORD
//             TextFormField(
//               controller: passwordController,
//               decoration: const InputDecoration(
//                 labelText: 'Password',
//                 border: OutlineInputBorder(),
//                 prefixIcon: Icon(Icons.lock),
//               ),
//               obscureText: true,
//               validator: (v) =>
//                   v == null || v.length < 4 ? 'Minimum 4 characters' : null,
//             ),
//
//             const SizedBox(height: 25),
//
//             // LOGIN BUTTON
//             SizedBox(
//               width: double.infinity,
//               height: 50,
//               child: ElevatedButton(
//                 onPressed: _loading ? null : login,
//                 child: _loading
//                     ? const CircularProgressIndicator(color: Colors.white)
//                     : const Text(
//                         'LOGIN',
//                         style: TextStyle(fontSize: 18),
//                       ),
//               ),
//             ),
//
//             const SizedBox(height: 25),
//
//             const Text(
//               "Don't have an account?",
//               style: TextStyle(fontSize: 16),
//             ),
//
//             const SizedBox(height: 10),
//
//             // USER SIGNUP
//             SizedBox(
//               width: double.infinity,
//               child: OutlinedButton(
//                 child: const Text('Create User Account'),
//                 onPressed: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (_) => const MyMySignup(),
//                     ),
//                   );
//                 },
//               ),
//             ),
//
//             const SizedBox(height: 10),
//
//             // WORKER SIGNUP
//             SizedBox(
//               width: double.infinity,
//               child: OutlinedButton(
//                 child: const Text('Register as Worker'),
//                 onPressed: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (_) => const WorkerssignupPage(),
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     ));
//   }
// }
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

import 'usersignup.dart';
import 'workerssignup.dart';
import 'userhome.dart';
import 'workershome.dart';
import 'forgetpassword.dart';

class MyLoginPage extends StatefulWidget {
  const MyLoginPage({super.key, required this.title});
  final String title;

  @override
  State<MyLoginPage> createState() => _MyLoginPageState();
}

class _MyLoginPageState extends State<MyLoginPage> {

  final _formKey = GlobalKey<FormState>();
  bool _loading = false;

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // LOGIN FUNCTION
  Future<void> login() async {

    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _loading = true;
    });

    try {

      SharedPreferences sp = await SharedPreferences.getInstance();
      String url = sp.getString('url') ?? '';

      if (url.isEmpty) {
        Fluttertoast.showToast(msg: "Server URL not set");
        setState(() => _loading = false);
        return;
      }

      final response = await http.post(
        Uri.parse("$url/user_login/"),
        body: {
          "email": usernameController.text.trim(),
          "password": passwordController.text.trim(),
        },
      );

      setState(() {
        _loading = false;
      });

      if (response.statusCode != 200) {
        Fluttertoast.showToast(msg: "Server error");
        return;
      }

      var data = jsonDecode(response.body);

      if (data['status'] == "ok") {

        String type = data['type'];
        String lid = data['lid'].toString();

        await sp.setBool("isLoggedIn", true);
        await sp.setString("user_type", type);
        await sp.setString("lid", lid);

        await updateLoc(lid);

        Fluttertoast.showToast(msg: "Login successful");

        if (type == "users") {

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => const UserHomePage(),
            ),
          );

        } else if (type == "worker") {

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => const WorkerHomePage(),
            ),
          );

        } else {

          Fluttertoast.showToast(msg: "Access denied");

        }

      } else {

        Fluttertoast.showToast(msg: data['message'] ?? "Login failed");

      }

    } catch (e) {

      setState(() => _loading = false);
      Fluttertoast.showToast(msg: "Error: $e");

    }
  }

  // LOCATION UPDATE
  Future<void> updateLoc(String lid) async {

    try {

      SharedPreferences sh = await SharedPreferences.getInstance();

      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        Fluttertoast.showToast(msg: "Enable GPS");
        return;
      }

      PermissionStatus permission = await Permission.location.request();

      if (!permission.isGranted) {
        Fluttertoast.showToast(msg: "Location permission denied");
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      String lat = position.latitude.toString();
      String lon = position.longitude.toString();

      await sh.setString("lat", lat);
      await sh.setString("lon", lon);

      String url = sh.getString("url") ?? "";

      await http.post(
        Uri.parse("$url/updatelocation/"),
        body: {
          "lid": lid,
          "lat": lat,
          "lon": lon,
        },
      );

    } catch (e) {

      debugPrint("Location Error $e");

    }
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  // UI
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),

            child: Form(
              key: _formKey,

              child: Column(
                children: [

                  const SizedBox(height: 40),

                  // EMAIL
                  TextFormField(
                    controller: usernameController,

                    decoration: const InputDecoration(
                      labelText: "Email",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.email),
                    ),

                    validator: (v) =>
                    v == null || v.isEmpty ? "Email required" : null,
                  ),

                  const SizedBox(height: 20),

                  // PASSWORD
                  TextFormField(
                    controller: passwordController,

                    decoration: const InputDecoration(
                      labelText: "Password",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.lock),
                    ),

                    obscureText: true,

                    validator: (v) =>
                    v == null || v.length < 4 ? "Minimum 4 characters" : null,
                  ),

                  const SizedBox(height: 10),

                  // FORGOT PASSWORD
                  Align(
                    alignment: Alignment.centerRight,

                    child: TextButton(
                      child: const Text("Forgot Password?"),

                      onPressed: () {

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ForgotPasswordPage(),
                          ),
                        );

                      },
                    ),
                  ),

                  const SizedBox(height: 20),

                  // LOGIN BUTTON
                  SizedBox(
                    width: double.infinity,
                    height: 50,

                    child: ElevatedButton(

                      onPressed: _loading ? null : login,

                      child: _loading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                        "LOGIN",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  const Text(
                    "Don't have an account?",
                    style: TextStyle(fontSize: 16),
                  ),

                  const SizedBox(height: 10),

                  // USER SIGNUP
                  SizedBox(
                    width: double.infinity,

                    child: OutlinedButton(
                      child: const Text("Create User Account"),

                      onPressed: () {

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const MyMySignup(),
                          ),
                        );

                      },
                    ),
                  ),

                  const SizedBox(height: 10),

                  // WORKER SIGNUP
                  SizedBox(
                    width: double.infinity,

                    child: OutlinedButton(
                      child: const Text("Register as Worker"),

                      onPressed: () {

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const WorkerssignupPage(),
                          ),
                        );

                      },
                    ),
                  ),

                  const SizedBox(height: 20),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}