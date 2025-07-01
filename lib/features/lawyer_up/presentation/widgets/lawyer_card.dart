import 'package:flutter/material.dart';

import '../../domain/entities/lawyer.dart';

class LawyerCard extends StatelessWidget {
  final Lawyer lawyer;

  const LawyerCard({Key? key, required this.lawyer}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final serverUrl = const String.fromEnvironment('REACT_APP_SERVER_URL', defaultValue: 'http://localhost:5000');
    final imageUrl = '$serverUrl${lawyer.profilePhoto}';

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(imageUrl),
        ),
        title: Text(lawyer.fullName),
        subtitle: Text(lawyer.specialization),
        trailing: const Icon(Icons.arrow_forward),
        onTap: () {
          // TODO: Navigate to lawyer profile page
        },
      ),
    );
  }
}
