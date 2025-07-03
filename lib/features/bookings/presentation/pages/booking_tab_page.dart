import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';

import '../../../../app/constant/hive_constants.dart';
import '../../../../app/service_locater/service_locator.dart';
import '../../../auth/data/models/user_hive_model.dart';
import '../bloc/booking_bloc.dart';
import '../bloc/booking_event.dart';
import '../bloc/booking_state.dart';
import '../widgets/user_booking_card.dart';
import '../widgets/lawyer_booking_card.dart';

class BookingTabPage extends StatelessWidget {
  final String role; // 'user' or 'lawyer'

  const BookingTabPage({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    // ✅ Access already-opened box (opened via HiveService in main.dart)
    final box = Hive.box<UserHiveModel>(HiveConstants.userBox);
    final user = box.get('user');
    final userId = user?.uid ?? ''; // fallback to '' if null

    return BlocProvider(
      create: (_) => sl<BookingBloc>()..add(LoadBookings(role: role, userId: userId)),
      child: _BookingTabView(role: role),
    );
  }
}


class _BookingTabView extends StatefulWidget {
  final String role;
  const _BookingTabView({required this.role});

  @override
  State<_BookingTabView> createState() => _BookingTabViewState();
}

class _BookingTabViewState extends State<_BookingTabView> with TickerProviderStateMixin {
  late TabController _tabController;
  final List<String> _tabs = ['pending', 'approved', 'history'];

  @override
  void initState() {
    _tabController = TabController(length: _tabs.length, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Bookings'),
        bottom: TabBar(
          controller: _tabController,
          tabs: _tabs.map((tab) => Tab(text: tab.capitalize())).toList(),
        ),
      ),
      body: BlocBuilder<BookingBloc, BookingState>(
        builder: (context, state) {
          if (state is BookingLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is BookingError) {
            return Center(child: Text(state.message));
          }

          if (state is BookingLoaded) {
            final bookings = state.bookings;
            return TabBarView(
              controller: _tabController,
              children: _tabs.map((status) {
                final filtered = bookings.where((b) {
                  if (status == 'history') {
                    return ['completed', 'cancelled'].contains(b.status.toLowerCase());
                  }
                  return b.status.toLowerCase() == status;
                }).toList();

                if (filtered.isEmpty) {
                  return const Center(child: Text('No bookings found.'));
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: filtered.length,
                  itemBuilder: (_, i) {
                    final booking = filtered[i];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: widget.role == 'lawyer'
                          ? LawyerBookingCard(booking: booking)
                          : UserBookingCard(booking: booking),
                    );
                  },
                );
              }).toList(),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}

extension on String {
  String capitalize() => '${this[0].toUpperCase()}${substring(1)}';
}
