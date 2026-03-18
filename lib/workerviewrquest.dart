// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// class WorkerViewRequests extends StatefulWidget {
//   const WorkerViewRequests({super.key});
//
//   @override
//   State<WorkerViewRequests> createState() => _WorkerViewRequestsState();
// }
//
// class _WorkerViewRequestsState extends State<WorkerViewRequests> {
//
//   List requestList = [];
//   bool isLoading = true;
//
//   @override
//   void initState() {
//     super.initState();
//     loadRequests();
//   }
//
//   Future<void> loadRequests() async {
//     SharedPreferences sp = await SharedPreferences.getInstance();
//     String url = sp.getString('url') ?? "";
//     String lid = sp.getString('lid') ?? "";
//
//     final response = await http.post(
//       Uri.parse("$url/worker_view_requests/"),
//       body: {'lid': lid},
//     );
//
//     final data = jsonDecode(response.body);
//
//     if (data['status'] == 'ok') {
//       setState(() {
//         requestList = data['data'];
//         isLoading = false;
//       });
//     }
//   }
//
//   Future<void> acceptRequest(String rid) async {
//     SharedPreferences sp = await SharedPreferences.getInstance();
//     String url = sp.getString('url') ?? "";
//
//     await http.post(
//       Uri.parse("$url/worker_accept_request/"),
//       body: {'rid': rid},
//     );
//
//     Fluttertoast.showToast(msg: "Accepted");
//     loadRequests();
//   }
//
//   Future<void> rejectRequest(String rid) async {
//     SharedPreferences sp = await SharedPreferences.getInstance();
//     String url = sp.getString('url') ?? "";
//
//     await http.post(
//       Uri.parse("$url/worker_reject_request/"),
//       body: {'rid': rid},
//     );
//
//     Fluttertoast.showToast(msg: "Rejected");
//     loadRequests();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Work Requests"),
//         backgroundColor: Colors.teal,
//       ),
//       body: isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : requestList.isEmpty
//           ? const Center(child: Text("No Pending Requests"))
//           : ListView.builder(
//         itemCount: requestList.length,
//         itemBuilder: (context, index) {
//           final request = requestList[index];
//
//           return Card(
//             margin: const EdgeInsets.all(10),
//             child: Padding(
//               padding: const EdgeInsets.all(12),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text("User: ${request['username']}"),
//                   Text("Job: ${request['job']}"),
//                   Text("Amount: ₹${request['amount']}"),
//                   Text("Date: ${request['date']}"),
//                   const SizedBox(height: 10),
//
//                   Row(
//                     children: [
//                       ElevatedButton(
//                         onPressed: () {
//                           acceptRequest(request['id'].toString());
//                         },
//                         style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.green),
//                         child: const Text("Accept"),
//                       ),
//                       const SizedBox(width: 10),
//                       ElevatedButton(
//                         onPressed: () {
//                           rejectRequest(request['id'].toString());
//                         },
//                         style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.red),
//                         child: const Text("Reject"),
//                       ),
//                     ],
//                   )
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }


import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WorkerViewRequests extends StatefulWidget {
  const WorkerViewRequests({super.key});

  @override
  State<WorkerViewRequests> createState() => _WorkerViewRequestsState();
}

class _WorkerViewRequestsState extends State<WorkerViewRequests> {

  List requestList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadRequests();
  }

  Future<void> loadRequests() async {

    SharedPreferences sp = await SharedPreferences.getInstance();
    String url = sp.getString('url') ?? "";
    String lid = sp.getString('lid') ?? "";

    final response = await http.post(
      Uri.parse("$url/worker_view_requests/"),
      body: {'lid': lid},
    );

    final data = jsonDecode(response.body);

    if (data['status'] == 'ok') {
      setState(() {
        requestList = data['data'];
        isLoading = false;
      });
    }
  }

  Future<void> acceptRequest(String rid) async {

    SharedPreferences sp = await SharedPreferences.getInstance();
    String url = sp.getString('url') ?? "";

    await http.post(
      Uri.parse("$url/worker_accept_request/"),
      body: {'rid': rid},
    );

    Fluttertoast.showToast(msg: "Request Accepted");
    loadRequests();
  }

  Future<void> rejectRequest(String rid) async {

    SharedPreferences sp = await SharedPreferences.getInstance();
    String url = sp.getString('url') ?? "";

    await http.post(
      Uri.parse("$url/worker_reject_request/"),
      body: {'rid': rid},
    );

    Fluttertoast.showToast(msg: "Request Rejected");
    loadRequests();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Work Requests"),
        backgroundColor: Colors.teal,
      ),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())

          : requestList.isEmpty
          ? const Center(child: Text("No Pending Requests"))

          : ListView.builder(
        itemCount: requestList.length,

        itemBuilder: (context, index) {

          final request = requestList[index];

          return Card(

            margin: const EdgeInsets.all(10),
            elevation: 4,

            child: Padding(
              padding: const EdgeInsets.all(12),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [

                  Text(
                    "User: ${request['username']}",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 5),

                  Text("Job: ${request['job']}"),
                  Text("Amount: ₹${request['amount']}"),

                  const Divider(),

                  Text("Date: ${request['date']}"),
                  Text("Time: ${request['time']}"),
                  Text("Place: ${request['place']}"),

                  const SizedBox(height: 5),

                  Text(
                    "Description:",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),

                  Text(request['description']),

                  const SizedBox(height: 10),

                  Row(
                    children: [

                      ElevatedButton(
                        onPressed: () {
                          acceptRequest(request['id'].toString());
                        },

                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green),

                        child: const Text("Accept"),
                      ),

                      const SizedBox(width: 10),

                      ElevatedButton(
                        onPressed: () {
                          rejectRequest(request['id'].toString());
                        },

                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red),

                        child: const Text("Reject"),
                      ),

                    ],
                  )

                ],
              ),
            ),
          );
        },
      ),
    );
  }
}