import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/achievement_model.dart';
import '../../viewmodels/achievement_viewmodel.dart';

class AchievementPage extends StatelessWidget {
  const AchievementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AchievementViewModel()..loadAchievementData(),
      child: const _AchievementView(),
    );
  }
}

class _AchievementView extends StatelessWidget {
  const _AchievementView();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<AchievementViewModel>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: viewModel.isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Color(0xFFED1E28),
              ),
            )
          : viewModel.errorMessage != null
              ? Center(
                  child: Text(viewModel.errorMessage!),
                )
              : Column(
                  children: [
                    _buildHeader(context, viewModel),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(28, 28, 28, 24),
                        child: viewModel.selectedTab == 0
                            ? _buildOwnershipContent(viewModel)
                            : _buildTrackContent(viewModel),
                      ),
                    ),
                  ],
                ),
    );
  }

  Widget _buildHeader(
    BuildContext context,
    AchievementViewModel viewModel,
  ) {
    final data = viewModel.achievementData!;
    final summary = data.summary;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(28, 70, 28, 28),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFED1E28),
            Color(0xFF8F1218),
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              InkWell(
                borderRadius: BorderRadius.circular(8),
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.white),
                  ),
                  child: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Achievement Status',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${summary.achieved} dari ${summary.totalAchievement} tercapai',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 40),
          _buildPointCard(summary),
          const SizedBox(height: 20),
          _buildTabSwitch(context, viewModel),
        ],
      ),
    );
  }

  Widget _buildPointCard(AchievementSummaryModel summary) {
    final percent = summary.progressPercent;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.22),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white, width: 1),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 62,
            height: 62,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 62,
                  height: 62,
                  child: CircularProgressIndicator(
                    value: percent,
                    strokeWidth: 9,
                    backgroundColor: Colors.white.withOpacity(0.85),
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Color(0xFFFF1020),
                    ),
                  ),
                ),
                Text(
                  '${(percent * 100).toInt()}%',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Total Poin Achievement',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${summary.currentPoint} / ${summary.targetPoint} Poin',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.95),
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: List.generate(summary.totalAchievement, (index) {
                    final bool active = index < summary.achieved;

                    return Expanded(
                      child: Container(
                        height: 4,
                        margin: const EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(
                          color: active
                              ? const Color(0xFFFF1020)
                              : Colors.white.withOpacity(0.85),
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabSwitch(
    BuildContext context,
    AchievementViewModel viewModel,
  ) {
    return Container(
      width: double.infinity,
      height: 48,
      padding: const EdgeInsets.all(7),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.22),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white, width: 1),
      ),
      child: Row(
        children: [
          _buildTabItem(
            context: context,
            viewModel: viewModel,
            index: 0,
            icon: Icons.emoji_events_outlined,
            title: 'Ownership card',
          ),
          const SizedBox(width: 8),
          _buildTabItem(
            context: context,
            viewModel: viewModel,
            index: 1,
            icon: Icons.fact_check_outlined,
            title: 'Track Achievement',
          ),
        ],
      ),
    );
  }

  Widget _buildTabItem({
    required BuildContext context,
    required AchievementViewModel viewModel,
    required int index,
    required IconData icon,
    required String title,
  }) {
    final bool isActive = viewModel.selectedTab == index;

    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () {
          context.read<AchievementViewModel>().changeTab(index);
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isActive ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 15,
                color: isActive ? const Color(0xFFED1E28) : Colors.white,
              ),
              const SizedBox(width: 5),
              Flexible(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: isActive ? const Color(0xFFED1E28) : Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOwnershipContent(AchievementViewModel viewModel) {
    final badges = viewModel.achievementData!.badges;

    if (badges.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF2F4),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: const Color(0xFFED1E28),
            width: 1,
          ),
        ),
        child: const Text(
          'Belum ada achievement yang diraih.',
          style: TextStyle(
            fontSize: 13,
            color: Colors.black87,
          ),
        ),
      );
    }

    return Column(
      children: badges.map((badge) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 24),
          child: _AchievementCard(badge: badge),
        );
      }).toList(),
    );
  }

  Widget _buildTrackContent(AchievementViewModel viewModel) {
    final tracks = viewModel.achievementData!.tracks;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 30),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF2F4),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: const Color(0xFFED1E28),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Track Progres Kamu',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 18),
          ...tracks.map((track) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 18),
              child: _TrackProgressItem(track: track),
            );
          }),
        ],
      ),
    );
  }
}

class _AchievementCard extends StatelessWidget {
  final AchievementBadgeModel badge;

  const _AchievementCard({
    required this.badge,
  });

  IconData _getIcon(String type) {
    switch (type) {
      case 'flash':
        return Icons.flash_on_rounded;
      case 'forum':
        return Icons.chat_bubble_outline_rounded;
      case 'badge':
      default:
        return Icons.badge_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF2F4),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: const Color(0xFFED1E28),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: const Color(0xFFED1E28),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Icon(
              _getIcon(badge.iconType),
              color: Colors.white,
              size: 26,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  badge.title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  badge.description,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  badge.achievedDate,
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.black.withOpacity(0.55),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Text(
                      'Progress',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.black87,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '${(badge.progress * 100).toInt()}%',
                      style: const TextStyle(
                        fontSize: 10,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: LinearProgressIndicator(
                    value: badge.progress,
                    minHeight: 8,
                    backgroundColor: Colors.white,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Color(0xFFED1E28),
                    ),
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

class _TrackProgressItem extends StatelessWidget {
  final AchievementTrackModel track;

  const _TrackProgressItem({
    required this.track,
  });

  IconData _getIcon(String type) {
    switch (type) {
      case 'forum':
        return Icons.chat_bubble_outline_rounded;
      case 'flash':
        return Icons.flash_on_rounded;
      case 'trophy':
      default:
        return Icons.emoji_events_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 54,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFED1E28),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  track.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  track.subtitle,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              _getIcon(track.iconType),
              color: const Color(0xFFED1E28),
              size: 20,
            ),
          ),
        ],
      ),
    );
  }
}
