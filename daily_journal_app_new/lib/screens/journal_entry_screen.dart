import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/auth_provider.dart';
import '../providers/journal_provider.dart';
import '../models/journal_entry.dart';

class JournalEntryScreen extends StatefulWidget {
  const JournalEntryScreen({super.key});

  @override
  State<JournalEntryScreen> createState() => _JournalEntryScreenState();
}

class _JournalEntryScreenState extends State<JournalEntryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  EmotionType _selectedEmotion = EmotionType.neutral;
  final List<String> _tags = [];
  final _tagController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _tagController.dispose();
    super.dispose();
  }

  Future<void> _saveEntry() async {
    if (_formKey.currentState!.validate()) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final journalProvider = Provider.of<JournalProvider>(
        context,
        listen: false,
      );

      if (authProvider.user != null) {
        final success = await journalProvider.createEntry(
          userId: authProvider.user!.id,
          title: _titleController.text.trim(),
          content: _contentController.text.trim(),
          emotion: _selectedEmotion,
          tags: _tags,
        );

        if (success && mounted) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Journal entry saved successfully!',
                style: GoogleFonts.poppins(),
              ),
              backgroundColor: Colors.green,
            ),
          );
        }
      }
    }
  }

  void _addTag() {
    final tag = _tagController.text.trim();
    if (tag.isNotEmpty && !_tags.contains(tag)) {
      setState(() {
        _tags.add(tag);
        _tagController.clear();
      });
    }
  }

  void _removeTag(String tag) {
    setState(() {
      _tags.remove(tag);
    });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'New Journal Entry',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        actions: [
          Consumer<JournalProvider>(
            builder: (context, journalProvider, child) {
              return TextButton(
                onPressed: journalProvider.isLoading ? null : _saveEntry,
                child: journalProvider.isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(
                        'Save',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
              );
            },
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Emotion Selection
              _buildEmotionSection(),
              const SizedBox(height: 24),

              // Title Field
              _buildTitleField(),
              const SizedBox(height: 24),

              // Content Field
              _buildContentField(),
              const SizedBox(height: 24),

              // Tags Section
              _buildTagsSection(),
              const SizedBox(height: 24),

              // Word Count
              _buildWordCount(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmotionSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'How are you feeling?',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Column(
            children: [
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1,
                ),
                itemCount: EmotionType.values.length,
                itemBuilder: (context, index) {
                  final emotion = EmotionType.values[index];
                  final isSelected = emotion == _selectedEmotion;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedEmotion = emotion;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: isSelected
                            ? _getEmotionColor(emotion).withOpacity(0.2)
                            : Colors.grey[100],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected
                              ? _getEmotionColor(emotion)
                              : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _getEmotionEmoji(emotion),
                            style: const TextStyle(fontSize: 24),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _getEmotionName(emotion),
                            style: GoogleFonts.poppins(
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                              color: isSelected
                                  ? _getEmotionColor(emotion)
                                  : Colors.grey[600],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ).animate().scale(duration: 200.ms, curve: Curves.easeInOut);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTitleField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Title',
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _titleController,
          decoration: InputDecoration(
            hintText: 'Give your entry a title...',
            hintStyle: GoogleFonts.poppins(color: Colors.grey[400]),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.primary,
                width: 2,
              ),
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.all(16),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter a title';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildContentField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Your Thoughts',
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: TextFormField(
            controller: _contentController,
            maxLines: 8,
            decoration: InputDecoration(
              hintText: 'Write about your day, thoughts, feelings...',
              hintStyle: GoogleFonts.poppins(color: Colors.grey[400]),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(16),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please write something';
              }
              return null;
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTagsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tags (Optional)',
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _tagController,
                decoration: InputDecoration(
                  hintText: 'Add a tag...',
                  hintStyle: GoogleFonts.poppins(color: Colors.grey[400]),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.primary,
                      width: 2,
                    ),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.all(16),
                ),
                onFieldSubmitted: (_) => _addTag(),
              ),
            ),
            const SizedBox(width: 12),
            ElevatedButton(
              onPressed: _addTag,
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
              ),
              child: Text(
                'Add',
                style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
        if (_tags.isNotEmpty) ...[
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _tags.map((tag) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Theme.of(
                      context,
                    ).colorScheme.primary.withOpacity(0.3),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      tag,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: () => _removeTag(tag),
                      child: Icon(
                        Icons.close,
                        size: 16,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ],
    );
  }

  Widget _buildWordCount() {
    final wordCount = _contentController.text.split(' ').length;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Word Count',
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
          Text(
            '$wordCount words',
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}
