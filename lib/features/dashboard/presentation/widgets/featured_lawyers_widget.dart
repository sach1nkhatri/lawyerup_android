import 'dart:math';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:lawyerup_android/core/network/dio_client.dart';
import 'package:lawyerup_android/features/lawyer_up/data/models/lawyer_model.dart';
import 'package:lawyerup_android/features/lawyer_up/presentation/pages/lawyer_up_page.dart';
import 'package:lawyerup_android/features/lawyer_up/presentation/widgets/lawyer_card.dart';

import '../../../lawyer_up/data/datasources/remote/LawyerRemoteDataSourceImpl.dart';

class FeaturedLawyersWidget extends StatefulWidget {
  const FeaturedLawyersWidget({super.key});

  @override
  State<FeaturedLawyersWidget> createState() => _FeaturedLawyersWidgetState();
}

class _FeaturedLawyersWidgetState extends State<FeaturedLawyersWidget> {
  LawyerModel? featuredLawyer;
  bool loading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    loadFeaturedLawyer();
  }

  Future<void> loadFeaturedLawyer() async {
    try {
      final remote = LawyerRemoteDataSourceImpl(DioClient());
      final allLawyers = await remote.getAllLawyers() as List<LawyerModel>;

      if (allLawyers.isEmpty) throw Exception("No lawyers found.");

      final randomIndex = Random().nextInt(allLawyers.length);
      final selected = allLawyers[randomIndex];

      setState(() {
        featuredLawyer = selected;
        loading = false;
      });
    } catch (e) {
      print("Error loading featured lawyer: $e");
      setState(() {
        error = "Unable to load featured lawyer.";
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) return const Center(child: CircularProgressIndicator());

    if (error != null) {
      return Center(child: Text(error!, style: const TextStyle(color: Colors.red)));
    }

    if (featuredLawyer == null) {
      return const Text("No featured lawyer found.");
    }

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const LawyerUpPage()),
        );
      },
      child: LawyerCard(lawyer: featuredLawyer! as dynamic), // ✅ Cast to match Lawyer
    );
  }
}
