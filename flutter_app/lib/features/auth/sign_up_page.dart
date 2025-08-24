import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _fullName = TextEditingController();
  bool _loading = false;
  String? _error;

  Future<void> _signUp() async {
    setState(() { _loading = true; _error = null; });
    try {
      final res = await Supabase.instance.client.auth.signUp(
        email: _email.text.trim(),
        password: _password.text,
        data: { 'full_name': _fullName.text.trim() },
      );
      final user = res.user;
      if (user != null) {
        await Supabase.instance.client.from('profiles').upsert({
          'id': user.id,
          'email': _email.text.trim(),
          'full_name': _fullName.text.trim(),
        });
      }
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Account created. You are signed in.')));
      Navigator.of(context).pop();
    } on AuthException catch (e) {
      setState(() { _error = e.message; });
    } finally {
      if (mounted) setState(() { _loading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign up')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            if (_error != null) Text(_error!, style: const TextStyle(color: Colors.red)),
            TextField(controller: _fullName, decoration: const InputDecoration(labelText: 'Full name')),
            TextField(controller: _email, decoration: const InputDecoration(labelText: 'Email')),
            TextField(controller: _password, decoration: const InputDecoration(labelText: 'Password'), obscureText: true),
            const SizedBox(height: 12),
            FilledButton(onPressed: _loading ? null : _signUp, child: _loading ? const CircularProgressIndicator() : const Text('Sign up')),
          ],
        ),
      ),
    );
  }
}
