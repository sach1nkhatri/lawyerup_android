import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../app/shared/widgets/loading_widget.dart';
import '../../../../core/error/error_widget.dart';
import '../../domain/entities/lawyer.dart';
import '../bloc/lawyer_list_bloc.dart';
import '../bloc/lawyer_list_state.dart';
import '../widgets/lawyer_card.dart';

class LawyerUpPage extends StatelessWidget {
  const LawyerUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Find a Lawyer")),
      body: BlocBuilder<LawyerListBloc, LawyerListState>(
        builder: (context, state) {
          if (state is LawyerListLoading) {
            return const LoadingWidget();
          } else if (state is LawyerListLoaded) {
            final List<Lawyer> lawyers = state.lawyers;

            if (lawyers.isEmpty) {
              return const Center(child: Text('No lawyers available.'));
            }

            return ListView.builder(
              itemCount: lawyers.length,
              itemBuilder: (context, index) {
                final lawyer = lawyers[index];
                return LawyerCard(lawyer: lawyer);
              },
            );
          } else if (state is LawyerListError) {
            return CustomErrorWidget(message: state.message); // ✅ FIXED
          }

          return const SizedBox(); // default fallback
        },
      ),
    );
  }
}
