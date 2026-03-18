import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class WorkerViewPaymentsPage extends StatefulWidget {
  const WorkerViewPaymentsPage({Key? key}) : super(key: key);

  @override
  State<WorkerViewPaymentsPage> createState() =>
      _WorkerViewPaymentsPageState();
}

class _WorkerViewPaymentsPageState
    extends State<WorkerViewPaymentsPage> {
  List payments = [];
  bool isLoading = true;
  String message = "Loading payments...";

  @override
  void initState() {
    super.initState();
    fetchPayments();
  }

  // 🔥 FETCH PAYMENTS FROM DJANGO API (CORRECTED)
  Future<void> fetchPayments() async {
    setState(() {
      isLoading = true;
      message = "Fetching payments...";
    });

    try {
      SharedPreferences sh = await SharedPreferences.getInstance();
      String baseUrl = sh.getString('url') ?? "";
      String lid = sh.getString('lid') ?? "";

      print("Base URL: $baseUrl");
      print("Worker LID: $lid");

      if (baseUrl.isEmpty || lid.isEmpty) {
        setState(() {
          message = "URL or Login ID missing";
          isLoading = false;
        });
        return;
      }

      // IMPORTANT: Ensure correct endpoint
      final uri = Uri.parse("$baseUrl/worker_view_payments/");

      final response = await http.post(uri, body: {
        'lid': lid,
      });

      print("Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['status'] == 'ok') {
          List temp = data['data'] ?? [];

          setState(() {
            payments = temp;
            isLoading = false;
            message = payments.isEmpty
                ? "No Payments Received Yet"
                : "";
          });
        } else {
          setState(() {
            payments = [];
            message = data['error'] ?? "No Payments Found";
            isLoading = false;
          });
        }
      } else {
        setState(() {
          message = "Server Error: ${response.statusCode}";
          isLoading = false;
        });
      }
    } catch (e) {
      print("Exception: $e");
      setState(() {
        message = "Error: $e";
        isLoading = false;
      });
    }
  }

  // 🔥 PAYMENT CARD UI (SAFE NULL HANDLING)
  Widget paymentCard(int index) {
    final payment = payments[index];

    String userName = payment['user_name']?.toString() ?? "Unknown User";
    String amount = payment['amount']?.toString() ?? "0";
    String status = payment['status']?.toString() ?? "pending";

    return Card(
      elevation: 5,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "User: $userName",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Amount: ₹$amount",
              style: const TextStyle(
                fontSize: 16,
                color: Colors.green,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Text(
                  "Status: ",
                  style: TextStyle(fontSize: 16),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 5),
                  decoration: BoxDecoration(
                    color: status.toLowerCase() == "paid"
                        ? Colors.green
                        : Colors.orange,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    status.toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
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
        title: const Text("Payments Received"),
        backgroundColor: const Color(0xFF14b8a6),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: fetchPayments,
          )
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : payments.isEmpty
          ? Center(
        child: Text(
          message,
          style: const TextStyle(
              fontSize: 18, fontWeight: FontWeight.w500),
        ),
      )
          : RefreshIndicator(
        onRefresh: fetchPayments,
        child: ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: payments.length,
          itemBuilder: (context, index) {
            return paymentCard(index);
          },
        ),
      ),
    );
  }
}