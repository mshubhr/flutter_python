import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:to_do_flutter_python/screens/profile_detail_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List profiles = [];
  final TextEditingController controller = TextEditingController();
  bool isLoading = false;
  String? errorMessage;

  final String baseUrl = 'http://192.168.0.107:5000';
  // final String baseUrl = 'http://127.0.0.1:5000';

  Future<void> fetchProfiles() async {
    setState(() => isLoading = true);
    try {
      final response = await http.get(Uri.parse('$baseUrl/tasks'));
      if (response.statusCode == 200) {
        profiles = jsonDecode(response.body);
      } else {
        errorMessage = 'Failed to load profiles';
      }
    } catch (_) {
      errorMessage = 'Network error';
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> addProfile(String name) async {
    if (name.trim().isEmpty) return;
    try {
      await http.post(
        Uri.parse('$baseUrl/tasks'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'title': name}),
      );
      controller.clear();
      fetchProfiles();
    } catch (_) {
      setState(() => errorMessage = 'Failed to add profile.');
    }
  }

  Future<void> deleteProfile(int id) async {
    try {
      await http.delete(Uri.parse('$baseUrl/tasks/$id'));
      fetchProfiles();
    } catch (_) {
      setState(() => errorMessage = 'Failed to delete profile.');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchProfiles();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Clink Dating'),
        backgroundColor: Colors.lightBlueAccent,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: controller,
              decoration: InputDecoration(
                labelText: 'Enter your name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.favorite, color: Colors.lightBlue),
                  onPressed: () => addProfile(controller.text),
                ),
              ),
            ),
            const SizedBox(height: 12),
            if (errorMessage != null)
              Text(errorMessage!,
                  style: const TextStyle(color: Colors.redAccent)),
            const SizedBox(height: 20),
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : profiles.isEmpty
                      ? const Center(
                          child: Text(
                            'No profiles yet.\nAdd one to start matching!',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.grey),
                          ),
                        )
                      : ListView.builder(
                          itemCount: profiles.length,
                          itemBuilder: (context, index) {
                            final profile = profiles[index];
                            return Card(
                              elevation: 3,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: Colors.lightBlueAccent,
                                  child: Text(
                                    profile['title'][0].toUpperCase(),
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                                title: Text(
                                  profile['title'],
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: const Text('Looking for a match 💫'),
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        ProfileDetail(profile: profile),
                                  ),
                                ),
                                trailing: IconButton(
                                  icon: const Icon(Icons.close,
                                      color: Colors.redAccent),
                                  onPressed: () => deleteProfile(profile['id']),
                                ),
                              ),
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
