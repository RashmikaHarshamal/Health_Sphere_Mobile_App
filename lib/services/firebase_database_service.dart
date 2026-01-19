// lib/services/firebase_database_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseDatabaseService {
  static final FirebaseDatabaseService _instance = FirebaseDatabaseService._internal();
  
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  FirebaseDatabaseService._internal();

  factory FirebaseDatabaseService() {
    return _instance;
  }

  // ==================== USERS ====================
  
  /// Save user data
  Future<void> saveUser({
    required String userId,
    required String name,
    required String email,
    required String userType, // 'patient', 'doctor', 'hospital_admin', 'super_admin'
    String? phone,
    String? profileImage,
    Map<String, dynamic>? additionalData,
  }) async {
    try {
      final userData = {
        'userId': userId,
        'name': name,
        'email': email,
        'userType': userType,
        'phone': phone,
        'profileImage': profileImage,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
        ...?additionalData,
      };

      await _firestore.collection('users').doc(userId).set(userData);
    } catch (e) {
      throw Exception('Failed to save user: $e');
    }
  }

  /// Get user data
  Future<Map<String, dynamic>?> getUser(String userId) async {
    try {
      final doc = await _firestore.collection('users').doc(userId).get();
      return doc.data();
    } catch (e) {
      throw Exception('Failed to get user: $e');
    }
  }

  /// Update user data
  Future<void> updateUser(String userId, Map<String, dynamic> data) async {
    try {
      data['updatedAt'] = FieldValue.serverTimestamp();
      await _firestore.collection('users').doc(userId).update(data);
    } catch (e) {
      throw Exception('Failed to update user: $e');
    }
  }

  // ==================== APPOINTMENTS ====================

  /// Save appointment
  Future<String> saveAppointment({
    required String patientId,
    required String doctorId,
    required String appointmentDate,
    required String timeSlot,
    String? notes,
    String status = 'scheduled', // 'scheduled', 'completed', 'cancelled'
    Map<String, dynamic>? additionalData,
  }) async {
    try {
      final appointmentData = {
        'patientId': patientId,
        'doctorId': doctorId,
        'appointmentDate': appointmentDate,
        'timeSlot': timeSlot,
        'notes': notes,
        'status': status,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
        ...?additionalData,
      };

      final docRef = await _firestore.collection('appointments').add(appointmentData);
      return docRef.id;
    } catch (e) {
      throw Exception('Failed to save appointment: $e');
    }
  }

  /// Get patient appointments
  Future<List<Map<String, dynamic>>> getPatientAppointments(String patientId) async {
    try {
      final snapshot = await _firestore
          .collection('appointments')
          .where('patientId', isEqualTo: patientId)
          .orderBy('appointmentDate', descending: true)
          .get();

      return snapshot.docs.map((doc) => {...doc.data(), 'id': doc.id}).toList();
    } catch (e) {
      throw Exception('Failed to get appointments: $e');
    }
  }

  /// Get doctor appointments
  Future<List<Map<String, dynamic>>> getDoctorAppointments(String doctorId) async {
    try {
      final snapshot = await _firestore
          .collection('appointments')
          .where('doctorId', isEqualTo: doctorId)
          .orderBy('appointmentDate', descending: true)
          .get();

      return snapshot.docs.map((doc) => {...doc.data(), 'id': doc.id}).toList();
    } catch (e) {
      throw Exception('Failed to get doctor appointments: $e');
    }
  }

  /// Update appointment status
  Future<void> updateAppointmentStatus(String appointmentId, String status) async {
    try {
      await _firestore.collection('appointments').doc(appointmentId).update({
        'status': status,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to update appointment: $e');
    }
  }

  // ==================== DOCTORS ====================

  /// Save doctor profile
  Future<void> saveDoctorProfile({
    required String doctorId,
    required String name,
    required String specialty,
    required String hospital,
    required String city,
    required double rating,
    String? experience,
    String? fee,
    String? qualifications,
    String? profileImage,
    Map<String, dynamic>? additionalData,
  }) async {
    try {
      final doctorData = {
        'doctorId': doctorId,
        'name': name,
        'specialty': specialty,
        'hospital': hospital,
        'city': city,
        'rating': rating,
        'experience': experience,
        'fee': fee,
        'qualifications': qualifications,
        'profileImage': profileImage,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
        ...?additionalData,
      };

      await _firestore.collection('doctors').doc(doctorId).set(doctorData);
    } catch (e) {
      throw Exception('Failed to save doctor profile: $e');
    }
  }

  /// Get doctor profile
  Future<Map<String, dynamic>?> getDoctorProfile(String doctorId) async {
    try {
      final doc = await _firestore.collection('doctors').doc(doctorId).get();
      return doc.data();
    } catch (e) {
      throw Exception('Failed to get doctor profile: $e');
    }
  }

  /// Search doctors by specialty and city
  Future<List<Map<String, dynamic>>> searchDoctors({
    String? specialty,
    String? city,
  }) async {
    try {
      Query query = _firestore.collection('doctors');

      if (specialty != null && specialty.isNotEmpty) {
        query = query.where('specialty', isEqualTo: specialty);
      }

      if (city != null && city.isNotEmpty) {
        query = query.where('city', isEqualTo: city);
      }

      final snapshot = await query.get();
      return snapshot.docs.map((doc) => {...doc.data() as Map<String, dynamic>, 'id': doc.id}).toList();
    } catch (e) {
      throw Exception('Failed to search doctors: $e');
    }
  }

  // ==================== ARTICLES ====================

  /// Save health article
  Future<String> saveArticle({
    required String title,
    required String content,
    String? category,
    String? imageUrl,
    List<String>? tags,
    String? authorId,
    Map<String, dynamic>? additionalData,
  }) async {
    try {
      final articleData = {
        'title': title,
        'content': content,
        'category': category,
        'imageUrl': imageUrl,
        'tags': tags,
        'authorId': authorId,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
        ...?additionalData,
      };

      final docRef = await _firestore.collection('articles').add(articleData);
      return docRef.id;
    } catch (e) {
      throw Exception('Failed to save article: $e');
    }
  }

  /// Get all articles
  Future<List<Map<String, dynamic>>> getArticles() async {
    try {
      final snapshot = await _firestore
          .collection('articles')
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs.map((doc) => {...doc.data(), 'id': doc.id}).toList();
    } catch (e) {
      throw Exception('Failed to get articles: $e');
    }
  }

  /// Get article by category
  Future<List<Map<String, dynamic>>> getArticlesByCategory(String category) async {
    try {
      final snapshot = await _firestore
          .collection('articles')
          .where('category', isEqualTo: category)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs.map((doc) => {...doc.data(), 'id': doc.id}).toList();
    } catch (e) {
      throw Exception('Failed to get articles: $e');
    }
  }

  // ==================== VACCINATIONS ====================

  /// Save vaccination record
  Future<String> saveVaccinationRecord({
    required String patientId,
    required String vaccineName,
    required String vaccinationDate,
    String? nextDueDate,
    String? location,
    String? notes,
    Map<String, dynamic>? additionalData,
  }) async {
    try {
      final vaccinationData = {
        'patientId': patientId,
        'vaccineName': vaccineName,
        'vaccinationDate': vaccinationDate,
        'nextDueDate': nextDueDate,
        'location': location,
        'notes': notes,
        'createdAt': FieldValue.serverTimestamp(),
        ...?additionalData,
      };

      final docRef = await _firestore.collection('vaccinations').add(vaccinationData);
      return docRef.id;
    } catch (e) {
      throw Exception('Failed to save vaccination record: $e');
    }
  }

  /// Get patient vaccination records
  Future<List<Map<String, dynamic>>> getVaccinationRecords(String patientId) async {
    try {
      final snapshot = await _firestore
          .collection('vaccinations')
          .where('patientId', isEqualTo: patientId)
          .get();

      final records = snapshot.docs.map((doc) => {...doc.data(), 'id': doc.id}).toList();
      
      // Sort in memory to avoid composite index requirement
      records.sort((a, b) {
        final aDate = a['vaccinationDate'] as String?;
        final bDate = b['vaccinationDate'] as String?;
        if (aDate == null && bDate == null) return 0;
        if (aDate == null) return 1;
        if (bDate == null) return -1;
        return bDate.compareTo(aDate); // descending order
      });
      
      return records;
    } catch (e) {
      throw Exception('Failed to get vaccination records: $e');
    }
  }

  // ==================== HOSPITALS ====================

  /// Save hospital profile
  Future<void> saveHospital({
    required String hospitalId,
    required String name,
    required String city,
    String? phone,
    String? email,
    String? address,
    String? imageUrl,
    List<String>? departments,
    Map<String, dynamic>? additionalData,
  }) async {
    try {
      final hospitalData = {
        'hospitalId': hospitalId,
        'name': name,
        'city': city,
        'phone': phone,
        'email': email,
        'address': address,
        'imageUrl': imageUrl,
        'departments': departments,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
        ...?additionalData,
      };

      await _firestore.collection('hospitals').doc(hospitalId).set(hospitalData);
    } catch (e) {
      throw Exception('Failed to save hospital: $e');
    }
  }

  /// Get hospitals by city
  Future<List<Map<String, dynamic>>> getHospitalsByCity(String city) async {
    try {
      final snapshot = await _firestore
          .collection('hospitals')
          .where('city', isEqualTo: city)
          .get();

      return snapshot.docs.map((doc) => {...doc.data(), 'id': doc.id}).toList();
    } catch (e) {
      throw Exception('Failed to get hospitals: $e');
    }
  }

  // ==================== PAYMENTS ====================

  /// Save payment record
  Future<String> savePayment({
    required String patientId,
    required String appointmentId,
    required double amount,
    String? paymentMethod,
    String status = 'pending', // 'pending', 'completed', 'failed'
    String? transactionId,
    Map<String, dynamic>? additionalData,
  }) async {
    try {
      final paymentData = {
        'patientId': patientId,
        'appointmentId': appointmentId,
        'amount': amount,
        'paymentMethod': paymentMethod,
        'status': status,
        'transactionId': transactionId,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
        ...?additionalData,
      };

      final docRef = await _firestore.collection('payments').add(paymentData);
      return docRef.id;
    } catch (e) {
      throw Exception('Failed to save payment: $e');
    }
  }

  /// Get payment history
  Future<List<Map<String, dynamic>>> getPaymentHistory(String patientId) async {
    try {
      final snapshot = await _firestore
          .collection('payments')
          .where('patientId', isEqualTo: patientId)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs.map((doc) => {...doc.data(), 'id': doc.id}).toList();
    } catch (e) {
      throw Exception('Failed to get payment history: $e');
    }
  }

  // ==================== GENERIC METHODS ====================

  /// Save generic data to a collection
  Future<String> saveData({
    required String collection,
    Map<String, dynamic>? data,
  }) async {
    try {
      final docData = {
        ...?data,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      };

      final docRef = await _firestore.collection(collection).add(docData);
      return docRef.id;
    } catch (e) {
      throw Exception('Failed to save data: $e');
    }
  }

  /// Get data from a collection
  Future<List<Map<String, dynamic>>> getData(String collection) async {
    try {
      final snapshot = await _firestore.collection(collection).get();
      return snapshot.docs.map((doc) => {...doc.data(), 'id': doc.id}).toList();
    } catch (e) {
      throw Exception('Failed to get data: $e');
    }
  }

  /// Query data with conditions
  Future<List<Map<String, dynamic>>> queryData({
    required String collection,
    required String field,
    required dynamic value,
  }) async {
    try {
      final snapshot = await _firestore
          .collection(collection)
          .where(field, isEqualTo: value)
          .get();

      return snapshot.docs.map((doc) => {...doc.data(), 'id': doc.id}).toList();
    } catch (e) {
      throw Exception('Failed to query data: $e');
    }
  }

  /// Delete document
  Future<void> deleteData(String collection, String documentId) async {
    try {
      await _firestore.collection(collection).doc(documentId).delete();
    } catch (e) {
      throw Exception('Failed to delete data: $e');
    }
  }

  /// Stream real-time updates
  Stream<List<Map<String, dynamic>>> streamData(String collection) {
    try {
      return _firestore
          .collection(collection)
          .snapshots()
          .map((snapshot) => snapshot.docs.map((doc) => {...doc.data(), 'id': doc.id}).toList());
    } catch (e) {
      throw Exception('Failed to stream data: $e');
    }
  }
}
