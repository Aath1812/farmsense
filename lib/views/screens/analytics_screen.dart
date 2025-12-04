// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:farmsense/models/crop_log.dart';
import 'package:farmsense/viewmodels/providers.dart';

final selectedStatusFilterProvider = StateProvider<String>((ref) => 'Harvested');

class AnalyticsScreen extends ConsumerWidget {
  const AnalyticsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cropLogs = ref.watch(cropListProvider);
    final String selectedFilter = ref.watch(selectedStatusFilterProvider);

    // 1. Filter Logs based on Dropdown
    List<CropLog> filteredLogs;
    if (selectedFilter == 'Total') {
      filteredLogs = cropLogs;
    } else {
      filteredLogs = cropLogs.where((log) => log.status == selectedFilter).toList();
    }

    // 2. Prepare Data
    final bool useYieldMetric = selectedFilter == 'Harvested';
    final Map<String, double> dataMap = {};

    for (var log in filteredLogs) {
      if (useYieldMetric) {
        // Sum yield for Harvested
        dataMap.update(log.cropType, (val) => val + log.yieldAmount, ifAbsent: () => log.yieldAmount);
      } else {
        // Count entries for Sown/Growing
        dataMap.update(log.cropType, (val) => val + 1, ifAbsent: () => 1.0);
      }
    }

    // 3. Sort Data (High to Low)
    final sortedEntries = dataMap.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final double maxValue = sortedEntries.isNotEmpty ? sortedEntries.first.value : 1.0;

    // 4. Calculate Overall Summary Stats
    final allLogs = cropLogs.where((log) => log.yieldAmount > 0).toList();
    final double totalYieldOverall = allLogs.fold(0.0, (sum, log) => sum + log.yieldAmount);

    // Find today's top performer
    final today = DateTime.now();
    final todayLogs = allLogs.where((log) =>
    log.date.year == today.year &&
        log.date.month == today.month &&
        log.date.day == today.day).toList();

    final Map<String, double> todayYields = {};
    for (var log in todayLogs) {
      todayYields.update(log.cropType, (v) => v + log.yieldAmount, ifAbsent: () => log.yieldAmount);
    }
    final String todayBestName = todayYields.isEmpty ? 'N/A' :
    todayYields.entries.reduce((a, b) => a.value > b.value ? a : b).key;
    final double todayBestVal = todayYields[todayBestName] ?? 0.0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Crop Analytics'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Header Section ---
            Text(
              'Top Crops', // CHANGED: Friendly Name
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.green.shade800,
              ),
            ),
            const SizedBox(height: 4.0),
            Text(
              // CHANGED: Friendly Description
              'See which crops are leading in ${useYieldMetric ? "production" : "activity"}.',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.black54),
            ),

            const SizedBox(height: 16.0),

            // --- Filter Dropdown ---
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: selectedFilter,
                  isExpanded: true,
                  // CHANGED: Farmer-Friendly Options
                  items: const [
                    DropdownMenuItem(value: 'Harvested', child: Text('Biggest Harvests (kg)')),
                    DropdownMenuItem(value: 'Sown', child: Text('Most Planted')),
                    DropdownMenuItem(value: 'Growing', child: Text('Active Fields')),
                    DropdownMenuItem(value: 'Total', child: Text('All Activity')),
                  ],
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      ref.read(selectedStatusFilterProvider.notifier).state = newValue;
                    }
                  },
                ),
              ),
            ),

            const SizedBox(height: 24.0),

            // --- THE LIST ---
            sortedEntries.isEmpty
                ? _buildEmptyState()
                : ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: sortedEntries.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final entry = sortedEntries[index];
                final percentage = entry.value / maxValue;
                final isTop = index == 0;

                return _buildLeaderboardItem(
                    context,
                    entry.key,
                    entry.value,
                    percentage,
                    isTop,
                    useYieldMetric
                );
              },
            ),

            const SizedBox(height: 32.0),

            // --- Overall Yield Summary (Cards) ---
            if (allLogs.isNotEmpty) ...[
              Text(
                'Total Production', // CHANGED: Simpler Title
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.green.shade800,
                ),
              ),
              const SizedBox(height: 16.0),
              Row(
                children: [
                  Expanded(child: _buildSummaryCard(context, "Total Yield", "${totalYieldOverall.toStringAsFixed(1)} kg", Icons.scale)),
                  const SizedBox(width: 12),
                  Expanded(child: _buildSummaryCard(context, "Best Today", "$todayBestName\n${todayBestVal.toStringAsFixed(1)} kg", Icons.emoji_events)),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  // --- Helper Widgets ---

  Widget _buildLeaderboardItem(BuildContext context, String name, double value, double percentage, bool isTop, bool isYield) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withAlpha(25),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
        border: isTop ? Border.all(color: Colors.amber.shade300, width: 1.5) : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  if (isTop) ...[
                    const Icon(Icons.star, size: 18, color: Colors.amber),
                    const SizedBox(width: 6),
                  ],
                  Text(
                    name,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ],
              ),
              Text(
                isYield ? "${value.toStringAsFixed(1)} kg" : "${value.toInt()} logs",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isTop ? Colors.green.shade700 : Colors.grey.shade700
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Animated Bar
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: percentage, // Normalized 0.0 to 1.0
              minHeight: 10,
              backgroundColor: Colors.grey.shade100,
              color: isTop ? Colors.green : Colors.green.shade300,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(BuildContext context, String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.green.shade100),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.green.shade700, size: 28),
          const SizedBox(height: 8),
          Text(title, style: TextStyle(color: Colors.green.shade900, fontSize: 12)),
          const SizedBox(height: 4),
          Text(
              value,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.green.shade800, fontWeight: FontWeight.bold, fontSize: 16)
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(32),
      alignment: Alignment.center,
      child: Column(
        children: const [
          Icon(Icons.bar_chart, size: 48, color: Colors.grey),
          SizedBox(height: 12),
          Text("No records found.", style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}