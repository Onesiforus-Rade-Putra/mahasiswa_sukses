import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/custom_bottom_navbar.dart';
import '../../viewmodels/forum_viewmodel.dart';
import '../widgets/forum/forum_header.dart';
import '../widgets/forum/forum_segment_tab.dart';
import '../widgets/forum/study_room_card.dart';
import 'study_room_chat_page.dart';
import '../widgets/forum/create_room_dialog.dart';

class ForumStudyRoomPage extends StatelessWidget {
  const ForumStudyRoomPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ForumViewModel()..initStudyRooms(),
      child: const _ForumStudyRoomPageContent(),
    );
  }
}

class _ForumStudyRoomPageContent extends StatelessWidget {
  const _ForumStudyRoomPageContent();

  @override
  Widget build(BuildContext context) {
    final forumVM = context.watch<ForumViewModel>();

    return Scaffold(
      extendBody: true,
      backgroundColor: const Color(0xFFF9F9F9),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                ForumHeader(
                  height: 265,
                  showBackButton: true,
                  onBackTap: () => Navigator.pop(context),
                  onAddTap: () async {
                    final result = await showDialog<bool>(
                      context: context,
                      barrierDismissible: false,
                      builder: (_) => CreateRoomDialog(
                        onSubmit: ({
                          required title,
                          required description,
                          required maxParticipants,
                        }) {
                          return forumVM.createRoom(
                            title: title,
                            description: description,
                            maxParticipants: maxParticipants,
                          );
                        },
                      ),
                    );

                    if (!context.mounted) return;

                    if (result == true) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Ruang belajar berhasil dibuat'),
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
                  bottom: 82,
                  child: ForumSegmentTab(
                    isStudyRoom: true,
                    onPostTap: () => Navigator.pop(context),
                    onStudyRoomTap: () {},
                  ),
                ),
                Positioned(
                  left: 30,
                  right: 30,
                  bottom: 20,
                  child: Container(
                    height: 35,
                    padding: const EdgeInsets.symmetric(horizontal: 22),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(9),
                    ),
                    child: const Row(
                      children: [
                        Icon(
                          Icons.search,
                          size: 18,
                          color: Color(0xFFF91D2F),
                        ),
                        SizedBox(width: 18),
                        Text(
                          'Cari tugas atau materi',
                          style: TextStyle(
                            color: Color(0xFFF91D2F),
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 28),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 28),
              child: Row(
                children: [
                  Icon(
                    Icons.local_fire_department,
                    color: Color(0xFFF91D2F),
                    size: 16,
                  ),
                  SizedBox(width: 7),
                  Text(
                    'Yuk belajar bareng di forum!',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 7),
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
                          padding: const EdgeInsets.only(bottom: 150),
                          itemCount: forumVM.studyRooms.length,
                          itemBuilder: (context, index) {
                            final room = forumVM.studyRooms[index];
                            return StudyRoomCard(
                              room: room,
                              onJoinTap: () async {
                                final success = await forumVM.joinRoom(room.id);

                                if (!context.mounted) return;

                                if (success) {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) => StudyRoomChatPage(
                                        roomId: room.id,
                                        roomTitle: room.title,
                                      ),
                                    ),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        forumVM.errorMessage ??
                                            'Gagal join study room',
                                      ),
                                    ),
                                  );
                                }
                              },
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavbar(
        currentIndex: 1,
        onTap: (index) {
          if (index == 1) return;
          Navigator.pop(context);
        },
      ),
    );
  }
}
