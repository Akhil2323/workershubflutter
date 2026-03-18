import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class WorkerViewReviewsPage extends StatefulWidget {
  const WorkerViewReviewsPage({Key? key}) : super(key: key);

  @override
  State<WorkerViewReviewsPage> createState() =>
      _WorkerViewReviewsPageState();
}

class _WorkerViewReviewsPageState
    extends State<WorkerViewReviewsPage> {
  List reviews = [];
  bool isLoading = true;
  String message = "";

  @override
  void initState() {
    super.initState();
    fetchReviews();
  }

  // 🔥 FETCH REVIEWS FROM DJANGO
  Future<void> fetchReviews() async {
    try {
      SharedPreferences sh =
      await SharedPreferences.getInstance();
      String url = sh.getString('url') ?? "";
      String lid = sh.getString('lid') ?? "";

      if (url.isEmpty || lid.isEmpty) {
        setState(() {
          message = "Missing URL or Login ID";
          isLoading = false;
        });
        return;
      }

      final uri =
      Uri.parse('$url/worker_view_reviews/');

      final response = await http.post(uri, body: {
        'lid': lid,
      });

      print("Review API Response: ${response.body}");

      var data = json.decode(response.body);

      if (data['status'] == 'ok') {
        setState(() {
          reviews = data['data'];
          isLoading = false;
        });
      } else {
        setState(() {
          message = data['error'] ?? "No Reviews Found";
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        message = "Error: $e";
        isLoading = false;
      });
    }
  }

  // ⭐ STAR RATING UI
  Widget buildStars(String rating) {
    int rate = int.tryParse(rating) ?? 0;

    return Row(
      children: List.generate(5, (index) {
        return Icon(
          index < rate ? Icons.star : Icons.star_border,
          color: Colors.amber,
          size: 20,
        );
      }),
    );
  }

  // 🔥 REVIEW CARD UI
  Widget reviewCard(int index) {
    final review = reviews[index];

    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(
          horizontal: 12, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Name
            Text(
              "User: ${review['user_name']}",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 6),

            // Rating Stars
            buildStars(review['rating'] ?? "0"),

            const SizedBox(height: 8),

            // Review Text
            Text(
              "Review: ${review['review']}",
              style: const TextStyle(fontSize: 16),
            ),

            const SizedBox(height: 6),

            // Date
            Text(
              "Date: ${review['date']}",
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 🔥 MAIN UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("User Reviews"),
        backgroundColor: const Color(0xFF14b8a6),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                isLoading = true;
              });
              fetchReviews();
            },
          )
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : reviews.isEmpty
          ? Center(
        child: Text(
          message.isEmpty
              ? "No Reviews Received Yet"
              : message,
          style: const TextStyle(fontSize: 18),
        ),
      )
          : RefreshIndicator(
        onRefresh: fetchReviews,
        child: ListView.builder(
          itemCount: reviews.length,
          itemBuilder: (context, index) {
            return reviewCard(index);
          },
        ),
      ),
    );
  }
}