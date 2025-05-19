import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'dart:convert';
import '../../core/app_export.dart';
import '../../model/review.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductReviewList extends StatefulWidget {
  final String productId;

  const ProductReviewList({super.key, required this.productId});

  @override
  State<ProductReviewList> createState() => _ProductReviewListState();
}

class _ProductReviewListState extends State<ProductReviewList> {
  late WebSocketChannel _channel;
  final List<ReviewModel> _reviews = [];

  @override
  void initState() {
    super.initState();
    // Connect to WebSocket server
    _channel = WebSocketChannel.connect(
      Uri.parse('ws://localhost:8080?productId=${widget.productId}'),
    );

    // Listen for WebSocket messages
    _channel.stream.listen(
      (message) {
        final data = jsonDecode(message);
        if (data['type'] == 'new_review') {
          final review = ReviewModel.fromMap(data['review']);
          setState(() {
            _reviews.insert(0, review); // Add new review at the top
          });
        }
      },
      onError: (error) {
        print('WebSocket error: $error');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi kết nối WebSocket')),
        );
      },
      onDone: () {
        print('WebSocket closed');
      },
    );

    // Fetch initial reviews from Firestore
    _fetchInitialReviews();
  }

  Future<void> _fetchInitialReviews() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('reviews')
        .where('productId', isEqualTo: widget.productId)
        .orderBy('createdAt', descending: true)
        .get();
    final reviews = snapshot.docs
        .map((doc) => ReviewModel.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
    setState(() {
      _reviews.clear();
      _reviews.addAll(reviews);
    });
  }

  @override
  void dispose() {
    _channel.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_reviews.isEmpty) {
      return Text('Chưa có đánh giá nào',
          style: CustomTextStyles.bodySmallBalooBhaiGray900);
    }
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: _reviews.length,
      itemBuilder: (context, index) {
        final review = _reviews[index];
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 8.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundImage: review.userAvatar.isNotEmpty
                        ? NetworkImage(review.userAvatar)
                        : null,
                    child:
                        review.userAvatar.isEmpty ? Icon(Icons.person) : null,
                    radius: 20.h,
                  ),
                  SizedBox(width: 12.h),
                  Text(
                    review.userName,
                    style: CustomTextStyles.labelLargeGray900,
                  ),
                  Spacer(),
                  if (review.rating > 0)
                    Row(
                      children: List.generate(5, (i) {
                        return Icon(
                          i < review.rating ? Icons.star : Icons.star_border,
                          color: Colors.amber,
                          size: 16.h,
                        );
                      }),
                    ),
                ],
              ),
              SizedBox(height: 8.h),
              Text(
                review.comment,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: CustomTextStyles.bodySmallBalooBhaiGray900_1,
              ),
              SizedBox(height: 4.h),
              Text(
                "${review.createdAt.day}/${review.createdAt.month}/${review.createdAt.year}",
                style: CustomTextStyles.bodySmallBalooBhaiGray900,
              ),
              if (review.images.isNotEmpty)
                SizedBox(
                  height: 60.h,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: review.images.length,
                    itemBuilder: (context, imgIndex) {
                      return Padding(
                        padding: EdgeInsets.only(right: 8.h),
                        child: Image.network(
                          review.images[imgIndex],
                          width: 60.h,
                          height: 60.h,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Icon(Icons.error),
                        ),
                      );
                    },
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
