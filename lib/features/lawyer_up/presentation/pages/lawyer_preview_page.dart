import 'package:flutter/material.dart';
import '../../domain/entities/lawyer.dart';
import '../widgets/lawyer_detail_tab_view.dart';


class LawyerUpPreviewPage extends StatelessWidget {
  final Lawyer lawyer;

  const LawyerUpPreviewPage({super.key, required this.lawyer});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1C2D3D),
        title: const Text("Lawyer Details", style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: LawyerDetailTabView(lawyer: lawyer),
    );
  }
}
