import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PostDataPage extends StatefulWidget {
  const PostDataPage({super.key});

  @override
  State<PostDataPage> createState() => _PostDataPageState();
}

class _PostDataPageState extends State<PostDataPage> {
  final TextEditingController _name = TextEditingController();

  sendData(name) async {
    var date = DateFormat('HH:mm d MMMM y ').format(DateTime.now());
    debugPrint(date);
    Map<String, dynamic> request = {
      'DateTime': date,
      'Name': name,
    };
    showDialog(
        context: context,
        builder: ((context) {
          return const AlertDialog(
            content: SizedBox(
              height: 80,
              child: Column(
                children: [Text('Sending'), CircularProgressIndicator()],
              ),
            ),
          );
        }));
    var response = await http.post(Uri.parse('--yoursheetAPI--'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(request));
    if (response.statusCode == 302) {
      if (!context.mounted) return;
      debugPrint('succes post data');
      Navigator.pop(context);
    } else {
      throw Exception('Failed send Data ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        margin: const EdgeInsets.all(10),
        child: Column(
          children: [
            TextField(
              controller: _name,
              decoration: const InputDecoration(hintText: 'Name'),
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
                onPressed: () {
                  if (_name.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Fill your name')));
                  } else {
                    sendData(_name.text);
                  }
                },
                child: const Text('Send'))
          ],
        ),
      ),
    );
  }
}
