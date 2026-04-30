import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/forum/create_post_dialog.dart';
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
                          ? Center(
                              child: Text(
                                forumVM.errorMessage!,
                                textAlign: TextAlign.center,
                              ),
                            )
                          : ListView.builder(
                              padding: const EdgeInsets.only(bottom: 105),
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
