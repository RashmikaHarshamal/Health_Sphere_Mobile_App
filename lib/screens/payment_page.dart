import 'package:flutter/material.dart';

class PaymentPage extends StatefulWidget {
  final Map<String, dynamic> appointmentDetails;

  const PaymentPage({super.key, required this.appointmentDetails});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  String _paymentOption = 'Pay at Hospital';
  String _paymentMethod = 'Cash';
  final double _hospitalCharge = 500.0; // Rs. 500 hospital charge

  double get _doctorFee {
    String feeString = widget.appointmentDetails['doctorFee'];
    // Extract number from "Rs. 3,500" format
    String cleanFee = feeString.replaceAll(RegExp(r'[^0-9]'), '');
    return double.tryParse(cleanFee) ?? 0.0;
  }

  double get _paymentAmount {
    if (_paymentOption == 'Pay Full') {
      return _doctorFee + _hospitalCharge;
    } else if (_paymentOption == 'Pay Half') {
      return (_doctorFee + _hospitalCharge) / 2;
    } else {
      return 0.0; // Pay at Hospital
    }
  }

  double get _remainingAmount {
    double total = _doctorFee + _hospitalCharge;
    return total - _paymentAmount;
  }

  void _confirmBooking() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: const [
            Icon(Icons.check_circle, color: Colors.green, size: 32),
            SizedBox(width: 12),
            Expanded(child: Text('Booking Confirmed!')),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Your appointment has been successfully booked.',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.green.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildConfirmRow('Booking ID', '#APT${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}'),
                  const Divider(height: 16),
                  _buildConfirmRow('Doctor', widget.appointmentDetails['doctorName']),
                  _buildConfirmRow('Date', _formatDate(widget.appointmentDetails['date'])),
                  _buildConfirmRow('Time', widget.appointmentDetails['timeSlot']),
                  if (_paymentAmount > 0) ...[
                    const Divider(height: 16),
                    _buildConfirmRow('Paid Amount', 'Rs. ${_paymentAmount.toStringAsFixed(2)}'),
                  ],
                  if (_remainingAmount > 0) ...[
                    _buildConfirmRow('Remaining', 'Rs. ${_remainingAmount.toStringAsFixed(2)}', isHighlight: true),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'A confirmation email has been sent to your email address.',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              // Navigate back to home (pop all screens)
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
            child: const Text('Go to Home'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4FC3F7),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }

  Widget _buildConfirmRow(String label, String value, {bool isHighlight = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              color: isHighlight ? Colors.red : Colors.grey[700],
              fontWeight: isHighlight ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: isHighlight ? Colors.red : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    List<String> months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  Widget _buildAppointmentSummary() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            (widget.appointmentDetails['doctorColor'] as Color).withOpacity(0.1),
            (widget.appointmentDetails['doctorColor'] as Color).withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: (widget.appointmentDetails['doctorColor'] as Color).withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.calendar_month,
                color: widget.appointmentDetails['doctorColor'],
                size: 28,
              ),
              const SizedBox(width: 12),
              const Text(
                'Appointment Summary',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildSummaryRow(Icons.person, 'Patient', widget.appointmentDetails['patientName']),
          _buildSummaryRow(Icons.medical_services, 'Doctor', widget.appointmentDetails['doctorName']),
          _buildSummaryRow(Icons.healing, 'Specialty', widget.appointmentDetails['doctorSpecialty']),
          _buildSummaryRow(Icons.local_hospital, 'Hospital', widget.appointmentDetails['hospital']),
          _buildSummaryRow(Icons.location_city, 'City', widget.appointmentDetails['city']),
          _buildSummaryRow(Icons.calendar_today, 'Date', _formatDate(widget.appointmentDetails['date'])),
          _buildSummaryRow(Icons.access_time, 'Time', widget.appointmentDetails['timeSlot']),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.grey[600]),
          const SizedBox(width: 12),
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 13,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentBreakdown() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Payment Breakdown',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          _buildPriceRow('Doctor Consultation Fee', _doctorFee),
          const SizedBox(height: 12),
          _buildPriceRow('Hospital Charges', _hospitalCharge),
          const Divider(height: 32),
          _buildPriceRow('Total Amount', _doctorFee + _hospitalCharge, isTotal: true),
        ],
      ),
    );
  }

  Widget _buildPriceRow(String label, double amount, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 16 : 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            color: isTotal ? Colors.black : Colors.grey[700],
          ),
        ),
        Text(
          'Rs. ${amount.toStringAsFixed(2)}',
          style: TextStyle(
            fontSize: isTotal ? 18 : 14,
            fontWeight: FontWeight.bold,
            color: isTotal ? const Color(0xFF4FC3F7) : Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentOptions() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Payment Options',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildPaymentOptionTile(
            'Pay Full',
            'Pay complete amount now',
            'Rs. ${(_doctorFee + _hospitalCharge).toStringAsFixed(2)}',
            Icons.payment,
          ),
          const SizedBox(height: 12),
          _buildPaymentOptionTile(
            'Pay Half',
            'Pay 50% now, rest at hospital',
            'Rs. ${((_doctorFee + _hospitalCharge) / 2).toStringAsFixed(2)}',
            Icons.pie_chart,
          ),
          const SizedBox(height: 12),
          _buildPaymentOptionTile(
            'Pay at Hospital',
            'Pay full amount at the hospital',
            'Rs. 0.00',
            Icons.local_hospital,
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentOptionTile(String title, String subtitle, String amount, IconData icon) {
    bool isSelected = _paymentOption == title;
    return GestureDetector(
      onTap: () {
        setState(() {
          _paymentOption = title;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF4FC3F7).withOpacity(0.1) : Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? const Color(0xFF4FC3F7) : Colors.grey.shade300,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF4FC3F7) : Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: isSelected ? Colors.white : Colors.grey[600],
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? const Color(0xFF4FC3F7) : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  amount,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isSelected ? const Color(0xFF4FC3F7) : Colors.black87,
                  ),
                ),
                if (isSelected)
                  const Icon(
                    Icons.check_circle,
                    color: Color(0xFF4FC3F7),
                    size: 20,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentMethods() {
    if (_paymentOption == 'Pay at Hospital') {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Select Payment Method',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildPaymentMethodTile('Cash', Icons.money),
          const SizedBox(height: 12),
          _buildPaymentMethodTile('Credit/Debit Card', Icons.credit_card),
          const SizedBox(height: 12),
          _buildPaymentMethodTile('Mobile Banking', Icons.phone_android),
          const SizedBox(height: 12),
          _buildPaymentMethodTile('Online Transfer', Icons.account_balance),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodTile(String method, IconData icon) {
    bool isSelected = _paymentMethod == method;
    return GestureDetector(
      onTap: () {
        setState(() {
          _paymentMethod = method;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF4FC3F7).withOpacity(0.1) : Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? const Color(0xFF4FC3F7) : Colors.grey.shade300,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? const Color(0xFF4FC3F7) : Colors.grey[600],
              size: 24,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                method,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected ? const Color(0xFF4FC3F7) : Colors.black87,
                ),
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check_circle,
                color: Color(0xFF4FC3F7),
                size: 20,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentSummary() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Amount to Pay Now',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                'Rs. ${_paymentAmount.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4FC3F7),
                ),
              ),
            ],
          ),
          if (_remainingAmount > 0) ...[
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Pay at Hospital',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.red,
                  ),
                ),
                Text(
                  'Rs. ${_remainingAmount.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          ],
        ],
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
          'Payment',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        children: [
          _buildAppointmentSummary(),
          const SizedBox(height: 8),
          _buildPaymentBreakdown(),
          const SizedBox(height: 16),
          _buildPaymentOptions(),
          const SizedBox(height: 16),
          _buildPaymentMethods(),
          const SizedBox(height: 16),
          _buildPaymentSummary(),
          const SizedBox(height: 24),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: ElevatedButton(
              onPressed: _confirmBooking,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4FC3F7),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
              ),
              child: Text(
                _paymentOption == 'Pay at Hospital' 
                    ? 'Confirm Booking' 
                    : 'Confirm & Pay Rs. ${_paymentAmount.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}