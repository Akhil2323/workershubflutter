// import 'dart:convert';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:image_picker/image_picker.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// class EditProfilePage extends StatefulWidget {
//   const EditProfilePage({super.key});
//
//   @override
//   State<EditProfilePage> createState() => _EditProfilePageState();
// }
//
// class _EditProfilePageState extends State<EditProfilePage> {
//   final TextEditingController nameController = TextEditingController();
//   final TextEditingController phoneController = TextEditingController();
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController placeController = TextEditingController();
//   final TextEditingController pinController = TextEditingController();
//   final TextEditingController postController = TextEditingController();
//
//   String baseUrl = "";
//   String photoPath = ""; // from server (/media/xxx.jpg)
//   File? selectedImage;
//   bool isLoading = true;
//
//   @override
//   void initState() {
//     super.initState();
//     fetchProfile(); // Auto load existing data
//   }
//
//   // FIX IMAGE URL (remove /myapp/)
//   String getFullImageUrl() {
//     if (photoPath.isEmpty || photoPath == "null") return "";
//     String serverUrl = baseUrl.replaceAll("myapp/", "");
//     if (!serverUrl.endsWith("/")) {
//       serverUrl = "$serverUrl/";
//     }
//     if (photoPath.startsWith("/")) {
//       return serverUrl + photoPath.substring(1);
//     } else {
//       return serverUrl + photoPath;
//     }
//   }
//
//   Future<void> fetchProfile() async {
//     SharedPreferences sh = await SharedPreferences.getInstance();
//     String lid = sh.getString('lid') ?? "";
//     baseUrl = sh.getString('url') ?? "";
//
//     if (!baseUrl.endsWith("/")) {
//       baseUrl = "$baseUrl/";
//     }
//
//     final response = await http.post(
//       Uri.parse(baseUrl + "view_profile/"),
//       body: {'lid': lid},
//     );
//
//     var jsonData = json.decode(response.body);
//
//     if (jsonData['status'] == "ok") {
//       setState(() {
//         nameController.text = jsonData['name'].toString();
//         phoneController.text = jsonData['phone'].toString();
//         emailController.text = jsonData['email'].toString();
//         placeController.text = jsonData['place'].toString();
//         pinController.text = jsonData['pin'].toString();
//         postController.text = jsonData['post'].toString();
//         photoPath = jsonData['photo'].toString(); // /media/xxx.jpg
//         isLoading = false;
//       });
//     } else {
//       isLoading = false;
//     }
//   }
//
//   Future<void> pickImage() async {
//     final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
//     if (picked != null) {
//       setState(() {
//         selectedImage = File(picked.path);
//       });
//     }
//   }
//
//   Future<void> updateProfile() async {
//     SharedPreferences sh = await SharedPreferences.getInstance();
//     String lid = sh.getString('lid') ?? "";
//     String url = sh.getString('url') ?? "";
//
//     if (!url.endsWith("/")) {
//       url = "$url/";
//     }
//
//     var request = http.MultipartRequest(
//       'POST',
//       Uri.parse(url + "edit_profile/"),
//     );
//
//     request.fields['lid'] = lid;
//     request.fields['name'] = nameController.text;
//     request.fields['phone'] = phoneController.text;
//     request.fields['place'] = placeController.text;
//     request.fields['pin'] = pinController.text;
//     request.fields['post'] = postController.text;
//     // EMAIL NOT SENT (not editable)
//
//     if (selectedImage != null) {
//       request.files.add(
//         await http.MultipartFile.fromPath(
//           'photo',
//           selectedImage!.path,
//         ),
//       );
//     }
//
//     var response = await request.send();
//     var respStr = await response.stream.bytesToString();
//     var jsonData = json.decode(respStr);
//
//     if (jsonData['status'] == "ok") {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text("Profile Updated Successfully"),
//           backgroundColor: Colors.green,
//         ),
//       );
//
//       // Return to View Profile & refresh
//       Navigator.pop(context, true);
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text("Update Failed"),
//           backgroundColor: Colors.red,
//         ),
//       );
//     }
//   }
//
//   Widget buildProfileImage() {
//     if (selectedImage != null) {
//       return CircleAvatar(
//         radius: 60,
//         backgroundImage: FileImage(selectedImage!),
//       );
//     }
//
//     String imageUrl = getFullImageUrl();
//
//     if (imageUrl.isNotEmpty) {
//       return CircleAvatar(
//         radius: 60,
//         backgroundImage: NetworkImage(imageUrl),
//         onBackgroundImageError: (_, __) {},
//       );
//     }
//
//     return const CircleAvatar(
//       radius: 60,
//       child: Icon(Icons.person, size: 50),
//     );
//   }
//
//   @override
//   void dispose() {
//     nameController.dispose();
//     phoneController.dispose();
//     emailController.dispose();
//     placeController.dispose();
//     pinController.dispose();
//     postController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Edit Profile"),
//         backgroundColor: const Color(0xFF14b8a6),
//       ),
//       body: isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : Padding(
//         padding: const EdgeInsets.all(20),
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               buildProfileImage(),
//               const SizedBox(height: 10),
//               TextButton(
//                 onPressed: pickImage,
//                 child: const Text(
//                   "Change Profile Photo",
//                   style: TextStyle(
//                       color: Color(0xFF14b8a6),
//                       fontWeight: FontWeight.bold),
//                 ),
//               ),
//               const SizedBox(height: 20),
//
//               TextField(
//                 controller: nameController,
//                 decoration: const InputDecoration(
//                   labelText: "Name",
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//               const SizedBox(height: 15),
//
//               TextField(
//                 controller: phoneController,
//                 keyboardType: TextInputType.phone,
//                 decoration: const InputDecoration(
//                   labelText: "Phone",
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//               const SizedBox(height: 15),
//
//               // EMAIL (READ ONLY)
//               TextField(
//                 controller: emailController,
//                 readOnly: true,
//                 decoration: const InputDecoration(
//                   labelText: "Email (Not Editable)",
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//               const SizedBox(height: 15),
//
//               TextField(
//                 controller: placeController,
//                 decoration: const InputDecoration(
//                   labelText: "Place",
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//               const SizedBox(height: 15),
//
//               TextField(
//                 controller: postController,
//                 decoration: const InputDecoration(
//                   labelText: "Post",
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//               const SizedBox(height: 15),
//
//               TextField(
//                 controller: pinController,
//                 keyboardType: TextInputType.number,
//                 decoration: const InputDecoration(
//                   labelText: "Pin",
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//               const SizedBox(height: 30),
//
//               SizedBox(
//                 width: double.infinity,
//                 child: ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: const Color(0xFF14b8a6),
//                     padding: const EdgeInsets.symmetric(vertical: 16),
//                   ),
//                   onPressed: updateProfile,
//                   child: const Text(
//                     "Update Profile",
//                     style: TextStyle(
//                         fontSize: 16, fontWeight: FontWeight.bold),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }


import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController placeController = TextEditingController();
  final TextEditingController pinController = TextEditingController();
  final TextEditingController postController = TextEditingController();

  String baseUrl = "";
  String photoPath = "";
  File? selectedImage;
  bool isLoading = true;
  bool isSubmitting = false;

  @override
  void initState() {
    super.initState();
    fetchProfile();
  }

  // FIX IMAGE URL (remove /myapp/ and avoid double slash)
  String getFullImageUrl() {
    if (photoPath.isEmpty || photoPath == "null") return "";

    String serverUrl = baseUrl.replaceAll("myapp/", "");

    if (!serverUrl.endsWith("/")) {
      serverUrl = "$serverUrl/";
    }

    if (photoPath.startsWith("/")) {
      return serverUrl + photoPath.substring(1);
    } else {
      return serverUrl + photoPath;
    }
  }

  Future<void> fetchProfile() async {
    try {
      SharedPreferences sh = await SharedPreferences.getInstance();
      String lid = sh.getString('lid') ?? "";
      baseUrl = sh.getString('url') ?? "";

      if (!baseUrl.endsWith("/")) {
        baseUrl = "$baseUrl/";
      }

      final response = await http.post(
        Uri.parse(baseUrl + "view_profile/"),
        body: {'lid': lid},
      );

      var jsonData = json.decode(response.body);

      if (jsonData['status'] == "ok") {
        setState(() {
          nameController.text = jsonData['name'].toString();
          phoneController.text = jsonData['phone'].toString();
          emailController.text = jsonData['email'].toString();
          placeController.text = jsonData['place'].toString();
          pinController.text = jsonData['pin'].toString();
          postController.text = jsonData['post'].toString();
          photoPath = jsonData['photo'].toString();
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        selectedImage = File(picked.path);
      });
    }
  }

  Future<void> updateProfile() async {
    // 🔥 CLOSE KEYBOARD (MAIN OVERFLOW FIX)
    FocusScope.of(context).unfocus();

    if (isSubmitting) return;

    setState(() {
      isSubmitting = true;
    });

    try {
      SharedPreferences sh = await SharedPreferences.getInstance();
      String lid = sh.getString('lid') ?? "";
      String url = sh.getString('url') ?? "";

      if (!url.endsWith("/")) {
        url = "$url/";
      }

      var request = http.MultipartRequest(
        'POST',
        Uri.parse(url + "edit_profile/"),
      );

      request.fields['lid'] = lid;
      request.fields['name'] = nameController.text;
      request.fields['phone'] = phoneController.text;
      request.fields['place'] = placeController.text;
      request.fields['pin'] = pinController.text;
      request.fields['post'] = postController.text;

      if (selectedImage != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'photo',
            selectedImage!.path,
          ),
        );
      }

      var response = await request.send();
      var respStr = await response.stream.bytesToString();
      var jsonData = json.decode(respStr);

      if (!mounted) return;

      if (jsonData['status'] == "ok") {
        // Small delay prevents layout overflow during navigation
        await Future.delayed(const Duration(milliseconds: 300));
        Navigator.pop(context, true); // Return & refresh previous screen
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Update Failed"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Server Error"),
          backgroundColor: Colors.red,
        ),
      );
    }

    if (mounted) {
      setState(() {
        isSubmitting = false;
      });
    }
  }

  Widget buildProfileImage() {
    if (selectedImage != null) {
      return CircleAvatar(
        radius: 60,
        backgroundImage: FileImage(selectedImage!),
      );
    }

    String imageUrl = getFullImageUrl();

    if (imageUrl.isNotEmpty) {
      return CircleAvatar(
        radius: 60,
        backgroundImage: NetworkImage(imageUrl),
        onBackgroundImageError: (_, __) {},
      );
    }

    return const CircleAvatar(
      radius: 60,
      child: Icon(Icons.person, size: 50),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    placeController.dispose();
    pinController.dispose();
    postController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true, // ✅ OVERFLOW FIX
      appBar: AppBar(
        title: const Text("Edit Profile"),
        backgroundColor: const Color(0xFF14b8a6),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            keyboardDismissBehavior:
            ScrollViewKeyboardDismissBehavior.onDrag,
            child: Column(
              children: [
                buildProfileImage(),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: pickImage,
                  child: const Text(
                    "Change Profile Photo",
                    style: TextStyle(
                      color: Color(0xFF14b8a6),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: "Name",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 15),

                TextField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: "Phone",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 15),

                // EMAIL READ ONLY
                TextField(
                  controller: emailController,
                  readOnly: true,
                  decoration: const InputDecoration(
                    labelText: "Email (Not Editable)",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 15),

                TextField(
                  controller: placeController,
                  decoration: const InputDecoration(
                    labelText: "Place",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 15),

                TextField(
                  controller: postController,
                  decoration: const InputDecoration(
                    labelText: "Post",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 15),

                TextField(
                  controller: pinController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "Pin",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 30),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF14b8a6),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    onPressed:
                    isSubmitting ? null : updateProfile, // prevent double click
                    child: isSubmitting
                        ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                        : const Text(
                      "Update Profile",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}