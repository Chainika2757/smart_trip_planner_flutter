import 'package:flutter/material.dart';

import 'login.dart'; 

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    
    final String userName = "Shubham S.";
    final String userEmail = "shubham.self@gmail.com";
    final int requestTokens = 1000;
    final int responseTokens = 750;
    final double cost = 0.07;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Profile", style: TextStyle(color: Colors.black)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFF8F8F8),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  )
                ],
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 24,
                    child: Text(userName[0],
                        style: const TextStyle(fontSize: 24)),
                  ),
                  const SizedBox(height: 10),
                  Text(userName,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(userEmail,
                      style: const TextStyle(color: Colors.grey, fontSize: 14)),
                  const SizedBox(height: 20),

                  // Request Tokens
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Request Tokens",
                        style: TextStyle(color: Colors.grey[700])),
                  ),
                  const SizedBox(height: 4),
                  LinearProgressIndicator(
                    value: 1.0,
                    backgroundColor: Colors.grey[300],
                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
                  ),
                  const SizedBox(height: 4),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text("$requestTokens/1000",
                        style: const TextStyle(fontSize: 12)),
                  ),
                  const SizedBox(height: 10),

                  // Response Tokens
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Response Tokens",
                        style: TextStyle(color: Colors.grey[700])),
                  ),
                  const SizedBox(height: 4),
                  LinearProgressIndicator(
                    value: 0.75,
                    backgroundColor: Colors.grey[300],
                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.red),
                  ),
                  const SizedBox(height: 4),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text("$responseTokens/1000",
                        style: const TextStyle(fontSize: 12)),
                  ),
                  const SizedBox(height: 10),

                  // Cost
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Total Cost",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                      Text("\$${cost.toStringAsFixed(2)} USD",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.green)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),

            // Logout Button
            ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              },
              icon: const Icon(Icons.logout, color: Colors.red),
              label: const Text(
                "Log Out",
                style: TextStyle(color: Colors.red),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                side: const BorderSide(color: Colors.red),
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
