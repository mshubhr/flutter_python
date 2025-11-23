import 'package:flutter/material.dart';

class ProfileDetail extends StatelessWidget {
  final Map profile;
  const ProfileDetail({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    final name = profile['title'] ?? 'Unknown';
    return Scaffold(
      appBar:
          AppBar(title: Text(name), backgroundColor: Colors.lightBlueAccent),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 60,
              backgroundColor: Colors.lightBlueAccent,
              child: Text(
                name[0].toUpperCase(),
                style: const TextStyle(fontSize: 40, color: Colors.white),
              ),
            ),
            const SizedBox(height: 16),
            Text(name,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('This is a sample profile.',
                textAlign: TextAlign.center),
            const Spacer(),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context)
                          .showSnackBar(const SnackBar(content: Text('Liked')));
                    },
                    icon: const Icon(Icons.favorite, color: Colors.blue),
                    label: const Text('Like'),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white70),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Message sent (demo)')));
                    },
                    icon: const Icon(Icons.message),
                    label: const Text('Message'),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
