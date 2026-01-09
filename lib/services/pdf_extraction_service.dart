import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:flutter/foundation.dart';
import '../models/product_card_model.dart';

class PdfExtractionService {
  // ---------------- CONFIG ----------------
  static final Set<String> headerKeywords = {
    "COMMODITY",
    "SPECIFICATION",
    "PREVAILING",
    "RETAIL",
    "PRICE",
    "UNIT",
    "P/UNIT",
    "DAILY",
    "INDEX",
    "NATIONAL",
    "REGION",
  };

  // IMPROVED: Flexible price pattern to handle spaces or weird formatting at the end
  // Matches: 52.00, 52 . 00, 1,250.00, etc.
  static final RegExp pricePattern = RegExp(r"(\d[\d,\s]*\.\s*\d{2})$");

  static final RegExp percentPattern = RegExp(r"\d.*?%");
  static final RegExp pureSpecPattern = RegExp(
    r"^\d+[,\d]*\s*(ml|l|g|kg|pcs|pc|pack|bottle|box)",
    caseSensitive: false,
  );

  // ---------------- HELPERS ----------------
  static Map<String, String> _extractNameAndSpec(String text) {
    final match = percentPattern.firstMatch(text);
    if (match != null) {
      String name = text.substring(0, match.start).trim();
      String spec = text.substring(match.start).trim();
      return {"name": name, "spec": spec};
    }
    return {"name": text.trim(), "spec": "N/A"};
  }

  static bool _isValidCategory(String line) {
    if (line.isEmpty) return false;
    if (line != line.toUpperCase()) return false;
    if (line.contains(RegExp(r"\d"))) return false;
    if (headerKeywords.any((keyword) => line.contains(keyword))) return false;
    return line.length > 3;
  }

  // ---------------- MAIN EXTRACTION ----------------
  static Future<List<ProductCardModel>> extractProducts(List<int> bytes) async {
    final PdfDocument document = PdfDocument(inputBytes: bytes);
    final PdfTextExtractor extractor = PdfTextExtractor(document);

    List<ProductCardModel> products = [];
    String? currentCategory;

    for (int i = 0; i < document.pages.count; i++) {
      String text = extractor.extractText(startPageIndex: i, endPageIndex: i);
      List<String> lines = text
          .split('\n')
          .map((l) => l.trim())
          .where((l) => l.isNotEmpty)
          .toList();

      for (int j = 0; j < lines.length; j++) {
        String line = lines[j];

        // 1. Skip page markers
        if (line.toLowerCase().startsWith("page")) continue;

        // 2. CATEGORY detection
        if (_isValidCategory(line)) {
          currentCategory = line;
          debugPrint("--- New Category Detected: $currentCategory ---");
          continue;
        }

        if (currentCategory == null) continue;

        // 3. Check if the price is on THIS line
        var priceMatch = pricePattern.firstMatch(line);
        String content = "";
        double? price;

        if (priceMatch != null) {
          content = line.substring(0, priceMatch.start).trim();
          String priceStr = priceMatch
              .group(1)!
              .replaceAll(RegExp(r'[\s,]'), '');
          price = double.tryParse(priceStr);
        }
        // 4. MULTILINE FALLBACK: If no price, check if the NEXT line is just a price
        else if (j + 1 < lines.length) {
          String nextLine = lines[j + 1];
          var nextPriceMatch = pricePattern.firstMatch(nextLine);

          // If the next line is exactly a price (or ends with one)
          if (nextPriceMatch != null && nextLine.length < 15) {
            content = line; // The current line is the name
            String priceStr = nextPriceMatch
                .group(1)!
                .replaceAll(RegExp(r'[\s,]'), '');
            price = double.tryParse(priceStr);
            j++; // Consume the next line so we don't process it again
          }
        }

        // 5. Validation and Cleanup
        if (price == null || price < 5 || content.isEmpty) continue;
        if (headerKeywords.any((k) => content.toUpperCase().contains(k)))
          continue;
        if (pureSpecPattern.hasMatch(content)) continue;

        final result = _extractNameAndSpec(content);

        products.add(
          ProductCardModel(
            category: currentCategory,
            name: result["name"]!,
            spec: result["spec"]!,
            price: price,
          ),
        );
      }
    }

    document.dispose();
    debugPrint("EXTRACTOR FINISHED: Found ${products.length} products.");
    return products;
  }
}
