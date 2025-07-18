import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:hive/hive.dart';
import '../../../../app/constant/api_endpoints.dart';
import '../../../../app/constant/hive_constants.dart';
import '../../../../features/auth/data/models/user_hive_model.dart';

class AppointmentModal extends StatefulWidget {
  final String lawyerId;
  final Function onClose;

  const AppointmentModal({
    super.key,
    required this.lawyerId,
    required this.onClose,
  });

  @override
  State<AppointmentModal> createState() => _AppointmentModalState();
}

class _AppointmentModalState extends State<AppointmentModal> {
  List<String> availableDates = [];
  List<String> timeSlots = [];
  String selectedDate = '';
  String selectedTime = '';
  int duration = 1;
  String appointmentType = 'online';
  String description = '';
  bool isLoadingSlots = false;
  bool isBooking = false;

  String? userId;

  @override
  void initState() {
    super.initState();
    final userBox = Hive.box<UserHiveModel>(HiveConstants.userBox);
    final user = userBox.get(HiveConstants.userKey);
    userId = user?.uid;
    _initDates();
  }

  void _initDates() {
    final now = DateTime.now();
    for (int i = 0; i < 14; i++) {
      final date = now.add(Duration(days: i));
      final formatted = "${date.year}-${_twoDigits(date.month)}-${_twoDigits(date.day)}";
      availableDates.add(formatted);
    }
    selectedDate = availableDates.first;
    _loadSlots();
  }

  Future<void> _loadSlots() async {
    setState(() {
      isLoadingSlots = true;
      timeSlots.clear();
      selectedTime = '';
    });

    final url = ApiEndpoints.getAvailableSlots(widget.lawyerId, selectedDate, duration);
    try {
      final res = await http.get(Uri.parse(url));
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        setState(() {
          timeSlots = List<String>.from(data);
          selectedTime = timeSlots.isNotEmpty ? timeSlots.first : '';
        });
      } else {
        _showToast("Failed to load slots");
      }
    } catch (e) {
      _showToast("Slot fetch error");
    } finally {
      setState(() => isLoadingSlots = false);
    }
  }

  String _twoDigits(int n) => n.toString().padLeft(2, '0');

  void _showToast(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  Future<void> _confirmBooking() async {
    if (selectedTime.isEmpty || userId == null) {
      _showToast("Please select date, time and ensure you're logged in.");
      return;
    }

    final booking = {
      "user": userId,
      "lawyer": widget.lawyerId,
      "lawyerList": widget.lawyerId,
      "date": selectedDate,
      "time": selectedTime,
      "duration": duration,
      "mode": appointmentType,
      "description": description,
      "status": "pending",
      "reviewed": false,
    };

    setState(() => isBooking = true);
    try {
      final res = await http.post(
        Uri.parse(ApiEndpoints.createBooking),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(booking),
      );
      if (res.statusCode == 200 || res.statusCode == 201) {
        _showToast("✅ Appointment booked!");
        widget.onClose();
        Navigator.of(context).pop();
      } else {
        _showToast("❌ Failed to book: ${res.body}");
      }
    } catch (e) {
      _showToast("Booking error");
    } finally {
      setState(() => isBooking = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.95,
        ),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.97),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              offset: Offset(0, -4),
            ),
          ],
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  '🎯 Book Appointment',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.pink.shade400,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              _buildLabel("📅 Select Date"),
              _styledDropdown(
                value: selectedDate,
                items: availableDates,
                onChanged: (val) {
                  selectedDate = val!;
                  _loadSlots();
                },
              ),

              _buildLabel("⏰ Time Slot"),
              isLoadingSlots
                  ? const Center(child: CircularProgressIndicator())
                  : _styledDropdown(
                value: selectedTime,
                items: timeSlots,
                onChanged: (val) => setState(() => selectedTime = val!),
              ),

              _buildLabel("⏳ Duration (hours)"),
              _styledTextInput(
                initialValue: duration.toString(),
                keyboardType: TextInputType.number,
                onChanged: (val) => duration = int.tryParse(val) ?? 1,
              ),

              _buildLabel("💻 Appointment Type"),
              Row(
                children: ['online', 'live'].map((type) {
                  final selected = appointmentType == type;
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: ElevatedButton(
                        onPressed: () => setState(() => appointmentType = type),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: selected ? Colors.pink[100] : Colors.grey[300],
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(type.toUpperCase()),
                      ),
                    ),
                  );
                }).toList(),
              ),

              _buildLabel("📝 Description"),
              _styledTextInput(
                hintText: "Reason for appointment",
                maxLines: 3,
                onChanged: (val) => description = val,
              ),

              const SizedBox(height: 20),
              Center(
                child: ElevatedButton.icon(
                  onPressed: isBooking ? null : _confirmBooking,
                  icon: isBooking
                      ? const CircularProgressIndicator(strokeWidth: 2, color: Colors.white)
                      : const Icon(Icons.done),
                  label: Text(
                    isBooking ? "Booking..." : "Confirm Booking",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pink.shade400,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) => Padding(
    padding: const EdgeInsets.only(top: 16, bottom: 6),
    child: Text(
      text,
      style: TextStyle(
        fontWeight: FontWeight.w600,
        color: Colors.grey.shade800,
        fontSize: 14.5,
      ),
    ),
  );

  Widget _styledDropdown({
    required String value,
    required List<String> items,
    required void Function(String?) onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: DropdownButton<String>(
        value: value,
        isExpanded: true,
        underline: const SizedBox(),
        items: items
            .map((item) => DropdownMenuItem(value: item, child: Text(item)))
            .toList(),
        onChanged: onChanged,
      ),
    );
  }

  Widget _styledTextInput({
    String initialValue = '',
    String? hintText,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    required void Function(String) onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: TextEditingController(text: initialValue),
        keyboardType: keyboardType,
        maxLines: maxLines,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: hintText,
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          filled: true,
          fillColor: Colors.grey.shade100,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
        ),
      ),
    );
  }
}
