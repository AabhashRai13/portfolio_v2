import 'package:flutter/material.dart';
import 'package:my_portfolio/features/blog_list/domain/usecases/get_blog_posts_use_case.dart';

class BlogHero extends StatelessWidget {
  const BlogHero({
    required this.sortOrder,
    required this.onSortChanged,
    super.key,
  });

  final BlogPostSortOrder sortOrder;
  final ValueChanged<BlogPostSortOrder?> onSortChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: <Widget>[
        const SizedBox(height: 10),
        Text(
          'This is where I will write',
          textAlign: TextAlign.center,
          style: theme.textTheme.displaySmall?.copyWith(
            fontWeight: FontWeight.w800,
            color: const Color(0xFF2E241E),
            height: 1.05,
            letterSpacing: -1.2,
          ),
        ),
        const SizedBox(height: 18),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 760),
          child: Text(
            'A place for everything I want to say about software, tech, and '
            'the craft of building things properly, with a pinch of humor, a '
            'little side-eye for bad code, and maybe, for reasons still '
            'unknown, the occasional poem.',
            textAlign: TextAlign.center,
            style: theme.textTheme.titleMedium?.copyWith(
              color: const Color(0xFF8F8074),
              height: 1.6,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(height: 48),
        const Divider(height: 1, color: Color(0xFFF0E5DA)),
        const SizedBox(height: 18),
        Row(
          children: <Widget>[
            Text(
              'LATEST STORIES',
              style: theme.textTheme.labelLarge?.copyWith(
                color: const Color(0xFFB0A195),
                fontWeight: FontWeight.w800,
                letterSpacing: 2,
              ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.86),
                borderRadius: BorderRadius.circular(999),
                border: Border.all(color: const Color(0xFFF0E5DA)),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<BlogPostSortOrder>(
                  value: sortOrder,
                  icon: const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: Color(0xFF8F8074),
                  ),
                  borderRadius: BorderRadius.circular(20),
                  dropdownColor: Colors.white,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: const Color(0xFF7B6C61),
                    fontWeight: FontWeight.w700,
                  ),
                  onChanged: onSortChanged,
                  items: BlogPostSortOrder.values
                      .map(
                        (value) => DropdownMenuItem<BlogPostSortOrder>(
                          value: value,
                          child: Text(value.label),
                        ),
                      )
                      .toList(growable: false),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
