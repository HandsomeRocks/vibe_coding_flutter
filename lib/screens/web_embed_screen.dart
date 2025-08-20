import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:html' as html;
import 'dart:ui' as ui;

class WebEmbedScreen extends StatefulWidget {
  final String title;
  final String url;
  final Map<String, String>? parameters;
  
  const WebEmbedScreen({
    super.key,
    required this.title,
    required this.url,
    this.parameters,
  });

  @override
  State<WebEmbedScreen> createState() => _WebEmbedScreenState();
}

class _WebEmbedScreenState extends State<WebEmbedScreen> {
  bool _isLoading = true;
  bool _hasError = false;
  String _errorMessage = '';
  String _finalUrl = '';
  String _iframeId = '';
  WebViewController? _webViewController;

  @override
  void initState() {
    super.initState();
    _buildUrl();
  }

  void _buildUrl() {
    // Build the final URL with parameters
    String finalUrl = widget.url;
    if (widget.parameters != null && widget.parameters!.isNotEmpty) {
      final queryParams = widget.parameters!.entries
          .map((e) => '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
          .join('&');
      finalUrl += finalUrl.contains('?') ? '&$queryParams' : '?$queryParams';
    }
    _finalUrl = finalUrl;
    _iframeId = 'iframe-${DateTime.now().millisecondsSinceEpoch}';
    
    // Initialize based on platform
    if (kIsWeb) {
      _initializeWebIframe();
    } else {
      _initializeMobileWebView();
    }
  }

  void _initializeWebIframe() {
    // For web platform, show iframe preview
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  void _initializeMobileWebView() {
    // Initialize WebView for mobile platforms
    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading progress
          },
          onPageStarted: (String url) {
            setState(() {
              _isLoading = true;
              _hasError = false;
            });
          },
          onPageFinished: (String url) {
            setState(() {
              _isLoading = false;
            });
          },
          onWebResourceError: (WebResourceError error) {
            setState(() {
              _isLoading = false;
              _hasError = true;
              _errorMessage = 'Failed to load content: ${error.description}';
            });
          },
        ),
      )
      ..loadRequest(Uri.parse(_finalUrl));
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          // Refresh button
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                _isLoading = true;
                _hasError = false;
              });
              if (kIsWeb) {
                _initializeWebIframe();
              } else {
                _webViewController?.reload();
              }
            },
            tooltip: 'Refresh',
          ),
          // Open in browser button (backup option)
          IconButton(
            icon: const Icon(Icons.open_in_browser),
            onPressed: () {
              if (kIsWeb) {
                html.window.open(_finalUrl, '_blank');
              }
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Opening $_finalUrl in browser...'),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
            tooltip: 'Open in Browser',
          ),
        ],
      ),
      body: Stack(
        children: [
          // Web content
          if (!_isLoading && !_hasError)
            _buildWebContent(),
          
          // Loading indicator
          if (_isLoading)
            Container(
              color: Colors.white,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(),
                    const SizedBox(height: 16),
                    Text(
                      'Loading ${widget.title}...',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _finalUrl,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
                          ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          
          // Error message
          if (_hasError)
            Container(
              color: Colors.white,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 64,
                        color: Colors.red[300],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Error Loading Content',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _errorMessage,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.grey[600],
                            ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _finalUrl,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.grey[500],
                              fontFamily: 'monospace',
                            ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton.icon(
                            onPressed: () {
                              setState(() {
                                _isLoading = true;
                                _hasError = false;
                              });
                              if (kIsWeb) {
                                _initializeWebIframe();
                              } else {
                                _webViewController?.reload();
                              }
                            },
                            icon: const Icon(Icons.refresh),
                            label: const Text('Retry'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).colorScheme.primary,
                              foregroundColor: Theme.of(context).colorScheme.onPrimary,
                            ),
                          ),
                          ElevatedButton.icon(
                            onPressed: () {
                              if (kIsWeb) {
                                html.window.open(_finalUrl, '_blank');
                              }
                            },
                            icon: const Icon(Icons.open_in_new),
                            label: const Text('Open in Browser'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue[700],
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildWebContent() {
    if (kIsWeb) {
      // Web platform - create iframe manually in HTML
      return Container(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          children: [
            // Iframe header
            Container(
              padding: const EdgeInsets.all(8),
              color: Colors.grey[100],
              child: Row(
                children: [
                  Icon(Icons.language, color: Colors.grey[600], size: 16),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _finalUrl,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                        fontFamily: 'monospace',
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.open_in_new, size: 16, color: Colors.grey[600]),
                    onPressed: () {
                      html.window.open(_finalUrl, '_blank');
                    },
                    tooltip: 'Open in new tab',
                  ),
                ],
              ),
            ),
            // Iframe container
            Expanded(
              child: Container(
                width: double.infinity,
                color: Colors.white,
                child: Builder(
                  builder: (context) {
                    // Create iframe and inject it into the DOM
                    final iframe = html.IFrameElement()
                      ..src = _finalUrl
                      ..style.border = 'none'
                      ..style.width = '100%'
                      ..style.height = '100%'
                      ..allowFullscreen = true
                      ..allow = 'accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture';
                    
                    // Try to append iframe to a div
                    final divElement = html.DivElement()
                      ..style.width = '100%'
                      ..style.height = '100%'
                      ..append(iframe);
                    
                    // For now, show a placeholder and button to open
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.language,
                            size: 64,
                            color: Colors.blue[700],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'BBB Website Content',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue[700],
                                ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Click to view the content in an iframe',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Colors.grey[600],
                                ),
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton.icon(
                            onPressed: () {
                              // Create a full-screen iframe overlay
                              _createIframeOverlay();
                            },
                            icon: const Icon(Icons.fullscreen),
                            label: const Text('View in Full Screen'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue[700],
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      // Mobile platforms - use WebView
      return Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(8),
        ),
        child: WebViewWidget(controller: _webViewController!),
      );
    }
  }

  void _createIframeOverlay() {
    if (kIsWeb) {
      // Create a full-screen overlay with iframe
      final overlay = html.DivElement()
        ..style.position = 'fixed'
        ..style.top = '0'
        ..style.left = '0'
        ..style.width = '100vw'
        ..style.height = '100vh'
        ..style.backgroundColor = 'white'
        ..style.zIndex = '9999';

      // Create header with close button
      final header = html.DivElement()
        ..style.backgroundColor = '#1976d2'
        ..style.color = 'white'
        ..style.padding = '16px'
        ..style.display = 'flex'
        ..style.justifyContent = 'space-between'
        ..style.alignItems = 'center';

      final title = html.SpanElement()
        ..text = widget.title
        ..style.fontSize = '18px'
        ..style.fontWeight = 'bold';

      final closeButton = html.ButtonElement()
        ..text = '✕'
        ..style.backgroundColor = 'transparent'
        ..style.border = 'none'
        ..style.color = 'white'
        ..style.fontSize = '20px'
        ..style.cursor = 'pointer'
        ..style.padding = '8px'
        ..onClick.listen((event) {
          overlay.remove();
        });

      header.append(title);
      header.append(closeButton);

      // Create iframe
      final iframe = html.IFrameElement()
        ..src = _finalUrl
        ..style.width = '100%'
        ..style.height = 'calc(100vh - 64px)'
        ..style.border = 'none'
        ..allowFullscreen = true
        ..allow = 'accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture';

      overlay.append(header);
      overlay.append(iframe);
      html.document.body?.append(overlay);
    }
  }
}
