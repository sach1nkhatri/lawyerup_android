import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:lawyerup_android/features/settings/presentation/widgets/FaqPopupWidget.dart';
import '../../../../app/routes/app_router.dart';
import '../../../../app/service_locater/service_locator.dart';
import '../../../../app/shared/widgets/global_snackbar.dart';
import '../../../auth/domain/repositories/auth_repository.dart';
import '../bloc/settings_bloc.dart';
import '../bloc/settings_bloc_event.dart';
import '../bloc/settings_bloc_state.dart';
import '../widgets/PrivacyPopup.dart';
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
      builder: (context) => Dialog(
        elevation: 8,
        backgroundColor: Colors.white.withOpacity(0.95),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Column(
                      children: const [
                        Icon(Icons.person, size: 36, color: Colors.deepPurple),
                        SizedBox(height: 8),
                        Text(
                          "Edit Profile",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                            fontFamily: 'Lora',
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  buildReadOnlyField("Name", nameController),
                  buildReadOnlyField("Email", emailController),
                  buildEditableField("Phone", phoneController),
                  buildEditableField("State", stateController),
                  buildEditableField("City", cityController),
                  buildEditableField("Address", addressController),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton.icon(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close, color: Colors.redAccent),
                        label: const Text(
                          "Cancel",
                          style: TextStyle(color: Colors.redAccent, fontFamily: 'PlayfairDisplay'),
                        ),
                      ),
                      ElevatedButton.icon(
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
                        icon: const Icon(Icons.save),
                        label: const Text("Save Changes", style: TextStyle(fontFamily: 'PlayfairDisplay')),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildEditableField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(fontFamily: 'PlayfairDisplay'),
          filled: true,
          fillColor: Colors.grey.shade100,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
        validator: (val) => val == null || val.isEmpty ? "Required" : null,
        style: const TextStyle(fontFamily: 'PlayfairDisplay'),
      ),
    );
  }

  Widget buildReadOnlyField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        controller: controller,
        enabled: false,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(fontFamily: 'PlayfairDisplay'),
          filled: true,
          fillColor: Colors.grey.shade200,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
        style: const TextStyle(fontFamily: 'PlayfairDisplay'),
      ),
    );
  }

  void confirmToggle(String label, VoidCallback onConfirm) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Are you sure?', style: TextStyle(fontFamily: 'Lora')),
        content: Text('Do you want to toggle $label?', style: const TextStyle(fontFamily: 'PlayfairDisplay')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel', style: TextStyle(fontFamily: 'PlayfairDisplay')),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Confirm', style: TextStyle(fontFamily: 'PlayfairDisplay')),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      onConfirm();
      GlobalSnackBar.show(
        context,
        '$label updated',
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
        title: const Text("Settings", style: TextStyle(color: Colors.white, fontFamily: 'Lora')),
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
                    Text(user.fullName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Lora')),
                    const SizedBox(height: 4),
                    Text(user.city, style: const TextStyle(fontFamily: 'PlayfairDisplay')),
                    Text("Since ${user.createdAt.year}", style: const TextStyle(fontFamily: 'PlayfairDisplay')),
                    Text("${user.plan} Plan", style: const TextStyle(fontFamily: 'PlayfairDisplay')),
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
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontFamily: 'Lora'),
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
                        Expanded(child: Text("Complete your profile to get personalized recommendations.", style: TextStyle(fontFamily: 'PlayfairDisplay'))),
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
                    } else if (index == 2) {
                      showDialog(context: context, builder: (_) => const FaqPopupWidget());
                    }
                  },
                ),
                const SizedBox(height: 24),
                SettingsSection(
                  title: "Preferences",
                  items: ["Notifications", "Automated Updates"],
                  switches: [notificationsEnabled, updatesEnabled],
                  onSwitchToggle: (index, value) {
                    final label = index == 0 ? 'Notifications' : 'Automated Updates';
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
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.red, fontFamily: 'Lora'),
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
                    Text('This action cannot be undone.', style: TextStyle(color: Colors.red, fontSize: 13, fontFamily: 'PlayfairDisplay')),
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
                      label: const Text('Logout', style: TextStyle(fontFamily: 'PlayfairDisplay')),
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
            return Center(child: Text(state.message, style: const TextStyle(fontFamily: 'PlayfairDisplay')));
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
        Expanded(child: Text(label, style: const TextStyle(fontFamily: 'PlayfairDisplay'))),
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
          child: const Text('Delete', style: TextStyle(fontFamily: 'PlayfairDisplay')),
        ),
      ],
    );
  }
}
