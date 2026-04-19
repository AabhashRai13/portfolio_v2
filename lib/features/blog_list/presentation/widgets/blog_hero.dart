import 'package:flutter/material.dart';
import 'package:my_portfolio/core/presentation/widgets/theme_toggle_button.dart';
import 'package:my_portfolio/core/resources/styles/blog_palette.dart';
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
    final palette = theme.blogPalette;

    return Column(
      children: <Widget>[
        Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: const EdgeInsets.only(top: 4),
            child: IconTheme(
              data: IconThemeData(color: palette.textMuted),
              child: const ThemeToggleButton(),
            ),
          ),
        ),
        Text(
          'This is where I will write',
          textAlign: TextAlign.center,
          style: theme.textTheme.headlineLarge?.copyWith(
            fontWeight: FontWeight.w800,
            color: palette.textStrong,
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
              color: palette.textMuted,
              height: 1.6,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(height: 48),
        Divider(height: 1, color: palette.dividerSoft),
        const SizedBox(height: 18),
        Row(
          children: <Widget>[
            Text(
              'LATEST STORIES',
              style: theme.textTheme.labelLarge?.copyWith(
                color: palette.textMuted,
                fontWeight: FontWeight.w800,
                letterSpacing: 2,
              ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
              decoration: BoxDecoration(
                color: palette.surfaceElevated,
                borderRadius: BorderRadius.circular(999),
                border: Border.all(color: palette.borderSoft),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<BlogPostSortOrder>(
                  value: sortOrder,
                  icon: Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: palette.textMuted,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  dropdownColor: palette.surfaceElevated,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: palette.textSecondary,
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
