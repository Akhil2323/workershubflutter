import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'editworkersprofile.dart';

class WorkerProfilePage extends StatefulWidget {
  const WorkerProfilePage({super.key});

  @override
  State<WorkerProfilePage> createState() => _WorkerProfilePageState();
}

class _WorkerProfilePageState extends State<WorkerProfilePage> {
  bool isLoading = true;

  String name = '';
  String photo = '';
  String phone = '';
  String email = '';
  String place = '';
  String post = '';
  String pin = '';
  String job = '';
  String experience = '';
  String category = '';
  String statusWorker = '';
  String serverUrl = '';

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  Future<void> loadProfile() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    String url = sp.getString('url') ?? '';
    String lid = sp.getString('lid') ?? '';

    // 🔥 SAME BASE URL FIX LIKE USER PROFILE
    serverUrl = url;
    if (!serverUrl.endsWith("/")) {
      serverUrl = "$serverUrl/";
    }

    final response = await http.post(
      Uri.parse(serverUrl + "worker_view_profile/"),
      body: {'lid': lid},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (data['status'] == 'ok') {

        // 🔥 IMAGE FIX (EXACTLY LIKE ViewProfilePage)
        String imagePath = data['photo'].toString();
        String finalPhotoUrl = "";

        if (imagePath.isNotEmpty) {
          // If Django returns /media/xxx.jpg
          if (imagePath.startsWith("/media/")) {
            // remove myapp/ from base url
            String serverBase = serverUrl.replaceAll("myapp/", "");
            finalPhotoUrl = serverBase + imagePath;
          } else {
            finalPhotoUrl = serverUrl + imagePath;
          }
        }

        setState(() {
          name = data['name'];
          photo = finalPhotoUrl; // ✅ corrected image url
          phone = data['phone'];
          email = data['email'];
          place = data['place'];
          post = data['post'];
          pin = data['pin'];
          job = data['job'];
          experience = data['experience'];
          category = data['category'];
          statusWorker = data['status_worker'];
          isLoading = false;
        });

        print("Final Worker Image URL: $photo");
      }
    }
  }

  Widget profileTile(IconData icon, String title, String value) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFF14b8a6)),
        title: Text(title),
        subtitle: Text(value.isEmpty ? "Not Available" : value),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Worker Profile"),
        backgroundColor: const Color(0xFF14b8a6),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const WorkerEditProfilePage(),
                ),
              );
              loadProfile();
            },
          )
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 20),

            // 🔥 FIXED PROFILE IMAGE (NOW SAME AS USER PROFILE)
            CircleAvatar(
              radius: 70,
              backgroundColor: Colors.grey.shade200,
              backgroundImage:
              photo.isNotEmpty ? NetworkImage(photo) : null,
              child: photo.isEmpty
                  ? const Icon(Icons.person, size: 60)
                  : null,
            ),

            const SizedBox(height: 20),

            Text(
              name,
              style: const TextStyle(
                  fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

            profileTile(Icons.email, "Email", email),
            profileTile(Icons.phone, "Phone", phone),
            profileTile(Icons.work, "Job", job),
            profileTile(Icons.category, "Category", category),
            profileTile(Icons.star, "Experience", experience),
            profileTile(Icons.location_city, "Place", place),
            profileTile(Icons.local_post_office, "Post", post),
            profileTile(Icons.pin_drop, "Pin", pin),
            profileTile(Icons.verified, "Status", statusWorker),
          ],
        ),
      ),
    );
  }
}