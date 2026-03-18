import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WorkerEditWorkPage extends StatefulWidget {
  final String wid;
  final String job;
  final String amount;

  const WorkerEditWorkPage({
    super.key,
    required this.wid,
    required this.job,
    required this.amount,
  });

  @override
  State<WorkerEditWorkPage> createState() => _WorkerEditWorkPageState();
}

class _WorkerEditWorkPageState extends State<WorkerEditWorkPage> {
  late TextEditingController jobController;
  late TextEditingController amountController;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    jobController = TextEditingController(text: widget.job);
    amountController = TextEditingController(text: widget.amount);
  }

  Future<void> updateWork() async {
    setState(() => isLoading = true);

    SharedPreferences sp = await SharedPreferences.getInstance();
    String url = sp.getString('url') ?? "";

    final response = await http.post(
      Uri.parse("${url}/worker_edit_work/"),
      body: {
        'wid': widget.wid,
        'job': jobController.text,
        'amount': amountController.text,
      },
    );

    final data = jsonDecode(response.body);
    setState(() => isLoading = false);

    if (data['status'] == 'ok') {
      Fluttertoast.showToast(msg: "Work Updated Successfully");
      Navigator.pop(context);
    } else {
      Fluttertoast.showToast(msg: "Update Failed");
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
        title: const Text("Edit Work"),
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
                onPressed: updateWork,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF14b8a6),
                ),
                child: const Text("UPDATE WORK"),
              ),
            )
          ],
        ),
      ),
    );
  }
}