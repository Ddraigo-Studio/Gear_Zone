import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AdminSupportChatDetailScreen extends StatefulWidget {
  final String userId;
  const AdminSupportChatDetailScreen({super.key, required this.userId});

  @override
  State<AdminSupportChatDetailScreen> createState() => _AdminSupportChatDetailScreenState();
}

class _AdminSupportChatDetailScreenState extends State<AdminSupportChatDetailScreen> {
  final TextEditingController _controller = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  void _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    // Tìm một tin nhắn từ người dùng để lấy tên
    final userMessageSnapshot = await _firestore
        .collection('support_chats')
        .where('senderId', isEqualTo: widget.userId)
        .limit(1)
        .get();
    
    String recipientName = 'Khách hàng';
    if (userMessageSnapshot.docs.isNotEmpty) {
      recipientName = (userMessageSnapshot.docs.first.data()['senderName'] ?? 'Khách hàng');
    }

    await _firestore.collection('support_chats').add({
      'message': text,
      'senderId': 'admin',
      'senderName': 'Hỗ trợ',
      'recipientId': widget.userId,
      'recipientName': recipientName,
      'timestamp': FieldValue.serverTimestamp(),
    });

    _controller.clear();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: StreamBuilder<QuerySnapshot>(
          stream: _firestore
              .collection('support_chats')
              .where('senderId', isEqualTo: widget.userId)
              .limit(1)
              .snapshots(),
          builder: (context, snapshot) {
            String userName = 'Khách hàng';
            if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
              final userData = snapshot.data!.docs.first.data() as Map<String, dynamic>;
              userName = userData['senderName'] ?? 'Khách hàng';
            }
            return Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 20,
                  child: Text(
                    userName.isNotEmpty ? userName[0].toUpperCase() : 'K',
                    style: const TextStyle(
                      color: Colors.deepPurpleAccent,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const Text(
                      'Trực tuyến',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
        backgroundColor: Colors.deepPurpleAccent,
        foregroundColor: Colors.white,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              // Show menu
            },
          ),
        ],
      ),      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const NetworkImage(
              'https://img.freepik.com/free-vector/gradient-bubble-chat-background_23-2149163886.jpg',
            ),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.white.withOpacity(0.2),
              BlendMode.lighten,
            ),
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestore
                    .collection('support_chats')
                    .orderBy('timestamp')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Colors.deepPurpleAccent,
                      ),
                    );
                  }

                  final messages = snapshot.data!.docs.where((doc) {
                    final data = doc.data() as Map<String, dynamic>;
                    return (data['senderId'] == 'admin' && data['recipientId'] == widget.userId) ||
                          (data['senderId'] == widget.userId && data['recipientId'] == 'admin');
                  }).toList();

                  return ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final data = messages[index].data() as Map<String, dynamic>;
                      final isMe = data['senderId'] == 'admin';
                      
                      // Format thời gian
                      String timeStr = '...';
                      if (data['timestamp'] != null) {
                        final timestamp = (data['timestamp'] as Timestamp).toDate();
                        final now = DateTime.now();
                        
                        if (timestamp.year == now.year && 
                            timestamp.month == now.month && 
                            timestamp.day == now.day) {
                          timeStr = DateFormat('HH:mm').format(timestamp);
                        } else {
                          timeStr = DateFormat('HH:mm, dd/MM').format(timestamp);
                        }
                      }

                      return Align(
                        alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                        child: Container(
                          margin: EdgeInsets.only(
                            bottom: 12, 
                            left: isMe ? 50 : 8, 
                            right: isMe ? 8 : 50,
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          decoration: BoxDecoration(
                            color: isMe ? Colors.deepPurpleAccent : Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: const Radius.circular(18),
                              topRight: const Radius.circular(18),
                              bottomLeft: Radius.circular(isMe ? 18 : 0),
                              bottomRight: Radius.circular(isMe ? 0 : 18),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 3,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Tin nhắn
                              Text(
                                data['message'],
                                style: TextStyle(
                                  fontSize: 16,
                                  color: isMe ? Colors.white : Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 4),
                              // Thời gian
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    timeStr,
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: isMe ? Colors.white70 : Colors.black54,
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                  if (isMe)
                                    Icon(
                                      Icons.done_all,
                                      size: 14,
                                      color: Colors.white.withOpacity(0.7),
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                  },
                );
              },
            ),
          ),          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.add_circle_outline,
                    color: Colors.deepPurpleAccent,
                    size: 28,
                  ),
                  onPressed: () {
                    // Thêm hình ảnh hoặc tệp
                  },
                ),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Nhập tin nhắn...',
                      hintStyle: TextStyle(
                        color: Colors.grey.shade500,
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      suffixIcon: IconButton(
                        icon: const Icon(
                          Icons.emoji_emotions_outlined,
                          color: Colors.amber,
                        ),
                        onPressed: () {
                          // Hiển thị emoji picker
                        },
                      ),
                    ),
                    minLines: 1,
                    maxLines: 4,
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  height: 48,
                  width: 48,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [Colors.deepPurpleAccent, Colors.purple],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.send_rounded,
                      color: Colors.white,
                    ),
                    onPressed: _sendMessage,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
    );
  }
}
