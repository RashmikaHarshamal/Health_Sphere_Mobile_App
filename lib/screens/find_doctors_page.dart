import 'package:flutter/material.dart';
import 'appointment_form_page.dart';
import '../services/firebase_database_service.dart';

class FindDoctorsPage extends StatefulWidget {
  const FindDoctorsPage({super.key});

  @override
  State<FindDoctorsPage> createState() => _FindDoctorsPageState();
}

class _FindDoctorsPageState extends State<FindDoctorsPage> {
  String? _selectedCity;
  String? _selectedHospital;
  String _selectedSpecialty = 'All';
  final _dbService = FirebaseDatabaseService();

  // Sri Lankan Cities
  final List<String> _cities = [
    'Colombo',
    'Negombo',
    'Gampaha',
    'Kandy',
    'Galle',
    'Jaffna',
    'Kurunegala',
    'Anuradhapura',
    'Ratnapura',
    'Batticaloa',
  ];

  // Hospitals by City
  final Map<String, List<Map<String, dynamic>>> _hospitalsByCity = {
    'Colombo': [
      {'name': 'Asiri Central Hospital', 'type': 'Private'},
      {'name': 'Nawaloka Hospital', 'type': 'Private'},
      {'name': 'Durdans Hospital', 'type': 'Private'},
      {'name': 'National Hospital of Sri Lanka', 'type': 'Government'},
      {'name': 'Lanka Hospital', 'type': 'Private'},
    ],
    'Negombo': [
      {'name': 'Negombo General Hospital', 'type': 'Government'},
      {'name': 'Negombo District Hospital', 'type': 'Government'},
      {'name': 'Medicare Hospital Negombo', 'type': 'Private'},
    ],
    'Gampaha': [
      {'name': 'Gampaha District Hospital', 'type': 'Government'},
      {'name': 'Asiri Hospital Gampaha', 'type': 'Private'},
    ],
    'Kandy': [
      {'name': 'Kandy General Hospital', 'type': 'Government'},
      {'name': 'Asiri Central Hospital Kandy', 'type': 'Private'},
      {'name': 'Suwa Sahana Hospital', 'type': 'Private'},
    ],
    'Galle': [
      {'name': 'Karapitiya Teaching Hospital', 'type': 'Government'},
      {'name': 'Ruhunu Hospital', 'type': 'Private'},
    ],
    'Jaffna': [
      {'name': 'Jaffna Teaching Hospital', 'type': 'Government'},
      {'name': 'Manipay Hospital', 'type': 'Private'},
    ],
    'Kurunegala': [
      {'name': 'Kurunegala Teaching Hospital', 'type': 'Government'},
      {'name': 'Neville Fernando Hospital', 'type': 'Private'},
    ],
    'Anuradhapura': [
      {'name': 'Anuradhapura Teaching Hospital', 'type': 'Government'},
    ],
    'Ratnapura': [
      {'name': 'Ratnapura General Hospital', 'type': 'Government'},
    ],
    'Batticaloa': [
      {'name': 'Batticaloa Teaching Hospital', 'type': 'Government'},
    ],
  };

  final List<Map<String, dynamic>> _specialties = [
    {'name': 'All', 'icon': Icons.medical_services, 'color': Colors.blue},
    {'name': 'Cardiologist', 'icon': Icons.favorite, 'color': Colors.red},
    {'name': 'Dentist', 'icon': Icons.medical_services, 'color': Colors.teal},
    {'name': 'Dermatologist', 'icon': Icons.healing, 'color': Colors.purple},
    {'name': 'Pediatrician', 'icon': Icons.child_care, 'color': Colors.pink},
    {'name': 'Orthopedic', 'icon': Icons.accessibility, 'color': Colors.orange},
    {'name': 'Neurologist', 'icon': Icons.psychology, 'color': Colors.indigo},
    {'name': 'General', 'icon': Icons.local_hospital, 'color': Colors.green},
    {'name': 'ENT Specialist', 'icon': Icons.hearing, 'color': Colors.cyan},
    {'name': 'Gynecologist', 'icon': Icons.pregnant_woman, 'color': Colors.pinkAccent},
  ];

  // All Doctors with City and Hospital info
  final List<Map<String, dynamic>> _allDoctors = [
    // Colombo - Asiri Central Hospital
    {
      'name': 'Dr. Nimali Fernando',
      'specialty': 'Cardiologist',
      'city': 'Colombo',
      'hospital': 'Asiri Central Hospital',
      'rating': 4.9,
      'reviews': 127,
      'experience': '15 years',
      'fee': 'Rs. 3,500',
      'image': Icons.person,
      'color': Colors.red,
      'availability': 'Available Today',
      'about': 'Specializes in heart diseases and cardiovascular health with international training.',
    },
    {
      'name': 'Dr. Rohan Perera',
      'specialty': 'Neurologist',
      'city': 'Colombo',
      'hospital': 'Asiri Central Hospital',
      'rating': 4.9,
      'reviews': 189,
      'experience': '20 years',
      'fee': 'Rs. 4,000',
      'image': Icons.person,
      'color': Colors.indigo,
      'availability': 'Available Today',
      'about': 'Expert in neurological disorders and brain health.',
    },
    
    // Colombo - Nawaloka Hospital
    {
      'name': 'Dr. Shanika Silva',
      'specialty': 'Pediatrician',
      'city': 'Colombo',
      'hospital': 'Nawaloka Hospital',
      'rating': 4.8,
      'reviews': 176,
      'experience': '16 years',
      'fee': 'Rs. 2,500',
      'image': Icons.person,
      'color': Colors.pink,
      'availability': 'Available Today',
      'about': 'Dedicated to children\'s health and development.',
    },
    {
      'name': 'Dr. Kasun Wickramasinghe',
      'specialty': 'Orthopedic',
      'city': 'Colombo',
      'hospital': 'Nawaloka Hospital',
      'rating': 4.9,
      'reviews': 203,
      'experience': '18 years',
      'fee': 'Rs. 3,800',
      'image': Icons.person,
      'color': Colors.orange,
      'availability': 'Available Tomorrow',
      'about': 'Expert in bone, joint and sports injuries treatment.',
    },

    // Colombo - National Hospital
    {
      'name': 'Dr. Priyanka Jayawardena',
      'specialty': 'General',
      'city': 'Colombo',
      'hospital': 'National Hospital of Sri Lanka',
      'rating': 4.7,
      'reviews': 98,
      'experience': '10 years',
      'fee': 'Rs. 1,000',
      'image': Icons.person,
      'color': Colors.green,
      'availability': 'Available Tomorrow',
      'about': 'Expert in general medicine and family healthcare.',
    },

    // Negombo
    {
      'name': 'Dr. Dilshan Amarasinghe',
      'specialty': 'Dentist',
      'city': 'Negombo',
      'hospital': 'Medicare Hospital Negombo',
      'rating': 4.8,
      'reviews': 142,
      'experience': '14 years',
      'fee': 'Rs. 2,000',
      'image': Icons.person,
      'color': Colors.teal,
      'availability': 'Available Today',
      'about': 'Specialized in dental surgery and oral health.',
    },
    {
      'name': 'Dr. Chamari Rajapaksha',
      'specialty': 'Dermatologist',
      'city': 'Negombo',
      'hospital': 'Negombo General Hospital',
      'rating': 4.7,
      'reviews': 156,
      'experience': '12 years',
      'fee': 'Rs. 1,500',
      'image': Icons.person,
      'color': Colors.purple,
      'availability': 'Available Today',
      'about': 'Specialist in skin care and dermatology treatments.',
    },

    // Kandy
    {
      'name': 'Dr. Nuwan Dissanayake',
      'specialty': 'Cardiologist',
      'city': 'Kandy',
      'hospital': 'Asiri Central Hospital Kandy',
      'rating': 4.8,
      'reviews': 134,
      'experience': '13 years',
      'fee': 'Rs. 3,000',
      'image': Icons.person,
      'color': Colors.red,
      'availability': 'Available Tomorrow',
      'about': 'Specialist in heart surgery and cardiac care.',
    },
    {
      'name': 'Dr. Malini Rathnayake',
      'specialty': 'Gynecologist',
      'city': 'Kandy',
      'hospital': 'Kandy General Hospital',
      'rating': 4.9,
      'reviews': 201,
      'experience': '17 years',
      'fee': 'Rs. 1,200',
      'image': Icons.person,
      'color': Colors.pinkAccent,
      'availability': 'Available Today',
      'about': 'Expert in women\'s health and maternity care.',
    },

    // Galle
    {
      'name': 'Dr. Tharindu Gunasekara',
      'specialty': 'ENT Specialist',
      'city': 'Galle',
      'hospital': 'Karapitiya Teaching Hospital',
      'rating': 4.7,
      'reviews': 89,
      'experience': '11 years',
      'fee': 'Rs. 1,500',
      'image': Icons.person,
      'color': Colors.cyan,
      'availability': 'Available Today',
      'about': 'Specialist in ear, nose, and throat conditions.',
    },
    {
      'name': 'Dr. Sandali Wickremaratne',
      'specialty': 'Dermatologist',
      'city': 'Galle',
      'hospital': 'Ruhunu Hospital',
      'rating': 4.9,
      'reviews': 167,
      'experience': '11 years',
      'fee': 'Rs. 2,500',
      'image': Icons.person,
      'color': Colors.purple,
      'availability': 'Available Today',
      'about': 'Expert in acne treatment and anti-aging solutions.',
    },

    // Gampaha
    {
      'name': 'Dr. Isuru Bandara',
      'specialty': 'General',
      'city': 'Gampaha',
      'hospital': 'Gampaha District Hospital',
      'rating': 4.6,
      'reviews': 76,
      'experience': '9 years',
      'fee': 'Rs. 800',
      'image': Icons.person,
      'color': Colors.green,
      'availability': 'Available Tomorrow',
      'about': 'General practitioner with focus on preventive care.',
    },

    // Jaffna
    {
      'name': 'Dr. Nithya Selvarajah',
      'specialty': 'Pediatrician',
      'city': 'Jaffna',
      'hospital': 'Jaffna Teaching Hospital',
      'rating': 4.8,
      'reviews': 112,
      'experience': '14 years',
      'fee': 'Rs. 1,000',
      'image': Icons.person,
      'color': Colors.pink,
      'availability': 'Available Today',
      'about': 'Specialist in child health and pediatric care.',
    },

    // Kurunegala
    {
      'name': 'Dr. Chaminda Herath',
      'specialty': 'Orthopedic',
      'city': 'Kurunegala',
      'hospital': 'Neville Fernando Hospital',
      'rating': 4.7,
      'reviews': 145,
      'experience': '15 years',
      'fee': 'Rs. 2,800',
      'image': Icons.person,
      'color': Colors.orange,
      'availability': 'Available Today',
      'about': 'Specialized in joint replacement and spine surgery.',
    },
  ];

  List<Map<String, dynamic>> get _filteredDoctors {
    return _allDoctors.where((doctor) {
      bool matchesCity = _selectedCity == null || doctor['city'] == _selectedCity;
      bool matchesHospital = _selectedHospital == null || doctor['hospital'] == _selectedHospital;
      bool matchesSpecialty = _selectedSpecialty == 'All' || doctor['specialty'] == _selectedSpecialty;
      return matchesCity && matchesHospital && matchesSpecialty;
    }).toList();
  }

  List<Map<String, dynamic>> get _availableHospitals {
    if (_selectedCity == null) return [];
    return _hospitalsByCity[_selectedCity] ?? [];
  }

  void _showCityPicker() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select City',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _cities.length,
                itemBuilder: (context, index) {
                  final city = _cities[index];
                  final isSelected = _selectedCity == city;
                  return ListTile(
                    leading: Icon(
                      Icons.location_city,
                      color: isSelected ? const Color(0xFF4FC3F7) : Colors.grey,
                    ),
                    title: Text(
                      city,
                      style: TextStyle(
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        color: isSelected ? const Color(0xFF4FC3F7) : Colors.black87,
                      ),
                    ),
                    trailing: isSelected ? const Icon(Icons.check, color: Color(0xFF4FC3F7)) : null,
                    onTap: () {
                      setState(() {
                        _selectedCity = city;
                        _selectedHospital = null; // Reset hospital when city changes
                      });
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showHospitalPicker() {
    if (_selectedCity == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a city first'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Hospital in $_selectedCity',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _availableHospitals.length,
                itemBuilder: (context, index) {
                  final hospital = _availableHospitals[index];
                  final isSelected = _selectedHospital == hospital['name'];
                  return ListTile(
                    leading: Icon(
                      Icons.local_hospital,
                      color: isSelected ? const Color(0xFF4FC3F7) : Colors.grey,
                    ),
                    title: Text(
                      hospital['name'],
                      style: TextStyle(
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        color: isSelected ? const Color(0xFF4FC3F7) : Colors.black87,
                      ),
                    ),
                    subtitle: Text(
                      hospital['type'],
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                    trailing: isSelected ? const Icon(Icons.check, color: Color(0xFF4FC3F7)) : null,
                    onTap: () {
                      setState(() {
                        _selectedHospital = hospital['name'];
                      });
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterSection() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Filter by Location',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildFilterChip(
                  icon: Icons.location_city,
                  label: _selectedCity ?? 'Select City',
                  isSelected: _selectedCity != null,
                  onTap: _showCityPicker,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildFilterChip(
                  icon: Icons.local_hospital,
                  label: _selectedHospital ?? 'Select Hospital',
                  isSelected: _selectedHospital != null,
                  onTap: _showHospitalPicker,
                ),
              ),
            ],
          ),
          if (_selectedCity != null || _selectedHospital != null) ...[
            const SizedBox(height: 12),
            TextButton.icon(
              onPressed: () {
                setState(() {
                  _selectedCity = null;
                  _selectedHospital = null;
                });
              },
              icon: const Icon(Icons.clear, size: 18),
              label: const Text('Clear Filters'),
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildFilterChip({
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF4FC3F7).withOpacity(0.1) : Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? const Color(0xFF4FC3F7) : Colors.grey.shade300,
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? const Color(0xFF4FC3F7) : Colors.grey[600],
              size: 20,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  color: isSelected ? const Color(0xFF4FC3F7) : Colors.grey[700],
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  fontSize: 13,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Icon(
              Icons.arrow_drop_down,
              color: isSelected ? const Color(0xFF4FC3F7) : Colors.grey[600],
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSpecialtyChip(Map<String, dynamic> specialty) {
    final isSelected = _selectedSpecialty == specialty['name'];
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedSpecialty = specialty['name'];
        });
      },
      child: Container(
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
                  colors: [
                    (specialty['color'] as Color).withOpacity(0.8),
                    specialty['color'] as Color,
                  ],
                )
              : null,
          color: isSelected ? null : Colors.white,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: isSelected ? Colors.transparent : Colors.grey.shade300,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? (specialty['color'] as Color).withOpacity(0.3)
                  : Colors.grey.withOpacity(0.1),
              blurRadius: isSelected ? 8 : 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              specialty['icon'],
              color: isSelected ? Colors.white : specialty['color'],
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              specialty['name'],
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black87,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDoctorCard(Map<String, dynamic> doctor) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
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
                  (doctor['color'] as Color).withOpacity(0.1),
                  (doctor['color'] as Color).withOpacity(0.05),
                ],
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: doctor['color'],
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: (doctor['color'] as Color).withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Icon(
                        doctor['image'],
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            doctor['name'],
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            doctor['specialty'],
                            style: TextStyle(
                              color: doctor['color'],
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(Icons.star, color: Colors.amber, size: 16),
                              const SizedBox(width: 4),
                              Text(
                                '${doctor['rating']}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '(${doctor['reviews']})',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.green, width: 1),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                              color: Colors.green,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          const Text(
                            'Available',
                            style: TextStyle(
                              color: Colors.green,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        '${doctor['hospital']}, ${doctor['city']}',
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 13,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  doctor['about'],
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildInfoChip(
                        Icons.work_outline,
                        doctor['experience'],
                        'Experience',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildInfoChip(
                        Icons.local_hospital_outlined,
                        doctor['hospital'],
                        'Hospital',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildInfoChip(
                        Icons.access_time,
                        doctor['availability'],
                        'Next Available',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildInfoChip(
                        Icons.attach_money,
                        doctor['fee'],
                        'Consultation Fee',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          _showDoctorDetails(doctor);
                        },
                        icon: const Icon(Icons.info_outline, size: 18),
                        label: const Text('View Profile'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF4FC3F7),
                          side: const BorderSide(color: Color(0xFF4FC3F7)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          _bookAppointment(doctor);
                        },
                        icon: const Icon(Icons.calendar_today, size: 18),
                        label: const Text('Book Now'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4FC3F7),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          elevation: 2,
                        ),
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

  Widget _buildInfoChip(IconData icon, String value, String label) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: Colors.grey[600]),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  void _showDoctorDetails(Map<String, dynamic> doctor) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.75,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) => SingleChildScrollView(
          controller: scrollController,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 50,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(30),
                    decoration: BoxDecoration(
                      color: doctor['color'],
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      doctor['image'],
                      color: Colors.white,
                      size: 50,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: Text(
                    doctor['name'],
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Center(
                  child: Text(
                    doctor['specialty'],
                    style: TextStyle(
                      color: doctor['color'],
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'About',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  doctor['about'],
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Details',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                _buildDetailRow(Icons.location_city, 'City', doctor['city']),
                _buildDetailRow(Icons.local_hospital, 'Hospital', doctor['hospital']),
                _buildDetailRow(Icons.work, 'Experience', doctor['experience']),
                _buildDetailRow(Icons.star, 'Rating', '${doctor['rating']} (${doctor['reviews']} reviews)'),
                _buildDetailRow(Icons.attach_money, 'Fee', doctor['fee']),
                _buildDetailRow(Icons.access_time, 'Availability', doctor['availability']),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      _bookAppointment(doctor);
                    },
                    icon: const Icon(Icons.calendar_today),
                    label: const Text('Book Appointment'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4FC3F7),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 12),
          Text(
            '$label:',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _bookAppointment(Map<String, dynamic> doctor) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AppointmentFormPage(doctor: doctor),
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Find Doctors',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black87),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildFilterSection(),
          const SizedBox(height: 8),
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'Specialties',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 50,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _specialties.length,
                    itemBuilder: (context, index) {
                      return _buildSpecialtyChip(_specialties[index]);
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Text(
              '${_filteredDoctors.length} Doctors Available',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: _filteredDoctors.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.person_search,
                          size: 80,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No doctors found',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Try adjusting your filters',
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.only(top: 8, bottom: 16),
                    itemCount: _filteredDoctors.length,
                    itemBuilder: (context, index) {
                      return _buildDoctorCard(_filteredDoctors[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}