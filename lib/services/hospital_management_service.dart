// lib/services/hospital_management_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class RegistrationResult {
  final bool success;
  final String message;
  final String? hospitalId;

  RegistrationResult({
    required this.success,
    required this.message,
    this.hospitalId,
  });
}

class HospitalManagementService {
  static final HospitalManagementService _instance = HospitalManagementService._internal();
  
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  HospitalManagementService._internal();

  factory HospitalManagementService() {
    return _instance;
  }

  /// Register a new hospital
  Future<RegistrationResult> registerHospital({
    required String adminId,
    required String adminName,
    required String adminEmail,
    required String hospitalName,
    required String hospitalEmail,
    required String hospitalPhone,
    required String hospitalAddress,
    required String city,
    required String state,
    required String zipCode,
    required String registrationNumber,
    required String licenseNumber,
    required int establishedYear,
    required String hospitalType,
    required List<String> facilities,
    required int totalBeds,
    int? totalDoctors,
    String? website,
  }) async {
    try {
      // Create hospital document
      final hospitalData = {
        'adminId': adminId,
        'adminName': adminName,
        'adminEmail': adminEmail,
        'hospitalName': hospitalName,
        'hospitalEmail': hospitalEmail,
        'hospitalPhone': hospitalPhone,
        'hospitalAddress': hospitalAddress,
        'city': city,
        'state': state,
        'zipCode': zipCode,
        'registrationNumber': registrationNumber,
        'licenseNumber': licenseNumber,
        'establishedYear': establishedYear,
        'hospitalType': hospitalType,
        'facilities': facilities,
        'totalBeds': totalBeds,
        'totalDoctors': totalDoctors ?? 0,
        'website': website ?? '',
        'status': 'pending', // pending, approved, rejected, suspended
        'verificationStatus': 'pending_verification',
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
        'approvedAt': null,
        'approvedBy': null,
      };

      // Add to hospitals collection
      final docRef = await _firestore.collection('hospitals').add(hospitalData);
      
      return RegistrationResult(
        success: true,
        message: 'Hospital registration submitted successfully. Your application is under review.',
        hospitalId: docRef.id,
      );
    } catch (e) {
      return RegistrationResult(
        success: false,
        message: 'Failed to register hospital: $e',
      );
    }
  }

  /// Get all hospitals (for super admin)
  Future<List<Map<String, dynamic>>> getAllHospitals() async {
    try {
      final snapshot = await _firestore.collection('hospitals').get();
      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['hospitalId'] = doc.id;
        return data;
      }).toList();
    } catch (e) {
      throw Exception('Failed to fetch hospitals: $e');
    }
  }

  /// Get hospitals by status
  Future<List<Map<String, dynamic>>> getHospitalsByStatus(String status) async {
    try {
      final snapshot = await _firestore
          .collection('hospitals')
          .where('status', isEqualTo: status)
          .get();
      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['hospitalId'] = doc.id;
        return data;
      }).toList();
    } catch (e) {
      throw Exception('Failed to fetch hospitals by status: $e');
    }
  }

  /// Get hospital by ID
  Future<Map<String, dynamic>?> getHospital(String hospitalId) async {
    try {
      final doc = await _firestore.collection('hospitals').doc(hospitalId).get();
      if (doc.exists) {
        final data = doc.data() ?? {};
        data['hospitalId'] = hospitalId;
        return data;
      }
      return null;
    } catch (e) {
      throw Exception('Failed to fetch hospital: $e');
    }
  }

  /// Get hospital by admin ID
  Future<Map<String, dynamic>?> getHospitalByAdminId(String adminId) async {
    try {
      final snapshot = await _firestore
          .collection('hospitals')
          .where('adminId', isEqualTo: adminId)
          .limit(1)
          .get();
      
      if (snapshot.docs.isNotEmpty) {
        final data = snapshot.docs.first.data();
        data['hospitalId'] = snapshot.docs.first.id;
        return data;
      }
      return null;
    } catch (e) {
      throw Exception('Failed to fetch hospital by admin: $e');
    }
  }

  /// Approve hospital (super admin only)
  Future<void> approveHospital(String hospitalId, String approvedBy) async {
    try {
      await _firestore.collection('hospitals').doc(hospitalId).update({
        'status': 'approved',
        'verificationStatus': 'verified',
        'approvedAt': FieldValue.serverTimestamp(),
        'approvedBy': approvedBy,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to approve hospital: $e');
    }
  }

  /// Reject hospital (super admin only)
  Future<void> rejectHospital(String hospitalId, String reason) async {
    try {
      await _firestore.collection('hospitals').doc(hospitalId).update({
        'status': 'rejected',
        'rejectionReason': reason,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to reject hospital: $e');
    }
  }

  /// Update hospital information
  Future<void> updateHospital(String hospitalId, Map<String, dynamic> data) async {
    try {
      data['updatedAt'] = FieldValue.serverTimestamp();
      await _firestore.collection('hospitals').doc(hospitalId).update(data);
    } catch (e) {
      throw Exception('Failed to update hospital: $e');
    }
  }

  /// Stream of hospitals (real-time updates)
  Stream<List<Map<String, dynamic>>> getHospitalsStream() {
    return _firestore.collection('hospitals').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['hospitalId'] = doc.id;
        return data;
      }).toList();
    });
  }

  /// Stream of pending hospitals (real-time updates)
  Stream<List<Map<String, dynamic>>> getPendingHospitalsStream() {
    return _firestore
        .collection('hospitals')
        .where('status', isEqualTo: 'pending')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['hospitalId'] = doc.id;
        return data;
      }).toList();
    });
  }

  /// Get hospital statistics
  Future<Map<String, int>> getHospitalStatistics() async {
    try {
      final allSnapshot = await _firestore.collection('hospitals').get();
      final approvedSnapshot = await _firestore
          .collection('hospitals')
          .where('status', isEqualTo: 'approved')
          .get();
      final pendingSnapshot = await _firestore
          .collection('hospitals')
          .where('status', isEqualTo: 'pending')
          .get();
      final rejectedSnapshot = await _firestore
          .collection('hospitals')
          .where('status', isEqualTo: 'rejected')
          .get();

      return {
        'total': allSnapshot.docs.length,
        'approved': approvedSnapshot.docs.length,
        'pending': pendingSnapshot.docs.length,
        'rejected': rejectedSnapshot.docs.length,
      };
    } catch (e) {
      throw Exception('Failed to get hospital statistics: $e');
    }
  }
}
