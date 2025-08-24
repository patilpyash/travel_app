import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../models/person.dart';
import 'person_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Person>> _future;

  Future<List<Person>> _fetch() async {
    final rows = await Supabase.instance.client
        .from('people')
        .select()
        .order('created_at', ascending: false);
    return (rows as List).map((e) => Person.fromJson(e as Map<String, dynamic>)).toList();
  }

  @override
  void initState() {
    super.initState();
    _future = _fetch();
  }

  @override
  Widget build(BuildContext context) {
    final session = Supabase.instance.client.auth.currentSession;
    return Scaffold(
      appBar: AppBar(
        title: const Text('John Doe Feed'),
        actions: [
          IconButton(onPressed: () => context.go('/profile'), icon: const Icon(Icons.person_outline)),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async { setState(() => _future = _fetch()); await _future; },
        child: FutureBuilder<List<Person>>(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            final people = snapshot.data ?? [];
            if (people.isEmpty) {
              return const Center(child: Text('No people yet.'));
            }
            return ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: people.length,
              itemBuilder: (context, i) => PersonCard(person: people[i]),
            );
          },
        ),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(child: FlutterLogo(size: 72)),
            ListTile(
              leading: const Icon(Icons.home_outlined),
              title: const Text('Home'),
              onTap: () => context.go('/home'),
            ),
            if (session == null)
              ListTile(
                leading: const Icon(Icons.login),
                title: const Text('Sign in'),
                onTap: () => context.go('/sign-in'),
              )
            else
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Sign out'),
                onTap: () => Supabase.instance.client.auth.signOut(),
              ),
          ],
        ),
      ),
    );
  }
}
