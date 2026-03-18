// import 'dart:convert';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:http/http.dart' as http;
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// class WorkerEditProfilePage extends StatefulWidget {
//   const WorkerEditProfilePage({super.key});
//
//   @override
//   State<WorkerEditProfilePage> createState() =>
//       _WorkerEditProfilePageState();
// }
//
// class _WorkerEditProfilePageState extends State<WorkerEditProfilePage> {
//   final _formKey = GlobalKey<FormState>();
//   bool isLoading = false;
//
//   TextEditingController nameController = TextEditingController();
//   TextEditingController phoneController = TextEditingController();
//   TextEditingController placeController = TextEditingController();
//   TextEditingController postController = TextEditingController();
//   TextEditingController pinController = TextEditingController();
//   TextEditingController jobController = TextEditingController();
//   TextEditingController expController = TextEditingController();
//
//   File? _image;
//   final picker = ImagePicker();
//
//   List categories = [];
//   String? selectedCategory;
//   String serverUrl = "";
//   String currentPhoto = ""; // 🔥 store existing photo
//
//   @override
//   void initState() {
//     super.initState();
//     loadCategories();
//     loadProfile();
//   }
//
//   Future<void> loadCategories() async {
//     SharedPreferences sp = await SharedPreferences.getInstance();
//     String url = sp.getString('url') ?? '';
//     serverUrl = url;
//
//     final response =
//     await http.get(Uri.parse('$url/view_category/'));
//
//     if (response.statusCode == 200) {
//       final data = jsonDecode(response.body);
//       setState(() {
//         categories = data['data'];
//       });
//     }
//   }
//
//   Future<void> loadProfile() async {
//     SharedPreferences sp = await SharedPreferences.getInstance();
//     String url = sp.getString('url') ?? '';
//     String lid = sp.getString('lid') ?? '';
//
//     // ensure slash
//     if (!url.endsWith("/")) {
//       url = "$url/";
//     }
//     serverUrl = url;
//
//     final response = await http.post(
//       Uri.parse('${url}worker_view_profile/'),
//       body: {'lid': lid},
//     );
//
//     final data = jsonDecode(response.body);
//
//     if (data['status'] == 'ok') {
//       // 🔥 FIX IMAGE URL (same logic as profile page)
//       String imagePath = data['photo'].toString();
//       String finalPhoto = "";
//
//       if (imagePath.isNotEmpty) {
//         if (imagePath.startsWith("/media/")) {
//           String serverBase = url.replaceAll("myapp/", "");
//           finalPhoto = serverBase + imagePath;
//         } else {
//           finalPhoto = url + imagePath;
//         }
//       }
//
//       setState(() {
//         nameController.text = data['name'];
//         phoneController.text = data['phone'];
//         placeController.text = data['place'];
//         postController.text = data['post'];
//         pinController.text = data['pin'];
//         jobController.text = data['job'];
//         expController.text = data['experience'];
//         currentPhoto = finalPhoto; // 🔥 show existing image
//         selectedCategory = data['category_id']?.toString(); // 🔥 default category
//       });
//     }
//   }
//
//   Future<void> pickImage() async {
//     final picked =
//     await picker.pickImage(source: ImageSource.gallery);
//     if (picked != null) {
//       setState(() {
//         _image = File(picked.path);
//       });
//     }
//   }
//
//   Future<void> updateProfile() async {
//     if (!_formKey.currentState!.validate()) return;
//
//     setState(() => isLoading = true);
//
//     SharedPreferences sp = await SharedPreferences.getInstance();
//     String url = sp.getString('url') ?? '';
//     String lid = sp.getString('lid') ?? '';
//
//     var request = http.MultipartRequest(
//       'POST',
//       Uri.parse('$url/worker_edit_profile/'),
//     );
//
//     request.fields['lid'] = lid;
//     request.fields['name'] = nameController.text;
//     request.fields['phone'] = phoneController.text;
//     request.fields['place'] = placeController.text;
//     request.fields['post'] = postController.text;
//     request.fields['pin'] = pinController.text;
//     request.fields['job'] = jobController.text;
//     request.fields['experience'] = expController.text;
//     request.fields['category'] = selectedCategory ?? '';
//
//     if (_image != null) {
//       request.files.add(
//         await http.MultipartFile.fromPath('photo', _image!.path),
//       );
//     }
//
//     var response = await request.send();
//     var res = await http.Response.fromStream(response);
//     final data = jsonDecode(res.body);
//
//     setState(() => isLoading = false);
//
//     if (data['status'] == 'ok') {
//       Fluttertoast.showToast(msg: "Profile Updated Successfully");
//       Navigator.pop(context);
//     } else {
//       Fluttertoast.showToast(msg: "Update Failed");
//     }
//   }
//
//   Widget textField(TextEditingController c, String label) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 15),
//       child: TextFormField(
//         controller: c,
//         validator: (v) =>
//         v == null || v.isEmpty ? 'Enter $label' : null,
//         decoration: InputDecoration(
//           labelText: label,
//           border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(12)),
//         ),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     ImageProvider? imageProvider;
//
//     // 🔥 SHOW SELECTED IMAGE OR EXISTING IMAGE
//     if (_image != null) {
//       imageProvider = FileImage(_image!);
//     } else if (currentPhoto.isNotEmpty) {
//       imageProvider = NetworkImage(currentPhoto);
//     }
//
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Edit Profile"),
//         backgroundColor: const Color(0xFF14b8a6),
//       ),
//       body: isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             children: [
//               GestureDetector(
//                 onTap: pickImage,
//                 child: CircleAvatar(
//                   radius: 60,
//                   backgroundColor: Colors.grey.shade300,
//                   backgroundImage: imageProvider,
//                   child: imageProvider == null
//                       ? const Icon(Icons.camera_alt, size: 40)
//                       : null,
//                 ),
//               ),
//               const SizedBox(height: 20),
//               textField(nameController, "Name"),
//               textField(phoneController, "Phone"),
//               textField(placeController, "Place"),
//               textField(postController, "Post"),
//               textField(pinController, "Pin"),
//               textField(jobController, "Job"),
//               textField(expController, "Experience"),
//
//               // 🔥 CATEGORY WITH DEFAULT VALUE
//               DropdownButtonFormField(
//                 value: selectedCategory,
//                 hint: const Text("Select Category"),
//                 items: categories.map<DropdownMenuItem>((cat) {
//                   return DropdownMenuItem(
//                     value: cat['id'].toString(),
//                     child: Text(cat['type']),
//                   );
//                 }).toList(),
//                 onChanged: (val) {
//                   setState(() {
//                     selectedCategory = val.toString();
//                   });
//                 },
//                 decoration: InputDecoration(
//                   border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12)),
//                 ),
//               ),
//
//               const SizedBox(height: 25),
//
//               SizedBox(
//                 width: double.infinity,
//                 height: 50,
//                 child: ElevatedButton(
//                   onPressed: updateProfile,
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: const Color(0xFF14b8a6),
//                   ),
//                   child: const Text(
//                     "UPDATE PROFILE",
//                     style: TextStyle(fontSize: 16),
//                   ),
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }



import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WorkerEditProfilePage extends StatefulWidget {
  const WorkerEditProfilePage({super.key});

  @override
  State<WorkerEditProfilePage> createState() =>
      _WorkerEditProfilePageState();
}

class _WorkerEditProfilePageState extends State<WorkerEditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController placeController = TextEditingController();
  TextEditingController postController = TextEditingController();
  TextEditingController pinController = TextEditingController();
  TextEditingController jobController = TextEditingController();
  TextEditingController expController = TextEditingController();

  File? _image;
  final picker = ImagePicker();

  List categories = [];
  String? selectedCategory;
  String serverUrl = "";
  String currentPhoto = "";
  String? categoryFromApi; // 🔥 store FK from API

  @override
  void initState() {
    super.initState();
    initLoad();
  }

  Future<void> initLoad() async {
    await loadCategories();
    await loadProfile();
  }

  // 🔥 LOAD CATEGORY
  Future<void> loadCategories() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    String url = sp.getString('url') ?? '';

    if (!url.endsWith("/")) url = "$url/";
    serverUrl = url;

    final response = await http.get(Uri.parse('${url}view_category/'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      setState(() {
        categories = data['data'];
      });
    }
  }

  // 🔥 LOAD PROFILE
  Future<void> loadProfile() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    String url = sp.getString('url') ?? '';
    String lid = sp.getString('lid') ?? '';

    if (!url.endsWith("/")) url = "$url/";

    final response = await http.post(
      Uri.parse('${url}worker_view_profile/'),
      body: {'lid': lid},
    );

    final data = jsonDecode(response.body);

    if (data['status'] == 'ok') {
      String imagePath = data['photo'].toString();
      String finalPhoto = "";

      if (imagePath.isNotEmpty) {
        if (imagePath.startsWith("/media/")) {
          String serverBase = url.replaceAll("myapp/", "");
          finalPhoto = serverBase + imagePath;
        } else {
          finalPhoto = url + imagePath;
        }
      }

      categoryFromApi = data['category_id']?.toString();

      setState(() {
        nameController.text = data['name'];
        phoneController.text = data['phone'];
        placeController.text = data['place'];
        postController.text = data['post'];
        pinController.text = data['pin'];
        jobController.text = data['job'];
        expController.text = data['experience'];
        currentPhoto = finalPhoto;
      });

      // 🔥 SET DEFAULT CATEGORY AFTER BOTH LOADED
      setDefaultCategory();
    }
  }

  // 🔥 IMPORTANT FIX
  void setDefaultCategory() {
    if (categories.isNotEmpty && categoryFromApi != null) {
      bool exists = categories.any(
              (cat) => cat['id'].toString() == categoryFromApi);

      if (exists) {
        setState(() {
          selectedCategory = categoryFromApi;
        });
      }
    }
  }

  Future<void> pickImage() async {
    final picked =
    await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _image = File(picked.path);
      });
    }
  }

  // 🔥 UPDATE PROFILE
  Future<void> updateProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    SharedPreferences sp = await SharedPreferences.getInstance();
    String url = sp.getString('url') ?? '';
    String lid = sp.getString('lid') ?? '';

    if (!url.endsWith("/")) url = "$url/";

    var request = http.MultipartRequest(
      'POST',
      Uri.parse('${url}worker_edit_profile/'),
    );

    request.fields['lid'] = lid;
    request.fields['name'] = nameController.text;
    request.fields['phone'] = phoneController.text;
    request.fields['place'] = placeController.text;
    request.fields['post'] = postController.text;
    request.fields['pin'] = pinController.text;
    request.fields['job'] = jobController.text;
    request.fields['experience'] = expController.text;

    // 🔥 IMPORTANT: send correct FK
    request.fields['category'] = selectedCategory ?? '';

    print("Sending category: $selectedCategory"); // debug

    if (_image != null) {
      request.files.add(
        await http.MultipartFile.fromPath('photo', _image!.path),
      );
    }

    var response = await request.send();
    var res = await http.Response.fromStream(response);
    final data = jsonDecode(res.body);

    setState(() => isLoading = false);

    if (data['status'] == 'ok') {
      Fluttertoast.showToast(msg: "Profile Updated Successfully");
      Navigator.pop(context);
    } else {
      Fluttertoast.showToast(msg: "Update Failed");
    }
  }

  Widget textField(TextEditingController c, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextFormField(
        controller: c,
        validator: (v) =>
        v == null || v.isEmpty ? 'Enter $label' : null,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ImageProvider? imageProvider;

    if (_image != null) {
      imageProvider = FileImage(_image!);
    } else if (currentPhoto.isNotEmpty) {
      imageProvider = NetworkImage(currentPhoto);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profile"),
        backgroundColor: const Color(0xFF14b8a6),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              GestureDetector(
                onTap: pickImage,
                child: CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.grey.shade300,
                  backgroundImage: imageProvider,
                  child: imageProvider == null
                      ? const Icon(Icons.camera_alt, size: 40)
                      : null,
                ),
              ),
              const SizedBox(height: 20),

              textField(nameController, "Name"),
              textField(phoneController, "Phone"),
              textField(placeController, "Place"),
              textField(postController, "Post"),
              textField(pinController, "Pin"),
              textField(jobController, "Job"),
              textField(expController, "Experience"),

              DropdownButtonFormField(
                value: selectedCategory,
                hint: const Text("Select Category"),
                items: categories.map<DropdownMenuItem>((cat) {
                  return DropdownMenuItem(
                    value: cat['id'].toString(),
                    child: Text(cat['type']),
                  );
                }).toList(),
                onChanged: (val) {
                  setState(() {
                    selectedCategory = val.toString();
                  });
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),

              const SizedBox(height: 25),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: updateProfile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF14b8a6),
                  ),
                  child: const Text(
                    "UPDATE PROFILE",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}