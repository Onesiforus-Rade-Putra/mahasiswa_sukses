import 'package:flutter/material.dart';

import '../../models/quest_model.dart';

class QuestCard extends StatelessWidget {
  final QuestModel quest;

  const QuestCard({
    super.key,
    required this.quest,
  });

  Color get difficultyColor {
    switch (quest.difficulty.toLowerCase()) {
      case 'hard':
        return const Color(0xFFFFD5DB);
      case 'medium':
        return const Color(0xFFFFE5B8);
      default:
        return const Color(0xFFB6FFC8);
    }
  }

  Color get difficultyTextColor {
    switch (quest.difficulty.toLowerCase()) {
      case 'hard':
        return const Color(0xFFFF4C67);
      case 'medium':
        return const Color(0xFFFFA000);
      default:
        return const Color(0xFF16C34A);
    }
  }

  String get difficultyLabel {
    final value = quest.difficulty.toLowerCase();

    if (value == 'hard') return 'Hard';
    if (value == 'medium') return 'Medium';
    return 'easy';
  }

  @override
  Widget build(BuildContext context) {
    final progress = (quest.progressPercentage / 100).clamp(0.0, 1.0);
    final showProgress = quest.progressPercentage > 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: const Color(0xFFED1E28),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _CheckBox(isCompleted: quest.isCompleted),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            quest.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Color(0xFF1E1E1E),
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        _DifficultyBadge(
                          label: difficultyLabel,
                          backgroundColor: difficultyColor,
                          textColor: difficultyTextColor,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      quest.description,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0xFF777777),
                        fontSize: 10,
                        height: 1.2,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (showProgress) ...[
            const SizedBox(height: 13),
            Padding(
              padding: const EdgeInsets.only(left: 44),
              child: Row(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 7,
                        backgroundColor:
                            const Color(0xFFED1E28).withValues(alpha: 0.25),
                        valueColor: const AlwaysStoppedAnimation(
                          Color(0xFFED1E28),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    '${quest.progressPercentage}%',
                    style: const TextStyle(
                      color: Color(0xFF1E88FF),
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(left: 44),
            child: Row(
              children: [
                const Icon(
                  Icons.star,
                  color: Color(0xFFFFA000),
                  size: 12,
                ),
                const SizedBox(width: 5),
                Text(
                  '+${quest.xpReward} XP',
                  style: const TextStyle(
                    color: Color(0xFFFFA000),
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CheckBox extends StatelessWidget {
  final bool isCompleted;

  const _CheckBox({
    required this.isCompleted,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: isCompleted ? const Color(0xFF04C46B) : Colors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color:
              isCompleted ? const Color(0xFF04C46B) : const Color(0xFFED1E28),
          width: 1,
        ),
      ),
      child: isCompleted
          ? const Icon(
              Icons.check,
              color: Colors.white,
              size: 17,
            )
          : null,
    );
  }
}

class _DifficultyBadge extends StatelessWidget {
  final String label;
  final Color backgroundColor;
  final Color textColor;

  const _DifficultyBadge({
    required this.label,
    required this.backgroundColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(
        minWidth: 60,
      ),
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: textColor,
          fontSize: 9,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
