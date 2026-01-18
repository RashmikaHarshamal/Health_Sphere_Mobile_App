import 'package:flutter/material.dart';
import 'appointments_page.dart';
import 'find_doctors_page.dart';
import 'articles_page.dart';
import 'article_details_page.dart';
import 'vaccination_page.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  final List<Map<String, dynamic>> _healthFeatures = [
    {'icon': Icons.calendar_today, 'title': 'Appointments', 'color': Colors.blue},
    {'icon': Icons.medical_services, 'title': 'Medicines', 'color': Colors.green},
    {'icon': Icons.health_and_safety, 'title': 'Health Tips', 'color': Colors.orange},
    {'icon': Icons.vaccines, 'title': 'Vaccination', 'color': Colors.red},
    {'icon': Icons.local_hospital, 'title': 'Find Doctor', 'color': Colors.purple},
    {'icon': Icons.article, 'title': 'Articles', 'color': Colors.indigo},
    {'icon': Icons.emergency, 'title': 'Emergency', 'color': Colors.redAccent},
    {'icon': Icons.chat_bubble, 'title': 'Chat', 'color': Colors.teal},
  ];



  final List<Map<String, dynamic>> _upcomingAppointments = [
    {
      'doctor': 'Dr. Sarah Johnson',
      'specialty': 'Cardiologist',
      'date': 'Today',
      'time': '10:30 AM',
      'icon': Icons.favorite,
      'color': Colors.red
    },
    {
      'doctor': 'Dr. Michael Chen',
      'specialty': 'General Physician',
      'date': 'Tomorrow',
      'time': '2:00 PM',
      'icon': Icons.local_hospital,
      'color': Colors.blue
    },
    {
      'doctor': 'Dr. Emily Davis',
      'specialty': 'Dermatologist',
      'date': 'Jan 20',
      'time': '11:00 AM',
      'icon': Icons.healing,
      'color': Colors.purple
    },
  ];

  final List<Map<String, dynamic>> _healthArticles = [
    {
      'id': '1',
      'title': 'Understanding Child Fever',
      'category': 'Pediatrics',
      'readTime': '5 min read',
      'image': Icons.child_care,
      'color': Colors.pink,
      'likes': 234,
      'views': 1542,
      'date': 'Jan 15, 2026',
      'author': 'Dr. Sarah Johnson',
      'isNew': true,
      'summary': 'Learn when to worry about your child\'s fever and effective home remedies.',
      'content': '''Fever is one of the most common reasons parents seek medical attention for their children. While it can be concerning, fever is actually a sign that your child's body is fighting an infection.

**When to Seek Immediate Care:**
- Fever above 104°F (40°C)
- Child is under 3 months old with any fever
- Fever lasts more than 3 days
- Child is lethargic or unresponsive
- Difficulty breathing or chest pain
- Severe headache or stiff neck

**Home Care Tips:**
1. Keep your child hydrated with water, clear broths, or electrolyte solutions
2. Dress them in light clothing
3. Use acetaminophen or ibuprofen as directed by your pediatrician
4. Monitor temperature regularly
5. Allow rest and avoid strenuous activities

**Common Myths:**
- Myth: All fevers are dangerous
- Reality: Fever itself is not harmful; it's the body's natural defense

Always trust your instincts as a parent. If something doesn't feel right, contact your healthcare provider.''',
    },
    {
      'id': '2',
      'title': 'Managing Diabetes Effectively',
      'category': 'Chronic Illness',
      'readTime': '8 min read',
      'image': Icons.favorite_border,
      'color': Colors.red,
      'likes': 189,
      'views': 2341,
      'date': 'Jan 14, 2026',
      'author': 'Dr. Michael Chen',
      'isNew': true,
      'summary': 'Comprehensive guide to living well with diabetes through diet, exercise, and medication.',
      'content': '''Living with diabetes requires dedication, but with the right knowledge and tools, you can lead a full and healthy life.

**Blood Sugar Monitoring:**
Regular monitoring is crucial. Check your blood sugar:
- Before meals
- 2 hours after meals
- Before bedtime
- Before and after exercise

**Diet Management:**
1. Focus on whole grains, lean proteins, and vegetables
2. Limit processed foods and sugary drinks
3. Eat regular meals at consistent times
4. Control portion sizes
5. Choose foods with low glycemic index

**Exercise Guidelines:**
- Aim for 150 minutes of moderate activity weekly
- Include both aerobic and strength training
- Monitor blood sugar before and after exercise
- Stay hydrated
- Always carry a quick sugar source

**Medication Adherence:**
Take medications exactly as prescribed. Set reminders if needed. Never skip doses without consulting your doctor.

**Regular Check-ups:**
Schedule regular appointments with your healthcare team including eye exams, foot checks, and kidney function tests.

Remember, diabetes management is a marathon, not a sprint. Small, consistent changes lead to better long-term outcomes.''',
    },
    {
      'id': '3',
      'title': 'Mental Health: Breaking the Stigma',
      'category': 'Mental Health',
      'readTime': '6 min read',
      'image': Icons.psychology,
      'color': Colors.purple,
      'likes': 456,
      'views': 3124,
      'date': 'Jan 13, 2026',
      'author': 'Dr. Emily Davis',
      'isNew': true,
      'summary': 'Understanding mental health and why seeking help is a sign of strength.',
      'content': '''Mental health is just as important as physical health. Yet many people struggle in silence due to stigma and misunderstanding.

**Common Mental Health Conditions:**
- Depression
- Anxiety disorders
- Bipolar disorder
- PTSD
- OCD

**Warning Signs:**
- Persistent sadness or irritability
- Changes in sleep or appetite
- Loss of interest in activities
- Difficulty concentrating
- Thoughts of self-harm

**Self-Care Strategies:**
1. Maintain a regular sleep schedule
2. Exercise regularly
3. Practice mindfulness and meditation
4. Connect with supportive friends and family
5. Limit alcohol and avoid drugs
6. Set realistic goals and priorities

**When to Seek Professional Help:**
Don't wait until you're in crisis. Seeking help early can prevent conditions from worsening. Mental health professionals include:
- Psychiatrists
- Psychologists
- Licensed counselors
- Social workers

**Treatment Options:**
- Psychotherapy (talk therapy)
- Medication
- Support groups
- Lifestyle modifications
- Combination approaches

Remember: Seeking help for mental health is not a sign of weakness—it's a courageous step toward healing and wellness.''',
    },
    {
      'id': '4',
      'title': 'Nutrition for Growing Kids',
      'category': 'Nutrition',
      'readTime': '4 min read',
      'image': Icons.restaurant,
      'color': Colors.green,
      'likes': 312,
      'views': 1876,
      'date': 'Jan 12, 2026',
      'author': 'Dr. Priya Sharma',
      'isNew': false,
      'summary': 'Essential nutrients and meal ideas for children\'s healthy development.',
      'content': '''Proper nutrition during childhood sets the foundation for lifelong health and development.

**Essential Nutrients:**
1. **Protein:** For growth and development
   - Lean meats, fish, eggs, beans, nuts
2. **Calcium:** For strong bones and teeth
   - Milk, yogurt, cheese, leafy greens
3. **Iron:** For blood and brain development
   - Red meat, fortified cereals, spinach
4. **Vitamins A, C, D:** For immunity and growth
   - Fruits, vegetables, fortified milk
5. **Healthy Fats:** For brain development
   - Avocados, nuts, fish

**Meal Planning Tips:**
- Offer variety and color
- Include all food groups
- Serve age-appropriate portions
- Make meals fun and engaging
- Lead by example

**Healthy Snack Ideas:**
- Fresh fruit with nut butter
- Vegetable sticks with hummus
- Whole grain crackers with cheese
- Yogurt with berries
- Homemade smoothies

**Picky Eaters:**
- Don't force food
- Offer new foods multiple times
- Involve kids in meal preparation
- Make food visually appealing
- Be patient and persistent

Establishing healthy eating habits early helps children develop a positive relationship with food.''',
    },
  ];

  List<bool> _articleLikes = [];

  @override
  void initState() {
    super.initState();
    _articleLikes = List.generate(_healthArticles.length, (index) => false);
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _navigateToAppointments() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AppointmentsPage()),
    );
  }

 

  Widget _buildHealthStatsCard() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF4FC3F7), Color(0xFF2196F3)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4FC3F7).withOpacity(0.4),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Health Overview',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'Today',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildHealthStat(Icons.favorite, '72', 'Heart Rate', 'bpm'),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildHealthStat(Icons.directions_walk, '8,432', 'Steps', 'today'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildHealthStat(Icons.local_fire_department, '420', 'Calories', 'kcal'),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildHealthStat(Icons.bedtime, '7.5', 'Sleep', 'hours'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHealthStat(IconData icon, String value, String label, String unit) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 24),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '$label ($unit)',
                  style: const TextStyle(color: Colors.white70, fontSize: 10),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureGrid() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Healthcare Services',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.85,
            ),
            itemCount: _healthFeatures.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  final title = _healthFeatures[index]['title'] as String;
                  if (title == 'Appointments') {
                    _navigateToAppointments();
                  } else if (title == 'Find Doctor') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const FindDoctorsPage()),
                    );
                  } else if (title == 'Articles') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ArticlesPage()),
                    );
                  } else if (title == 'Vaccination') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const VaccinationPage()),
                    );
                 
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('$title - Coming Soon!')),
                    );
                  }
                },
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: (_healthFeatures[index]['color'] as Color).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(
                        _healthFeatures[index]['icon'],
                        color: _healthFeatures[index]['color'],
                        size: 28,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _healthFeatures[index]['title'],
                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  
 

  Widget _buildAppointmentsList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Upcoming Appointments',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: _navigateToAppointments,
                child: const Text('See All', style: TextStyle(color: Color(0xFF4FC3F7))),
              ),
            ],
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _upcomingAppointments.length,
          itemBuilder: (context, index) {
            final appointment = _upcomingAppointments[index];
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.all(16),
                leading: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: (appointment['color'] as Color).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    appointment['icon'],
                    color: appointment['color'],
                    size: 28,
                  ),
                ),
                title: Text(
                  appointment['doctor'],
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4),
                    Text(
                      appointment['specialty'],
                      style: TextStyle(color: Colors.grey[600], fontSize: 13),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(Icons.calendar_today, size: 14, color: Colors.grey[500]),
                        const SizedBox(width: 4),
                        Text(
                          '${appointment['date']} • ${appointment['time']}',
                          style: TextStyle(color: Colors.grey[700], fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
                trailing: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4FC3F7),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                  child: const Text('Join', style: TextStyle(fontSize: 12)),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildHealthArticles() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Health Articles',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ArticlesPage()),
                  );
                },
                child: const Text('See All', style: TextStyle(color: Color(0xFF4FC3F7))),
              ),
            ],
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _healthArticles.length,
          itemBuilder: (context, index) {
            final article = _healthArticles[index];
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 150,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          (article['color'] as Color).withOpacity(0.6),
                          article['color'] as Color,
                        ],
                      ),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                      ),
                    ),
                    child: Center(
                      child: Icon(
                        article['image'],
                        size: 60,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: (article['color'] as Color).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                article['category'],
                                style: TextStyle(
                                  color: article['color'],
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const Spacer(),
                            Icon(Icons.access_time, size: 14, color: Colors.grey[600]),
                            const SizedBox(width: 4),
                            Text(
                              article['readTime'],
                              style: TextStyle(color: Colors.grey[600], fontSize: 12),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          article['title'],
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  _articleLikes[index] = !_articleLikes[index];
                                });
                              },
                              icon: Icon(
                                _articleLikes[index] ? Icons.favorite : Icons.favorite_border,
                                color: _articleLikes[index] ? Colors.red : Colors.grey,
                              ),
                            ),
                            Text(
                              '${article['likes'] + (_articleLikes[index] ? 1 : 0)}',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                            const Spacer(),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ArticleDetailsPage(article: article),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF4FC3F7),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                              ),
                              child: const Text('Read Now'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildHomeContent() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 25,
                  backgroundColor: Color(0xFF4FC3F7),
                  child: Icon(Icons.person, color: Colors.white, size: 28),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Hello, John!',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'How are you feeling today?',
                        style: TextStyle(color: Colors.grey[600], fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          _buildHealthStatsCard(),
          const SizedBox(height: 24),
          _buildFeatureGrid(),
          const SizedBox(height: 24),
          _buildAppointmentsList(),
          const SizedBox(height: 24),
          _buildHealthArticles(),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildProfileContent() {
    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16),
      children: [
        const SizedBox(height: 20),
        Center(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFF4FC3F7), width: 3),
                ),
                child: const CircleAvatar(
                  radius: 50,
                  backgroundColor: Color(0xFF4FC3F7),
                  child: Icon(Icons.person, size: 50, color: Colors.white),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'John Doe',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                'john.doe@email.com',
                style: TextStyle(color: Colors.grey[600]),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'Health Score: 85/100',
                  style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),
        _buildProfileOption(Icons.person_outline, 'Personal Information', () {}),
        _buildProfileOption(Icons.medical_information, 'Medical History', () {}),
        _buildProfileOption(Icons.family_restroom, 'Family Members', () {}),
        _buildProfileOption(Icons.payment, 'Payment Methods', () {}),
        _buildProfileOption(Icons.notifications_outlined, 'Notifications', () {}),
        _buildProfileOption(Icons.privacy_tip, 'Privacy & Security', () {}),
        _buildProfileOption(Icons.help_outline, 'Help & Support', () {}),
        _buildProfileOption(Icons.info_outline, 'About', () {}),
        const SizedBox(height: 16),
        _buildProfileOption(Icons.logout, 'Logout', () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Logout'),
              content: const Text('Are you sure you want to logout?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Logged out successfully')),
                    );
                  },
                  child: const Text('Logout', style: TextStyle(color: Colors.red)),
                ),
              ],
            ),
          );
        }, isLogout: true),
      ],
    );
  }

  Widget _buildProfileOption(IconData icon, String title, VoidCallback onTap, {bool isLogout = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        leading: Icon(icon, color: isLogout ? Colors.red : const Color(0xFF4FC3F7)),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: isLogout ? Colors.red : Colors.black87,
          ),
        ),
        trailing: Icon(Icons.chevron_right, color: Colors.grey[400]),
        onTap: onTap,
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    final isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF4FC3F7).withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? const Color(0xFF4FC3F7) : Colors.grey,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color: isSelected ? const Color(0xFF4FC3F7) : Colors.grey,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF4FC3F7).withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.health_and_safety, color: Color(0xFF4FC3F7), size: 24),
            ),
            const SizedBox(width: 12),
            const Text(
              'HealthCare+',
              style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined, color: Colors.black87),
                onPressed: () {},
              ),
              Positioned(
                right: 12,
                top: 12,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: const Text(
                    '3',
                    style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.chat_bubble_outline, color: Colors.black87),
            onPressed: () {},
          ),
        ],
      ),
      body: _selectedIndex == 0 ? _buildHomeContent() : _buildProfileContent(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _navigateToAppointments,
        backgroundColor: const Color(0xFF4FC3F7),
        icon: const Icon(Icons.add),
        label: const Text('Book'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(Icons.home, 'Home', 0),
              _buildNavItem(Icons.calendar_today, 'Schedule', 1),
              const SizedBox(width: 40),
              _buildNavItem(Icons.message, 'Messages', 2),
              _buildNavItem(Icons.person, 'Profile', 3),
            ],
          ),
        ),
      ),
    );
  }
}