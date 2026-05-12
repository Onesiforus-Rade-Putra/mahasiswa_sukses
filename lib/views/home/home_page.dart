import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:mahasiswa_sukses/models/history_model.dart';
import 'package:mahasiswa_sukses/models/task_model.dart';
import 'package:mahasiswa_sukses/viewmodels/home_viewmodel.dart';
import 'package:mahasiswa_sukses/views/achievement/achievement_page.dart';
import 'package:mahasiswa_sukses/views/profile/profile_page.dart';
import 'package:mahasiswa_sukses/views/target/target_page.dart';

class HomePage extends StatefulWidget {
  final ValueChanged<int>? onChangeTab;

  const HomePage({
    super.key,
    this.onChangeTab,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final HomeViewModel vm = HomeViewModel();

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

  void _goToTargetPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const TargetPage()),
    );
  }

  void _goToAchievementPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AchievementPage()),
    );
  }

  void _goToForum() {
    widget.onChangeTab?.call(1);
  }

  void _goToQuiz() {
    widget.onChangeTab?.call(2);
  }

  void _goToLeaderboard() {
    widget.onChangeTab?.call(3);
  }

  void _goToSetting() {
    widget.onChangeTab?.call(4);
  }

  void _goToProfilePage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ProfilePage()),
    );
  }

  String _shortName(String name) {
    final cleanName = name.trim();

    if (cleanName.isEmpty) return 'Mahasiswa';

    final parts = cleanName.split(' ');
    return parts.first;
  }

  String _formatXp(int value) {
    final text = value.toString();

    return text.replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
      (match) => '${match[1]},',
    );
  }

  String _priorityLabel(String priority) {
    switch (priority.toLowerCase()) {
      case 'tinggi':
      case 'high':
        return 'High';
      case 'sedang':
      case 'medium':
        return 'Medium';
      case 'rendah':
      case 'low':
        return 'Low';
      default:
        return priority.isEmpty ? 'Low' : priority;
    }
  }

  Color _priorityTextColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'tinggi':
      case 'high':
        return const Color(0xFFFF2338);
      case 'sedang':
      case 'medium':
        return const Color(0xFFFF7A1A);
      case 'rendah':
      case 'low':
        return const Color(0xFF18B95B);
      default:
        return const Color(0xFF18B95B);
    }
  }

  Color _priorityBgColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'tinggi':
      case 'high':
        return const Color(0xFFFFE9EC);
      case 'sedang':
      case 'medium':
        return const Color(0xFFFFE9D8);
      case 'rendah':
      case 'low':
        return const Color(0xFFE3FBEF);
      default:
        return const Color(0xFFE3FBEF);
    }
  }

  String _formatDeadline(String isoString) {
    final date = DateTime.tryParse(isoString)?.toLocal();

    if (date == null) return '';

    const days = [
      'Sen',
      'Sel',
      'Rab',
      'Kam',
      'Jum',
      'Sab',
      'Min',
    ];

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

    final dayName = days[date.weekday - 1];
    final monthName = months[date.month - 1];
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');

    return '$dayName, ${date.day} $monthName, $hour:$minute';
  }

  String _relativeTime(String isoString) {
    final date = DateTime.tryParse(isoString)?.toLocal();

    if (date == null) return '-';

    final diff = DateTime.now().difference(date);

    if (diff.inMinutes < 1) return 'Baru saja';
    if (diff.inMinutes < 60) return '${diff.inMinutes} menit lalu';
    if (diff.inHours < 24) return '${diff.inHours} jam lalu';
    if (diff.inDays < 7) return '${diff.inDays} hari lalu';

    return '${date.day}/${date.month}/${date.year}';
  }

  Widget _buildAvatar() {
    if (vm.avatarUrl.isEmpty || vm.token.isEmpty) {
      return _avatarPlaceholder();
    }

    return GestureDetector(
      onTap: _goToProfilePage,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.network(
          vm.avatarUrl,
          width: 48,
          height: 48,
          fit: BoxFit.cover,
          headers: {
            'Authorization': 'Bearer ${vm.token}',
          },
          errorBuilder: (_, __, ___) => _avatarPlaceholder(),
        ),
      ),
    );
  }

  Widget _avatarPlaceholder() {
    return GestureDetector(
      onTap: _goToProfilePage,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.white.withOpacity(0.38),
            width: 1,
          ),
        ),
        child: const Icon(
          Icons.person_outline_rounded,
          color: Colors.white,
          size: 25,
        ),
      ),
    );
  }

  Widget _statCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Expanded(
      child: Container(
        height: 109,
        padding: const EdgeInsets.fromLTRB(12, 14, 12, 13),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.14),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.white.withOpacity(0.12),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 33,
              height: 33,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.18),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: 18,
              ),
            ),
            const Spacer(),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w800,
                height: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final topPadding = MediaQuery.of(context).padding.top;

    return Container(
      height: 305,
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFED1E28),
            Color(0xFF9B0D17),
          ],
        ),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(20, topPadding + 50, 20, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Halo, ${_shortName(vm.greetingName)}!',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 7),
                      const Text(
                        'Siap Belajar Hari ini?',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          height: 1.1,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
                _buildAvatar(),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                _statCard(
                  icon: Icons.star_rounded,
                  title: 'Total XP',
                  value: _formatXp(vm.totalPoints),
                ),
                const SizedBox(width: 13),
                _statCard(
                  icon: Icons.leaderboard_rounded,
                  title: 'Rangking',
                  value: '#${vm.ranking}',
                ),
                const SizedBox(width: 13),
                _statCard(
                  icon: Icons.bolt_rounded,
                  title: 'Streak',
                  value: '${vm.streak} hari',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _questNumberBox({
    required int number,
    required bool isCompleted,
  }) {
    return Container(
      width: 39,
      height: 39,
      decoration: BoxDecoration(
        color: const Color(0xFFED0711),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: isCompleted
            ? const Icon(
                Icons.check_rounded,
                color: Colors.white,
                size: 22,
              )
            : Text(
                '$number',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
      ),
    );
  }

  Widget _buildDailyQuestCard() {
    final totalQuest = math.max(vm.totalQuestCount, 3);
    final completedQuest = vm.completedQuestCount;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(13),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.14),
            blurRadius: 18,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 33,
                height: 33,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFE9EC),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.calendar_today_rounded,
                  color: Color(0xFFED0711),
                  size: 16,
                ),
              ),
              const SizedBox(width: 10),
              const Text(
                'Quest Harian',
                style: TextStyle(
                  color: Color(0xFFED0711),
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            'Selesaikan $totalQuest Quest & Raih Bonus',
            style: const TextStyle(
              color: Color(0xFF171717),
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 13),
          Row(
            children: [
              _questNumberBox(
                number: 1,
                isCompleted: completedQuest >= 1,
              ),
              const SizedBox(width: 10),
              _questNumberBox(
                number: 2,
                isCompleted: completedQuest >= 2,
              ),
              const SizedBox(width: 10),
              _questNumberBox(
                number: 3,
                isCompleted: completedQuest >= 3,
              ),
              const Spacer(),
              SizedBox(
                width: 97,
                height: 39,
                child: ElevatedButton(
                  onPressed: _goToQuiz,
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: const Color(0xFFED0711),
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(11),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Mulai',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(width: 6),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 13,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeProgressCard() {
    final totalQuest = vm.totalQuestCount;
    final completedQuest = vm.completedQuestCount;
    final progress = vm.questProgress.clamp(0.0, 1.0);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 15, 16, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(13),
        border: Border.all(
          color: const Color(0xFFEDEDED),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Selamat Datang Kembali!',
            style: TextStyle(
              color: Color(0xFF171717),
              fontSize: 15,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Anda telah menyelesaikan $completedQuest dari $totalQuest quest hari ini.\nTetap semangat!',
            style: const TextStyle(
              color: Color(0xFF6B7280),
              fontSize: 13,
              height: 1.25,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(99),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 7,
              backgroundColor: const Color(0xFFD7D7D7),
              valueColor: const AlwaysStoppedAnimation(
                Color(0xFFFF4A16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 48,
            child: ElevatedButton.icon(
              onPressed: _goToQuiz,
              icon: const Icon(
                Icons.play_arrow_rounded,
                size: 20,
              ),
              label: const Text('Mulai Quiz'),
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: const Color(0xFFED0711),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                textStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 13),
        Expanded(
          child: SizedBox(
            height: 48,
            child: OutlinedButton.icon(
              onPressed: _goToTargetPage,
              icon: const Icon(
                Icons.add_rounded,
                size: 20,
              ),
              label: const Text('Tambah Target'),
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFFED0711),
                side: const BorderSide(
                  color: Color(0xFFED0711),
                  width: 1.5,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                textStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _featureItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        children: [
          Container(
            width: 55,
            height: 55,
            decoration: BoxDecoration(
              color: const Color(0xFFED0711),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.10),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 26,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            title,
            textAlign: TextAlign.center,
            maxLines: 2,
            style: const TextStyle(
              color: Color(0xFF374151),
              fontSize: 12.5,
              height: 1.15,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureGrid() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _featureItem(
          icon: Icons.emoji_events_rounded,
          title: 'Achievement',
          onTap: _goToAchievementPage,
        ),
        _featureItem(
          icon: Icons.track_changes_rounded,
          title: 'Target\n& Tugas',
          onTap: _goToTargetPage,
        ),
        _featureItem(
          icon: Icons.chat_bubble_rounded,
          title: 'Forum',
          onTap: _goToForum,
        ),
        _featureItem(
          icon: Icons.leaderboard_rounded,
          title: 'Leaderboard',
          onTap: _goToLeaderboard,
        ),
      ],
    );
  }

  Widget _taskIcon(TaskModel task) {
    final isCompleted = task.isCompleted;

    return Container(
      width: 43,
      height: 43,
      decoration: BoxDecoration(
        color: isCompleted ? const Color(0xFFE1F9EC) : const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(
        isCompleted ? Icons.check_rounded : Icons.circle_rounded,
        color: isCompleted ? const Color(0xFF22C55E) : const Color(0xFFB7BEC8),
        size: isCompleted ? 22 : 10,
      ),
    );
  }

  Widget _taskItem(TaskModel task) {
    final deadline = _formatDeadline(task.deadline);
    final category =
        task.category.trim().isEmpty ? 'Tugas Kuliah' : task.category;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 13),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(13),
        border: Border.all(
          color: const Color(0xFFEDEDED),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _taskIcon(task),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 1),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color(0xFF171717),
                      fontSize: 14.5,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    task.description.isEmpty ? '-' : task.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color(0xFF6B7280),
                      fontSize: 12.5,
                      height: 1.25,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        Icons.access_time_rounded,
                        color: Color(0xFFFF2338),
                        size: 14,
                      ),
                      const SizedBox(width: 4),
                      Flexible(
                        child: RichText(
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          text: TextSpan(
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                            children: [
                              TextSpan(
                                text: deadline,
                                style: const TextStyle(
                                  color: Color(0xFFFF2338),
                                ),
                              ),
                              TextSpan(
                                text:
                                    deadline.isEmpty ? category : ' $category',
                                style: const TextStyle(
                                  color: Color(0xFF8B8B8B),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 5,
            ),
            decoration: BoxDecoration(
              color: _priorityBgColor(task.priority),
              borderRadius: BorderRadius.circular(99),
            ),
            child: Text(
              _priorityLabel(task.priority),
              style: TextStyle(
                color: _priorityTextColor(task.priority),
                fontSize: 12,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveTasks() {
    final tasks = vm.activeTasks.take(3).toList();

    if (tasks.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(13),
          border: Border.all(
            color: const Color(0xFFEDEDED),
          ),
        ),
        child: const Text(
          'Belum ada target aktif.',
          style: TextStyle(
            color: Color(0xFF6B7280),
            fontSize: 13,
          ),
        ),
      );
    }

    return Column(
      children: tasks.map(_taskItem).toList(),
    );
  }

  Widget _historyItem(HistoryModel item, bool showDivider) {
    final xp = item.xpReward > 0 ? '+${item.xpReward} XP' : '0 XP';

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 13, 12, 13),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0xFF171717),
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      _relativeTime(item.completedAt),
                      style: const TextStyle(
                        color: Color(0xFF6B7280),
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                xp,
                style: const TextStyle(
                  color: Color(0xFF16A34A),
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
        if (showDivider)
          const Divider(
            height: 1,
            thickness: 1,
            color: Color(0xFFF1F1F1),
          ),
      ],
    );
  }

  Widget _buildLatestActivities() {
    final histories = vm.latestHistories.take(3).toList();

    if (histories.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(13),
          border: Border.all(
            color: const Color(0xFFEDEDED),
          ),
        ),
        child: const Text(
          'Belum ada aktivitas terbaru.',
          style: TextStyle(
            color: Color(0xFF6B7280),
            fontSize: 13,
          ),
        ),
      );
    }

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(13),
        border: Border.all(
          color: const Color(0xFFEDEDED),
          width: 1,
        ),
      ),
      child: Column(
        children: List.generate(histories.length, (index) {
          return _historyItem(
            histories[index],
            index != histories.length - 1,
          );
        }),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: Color(0xFF171717),
        fontSize: 17,
        fontWeight: FontWeight.w900,
      ),
    );
  }

  Widget _errorBox() {
    if (vm.errorMessage == null) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF1F2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFFFD7DC),
        ),
      ),
      child: Text(
        vm.errorMessage!,
        style: const TextStyle(
          color: Color(0xFFB42318),
          fontSize: 12.5,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _loadingBar() {
    if (!vm.isLoading) return const SizedBox.shrink();

    return const Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: LinearProgressIndicator(
        minHeight: 3,
        color: Color(0xFFED0711),
        backgroundColor: Color(0xFFFFE5E8),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: RefreshIndicator(
        onRefresh: vm.refresh,
        color: const Color(0xFFED0711),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              _buildHeader(),
              Transform.translate(
                offset: const Offset(0, -26),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 125),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDailyQuestCard(),
                      const SizedBox(height: 36),
                      _loadingBar(),
                      _errorBox(),
                      _buildWelcomeProgressCard(),
                      const SizedBox(height: 22),
                      _buildActionButtons(),
                      const SizedBox(height: 22),
                      _sectionTitle('Jelajahi Fitur'),
                      const SizedBox(height: 15),
                      _buildFeatureGrid(),
                      const SizedBox(height: 27),
                      _sectionTitle('Target Aktif'),
                      const SizedBox(height: 14),
                      _buildActiveTasks(),
                      const SizedBox(height: 15),
                      _sectionTitle('Aktivitas Terbaru'),
                      const SizedBox(height: 14),
                      _buildLatestActivities(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
