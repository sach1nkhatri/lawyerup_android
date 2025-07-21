import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import '../../../../app/routes/app_router.dart';
import '../../../../app/service_locater/service_locator.dart';
import '../../../../app/shared/widgets/global_snackbar.dart';
import '../../../auth/domain/repositories/auth_repository.dart';
import '../bloc/settings_bloc.dart';
import '../bloc/settings_bloc_event.dart';
import '../bloc/settings_bloc_state.dart';
import '../widgets/settings_section.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<SettingsBloc>()..add(LoadSettingsUser()),
      child: const _SettingsView(),
    );
  }
}

class _SettingsView extends StatefulWidget {
  const _SettingsView({super.key});

  @override
  State<_SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<_SettingsView> {
  bool notificationsEnabled = false;
  bool updatesEnabled = false;

  final formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  void showEditProfileDialog(SettingsState state) {
    if (state is! SettingsLoaded) return;
    final user = state.user;

    phoneController.text = user.contactNumber;
    stateController.text = user.state;
    cityController.text = user.city;
    addressController.text = user.address;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Edit Profile"),
        content: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(controller: nameController, decoration: const InputDecoration(labelText: 'Name'), enabled: false),
                TextFormField(controller: emailController, decoration: const InputDecoration(labelText: 'Email'), enabled: false),
                TextFormField(controller: phoneController, decoration: const InputDecoration(labelText: 'Phone')),
                TextFormField(controller: stateController, decoration: const InputDecoration(labelText: 'State')),
                TextFormField(controller: cityController, decoration: const InputDecoration(labelText: 'City')),
                TextFormField(controller: addressController, decoration: const InputDecoration(labelText: 'Address')),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                context.read<SettingsBloc>().add(SaveSettingsUserProfile(
                  contactNumber: phoneController.text,
                  state: stateController.text,
                  city: cityController.text,
                  address: addressController.text,
                ));
                Navigator.pop(context);
              }
            },
            child: const Text("Save"),
          )
        ],
      ),
    );
  }

  void confirmToggle(String label, VoidCallback onConfirm) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Are you sure?'),
        content: Text('Do you want to toggle $label?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Confirm'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      onConfirm();
      GlobalSnackBar.show(
        context,
        '$label updated (for visual only)',
        type: SnackType.success,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E2B3A),
        elevation: 0,
        title: const Text("Settings", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: BlocConsumer<SettingsBloc, SettingsState>(
        listener: (context, state) {
          if (state is SettingsUpdateSuccess) {
            GlobalSnackBar.show(context, 'Profile updated successfully');
          }
        },
        builder: (context, state) {
          if (state is SettingsLoading || state is SettingsInitial) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is SettingsLoaded) {
            final user = state.user;

            nameController.text = user.fullName;
            emailController.text = user.email;

            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(user.fullName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(user.city),
                    Text("Since ${user.createdAt.year}"),
                    Text("${user.plan} Plan"),
                    const SizedBox(height: 12),
                    GestureDetector(
                      onTap: () {
                        GlobalSnackBar.show(
                          context,
                          'Checkout is currently unavailable. Coming soon!',
                          type: SnackType.error,
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(colors: [Colors.purple, Colors.deepPurple]),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Text(
                          user.plan == 'Free Trial' ? 'Get Plus ➕' : 'Upgrade ➕',
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                if (user.city.isEmpty || user.state.isEmpty || user.address.isEmpty)
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.amber.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: const [
                        Icon(Icons.warning_amber_rounded, color: Colors.orange),
                        SizedBox(width: 8),
                        Expanded(child: Text("Complete your profile to get personalized recommendations.")),
                      ],
                    ),
                  ),

                const SizedBox(height: 24),

                SettingsSection(
                  title: "Account",
                  items: ["Edit Profile", "Privacy", "Help & FAQ"],
                  onTap: (index) {
                    if (index == 0) {
                      showEditProfileDialog(state);
                    } else if (index == 1) {
                      showDialog(context: context, builder: (_) => const PrivacyPopup());
                    }
                  },
                ),

                const SizedBox(height: 24),

                SettingsSection(
                  title: "Preferences",
                  items: ["Notifications", "Updates"],
                  switches: [notificationsEnabled, updatesEnabled],
                  onSwitchToggle: (index, value) {
                    final label = index == 0 ? 'Notifications' : 'Updates';
                    confirmToggle(label, () {
                      setState(() {
                        if (index == 0) notificationsEnabled = value;
                        if (index == 1) updatesEnabled = value;
                      });
                    });
                  },
                ),

                const SizedBox(height: 24),

                const Text(
                  'Danger Zone',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.red),
                ),
                const SizedBox(height: 12),

                Column(
                  children: [
                    buildDangerRow(context, 'Clear Booking & Chat History'),
                    const SizedBox(height: 12),
                    buildDangerRow(context, 'Clear Law AI Data'),
                    const SizedBox(height: 12),
                    buildDangerRow(context, 'Delete Account'),
                  ],
                ),

                const SizedBox(height: 12),
                Row(
                  children: const [
                    Icon(Icons.warning_amber_rounded, color: Colors.red, size: 16),
                    SizedBox(width: 6),
                    Text('This action cannot be undone.', style: TextStyle(color: Colors.red, fontSize: 13)),
                  ],
                ),

                const SizedBox(height: 32),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        await sl<AuthRepository>().logout();
                        final settingsBox = await Hive.openBox('settingsBox');
                        await settingsBox.clear();
                        Navigator.pushNamedAndRemoveUntil(context, AppRouter.login, (route) => false);
                      },
                      icon: const Icon(Icons.logout),
                      label: const Text('Logout'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        textStyle: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 32),
              ],
            );
          } else if (state is SettingsError) {
            return Center(child: Text(state.message));
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }

  Widget buildDangerRow(BuildContext context, String label) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(child: Text(label)),
        ElevatedButton(
          onPressed: () {
            GlobalSnackBar.show(context, '$label not implemented yet.', type: SnackType.warning);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          ),
          child: const Text('Delete'),
        ),
      ],
    );
  }
}

class PrivacyPopup extends StatelessWidget {
  const PrivacyPopup({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Privacy Policy"),
      content: const SingleChildScrollView(
        child: Text("This is where your privacy policy content will go."),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Close"),
        ),
      ],
    );
  }
}
