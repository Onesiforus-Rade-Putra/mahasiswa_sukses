import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../viewmodels/forum_viewmodel.dart';
import '../widgets/custom_bottom_navbar.dart';
import '../widgets/forum/create_room_dialog.dart';
import '../widgets/forum/forum_header.dart';
import '../widgets/forum/forum_segment_tab.dart';
import '../widgets/forum/study_room_card.dart';
import 'study_room_chat_page.dart';

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

class _ForumStudyRoomPageContent extends StatefulWidget {
  const _ForumStudyRoomPageContent();

  @override
  State<_ForumStudyRoomPageContent> createState() =>
      _ForumStudyRoomPageContentState();
}

class _ForumStudyRoomPageContentState
    extends State<_ForumStudyRoomPageContent> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _searchDebounce;

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    _searchDebounce?.cancel();

    _searchDebounce = Timer(const Duration(milliseconds: 500), () {
      if (!mounted) return;
      context.read<ForumViewModel>().searchRooms(value);
    });
  }

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
                  subtitle: forumVM.onlineText,
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

                // Search bar ruang belajar
                Positioned(
                  left: 30,
                  right: 30,
                  bottom: 20,
                  child: Container(
                    height: 35,
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(9),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.search,
                          size: 18,
                          color: Color(0xFFF91D2F),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            onChanged: _onSearchChanged,
                            textInputAction: TextInputAction.search,
                            cursorColor: const Color(0xFFF91D2F),
                            style: const TextStyle(
                              color: Color(0xFF222222),
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                            decoration: const InputDecoration(
                              hintText: 'Cari tugas atau materi',
                              hintStyle: TextStyle(
                                color: Color(0xFFF91D2F),
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                              ),
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding: EdgeInsets.zero,
                            ),
                          ),
                        ),
                        if (_searchController.text.isNotEmpty)
                          GestureDetector(
                            onTap: () {
                              _searchController.clear();
                              context.read<ForumViewModel>().searchRooms('');
                              setState(() {});
                            },
                            child: const Icon(
                              Icons.close,
                              size: 16,
                              color: Color(0xFFF91D2F),
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
                      ? RefreshIndicator(
                          color: const Color(0xFFF91D2F),
                          onRefresh: () async {
                            await forumVM.fetchCommunityStats();
                            await forumVM.fetchRoomFeed();
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
                      : forumVM.studyRooms.isEmpty
                          ? RefreshIndicator(
                              color: const Color(0xFFF91D2F),
                              onRefresh: () async {
                                await forumVM.fetchCommunityStats();
                                await forumVM.fetchRoomFeed();
                              },
                              child: ListView(
                                physics: const AlwaysScrollableScrollPhysics(),
                                padding:
                                    const EdgeInsets.fromLTRB(24, 120, 24, 150),
                                children: const [
                                  Center(
                                    child: Text(
                                      'Ruang belajar tidak ditemukan',
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
                                await forumVM.fetchRoomFeed();
                              },
                              child: ListView.builder(
                                physics: const AlwaysScrollableScrollPhysics(),
                                padding: const EdgeInsets.only(bottom: 150),
                                itemCount: forumVM.studyRooms.length,
                                itemBuilder: (context, index) {
                                  final room = forumVM.studyRooms[index];
                                  return StudyRoomCard(
                                    room: room,
                                    onLikeTap: forumVM.isActionLoading
                                        ? null
                                        : () {
                                            forumVM.toggleRoomLike(room.id);
                                          },
                                    onJoinTap: forumVM.isActionLoading
                                        ? () {}
                                        : () async {
                                            if (room.currentParticipants >=
                                                    room.maxParticipants &&
                                                !room.isJoined) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                  content: Text(
                                                      'Ruang belajar sudah penuh'),
                                                ),
                                              );
                                              return;
                                            }

                                            if (room.isJoined) {
                                              final result =
                                                  await Navigator.of(context)
                                                      .push<bool>(
                                                MaterialPageRoute(
                                                  builder: (_) =>
                                                      StudyRoomChatPage(
                                                    roomId: room.id,
                                                    roomTitle: room.title,
                                                    currentParticipants: room
                                                        .currentParticipants,
                                                    maxParticipants:
                                                        room.maxParticipants,
                                                    isActive: room.isActive,
                                                  ),
                                                ),
                                              );

                                              if (result == true) {
                                                await forumVM.fetchRoomFeed();
                                              }

                                              return;
                                            }

                                            final success =
                                                await forumVM.joinRoom(room.id);

                                            if (!context.mounted) return;

                                            if (success) {
                                              final latestRoom =
                                                  forumVM.studyRooms.firstWhere(
                                                (item) => item.id == room.id,
                                                orElse: () => room,
                                              );

                                              final result =
                                                  await Navigator.of(context)
                                                      .push<bool>(
                                                MaterialPageRoute(
                                                  builder: (_) =>
                                                      StudyRoomChatPage(
                                                    roomId: latestRoom.id,
                                                    roomTitle: latestRoom.title,
                                                    currentParticipants:
                                                        latestRoom
                                                            .currentParticipants,
                                                    maxParticipants: latestRoom
                                                        .maxParticipants,
                                                    isActive:
                                                        latestRoom.isActive,
                                                  ),
                                                ),
                                              );

                                              if (result == true) {
                                                await forumVM.fetchRoomFeed();
                                              }
                                            } else {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
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
