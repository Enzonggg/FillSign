class SignService {
  // Mapping of characters and numbers to asset paths
  static const Map<String, String> _signAssets = {
    // Alphabets
    'A': 'assets/signs/A.jpg',
    'B': 'assets/signs/B.jpg',
    'C': 'assets/signs/C.jpg',
    'D': 'assets/signs/D.jpg',
    'E': 'assets/signs/E.jpg',
    'F': 'assets/signs/F.jpg',
    'G': 'assets/signs/G.jpg',
    'H': 'assets/signs/H.jpg',
    'I': 'assets/signs/I.jpg',
    'J': 'assets/signs/J.jpg',
    'K': 'assets/signs/K.jpg',
    'L': 'assets/signs/L.jpg',
    'M': 'assets/signs/M.jpg',
    'N': 'assets/signs/N.jpg',
    'O': 'assets/signs/O.jpg',
    'P': 'assets/signs/P.jpg',
    'Q': 'assets/signs/Q.jpg',
    'R': 'assets/signs/R.jpg',
    'S': 'assets/signs/S.jpg',
    'T': 'assets/signs/T.jpg',
    'U': 'assets/signs/U.jpg',
    'V': 'assets/signs/V.jpg',
    'W': 'assets/signs/W.jpg',
    'X': 'assets/signs/X.jpg',
    'Y': 'assets/signs/Y.jpg',
    'Z': 'assets/signs/Z.jpg',

    // Numbers
    '0': 'assets/signs/0.jpg',
    '1': 'assets/signs/1.jpg',
    '2': 'assets/signs/2.jpg',
    '3': 'assets/signs/3.jpg',
    '4': 'assets/signs/4.jpg',
    '5': 'assets/signs/5.jpg',
    '6': 'assets/signs/6.jpg',
    '7': 'assets/signs/7.jpg',
    '8': 'assets/signs/8.jpg',
    '9': 'assets/signs/9.jpg',
    ' ': 'assets/signs/space.jpg',
  };

  /// Returns the asset path for a specific character or number.
  /// Returns null if the sign is not found.
  static String? getSignAsset(String char) {
    return _signAssets[char.toUpperCase()];
  }

  /// Parses a string into a list of sign assets.
  static List<String> parseTextToSigns(String text) {
    List<String> assets = [];
    for (int i = 0; i < text.length; i++) {
      String char = text[i];
      if (char == ' ') continue; // Skip spaces for now

      // Handle "10" as a single token if possible, but basic logic:
      String? asset = getSignAsset(char);
      if (asset != null) {
        assets.add(asset);
      }
    }
    return assets;
  }
}
