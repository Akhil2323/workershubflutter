import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login.dart';
import 'viewworkerprofile.dart';
import 'addworkdetails.dart';
import 'viewworkdetails.dart';
import 'workerviewrquest.dart';
import 'workviewacceptrequest.dart';
import 'workersviewrejecetedwork.dart';
import 'changepassword.dart';
import 'workerviewpayement.dart';
import 'viewreviewworker.dart';

class WorkerHomePage extends StatelessWidget {
  const WorkerHomePage({super.key});

  Future<void> logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // keep server URL safe
    String? url = prefs.getString('url');
    await prefs.clear();
    if (url != null) {
      await prefs.setString('url', url);
    }

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => const MyLoginPage(title: "Login"),
      ),
          (route) => false,
    );
  }

  Widget menuCard(
      BuildContext context, IconData icon, String title, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 8,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: const Color(0xFF14b8a6)),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget actionButton(
      BuildContext context, String title, IconData icon, VoidCallback onTap) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: Icon(icon),
        label: Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF14b8a6),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      appBar: AppBar(
        title: const Text(
          "Worker Dashboard",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF14b8a6),
        actions: [
          IconButton(
            onPressed: () => logout(context),
            icon: const Icon(Icons.logout),
          )
        ],
      ),
      body: Column(
        children: [
          // 🔹 HEADER
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(25),
            decoration: const BoxDecoration(
              color: Color(0xFF14b8a6),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(25),
                bottomRight: Radius.circular(25),
              ),
            ),
            child: const Column(
              children: [
                Icon(Icons.engineering, size: 60, color: Colors.white),
                SizedBox(height: 10),
                Text(
                  "Welcome Worker",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  "Manage your work requests and profile",
                  style: TextStyle(color: Colors.white70),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // 🔹 ADD & VIEW WORK BUTTONS
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                actionButton(
                  context,
                  "Add Work Details",
                  Icons.add_circle,
                      () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const WorkerAddWorkPage()),
                    );
                  },
                ),
                const SizedBox(height: 12),
                actionButton(
                  context,
                  "View My Work",
                  Icons.work_outline,
                      () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const WorkerViewWorkPage()),
                    );
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // 🔹 MENU GRID
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                children: [
                  menuCard(
                    context,
                    Icons.person,
                    "My Profile",
                        () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const WorkerProfilePage()),
                      );
                    },
                  ),
                  menuCard(
                    context,
                    Icons.build,
                    "Manage Work",
                        () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const WorkerViewWorkPage()),
                      );
                    },
                  ),
                  menuCard(
                    context,
                    Icons.build,
                    "view request",
                        () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const WorkerViewRequests()),
                      );
                    },
                  ),
              menuCard(
                context,
                Icons.build,
                "view accept work",
                    () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const AcceptedWorkPage()),
                  );
                },
              ),
                  menuCard(
                    context,
                    Icons.build,
                    "view reject work",
                        () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const RejectedWorkPage()),
                      );
                    },
                  ),
                  menuCard(
                    context,
                    Icons.build,
                    "change password",
                        () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const changepassword(title: '',)),
                      );
                    },
                  ),

                  menuCard(
                    context,
                    Icons.build,
                    "view payment",
                        () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const WorkerViewPaymentsPage()),
                      );
                    },
                  ),

                  menuCard(
                    context,
                    Icons.build,
                    "view review  ",
                        () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const WorkerViewReviewsPage()),
                      );
                    },
                  ),




                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}