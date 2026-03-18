// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
// import 'viewoneworkerdetails.dart';
//
// class ViewNearbyWorkers extends StatefulWidget {
//   const ViewNearbyWorkers({Key? key}) : super(key: key);
//
//   @override
//   State<ViewNearbyWorkers> createState() => _ViewNearbyWorkersState();
// }
//
// class _ViewNearbyWorkersState extends State<ViewNearbyWorkers> {
//   List workers = [];
//   bool isLoading = true;
//   String message = "";
//
//   @override
//   void initState() {
//     super.initState();
//     fetchNearbyWorkers();
//   }
//
//   // 🔹 Fetch Nearby Workers
//   Future<void> fetchNearbyWorkers() async {
//     try {
//       SharedPreferences sh = await SharedPreferences.getInstance();
//       String url = sh.getString('url') ?? '';
//       String lid = sh.getString('lid') ?? '';
//
//       final uri = Uri.parse('$url/view_nearby_workers/');
//
//       final response = await http.post(uri, body: {
//         'lid': lid,
//         'radius': '50',
//       });
//
//       if (response.statusCode == 200) {
//         var data = json.decode(response.body);
//
//         if (data['status'] == 'ok') {
//           setState(() {
//             workers = data['workers'];
//             isLoading = false;
//           });
//         } else {
//           setState(() {
//             message = data['message'] ?? "No workers found";
//             isLoading = false;
//           });
//         }
//       } else {
//         setState(() {
//           message = "Server Error";
//           isLoading = false;
//         });
//       }
//     } catch (e) {
//       setState(() {
//         message = "Error: $e";
//         isLoading = false;
//       });
//     }
//   }
//
//   // 🔹 Send Work Request
//   Future<void> sendRequest(String workId) async {
//     SharedPreferences sh = await SharedPreferences.getInstance();
//     String url = sh.getString('url') ?? '';
//     String lid = sh.getString('lid') ?? '';
//
//     final uri = Uri.parse('$url/send_work_request/');
//
//     final response = await http.post(uri, body: {
//       'lid': lid,
//       'work_id': workId,
//     });
//
//     var data = json.decode(response.body);
//
//     if (data['status'] == 'ok') {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Request Sent Successfully")),
//       );
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Request Failed")),
//       );
//     }
//   }
//
//   Widget workerCard(dynamic worker) {
//     String photo = worker['photo'] ?? '';
//
//     return Card(
//       margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//       elevation: 4,
//       child: Padding(
//         padding: const EdgeInsets.all(10),
//         child: Column(
//           children: [
//             ListTile(
//               leading: photo.isNotEmpty
//                   ? CircleAvatar(
//                 radius: 30,
//                 backgroundImage: NetworkImage(photo),
//               )
//                   : const CircleAvatar(
//                 radius: 30,
//                 child: Icon(Icons.person, size: 30),
//               ),
//               title: Text(
//                 worker['name'] ?? "No Name",
//                 style: const TextStyle(
//                     fontWeight: FontWeight.bold, fontSize: 18),
//               ),
//               subtitle: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text("Job: ${worker['job'] ?? 'N/A'}"),
//                   Text("Place: ${worker['place'] ?? 'N/A'}"),
//                   Text("Experience: ${worker['experience'] ?? 'N/A'}"),
//                   Text(
//                     "Distance: ${worker['distance_km'] ?? '0'} KM",
//                     style: const TextStyle(
//                         color: Colors.green,
//                         fontWeight: FontWeight.bold),
//                   ),
//                   Text("Phone: ${worker['phone'] ?? 'N/A'}"),
//                 ],
//               ),
//             ),
//
//             const SizedBox(height: 10),
//
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 // 🔥 View Work Details Button
//                 ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.blue),
//                   onPressed: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => WorkerWorkDetailsPage(
//                           workerId: worker['worker_id'].toString(), workerName: '',
//                         ),
//                       ),
//                     );
//                   },
//                   child: const Text("View Works"),
//                 ),
//
//                 // 🔥 Send Request Button
//
//               ],
//             )
//           ],
//         ),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Nearby Workers"),
//       ),
//       body: isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : workers.isEmpty
//           ? Center(
//         child: Text(
//           message.isEmpty
//               ? "No Nearby Workers Found"
//               : message,
//           style: const TextStyle(fontSize: 18),
//         ),
//       )
//           : RefreshIndicator(
//         onRefresh: fetchNearbyWorkers,
//         child: ListView.builder(
//           itemCount: workers.length,
//           itemBuilder: (context, index) {
//             return workerCard(workers[index]);
//           },
//         ),
//       ),
//     );
//   }
// }

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'viewoneworkerdetails.dart';
import 'vieweachworkerreview.dart';

class ViewNearbyWorkers extends StatefulWidget {
  const ViewNearbyWorkers({Key? key}) : super(key: key);

  @override
  State<ViewNearbyWorkers> createState() => _ViewNearbyWorkersState();
}

class _ViewNearbyWorkersState extends State<ViewNearbyWorkers> {

  List workers = [];
  bool isLoading = true;
  String message = "";
  String baseUrl = "";

  @override
  void initState() {
    super.initState();
    fetchNearbyWorkers();
  }

  Future<void> fetchNearbyWorkers() async {

    try {

      SharedPreferences sh = await SharedPreferences.getInstance();
      baseUrl = sh.getString('url') ?? '';
      String lid = sh.getString('lid') ?? '';

      final uri = Uri.parse('$baseUrl/view_nearby_workers/');

      final response = await http.post(uri, body: {
        'lid': lid,
        'radius': '50',
      });

      if (response.statusCode == 200) {

        var data = json.decode(response.body);

        if (data['status'] == 'ok') {

          setState(() {
            workers = data['workers'];
            isLoading = false;
          });

        } else {

          setState(() {
            message = data['message'] ?? "No workers found";
            isLoading = false;
          });

        }

      } else {

        setState(() {
          message = "Server Error";
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

  Widget workerCard(dynamic worker) {

    return Card(

      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      elevation: 4,

      child: Padding(
        padding: const EdgeInsets.all(12),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [

            Text(
              worker['name'] ?? "No Name",
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
            ),

            const SizedBox(height: 8),

            Text("Job: ${worker['job'] ?? 'N/A'}"),
            Text("Place: ${worker['place'] ?? 'N/A'}"),
            Text("Experience: ${worker['experience'] ?? 'N/A'}"),

            Text(
              "Distance: ${worker['distance_km'] ?? '0'} KM",
              style: const TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold),
            ),

            Text("Phone: ${worker['phone'] ?? 'N/A'}"),

            const SizedBox(height: 12),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue),
                  onPressed: () {

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => WorkerWorkDetailsPage(
                          workerId: worker['worker_id'].toString(),
                          workerName: worker['name'] ?? '',
                        ),
                      ),
                    );

                  },
                  child: const Text("View Works"),
                ),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange),
                  onPressed: () {

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => WorkerReviewPage(
                          workerId: worker['worker_id'].toString(),
                          workerName: worker['name'] ?? '',
                        ),
                      ),
                    );

                  },
                  child: const Text("View Reviews"),
                ),

              ],
            )

          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Nearby Workers"),
      ),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())

          : workers.isEmpty

          ? Center(
        child: Text(
          message.isEmpty
              ? "No Nearby Workers Found"
              : message,
          style: const TextStyle(fontSize: 18),
        ),
      )

          : RefreshIndicator(

        onRefresh: fetchNearbyWorkers,

        child: ListView.builder(
          itemCount: workers.length,
          itemBuilder: (context, index) {
            return workerCard(workers[index]);
          },
        ),

      ),
    );
  }
}