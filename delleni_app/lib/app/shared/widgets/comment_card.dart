import 'package:flutter/material.dart';
import 'package:delleni_app/app/data/models/comment_model.dart';
import 'package:delleni_app/app/core/constants/app_constants.dart';
import 'package:delleni_app/app/core/utils/helpers.dart';

class CommentCard extends StatelessWidget {
  final CommentModel comment;
  final VoidCallback onLike;
  final VoidCallback? onReply;
  final VoidCallback? onTap;
  final bool showServiceName;
  final String? serviceName;

  const CommentCard({
    Key? key,
    required this.comment,
    required this.onLike,
    this.onReply,
    this.onTap,
    this.showServiceName = false,
    this.serviceName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final timeAgoStr = Helpers.timeAgoArabic(comment.createdAt);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: avatar + name + time
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Avatar
                Container(
                  width: 32,
                  height: 32,
                  decoration: const BoxDecoration(
                    color: Color(0xFFEFEFEF),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.person_outline_rounded,
                    size: 18,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(width: 8),
                // Name and time
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        comment.username,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        timeAgoStr,
                        style: const TextStyle(
                          fontSize: 11,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                // Service badge (if shown)
                if (showServiceName && serviceName != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primaryGreenLight,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      serviceName!,
                      style: const TextStyle(
                        fontSize: 10,
                        color: AppColors.primaryGreen,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 10),
            // Comment content
            Text(
              comment.content,
              style: const TextStyle(
                fontSize: 13,
                color: Colors.black87,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 12),
            // Actions row
            Row(
              children: [
                // Reply button
                if (onReply != null)
                  InkWell(
                    onTap: onReply,
                    child: const Row(
                      children: [
                        Icon(
                          Icons.reply_outlined,
                          size: 16,
                          color: Colors.grey,
                        ),
                        SizedBox(width: 4),
                        Text(
                          'رد',
                          style: TextStyle(fontSize: 13, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                if (onReply != null) const SizedBox(width: 16),
                // Like button
                InkWell(
                  onTap: onLike,
                  child: Row(
                    children: [
                      Icon(
                        comment.likes > 0
                            ? Icons.thumb_up_rounded
                            : Icons.thumb_up_alt_outlined,
                        size: 16,
                        color: comment.likes > 0
                            ? AppColors.primaryGreen
                            : Colors.grey,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        comment.likes.toString(),
                        style: TextStyle(
                          fontSize: 13,
                          color: comment.likes > 0
                              ? AppColors.primaryGreen
                              : Colors.grey,
                        ),
                      ),
                    ],
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

class CommentInputField extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;
  final String hintText;
  final bool isSending;

  const CommentInputField({
    Key? key,
    required this.controller,
    required this.onSend,
    this.hintText = 'شارك نصيحة أو تجربة...',
    this.isSending = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        boxShadow: [
          BoxShadow(
            color: Color(0x1A000000),
            blurRadius: 8,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Text field
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: AppColors.backgroundGrey,
                borderRadius: BorderRadius.circular(20),
              ),
              child: TextField(
                controller: controller,
                minLines: 1,
                maxLines: 4,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: hintText,
                  hintStyle: const TextStyle(fontSize: 13, color: Colors.grey),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          // Send button
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isSending ? Colors.grey : AppColors.primaryGreen,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: isSending
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(
                      Icons.send_rounded,
                      color: Colors.white,
                      size: 18,
                    ),
              onPressed: isSending ? null : onSend,
            ),
          ),
        ],
      ),
    );
  }
}
