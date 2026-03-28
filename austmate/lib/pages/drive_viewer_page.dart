import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class DriveViewerPage extends StatefulWidget {
  final String driveUrl;
  final String title;

  const DriveViewerPage({
    super.key,
    required this.driveUrl,
    required this.title,
  });

  @override
  State<DriveViewerPage> createState() => _DriveViewerPageState();
}

class _DriveViewerPageState extends State<DriveViewerPage> {
  late WebViewController controller;
  bool loading = true;

  String getEmbedUrl(String url) {
    if (url.contains("/folders/")) {
      final id = url.split("/folders/")[1].split("?")[0];
      return "https://drive.google.com/embeddedfolderview?id=$id#list";
    }

    if (url.contains("/file/d/")) {
      final id = url.split("/file/d/")[1].split("/")[0];
      return "https://drive.google.com/file/d/$id/preview";
    }

    return url;
  }

  @override
  void initState() {
    super.initState();

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) => setState(() => loading = true),
          onPageFinished: (_) => setState(() => loading = false),
        ),
      )
      ..loadRequest(Uri.parse(getEmbedUrl(widget.driveUrl)));
  }

   @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
       child: Column(
        children: [
          const SizedBox(height: 20), // <-- Add this line!
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 16), // <-- Change top padding to 0
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.title,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.refresh, color: Color(0xFFE53935)),
                  onPressed: () => controller.reload(),
                ),
              ],
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                WebViewWidget(controller: controller),
                if (loading) const Center(child: CircularProgressIndicator()),
              ],
            ),
          ),
        ],
       ),
      ),
    );
  }
}