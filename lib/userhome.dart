import 'package:flutter/material.dart';
import 'login.dart';
import 'viewuserprofile.dart';
import 'viewnearbyworkers.dart';
import 'usersendcomplaint.dart';
import 'viewcomplaint.dart';
import 'userviewworkdetail.dart';
import 'viewrequeststatususer.dart';
import 'sendreview.dart';
import 'viewreview.dart';
import 'changepassword.dart';
import 'userviewpayement.dart';

class UserHomePage extends StatelessWidget {
  const UserHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFf8fafc),
      appBar: AppBar(
        title: const Text(
          'User Home',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF14b8a6),
        elevation: 2,
        actions: [
          TextButton.icon(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (_) => const MyLoginPage(title: 'Login'),
                ),
                    (route) => false,
              );
            },
            icon: const Icon(Icons.logout, color: Colors.white),
            label: const Text(
              'Logout',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [

              const SizedBox(height: 10),

              // Welcome Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF14b8a6),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    )
                  ],
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Welcome User 👋",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Manage all your activities easily",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              // VIEW PROFILE
              _buildButton(
                context,
                icon: Icons.person,
                text: "View Profile",
                color: const Color(0xFF14b8a6),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => ViewProfilePage()),
                  );
                },
              ),

              const SizedBox(height: 12),

              // VIEW NEARBY WORKERS (LOCATION)
              _buildButton(
                context,
                icon: Icons.location_on,
                text: "View Nearby Workers",
                color: Colors.blue,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => ViewNearbyWorkers()),
                  );
                },
              ),

              const SizedBox(height: 12),

              // SEND REQUEST
              _buildButton(
                context,
                icon: Icons.send,
                text: "view workers",
                color: Colors.green,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => UserViewWorkPage()),
                  );
                },
              ),


              const SizedBox(height: 12),

              // VIEW REQUEST STATUS
              _buildButton(
                context,
                icon: Icons.assignment,
                text: "View Request Status",
                color: Colors.indigo,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => ViewRequestStatusPage()),
                  );
                },
              ),


              const SizedBox(height: 12),

              // SEND PAYMENT
              _buildButton(
                context,
                icon: Icons.payment,
                text: "view payement",
                color: Colors.purple,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => ViewPaymentHistoryPage()),
                  );
                },
              ),

              const SizedBox(height: 12),

              // SEND COMPLAINT
              _buildButton(
                context,
                icon: Icons.report_problem,
                text: "Send Complaint",
                color: Colors.orange,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => SendComplaintPage()),
                  );
                },
              ),

              const SizedBox(height: 12),

              // VIEW COMPLAINT (WITH REPLY)
              _buildButton(
                context,
                icon: Icons.visibility,
                text: "View Complaint & Reply",
                color: Colors.deepOrange,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => ViewComplaintPage()),
                  );
                },
              ),

              const SizedBox(height: 12),

              // VIEW COMPLAINT (WITH REPLY)
              _buildButton(
                context,
                icon: Icons.visibility,
                text: "View Review",
                color: Colors.deepOrange,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => ViewReviewPage()),
                  );
                },
              ),


              const SizedBox(height: 12),

              // SEND REVIEW
              _buildButton(
                context,
                icon: Icons.star,
                text: "Send Review",
                color: Colors.amber,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => SendReviewPage()),
                  );
                },
              ),

              const SizedBox(height: 12),

              // CHANGE PASSWORD
              _buildButton(
                context,
                icon: Icons.lock,
                text: "Change Password",
                color: Colors.red,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => changepassword(title: '',)),
                  );
                },
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButton(BuildContext context,
      {required IconData icon,
        required String text,
        required Color color,
        required VoidCallback onPressed}) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton.icon(
        icon: Icon(icon, size: 24),
        label: Text(
          text,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        onPressed: onPressed,
      ),
    );
  }
}