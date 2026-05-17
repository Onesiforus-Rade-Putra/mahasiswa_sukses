import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/leaderboard_model.dart';
import '../../viewmodels/leaderboard_viewmodel.dart';

class LeaderboardPage extends StatelessWidget {
  const LeaderboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LeaderboardViewModel()..loadLeaderboard(),
      child: const _LeaderboardView(),
    );
  }
}

class _LeaderboardView extends StatelessWidget {
  const _LeaderboardView();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<LeaderboardViewModel>();
    final isFriendTab = viewModel.selectedTab == LeaderboardTab.teman;

    const double headerHeight = 220;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F4),
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                height: headerHeight,
                width: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFFED1E28),
                      Color(0xFF871117),
                    ],
                  ),
                ),
              ),
              const Expanded(
                child: ColoredBox(
                  color: Color(0xFFF4F4F4),
                ),
              ),
            ],
          ),

          // HEADER FIXED / TIDAK IKUT SCROLL
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(28, 48, 28, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _HeaderTitle(
                    isFriendTab: isFriendTab,
                    onBackTap: () {
                      viewModel.changeTab(LeaderboardTab.top50);
                    },
                  ),
                  const SizedBox(height: 34),
                  _LeaderboardTabs(viewModel: viewModel),
                ],
              ),
            ),
          ),

          Positioned.fill(
            top: headerHeight,
            child: viewModel.isLoading
                ? const _LeaderboardLoadingView()
                : viewModel.errorMessage != null
                    ? _LeaderboardErrorView(
                        message: viewModel.errorMessage!,
                        onRetry: () {
                          context
                              .read<LeaderboardViewModel>()
                              .loadLeaderboard();
                        },
                      )
                    : SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(24, 20, 24, 100),
                        child: Column(
                          children: [
                            if (viewModel.hasEnoughTopPerformers)
                              _TopPerformersCard(
                                performers: viewModel.currentTopPerformers,
                              )
                            else
                              const _LeaderboardEmptyCard(
                                title: 'Belum Ada Top Performers',
                                message:
                                    'Data peringkat belum cukup untuk menampilkan podium.',
                              ),
                            const SizedBox(height: 18),
                            if (viewModel.hasLeaderboardData)
                              ...viewModel.currentLeaderboardList.map(
                                (item) => Padding(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: _RankingItemCard(item: item),
                                ),
                              )
                            else
                              const _LeaderboardEmptyCard(
                                title: 'Belum Ada Data',
                                message:
                                    'Leaderboard masih kosong untuk kategori ini.',
                              ),
                          ],
                        ),
                      ),
          ),
        ],
      ),
    );
  }
}

class _HeaderTitle extends StatelessWidget {
  final bool isFriendTab;
  final VoidCallback onBackTap;

  const _HeaderTitle({
    required this.isFriendTab,
    required this.onBackTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (isFriendTab) ...[
          InkWell(
            onTap: onBackTap,
            borderRadius: BorderRadius.circular(7),
            child: Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.white,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(7),
              ),
              child: const Icon(
                Icons.arrow_back_rounded,
                color: Colors.white,
                size: 16,
              ),
            ),
          ),
          const SizedBox(width: 12),
        ],
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Leaderboard',
              style: TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(
                  Icons.trending_up_rounded,
                  color: Colors.white,
                  size: 11,
                ),
                const SizedBox(width: 5),
                Text(
                  isFriendTab ? 'Peringkat Teman' : 'Peringkat Kampus',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

class _LeaderboardTabs extends StatelessWidget {
  final LeaderboardViewModel viewModel;

  const _LeaderboardTabs({
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      padding: const EdgeInsets.all(7),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.22),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colors.white,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: _TabButton(
              title: 'Top 50',
              icon: Icons.emoji_events_outlined,
              isActive: viewModel.selectedTab == LeaderboardTab.top50,
              onTap: () => viewModel.changeTab(LeaderboardTab.top50),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _TabButton(
              title: 'Teman',
              icon: Icons.people_alt_outlined,
              isActive: viewModel.selectedTab == LeaderboardTab.teman,
              onTap: () => viewModel.changeTab(LeaderboardTab.teman),
            ),
          ),
        ],
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool isActive;
  final VoidCallback onTap;

  const _TabButton({
    required this.title,
    required this.icon,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final activeColor = const Color(0xFFED1E28);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isActive ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 13,
              color: isActive ? activeColor : Colors.white,
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                color: isActive ? activeColor : Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TopPerformersCard extends StatelessWidget {
  final List<LeaderboardModel> performers;

  const _TopPerformersCard({
    required this.performers,
  });

  @override
  Widget build(BuildContext context) {
    final first = performers.firstWhere(
      (item) => item.rank == 1,
      orElse: () => performers[0],
    );

    final second = performers.firstWhere(
      (item) => item.rank == 2,
      orElse: () => performers[1],
    );

    final third = performers.firstWhere(
      (item) => item.rank == 3,
      orElse: () => performers[2],
    );

    return Container(
      width: double.infinity,
      height: 310,
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 0),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF0F1),
        borderRadius: BorderRadius.circular(7),
        border: Border.all(
          color: const Color(0xFFFF2B36),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          const Text(
            'Top Performers',
            style: TextStyle(
              color: Color(0xFF222222),
              fontSize: 13,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 3),
          const Text(
            'Mahasiswa terbaik minggu ini',
            style: TextStyle(
              color: Color(0xFF555555),
              fontSize: 11,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 22),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: _PodiumItem(
                    item: second,
                    avatarSize: 56,
                    barHeight: 62,
                    barColor: const Color(0xFFC9C9C9),
                    showMedal: true,
                  ),
                ),
                Expanded(
                  child: _PodiumItem(
                    item: first,
                    avatarSize: 64,
                    barHeight: 104,
                    barColor: const Color(0xFFFFC236),
                    showCrown: true,
                  ),
                ),
                Expanded(
                  child: _PodiumItem(
                    item: third,
                    avatarSize: 56,
                    barHeight: 42,
                    barColor: const Color(0xFFD1924D),
                    showMedal: true,
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

class _PodiumItem extends StatelessWidget {
  final LeaderboardModel item;
  final double avatarSize;
  final double barHeight;
  final Color barColor;
  final bool showCrown;
  final bool showMedal;

  const _PodiumItem({
    required this.item,
    required this.avatarSize,
    required this.barHeight,
    required this.barColor,
    this.showCrown = false,
    this.showMedal = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              height: avatarSize,
              width: avatarSize,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: const Color(0xFFED1E28),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                item.initials,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            if (showCrown)
              const Positioned(
                right: -6,
                top: -10,
                child: Icon(
                  Icons.workspace_premium,
                  size: 18,
                  color: Colors.black,
                ),
              ),
            if (showMedal)
              Positioned(
                right: -4,
                top: -5,
                child: Container(
                  height: 16,
                  width: 16,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.military_tech_outlined,
                    size: 11,
                    color: Color(0xFFA7A7A7),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          item.name,
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Color(0xFF222222),
            fontSize: 9,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 5),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 9,
            vertical: 4,
          ),
          decoration: BoxDecoration(
            color: const Color(0xFFFFE6E8),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.emoji_events_outlined,
                size: 9,
                color: Color(0xFFED1E28),
              ),
              const SizedBox(width: 3),
              Text(
                '${item.point}',
                style: const TextStyle(
                  color: Color(0xFF333333),
                  fontSize: 9,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 6),
        Container(
          height: barHeight,
          width: double.infinity,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            color: barColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(9),
              topRight: Radius.circular(9),
            ),
          ),
        ),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Icon(
          Icons.trending_up_rounded,
          size: 13,
          color: Colors.black,
        ),
        SizedBox(width: 7),
        Text(
          'Rangking Lainnya',
          style: TextStyle(
            color: Color(0xFF111111),
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _RankingItemCard extends StatelessWidget {
  final LeaderboardModel item;

  const _RankingItemCard({
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFED1E28),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            height: 34,
            width: 34,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '#${item.rank}',
              style: const TextStyle(
                color: Color(0xFFED1E28),
                fontSize: 12,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            height: 36,
            width: 36,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color(0xFFFFF0F1),
              borderRadius: BorderRadius.circular(9),
            ),
            child: Text(
              item.initials,
              style: const TextStyle(
                color: Color(0xFFED1E28),
                fontSize: 12,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${item.point} Poin',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 36,
            width: 36,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(9),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${item.level}',
                  style: const TextStyle(
                    color: Color(0xFFED1E28),
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  'Level',
                  style: TextStyle(
                    color: Color(0xFFED1E28),
                    fontSize: 7,
                    fontWeight: FontWeight.w600,
                    height: 1,
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

class _LeaderboardEmptyCard extends StatelessWidget {
  final String title;
  final String message;

  const _LeaderboardEmptyCard({
    required this.title,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          const Icon(
            Icons.emoji_events_outlined,
            color: Color(0xFFED1E28),
            size: 34,
          ),
          const SizedBox(height: 10),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFF111827),
              fontSize: 13,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFF6B7280),
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _LeaderboardLoadingView extends StatelessWidget {
  const _LeaderboardLoadingView();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(
        color: Color(0xFFED1E28),
      ),
    );
  }
}

class _LeaderboardErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _LeaderboardErrorView({
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 22),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.warning_amber_rounded,
                color: Color(0xFFED1E28),
                size: 36,
              ),
              const SizedBox(height: 10),
              const Text(
                'Gagal Memuat Leaderboard',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF111827),
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color(0xFF6B7280),
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 14),
              SizedBox(
                height: 38,
                child: ElevatedButton(
                  onPressed: onRetry,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFED1E28),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Coba Lagi',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
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
