import 'package:_nehadam/screens/mainFrame_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserNameScreen extends StatefulWidget {
  const UserNameScreen({super.key});

  @override
  _UserNameScreenState createState() => _UserNameScreenState();
}

class _UserNameScreenState extends State<UserNameScreen> {
  final TextEditingController _nameController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void _saveUserName() async {
    String name = _nameController.text.trim();
    User? user = _auth.currentUser;

    if (name.isNotEmpty && user != null) {
      await _firestore.collection('users').doc(user.uid).update({
        'name': name,
      });

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainFrameScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Set User Name'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'User Name'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveUserName,
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
