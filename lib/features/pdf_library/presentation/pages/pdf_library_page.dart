import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../app/service_locater/service_locator.dart';
import '../bloc/pdf_bloc.dart';
import '../bloc/pdf_event.dart';
import '../bloc/pdf_state.dart';
import '../widgets/pdf_tile.dart';

class PdfLibraryPage extends StatelessWidget {
  const PdfLibraryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<PdfBloc>()..add(FetchPdfs()),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: const Color(0xFF1E2B3A),
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            "PDF Library",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(5), //if ever used padding is 16
              // child: Container(
              //   padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              //   decoration: BoxDecoration(
              //     color: Colors.white,
              //     borderRadius: BorderRadius.circular(24),
              //     boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
              //   ),
              //   child: Row(
              //     children: const [
              //       Icon(Icons.search, color: Colors.grey),
              //       SizedBox(width: 8),
              //       Expanded(
              //         child: Text(
              //           "Search for law article",
              //           style: TextStyle(color: Colors.black54, fontSize: 14),
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
            ),
            Expanded(
              child: BlocBuilder<PdfBloc, PdfState>(
                builder: (context, state) {
                  if (state is PdfLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is PdfLoaded) {
                    final pdfList = state.pdfs;

                    return ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: pdfList.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final pdf = pdfList[index];
                        return PdfTile(title: pdf.title, fullUrl: pdf.fullUrl, rawUrl: pdf.url);

                      },
                    );
                  } else if (state is PdfError) {
                    return Center(child: Text("Error: ${state.message}"));
                  } else {
                    return const Center(child: Text("No PDFs found."));
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
