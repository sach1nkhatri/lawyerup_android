import 'package:flutter/material.dart';

class JoinAsLawyerPage extends StatefulWidget {
  const JoinAsLawyerPage({Key? key}) : super(key: key);

  @override
  State<JoinAsLawyerPage> createState() => _JoinAsLawyerPageState();
}

class _JoinAsLawyerPageState extends State<JoinAsLawyerPage> {
  int step = 1;
  bool isJunior = false;

  final form = {
    'fullName': '',
    'specialization': '',
    'email': '',
    'phone': '',
    'state': '',
    'city': '',
    'address': '',
    'expectedGraduation': '',
    'description': '',
    'specialCase': '',
    'socialLink': '',
    'eduDegree': '',
    'eduInstitute': '',
    'eduYear': '',
    'eduSpecialization': '',
    'workCourt': '',
    'workFrom': '',
    'workTo': '',
  };

  List<Map<String, String>> educationList = [];
  List<Map<String, String>> workList = [];

  void addEducation() {
    setState(() {
      educationList.add({
        'degree': form['eduDegree']!,
        'institute': form['eduInstitute']!,
        'year': form['eduYear']!,
        'specialization': form['eduSpecialization']!,
      });
      form['eduDegree'] = '';
      form['eduInstitute'] = '';
      form['eduYear'] = '';
      form['eduSpecialization'] = '';
    });
  }

  void addWork() {
    setState(() {
      workList.add({
        'court': form['workCourt']!,
        'from': form['workFrom']!,
        'to': form['workTo']!,
      });
      form['workCourt'] = '';
      form['workFrom'] = '';
      form['workTo'] = '';
    });
  }

  Widget input(String key, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        initialValue: form[key],
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onChanged: (val) => form[key] = val,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      appBar: AppBar(
        backgroundColor: const Color(0xFF1C2D3D),
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Join as a Lawyer",
          style: TextStyle(
            fontFamily: 'Lora',
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        elevation: 4,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () => setState(() => isJunior = !isJunior),
              child: Text(
                isJunior ? 'Switch to Senior Lawyer Form' : 'Join as Junior Lawyer',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Text(
            step == 1 ? "Personal Information" : "Education & Work",
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          if (step == 1) ...[
            input('fullName', 'Full Name'),
            if (!isJunior) input('specialization', 'Specialization'),
            input('email', 'Email'),
            input('phone', 'Phone'),
            input('state', 'State'),
            input('city', 'City'),
            input('address', 'Address'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => setState(() => step = 2),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1C2D3D),
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text("Next"),
            ),
          ] else ...[
            if (isJunior) input('expectedGraduation', 'Expected Graduation Year'),
            input('description', 'Short Description (max 200 chars)'),
            input('specialCase', 'Special Case or Interest'),
            input('socialLink', 'Social Link (optional)'),

            if (!isJunior) ...[
              const SizedBox(height: 20),
              const Text("Work Experience", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              input('workCourt', 'Court'),
              input('workFrom', 'From'),
              input('workTo', 'To'),
              ElevatedButton(
                onPressed: addWork,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey.shade700,
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(45),
                ),
                child: const Text("Add Work"),
              ),
              const SizedBox(height: 10),
              for (var w in workList)
                ListTile(
                  leading: const Icon(Icons.work),
                  title: Text("${w['court']} (${w['from']} - ${w['to']})"),
                ),
            ],

            const SizedBox(height: 20),
            const Text("Academic Details", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            input('eduDegree', 'Degree'),
            input('eduInstitute', 'Institute'),
            input('eduYear', 'Year'),
            input('eduSpecialization', 'Specialization'),
            ElevatedButton(
              onPressed: addEducation,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey.shade700,
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(45),
              ),
              child: const Text("Add Education"),
            ),
            const SizedBox(height: 10),
            for (var e in educationList)
              ListTile(
                leading: const Icon(Icons.school),
                title: Text(
                    "${e['degree']} - ${e['institute']} (${e['year']}) | ${e['specialization']}"),
              ),

            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: () {
                // submit logic
              },
              icon: const Icon(Icons.check_circle),
              label: const Text("Join Now"),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1C2D3D),
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(55),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ]
        ],
      ),
    );
  }
}
