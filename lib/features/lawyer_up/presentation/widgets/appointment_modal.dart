import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:hive/hive.dart';
import '../../../../app/constant/api_endpoints.dart';
import '../../../../app/constant/hive_constants.dart';
import '../../../../app/shared/widgets/global_snackbar.dart';
import '../../../../features/auth/data/models/user_hive_model.dart';

class AppointmentModal extends StatefulWidget {
  final String lawyerId;     // Lawyer's user ID
  final String lawyerListId; // Lawyer's listing ID
  final Function onClose;

  const AppointmentModal({
    super.key,
    required this.lawyerId,
    required this.lawyerListId,
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

    final url = ApiEndpoints.getAvailableSlots(widget.lawyerListId, selectedDate, duration);
    try {
      final res = await http.get(Uri.parse(url));
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        setState(() {
          timeSlots = List<String>.from(data);
          selectedTime = timeSlots.isNotEmpty ? timeSlots.first : '';
        });
      } else {
        GlobalSnackBar.show(context, "Failed to load slots", type: SnackType.error);
      }
    } catch (e) {
      GlobalSnackBar.show(context, "Slot fetch error", type: SnackType.error);
    } finally {
      setState(() => isLoadingSlots = false);
    }
  }

  String _twoDigits(int n) => n.toString().padLeft(2, '0');

  Future<void> _confirmBooking() async {
    if (selectedTime.isEmpty || userId == null) {
      GlobalSnackBar.show(context, "Please select date, time and ensure you're logged in.", type: SnackType.warning);
      return;
    }

    final booking = {
      "user": userId,
      "lawyer": widget.lawyerId,
      "lawyerList": widget.lawyerListId,
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
        GlobalSnackBar.show(context, "Appointment booked!", type: SnackType.success);
        GlobalSnackBar.show(context, "Appointment booked!", type: SnackType.success);
        widget.onClose();
        Navigator.of(context).pop();
      } else {
        GlobalSnackBar.show(context, "Failed to book: ${res.body}", type: SnackType.error);
      }
    } catch (e) {
      GlobalSnackBar.show(context, "Booking error", type: SnackType.error);
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
                  'Book Appointment',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.green.shade400,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              _buildLabel("Select Date"),
              InkWell(
                onTap: () async {
                  final now = DateTime.now();
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: now,
                    firstDate: now,
                    lastDate: now.add(const Duration(days: 14)),
                    builder: (context, child) {
                      return Theme(
                        data: Theme.of(context).copyWith(
                          colorScheme: ColorScheme.light(
                            primary: Colors.green.shade400,
                            onPrimary: Colors.white,
                            onSurface: Colors.black,
                          ),
                          textButtonTheme: TextButtonThemeData(
                            style: TextButton.styleFrom(foregroundColor: Colors.green.shade400),
                          ),
                        ),
                        child: child!,
                      );
                    },
                  );

                  if (picked != null) {
                    setState(() {
                      selectedDate = "${picked.year}-${_twoDigits(picked.month)}-${_twoDigits(picked.day)}";
                    });
                    _loadSlots();
                  }
                },
                child: Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        selectedDate.isNotEmpty ? selectedDate : 'Select a date',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const Icon(Icons.calendar_today, size: 20, color: Colors.grey),
                    ],
                  ),
                ),
              ),


              _buildLabel("Time Slot"),
              if (isLoadingSlots)
                const Center(child: CircularProgressIndicator())
              else if (timeSlots.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Text(
                    "🚫 No slots available for the selected date.",
                    style: TextStyle(fontSize: 15, color: Colors.redAccent),
                    textAlign: TextAlign.center,
                  ),
                )
              else
                timeSlotSelector(
                  selectedValue: selectedTime,
                  items: timeSlots,
                  onSelected: (val) => setState(() => selectedTime = val),
                ),



              _buildLabel("Duration (hours)"),
              _styledTextInput(
                initialValue: duration.toString(),
                keyboardType: TextInputType.number,
                onChanged: (val) => duration = int.tryParse(val) ?? 1,
              ),

              _buildLabel("Appointment Type"),
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
                      ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                  )
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

  Widget timeSlotSelector({
    required String selectedValue,
    required List<String> items,
    required void Function(String) onSelected,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(4),
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        children: items.map((slot) {
          final isSelected = slot == selectedValue;
          return ChoiceChip(
            label: Text(
              slot,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : Colors.black87,
              ),
            ),
            selected: isSelected,
            selectedColor: Colors.pink.shade400,
            backgroundColor: Colors.grey.shade100,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(
                color: isSelected ? Colors.pink.shade400 : Colors.grey.shade300,
              ),
            ),
            onSelected: (_) => onSelected(slot),
          );
        }).toList(),
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
    final controller = TextEditingController(text: initialValue);
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
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
