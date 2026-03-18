import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'edituserprofile.dart';

class ViewProfilePage extends StatefulWidget {
  const ViewProfilePage({super.key});

  @override
  State<ViewProfilePage> createState() => _ViewProfilePageState();
}

class _ViewProfilePageState extends State<ViewProfilePage> {

  String name = "";
  String phone = "";
  String email = "";
  String place = "";
  String pin = "";
  String post = "";
  String photo = "";
  String baseUrl = "";
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchProfile();
  }

  Future<void> fetchProfile() async {
    SharedPreferences sh = await SharedPreferences.getInstance();
    String lid = sh.getString('lid') ?? "";
    baseUrl = sh.getString('url') ?? "";

    // Ensure trailing slash
    if (!baseUrl.endsWith("/")) {
      baseUrl = "$baseUrl/";
    }

    print("Base URL: $baseUrl");
    print("LID: $lid");

    final response = await http.post(
      Uri.parse(baseUrl + "view_profile/"),
      body: {
        'lid': lid,
      },
    );

    print("Response: ${response.body}");

    var jsonData = json.decode(response.body);

    if (jsonData['status'] == "ok") {

      // 🔥 IMPORTANT FIX FOR MEDIA URL
      String imagePath = jsonData['photo'].toString();

      String finalPhotoUrl = "";
      if (imagePath.isNotEmpty) {
        // If Django returns /media/xxx.jpg
        if (imagePath.startsWith("/media/")) {
          // Remove /myapp/ from base URL for media loading
          String serverBase = baseUrl.replaceAll("myapp/", "");
          finalPhotoUrl = serverBase + imagePath;
        } else {
          finalPhotoUrl = baseUrl + imagePath;
        }
      }

      setState(() {
        name = jsonData['name'].toString();
        phone = jsonData['phone'].toString();
        email = jsonData['email'].toString();
        place = jsonData['place'].toString();
        pin = jsonData['pin'].toString();
        post = jsonData['post'].toString();
        photo = finalPhotoUrl;
        isLoading = false;
      });

      print("Final Image URL: $photo");
    } else {
      isLoading = false;
      print("Error: ${jsonData['message']}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Profile"),
        backgroundColor: const Color(0xFF14b8a6),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            // PROFILE IMAGE (Fixed)
            CircleAvatar(
              radius: 60,
              backgroundColor: Colors.grey.shade300,
              backgroundImage: (photo.isNotEmpty)
                  ? NetworkImage(photo)
                  : null,
              child: photo.isEmpty
                  ? const Icon(Icons.person, size: 60, color: Colors.grey)
                  : null,
            ),

            const SizedBox(height: 20),

            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    buildRow("Name", name),
                    buildRow("Phone", phone),
                    buildRow("Email", email),
                    buildRow("Place", place),
                    buildRow("Post", post),
                    buildRow("Pin", pin),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF14b8a6),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const EditProfilePage(),
                    ),
                  );
                },
                child: const Text(
                  "Edit Profile",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Text(
            "$title: ",
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16
            ),
          ),
          Expanded(
            child: Text(
              value.isNotEmpty ? value : "Not Available",
              style: const TextStyle(fontSize: 16),
            ),
          )
        ],
      ),
    );
  }
}