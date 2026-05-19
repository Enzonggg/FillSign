import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'text_to_sign_screen.dart';
import 'sign_to_text_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF6200EE),
              Color(0xFF3700B3),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 60),
              // App Logo & Name
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white.withOpacity(0.2)),
                ),
                child: const Icon(
                  Icons.gesture_rounded,
                  size: 80,
                  color: Colors.white,
                ),
              ).animate().scale(duration: 600.ms, curve: Curves.easeOutBack).fadeIn(),
              
              const SizedBox(height: 24),
              Text(
                'FiliSign',
                style: GoogleFonts.outfit(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 2,
                ),
              ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.3),
              
              Text(
                'Filipino Sign Language Translator',
                style: GoogleFonts.outfit(
                  fontSize: 16,
                  color: Colors.white.withOpacity(0.8),
                  fontWeight: FontWeight.w300,
                ),
              ).animate().fadeIn(delay: 400.ms),
              
              const Spacer(),
              
              // Menu Options
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  children: [
                    _MenuCard(
                      title: 'Sign to Text',
                      subtitle: 'Translate FSL gestures in real-time',
                      icon: Icons.camera_alt_rounded,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SignToTextScreen(),
                          ),
                        );
                      },
                      isSecondary: true,
                    ).animate().fadeIn(delay: 600.ms).slideX(begin: -0.1),
                    
                    const SizedBox(height: 20),
                    
                    _MenuCard(
                      title: 'Text to Sign',
                      subtitle: 'Convert words to FSL gestures',
                      icon: Icons.translate_rounded,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const TextToSignScreen(),
                          ),
                        );
                      },
                      isSecondary: true,
                    ).animate().fadeIn(delay: 800.ms).slideX(begin: 0.1),
                  ],
                ),
              ),
              
              const SizedBox(height: 60),
            ],
          ),
        ),
      ),
    );
  }
}

class _MenuCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;
  final bool isSecondary;

  const _MenuCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
    this.isSecondary = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: isSecondary 
              ? Colors.white.withOpacity(0.1) 
              : Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: isSecondary ? [] : [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
            border: Border.all(
              color: isSecondary 
                ? Colors.white.withOpacity(0.2) 
                : Colors.transparent,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isSecondary 
                    ? Colors.white.withOpacity(0.1) 
                    : const Color(0xFF6200EE).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  icon,
                  size: 32,
                  color: isSecondary ? Colors.white : const Color(0xFF6200EE),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.outfit(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: isSecondary ? Colors.white : Colors.black87,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: GoogleFonts.outfit(
                        fontSize: 14,
                        color: isSecondary 
                          ? Colors.white.withOpacity(0.7) 
                          : Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16,
                color: isSecondary 
                  ? Colors.white.withOpacity(0.5) 
                  : Colors.black26,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
