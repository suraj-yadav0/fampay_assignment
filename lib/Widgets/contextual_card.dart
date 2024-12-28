
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'F A M P A Y',
          style: TextStyle(color: Colors.black),
        ), 
        centerTitle: true, 
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Big display card with action
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF4A4DFF),
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.lock,
                  color: Colors.white,
                  size: 40,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Big display card',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  'with action',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'This is a sample text for the subtitle that you can add to contextual cards',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Action'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Small card with arrow
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.grey,
                child: Icon(Icons.person, color: Colors.white),
              ),
              title: Text('Small card with arrow'),
              trailing: Icon(Icons.arrow_forward_ios, size: 16),
            ),
          ),

          const SizedBox(height: 16),

          // Savings Challenge Card
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFFFF3E0),
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Image.asset(
                  'assets/Group 336.png',
                  height: 60,
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Save the streak 🔥',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '10-Day Savings Challenge',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Horizontal scrolling cards
          SizedBox(
            height: 120,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildColorCard(Colors.amber),
                _buildColorCard(Colors.purple),
                _buildColorCard(Colors.green),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Small cards with profile pictures
          ...List.generate(
            2,
            (index) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Container(
                decoration: BoxDecoration(
                  color: index == 1 ? Colors.amber : Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ListTile(
                  leading: const CircleAvatar(
                    backgroundImage: NetworkImage('https://your-avatar-url.com/avatar.png'),
                  ),
                  title: const Text('Arya Stark'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildColorCard(Color color) {
    return Container(
      width: 120,
      margin: const EdgeInsets.only(right: 8),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}