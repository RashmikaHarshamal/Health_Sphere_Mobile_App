// lib/superadmin/analytics_page.dart
import 'package:flutter/material.dart';

class AnalyticsPage extends StatelessWidget {
  const AnalyticsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text('Analytics Overview', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        const SizedBox(height: 20),
        _buildMonthlyStats(),
        const SizedBox(height: 20),
        _buildRevenueCard(),
        const SizedBox(height: 20),
        _buildTopHospitals(),
      ],
    );
  }

  Widget _buildMonthlyStats() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Monthly Growth', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(child: _buildGrowthCard('New Hospitals', '+8', '15%', Colors.blue)),
              const SizedBox(width: 12),
              Expanded(child: _buildGrowthCard('New Doctors', '+156', '22%', Colors.green)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _buildGrowthCard('Patients', '+2.4K', '18%', Colors.purple)),
              const SizedBox(width: 12),
              Expanded(child: _buildGrowthCard('Appointments', '+890', '12%', Colors.orange)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGrowthCard(String title, String value, String percentage, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontSize: 12, color: Colors.grey[700])),
          const SizedBox(height: 8),
          Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color)),
          Row(
            children: [
              Icon(Icons.trending_up, size: 14, color: Colors.green),
              Text(' $percentage', style: const TextStyle(fontSize: 12, color: Colors.green, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRevenueCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFF4FC3F7), Color(0xFF2196F3)]),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Total Revenue', style: TextStyle(color: Colors.white70, fontSize: 14)),
          const SizedBox(height: 8),
          const Text('\$2,450,000', style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text('This month', style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildTopHospitals() {
    final hospitals = [
      {'name': 'City General Hospital', 'appointments': 1234, 'revenue': '\$45,000'},
      {'name': 'Metro Medical Center', 'appointments': 987, 'revenue': '\$38,500'},
      {'name': 'St. Mary Hospital', 'appointments': 856, 'revenue': '\$32,100'},
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Top Performing Hospitals', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          ...hospitals.asMap().entries.map((e) {
            final index = e.key;
            final hospital = e.value;
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: const Color(0xFF4FC3F7).withOpacity(0.2),
                    child: Text('${index + 1}', style: const TextStyle(color: Color(0xFF4FC3F7), fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(hospital['name'] as String, style: const TextStyle(fontWeight: FontWeight.w600)),
                        Text('${hospital['appointments']} appointments', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                      ],
                    ),
                  ),
                  Text(hospital['revenue'] as String, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}