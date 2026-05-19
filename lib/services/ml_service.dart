import 'dart:convert';
import 'package:camera/camera.dart';
import 'package:http/http.dart' as http;

class MLService {
  final String _apiKey = '2048CE15-B0E5-4AC4-97AF-27CF112349C7';
  final String _apiUrl =
      'https://innovatechservicesph.com/management/microservices.php?service=vision-analyze';

  /// Analyzes the captured image using the Vision Multi-modal AI.
  /// [mode] can be 'Alphabet', 'Number', or 'Gesture'.
  Future<String> analyzeImage(XFile imageFile, String mode) async {
    try {
      final request = http.MultipartRequest('POST', Uri.parse(_apiUrl));
      request.fields['api_key'] = _apiKey;

      // Specialized FSL Prompts
      String prompt = '';
      if (mode == 'Alphabet') {
        prompt = 'Identify the Filipino Sign Language (FSL) alphabet character shown. '
            'Return ONLY the single uppercase letter. No explanation. Example: "A".';
      } else if (mode == 'Number') {
        prompt = 'Identify the Filipino Sign Language (FSL) number shown. '
            'Return ONLY the number digit. No explanation. Example: "1".';
      } else {
        prompt = 'Identify the Filipino Sign Language (FSL) gesture. '
            'Options: I LOVE YOU, YES, NO, LIKE, HELP, THANK YOU, PLEASE, SORRY, FRIEND, HOUSE. '
            'Return ONLY the uppercase name. No explanation.';
      }

      request.fields['prompt'] = prompt;

      final bytes = await imageFile.readAsBytes();
      request.files.add(
        http.MultipartFile.fromBytes(
          'image',
          bytes,
          filename: 'fsl_capture.jpg',
        ),
      );

      final response = await request.send();
      final responseData = await response.stream.bytesToString();
      final jsonResponse = json.decode(responseData);

      if (jsonResponse['status'] == 'success') {
        String analysis = jsonResponse['analysis']?.toString() ?? 'no match';
        return _cleanAnalysis(analysis);
      } else {
        return 'API Error';
      }
    } catch (e) {
      return 'Connection Failed';
    }
  }

  String _cleanAnalysis(String text) {
    String cleaned = text.trim();
    
    // If response contains "Answer:", extract the part after it
    if (cleaned.contains('Answer:')) {
      cleaned = cleaned.split('Answer:').last.trim();
    } 
    // If response contains "is:", often the answer follow
    else if (cleaned.toLowerCase().contains('is:')) {
       cleaned = cleaned.split(RegExp(r'is:', caseSensitive: false)).last.trim();
    }
    
    // Remove any trailing punctuation if it's a short result
    if (cleaned.length <= 5) {
      cleaned = cleaned.replaceAll(RegExp(r'[.\s]'), '');
    }
    
    // Final check: if it's still long, it might be an unexpected description
    // Most FSL results should be short.
    return cleaned.isEmpty ? 'no match' : cleaned;
  }

  void dispose() {
    // No-op for now
  }
}
