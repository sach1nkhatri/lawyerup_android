import 'package:flutter/material.dart';
import '../widgets/user_booking_card.dart';
import '../widgets/lawyer_booking_card.dart';

class BookingTabPage extends StatefulWidget {
  final String role; // 'user' or 'lawyer'
  const BookingTabPage({super.key, required this.role});

  @override
  State<BookingTabPage> createState() => _BookingTabPageState();
}

class _BookingTabPageState extends State<BookingTabPage> with TickerProviderStateMixin {
  late TabController _tabController;

  final List<String> _tabs = ['Pending', 'Accepted', 'History'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget _buildDummyCard(String status) {
    if (widget.role == 'lawyer') {
      return LawyerBookingCard(
        name: 'John Doe',
        email: 'john@example.com',
        contact: '9800000000',
        status: status,
        date: '2025-07-04',
        time: '10:30',
        mode: 'online',
        description: 'Discuss criminal case',
      );
    } else {
      return UserBookingCard(
        lawyerName: 'Aayush Khatri',
        email: 'aayush@lawyer.com',
        contact: '9812345678',
        status: status,
        date: '2025-07-04',
        time: '14:00',
        mode: 'live',
        description: 'Consult family law issue',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Bookings'),
        bottom: TabBar(
          controller: _tabController,
          tabs: _tabs.map((t) => Tab(text: t)).toList(),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: _tabs.map((status) {
          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: 2, // Just show 2 dummy cards
            itemBuilder: (_, i) => Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: _buildDummyCard(status.toLowerCase()),
            ),
          );
        }).toList(),
      ),
    );
  }
}
