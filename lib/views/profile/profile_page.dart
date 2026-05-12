import 'package:flutter/material.dart';
import 'package:mahasiswa_sukses/views/profile/edit_profile_page.dart';

import '../../models/achievement_model.dart';
import '../../models/friend_model.dart';
import '../../viewmodels/profile_viewmodel.dart';
import '../achievement/achievement_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ProfileViewModel vm = ProfileViewModel();

  static const Color primaryRed = Color(0xFFED0711);
  static const Color darkRed = Color(0xFF9B0D17);
  static const Color pageBg = Color(0xFFF4F5F7);
  static const Color textDark = Color(0xFF111827);
  static const Color textGrey = Color(0xFF6B7280);

  @override
  void initState() {
    super.initState();
    vm.addListener(_onVmChanged);
    vm.loadProfilePage();
  }

  void _onVmChanged() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    vm.removeListener(_onVmChanged);
    vm.dispose();
    super.dispose();
  }

  String _formatNumber(int value) {
    return value.toString();
  }

  String _percentText(double value) {
    return '${(value * 100).round()}%';
  }

  Future<void> _showAddFriendDialog() async {
    final controller = TextEditingController();

    bool isSending = false;
    String? errorText;

    final success = await showDialog<bool>(
      context: context,
      barrierDismissible: !isSending,
      barrierColor: Colors.black.withOpacity(0.25),
      useRootNavigator: true,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            Future<void> submitFriendRequest() async {
              final username = controller.text.trim();

              setDialogState(() {
                errorText = null;
              });

              if (username.isEmpty) {
                setDialogState(() {
                  errorText = 'Username wajib diisi';
                });
                return;
              }

              if (username.length < 3) {
                setDialogState(() {
                  errorText = 'Username minimal 3 karakter';
                });
                return;
              }

              setDialogState(() {
                isSending = true;
              });

              final error = await vm.sendFriendRequestForDialog(username);

              if (!dialogContext.mounted) return;

              if (error != null) {
                setDialogState(() {
                  isSending = false;
                  errorText = error;
                });
                return;
              }

              Navigator.of(dialogContext, rootNavigator: true).pop(true);
            }

            return Dialog(
              insetPadding: const EdgeInsets.symmetric(horizontal: 20),
              backgroundColor: Colors.transparent,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Expanded(
                          child: Text(
                            'Tambah Teman Baru',
                            style: TextStyle(
                              color: Color(0xFF111827),
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: isSending
                              ? null
                              : () {
                                  Navigator.of(
                                    dialogContext,
                                    rootNavigator: true,
                                  ).pop(false);
                                },
                          child: const Icon(
                            Icons.close_rounded,
                            size: 22,
                            color: Color(0xFF111827),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 17),
                    const Text(
                      'Username',
                      style: TextStyle(
                        color: Color(0xFF6B7280),
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 29,
                      child: TextField(
                        controller: controller,
                        enabled: !isSending,
                        textInputAction: TextInputAction.done,
                        onSubmitted: (_) {
                          if (!isSending) {
                            submitFriendRequest();
                          }
                        },
                        decoration: InputDecoration(
                          hintText: 'Masukkan Username',
                          hintStyle: const TextStyle(
                            color: Color(0xFF6B7280),
                            fontSize: 12,
                          ),
                          filled: true,
                          fillColor: const Color(0xFFE5E7EB),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 0,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(3),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                    if (errorText != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        errorText!,
                        style: const TextStyle(
                          color: Color(0xFFED0711),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                    const SizedBox(height: 14),
                    SizedBox(
                      width: double.infinity,
                      height: 40,
                      child: ElevatedButton(
                        onPressed: isSending ? null : submitFriendRequest,
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: primaryRed,
                          disabledBackgroundColor: primaryRed.withOpacity(0.65),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        child: isSending
                            ? const SizedBox(
                                width: 17,
                                height: 17,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Text(
                                'Kirim Friend Request',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );

    controller.dispose();

    if (!mounted) return;

    if (success == true) {
      await vm.reloadFriendSection();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Friend request berhasil dikirim'),
        ),
      );
    }
  }

  Widget _buildHeader() {
    final topPadding = MediaQuery.of(context).padding.top;

    return Container(
      height: 365,
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(20, topPadding + 26, 20, 0),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFED1E28),
            Color(0xFF9B0D17),
          ],
        ),
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(30),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Halo, Mahasiswa!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: 7),
                  Text(
                    'Profile Kamu',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 23,
                      height: 1.1,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.18),
              borderRadius: BorderRadius.circular(13),
            ),
            child: const Icon(
              Icons.person_outline_rounded,
              color: Colors.white,
              size: 25,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileCard() {
    return Container(
      width: double.infinity,
      height: 168,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(13),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.10),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFFFF2D4D),
                      Color(0xFFED0711),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(13),
                  boxShadow: [
                    BoxShadow(
                      color: primaryRed.withOpacity(0.26),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: const Center(
                  child: Text(
                    'JD',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  vm.username,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: textDark,
                    fontSize: 21,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(9),
                ),
                child: IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: vm.profile == null
                      ? null
                      : () async {
                          final result = await Navigator.push<bool>(
                            context,
                            MaterialPageRoute(
                              builder: (_) => EditProfilePage(
                                profile: vm.profile!,
                              ),
                            ),
                          );

                          if (result == true) {
                            await vm.refresh();
                          }
                        },
                  icon: const Icon(
                    Icons.edit_outlined,
                    size: 19,
                    color: Color(0xFF4B5563),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 17),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              vm.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: textGrey,
                fontSize: 14,
                height: 1.45,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _statCard({
    required IconData icon,
    required Color iconBg,
    required String title,
    required String value,
  }) {
    return Expanded(
      child: Container(
        height: 121,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(13),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.12),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: 23,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(
                color: textGrey,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              value,
              style: const TextStyle(
                color: textDark,
                fontSize: 20,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStats() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          _statCard(
            icon: Icons.star_border_rounded,
            iconBg: primaryRed,
            title: 'Level',
            value: _formatNumber(vm.level),
          ),
          const SizedBox(width: 13),
          _statCard(
            icon: Icons.bolt_rounded,
            iconBg: const Color(0xFFFF6A00),
            title: 'Total XP',
            value: _formatNumber(vm.totalXp),
          ),
          const SizedBox(width: 13),
          _statCard(
            icon: Icons.people_alt_outlined,
            iconBg: const Color(0xFF2F80ED),
            title: 'Teman',
            value: _formatNumber(vm.friendCount),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressCard() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(13),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Progress ke Level ${vm.nextLevel}',
                  style: const TextStyle(
                    color: textDark,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Text(
                '${vm.totalXp}/${vm.nextLevelTarget} XP',
                style: const TextStyle(
                  color: primaryRed,
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(99),
            child: LinearProgressIndicator(
              value: vm.levelProgress,
              minHeight: 10,
              backgroundColor: const Color(0xFFE5E7EB),
              valueColor: const AlwaysStoppedAnimation(
                Color(0xFFFF4A16),
              ),
            ),
          ),
          const SizedBox(height: 9),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              '${vm.remainingXp} XP lagi untuk naik level',
              style: const TextStyle(
                color: textGrey,
                fontSize: 12.5,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle({
    required String title,
    String? actionText,
    VoidCallback? onAction,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: textDark,
                fontSize: 18,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          if (actionText != null)
            GestureDetector(
              onTap: onAction,
              child: Text(
                actionText,
                style: const TextStyle(
                  color: primaryRed,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildAchievementSummary() {
    return Container(
      width: double.infinity,
      height: 108,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(13),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: RichText(
              text: TextSpan(
                style: const TextStyle(
                  color: textGrey,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
                children: [
                  const TextSpan(text: 'Total Achievement\n'),
                  TextSpan(
                    text: '${vm.achievedCount}',
                    style: const TextStyle(
                      color: textDark,
                      fontSize: 26,
                      fontWeight: FontWeight.w900,
                      height: 1.6,
                    ),
                  ),
                  TextSpan(
                    text: '/${vm.totalAchievement}',
                    style: const TextStyle(
                      color: Color(0xFF9CA3AF),
                      fontSize: 26,
                      fontWeight: FontWeight.w900,
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: primaryRed,
                width: 4,
              ),
            ),
            child: Center(
              child: Text(
                _percentText(vm.achievementProgress),
                style: const TextStyle(
                  color: primaryRed,
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _achievementEmoji(AchievementBadgeModel badge) {
    switch (badge.iconType) {
      case 'forum':
        return '💬';
      case 'flash':
        return '⚡';
      case 'trophy':
        return '🏆';
      case 'badge':
      default:
        return '🎯';
    }
  }

  Widget _buildAchievementGrid() {
    final badges = vm.achievementData?.badges ?? [];

    final emojis = badges.isNotEmpty
        ? badges.take(8).map(_achievementEmoji).toList()
        : ['🎯', '💬', '⭐', '🏆', '🌟', '⚡', '📚', '💎'];

    while (emojis.length < 8) {
      emojis.add('⭐');
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: emojis.take(8).map((emoji) {
          return Container(
            width: 78,
            height: 58,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(11),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 9,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: Text(
                emoji,
                style: const TextStyle(fontSize: 24),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _avatarBox(FriendModel friend, {required Color bgColor}) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(
              friend.avatarText,
              style: const TextStyle(
                color: textDark,
                fontSize: 17,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
        if (friend.onlineStatus)
          Positioned(
            right: -2,
            bottom: -2,
            child: Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: const Color(0xFF22C55E),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildRequestItem(FriendModel friend) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 10),
      padding: const EdgeInsets.fromLTRB(12, 11, 12, 11),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(13),
        border: Border.all(
          color: const Color(0xFFFFD6B8),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              _avatarBox(friend, bgColor: const Color(0xFFFFE7B8)),
              Positioned(
                right: -5,
                top: -5,
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: const BoxDecoration(
                    color: primaryRed,
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Text(
                      '!',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _friendInfo(friend),
          ),
          _circleActionButton(
            icon: Icons.check_rounded,
            color: const Color(0xFF16C758),
            onTap: vm.isActionLoading ? null : () => vm.acceptFriend(friend.id),
          ),
          const SizedBox(width: 8),
          _circleActionButton(
            icon: Icons.close_rounded,
            color: const Color(0xFFFF3946),
            onTap: vm.isActionLoading ? null : () => vm.denyFriend(friend.id),
          ),
        ],
      ),
    );
  }

  Widget _friendInfo(FriendModel friend) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          friend.displayName,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: textDark,
            fontSize: 14,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 5),
        RichText(
          text: TextSpan(
            style: const TextStyle(
              color: textGrey,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
            children: [
              TextSpan(text: 'Lv ${friend.level}'),
              const TextSpan(text: '   •   '),
              TextSpan(
                text: '${friend.totalXp} XP',
                style: const TextStyle(
                  color: Color(0xFFFF3B1F),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _circleActionButton({
    required IconData icon,
    required Color color,
    required VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          icon,
          color: Colors.white,
          size: 19,
        ),
      ),
    );
  }

  Widget _buildFriendItem(FriendModel friend) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 10),
      padding: const EdgeInsets.fromLTRB(12, 11, 12, 11),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(13),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 9,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          _avatarBox(friend, bgColor: const Color(0xFFF0F1F4)),
          const SizedBox(width: 12),
          Expanded(
            child: _friendInfo(friend),
          ),
          GestureDetector(
            onTap: vm.isActionLoading ? null : () => vm.removeFriend(friend.id),
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: const Color(0xFFFFF1F2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.delete_outline_rounded,
                color: Color(0xFFFF3946),
                size: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _emptyBox(String text) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(13),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: textGrey,
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildErrorBox() {
    if (vm.errorMessage == null) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 14),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF1F2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFFFD7DC)),
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

  Widget _buildContent() {
    if (vm.isLoading) {
      return const Padding(
        padding: EdgeInsets.only(top: 420),
        child: Center(
          child: CircularProgressIndicator(
            color: primaryRed,
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildProfileCard(),
        const SizedBox(height: 47),
        _buildStats(),
        const SizedBox(height: 22),
        _buildErrorBox(),
        _buildProgressCard(),
        const SizedBox(height: 25),
        _sectionTitle(
          title: 'Achievement Terbaru',
          actionText: 'Lihat Semua  →',
          onAction: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AchievementPage()),
            );
          },
        ),
        const SizedBox(height: 14),
        _buildAchievementSummary(),
        const SizedBox(height: 14),
        _buildAchievementGrid(),
        const SizedBox(height: 24),
        _sectionTitle(
          title: 'Friend Request (${vm.friendRequestCount})',
        ),
        const SizedBox(height: 14),
        if (vm.friendRequests.isEmpty)
          _emptyBox('Belum ada friend request.')
        else
          ...vm.friendRequests.map(_buildRequestItem),
        const SizedBox(height: 18),
        _sectionTitle(
          title: 'Teman (${vm.friendCount})',
          actionText: '⚭ Tambah',
          onAction: _showAddFriendDialog,
        ),
        const SizedBox(height: 14),
        if (vm.friends.isEmpty)
          _emptyBox('Belum ada teman.')
        else
          ...vm.friends.take(5).map(_buildFriendItem),
        const SizedBox(height: 90),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: pageBg,
      body: RefreshIndicator(
        onRefresh: vm.refresh,
        color: primaryRed,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Stack(
            children: [
              _buildHeader(),
              Padding(
                padding: const EdgeInsets.only(top: 138),
                child: _buildContent(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
