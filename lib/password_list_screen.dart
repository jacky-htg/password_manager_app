import 'package:flutter/material.dart';
import '../models/password.dart';
import '../helpers/database_password.dart';
import '../helpers/database_profile.dart';

class PasswordListScreen extends StatefulWidget {
  const PasswordListScreen({super.key});

  @override
  State<PasswordListScreen> createState() => _PasswordListScreenState();
}

class _PasswordListScreenState extends State<PasswordListScreen> {
  List<Password> passwords = [];
  String? userId;

  @override
  void initState() {
    super.initState();
    _loadUserIdAndPasswords();
  }

  Future<void> _loadUserIdAndPasswords() async {
    final profiles = await ProfileDatabaseHelper.fetchProfiles();
    if (profiles.isNotEmpty) {
      userId = profiles.first.userId;
      final fetchedPasswords = await PasswordDatabaseHelper.fetchPasswords();
      setState(() {
        passwords = fetchedPasswords;
      });
    }
  }

  Future<void> _addPassword() async {
    final newPassword = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PasswordForm(userId: userId),
      ),
    );

    if (newPassword != null) {
      await PasswordDatabaseHelper.addPassword(newPassword);
      await _loadUserIdAndPasswords();
    }
  }

  Future<void> _editPassword(Password password) async {
    final updatedPassword = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PasswordForm(userId: userId, password: password),
      ),
    );

    if (updatedPassword != null) {
      await PasswordDatabaseHelper.addPassword(updatedPassword);
      await _loadUserIdAndPasswords();
    }
  }

  Future<void> _deletePassword(String appName) async {
    if (userId != null) {
      await PasswordDatabaseHelper.deletePassword(userId!, appName);
      await _loadUserIdAndPasswords();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Password List'),
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: _addPassword,
            child: const Text('Tambah Password'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: passwords.length,
              itemBuilder: (context, index) {
                final password = passwords[index];
                return ListTile(
                  title: Text(password.appName),
                  subtitle: Text('Username: ${password.username}\nPassword: ${password.password}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => _editPassword(password),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => _deletePassword(password.appName),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class PasswordForm extends StatefulWidget {
  final String? userId;
  final Password? password;

  const PasswordForm({super.key, required this.userId, this.password});

  @override
  State<PasswordForm> createState() => _PasswordFormState();
}

class _PasswordFormState extends State<PasswordForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _appNameController;
  late TextEditingController _usernameController;
  late TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _appNameController = TextEditingController(
      text: widget.password?.appName ?? '',
    );
    _usernameController = TextEditingController(
      text: widget.password?.username ?? '',
    );
    _passwordController = TextEditingController(
      text: widget.password?.password ?? '',
    );
  }

  @override
  void dispose() {
    _appNameController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.password == null ? 'Tambah Password' : 'Edit Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _appNameController,
                decoration: const InputDecoration(labelText: 'App Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'App Name tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(labelText: 'Username'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Username tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Password tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final newPassword = Password(
                      userId: widget.userId!,
                      appName: _appNameController.text,
                      username: _usernameController.text,
                      password: _passwordController.text,
                    );

                    Navigator.pop(context, newPassword);
                  }
                },
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
