import 'package:flutter/material.dart';

import '../models/forum/forum_post_model.dart';
import '../models/forum/study_room_model.dart';
import '../models/forum/chat_message_model.dart';

class ForumViewModel extends ChangeNotifier {
  String selectedCategory = 'Semua';

  final List<String> categories = [
    'Semua',
    'Umum',
    'Tips & Trik',
    'Bantuan',
  ];

  final List<ForumPostModel> _posts = [
    ForumPostModel(
      id: '1',
      authorName: 'Ahmad',
      authorInitial: 'AH',
      category: 'Tips & Trik',
      title: 'Tips Menyelesaikan Daily Quest dengan Cepat',
      description:
          'Berikut adalah beberapa tips yang bisa membantu kalian menyelesaikan daily quest...',
      tags: ['Tips', 'Quiz'],
      likes: 24,
      comments: 8,
      timeAgo: '2 jam lalu',
    ),
    ForumPostModel(
      id: '2',
      authorName: 'Siti',
      authorInitial: 'SI',
      category: 'Umum',
      title: 'Komunitas yang Luar Biasa!',
      description:
          'Berikut adalah beberapa tips yang bisa membantu kalian menyelesaikan daily quest...',
      tags: ['Umum', 'Apreasi'],
      likes: 24,
      comments: 8,
      timeAgo: '2 jam lalu',
    ),
    ForumPostModel(
      id: '3',
      authorName: 'Andi Pratama',
      authorInitial: 'AP',
      category: 'Tips & Trik',
      title: 'Bagaimana menyeimbangkan quiz dengan jadwal kuliah?',
      description:
          'Saya sering kesulitan mengatur waktu antara quiz dan tugas kuliah. Ada tips?',
      tags: ['Tips', 'Manajemen'],
      likes: 24,
      comments: 8,
      timeAgo: '2 jam lalu',
    ),
    ForumPostModel(
      id: '4',
      authorName: 'Budi',
      authorInitial: 'BD',
      category: 'Bantuan',
      title: 'Bagaimana cara mendapat achievement “Legend”?',
      description:
          'Saya sudah mencoba berbagai cara tapi belum berhasil mendapatkan achievement...',
      tags: ['Bantuan', 'Achievement'],
      likes: 24,
      comments: 8,
      timeAgo: '2 jam lalu',
    ),
  ];

  final List<StudyRoomModel> studyRooms = [
    StudyRoomModel(
      id: '1',
      authorName: 'Budi',
      authorInitial: 'BD',
      title: 'Algoritma Pemograman',
      description:
          'Ruang Belajar: Dasar-dasar Python untuk Pemula – Join yuk! Kita akan belajar bareng dari basic sampai OOP',
      currentParticipants: 15,
      maxParticipants: 20,
      likes: 24,
      timeAgo: '2 jam lalu',
    ),
    StudyRoomModel(
      id: '2',
      authorName: 'Siti Aminah',
      authorInitial: 'SA',
      title: 'Algoritma Pemograman',
      description:
          'Ruang Belajar: Dasar-dasar Python untuk Pemula – Join yuk! Kita akan belajar bareng dari basic sampai OOP',
      currentParticipants: 15,
      maxParticipants: 20,
      likes: 24,
      timeAgo: '2 jam lalu',
    ),
  ];

  final List<ChatMessageModel> chatMessages = [
    ChatMessageModel(
      id: '1',
      senderName: 'Siti Aminah',
      senderInitial: 'SA',
      message:
          'Halo semuanya! Selamat datang di study group persiapan UTS Algoritma. Yuk kita mulai dengan membahas materi sorting algorithms dulu',
      time: '08:30',
      isMe: false,
      isAdmin: true,
      likes: 8,
      replies: 2,
    ),
    ChatMessageModel(
      id: '2',
      senderName: 'Budi Santoso',
      senderInitial: 'BS',
      message:
          'Sip kak! Aku masih bingung di bubble sort sama quick sort nih. Bisa dijelasin bedanya ga?',
      time: '08:35',
      isMe: false,
      likes: 3,
    ),
    ChatMessageModel(
      id: '3',
      senderName: 'Anda',
      senderInitial: 'AN',
      message:
          'Bubble sort itu lebih simple tapi lambat O(n²), sedangkan quick sort lebih cepat dengan average O(n log n).',
      time: '08:40',
      isMe: true,
    ),
  ];

  List<ForumPostModel> get filteredPosts {
    if (selectedCategory == 'Semua') {
      return _posts;
    }

    return _posts.where((post) {
      return post.category == selectedCategory;
    }).toList();
  }

  void changeCategory(String category) {
    selectedCategory = category;
    notifyListeners();
  }
}
