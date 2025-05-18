import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'admin_support.dart'; // màn hình chat chi tiết

class AdminSupportUserListScreen extends StatelessWidget {
  const AdminSupportUserListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hộp thư hỗ trợ'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('support_chats')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

          final docs = snapshot.data!.docs;
          final Map<String, QueryDocumentSnapshot> lastMessages = {};

          for (var doc in docs) {
            final data = doc.data() as Map<String, dynamic>;
            final senderId = data['senderId'];
            final recipientId = data['recipientId'];

            if (senderId == 'admin' || recipientId == 'admin') {
              final userId = senderId == 'admin' ? recipientId : senderId;
              if (!lastMessages.containsKey(userId)) {
                lastMessages[userId] = doc; // lấy tin nhắn mới nhất
              }
            }
          }

          if (lastMessages.isEmpty) {
            return const Center(child: Text("Chưa có tin nhắn nào"));
          }          return ListView(
            children: lastMessages.entries.map((entry) {              final userId = entry.key;
              final data = entry.value.data() as Map<String, dynamic>;
              final message = data['message'] ?? '';
              
              // Lấy tên người dùng từ tin nhắn
              String userName = 'Khách hàng';
              if (data['senderId'] != 'admin' && data['senderName'] != null) {
                userName = data['senderName'];
              } else if (data['recipientId'] != 'admin' && data['senderName'] != null) {
                // Tìm kiếm thêm tên người dùng từ các tin nhắn khác
                for (var doc in docs) {
                  final msgData = doc.data() as Map<String, dynamic>;
                  if (msgData['senderId'] == userId && msgData['senderName'] != null) {
                    userName = msgData['senderName'];
                    break;
                  }
                }
              }

              return ListTile(
                title: Text(userName),
                subtitle: Text(message, maxLines: 1, overflow: TextOverflow.ellipsis),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AdminSupportChatDetailScreen(userId: userId),
                    ),
                  );
                },
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
