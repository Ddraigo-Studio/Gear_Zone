import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'admin_support.dart'; // màn hình chat chi tiết

class AdminSupportUserListScreen extends StatelessWidget {
  const AdminSupportUserListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hộp thư hỗ trợ',
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.deepPurpleAccent,
        foregroundColor: Colors.white,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.deepPurple.withOpacity(0.05), Colors.white],
          ),
        ),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('support_chats')
              .orderBy('timestamp', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData)
              return const Center(child: CircularProgressIndicator());

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
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.chat_bubble_outline,
                        size: 80, color: Colors.grey.withOpacity(0.5)),
                    const SizedBox(height: 16),
                    const Text(
                      "Chưa có tin nhắn hỗ trợ nào",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey,
                      ),
                    )
                  ],
                ),
              );
            }
            return ListView(
              children: lastMessages.entries.map((entry) {
                final userId = entry.key;
                final data = entry.value.data() as Map<String, dynamic>;
                final message = data['message'] ?? '';

                // Lấy tên người dùng từ tin nhắn
                String userName = 'Khách hàng';
                if (data['senderId'] != 'admin' && data['senderName'] != null) {
                  userName = data['senderName'];
                } else if (data['recipientId'] != 'admin' &&
                    data['senderName'] != null) {
                  // Tìm kiếm thêm tên người dùng từ các tin nhắn khác
                  for (var doc in docs) {
                    final msgData = doc.data() as Map<String, dynamic>;
                    if (msgData['senderId'] == userId &&
                        msgData['senderName'] != null) {
                      userName = msgData['senderName'];
                      break;
                    }
                  }
                } // Lấy timestamp và format nó thành một chuỗi dễ đọc
                String timeString = '';
                if (data['timestamp'] != null) {
                  final timestamp = (data['timestamp'] as Timestamp).toDate();
                  final now = DateTime.now();

                  if (timestamp.year == now.year &&
                      timestamp.month == now.month &&
                      timestamp.day == now.day) {
                    // Nếu là hôm nay, chỉ hiển thị giờ
                    timeString =
                        '${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}';
                  } else {
                    // Ngày khác
                    timeString =
                        '${timestamp.day}/${timestamp.month}/${timestamp.year}';
                  }
                }

                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ListTile(
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    leading: CircleAvatar(
                      backgroundColor: Colors.deepPurpleAccent,
                      child: Text(
                        userName.isNotEmpty ? userName[0].toUpperCase() : 'K',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    title: Row(
                      children: [
                        Expanded(
                          child: Text(
                            userName,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        if (timeString.isNotEmpty)
                          Text(
                            timeString,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                      ],
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Text(
                        message,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.grey[700],
                        ),
                      ),
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: Colors.deepPurpleAccent,
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              AdminSupportChatDetailScreen(userId: userId),
                        ),
                      );
                    },
                  ),
                );
              }).toList(),
            );
          },
        ),
      ),
    );
  }
}
