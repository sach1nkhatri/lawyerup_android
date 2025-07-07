import 'package:flutter/material.dart';

class ScheduleBuilder extends StatefulWidget {
  final Function(Map<String, List<Map<String, String>>>) onScheduleChange;

  const ScheduleBuilder({super.key, required this.onScheduleChange});

  @override
  State<ScheduleBuilder> createState() => _ScheduleBuilderState();
}

class _ScheduleBuilderState extends State<ScheduleBuilder> {
  final List<String> _daysOfWeek = [
    'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'
  ];

  String? selectedDay;
  TimeOfDay? startTime;
  TimeOfDay? endTime;

  Map<String, List<Map<String, String>>> schedule = {};

  Future<void> _pickTime(bool isStart) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          startTime = picked;
        } else {
          endTime = picked;
        }
      });
    }
  }

  void _addSlot() {
    if (selectedDay == null || startTime == null || endTime == null) return;

    final slot = {
      'start': startTime!.format(context),
      'end': endTime!.format(context),
    };

    final updated = Map<String, List<Map<String, String>>>.from(schedule);
    updated[selectedDay!] = [...(updated[selectedDay!] ?? []), slot];

    setState(() {
      schedule = updated;
    });

    widget.onScheduleChange(schedule);
  }

  void _removeSlot(String day, int index) {
    final updated = Map<String, List<Map<String, String>>>.from(schedule);
    updated[day]?.removeAt(index);
    if (updated[day]!.isEmpty) {
      updated.remove(day);
    }

    setState(() {
      schedule = updated;
    });

    widget.onScheduleChange(schedule);
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Select Availability", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        Row(
          children: [
            DropdownButton<String>(
              value: selectedDay,
              hint: const Text("Select Day"),
              items: _daysOfWeek.map((day) {
                return DropdownMenuItem(value: day, child: Text(day));
              }).toList(),
              onChanged: (val) => setState(() => selectedDay = val),
            ),
            const SizedBox(width: 10),
            TextButton(onPressed: () => _pickTime(true), child: Text(startTime?.format(context) ?? "Start")),
            const Text("to"),
            TextButton(onPressed: () => _pickTime(false), child: Text(endTime?.format(context) ?? "End")),
            ElevatedButton(onPressed: _addSlot, child: const Text("Add Slot")),
          ],
        ),
        const SizedBox(height: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: schedule.entries.map((entry) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${entry.key}:'),
                ...entry.value.asMap().entries.map((e) => Row(
                  children: [
                    Text('  ${e.value['start']} to ${e.value['end']}'),
                    IconButton(
                      onPressed: () => _removeSlot(entry.key, e.key),
                      icon: const Icon(Icons.close),
                      iconSize: 16,
                    )
                  ],
                )),
              ],
            );
          }).toList(),
        )
      ],
    );
  }
}
