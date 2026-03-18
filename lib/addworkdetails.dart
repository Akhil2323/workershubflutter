import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WorkerAddWorkPage extends StatefulWidget {
  const WorkerAddWorkPage({super.key});

  @override
  State<WorkerAddWorkPage> createState() => _WorkerAddWorkPageState();
}

class _WorkerAddWorkPageState extends State<WorkerAddWorkPage> {
  TextEditingController jobController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  bool isLoading = false;

  Future<void> addWork() async {
    if (jobController.text.isEmpty || amountController.text.isEmpty) {
      Fluttertoast.showToast(msg: "Enter all fields");
      return;
    }

    setState(() => isLoading = true);

    SharedPreferences sp = await SharedPreferences.getInstance();
    String url = sp.getString('url') ?? "";
    String lid = sp.getString('lid') ?? "";

    final response = await http.post(
      Uri.parse("${url}/worker_add_work/"),
      body: {
        'lid': lid,
        'job': jobController.text,
        'amount': amountController.text,
      },
    );

    final data = jsonDecode(response.body);
    setState(() => isLoading = false);

    if (data['status'] == 'ok') {
      Fluttertoast.showToast(msg: "Work Added Successfully");
      jobController.clear();
      amountController.clear();
    } else {
      Fluttertoast.showToast(msg: "Failed to Add Work");
    }
  }

  Widget textField(TextEditingController c, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextField(
        controller: c,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Work Details"),
        backgroundColor: const Color(0xFF14b8a6),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            textField(jobController, "Job Name"),
            textField(amountController, "Amount"),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: addWork,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF14b8a6),
                ),
                child: const Text("ADD WORK"),
              ),
            )
          ],
        ),
      ),
    );
  }
}