import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../viewmodels/forum_viewmodel.dart';
import '../widgets/forum/forum_header.dart';
import '../widgets/forum/forum_segment_tab.dart';
import '../widgets/forum/forum_category_filter.dart';
import '../widgets/forum/forum_post_card.dart';
import 'forum_study_room_page.dart';

class ForumPage extends StatelessWidget {
  const ForumPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ForumViewModel(),
      child: const _ForumPageContent(),
    );
  }
}

class _ForumPageContent extends StatelessWidget {
  const _ForumPageContent();

  @override
  Widget build(BuildContext context) {
    final forumVM = context.watch<ForumViewModel>();

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            Column(
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    const ForumHeader(
                      showBackButton: false,
                    ),
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 31,
                      child: ForumSegmentTab(
                        isStudyRoom: false,
                        onPostTap: () {},
                        onStudyRoomTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const ForumStudyRoomPage(),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                ForumCategoryFilter(
                  categories: forumVM.categories,
                  selectedCategory: forumVM.selectedCategory,
                  onCategoryTap: forumVM.changeCategory,
                ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.only(
                      bottom: 105,
                    ),
                    itemCount: forumVM.filteredPosts.length,
                    itemBuilder: (context, index) {
                      final post = forumVM.filteredPosts[index];

                      return ForumPostCard(post: post);
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
