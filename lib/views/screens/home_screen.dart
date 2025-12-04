import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:farmsense/viewmodels/providers.dart';
import 'package:farmsense/views/widgets/weather_card.dart';
import 'package:farmsense/views/screens/add_log_screen.dart';
import 'package:farmsense/views/screens/edit_log_screen.dart';
import 'package:farmsense/views/screens/user_profile_screen.dart';
import 'package:animations/animations.dart';

// A simple skeleton loader widget
class _SkeletonCard extends StatelessWidget {
  const _SkeletonCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest.withAlpha(102),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    height: 16,
                    color: Theme.of(context).colorScheme.surfaceContainerHighest.withAlpha(102),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: 150,
                    height: 12,
                    color: Theme.of(context).colorScheme.surfaceContainerHighest.withAlpha(102),
                  ),
                ],
              ),
            ),
            Container(
              width: 60,
              height: 24,
              color: Theme.of(context).colorScheme.surfaceContainerHighest.withAlpha(102),
            ),
          ],
        ),
      ),
    );
  }
}

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  String _greeting = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _updateGreeting();
    _loadData(); // Simulate data loading
  }

  void _updateGreeting() {
    final hour = DateTime.now().hour;
    setState(() {
      if (hour < 12) {
        _greeting = 'Good Morning';
      } else if (hour < 17) {
        _greeting = 'Good Afternoon';
      } else {
        _greeting = 'Good Evening';
      }
    });
  }

  Future<void> _loadData() async {
    // Simulate a network delay for the skeleton effect
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Color _getStatusChipColor(String status) {
    switch (status.toLowerCase()) {
      case 'harvested':
        return Colors.green.shade200;
      case 'sown':
        return Colors.orange.shade200;
      case 'growing':
        return Colors.blue.shade200;
      default:
        return Colors.grey.shade200;
    }
  }

  Color _getStatusTextColor(String status) {
    switch (status.toLowerCase()) {
      case 'harvested':
        return Colors.green.shade800;
      case 'sown':
        return Colors.orange.shade800;
      case 'growing':
        return Colors.blue.shade800;
      default:
        return Colors.grey.shade800;
    }
  }

  @override
  Widget build(BuildContext context) {
    final cropLogs = ref.watch(cropListProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        title: Row(
          children: [
            const Icon(Icons.agriculture),
            const SizedBox(width: 16),
            Flexible(
              child: Text(
                '$_greeting, Farmer!',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        actions: [
          InkWell(
            onTap: () {
              Navigator.of(context).push(
                PageRouteBuilder(
                  transitionDuration: const Duration(milliseconds: 500),
                  pageBuilder: (context, animation, secondaryAnimation) => const UserProfileScreen(),
                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                    return SharedAxisTransition(
                      animation: animation,
                      secondaryAnimation: secondaryAnimation,
                      transitionType: SharedAxisTransitionType.horizontal,
                      child: child,
                    );
                  },
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              // --- CHANGED: Unified Offline Avatar in AppBar ---
              child: CircleAvatar(
                radius: 20,
                backgroundColor: Theme.of(context).primaryColor.withAlpha(30),
                child: Icon(
                  Icons.person,
                  color: Theme.of(context).primaryColor,
                  size: 24,
                ),
              ),
              // -------------------------------------------------
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const WeatherCard(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Text(
                'Your Crop Logs',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ),
            if (_isLoading)
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 3,
                separatorBuilder: (context, index) => const SizedBox(height: 8.0),
                itemBuilder: (context, index) => const _SkeletonCard(),
              )
            else if (cropLogs.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.agriculture_outlined,
                        size: 80,
                        color: Theme.of(context).colorScheme.primary.withAlpha(153),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No crop logs yet.',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Theme.of(context).colorScheme.onSurface.withAlpha(204)),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Tap the \'+\' button to add your first crop log!',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Theme.of(context).colorScheme.onSurface.withAlpha(153)),
                      ),
                    ],
                  ),
                ),
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: cropLogs.length,
                separatorBuilder: (context, index) => const SizedBox(height: 8.0),
                itemBuilder: (context, index) {
                  final crop = cropLogs[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 16.0),
                    elevation: 2,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          PageRouteBuilder(
                            transitionDuration: const Duration(milliseconds: 500),
                            pageBuilder: (context, animation, secondaryAnimation) => EditLogScreen(cropLog: crop),
                            transitionsBuilder: (context, animation, secondaryAnimation, child) {
                              return SharedAxisTransition(
                                animation: animation,
                                secondaryAnimation: secondaryAnimation,
                                transitionType: SharedAxisTransitionType.horizontal,
                                child: child,
                              );
                            },
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: Theme.of(context).colorScheme.primary.withAlpha(25),
                              foregroundColor: Theme.of(context).colorScheme.primary,
                              child: Text(
                                crop.cropType.isNotEmpty ? crop.cropType[0].toUpperCase() : '?',
                                style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    crop.cropType,
                                    style: Theme.of(context).textTheme.titleLarge,
                                  ),
                                  Text(
                                    'Sown: ${DateFormat('MMM dd, yyyy').format(crop.date)}',
                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                                  ),
                                ],
                              ),
                            ),
                            Chip(
                              label: Text(
                                crop.status,
                                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                  color: _getStatusTextColor(crop.status),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              backgroundColor: _getStatusChipColor(crop.status),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 0),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            PageRouteBuilder(
              transitionDuration: const Duration(milliseconds: 500),
              pageBuilder: (context, animation, secondaryAnimation) => const AddLogScreen(),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                return SharedAxisTransition(
                  animation: animation,
                  secondaryAnimation: secondaryAnimation,
                  transitionType: SharedAxisTransitionType.vertical,
                  child: child,
                );
              },
            ),
          );
        },
        backgroundColor: Theme.of(context).colorScheme.secondary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}