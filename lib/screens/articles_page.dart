import 'package:flutter/material.dart';
import 'article_details_page.dart';

class ArticlesPage extends StatefulWidget {
  const ArticlesPage({Key? key}) : super(key: key);

  @override
  State<ArticlesPage> createState() => _ArticlesPageState();
}

class _ArticlesPageState extends State<ArticlesPage> {
  String _selectedCategory = 'All';
  
  final List<String> _categories = [
    'All',
    'Pediatrics',
    'Chronic Illness',
    'Mental Health',
    'Nutrition',
    'Fitness',
    'Women\'s Health',
    'Heart Health',
    'Preventive Care',
  ];

  final List<Map<String, dynamic>> _allArticles = [
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
    {
      'id': '5',
      'title': 'Heart Health After 40',
      'category': 'Heart Health',
      'readTime': '7 min read',
      'image': Icons.favorite,
      'color': Colors.red.shade700,
      'likes': 287,
      'views': 2156,
      'date': 'Jan 10, 2026',
      'author': 'Dr. Robert Wilson',
      'isNew': false,
      'summary': 'Preventive measures and lifestyle changes for a healthy heart.',
      'content': '''After 40, taking care of your heart becomes increasingly important. Prevention is always better than treatment.

**Key Risk Factors:**
- High blood pressure
- High cholesterol
- Diabetes
- Obesity
- Smoking
- Family history
- Sedentary lifestyle

**Heart-Healthy Lifestyle:**
1. **Diet:**
   - Mediterranean diet pattern
   - Limit saturated fats and sodium
   - Increase omega-3 fatty acids
   - Plenty of fruits and vegetables

2. **Exercise:**
   - 150 minutes moderate aerobic activity weekly
   - Strength training twice weekly
   - Include flexibility exercises

3. **Stress Management:**
   - Practice relaxation techniques
   - Adequate sleep (7-9 hours)
   - Maintain work-life balance

4. **Regular Monitoring:**
   - Blood pressure checks
   - Cholesterol screening
   - Blood sugar monitoring

**Warning Signs:**
Seek immediate medical attention for:
- Chest pain or discomfort
- Shortness of breath
- Pain in arms, back, neck, or jaw
- Cold sweats or nausea

**Medications:**
If prescribed, take blood pressure and cholesterol medications consistently. Never stop without consulting your doctor.

Your heart health is in your hands. Small changes today can prevent major problems tomorrow.''',
    },
    {
      'id': '6',
      'title': 'Women\'s Health: Annual Checkups',
      'category': 'Women\'s Health',
      'readTime': '5 min read',
      'image': Icons.pregnant_woman,
      'color': Colors.pinkAccent,
      'likes': 398,
      'views': 2567,
      'date': 'Jan 8, 2026',
      'author': 'Dr. Lisa Anderson',
      'isNew': false,
      'summary': 'Essential screenings and preventive care every woman needs.',
      'content': '''Regular health screenings are crucial for early detection and prevention of health issues.

**Essential Annual Screenings:**

**Ages 20-39:**
- Blood pressure check
- Clinical breast exam
- Pap smear (every 3 years)
- STI screening if sexually active
- Skin exam

**Ages 40-49:**
- All of the above, plus:
- Mammogram (discuss timing with doctor)
- Cholesterol screening
- Diabetes screening if at risk

**Ages 50+:**
- All of the above, plus:
- Colonoscopy (every 10 years)
- Bone density scan
- Regular mammograms

**Reproductive Health:**
- Birth control counseling
- Preconception planning
- Menopause management
- Fertility concerns

**Mental Health:**
- Depression screening
- Anxiety assessment
- Stress management

**Lifestyle Discussions:**
- Diet and nutrition
- Exercise habits
- Sleep quality
- Substance use
- Relationship health

**Vaccinations:**
- HPV vaccine (if not previously vaccinated)
- Flu shot annually
- Tdap booster
- COVID-19 vaccines

Building a relationship with your healthcare provider allows for personalized care based on your unique needs and risk factors.''',
    },
    {
      'id': '7',
      'title': 'The Importance of Sleep',
      'category': 'Preventive Care',
      'readTime': '6 min read',
      'image': Icons.bedtime,
      'color': Colors.indigo,
      'likes': 423,
      'views': 2890,
      'date': 'Jan 5, 2026',
      'author': 'Dr. James Brown',
      'isNew': false,
      'summary': 'How quality sleep affects your physical and mental health.',
      'content': '''Sleep is not a luxury—it's a biological necessity that affects every aspect of your health.

**Why Sleep Matters:**
- Memory consolidation and learning
- Immune system function
- Hormone regulation
- Tissue repair and growth
- Emotional regulation
- Cardiovascular health

**Sleep Requirements:**
- Adults: 7-9 hours
- Teenagers: 8-10 hours
- Children: 9-12 hours
- Infants: 12-16 hours

**Creating Good Sleep Hygiene:**
1. **Consistent Schedule:**
   - Same bedtime and wake time daily
   - Even on weekends

2. **Bedroom Environment:**
   - Cool, dark, and quiet
   - Comfortable mattress and pillows
   - Remove electronic devices

3. **Pre-Sleep Routine:**
   - Wind down 30-60 minutes before bed
   - Avoid screens
   - Light reading or gentle stretching
   - Warm bath or shower

4. **Daytime Habits:**
   - Regular exercise (not close to bedtime)
   - Limit caffeine after 2 PM
   - Avoid large meals before bed
   - Get natural sunlight exposure

**Sleep Disorders:**
Consult a doctor if you experience:
- Chronic insomnia
- Sleep apnea symptoms (snoring, gasping)
- Restless legs
- Excessive daytime sleepiness

Good sleep is foundational to good health. Prioritize it like you would nutrition and exercise.''',
    },
    {
      'id': '8',
      'title': 'Fitness at Every Age',
      'category': 'Fitness',
      'readTime': '7 min read',
      'image': Icons.fitness_center,
      'color': Colors.orange,
      'likes': 356,
      'views': 2234,
      'date': 'Jan 3, 2026',
      'author': 'Dr. Maria Garcia',
      'isNew': false,
      'summary': 'Age-appropriate exercise guidelines for optimal health.',
      'content': '''Physical activity is vital at every stage of life, but the approach should evolve with age.

**Ages 18-40:**
- Focus: Building strength and endurance
- Activities: Running, HIIT, weightlifting, sports
- Frequency: 150 minutes moderate or 75 minutes vigorous weekly
- Include: Flexibility and balance work

**Ages 40-60:**
- Focus: Maintaining muscle mass and bone density
- Activities: Strength training, swimming, cycling, yoga
- Frequency: Same as above, with emphasis on recovery
- Include: Low-impact options to protect joints

**Ages 60+:**
- Focus: Balance, flexibility, and functional fitness
- Activities: Walking, water aerobics, tai chi, gentle strength training
- Frequency: Modified based on ability
- Include: Fall prevention exercises

**Benefits of Regular Exercise:**
- Weight management
- Disease prevention
- Better sleep
- Improved mood
- Stronger bones and muscles
- Enhanced cognitive function
- Increased energy

**Getting Started:**
1. Consult your doctor
2. Start slowly and progress gradually
3. Choose activities you enjoy
4. Find a workout buddy
5. Set realistic goals
6. Listen to your body

**Staying Motivated:**
- Track your progress
- Vary your routine
- Join classes or groups
- Celebrate small wins
- Focus on how you feel, not just appearance

Remember: The best exercise is the one you'll actually do consistently. Find what works for you and make it a sustainable part of your lifestyle.''',
    },
  ];

  List<Map<String, dynamic>> get _filteredArticles {
    if (_selectedCategory == 'All') {
      return _allArticles;
    }
    return _allArticles.where((article) => article['category'] == _selectedCategory).toList();
  }

  List<Map<String, dynamic>> get _newArticles {
    return _allArticles.where((article) => article['isNew'] == true).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Health Articles',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black87),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.bookmark_border, color: Colors.black87),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // New Articles Section
          if (_newArticles.isNotEmpty) ...[
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF4FC3F7), Color(0xFF2196F3)],
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: const [
                            Icon(Icons.fiber_new, color: Colors.white, size: 16),
                            SizedBox(width: 4),
                            Text(
                              'New Articles',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '${_newArticles.length} new',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 180,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _newArticles.length,
                      itemBuilder: (context, index) {
                        final article = _newArticles[index];
                        return _buildNewArticleCard(article);
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
          ],

          // Category Filter
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'Categories',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 40,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _categories.length,
                    itemBuilder: (context, index) {
                      final category = _categories[index];
                      final isSelected = _selectedCategory == category;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedCategory = category;
                          });
                        },
                        child: Container(
                          margin: const EdgeInsets.only(right: 12),
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          decoration: BoxDecoration(
                            color: isSelected ? const Color(0xFF4FC3F7) : Colors.grey[100],
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isSelected ? const Color(0xFF4FC3F7) : Colors.grey.shade300,
                            ),
                          ),
                          child: Text(
                            category,
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.grey[700],
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 8),
          
          // Articles Count
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Text(
              '${_filteredArticles.length} articles',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          // Articles List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(bottom: 16),
              itemCount: _filteredArticles.length,
              itemBuilder: (context, index) {
                return _buildArticleCard(_filteredArticles[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNewArticleCard(Map<String, dynamic> article) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ArticleDetailsPage(article: article),
          ),
        );
      },
      child: Container(
        width: 280,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [
              (article['color'] as Color).withOpacity(0.7),
              article['color'] as Color,
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: (article['color'] as Color).withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(article['image'], color: Colors.white, size: 32),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'NEW',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                article['title'],
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Text(
                article['summary'],
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const Spacer(),
              Row(
                children: [
                  const Icon(Icons.access_time, color: Colors.white70, size: 14),
                  const SizedBox(width: 4),
                  Text(
                    article['readTime'],
                    style: const TextStyle(color: Colors.white70, fontSize: 11),
                  ),
                  const Spacer(),
                  const Icon(Icons.arrow_forward, color: Colors.white, size: 16),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildArticleCard(Map<String, dynamic> article) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ArticleDetailsPage(article: article),
          ),
        );
      },
      child: Container(
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
              height: 140,
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
              child: Stack(
                children: [
                  Center(
                    child: Icon(
                      article['image'],
                      size: 50,
                      color: Colors.white,
                    ),
                  ),
                  if (article['isNew'] == true)
                    Positioned(
                      top: 12,
                      right: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'NEW',
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
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
                  const SizedBox(height: 8),
                  Text(
                    article['summary'],
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 13,
                      height: 1.4,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(Icons.person_outline, size: 14, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Text(
                        article['author'],
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      ),
                      const SizedBox(width: 12),
                      Icon(Icons.remove_red_eye_outlined, size: 14, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Text(
                        '${article['views']}',
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
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
                      minimumSize: const Size(double.infinity, 40),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text('Read Now'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}