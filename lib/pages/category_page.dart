import 'package:flutter/material.dart';

class CategoryPage extends StatelessWidget {
  const CategoryPage({super.key});

  final List<Map<String, dynamic>> categories = const [
    {'name': 'Bouquet Mawar', 'icon': Icons.local_florist, 'color': Colors.pinkAccent},
    {'name': 'Bouquet Tulip', 'icon': Icons.filter_vintage, 'color': Colors.pink},
    {'name': 'Bouquet Lily', 'icon': Icons.eco, 'color': Colors.pinkAccent},
    {'name': 'Bouquet Boneka', 'icon': Icons.toys, 'color': Colors.pink},
    {'name': 'Bouquet Wisuda', 'icon': Icons.school, 'color': Colors.pinkAccent},
    {'name': 'Dried Flowers', 'icon': Icons.grass, 'color': Colors.pink},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kategori Buket', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.pinkAccent,
        foregroundColor: Colors.white,
      ),
      body: Container(
        color: Colors.pink.shade50,
        child: GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.2,
          ),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final cat = categories[index];
            return Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              elevation: 3,
              child: InkWell(
                onTap: () {},
                borderRadius: BorderRadius.circular(15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundColor: Colors.pink.shade100,
                      child: Icon(cat['icon'], size: 30, color: cat['color']),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      cat['name'],
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}