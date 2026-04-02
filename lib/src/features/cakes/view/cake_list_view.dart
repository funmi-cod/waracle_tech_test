import 'package:cake_it_app/src/features/cakes/bloc/cake_bloc.dart';
import 'package:cake_it_app/src/features/cakes/bloc/cake_event.dart';
import 'package:cake_it_app/src/features/cakes/bloc/cake_state.dart';
import 'package:cake_it_app/src/features/cakes/models/cake.dart';
import 'package:cake_it_app/src/features/cakes/view/cake_details_view.dart';
import 'package:cake_it_app/src/settings/settings_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Displays a list of cakes.
/// Hmmm Stateful Widget is used here, but it could be a StatelessWidget?
class CakeListView extends StatelessWidget {
  const CakeListView({
    super.key,
  });

  static const routeName = '/';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🎂CakeItApp🍰'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Navigate to the settings page. If the user leaves and returns
              // to the app after it has been killed while running in the
              // background, the navigation stack is restored.
              Navigator.restorablePushNamed(context, SettingsView.routeName);
            },
          ),
        ],
      ),
      body: _buildMainContent(),
    );
  }

  Widget _buildMainContent() {
    return BlocBuilder<CakeBloc, CakeState>(
      builder: (context, state) {
        if (state is CakeInitial || state is CakeLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is CakeLoaded) {
          final cakes = state.cakes;
          return RefreshIndicator(
            onRefresh: () async {
              context.read<CakeBloc>().add(RefreshCakes());
            },
            child: ListView.builder(
              restorationId: 'cakeListView',
              itemCount: cakes.length,
              itemBuilder: (BuildContext context, int index) {
                final cake = cakes[index];

                return ListTile(
                  title: Text('${cake.title}'),
                  subtitle: Text('${cake.description}'),
                  leading: CircleAvatar(
                    child: ClipOval(
                      child: cake.image != null && cake.image!.isNotEmpty
                          ? Image.network(
                              cake.image!,
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(Icons.image);
                              },
                            )
                          : const Icon(Icons.image_not_supported),
                    ),
                  ),
                  onTap: () {
                    Navigator.restorablePushNamed(
                      context,
                      CakeDetailsView.routeName,
                      arguments: Cake(
                        title: cake.title,
                        description: cake.description,
                        image: cake.image,
                      ).toJson(),
                    );
                  },
                );
              },
            ),
          );
        } else if (state is CakeError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 60, color: Colors.red),
                const SizedBox(height: 16),
                Text('Failed to load cakes: ${state.message}'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    context.read<CakeBloc>().add(FetchCakes());
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
