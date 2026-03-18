import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'editworkdetail.dart';

class WorkerViewWorkPage extends StatefulWidget {
  const WorkerViewWorkPage({super.key});

  @override
  State<WorkerViewWorkPage> createState() => _WorkerViewWorkPageState();
}

class _WorkerViewWorkPageState extends State<WorkerViewWorkPage> {
  List workList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadWorks();
  }

  Future<void> loadWorks() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    String url = sp.getString('url') ?? "";
    String lid = sp.getString('lid') ?? "";

    final response = await http.post(
      Uri.parse("${url}/worker_view_work/"),
      body: {'lid': lid},
    );

    final data = jsonDecode(response.body);

    if (data['status'] == 'ok') {
      setState(() {
        workList = data['data'];
        isLoading = false;
      });
    }
  }

  Future<void> deleteWork(String wid) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    String url = sp.getString('url') ?? "";

    final response = await http.post(
      Uri.parse("${url}/worker_delete_work/"),
      body: {'wid': wid},
    );

    final data = jsonDecode(response.body);

    if (data['status'] == 'ok') {
      Fluttertoast.showToast(msg: "Deleted Successfully");
      loadWorks();
    } else {
      Fluttertoast.showToast(msg: "Delete Failed");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Work Details"),
        backgroundColor: const Color(0xFF14b8a6),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : workList.isEmpty
          ? const Center(child: Text("No Work Added"))
          : ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: workList.length,
        itemBuilder: (context, index) {
          final work = workList[index];
          return Card(
            elevation: 4,
            child: ListTile(
              title: Text(work['job']),
              subtitle: Text("Amount: ₹${work['amount']}"),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blue),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => WorkerEditWorkPage(
                            wid: work['id'].toString(),
                            job: work['job'],
                            amount: work['amount'],
                          ),
                        ),
                      ).then((_) => loadWorks());
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      deleteWork(work['id'].toString());
                    },
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