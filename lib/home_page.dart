// // home_page.dart
// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class HomePage extends StatelessWidget {
//   const HomePage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final user = FirebaseAuth.instance.currentUser;
    
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Home Page'),
//         actions: [
//           IconButton(
//             onPressed: () async {
//               await FirebaseAuth.instance.signOut();
//             },
//             icon: const Icon(Icons.logout),
//           ),
//         ],
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             if (user?.photoURL != null)
//               CircleAvatar(
//                 radius: 50,
//                 backgroundImage: NetworkImage(user!.photoURL!),
//               ),
//             const SizedBox(height: 20),
//             Text(
//               'Welcome, ${user?.displayName ?? user?.email ?? 'User'}!',
//               style: const TextStyle(fontSize: 24),
//               textAlign: TextAlign.center,
//             ),
//             const SizedBox(height: 20),
//             if (user?.emailVerified == false)
//               TextButton(
//                 onPressed: () async {
//                   await user?.sendEmailVerification();
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(
//                       content: Text('Verification email sent!'),
//                     ),
//                   );
//                 },
//                 child: const Text('Verify Email'),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:final_exam/models/loyalty_card.dart';
import 'package:final_exam/services/hive_service.dart';
import 'package:final_exam/add_card_page.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final HiveService _hiveService = HiveService();
  late Future<List<LoyaltyCard>> _cardsFuture;

  @override
  void initState() {
    super.initState();
    _cardsFuture = _hiveService.getAllCards();
  }

  void _refreshCards() {
    setState(() {
      _cardsFuture = _hiveService.getAllCards();
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Loyalty Cards'),
        actions: [
          IconButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                if (user?.photoURL != null)
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(user!.photoURL!),
                  ),
                const SizedBox(height: 20),
                Text(
                  'Welcome, ${user?.displayName ?? user?.email ?? 'User'}!',
                  style: const TextStyle(fontSize: 24),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                if (user?.emailVerified == false)
                  TextButton(
                    onPressed: () async {
                      await user?.sendEmailVerification();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Verification email sent!'),
                        ),
                      );
                    },
                    child: const Text('Verify Email'),
                  ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<LoyaltyCard>>(
              future: _cardsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return const Center(child: Text('Error loading cards'));
                }
                final cards = snapshot.data ?? [];
                if (cards.isEmpty) {
                  return const Center(child: Text('No loyalty cards added yet'));
                }
                return ListView.builder(
                  itemCount: cards.length,
                  itemBuilder: (context, index) {
                    final card = cards[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: ListTile(
                        
                        subtitle: Text('Card: ${card.cardNumber}'),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () async {
                            await _hiveService.deleteCard(card.id);
                            _refreshCards();
                          },
                        ),
                        onTap: () {
                          // TODO: Display barcode/QR code
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Show barcode for ${card.issuer}')),
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddCardPage()),
          );
          if (result == true) {
            _refreshCards();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}