import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  String? _userName;
  String? _userEmail;
  String? _userBio;
  String? _profileImageUrl;
  TextEditingController _bioController = TextEditingController();
  bool _isEditingBio = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot userData =
          await _firestore.collection('users').doc(user.uid).get();
      setState(() {
        _userName = "${userData['firstName']} ${userData['lastName']}";
        _userEmail = user.email;
        _userBio = userData['bio'];
        _profileImageUrl = userData['profileImageUrl'];
        _bioController.text = _userBio ?? '';
      });
    }
  }

  Future<void> _updateProfileImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      File imageFile = File(image.path);
      User? user = _auth.currentUser;

      if (user != null) {
        try {
          TaskSnapshot uploadTask = await _storage
              .ref('profile_images/${user.uid}.jpg')
              .putFile(imageFile);
          String downloadUrl = await uploadTask.ref.getDownloadURL();

          await _firestore.collection('users').doc(user.uid).update({
            'profileImageUrl': downloadUrl,
          });

          setState(() {
            _profileImageUrl = downloadUrl;
          });
        } catch (e) {
          print("Error updating profile image: $e");
        }
      }
    }
  }

  Future<void> _updateBio() async {
    User? user = _auth.currentUser;
    if (user != null) {
      try {
        await _firestore.collection('users').doc(user.uid).update({
          'bio': _bioController.text,
        });
        setState(() {
          _userBio = _bioController.text;
          _isEditingBio = false;
        });
      } catch (e) {
        print("Error updating bio: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[50],
      appBar: AppBar(
        backgroundColor: Colors.blueGrey[700],
        title: const Text('Profile', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 220,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      image: DecorationImage(
                        image: _profileImageUrl != null
                            ? NetworkImage(_profileImageUrl!)
                            : const AssetImage('assets/default_profile.jpg')
                                as ImageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 24,
                  right: 24,
                  child: FloatingActionButton(
                    onPressed: _updateProfileImage,
                    backgroundColor: Colors.blueGrey[700],
                    child: const Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    _userName ?? 'Loading...',
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueGrey[800]),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _userEmail ?? 'Loading...',
                    style: TextStyle(fontSize: 16, color: Colors.blueGrey[600]),
                  ),
                  const SizedBox(height: 16),
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Bio',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blueGrey[800])),
                              IconButton(
                                icon: Icon(
                                    _isEditingBio ? Icons.save : Icons.edit,
                                    color: Colors.blueGrey[700]),
                                onPressed: () {
                                  if (_isEditingBio) {
                                    _updateBio();
                                  } else {
                                    setState(() => _isEditingBio = true);
                                  }
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          _isEditingBio
                              ? TextField(
                                  controller: _bioController,
                                  maxLines: null,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8)),
                                    hintText: 'Enter your bio...',
                                  ),
                                )
                              : Text(_userBio ?? 'No bio available',
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.blueGrey[600])),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
