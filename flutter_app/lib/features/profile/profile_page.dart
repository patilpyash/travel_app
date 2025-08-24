import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _fullName = TextEditingController();
  final _avatarUrl = TextEditingController();
  String _email = '';
  bool _loading = true;

  Future<void> _load() async {
    final user = Supabase.instance.client.auth.currentUser!;
    _email = user.email ?? '';
    final rows = await Supabase.instance.client
        .from('profiles')
        .select()
        .eq('id', user.id)
        .maybeSingle();
    if (rows != null) {
      _fullName.text = rows['full_name'] ?? '';
      _avatarUrl.text = rows['avatar_url'] ?? '';
    }
    setState(() => _loading = false);
  }

  Future<void> _save() async {
    final user = Supabase.instance.client.auth.currentUser!;
    await Supabase.instance.client.from('profiles').upsert({
      'id': user.id,
      'email': _email,
      'full_name': _fullName.text.trim(),
      'avatar_url': _avatarUrl.text.trim(),
    });
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Profile saved')));
  }

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Your Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text('Email: $_email'),
            TextField(controller: _fullName, decoration: const InputDecoration(labelText: 'Full name')),
            TextField(controller: _avatarUrl, decoration: const InputDecoration(labelText: 'Avatar URL')),
            const SizedBox(height: 12),
            FilledButton(onPressed: _save, child: const Text('Save')),
            const SizedBox(height: 12),
            FilledButton.tonal(
              onPressed: () => Supabase.instance.client.auth.signOut(),
              child: const Text('Sign out'),
            ),
          ],
        ),
      ),
    );
  }
}
