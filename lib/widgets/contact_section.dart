import 'package:flutter/material.dart';
import 'package:my_portfolio/constants/size.dart';
import 'package:my_portfolio/constants/sns_links.dart';

import '../constants/colors.dart';
import 'custom_text_field.dart';
import 'package:url_launcher/url_launcher.dart' as html;

class ContactSection extends StatelessWidget {
  const ContactSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(25, 20, 25, 60),
      color: CustomColor.bgLight1,
      child: Column(
        children: [
          // title
          const Text(
            "Get in touch",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
              color: CustomColor.textPrimary,
            ),
          ),

          const SizedBox(height: 50),
          ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 700,
              maxHeight: 100,
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth >= kMinDesktopWidth) {
                  return buildNameEmailFieldDesktop();
                }

                // else
                return buildNameEmailFieldMobile();
              },
            ),
          ),
          const SizedBox(height: 15),
          // message
          ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 700,
            ),
            child: const CustomTextField(
              hintText: "Your message",
              maxLines: 16,
            ),
          ),
          const SizedBox(height: 20),
          // send button
          ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 700,
            ),
            child: SizedBox(
              width: double.maxFinite,
              child: ElevatedButton(
                onPressed: () {},
                child: const Text("Get in touch"),
              ),
            ),
          ),
          const SizedBox(height: 30),

          ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 300,
            ),
            child: const Divider(),
          ),
          const SizedBox(height: 15),

          // SNS icon button links
          Wrap(
            spacing: 12,
            runSpacing: 12,
            alignment: WrapAlignment.center,
            children: [
              InkWell(
                onTap: () {
                  html.launchUrl(Uri.parse(SnsLinks.github));
                },
                child: Image.asset(
                  "assets/github.png",
                  width: 28,
                ),
              ),
              InkWell(
                onTap: () {
                  html.launchUrl(Uri.parse(SnsLinks.linkedIn));
                },
                child: Image.asset(
                  "assets/linkedin.png",
                  width: 28,
                ),
              ),
              InkWell(
                onTap: () {
                  html.launchUrl(Uri.parse(SnsLinks.facebook));
                },
                child: Image.asset(
                  "assets/facebook.png",
                  width: 28,
                ),
              ),
              InkWell(
                onTap: () {
                  html.launchUrl(Uri.parse(SnsLinks.instagram));
                },
                child: Image.asset(
                  "assets/instagram.png",
                  width: 28,
                ),
              ),
              InkWell(
                onTap: () {
                      html.launchUrl(Uri.parse(SnsLinks.telegram));
                },
                child: Image.asset(
                  "assets/telegram.png",
                  width: 28,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Row buildNameEmailFieldDesktop() {
    return const Row(
      children: [
        // name
        Flexible(
          child: CustomTextField(
            hintText: "Your name",
          ),
        ),
        SizedBox(width: 15),
        // email
        Flexible(
          child: CustomTextField(
            hintText: "Your email",
          ),
        ),
      ],
    );
  }

  Column buildNameEmailFieldMobile() {
    return const Column(
      children: [
        // name
        Flexible(
          child: CustomTextField(
            hintText: "Your name",
          ),
        ),
        SizedBox(height: 15),
        // email
        Flexible(
          child: CustomTextField(
            hintText: "Your email",
          ),
        ),
      ],
    );
  }
}
