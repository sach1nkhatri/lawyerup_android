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
  const BookingTabPage({super.key});

  @override
  Widget build(BuildContext context) {
    final box = Hive.box<UserHiveModel>(HiveConstants.userBox);
    final user = box.get('user');

    final userId = user?.uid ?? '';
    final role = user?.role ?? '';

    if (userId.isEmpty || role.isEmpty) {
      return const Scaffold(
        body: Center(child: Text("Error loading user info")),
      );
    }

    return BlocProvider(
      create: (_) => sl<BookingBloc>()..add(LoadBookings(role: role, userId: userId)),
      child: _BookingTabView(role: role, userId: userId), //  FIXED
    );
  }
}

class _BookingTabView extends StatefulWidget {
  final String role;
  final String userId;

  const _BookingTabView({
    required this.role,
    required this.userId,
  });

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
          tabs: _tabs.map((tab) => Tab(text: tab)).toList(),
        ),
      ),
      body: BlocBuilder<BookingBloc, BookingState>(
        builder: (context, state) {
          if (state is BookingLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is BookingLoaded) {
            final filtered = (String status) {
              final isHistory = status == 'history';
              return state.bookings.where((b) {
                final matchesStatus = isHistory
                    ? b.status == 'completed'
                    : b.status == status;

                final isMine = widget.role == 'lawyer'
                    ? b.lawyer.id == widget.userId
                    : b.user.id == widget.userId;

                return matchesStatus && isMine;
              }).toList();
            };

            return TabBarView(
              controller: _tabController,
              children: _tabs.map((status) {
                final bookings = filtered(status);
                if (bookings.isEmpty) {
                  return const Center(child: Text("No bookings"));
                }
                return ListView.builder(
                  itemCount: bookings.length,
                  itemBuilder: (context, index) {
                    final booking = bookings[index];

                    return widget.role == 'lawyer'
                        ? LawyerBookingCard(booking: booking) // 🧑‍⚖️ lawyer sees lawyer card
                        : UserBookingCard(
                      booking: booking,
                      currentUserId: widget.userId,
                      onCancelSuccess: () {
                        context.read<BookingBloc>().add(
                          LoadBookings(userId: widget.userId, role: widget.role),
                        );
                      },
                    ); // 👤 user sees user card
                  },
                );
              }).toList(),
            );
          } else if (state is BookingError) {
            return Center(child: Text(state.message));
          }
          return const SizedBox();
        },
      ),
    );
  }
}
