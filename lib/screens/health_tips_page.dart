import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HealthTipsPage extends StatefulWidget {
  const HealthTipsPage({super.key});

  @override
  State<HealthTipsPage> createState() => _HealthTipsPageState();
}

class _HealthTipsPageState extends State<HealthTipsPage> {
  final _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedCategory = 'All';

  final List<String> _categories = [
    'All',
    'Nutrition',
    'Exercise',
    'Mental Health',
    'Sleep',
    'Hydration',
    'General'
  ];

  Stream<QuerySnapshot<Map<String, dynamic>>> get _tipsStream =>
      FirebaseFirestore.instance.collection('health_tips').snapshots();

  @override
  void initState() {
    super.initState();
    _addDefaultTips();
  }

  Future<void> _addDefaultTips() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('health_tips')
        .limit(1)
        .get();

    if (snapshot.docs.isEmpty) {
      final defaultTips = [
        {
          'title': 'Drink Water First Thing',
          'description':
              'Start your day with a glass of water to rehydrate your body after sleep and kickstart your metabolism.',
          'category': 'Hydration',
          'icon': 'water',
          'color': 'blue',
          'likes': 245,
        },
        {
          'title': '30 Minutes of Exercise Daily',
          'description':
              'Engage in at least 30 minutes of moderate physical activity daily to improve cardiovascular health and maintain weight.',
          'category': 'Exercise',
          'icon': 'fitness',
          'color': 'orange',
          'likes': 189,
        },
        {
          'title': 'Eat More Fruits & Vegetables',
          'description':
              'Include 5 servings of colorful fruits and vegetables in your daily diet for essential vitamins and nutrients.',
          'category': 'Nutrition',
          'icon': 'restaurant',
          'color': 'green',
          'likes': 312,
        },
        {
          'title': 'Get 7-8 Hours of Sleep',
          'description':
              'Quality sleep is crucial for physical recovery, mental clarity, and overall health. Maintain a consistent sleep schedule.',
          'category': 'Sleep',
          'icon': 'bedtime',
          'color': 'purple',
          'likes': 278,
        },
        {
          'title': 'Practice Deep Breathing',
          'description':
              'Take 5 minutes daily for deep breathing exercises to reduce stress, lower blood pressure, and improve focus.',
          'category': 'Mental Health',
          'icon': 'air',
          'color': 'teal',
          'likes': 156,
        },
        {
          'title': 'Limit Screen Time Before Bed',
          'description':
              'Avoid screens 1 hour before sleep. Blue light disrupts melatonin production and affects sleep quality.',
          'category': 'Sleep',
          'icon': 'phone_disabled',
          'color': 'purple',
          'likes': 203,
        },
        {
          'title': 'Take Regular Breaks',
          'description':
              'Stand up and move every hour if you work at a desk. This prevents stiffness and improves circulation.',
          'category': 'Exercise',
          'icon': 'directions_walk',
          'color': 'orange',
          'likes': 167,
        },
        {
          'title': 'Practice Gratitude',
          'description':
              'Write down 3 things you\'re grateful for each day. This simple practice can improve mental well-being significantly.',
          'category': 'Mental Health',
          'icon': 'favorite',
          'color': 'pink',
          'likes': 221,
        },
        {
          'title': 'Wash Hands Regularly',
          'description':
              'Wash hands with soap for 20 seconds, especially before meals and after public contact, to prevent infections.',
          'category': 'General',
          'icon': 'clean_hands',
          'color': 'blue',
          'likes': 298,
        },
        {
          'title': 'Reduce Sugar Intake',
          'description':
              'Limit added sugars to less than 25g per day. High sugar intake leads to obesity, diabetes, and heart disease.',
          'category': 'Nutrition',
          'icon': 'warning',
          'color': 'red',
          'likes': 234,
        },
      ];

      for (var tip in defaultTips) {
        await FirebaseFirestore.instance.collection('health_tips').add(tip);
      }
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Color _parseColor(String? colorName) {
    switch (colorName) {
      case 'blue':
        return Colors.blue;
      case 'green':
        return Colors.green;
      case 'orange':
        return Colors.orange;
      case 'purple':
        return Colors.purple;
      case 'teal':
        return Colors.teal;
      case 'pink':
        return Colors.pink;
      case 'red':
        return Colors.red;
      default:
        return Colors.cyan;
    }
  }

  IconData _parseIcon(String? iconName) {
    switch (iconName) {
      case 'water':
        return Icons.water_drop_rounded;
      case 'fitness':
        return Icons.fitness_center_rounded;
      case 'restaurant':
        return Icons.restaurant_rounded;
      case 'bedtime':
        return Icons.bedtime_rounded;
      case 'air':
        return Icons.air_rounded;
      case 'phone_disabled':
        return Icons.phone_disabled_rounded;
      case 'directions_walk':
        return Icons.directions_walk_rounded;
      case 'favorite':
        return Icons.favorite_rounded;
      case 'clean_hands':
        return Icons.clean_hands_rounded;
      case 'warning':
        return Icons.warning_amber_rounded;
      default:
        return Icons.tips_and_updates_rounded;
    }
  }

  List<DocumentSnapshot<Map<String, dynamic>>> _filterTips(
    List<DocumentSnapshot<Map<String, dynamic>>> docs,
  ) {
    var filtered = docs;

    if (_selectedCategory != 'All') {
      filtered = filtered.where((doc) {
        return doc['category'] == _selectedCategory;
      }).toList();
    }

    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((doc) {
        final data = doc.data()!;
        final title = (data['title'] ?? '').toString().toLowerCase();
        final description = (data['description'] ?? '').toString().toLowerCase();
        final category = (data['category'] ?? '').toString().toLowerCase();
        final query = _searchQuery.toLowerCase();
        return title.contains(query) ||
            description.contains(query) ||
            category.contains(query);
      }).toList();
    }

    return filtered;
  }

  Widget _buildTipCard(Map<String, dynamic> tip, String docId) {
    final color = _parseColor(tip['color']);
    final icon = _parseIcon(tip['icon']);
    final likes = tip['likes'] ?? 0;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white,
            color.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.2),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  color.withOpacity(0.15),
                  color.withOpacity(0.05),
                ],
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [color, color.withOpacity(0.7)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: color.withOpacity(0.4),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(
                    icon,
                    color: Colors.white,
                    size: 36,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tip['title'] ?? 'Health Tip',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: color,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: color, width: 1),
                        ),
                        child: Text(
                          tip['category'] ?? 'General',
                          style: TextStyle(
                            color: color,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tip['description'] ?? 'No description available',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 15,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.favorite_rounded,
                          color: Colors.red[400],
                          size: 20,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '$likes people found this helpful',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      onPressed: () async {
                        await FirebaseFirestore.instance
                            .collection('health_tips')
                            .doc(docId)
                            .update({'likes': likes + 1});
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text('Thanks for your feedback!'),
                            backgroundColor: color,
                            behavior: SnackBarBehavior.floating,
                            duration: const Duration(seconds: 1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        );
                      },
                      icon: Icon(
                        Icons.thumb_up_rounded,
                        color: color,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF66BB6A), Color(0xFF43A047)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Health Tips',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded, color: Colors.white),
            onPressed: () {
              setState(() {});
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF66BB6A), Color(0xFF43A047)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _searchController,
                      onChanged: (value) {
                        setState(() {
                          _searchQuery = value;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Search health tips...',
                        prefixIcon: const Icon(
                          Icons.search_rounded,
                          color: Color(0xFF66BB6A),
                        ),
                        suffixIcon: _searchQuery.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear, color: Colors.grey),
                                onPressed: () {
                                  setState(() {
                                    _searchController.clear();
                                    _searchQuery = '';
                                  });
                                },
                              )
                            : null,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 50,
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    scrollDirection: Axis.horizontal,
                    itemCount: _categories.length,
                    itemBuilder: (context, index) {
                      final category = _categories[index];
                      final isSelected = _selectedCategory == category;
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: ChoiceChip(
                          label: Text(category),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              _selectedCategory = category;
                            });
                          },
                          backgroundColor: Colors.white.withOpacity(0.3),
                          selectedColor: Colors.white,
                          labelStyle: TextStyle(
                            color: isSelected
                                ? const Color(0xFF43A047)
                                : Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          elevation: isSelected ? 4 : 0,
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: _tipsStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.tips_and_updates_rounded,
                          size: 80,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No health tips found',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                final filteredTips = _filterTips(snapshot.data!.docs);

                if (filteredTips.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off_rounded,
                          size: 80,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No tips match your search',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  itemCount: filteredTips.length,
                  itemBuilder: (context, index) {
                    final tip = filteredTips[index].data()!;
                    final docId = filteredTips[index].id;
                    return _buildTipCard(tip, docId);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
