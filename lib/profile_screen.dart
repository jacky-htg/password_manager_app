import 'package:flutter/material.dart';
import '../helpers/database_profile.dart';
import '../models/profile.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Profile? profile;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  // Fungsi untuk memuat data profile dari database
  Future<void> _loadProfile() async {
    final profiles = await ProfileDatabaseHelper.fetchProfiles();
    setState(() {
      profile = profiles.isNotEmpty ? profiles.first : null;
    });
  }

  // Fungsi untuk mengedit profil
  Future<void> _editProfile(BuildContext context) async {
  final updatedProfile = await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => Scaffold(
        appBar: AppBar(
          title: const Text('Edit Profile'),
        ),
        body: ProfileForm(
          profile: profile,
        ),
      ),
    ),
  );

  if (updatedProfile != null) {
    await ProfileDatabaseHelper.addProfile(updatedProfile);
    await _loadProfile();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile berhasil diperbarui')),
    );
  }
}

  // Fungsi untuk menambah profil
  Future<void> _addProfile(Profile newProfile) async {
    await ProfileDatabaseHelper.addProfile(newProfile);
    await _loadProfile();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile berhasil ditambahkan')),
    );
  }

  Future<void> _deleteProfile(BuildContext context) async {
  if (profile != null) {
    try {
      // Delete profile from the database
      await ProfileDatabaseHelper.deleteProfile(profile!.userId);

      // Clear the state and notify user
      setState(() {
        profile = null;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile berhasil dihapus')),
      );
    } catch (e) {
      // Handle errors and notify user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menghapus profile: $e')),
      );
    }
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: profile == null
          ? ProfileForm(onSubmit: _addProfile)
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'User ID: ${profile!.userId}',
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Username: ${profile!.username}',
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Full Name: ${profile!.fullName}',
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Password: ${profile!.password}',
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: () => _editProfile(context),
                        child: const Text('Edit Profile'),
                      ),
                      const SizedBox(width: 16),
                      ElevatedButton(
                        onPressed: () => _deleteProfile(context),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                        child: const Text('Hapus Profile'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}

class ProfileForm extends StatefulWidget {
  final Profile? profile;
  final Function(Profile)? onSubmit;

  const ProfileForm({super.key, this.profile, this.onSubmit});

  @override
  State<ProfileForm> createState() => _ProfileFormState();
}

class _ProfileFormState extends State<ProfileForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _userIdController;
  late TextEditingController _usernameController;
  late TextEditingController _fullNameController;
  late TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _userIdController = TextEditingController(
      text: widget.profile?.userId ?? '',
    );
    _usernameController = TextEditingController(
      text: widget.profile?.username ?? '',
    );
    _fullNameController = TextEditingController(
      text: widget.profile?.fullName ?? '',
    );
    _passwordController = TextEditingController(
      text: widget.profile?.password ?? '',
    );
  }

  @override
  void dispose() {
    _userIdController.dispose();
    _usernameController.dispose();
    _fullNameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _userIdController,
              decoration: const InputDecoration(
                labelText: 'User ID',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'User ID tidak boleh kosong';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Username tidak boleh kosong';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _fullNameController,
              decoration: const InputDecoration(
                labelText: 'Full Name',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Full Name tidak boleh kosong';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Password tidak boleh kosong';
                }
                if (value.length < 6) {
                  return 'Password harus memiliki setidaknya 6 karakter';
                }
                return null;
              },
            ),
            const SizedBox(height: 32),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final newProfile = Profile(
                      userId: _userIdController.text,
                      username: _usernameController.text,
                      fullName: _fullNameController.text,
                      password: _passwordController.text,
                    );

                    if (widget.onSubmit != null) {
                      widget.onSubmit!(newProfile);
                    } else {
                      Navigator.pop(context, newProfile);
                    }
                  }
                },
                child: const Text('Submit'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
