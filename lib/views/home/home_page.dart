import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:mahasiswa_sukses/models/history_model.dart';
import 'package:mahasiswa_sukses/models/task_model.dart';
import 'package:mahasiswa_sukses/viewmodels/home_viewmodel.dart';
import 'package:mahasiswa_sukses/views/target/target_page.dart';
import 'package:mahasiswa_sukses/views/widgets/custom_bottom_navbar.dart';
import 'package:mahasiswa_sukses/views/widgets/header_background.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final HomeViewModel vm = HomeViewModel();
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    vm.addListener(_onVmUpdated);
    vm.loadHomeData();
  }

  @override
  void dispose() {
    vm.removeListener(_onVmUpdated);
    vm.dispose();
    super.dispose();
  }

  void _onVmUpdated() {
    if (mounted) setState(() {});
  }

  void _goToTargetPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const TargetPage()),
    );
  }

  Widget statCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Expanded(
      child: Container(
        height: 90,
        margin: const EdgeInsets.symmetric(horizontal: 6),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.14),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.white.withOpacity(0.35),
            width: 1.2,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: const Color(0xFFFF6A6A),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: Colors.white, size: 15),
            ),
            const Spacer(),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget featureCard({
    required IconData icon,
    required String title,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 54,
          height: 54,
          decoration: BoxDecoration(
            color: const Color(0xFFFF2020),
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                color: Color(0x1A000000),
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Icon(icon, color: Colors.white, size: 24),
        ),
        const SizedBox(height: 10),
        Text(
          title,
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 11.5,
            height: 1.3,
            fontWeight: FontWeight.w500,
            color: Color(0xFF1E1E1E),
          ),
        ),
      ],
    );
  }

  Widget targetCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required String status,
    required Color statusColor,
    required Color statusBg,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F7F7),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE9E9E9)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: const Color(0xFF9B9B9B), size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF222222),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 9,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: statusBg,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        status,
                        style: TextStyle(
                          color: statusColor,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 11,
                    height: 1.4,
                    color: Color(0xFF7A7A7A),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget activityItem({
    required String title,
    required String time,
    required String xp,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF222222),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  time,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF8B8B8B),
                  ),
                ),
              ],
            ),
          ),
          Text(
            xp,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: Color(0xFF22B25F),
            ),
          ),
        ],
      ),
    );
  }

  Color _priorityTextColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'tinggi':
        return const Color(0xFFFF4D4F);
      case 'sedang':
        return const Color(0xFFFF9F1A);
      case 'rendah':
        return const Color(0xFF22B25F);
      default:
        return const Color(0xFF7A7A7A);
    }
  }

  Color _priorityBgColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'tinggi':
        return const Color(0xFFFFE5E5);
      case 'sedang':
        return const Color(0xFFFFF1D9);
      case 'rendah':
        return const Color(0xFFE4F8EC);
      default:
        return const Color(0xFFF1F1F1);
    }
  }

  String _priorityLabel(String priority) {
    switch (priority.toLowerCase()) {
      case 'tinggi':
        return 'High';
      case 'sedang':
        return 'Medium';
      case 'rendah':
        return 'Low';
      default:
        return priority;
    }
  }

  String _relativeTime(String isoString) {
    final date = DateTime.tryParse(isoString)?.toLocal();
    if (date == null) return '-';
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inMinutes < 1) return 'Baru saja';
    if (difference.inMinutes < 60) return '${difference.inMinutes} menit lalu';
    if (difference.inHours < 24) return '${difference.inHours} jam lalu';
    if (difference.inDays < 7) return '${difference.inDays} hari lalu';
    return '${date.day}/${date.month}/${date.year}';
  }

  String _formatDeadline(String isoString) {
    final date = DateTime.tryParse(isoString)?.toLocal();
    if (date == null) return '';
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'Mei',
      'Jun',
      'Jul',
      'Agu',
      'Sep',
      'Okt',
      'Nov',
      'Des',
    ];

    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');
    return '${date.day} ${months[date.month - 1]} ${date.year}, $hour:$minute';
  }

  Widget _buildAvatar() {
    if (vm.avatarUrl == null || vm.token == null) {
      return _avatarPlaceholder();
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: Image.network(
        vm.avatarUrl!,
        width: 48,
        height: 48,
        fit: BoxFit.cover,
        headers: {'Authorization': 'Bearer ${vm.token!}'},
        errorBuilder: (_, __, ___) => _avatarPlaceholder(),
      ),
    );
  }

  Widget _avatarPlaceholder() {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white.withOpacity(0.55), width: 2),
        borderRadius: BorderRadius.circular(14),
      ),
      child: const Icon(
        Icons.person_outline,
        color: Colors.white,
        size: 24,
      ),
    );
  }

  Widget _buildQuestBoxes() {
    final displayedCount = math.max(
        3, math.min(3, vm.totalQuestCount == 0 ? 3 : vm.totalQuestCount));
    final displayedQuests = vm.quests.take(displayedCount).toList();

    return Row(
      children: [
        ...List.generate(displayedCount, (index) {
          final isCompleted = index < displayedQuests.length
              ? displayedQuests[index].isCompleted
              : index < vm.completedQuestCount;

          return Container(
            width: 34,
            height: 34,
            margin: const EdgeInsets.only(right: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFFF2D2D),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: isCompleted
                  ? const Icon(Icons.check, size: 18, color: Colors.white)
                  : Text(
                      '${index + 1}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
            ),
          );
        }),
        const Spacer(),
        SizedBox(
          height: 48,
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              elevation: 0,
              backgroundColor: const Color(0xFFFF2D2D),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 22),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: const Row(
              children: [
                Text(
                  'Mulai',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                ),
                SizedBox(width: 8),
                Icon(Icons.arrow_forward_ios, size: 14),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActiveTasks() {
    final tasks = vm.activeTasks.take(3).toList();
    if (tasks.isEmpty) {
      return const Padding(
        padding: EdgeInsets.only(bottom: 8),
        child: Text(
          'Belum ada target aktif.',
          style: TextStyle(fontSize: 12, color: Color(0xFF7A7A7A)),
        ),
      );
    }

    return Column(
      children: tasks.map((task) => _taskItem(task)).toList(),
    );
  }

  Widget _taskItem(TaskModel task) {
    final extra = _formatDeadline(task.date);
    final subtitle = task.description.trim().isEmpty
        ? (extra.isEmpty ? '-' : extra)
        : (extra.isEmpty ? task.description : '${task.description}\n$extra');

    return targetCard(
      icon: task.isCompleted ? Icons.check : Icons.circle_outlined,
      title: task.title,
      subtitle: subtitle,
      status: _priorityLabel(task.priority),
      statusColor: _priorityTextColor(task.priority),
      statusBg: _priorityBgColor(task.priority),
    );
  }

  Widget _buildHistories() {
    final items = vm.latestHistories.take(3).toList();
    if (items.isEmpty) {
      return const Padding(
        padding: EdgeInsets.only(bottom: 8),
        child: Text(
          'Belum ada aktivitas terbaru.',
          style: TextStyle(fontSize: 12, color: Color(0xFF7A7A7A)),
        ),
      );
    }

    return Column(
      children: items.map((item) => _historyItem(item)).toList(),
    );
  }

  Widget _historyItem(HistoryModel item) {
    final xp = item.xpReward > 0 ? '+${item.xpReward} XP' : '0 XP';
    return activityItem(
      title: item.title,
      time: _relativeTime(item.completedAt),
      xp: xp,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: const Color(0xFFF4F4F4),
      body: SafeArea(
        bottom: false,
        child: vm.isLoading
            ? const Center(child: CircularProgressIndicator())
            : RefreshIndicator(
                onRefresh: vm.refresh,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.zero,
                  child: Column(
                    children: [
                      HeaderBackground(
                        height: 250,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(16, 18, 16, 18),
                          child: Column(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 6),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Halo, ${vm.greetingName}!',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                          const Text(
                                            'Siap Belajar Hari ini?',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20,
                                              height: 1.15,
                                              fontWeight: FontWeight.w800,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Stack(
                                    clipBehavior: Clip.none,
                                    children: [
                                      _buildAvatar(),
                                      Positioned(
                                        top: -2,
                                        right: -2,
                                        child: Container(
                                          width: 16,
                                          height: 16,
                                          decoration: const BoxDecoration(
                                            color: Colors.white,
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Center(
                                            child: Icon(
                                              Icons.bolt,
                                              size: 10,
                                              color: Color(0xFFFF1F2D),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  statCard(
                                    icon: Icons.star,
                                    title: 'Total Poin',
                                    value: vm.summary.totalXpEarned.toString(),
                                  ),
                                  statCard(
                                    icon: Icons.emoji_events_outlined,
                                    title: 'Rangking',
                                    value: '#${vm.summary.currentRanking}',
                                  ),
                                  statCard(
                                    icon: Icons.bolt,
                                    title: 'Streak',
                                    value: '${vm.summary.currentStreak} hari',
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 120),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Transform.translate(
                              offset: const Offset(0, -40),
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(18),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Color(0x14000000),
                                      blurRadius: 10,
                                      offset: Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Row(
                                      children: [
                                        Icon(
                                          Icons.card_giftcard,
                                          color: Color(0xFFFF3B30),
                                          size: 18,
                                        ),
                                        SizedBox(width: 8),
                                        Text(
                                          'Quest Harian',
                                          style: TextStyle(
                                            color: Color(0xFFFF3B30),
                                            fontSize: 13,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 14),
                                    Text(
                                      'Selesaikan ${math.max(3, vm.totalQuestCount)} Quest & Raih Bonus',
                                      style: const TextStyle(
                                        fontSize: 14.5,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xFF252525),
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    _buildQuestBoxes(),
                                  ],
                                ),
                              ),
                            ),
                            Transform.translate(
                              offset: const Offset(0, -20),
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(18),
                                  border: Border.all(
                                    color: const Color(0xFFEAEAEA),
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Selamat Datang Kembali!',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Anda sudah menyelesaikan ${vm.completedQuestCount} dari ${vm.totalQuestCount} quest hari ini.\nTetap semangat!',
                                      style: const TextStyle(
                                        fontSize: 11.5,
                                        height: 1.4,
                                        color: Color(0xFF7D7D7D),
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: LinearProgressIndicator(
                                        value: vm.questProgress,
                                        minHeight: 8,
                                        backgroundColor:
                                            const Color(0xFFE2E2E2),
                                        valueColor:
                                            const AlwaysStoppedAnimation(
                                          Color(0xFFFF2D2D),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            if (vm.errorMessage != null) ...[
                              Container(
                                width: double.infinity,
                                margin: const EdgeInsets.only(bottom: 16),
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFFF3F3),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                      color: const Color(0xFFFFD7D7)),
                                ),
                                child: Text(
                                  vm.errorMessage!,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFFB42318),
                                  ),
                                ),
                              ),
                            ],
                            Row(
                              children: [
                                Expanded(
                                  child: SizedBox(
                                    height: 52,
                                    child: ElevatedButton(
                                      onPressed: () {},
                                      style: ElevatedButton.styleFrom(
                                        elevation: 0,
                                        backgroundColor:
                                            const Color(0xFFFF2020),
                                        foregroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(16),
                                        ),
                                      ),
                                      child: const Text(
                                        'Mulai Quiz',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: SizedBox(
                                    height: 52,
                                    child: OutlinedButton(
                                      onPressed: () => _goToTargetPage(context),
                                      style: OutlinedButton.styleFrom(
                                        foregroundColor:
                                            const Color(0xFFFF2020),
                                        side: const BorderSide(
                                          color: Color(0xFFFF2020),
                                          width: 1.4,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(16),
                                        ),
                                      ),
                                      child: const Text(
                                        'Tambah Target',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 28),
                            const Text(
                              'Jelajahi Fitur',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF1E1E1E),
                              ),
                            ),
                            const SizedBox(height: 14),
                            GridView.count(
                              crossAxisCount: 4,
                              crossAxisSpacing: 14,
                              mainAxisSpacing: 14,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              childAspectRatio: 0.70,
                              children: [
                                featureCard(
                                  icon: Icons.emoji_events_outlined,
                                  title: 'Achievement',
                                ),
                                GestureDetector(
                                  onTap: () => _goToTargetPage(context),
                                  child: featureCard(
                                    icon: Icons.track_changes,
                                    title: 'Target\n& Tugas',
                                  ),
                                ),
                                featureCard(
                                  icon: Icons.forum_outlined,
                                  title: 'Forum',
                                ),
                                featureCard(
                                  icon: Icons.person_outline,
                                  title: 'Leaderboard',
                                ),
                              ],
                            ),
                            const SizedBox(height: 26),
                            const Text(
                              'Target Aktif',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF1E1E1E),
                              ),
                            ),
                            const SizedBox(height: 14),
                            _buildActiveTasks(),
                            const SizedBox(height: 10),
                            const Text(
                              'Aktivitas Terbaru',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF1E1E1E),
                              ),
                            ),
                            const SizedBox(height: 14),
                            _buildHistories(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
