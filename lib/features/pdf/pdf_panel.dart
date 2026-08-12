import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:online_course/core/constants/app_colors.dart';
import 'package:online_course/core/service/connectivity/connectivity_checker.dart';
import 'package:online_course/core/service/connectivity/no_internat_page.dart';

class PDFPanel extends StatefulWidget {
  const PDFPanel({super.key});
  static const String routeName = '/pdf-panel';

  @override
  State<PDFPanel> createState() => _PDFPanelState();
}

class _PDFPanelState extends State<PDFPanel> {
  final ScrollController _scrollController = ScrollController();
  double _readingProgress = 0.0;
  static const _platform = MethodChannel('com.example.online_course/secure');

  @override
  void initState() {
    super.initState();
    _setSecureFlag(true);
    _scrollController.addListener(() {
      if (_scrollController.hasClients) {
        final maxScroll = _scrollController.position.maxScrollExtent;
        final currentScroll = _scrollController.position.pixels;
        if (maxScroll > 0) {
          setState(() {
            _readingProgress = currentScroll / maxScroll;
          });
        }
      }
    });
  }

  Future<void> _setSecureFlag(bool enable) async {
    try {
      await _platform.invokeMethod('setSecureFlag', {'enable': enable});
    } on MissingPluginException {
      debugPrint('Secure flag not supported on this platform');
    }
  }

  @override
  void dispose() {
    _setSecureFlag(false);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
     stream: InternetConnectivityChecker().connectionStream,
      initialData: true, // Assume connected initially
      builder: (context, snapshot) {
        // Handle error state
        if (snapshot.hasError) {
          return const NoInternetPage();
        }

        // Handle disconnected state
        if (snapshot.data == false) {
          return const NoInternetPage();
        }

        // Handle loading state
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        return Scaffold(
          backgroundColor: const Color(0xFFFAF9F6), // Off-white "paper" color
          appBar: AppBar(
            backgroundColor: AppColors.primaryBlue,
            foregroundColor: AppColors.darkGrey,
            elevation: 0,
            title: Column(
              children: [
                const Text(
                  'Chapter 1',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  'Introduction to Flutter',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, size: 20, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
            // actions: [
            //   IconButton(
            //     icon: const Icon(Icons.bookmark_border, size: 22),
            //     onPressed: () {},
            //   ),
            //   IconButton(
            //     icon: const Icon(Icons.text_fields, size: 22),
            //     onPressed: () {},
            //   ),
            // ],
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(2),
              child: LinearProgressIndicator(
                value: _readingProgress,
                backgroundColor: Colors.grey[200],
                color: AppColors.primaryBlue,
                minHeight: 2,
              ),
            ),
          ),
          body: SingleChildScrollView(
            controller: _scrollController,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Introduction to Flutter & Dart',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    height: 1.2,
                    color: Color(0xFF2C3E50),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    CircleAvatar(
                      radius: 16,
                      backgroundColor: AppColors.primaryBlue.withValues(alpha: 0.1),
                      child: Icon(
                        Icons.person,
                        size: 16,
                        color: AppColors.primaryBlue,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'By T4 Flutter Team',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '2 Days read',
                      style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                _buildParagraph(
                  'Welcome to the exciting world of cross-platform mobile development! In this comprehensive guide, we will explore the foundational concepts of Flutter and its programming language, Dart. By the end of this chapter, you will have a solid understanding of how Flutter revolutionizes UI creation.',
                  isFirstParagraph: true,
                ),
                _buildSubHeading('What is Flutter?'),
                _buildParagraph(
                  'Flutter is an open-source UI software development kit created by Google. It is used to develop cross-platform applications for Android, iOS, Linux, macOS, Windows, Google Fuchsia, and the web from a single codebase.',
                ),
                _buildParagraph(
                  'Unlike other frameworks that use web views or OEM widgets, Flutter provides its own rendering engine. This means your app will look and behave consistently across all devices, eliminating the common headaches of fragmented UI development.',
                ),
                _buildQuote(
                  '"Flutter allows you to build beautiful, natively compiled applications from a single codebase."',
                ),
                _buildSubHeading('The Power of Dart'),
                _buildParagraph(
                  'Flutter is powered by Dart, a client-optimized language for fast apps on any platform. Dart is designed to be familiar to developers who already know languages like C#, Java, or JavaScript.',
                ),
                _buildParagraph(
                  'One of Dart\'s strongest features is its capability to compile Ahead-Of-Time (AOT) for fast, predictable native performance, while also supporting Just-In-Time (JIT) compilation for exceptionally fast development cycles with Stateful Hot Reload.',
                ),
                _buildSubHeading('Everything is a Widget'),
                _buildParagraph(
                  'The core philosophy of Flutter is that everything is a widget. Whether it is a button, a layout container, a piece of text, or an entire screen, you build your UI by combining these widgets together.',
                ),
                _buildParagraph(
                  'This composition-based approach offers immense flexibility. You can easily create complex, custom UIs without having to write custom platform-specific code. Widgets form a tree hierarchy where each widget nests inside a parent and inherits properties from its context.',
                ),
                const SizedBox(height: 40),
                Center(
                  child: Text(
                    '~ End of Chapter 1 ~',
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      color: Colors.grey[500],
                    ),
                  ),
                ),
                const SizedBox(height: 60),
              ],
            ),
          ),
        );
      }
    );
  }

  Widget _buildParagraph(String text, {bool isFirstParagraph = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 18,
          height: 1.8, // Good line height for readability
          color: Color(0xFF34495E),
          letterSpacing: 0.3,
          fontFamily: 'Georgia', // Serif font for book-like feel
        ),
        textAlign: TextAlign.justify,
      ),
    );
  }

  Widget _buildSubHeading(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          height: 1.3,
          color: Color(0xFF2C3E50),
        ),
      ),
    );
  }

  Widget _buildQuote(String text) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 8.0),
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(color: AppColors.primaryBlue, width: 4.0),
        ),
        color: AppColors.primaryBlue.withValues(alpha: 0.05),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 18,
          fontStyle: FontStyle.italic,
          height: 1.6,
          color: AppColors.primaryBlue,
        ),
      ),
    );
  }
}
