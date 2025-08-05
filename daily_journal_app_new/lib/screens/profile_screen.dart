import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../providers/auth_provider.dart';
import '../providers/journal_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Profile',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        actions: [
          IconButton(
            onPressed: () {
              _showLogoutDialog(context);
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          if (authProvider.user == null) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                _buildProfileHeader(context, authProvider),
                const SizedBox(height: 24),
                _buildStatsSection(context),
                const SizedBox(height: 24),
                _buildSettingsSection(context),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context, AuthProvider authProvider) {
    return Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              // Profile Picture
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(
                    color: Theme.of(
                      context,
                    ).colorScheme.primary.withOpacity(0.3),
                    width: 3,
                  ),
                ),
                child: authProvider.user?.profileImageUrl != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(47),
                        child: Image.network(
                          authProvider.user!.profileImageUrl!,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Icon(
                        Icons.person,
                        size: 50,
                        color: Theme.of(context).colorScheme.primary,
                      ),
              ),
              const SizedBox(height: 16),

              // User Name
              Text(
                authProvider.user?.name ?? 'User',
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 4),

              // Email
              Text(
                authProvider.user?.email ?? '',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 16),

              // Member Since
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Member since ${DateFormat('MMM yyyy').format(authProvider.user?.createdAt ?? DateTime.now())}',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ),
            ],
          ),
        )
        .animate()
        .fadeIn(delay: 200.ms, duration: 800.ms)
        .slideY(begin: 0.3, duration: 800.ms);
  }

  Widget _buildStatsSection(BuildContext context) {
    return Consumer<JournalProvider>(
      builder: (context, journalProvider, child) {
        final totalEntries = journalProvider.entries.length;
        final recentEntries = journalProvider.getRecentEntries().length;
        final totalWords = journalProvider.entries
            .map((entry) => entry.wordCount)
            .fold(0, (sum, count) => sum + count);

        return Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
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
                    'Your Journal Stats',
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
                        child: _buildStatCard(
                          'Total Entries',
                          totalEntries.toString(),
                          Icons.book,
                          Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildStatCard(
                          'This Week',
                          recentEntries.toString(),
                          Icons.trending_up,
                          Colors.green,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          'Total Words',
                          totalWords.toString(),
                          Icons.text_fields,
                          Colors.blue,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildStatCard(
                          'Avg. Words',
                          totalEntries > 0
                              ? (totalWords / totalEntries).round().toString()
                              : '0',
                          Icons.analytics,
                          Colors.orange,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
            .animate()
            .fadeIn(delay: 400.ms, duration: 800.ms)
            .slideY(begin: 0.3, duration: 800.ms);
      },
    );
  }

  Widget _buildStatCard(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 18,
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

  Widget _buildSettingsSection(BuildContext context) {
    return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
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
                'Settings',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 20),
              _buildSettingItem(
                context: context,
                icon: Icons.edit,
                title: 'Edit Profile',
                subtitle: 'Update your personal information',
                onTap: () {},
              ),
              _buildSettingItem(
                context: context,
                icon: Icons.notifications,
                title: 'Notifications',
                subtitle: 'Manage your notification preferences',
                onTap: () {},
              ),
              _buildSettingItem(
                context: context,
                icon: Icons.security,
                title: 'Privacy & Security',
                subtitle: 'Manage your privacy settings',
                onTap: () {},
              ),
              _buildSettingItem(
                context: context,
                icon: Icons.help,
                title: 'Help & Support',
                subtitle: 'Get help and contact support',
                onTap: () {},
              ),
              _buildSettingItem(
                context: context,
                icon: Icons.info,
                title: 'About',
                subtitle: 'App version and information',
                onTap: () {
                  _showAboutDialog(context);
                },
              ),
            ],
          ),
        )
        .animate()
        .fadeIn(delay: 600.ms, duration: 800.ms)
        .slideY(begin: 0.3, duration: 800.ms);
  }

  Widget _buildSettingItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: Theme.of(context).colorScheme.primary,
            size: 20,
          ),
        ),
        title: Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[600]),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: Colors.grey,
        ),
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(
          'Sign Out',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        content: Text(
          'Are you sure you want to sign out?',
          style: GoogleFonts.poppins(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text('Cancel', style: GoogleFonts.poppins()),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              _signOut(context);
            },
            child: Text(
              'Sign Out',
              style: GoogleFonts.poppins(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(
          'About Daily Journal',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Version 1.0.0',
              style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(
              'A beautiful daily journal app to track your emotions and reflect on your day.',
              style: GoogleFonts.poppins(),
            ),
            const SizedBox(height: 16),
            Text(
              'Features:',
              style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(
              '• Emotion tracking with emojis\n• Beautiful and responsive UI\n• Firebase integration\n• Analytics and insights\n• Secure authentication',
              style: GoogleFonts.poppins(fontSize: 14),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text('Close', style: GoogleFonts.poppins()),
          ),
        ],
      ),
    );
  }

  Future<void> _signOut(BuildContext context) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final journalProvider = Provider.of<JournalProvider>(
      context,
      listen: false,
    );

    await authProvider.signOut();
    journalProvider.clearEntries();

    if (context.mounted) {
      Navigator.of(context).pushReplacementNamed('/login');
    }
  }
}
