import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../providers/journal_provider.dart';
import '../models/journal_entry.dart';

class EmotionStatsScreen extends StatefulWidget {
  const EmotionStatsScreen({super.key});

  @override
  State<EmotionStatsScreen> createState() => _EmotionStatsScreenState();
}

class _EmotionStatsScreenState extends State<EmotionStatsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Emotion Analytics',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
      ),
      body: Consumer<JournalProvider>(
        builder: (context, journalProvider, child) {
          if (journalProvider.entries.isEmpty) {
            return _buildEmptyState();
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildOverviewCard(journalProvider),
                const SizedBox(height: 24),
                _buildEmotionChart(journalProvider),
                const SizedBox(height: 24),
                _buildEmotionBreakdown(journalProvider),
                const SizedBox(height: 24),
                _buildRecentActivity(journalProvider),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(60),
            ),
            child: Icon(
              Icons.analytics_outlined,
              size: 60,
              color: Colors.grey[400],
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'No data to analyze',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Start journaling to see your emotion analytics',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewCard(JournalProvider journalProvider) {
    final totalEntries = journalProvider.entries.length;
    final recentEntries = journalProvider.getRecentEntries().length;
    final mostCommonEmotion = _getMostCommonEmotion(journalProvider);

    return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Overview',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: _buildStatItem(
                      'Total Entries',
                      totalEntries.toString(),
                      Icons.book,
                      Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildStatItem(
                      'This Week',
                      recentEntries.toString(),
                      Icons.trending_up,
                      Colors.green,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildStatItem(
                      'Most Common',
                      mostCommonEmotion,
                      Icons.favorite,
                      Colors.red,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildStatItem(
                      'Avg. Words',
                      _getAverageWordCount(journalProvider).toString(),
                      Icons.text_fields,
                      Colors.blue,
                    ),
                  ),
                ],
              ),
            ],
          ),
        )
        .animate()
        .fadeIn(delay: 200.ms, duration: 800.ms)
        .slideY(begin: 0.3, duration: 800.ms);
  }

  Widget _buildStatItem(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildEmotionChart(JournalProvider journalProvider) {
    final emotionStats = journalProvider.getEmotionStats();
    final chartData = emotionStats.entries
        .where((entry) => entry.value > 0)
        .map(
          (entry) => PieChartSectionData(
            color: _getEmotionColor(entry.key),
            value: entry.value.toDouble(),
            title: '${entry.value}',
            radius: 60,
            titleStyle: GoogleFonts.poppins(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        )
        .toList();

    return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Emotion Distribution',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 200,
                child: chartData.isEmpty
                    ? Center(
                        child: Text(
                          'No data available',
                          style: GoogleFonts.poppins(color: Colors.grey[500]),
                        ),
                      )
                    : PieChart(
                        PieChartData(
                          sections: chartData,
                          centerSpaceRadius: 40,
                          sectionsSpace: 2,
                        ),
                      ),
              ),
            ],
          ),
        )
        .animate()
        .fadeIn(delay: 400.ms, duration: 800.ms)
        .slideY(begin: 0.3, duration: 800.ms);
  }

  Widget _buildEmotionBreakdown(JournalProvider journalProvider) {
    final emotionStats = journalProvider.getEmotionStats();

    return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Emotion Breakdown',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 20),
              ...emotionStats.entries.map((entry) {
                final percentage = journalProvider.entries.isEmpty
                    ? 0.0
                    : (entry.value / journalProvider.entries.length * 100);
                return _buildEmotionItem(entry.key, entry.value, percentage);
              }),
            ],
          ),
        )
        .animate()
        .fadeIn(delay: 600.ms, duration: 800.ms)
        .slideY(begin: 0.3, duration: 800.ms);
  }

  Widget _buildEmotionItem(EmotionType emotion, int count, double percentage) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: _getEmotionColor(emotion).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              _getEmotionEmoji(emotion),
              style: const TextStyle(fontSize: 20),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getEmotionName(emotion),
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                LinearProgressIndicator(
                  value: percentage / 100,
                  backgroundColor: Colors.grey[200],
                  valueColor: AlwaysStoppedAnimation<Color>(
                    _getEmotionColor(emotion),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                count.toString(),
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: _getEmotionColor(emotion),
                ),
              ),
              Text(
                '${percentage.toStringAsFixed(1)}%',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRecentActivity(JournalProvider journalProvider) {
    final recentEntries = journalProvider.getRecentEntries().take(5).toList();

    return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Recent Activity',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 20),
              ...recentEntries.map((entry) => _buildActivityItem(entry)),
            ],
          ),
        )
        .animate()
        .fadeIn(delay: 800.ms, duration: 800.ms)
        .slideY(begin: 0.3, duration: 800.ms);
  }

  Widget _buildActivityItem(JournalEntry entry) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: _getEmotionColor(entry.emotion).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              _getEmotionEmoji(entry.emotion),
              style: const TextStyle(fontSize: 16),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.title,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  DateFormat('MMM dd, HH:mm').format(entry.createdAt),
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getMostCommonEmotion(JournalProvider journalProvider) {
    final emotionStats = journalProvider.getEmotionStats();
    if (emotionStats.isEmpty) return 'None';

    final mostCommon = emotionStats.entries.reduce(
      (a, b) => a.value > b.value ? a : b,
    );
    return _getEmotionName(mostCommon.key);
  }

  int _getAverageWordCount(JournalProvider journalProvider) {
    if (journalProvider.entries.isEmpty) return 0;

    final totalWords = journalProvider.entries
        .map((entry) => entry.wordCount)
        .reduce((a, b) => a + b);
    return (totalWords / journalProvider.entries.length).round();
  }

  Color _getEmotionColor(EmotionType emotion) {
    switch (emotion) {
      case EmotionType.happy:
        return Colors.yellow;
      case EmotionType.sad:
        return Colors.blue;
      case EmotionType.angry:
        return Colors.red;
      case EmotionType.neutral:
        return Colors.grey;
      case EmotionType.excited:
        return Colors.orange;
      case EmotionType.anxious:
        return Colors.purple;
      case EmotionType.grateful:
        return Colors.green;
      case EmotionType.frustrated:
        return Colors.deepOrange;
    }
  }

  String _getEmotionEmoji(EmotionType emotion) {
    switch (emotion) {
      case EmotionType.happy:
        return '😊';
      case EmotionType.sad:
        return '😢';
      case EmotionType.angry:
        return '😠';
      case EmotionType.neutral:
        return '😐';
      case EmotionType.excited:
        return '🤩';
      case EmotionType.anxious:
        return '😰';
      case EmotionType.grateful:
        return '🙏';
      case EmotionType.frustrated:
        return '😤';
    }
  }

  String _getEmotionName(EmotionType emotion) {
    switch (emotion) {
      case EmotionType.happy:
        return 'Happy';
      case EmotionType.sad:
        return 'Sad';
      case EmotionType.angry:
        return 'Angry';
      case EmotionType.neutral:
        return 'Neutral';
      case EmotionType.excited:
        return 'Excited';
      case EmotionType.anxious:
        return 'Anxious';
      case EmotionType.grateful:
        return 'Grateful';
      case EmotionType.frustrated:
        return 'Frustrated';
    }
  }
}
