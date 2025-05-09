import 'package:flutter/material.dart';

class BookingsCard extends StatelessWidget {
  const BookingsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Bookings", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFD3E6F9),
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 4)],
          ),
          child: const Row(
            children: [
              Icon(Icons.image, size: 48),
              SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Name"),
                  Text("Specializations"),
                  Text("Contact"),
                  Text("Appointment Date"),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
}
