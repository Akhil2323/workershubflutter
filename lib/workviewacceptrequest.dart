// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
//
// class AcceptedWorkPage extends StatefulWidget {
//   const AcceptedWorkPage({super.key});
//
//   @override
//   State<AcceptedWorkPage> createState() => _AcceptedWorkPageState();
// }
//
// class _AcceptedWorkPageState extends State<AcceptedWorkPage> {
//
//   List acceptedList = [];
//   bool isLoading = true;
//
//   @override
//   void initState() {
//     super.initState();
//     loadAcceptedWork();
//   }
//
//   Future<void> loadAcceptedWork() async {
//     SharedPreferences sp = await SharedPreferences.getInstance();
//     String url = sp.getString('url') ?? "";
//     String lid = sp.getString('lid') ?? "";
//
//     final response = await http.post(
//       Uri.parse("$url/worker_view_accepted/"),
//       body: {'lid': lid},
//     );
//
//     var jsonData = jsonDecode(response.body);
//
//     if (jsonData['status'] == 'ok') {
//       setState(() {
//         acceptedList = jsonData['data'];
//         isLoading = false;
//       });
//     } else {
//       setState(() {
//         acceptedList = [];
//         isLoading = false;
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Accepted Works"),
//         backgroundColor: Colors.green,
//       ),
//       body: isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : acceptedList.isEmpty
//           ? const Center(child: Text("No Accepted Works"))
//           : ListView.builder(
//         itemCount: acceptedList.length,
//         itemBuilder: (context, index) {
//           final item = acceptedList[index];
//
//           return Card(
//             margin: const EdgeInsets.all(10),
//             elevation: 4,
//             child: Padding(
//               padding: const EdgeInsets.all(12),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text("User: ${item['username']}",
//                       style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//                   const SizedBox(height: 5),
//                   Text("Job: ${item['job']}"),
//                   Text("Amount: ₹${item['amount']}"),
//                   Text("Date: ${item['date']}"),
//                   const SizedBox(height: 8),
//                   const Chip(
//                     label: Text("ACCEPTED"),
//                     backgroundColor: Colors.green,
//                     labelStyle: TextStyle(color: Colors.white),
//                   ),
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
import 'package:shared_preferences/shared_preferences.dart';

class AcceptedWorkPage extends StatefulWidget {
  const AcceptedWorkPage({super.key});

  @override
  State<AcceptedWorkPage> createState() => _AcceptedWorkPageState();
}

class _AcceptedWorkPageState extends State<AcceptedWorkPage> {

  List acceptedList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadAcceptedWork();
  }

  Future<void> loadAcceptedWork() async {

    SharedPreferences sp = await SharedPreferences.getInstance();
    String url = sp.getString('url') ?? "";
    String lid = sp.getString('lid') ?? "";

    final response = await http.post(
      Uri.parse("$url/worker_view_accepted/"),
      body: {'lid': lid},
    );

    var jsonData = jsonDecode(response.body);

    if (jsonData['status'] == 'ok') {
      setState(() {
        acceptedList = jsonData['data'];
        isLoading = false;
      });
    } else {
      setState(() {
        acceptedList = [];
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Accepted Works"),
        backgroundColor: Colors.green,
      ),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())

          : acceptedList.isEmpty
          ? const Center(child: Text("No Accepted Works"))

          : ListView.builder(
        itemCount: acceptedList.length,

        itemBuilder: (context, index) {

          final item = acceptedList[index];

          return Card(

            margin: const EdgeInsets.all(10),
            elevation: 4,

            child: Padding(
              padding: const EdgeInsets.all(12),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [

                  Text(
                    "User: ${item['username']}",
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 6),

                  Text("Job: ${item['job']}"),
                  Text("Amount: ₹${item['amount']}"),

                  const Divider(),

                  Text("Date: ${item['date']}"),
                  Text("Time: ${item['time']}"),
                  Text("Place: ${item['place']}"),

                  const SizedBox(height: 6),

                  const Text(
                    "Description:",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),

                  Text(item['description']),

                  const SizedBox(height: 10),

                  const Chip(
                    label: Text("ACCEPTED"),
                    backgroundColor: Colors.green,
                    labelStyle: TextStyle(color: Colors.white),
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