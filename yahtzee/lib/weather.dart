// experimenting with free dictionary api

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(DictionaryApp());
}

class DictionaryApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dictionary App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: DictionaryScreen(),
    );
  }
}

class Definition {
  final String word;
  final String definition;
  final String example;

  Definition({required this.word, required this.definition, required this.example});

  factory Definition.fromJson(Map<String, dynamic> json) {
    return Definition(
      word: json['word'] ?? '',
      definition: json['meanings'][0]['definitions'][0]['definition'] ?? '',
      example: json['meanings'][0]['definitions'][0]['example'] ?? '',
    );
  }
}

class DictionaryScreen extends StatefulWidget {
  @override
  _DictionaryScreenState createState() => _DictionaryScreenState();
}

class _DictionaryScreenState extends State<DictionaryScreen> {
  final TextEditingController _controller = TextEditingController();
  Future<Definition?>? _futureDefinition;

  Future<Definition?> fetchDefinition(String word) async {
    final response = await http.get(Uri.parse('https://api.dictionaryapi.dev/api/v2/entries/en/$word'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      if (data.isNotEmpty) {
        return Definition.fromJson(data[0]);
      }
    }
    return null;
  }

  void _searchWord() {
    setState(() {
      _futureDefinition = fetchDefinition(_controller.text.trim());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dictionary'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Enter a word',
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: _searchWord,
                ),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: FutureBuilder<Definition?>(
                future: _futureDefinition,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data == null) {
                    return Center(child: Text('No definition found.'));
                  }

                  final definition = snapshot.data!;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        definition.word,
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      Text(definition.definition, style: TextStyle(fontSize: 18)),
                      SizedBox(height: 10),
                      Text(
                        'Example: ${definition.example}',
                        style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
