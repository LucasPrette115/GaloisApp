import 'dart:convert'; // Para base64Decode
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:typed_data'; // Para Uint8List

class HistoryScreen extends StatelessWidget {
  final User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'User History',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
        ),
        actions: [
          IconButton(
            onPressed: () => {Navigator.pushReplacementNamed(context, '/home')},
            icon: Icon(Icons.photo_camera_sharp),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Flexible(
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: FirebaseFirestore.instance
                    .collection('history')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text("No history found."));
                  }

                  var historyDocs = snapshot.data!.docs;

                  return ListView.builder(
                    itemCount: historyDocs.length,
                    itemBuilder: (context, index) {
                      var data = historyDocs[index].data();
                      String? base64Image = data['base64Image'];
                      Uint8List? imageBytes;

                      if (base64Image != null) {
                        imageBytes = base64Decode(base64Image);
                      }

                      return Card(
                        margin: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 0.0),
                        elevation: 3.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Response: ' +
                                    (data['response'] ?? 'No response'),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                data['date']?.toDate().toString() ??
                                    'No date available',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.blueGrey,
                                ),
                              ),
                              const SizedBox(height: 10),
                              if (imageBytes != null)
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.memory(
                                    imageBytes,
                                    width: double.infinity,
                                    height: 200,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              else
                                const Text('No Image',
                                    style: TextStyle(color: Colors.red)),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  translateMessage(String id, doc) {}
}
