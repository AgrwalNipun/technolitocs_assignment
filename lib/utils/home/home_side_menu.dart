import 'package:assihnment_technolitocs/utils/gallary/gallary.dart';
import 'package:assihnment_technolitocs/utils/ui_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../Groups/all_features.dart';
import '../../screens/explore_page/activity_page/blog_details.dart';
import '../../screens/explore_page/activity_page/api_service.dart'; // Import your fetchBlogDetailsBySlug here

class SideMenuWidget extends StatefulWidget {
  const SideMenuWidget({Key? key}) : super(key: key);

  @override
  State<SideMenuWidget> createState() => _SideMenuWidgetState();
}

class _SideMenuWidgetState extends State<SideMenuWidget> {
  bool initiativesExpanded = false;
  bool projectsExpanded = false;
  bool insightsExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 340,
      height: MediaQuery.of(context).size.height,
      color: UI_COLORS.uiWhiteColor,
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      height: 48,
                      width: 48,
                      child: CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.blue[700],
                        child: const Text(
                          'FJ',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                            fontFamily: 'Mavatif',
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Fanish Jain',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.5,
                            color: Color(0xFF1F2937),
                            fontFamily: 'NotoSans',
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Member, Raipur Chapter',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                            fontFamily: 'NotoSans',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.close, size: 24, color: Colors.black),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 24),

            ListTile(
              leading: Image.asset(
                'assets/images/m1.png',
                color: Colors.black,
                width: 24,
                height: 24,
              ),
              title: const Text('All Features', style: _titleStyle),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AllFeatures()),
                );
              },
            ),

            ExpansionTile(
              initiallyExpanded: initiativesExpanded,
              onExpansionChanged:
                  (val) => setState(() => initiativesExpanded = val),
              leading: Image.asset(
                'assets/images/m2.png',
                color: Colors.black,
                width: 24,
                height: 24,
              ),
              title: const Text('Initiatives', style: _titleStyle),
              trailing: Icon(
                initiativesExpanded
                    ? Icons.keyboard_arrow_up
                    : Icons.keyboard_arrow_down_rounded,
                color: Colors.black,
                size: 20,
              ),
              children: const [
                _SubMenuItem('Robol talks'),
                _SubMenuItem('Coffee Date'),
                _SubMenuItem('Tribe'),
                _SubMenuItem('Robol Film Festival'),
                _SubMenuItem('Robol Conclave'),
                _SubMenuItem('Rolbol Podcast'),
                _SubMenuItem('Robol Retreats'),
              ],
              childrenPadding: const EdgeInsets.only(left: 36),
            ),

            ExpansionTile(
              initiallyExpanded: projectsExpanded,
              onExpansionChanged:
                  (val) => setState(() => projectsExpanded = val),
              leading: const Icon(
                CupertinoIcons.cube,
                size: 20,
                color: Colors.black,
              ),
              title: const Text('Project & CSR', style: _titleStyle),
              trailing: Icon(
                projectsExpanded
                    ? Icons.keyboard_arrow_up
                    : Icons.keyboard_arrow_down_rounded,
                color: Colors.black,
                size: 20,
              ),
              children: const [
                _SubMenuItem('Food Donation'),
                _SubMenuItem('Health Camp'),
                _SubMenuItem('Blood Donation'),
                _SubMenuItem('Girls Safety and Hygiene'),
                _SubMenuItem('Cyber Awareness'),
                _SubMenuItem('Rolbol Skills'),
                _SubMenuItem('Menu Item'),
              ],
              childrenPadding: const EdgeInsets.only(left: 36),
            ),

            ExpansionTile(
              initiallyExpanded: insightsExpanded,
              onExpansionChanged:
                  (val) => setState(() => insightsExpanded = val),
              leading: Image.asset(
                'assets/images/m4.png',
                color: Colors.black,
                width: 24,
                height: 24,
              ),
              title: const Text('Insights', style: _titleStyle),
              trailing: Icon(
                insightsExpanded
                    ? Icons.keyboard_arrow_up
                    : Icons.keyboard_arrow_down_rounded,
                color: Colors.black,
                size: 20,
              ),
              children: [
                _SubMenuItem(
                  'Gallery',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const GalleryPage(),
                      ),
                    );
                  },
                ),
                const _SubMenuItem('Events'),

                // Updated Blogs item with async fetch and navigation
                _SubMenuItem(
                  'Blogs',
                  onTap: () async {
                    // Show a loading dialog while fetching blog data
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder:
                          (_) =>
                              const Center(child: CircularProgressIndicator()),
                    );

                    final blogData = await fetchBlogDetailsBySlug(
                      "mindful-living--take-control-of-stress,-unl...",
                    );

                    Navigator.pop(context); // Remove loading dialog

                    if (blogData != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BlogDetails(blogData: blogData),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Failed to load blog details'),
                        ),
                      );
                    }
                  },
                ),

                const _SubMenuItem('News'),
                const _SubMenuItem('Spotlight'),
                const _SubMenuItem('Poll'),
              ],
              childrenPadding: const EdgeInsets.only(left: 36),
            ),

            ListTile(
              leading: Image.asset(
                'assets/images/m6.png',
                color: Colors.black,
                width: 24,
                height: 24,
              ),
              title: const Text('Profile Inquiries', style: _titleStyle),
              onTap: () {},
            ),

            ListTile(
              leading: Image.asset(
                'assets/images/m7.png',
                color: Colors.black,
                width: 24,
                height: 24,
              ),
              title: const Text('Certificates', style: _titleStyle),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }

  fetchBlogDetailsBySlug(String s) {}
}

const TextStyle _titleStyle = TextStyle(
  fontWeight: FontWeight.w500,
  fontSize: 16,
  color: Colors.black,
  fontFamily: 'NotoSans',
);

class _SubMenuItem extends StatelessWidget {
  final String title;
  final VoidCallback? onTap;

  const _SubMenuItem(this.title, {this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Colors.black,
              fontFamily: 'NotoSans',
            ),
          ),
        ),
      ),
    );
  }
}
