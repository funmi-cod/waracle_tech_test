import 'package:cake_it_app/src/features/cake.dart';
import 'package:flutter/material.dart';

/// Displays detailed information about a cake.
class CakeDetailsView extends StatelessWidget {
  const CakeDetailsView({
    super.key,
  });

  static const routeName = '/cake_detail';

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    Cake cake = Cake.fromJson(args);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cake Details'),
      ),
      body: Column(
        children: [
          Center(
            child: Text('${cake.title}',
                style: Theme.of(context).textTheme.titleLarge),
          ),
          Center(
            child: Text('${cake.description}'),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: cake.image != null && cake.image!.isNotEmpty
                  ? Image.network(
                      cake.image!,
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 200,
                          width: double.infinity,
                          color: Colors.grey[200],
                          child: const Icon(Icons.broken_image,
                              color: Colors.grey, size: 50),
                        );
                      },
                    )
                  : Container(
                      height: 200,
                      width: double.infinity,
                      color: Colors.grey[200],
                      child: const Icon(Icons.image_not_supported,
                          color: Colors.grey, size: 50),
                    ),
            ),
          )
        ],
      ),
    );
  }
}
