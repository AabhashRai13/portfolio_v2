import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_portfolio/app/router/app_routes.dart';
import 'package:my_portfolio/constants/colors.dart';
import 'package:my_portfolio/features/blog_list/presentation/controllers/blog_list_controller.dart';

class BlogListPage extends StatefulWidget {
  const BlogListPage({required this.blogListController, super.key});
  final BlogListController blogListController;

  @override
  State<BlogListPage> createState() => _BlogListPageState();
}

class _BlogListPageState extends State<BlogListPage> {
  late final BlogListController blogListController;

  @override
  void initState() {
    super.initState();
    blogListController = widget.blogListController;
    blogListController.loadBlogs();
  }

  @override
  void dispose() {
    blogListController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Blog'),
        backgroundColor: Colors.white,
        foregroundColor: CustomColor.textPrimary,
        elevation: 0,
      ),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFFF7F0),
              Color(0xFFFFFFFF),
            ],
          ),
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 960),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: ListenableBuilder(
                listenable: blogListController.loadBlogsCommand,
                builder: (context, _) {
                  final command = blogListController.loadBlogsCommand;

                  if (command.isLoading && command.data.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (command.error != null) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            command.error!,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.redAccent,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          FilledButton.tonal(
                            onPressed: blogListController.loadBlogs,
                            child: const Text('Try again'),
                          ),
                        ],
                      ),
                    );
                  }

                  if (command.data.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          const Text(
                            'No blog posts yet.',
                            style: TextStyle(fontSize: 18),
                          ),
                          const SizedBox(height: 16),
                          FilledButton.tonal(
                            onPressed: blogListController.loadBlogs,
                            child: const Text('Refresh'),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.separated(
                    itemCount: command.data.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 18),
                    itemBuilder: (context, index) {
                      final post = command.data[index];

                      return InkWell(
                        borderRadius: BorderRadius.circular(24),
                        onTap: () => context.push(
                          AppRoutes.blogPost(post.slug),
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.05),
                                blurRadius: 18,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: post.tags
                                    .map(
                                      (tag) => Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 6,
                                        ),
                                        decoration: BoxDecoration(
                                          color: CustomColor.primary.withValues(
                                            alpha: 0.08,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            999,
                                          ),
                                        ),
                                        child: Text(
                                          tag,
                                          style: const TextStyle(
                                            color: CustomColor.primary,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    )
                                    .toList(),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                post.title,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w700,
                                  color: CustomColor.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                post.summary,
                                style: const TextStyle(
                                  fontSize: 16,
                                  height: 1.5,
                                  color: CustomColor.textSecondary,
                                ),
                              ),
                              const SizedBox(height: 18),
                              Wrap(
                                spacing: 12,
                                runSpacing: 8,
                                children: [
                                  Text(
                                    '${_formatBlogDate(post.publishedAt)} • '
                                    '${_formatReadTime(post.readTimeMinutes)}',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: CustomColor.secondary,
                                    ),
                                  ),
                                  const Text(
                                    'Read article',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: CustomColor.primary,
                                    ),
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
            ),
          ),
        ),
      ),
    );
  }
}

String _formatBlogDate(DateTime date) {
  const months = <String>[
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  final month = months[date.month - 1];
  return '$month ${date.day}, ${date.year}';
}

String _formatReadTime(int minutes) {
  return '$minutes min read';
}
