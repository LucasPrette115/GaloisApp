import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EquationSolverScreen extends StatefulWidget {
  @override
  _EquationSolverScreenState createState() => _EquationSolverScreenState();
}

class _EquationSolverScreenState extends State<EquationSolverScreen> {
  XFile? _image;
  String? _base64Image;
  final picker = ImagePicker();
  String _result = "Result will be shown here";
  var user = (FirebaseAuth.instance).currentUser;
  bool _isLoading = false;

  Future<void> _getImage(ImageSource source) async {
    setState(() {
      _isLoading = true;
    });

    final pickedFile = await picker.pickImage(source: source);

    setState(() {
      if (pickedFile != null) {
        _image = pickedFile;
      }
      _isLoading = false;
    });
  }

  Future<void> _solveEquation() async {
    if (_image == null) {
      _showSnackBar("Please capture or select an image first");
      return;
    }

    try {
      final model = GenerativeModel(
        model: 'gemini-1.5-flash-latest',
        apiKey: 'api_key',
      );

      final bytes = await _image!.readAsBytes();
      _base64Image = base64Encode(bytes);

      const prompt = 'Solve this problem and return only its answer';

      final content = [
        Content.multi([
          TextPart(prompt),
          DataPart('image/jpeg', bytes),
        ])
      ];
      final response = await model.generateContent(content);
      final responseText = response.text;
      var data = {
        "user_id": user!.uid,
        "response": responseText,
        "base64Image": _base64Image,
        "date": DateTime.now(),
      };

      FirebaseFirestore.instance.collection('history').add(data);

      setState(() {
        _result = "Response: $responseText";
      });
    } catch (e) {
      _showSnackBar("Error: $e");
    }
  }

  void signOut(BuildContext context) async {
    await (FirebaseAuth.instance).signOut();
    Navigator.pushReplacementNamed(context, '/login');
  }

  void accessHistory(BuildContext context) async {
    Navigator.pushReplacementNamed(context, '/history');
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: Colors.red,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Center(child: Text('Galois')),
          leading: IconButton(
            onPressed: () => signOut(context),
            icon: Icon(Icons.logout),
          ),
          actions: [
            IconButton(
              onPressed: () => accessHistory(context),
              icon: Icon(Icons.history),
            )
          ]),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_isLoading)
                CircularProgressIndicator()
              else if (_image == null)
                Text('No image selected.')
              else
                Image.network(_image!.path, height: 200),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: () async => await _getImage(ImageSource.camera),
                    icon: Icon(Icons.camera),
                    label: Text('Capture Image'),
                  ),
                  ElevatedButton.icon(
                    onPressed: () async => await _getImage(ImageSource.gallery),
                    icon: Icon(Icons.photo),
                    label: Text('Pick from Gallery'),
                  ),
                ],
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _solveEquation,
                child: Text('Solve Equation'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                ),
              ),
              SizedBox(height: 20),
              Text(
                _result,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
