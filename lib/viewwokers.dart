import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ViewAcceptedWorkersPage extends StatefulWidget {
  const ViewAcceptedWorkersPage({super.key});

  @override
  State<ViewAcceptedWorkersPage> createState() =>
      _ViewAcceptedWorkersPageState();
}

class _ViewAcceptedWorkersPageState extends State<ViewAcceptedWorkersPage> {
  List workers = [];
  bool isLoading = true;
  String baseUrl = "";

  @override
  void initState() {
    super.initState();
    fetchWorkers();
  }

  Future<void> fetchWorkers() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    baseUrl = sp.getString('url') ?? "";

    // ensure trailing slash
    if (!baseUrl.endsWith("/")) {
      baseUrl = "$baseUrl/";
    }

    final response = await http.get(
      Uri.parse(baseUrl + "user_view_accepted_workers/"),
    );

    final data = jsonDecode(response.body);

    if (data['status'] == "ok") {
      setState(() {
        workers = data['data'];
        isLoading = false;
      });
    } else {
      isLoading = false;
    }
  }

  String getImageUrl(String imagePath) {
    if (imagePath.isEmpty) return "";

    // Fix for Django media path
    if (imagePath.startsWith("/media/")) {
      String serverBase = baseUrl.replaceAll("myapp/", "");
      return serverBase + imagePath;
    } else {
      return baseUrl + imagePath;
    }
  }

  Widget workerCard(dynamic worker) {
    String imageUrl = getImageUrl(worker['photo'].toString());

    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Row(
          children: [
            // 🔥 WORKER PHOTO
            CircleAvatar(
              radius: 40,
              backgroundColor: Colors.grey.shade200,
              backgroundImage:
              imageUrl.isNotEmpty ? NetworkImage(imageUrl) : null,
              child: imageUrl.isEmpty
                  ? const Icon(Icons.person, size: 40)
                  : null,
            ),

            const SizedBox(width: 15),

            // 🔥 WORKER DETAILS
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    worker['name'],
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  Text("Job: ${worker['job']}"),
                  Text("Category: ${worker['category']}"),
                  Text("Experience: ${worker['experience']}"),
                  Text("Place: ${worker['place']}"),
                  Text("Phone: ${worker['phone']}"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Accepted Workers"),
        backgroundColor: const Color(0xFF14b8a6),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : workers.isEmpty
          ? const Center(
        child: Text(
          "No Accepted Workers Found",
          style: TextStyle(fontSize: 16),
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: workers.length,
        itemBuilder: (context, index) {
          return workerCard(workers[index]);
        },
      ),
    );
  }
}