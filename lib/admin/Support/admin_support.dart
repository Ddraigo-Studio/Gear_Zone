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
    return Scaffold(      appBar: AppBar(
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
            return Text('Chat với $userName');
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('support_chats')
                  .orderBy('timestamp')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

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
                    final time = data['timestamp'] != null
                        ? DateFormat('HH:mm, dd/MM/yyyy').format(
                            (data['timestamp'] as Timestamp).toDate(),
                          )
                        : '...';

                    return Align(
                      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        padding: const EdgeInsets.all(10),
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.7,
                        ),
                        decoration: BoxDecoration(
                          color: isMe ? Colors.deepPurpleAccent : Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              data['message'],
                              style: TextStyle(
                                color: isMe ? Colors.white : Colors.black,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              time,
                              style: TextStyle(
                                fontSize: 11,
                                color: isMe ? Colors.white70 : Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Nhập tin nhắn...',
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.deepPurple),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
