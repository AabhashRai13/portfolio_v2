# Decision: Newsletter Subscribe Button Placement

Date: 2026-04-27

## Decision

Place the primary newsletter subscribe CTA directly after the blog article body and before the engagement card, comments heading, comment form, and comments list.

In code, this means adding the subscribe card in:

`lib/features/blog_detail/presentation/views/blog_post_detail_page.dart`

Recommended position:

```dart
BlogPostMarkdownCard(
  sections: _post.sections,
  onOpenLink: widget.controller.openLink,
  sectionKeys: _headingKeys,
),
const SizedBox(height: 28),
BlogNewsletterSubscribeCard(...),
const SizedBox(height: 28),
BlogPostEngagementCard(...)
```

## Why

The end of the article is the highest-intent moment in the current blog detail layout. A reader who reaches that point has already consumed the post and received value, so a newsletter ask feels like a natural next step instead of an interruption.

This placement also avoids competing with the article itself. The current page order is:

1. Navigation
2. Post header
3. Optional table of contents
4. Article markdown
5. Engagement card
6. Comments

Putting the subscribe CTA between the article and engagement card keeps it close to the content value moment, before the reader is pulled into lower-conversion actions like liking or commenting.

## Secondary Placements

Use the blog navigation bar as the secondary CTA placement.

The nav already has room, and a subtle `Newsletter` button gives readers an always-visible way to subscribe without interrupting the article. This should be treated as a quiet doorway, not the main conversion moment.

Recommended nav placement:

```text
Logo                         All posts   Newsletter   Theme
```

Implementation notes:

- Place `Newsletter` between `All posts` and the theme toggle.
- Use a mail icon with the `Newsletter` label on desktop.
- On narrow mobile layouts, either hide the nav CTA or use an icon-only mail button with an accessible tooltip.
- Clicking the nav CTA should open a small subscribe dialog or bottom sheet, because the user has intentionally asked for it.
- Keep the end-of-article subscribe card as the primary CTA.

Do not show a full-screen popup on page load. It interrupts the article, can frustrate readers, and may create SEO risk on mobile if it obscures content.

## Copy Guidance

Use a plain label in navigation and benefit-led copy in the primary end-of-article CTA.

Navigation CTA:

- Label: `Newsletter`

Primary end-of-article CTA:

- Headline: `Enjoyed this one?`
- Button: `Send me the next post`

Keep the form low-friction. Email-only is best for the first version.

## Sources

- Liquid Web recommends end-of-post, in-content, and sidebar placements, while warning against too many competing opt-ins: https://www.liquidweb.com/blog/email-subscribe-form/
- MailPoet recommends strategic locations including end of each blog post, footer, and slide-ins, plus clear benefit-focused copy: https://www.mailpoet.com/blog/improve-newsletter-signup-form/
- Google Search Central recommends avoiding intrusive interstitials and using smaller, unobtrusive banners for promotional prompts: https://developers.google.com/search/docs/appearance/avoid-intrusive-interstitials
- Getsitecontrol recommends matching popup or CTA design to the page and using less aggressive formats like slide-ins, teasers, sidebars, and bottom bars: https://getsitecontrol.com/blog/email-newsletter-popup/
