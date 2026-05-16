import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/forum/create_post_dialog.dart';
import '../../viewmodels/forum_viewmodel.dart';
import '../widgets/forum/forum_header.dart';
import '../widgets/forum/forum_segment_tab.dart';
import '../widgets/forum/forum_category_filter.dart';
import '../widgets/forum/forum_post_card.dart';
import 'forum_study_room_page.dart';
import 'forum_post_detail_page.dart';

class ForumPage extends StatelessWidget {
  const ForumPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ForumViewModel()..initForum(),
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
                    ForumHeader(
                      showBackButton: false,
                      subtitle: forumVM.onlineText,
                      onAddTap: () async {
                        final result = await showDialog<bool>(
                          context: context,
                          barrierDismissible: false,
                          builder: (_) => CreatePostDialog(
                            onSubmit: ({
                              required title,
                              required content,
                              required category,
                              required tags,
                            }) {
                              return forumVM.createPost(
                                title: title,
                                content: content,
                                category: category,
                                tags: tags,
                              );
                            },
                          ),
                        );

                        if (!context.mounted) return;

                        if (result == true) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Postingan berhasil dibuat'),
                            ),
                          );
                        } else if (forumVM.errorMessage != null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(forumVM.errorMessage!),
                            ),
                          );
                        }
                      },
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
                  child: forumVM.isLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: Color(0xFFF91D2F),
                          ),
                        )
                      : forumVM.errorMessage != null
                          ? RefreshIndicator(
                              color: const Color(0xFFF91D2F),
                              onRefresh: () async {
                                await forumVM.fetchCommunityStats();
                                await forumVM.fetchForumFeed();
                              },
                              child: ListView(
                                physics: const AlwaysScrollableScrollPhysics(),
                                padding:
                                    const EdgeInsets.fromLTRB(24, 120, 24, 150),
                                children: [
                                  Center(
                                    child: Text(
                                      forumVM.errorMessage!,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontSize: 13,
                                        color: Color(0xFF777777),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : forumVM.filteredPosts.isEmpty
                              ? RefreshIndicator(
                                  color: const Color(0xFFF91D2F),
                                  onRefresh: () async {
                                    await forumVM.fetchCommunityStats();
                                    await forumVM.fetchForumFeed();
                                  },
                                  child: ListView(
                                    physics:
                                        const AlwaysScrollableScrollPhysics(),
                                    padding: const EdgeInsets.fromLTRB(
                                        24, 120, 24, 150),
                                    children: const [
                                      Center(
                                        child: Text(
                                          'Belum ada postingan',
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: Color(0xFF777777),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : RefreshIndicator(
                                  color: const Color(0xFFF91D2F),
                                  onRefresh: () async {
                                    await forumVM.fetchCommunityStats();
                                    await forumVM.fetchForumFeed();
                                  },
                                  child: ListView.builder(
                                    physics:
                                        const AlwaysScrollableScrollPhysics(),
                                    padding: const EdgeInsets.only(bottom: 150),
                                    itemCount: forumVM.filteredPosts.length,
                                    itemBuilder: (context, index) {
                                      final post = forumVM.filteredPosts[index];
                                      return ForumPostCard(
                                        post: post,
                                        onLikeTap: forumVM.isActionLoading
                                            ? null
                                            : () {
                                                forumVM.togglePostLike(post.id);
                                              },
                                        onCommentTap: () async {
                                          await Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (_) =>
                                                  ForumPostDetailPage(
                                                      post: post),
                                            ),
                                          );

                                          await forumVM.fetchForumFeed();
                                        },
                                      );
                                    },
                                  ),
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
