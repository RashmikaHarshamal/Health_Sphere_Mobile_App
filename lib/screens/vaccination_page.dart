import 'package:flutter/material.dart';

// Add this import to your home_page.dart file:
// import 'vaccination_page.dart';

class VaccinationPage extends StatefulWidget {
  const VaccinationPage({Key? key}) : super(key: key);

  @override
  State<VaccinationPage> createState() => _VaccinationPageState();
}

class _VaccinationPageState extends State<VaccinationPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedAgeGroup = 'All Ages';

  final List<String> _ageGroups = [
    'All Ages',
    'Infants (0-1 year)',
    'Children (1-12 years)',
    'Teens (13-18 years)',
    'Adults (19-64 years)',
    'Seniors (65+ years)',
  ];

  final List<Map<String, dynamic>> _vaccines = [
    {
      'name': 'BCG Vaccine',
      'fullName': 'Bacillus Calmette-Guérin',
      'description': 'Protects against tuberculosis (TB), a serious bacterial infection affecting the lungs.',
      'ageGroup': 'Infants (0-1 year)',
      'recommendedAge': 'At birth or within first few weeks',
      'doses': '1 dose',
      'color': Colors.blue,
      'icon': Icons.vaccines,
      'importance': 'Critical',
      'sideEffects': 'Small bump at injection site, mild fever',
      'schedule': ['At birth'],
    },
    {
      'name': 'Hepatitis B',
      'fullName': 'Hepatitis B Vaccine',
      'description': 'Prevents hepatitis B, a serious liver infection that can cause lifelong illness.',
      'ageGroup': 'Infants (0-1 year)',
      'recommendedAge': 'Birth, 1-2 months, 6-18 months',
      'doses': '3 doses',
      'color': Colors.orange,
      'icon': Icons.medical_services,
      'importance': 'Critical',
      'sideEffects': 'Soreness at injection site, mild fever',
      'schedule': ['At birth', '1-2 months', '6-18 months'],
    },
    {
      'name': 'DTP/DTaP',
      'fullName': 'Diphtheria, Tetanus, and Pertussis',
      'description': 'Protects against three serious diseases: diphtheria (throat infection), tetanus (lockjaw), and pertussis (whooping cough).',
      'ageGroup': 'Infants (0-1 year)',
      'recommendedAge': '2, 4, 6, 15-18 months, 4-6 years',
      'doses': '5 doses',
      'color': Colors.purple,
      'icon': Icons.shield,
      'importance': 'Critical',
      'sideEffects': 'Redness, swelling at injection site, mild fever, fussiness',
      'schedule': ['2 months', '4 months', '6 months', '15-18 months', '4-6 years'],
    },
    {
      'name': 'Polio Vaccine',
      'fullName': 'Inactivated Poliovirus Vaccine (IPV)',
      'description': 'Prevents polio, a crippling and potentially deadly infectious disease affecting the nervous system.',
      'ageGroup': 'Infants (0-1 year)',
      'recommendedAge': '2, 4, 6-18 months, 4-6 years',
      'doses': '4 doses',
      'color': Colors.red,
      'icon': Icons.healing,
      'importance': 'Critical',
      'sideEffects': 'Soreness at injection site, rarely allergic reaction',
      'schedule': ['2 months', '4 months', '6-18 months', '4-6 years'],
    },
    {
      'name': 'MMR Vaccine',
      'fullName': 'Measles, Mumps, and Rubella',
      'description': 'Protects against measles (respiratory infection), mumps (salivary gland swelling), and rubella (German measles).',
      'ageGroup': 'Children (1-12 years)',
      'recommendedAge': '12-15 months, 4-6 years',
      'doses': '2 doses',
      'color': Colors.pink,
      'icon': Icons.child_care,
      'importance': 'Critical',
      'sideEffects': 'Mild rash, fever, swollen lymph nodes',
      'schedule': ['12-15 months', '4-6 years'],
    },
    {
      'name': 'Varicella Vaccine',
      'fullName': 'Chickenpox Vaccine',
      'description': 'Prevents chickenpox, a highly contagious viral infection causing itchy rash and blisters.',
      'ageGroup': 'Children (1-12 years)',
      'recommendedAge': '12-15 months, 4-6 years',
      'doses': '2 doses',
      'color': Colors.green,
      'icon': Icons.spa,
      'importance': 'Recommended',
      'sideEffects': 'Mild rash, fever, soreness at injection site',
      'schedule': ['12-15 months', '4-6 years'],
    },
    {
      'name': 'HPV Vaccine',
      'fullName': 'Human Papillomavirus Vaccine',
      'description': 'Prevents HPV infections that can cause cervical, throat, and other cancers.',
      'ageGroup': 'Teens (13-18 years)',
      'recommendedAge': '11-12 years (can start at 9)',
      'doses': '2-3 doses',
      'color': Colors.teal,
      'icon': Icons.favorite,
      'importance': 'Critical',
      'sideEffects': 'Pain at injection site, headache, fatigue',
      'schedule': ['11-12 years', '6-12 months later'],
    },
    {
      'name': 'Tdap Booster',
      'fullName': 'Tetanus, Diphtheria, Pertussis Booster',
      'description': 'Booster shot to maintain protection against tetanus, diphtheria, and whooping cough.',
      'ageGroup': 'Teens (13-18 years)',
      'recommendedAge': '11-12 years, then every 10 years',
      'doses': 'Every 10 years',
      'color': Colors.indigo,
      'icon': Icons.refresh,
      'importance': 'Recommended',
      'sideEffects': 'Soreness, redness at injection site, mild fever',
      'schedule': ['11-12 years', 'Every 10 years thereafter'],
    },
    {
      'name': 'Influenza Vaccine',
      'fullName': 'Seasonal Flu Vaccine',
      'description': 'Annual vaccine protecting against seasonal flu viruses that cause respiratory illness.',
      'ageGroup': 'All Ages',
      'recommendedAge': 'Yearly from 6 months onwards',
      'doses': 'Annual',
      'color': Colors.cyan,
      'icon': Icons.air,
      'importance': 'Recommended',
      'sideEffects': 'Soreness at injection site, mild fever, muscle aches',
      'schedule': ['Annually before flu season'],
    },
    {
      'name': 'Pneumococcal Vaccine',
      'fullName': 'Pneumococcal Conjugate/Polysaccharide',
      'description': 'Protects against pneumococcal bacteria causing pneumonia, meningitis, and blood infections.',
      'ageGroup': 'Seniors (65+ years)',
      'recommendedAge': '65 years and older',
      'doses': '1-2 doses',
      'color': Colors.amber,
      'icon': Icons.elderly,
      'importance': 'Critical',
      'sideEffects': 'Mild pain, redness at injection site, fatigue',
      'schedule': ['65 years', 'Second dose 1 year later if needed'],
    },
    {
      'name': 'Shingles Vaccine',
      'fullName': 'Herpes Zoster Vaccine',
      'description': 'Prevents shingles, a painful rash caused by reactivation of chickenpox virus.',
      'ageGroup': 'Seniors (65+ years)',
      'recommendedAge': '50 years and older',
      'doses': '2 doses',
      'color': Colors.deepOrange,
      'icon': Icons.warning,
      'importance': 'Recommended',
      'sideEffects': 'Muscle pain, fatigue, headache, fever',
      'schedule': ['50+ years', '2-6 months after first dose'],
    },
    {
      'name': 'COVID-19 Vaccine',
      'fullName': 'COVID-19 mRNA or Viral Vector',
      'description': 'Protects against COVID-19, preventing severe illness, hospitalization, and death.',
      'ageGroup': 'All Ages',
      'recommendedAge': '6 months and older',
      'doses': '2-3 doses + boosters',
      'color': Colors.deepPurple,
      'icon': Icons.coronavirus,
      'importance': 'Critical',
      'sideEffects': 'Fatigue, headache, muscle pain, fever, chills',
      'schedule': ['Primary series + annual boosters'],
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _filteredVaccines {
    if (_selectedAgeGroup == 'All Ages') {
      return _vaccines;
    }
    return _vaccines.where((vaccine) => 
      vaccine['ageGroup'] == _selectedAgeGroup || vaccine['ageGroup'] == 'All Ages'
    ).toList();
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
          'Vaccination Guide',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: const Color(0xFF4FC3F7),
          unselectedLabelColor: Colors.grey,
          indicatorColor: const Color(0xFF4FC3F7),
          tabs: const [
            Tab(text: 'Vaccines'),
            Tab(text: 'Schedule'),
            Tab(text: 'Info'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildVaccinesTab(),
          _buildScheduleTab(),
          _buildInfoTab(),
        ],
      ),
    );
  }

  Widget _buildVaccinesTab() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Filter by Age Group',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 40,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _ageGroups.length,
                  itemBuilder: (context, index) {
                    final isSelected = _selectedAgeGroup == _ageGroups[index];
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedAgeGroup = _ageGroups[index];
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected ? const Color(0xFF4FC3F7) : Colors.grey[200],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Center(
                          child: Text(
                            _ageGroups[index],
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.black87,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              fontSize: 13,
                            ),
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
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _filteredVaccines.length,
            itemBuilder: (context, index) {
              return _buildVaccineCard(_filteredVaccines[index]);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildVaccineCard(Map<String, dynamic> vaccine) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
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
                  (vaccine['color'] as Color).withOpacity(0.7),
                  vaccine['color'] as Color,
                ],
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(vaccine['icon'], color: Colors.white, size: 32),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        vaccine['name'],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        vaccine['fullName'],
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    vaccine['importance'],
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoRow(Icons.info_outline, 'What it prevents', vaccine['description']),
                const SizedBox(height: 16),
                _buildInfoRow(Icons.calendar_today, 'Recommended Age', vaccine['recommendedAge']),
                const SizedBox(height: 16),
                _buildInfoRow(Icons.medical_services, 'Number of Doses', vaccine['doses']),
                const SizedBox(height: 16),
                _buildInfoRow(Icons.people, 'Age Group', vaccine['ageGroup']),
                const SizedBox(height: 16),
                _buildInfoRow(Icons.warning_amber, 'Common Side Effects', vaccine['sideEffects']),
                const SizedBox(height: 20),
                const Text(
                  'Vaccination Schedule:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                const SizedBox(height: 8),
                ...List.generate(
                  (vaccine['schedule'] as List).length,
                  (index) => Padding(
                    padding: const EdgeInsets.only(left: 16, bottom: 4),
                    child: Row(
                      children: [
                        const Icon(Icons.circle, size: 6, color: Color(0xFF4FC3F7)),
                        const SizedBox(width: 8),
                        Text(
                          vaccine['schedule'][index],
                          style: TextStyle(color: Colors.grey[700], fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: const Color(0xFF4FC3F7), size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[700],
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildScheduleTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildScheduleSection('Birth - 1 Year', [
          {'time': 'At Birth', 'vaccines': ['BCG', 'Hepatitis B (1st dose)']},
          {'time': '2 Months', 'vaccines': ['DTP (1st)', 'Polio (1st)', 'Hepatitis B (2nd)']},
          {'time': '4 Months', 'vaccines': ['DTP (2nd)', 'Polio (2nd)']},
          {'time': '6 Months', 'vaccines': ['DTP (3rd)', 'Polio (3rd)', 'Hepatitis B (3rd)']},
        ]),
        _buildScheduleSection('1 - 6 Years', [
          {'time': '12-15 Months', 'vaccines': ['MMR (1st)', 'Varicella (1st)']},
          {'time': '15-18 Months', 'vaccines': ['DTP (4th)']},
          {'time': '4-6 Years', 'vaccines': ['DTP (5th)', 'Polio (4th)', 'MMR (2nd)', 'Varicella (2nd)']},
        ]),
        _buildScheduleSection('7 - 18 Years', [
          {'time': '11-12 Years', 'vaccines': ['HPV (1st)', 'Tdap Booster']},
          {'time': '6-12 Months Later', 'vaccines': ['HPV (2nd)']},
        ]),
        _buildScheduleSection('Adults (19-64 Years)', [
          {'time': 'Every 10 Years', 'vaccines': ['Tdap Booster']},
          {'time': 'Annually', 'vaccines': ['Influenza']},
        ]),
        _buildScheduleSection('Seniors (65+ Years)', [
          {'time': 'Once at 65', 'vaccines': ['Pneumococcal']},
          {'time': '50+ Years', 'vaccines': ['Shingles']},
          {'time': 'Annually', 'vaccines': ['Influenza']},
        ]),
      ],
    );
  }

  Widget _buildScheduleSection(String title, List<Map<String, dynamic>> items) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF4FC3F7).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.calendar_month, color: Color(0xFF4FC3F7), size: 20),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...List.generate(items.length, (index) {
            final item = items[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 100,
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      item['time'],
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: List.generate(
                        (item['vaccines'] as List).length,
                        (vIndex) => Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Row(
                            children: [
                              const Icon(Icons.check_circle, size: 16, color: Colors.green),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  item['vaccines'][vIndex],
                                  style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildInfoTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildInfoCard(
          'Why Vaccines Are Important',
          'Vaccines are one of the most effective ways to prevent serious diseases. They work by training your immune system to recognize and fight specific infections. Vaccination not only protects you but also helps protect vulnerable members of the community who cannot be vaccinated.',
          Icons.shield_outlined,
          Colors.blue,
        ),
        _buildInfoCard(
          'How Vaccines Work',
          'Vaccines contain weakened or inactive parts of a particular organism (antigen) that triggers an immune response. Your body then produces antibodies to fight this antigen. If you\'re exposed to the actual disease in the future, your immune system will recognize it and fight it off.',
          Icons.science,
          Colors.purple,
        ),
        _buildInfoCard(
          'Vaccine Safety',
          'All vaccines undergo rigorous testing before approval and continuous monitoring after release. Side effects are typically mild (soreness, low-grade fever) and temporary. Serious side effects are extremely rare. The benefits of vaccination far outweigh the risks.',
          Icons.verified_user,
          Colors.green,
        ),
        _buildInfoCard(
          'What to Expect',
          'Before vaccination: Inform your doctor about allergies or previous reactions. After vaccination: Monitor for side effects, stay hydrated, and rest if needed. Most side effects resolve within a few days. Contact your healthcare provider if you have concerns.',
          Icons.event_note,
          Colors.orange,
        ),
        _buildInfoCard(
          'Herd Immunity',
          'When a large portion of the population is vaccinated, it becomes harder for diseases to spread. This protects those who cannot be vaccinated (infants, immunocompromised individuals, pregnant women). Community-wide vaccination helps eliminate diseases entirely.',
          Icons.groups,
          Colors.teal,
        ),
      ],
    );
  }

  Widget _buildInfoCard(String title, String content, IconData icon, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            content,
            style: TextStyle(fontSize: 14, color: Colors.grey[700], height: 1.5),
          ),
        ],
      ),
    );
  }
}