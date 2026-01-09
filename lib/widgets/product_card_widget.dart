import 'package:flutter/material.dart';
import '../models/product_card_model.dart';
import '../services/comment_service.dart';
import '../models/comment_model.dart';

class ProductWidget extends StatelessWidget {
  final ProductCardModel product;
  final bool isFavorite;
  final VoidCallback onToggleFavorite;

  const ProductWidget({
    super.key,
    required this.product,
    required this.isFavorite,
    required this.onToggleFavorite,
  });

  // This opens the comment section without changing the main Product UI
  void _showCommentSheet(BuildContext context) {
    final TextEditingController controller = TextEditingController();
    final CommentService service = CommentService();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16, right: 16, top: 16),
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.6,
          child: Column(
            children: [
              Text("Comments for ${product.name}",
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const Divider(),
              Expanded(
                child: StreamBuilder<List<ProductComment>>(
                  stream: service.getComments(product.name),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    final comments = snapshot.data ?? [];
                    if (comments.isEmpty) {
                      return const Center(child: Text("No comments yet. Be the first!"));
                    }
                    return ListView.builder(
                      itemCount: comments.length,
                      itemBuilder: (context, index) => ListTile(
                        leading: const CircleAvatar(child: Icon(Icons.person)),
                        title: Text(comments[index].userName, 
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                        subtitle: Text(comments[index].text),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10, top: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: controller,
                        decoration: const InputDecoration(
                          hintText: "Add a comment...",
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.send, color: Color(0xFF5ce1e6)),
                      onPressed: () {
                        if (controller.text.trim().isNotEmpty) {
                          service.addComment(product.name, controller.text);
                          controller.clear();
                        }
                      },
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // PRESERVING YOUR ORIGINAL LAYOUT
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 3,
      child: Stack( // Using Stack to place the comment button at bottom right
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Your original Product Details
                Text(
                  product.name,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(
                  product.spec!,
                  style: const TextStyle(color: Colors.grey, fontSize: 13),
                ),
                const SizedBox(height: 8),
                Text(
                  "₱${product.price.toStringAsFixed(2)}",
                  style: const TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 10),
                // Heart Icon for Favorites
                GestureDetector(
                  onTap: onToggleFavorite,
                  child: Icon(
                    isFavorite ? Icons.star : Icons.star_border,
                    color: Colors.yellow,
                  ),
                ),
              ],
            ),
          ),
          
          // NEW: Comment Button/Icon at Bottom Right
          Positioned(
            bottom: 8,
            right: 8,
            child: IconButton(
              icon: const Icon(Icons.comment_outlined, color: Colors.blueGrey),
              onPressed: () => _showCommentSheet(context),
            ),
          ),
        ],
      ),
    );
  }
}