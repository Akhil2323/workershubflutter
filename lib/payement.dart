// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:fluttertoast/fluttertoast.dart';
//
// class PaymentPage extends StatefulWidget {
//   final String workerId;
//   final String workerName;
//   final String amount;
//
//   const PaymentPage({
//     super.key,
//     required this.workerId,
//     required this.workerName,
//     required this.amount,
//   });
//
//   @override
//   State<PaymentPage> createState() => _PaymentPageState();
// }
//
// class _PaymentPageState extends State<PaymentPage> {
//   bool isLoading = false;
//
//   Future<void> makePayment() async {
//     setState(() => isLoading = true);
//
//     SharedPreferences sp = await SharedPreferences.getInstance();
//     String url = sp.getString('url') ?? "";
//     String lid = sp.getString('lid') ?? "";
//
//     final response = await http.post(
//       Uri.parse("$url/myapp/make_payment/"),
//       body: {
//         'lid': lid,
//         'worker_id': widget.workerId,
//         'amount': widget.amount,
//       },
//     );
//
//     final data = jsonDecode(response.body);
//     setState(() => isLoading = false);
//
//     if (data['status'] == 'ok') {
//       Fluttertoast.showToast(msg: "Payment Successful");
//       Navigator.pop(context);
//     } else if (data['status'] == 'already_paid') {
//       Fluttertoast.showToast(msg: "Already Paid");
//     } else {
//       Fluttertoast.showToast(msg: "Payment Failed");
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Payment"),
//         backgroundColor: const Color(0xFF14b8a6),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Card(
//           elevation: 5,
//           child: Padding(
//             padding: const EdgeInsets.all(20),
//             child: Column(
//               children: [
//                 const Icon(Icons.payment,
//                     size: 70, color: Color(0xFF14b8a6)),
//                 const SizedBox(height: 20),
//                 Text(
//                   widget.workerName,
//                   style: const TextStyle(
//                       fontSize: 20, fontWeight: FontWeight.bold),
//                 ),
//                 const SizedBox(height: 10),
//                 Text(
//                   "Amount to Pay: ₹${widget.amount}",
//                   style: const TextStyle(fontSize: 18),
//                 ),
//                 const SizedBox(height: 40),
//                 SizedBox(
//                   width: double.infinity,
//                   height: 50,
//                   child: ElevatedButton(
//                     onPressed: isLoading ? null : makePayment,
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: const Color(0xFF14b8a6),
//                     ),
//                     child: isLoading
//                         ? const CircularProgressIndicator(
//                         color: Colors.white)
//                         : const Text(
//                       "CONFIRM PAYMENT",
//                       style: TextStyle(fontSize: 16),
//                     ),
//                   ),
//                 )
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// // import 'dart:convert';
// // import 'package:flutter/material.dart';
// // import 'package:fluttertoast/fluttertoast.dart';
// // import 'package:http/http.dart' as http;
// // import 'package:razorpay_flutter/razorpay_flutter.dart';
// // import 'package:shared_preferences/shared_preferences.dart';
// //
// // class PaymentPage extends StatefulWidget {
// //   final String workerId;
// //   final String workerName;
// //   final String amount;
// //   final String requestId;
// //
// //   const PaymentPage({
// //     super.key,
// //     required this.workerId,
// //     required this.workerName,
// //     required this.amount,
// //     required this.requestId,
// //   });
// //
// //   @override
// //   State<PaymentPage> createState() => _PaymentPageState();
// // }
// //
// // class _PaymentPageState extends State<PaymentPage> {
// //   late Razorpay _razorpay;
// //   bool _isProcessing = false;
// //   String baseUrl = "";
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //
// //     _razorpay = Razorpay();
// //     _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
// //     _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
// //     _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
// //
// //     _loadBaseUrl();
// //   }
// //
// //   Future<void> _loadBaseUrl() async {
// //     SharedPreferences sp = await SharedPreferences.getInstance();
// //     baseUrl = sp.getString("url") ?? "";
// //   }
// //
// //   @override
// //   void dispose() {
// //     _razorpay.clear();
// //     super.dispose();
// //   }
// //
// //   // ================= OPEN RAZORPAY =================
// //
// //   void _openCheckout() {
// //     if (widget.amount.isEmpty) {
// //       Fluttertoast.showToast(msg: "Invalid Amount");
// //       return;
// //     }
// //
// //     setState(() => _isProcessing = true);
// //
// //     var options = {
// //       'key': 'rzp_test_HKCAwYtLt0rwQe',
// //       'amount': (double.parse(widget.amount) * 100).toInt(),
// //       'name': widget.workerName,
// //       'description': 'Worker Service Payment',
// //       'prefill': {
// //         'contact': '9999999999',
// //         'email': 'user@email.com',
// //       },
// //       'theme': {'color': '#14b8a6'}
// //     };
// //
// //     try {
// //       _razorpay.open(options);
// //     } catch (e) {
// //       setState(() => _isProcessing = false);
// //       Fluttertoast.showToast(msg: "Payment Error");
// //     }
// //   }
// //
// //   // ================= SUCCESS =================
// //
// //   void _handlePaymentSuccess(PaymentSuccessResponse response) {
// //     _savePayment();
// //   }
// //
// //   // ================= FAILURE =================
// //
// //   void _handlePaymentError(PaymentFailureResponse response) {
// //     setState(() => _isProcessing = false);
// //     Fluttertoast.showToast(msg: "Payment Failed ❌");
// //   }
// //
// //   void _handleExternalWallet(ExternalWalletResponse response) {
// //     Fluttertoast.showToast(msg: "Wallet: ${response.walletName}");
// //   }
// //
// //   // ================= SAVE TO DJANGO =================
// //
// //   Future<void> _savePayment() async {
// //     SharedPreferences sp = await SharedPreferences.getInstance();
// //     String lid = sp.getString("lid") ?? "";
// //
// //
// //       final response = await http.post(
// //         Uri.parse("$baseUrl/make_payment/"),
// //         body: {
// //           'lid': lid,
// //           'worker_id': widget.workerId,
// //           'request_id': widget.requestId,
// //           'amount': widget.amount,
// //         },
// //       );
// //
// //       final data = jsonDecode(response.body);
// //
// //       setState(() => _isProcessing = false);
// //
// //       if (data['status'] == 'ok') {
// //         Fluttertoast.showToast(msg: "Payment Successful ✅");
// //         Navigator.pop(context);
// //       } else if (data['status'] == 'already_paid') {
// //         Fluttertoast.showToast(msg: "Already Paid");
// //       } else {
// //         Fluttertoast.showToast(msg: "Payment Failed");
// //       }
// //
// //   }
// //
// //   // ================= UI =================
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     double amount = double.tryParse(widget.amount) ?? 0;
// //
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: const Text("Payment"),
// //         backgroundColor: const Color(0xFF14b8a6),
// //       ),
// //       body: Padding(
// //         padding: const EdgeInsets.all(20),
// //         child: Card(
// //           elevation: 6,
// //           shape:
// //           RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
// //           child: Padding(
// //             padding: const EdgeInsets.all(25),
// //             child: Column(
// //               mainAxisSize: MainAxisSize.min,
// //               children: [
// //                 const Icon(Icons.payment,
// //                     size: 80, color: Color(0xFF14b8a6)),
// //                 const SizedBox(height: 20),
// //
// //                 Text(
// //                   widget.workerName,
// //                   style: const TextStyle(
// //                       fontSize: 22, fontWeight: FontWeight.bold),
// //                 ),
// //
// //                 const SizedBox(height: 15),
// //
// //                 Text(
// //                   "Amount to Pay: ₹${amount.toStringAsFixed(2)}",
// //                   style: const TextStyle(
// //                       fontSize: 20, fontWeight: FontWeight.w500),
// //                 ),
// //
// //                 const SizedBox(height: 35),
// //
// //                 SizedBox(
// //                   width: double.infinity,
// //                   height: 55,
// //                   child: ElevatedButton(
// //                     onPressed: _isProcessing ? null : _openCheckout,
// //                     style: ElevatedButton.styleFrom(
// //                       backgroundColor: const Color(0xFF14b8a6),
// //                       shape: RoundedRectangleBorder(
// //                         borderRadius: BorderRadius.circular(12),
// //                       ),
// //                     ),
// //                     child: _isProcessing
// //                         ? const CircularProgressIndicator(
// //                         color: Colors.white)
// //                         : const Text(
// //                       "PAY NOW",
// //                       style: TextStyle(
// //                           fontSize: 16,
// //                           fontWeight: FontWeight.bold),
// //                     ),
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workershub/viewrequeststatususer.dart';

class PaymentPage extends StatefulWidget {
  final String amount;
  final String worker_id;

  const PaymentPage({super.key, required this.amount, required this.worker_id});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  late Razorpay _razorpay;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  // ---------------- PAYMENT CALLBACKS ----------------

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    _isProcessing = false;
    _sendData();

    Fluttertoast.showToast(
      msg: "Payment Successful ✅",
      backgroundColor: Colors.green,
      textColor: Colors.white,
    );
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    _isProcessing = false;

    print("RAZORPAY ERROR CODE: ${response.code}");
    print("RAZORPAY ERROR MESSAGE: ${response.message}");

    Fluttertoast.showToast(
      msg: "Payment Failed ❌",
      backgroundColor: Colors.red,
      textColor: Colors.white,
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    _isProcessing = false;
    Fluttertoast.showToast(
      msg: "Wallet: ${response.walletName}",
      backgroundColor: Colors.green,
      textColor: Colors.white,
    );
  }

  // ---------------- OPEN RAZORPAY ----------------

  void _openCheckout() {
    setState(() => _isProcessing = true);

    var options = {
      'key': 'rzp_test_HKCAwYtLt0rwQe',
      'amount': (double.parse(widget.amount) * 100).round(),
      'name': 'MindWell',
      'description': 'Mental Wellness Service Payment',
      'prefill': {'contact': '9876543210', 'email': 'support@mindwell.in'},
      'theme': {'color': '#6A1B9A'},
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      _isProcessing = false;
      Fluttertoast.showToast(
        msg: "Payment initialization failed",
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  // ---------------- SEND DATA TO BACKEND ----------------

  void _sendData() async {
    SharedPreferences sh = await SharedPreferences.getInstance();
    String url = sh.getString('url') ?? '';
    String lid = sh.getString('lid') ?? '';

    try {
      var response = await http.post(
        Uri.parse('$url/make_payment/'),
        body: {'lid': lid, 'request_id': widget.worker_id,'amount':widget.amount.toString()},
      );

      var data = jsonDecode(response.body);

      if (data['status'] == 'ok') {
        Fluttertoast.showToast(
          msg: 'Payment recorded successfully 🧠',
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => ViewRequestStatusPage()),
        );
      } else {
        Fluttertoast.showToast(
          msg: 'Payment successful, but server update failed',
          backgroundColor: Colors.orange,
          textColor: Colors.white,
        );
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Network error',
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  // ---------------- UI ----------------

  @override
  Widget build(BuildContext context) {
    double amount = double.tryParse(widget.amount) ?? 0;

    return Scaffold(
      backgroundColor: const Color(0xFFF3E5F5),
      body: SafeArea(
        child: Column(children: [_header(), Expanded(child: _content(amount))]),
      ),
    );
  }

  Widget _header() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF6A1B9A), Color(0xFF9C27B0)],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          const SizedBox(width: 10),
          const Text(
            "MindWell",
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _content(double amount) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.purple.withOpacity(0.2),
                  blurRadius: 15,
                ),
              ],
            ),
            child: Column(
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [Color(0xFF6A1B9A), Color(0xFFBA68C8)],
                    ),
                  ),
                  child: Center(
                    child: Text(
                      "₹${amount.toStringAsFixed(2)}",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                const Text(
                  "Wellness Service Fee",
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 10),
                const Text(
                  "MindWell – Mental Wellness Platform",
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.lock, color: Colors.purple),
                    SizedBox(width: 8),
                    Text(
                      "Secure & Confidential Payment",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          SizedBox(
            width: double.infinity,
            height: 55,
            child: ElevatedButton.icon(
              onPressed: _isProcessing ? null : _openCheckout,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6A1B9A),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              icon:
              _isProcessing
                  ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
                  : const Icon(Icons.psychology, color: Colors.white),
              label: Text(
                _isProcessing ? "Processing..." : "Pay MindWell Fee",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}