import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter/services.dart';
import '../services/ml_service.dart';
import 'translation_result_screen.dart';

class SignToTextScreen extends StatefulWidget {
  const SignToTextScreen({super.key});

  @override
  State<SignToTextScreen> createState() => _SignToTextScreenState();
}

class _SignToTextScreenState extends State<SignToTextScreen> {
  CameraController? _controller;
  List<CameraDescription>? _cameras;
  final MLService _mlService = MLService();
  String _recognizedText = '';
  final List<String> _history = [];
  bool _isInitialized = false;
  bool _isLoading = false;
  String _currentMode = 'Alphabet';

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    _cameras = await availableCameras();
    if (_cameras != null && _cameras!.isNotEmpty) {
      _controller = CameraController(
        _cameras![0],
        ResolutionPreset.medium,
        enableAudio: false,
      );

      await _controller!.initialize();
      if (mounted) {
        setState(() {
          _isInitialized = true;
        });
      }
    }
  }

  Widget _buildCategoryTab(String mode) {
    bool isSelected = _currentMode == mode;
    return GestureDetector(
      onTap: () => setState(() => _currentMode = mode),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? Colors.transparent : Colors.white24,
          ),
        ),
        child: Text(
          mode,
          style: GoogleFonts.outfit(
            color: isSelected ? const Color(0xFF6200EE) : Colors.white,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Future<void> _captureAndAnalyze() async {
    if (_controller == null || !_controller!.value.isInitialized || _isLoading) {
      return;
    }

    HapticFeedback.mediumImpact();

    setState(() {
      _isLoading = true;
      _recognizedText = '...';
    });

    try {
      final XFile image = await _controller!.takePicture();
      final result = await _mlService.analyzeImage(image, _currentMode);

      if (mounted) {
        setState(() {
          _recognizedText = result;
          if (result != 'no match' && result != 'API Error' && result != 'Connection Failed') {
            _history.add(result);
          }
          _isLoading = false;
        });
        HapticFeedback.lightImpact();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _recognizedText = 'Error';
          _isLoading = false;
        });
      }
    }
  }

  void _copyToClipboard() {
    if (_history.isEmpty) return;
    final text = _history.join(_currentMode == 'Alphabet' ? '' : ' ');
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Copied: $text', style: GoogleFonts.outfit()),
        behavior: SnackBarBehavior.floating,
        backgroundColor: const Color(0xFF6200EE),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _clearHistory() {
    setState(() {
      _history.clear();
      _recognizedText = '';
    });
    HapticFeedback.vibrate();
  }

  @override
  void dispose() {
    _controller?.dispose();
    _mlService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator(color: Colors.white)),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 1. Full Screen Camera Preview
          Center(
            child: CameraPreview(_controller!),
          ),

          // 2. Gradient Overlay
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.6),
                    Colors.transparent,
                    Colors.transparent,
                    Colors.black.withOpacity(0.7),
                  ],

                  stops: const [0.0, 0.2, 0.7, 1.0],
                ),
              ),
            ),
          ),

          // 3. Top Navigation & Tabs
          SafeArea(
            child: Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 18,
                          backgroundColor: Colors.black26,
                          child: IconButton(
                            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 18),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                _buildCategoryTab('Alphabet'),
                                const SizedBox(width: 8),
                                _buildCategoryTab('Number'),
                                const SizedBox(width: 8),
                                _buildCategoryTab('Gesture'),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Clear Button
                        IconButton(
                          icon: const Icon(Icons.delete_outline_rounded, color: Colors.white70, size: 20),
                          constraints: const BoxConstraints(),
                          padding: EdgeInsets.zero,
                          onPressed: _clearHistory,
                        ),
                      ],
                    ),
                    
                    if (_history.isNotEmpty)
                      Container(
                        margin: const EdgeInsets.only(top: 15),
                        height: 50,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _history.length,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          itemBuilder: (context, index) {
                            return Container(
                              margin: const EdgeInsets.only(right: 8),
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(color: Colors.white24),
                              ),
                              child: Center(
                                child: Text(
                                  _history[index],
                                  style: GoogleFonts.outfit(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ).animate().fadeIn().scale(begin: const Offset(0.8, 0.8));
                          },
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),

          // 4. Result & Capture Button
          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: SafeArea(
              top: false,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Recognition Result Card
                  GestureDetector(
                    onTap: _copyToClipboard,
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 18),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.95),
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(color: Colors.black38, blurRadius: 20, offset: const Offset(0, 8)),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  _isLoading ? 'ANALYZING...' : 'LATEST DETECTION',
                                  style: GoogleFonts.outfit(
                                    fontSize: 10,
                                    color: Colors.black45,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 1.5,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _recognizedText.isEmpty ? 'Tap to start' : _recognizedText,
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.outfit(
                                    fontSize: 36,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFF6200EE),
                                  ),
                                ).animate(key: ValueKey(_recognizedText + _isLoading.toString()))
                                 .shimmer(duration: 1.seconds, color: Colors.white.withOpacity(0.5))
                                 .fadeIn().scale(curve: Curves.easeOutBack),
                              ],
                            ),
                          ),
                          if (_history.isNotEmpty)
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: const Color(0xFF6200EE).withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.copy_rounded, color: Color(0xFF6200EE), size: 20),
                            ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Capture Button
                  GestureDetector(
                    onTap: _captureAndAnalyze,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Outer Ring Animation
                        Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white.withOpacity(0.5), width: 2),
                          ),
                        ).animate(onPlay: (controller) => controller.repeat())
                         .scale(begin: const Offset(1, 1), end: const Offset(1.1, 1.1), duration: 1.seconds)
                         .fadeOut(duration: 1.seconds),
                        
                        Container(
                          height: 80,
                          width: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 4),
                            color: Colors.white.withOpacity(0.2),
                          ),
                          padding: const EdgeInsets.all(6),
                          child: Container(
                            decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                            child: _isLoading
                                ? const Padding(
                                    padding: EdgeInsets.all(20.0),
                                    child: CircularProgressIndicator(strokeWidth: 4, color: Color(0xFF6200EE)),
                                  )
                                : const Icon(Icons.camera_rounded, color: Color(0xFF6200EE), size: 40),
                          ),
                        ),
                      ],
                    ),
                  ).animate(target: _isLoading ? 0 : 1).scale(begin: const Offset(0.9, 0.9), end: const Offset(1, 1)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
