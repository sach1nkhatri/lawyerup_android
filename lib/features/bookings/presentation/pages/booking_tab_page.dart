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
import '../../domain/entities/booking.dart';

class BookingTabPage extends StatelessWidget {
  final String role; // 'user' or 'lawyer'

  const BookingTabPage({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    final box = Hive.box<UserHiveModel>(HiveConstants.userBox);
    final user = box.get('user');
    final userId = user?.uid ?? '';

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
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  void _switchToFirstNonEmptyTab(List<Booking> bookings) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      for (int i = 0; i < _tabs.length; i++) {
        final status = _tabs[i];
        final matches = bookings.where((b) {
          if (status == 'history') {
            return ['completed', 'cancelled'].contains(b.status.toLowerCase());
          }
          return b.status.toLowerCase() == status;
        }).toList();

        if (matches.isNotEmpty) {
          _tabController.index = i;
          break;
        }
      }
    });
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
        backgroundColor: const Color(0xFF1C2D3D),
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'My Bookings',
          style: TextStyle(
            fontFamily: 'Lora',
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
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

            // 🔁 Switch to non-empty tab after UI is built
            _switchToFirstNonEmptyTab(bookings);

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
  String capitalize() => isEmpty ? this : '${this[0].toUpperCase()}${substring(1)}';
}
