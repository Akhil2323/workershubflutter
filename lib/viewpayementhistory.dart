import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ViewPaymentHistory extends StatefulWidget {
  const ViewPaymentHistory({Key? key}) : super(key: key);

  @override
  State<ViewPaymentHistory> createState() => _ViewPaymentHistoryState();
}

class _ViewPaymentHistoryState extends State<ViewPaymentHistory> {

  List paymentList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchPayments();
  }

  Future<void> fetchPayments() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    String url = sp.getString('url') ?? '';
    String lid = sp.getString('lid') ?? '';

    final response = await http.post(
      Uri.parse('$url/user_payment_history/'),
      body: {'lid': lid},
    );

    final data = jsonDecode(response.body);

    if (data['status'] == 'ok') {
      setState(() {
        paymentList = data['data'];
        isLoading = false;
      });
    } else {
      setState(() => isLoading = false);
    }
  }

  Color getStatusColor(String status) {
    if (status.toLowerCase() == "paid") {
      return Colors.green;
    } else {
      return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Payment History"),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : paymentList.isEmpty
          ? const Center(child: Text("No Payment History Found"))
          : ListView.builder(
        itemCount: paymentList.length,
        itemBuilder: (context, index) {

          final payment = paymentList[index];

          return Card(
            margin: const EdgeInsets.all(10),
            elevation: 3,
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Text(
                    payment['workshop_name'],
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    "Amount: ₹ ${payment['amount']}",
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    "Date: ${payment['date']}",
                  ),

                  const SizedBox(height: 5),

                  Text(
                    "Status: ${payment['status']}",
                    style: TextStyle(
                      color: getStatusColor(payment['status']),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}