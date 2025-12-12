import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:delleni_app/app/modules/society/controllers/comments_controller.dart';
import 'package:delleni_app/app/core/constants/app_constants.dart';
import 'package:delleni_app/app/shared/widgets/comment_card.dart';
import 'package:delleni_app/app/shared/widgets/empty_state.dart';
import 'package:delleni_app/app/shared/widgets/loading.dart';
import 'package:delleni_app/app/core/utils/helpers.dart';

class CommentsView extends StatefulWidget {
  const CommentsView({Key? key}) : super(key: key);

  @override
  State<CommentsView> createState() => _CommentsViewState();
}

class _CommentsViewState extends State<CommentsView> {
  final CommentsController _controller = Get.put(CommentsController());
  final TextEditingController _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.backgroundGrey,
        body: SafeArea(
          child: Column(
            children: [
              // Header
              _buildHeader(),
              const SizedBox(height: 8),

              // Comments list
              Expanded(
                child: Obx(() {
                  if (_controller.isLoading.value) {
                    return const CustomLoadingIndicator();
                  }

                  final comments = _controller.comments;
                  if (comments.isEmpty) {
                    return EmptyState(
                      title: 'لا توجد نصائح بعد',
                      subtitle: 'كن أول من يشارك تجربته ✨',
                      icon: Icons.chat_bubble_outline,
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    itemCount: comments.length,
                    itemBuilder: (context, index) {
                      final comment = comments[index];
                      return CommentCard(
                        comment: comment,
                        onLike: () => _controller.likeComment(comment),
                        onReply: () {
                          // Focus on text field with mention
                          _textController.text = '@${comment.username} ';
                          _textController
                              .selection = TextSelection.fromPosition(
                            TextPosition(offset: _textController.text.length),
                          );
                        },
                      );
                    },
                  );
                }),
              ),

              // Input bar
              _buildInputBar(),
            ],
          ),
        ),
      ),
    );
  }

  // ================= HEADER =================
  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
      decoration: const BoxDecoration(
        color: AppColors.primaryGreen,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Back button
          InkWell(
            onTap: () => Get.back(),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Colors.white,
                  size: 18,
                ),
                SizedBox(width: 4),
                Text(
                  'العودة للخدمة',
                  style: TextStyle(color: Colors.white, fontSize: 13),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'نصائح المجتمع',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Obx(
            () => Text(
              'تجارب ونصائح للمساعدة في ${_controller.serviceName}',
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ================= INPUT BAR =================
  Widget _buildInputBar() {
    return SafeArea(
      top: false,
      child: Container(
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
                  controller: _textController,
                  onChanged: _controller.updateCommentText,
                  minLines: 1,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'شارك نصيحة أو تجربة...',
                    hintStyle: TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            // Send button
            Obx(
              () => Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: _textController.text.trim().isEmpty
                      ? Colors.grey[300]
                      : AppColors.primaryGreen,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(
                    Icons.send_rounded,
                    color: Colors.white,
                    size: 18,
                  ),
                  onPressed: _textController.text.trim().isEmpty
                      ? null
                      : () {
                          _controller.addComment();
                          _textController.clear();
                        },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
