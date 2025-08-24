import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../models/person.dart';

class PersonCard extends StatelessWidget {
  final Person person;
  const PersonCard({super.key, required this.person});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (person.imageUrl != null)
            AspectRatio(
              aspectRatio: 3/2,
              child: CachedNetworkImage(
                imageUrl: person.imageUrl!,
                fit: BoxFit.cover,
                placeholder: (c, _) => const Center(child: CircularProgressIndicator()),
                errorWidget: (c, _, __) => const Center(child: Icon(Icons.image_not_supported_outlined)),
              ),
            ),
          ListTile(
            title: Text(person.fullName),
            subtitle: Text(person.title ?? '—'),
          ),
          if (person.bio != null) Padding(
            padding: const EdgeInsets.all(12),
            child: Text(person.bio!),
          ),
        ],
      ),
    );
  }
}
