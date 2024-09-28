// import 'package:google_ml_kit/google_ml_kit.dart';
// import 'package:image_picker/image_picker.dart';
//
// class ImageOcrHelper {
//   final ImagePicker _picker = ImagePicker();
//   final TextRecognizer _textRecognizer = GoogleMlKit.vision.textRecognizer();
//
//   Future<String?> pickImageAndExtractText() async {
//     final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
//
//     if (pickedFile != null) {
//       final inputImage = InputImage.fromFilePath(pickedFile.path);
//       final RecognizedText recognizedText = await _textRecognizer.processImage(inputImage);
//
//       String extractedText = '';
//       for (TextBlock block in recognizedText.blocks) {
//         for (TextLine line in block.lines) {
//           extractedText += line.text + '\n';
//         }
//       }
//
//       await _textRecognizer.close();  // ปิด TextRecognizer
//
//       // ใช้ RegExp เพื่อค้นหาและกรองเฉพาะตัวเลขทศนิยม
//       final RegExp decimalPattern = RegExp(r'\d+\.\d{2}');
//       final Iterable<Match> matches = decimalPattern.allMatches(extractedText);
//
//       // รวมค่าทศนิยมทั้งหมดเข้าด้วยกัน
//       double totalAmount = matches.map((match) {
//         return double.parse(match.group(0)!);
//       }).reduce((a, b) => a + b);
//
//       // คืนค่าผลรวมของจำนวนเงินในรูปแบบสตริง
//       return totalAmount.toStringAsFixed(2);
//     }
//     return null;
//   }
// }

//************************************************
// import 'package:google_ml_kit/google_ml_kit.dart';
// import 'package:image_picker/image_picker.dart';
//
// class ImageOcrHelper {
//   final ImagePicker _picker = ImagePicker();
//   final TextRecognizer _textRecognizer = GoogleMlKit.vision.textRecognizer();
//
//   Future<String?> pickImageAndExtractText() async {
//     final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
//
//     if (pickedFile != null) {
//       return await extractTextFromImage(pickedFile.path);
//     }
//     return null;
//   }
//
//   Future<String?> extractTextFromImage(String path) async {
//     final inputImage = InputImage.fromFilePath(path);
//     final RecognizedText recognizedText = await _textRecognizer.processImage(inputImage);
//
//     String extractedText = '';
//     for (TextBlock block in recognizedText.blocks) {
//       for (TextLine line in block.lines) {
//         extractedText += line.text + '\n';
//       }
//     }
//
//     await _textRecognizer.close();  // ปิด TextRecognizer
//
//     // ใช้ RegExp เพื่อค้นหาและกรองเฉพาะตัวเลขทศนิยม
//     final RegExp decimalPattern = RegExp(r'\d+\.\d{2}');
//     final Iterable<Match> matches = decimalPattern.allMatches(extractedText);
//
//     // รวมค่าทศนิยมทั้งหมดเข้าด้วยกัน
//     double totalAmount = matches.isNotEmpty
//         ? matches.map((match) {
//       return double.parse(match.group(0)!);
//     }).reduce((a, b) => a + b)
//         : 0.0;
//
//     // คืนค่าผลรวมของจำนวนเงินในรูปแบบสตริง
//     return totalAmount.toStringAsFixed(2);
//   }
// }
//*******************************
import 'package:flutter/services.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';

class ImageOcrHelper {
  final ImagePicker _picker = ImagePicker(); //class ImagePicker มีอยู่แล้ว ใช้เพื่อเอาไว้เลือกรูป _picker เป็นตัวแปรที่เก็บอินสแตนซ์ของ ImagePicker ไว้ และใช้เพื่อเข้าถึงเมธอดต่างๆ ของ ImagePicker เช่น การเลือกภาพจากแกลเลอรีหรือถ่ายภาพด้วยกล้อง
  final TextRecognizer _textRecognizer = TextRecognizer();//class TextRecognizer มีอยู่แล้วเหมือนกัน

  // MethodChannel สำหรับการรับ URI ของรูปภาพที่แชร์
  // static const MethodChannel _channel = MethodChannel("vongola");
  //
  // ImageOcrHelper() {
  //   _channel.setMethodCallHandler((call) async {
  //     if (call.method == 'shareImage') {
  //       String imagePath = call.arguments;
  //       return await extractTextFromImage(imagePath);
  //     }
  //   });
  // }


  Future<String?> pickImageAndExtractText() async { //ฟังก์ชั่นจิ้มรูป
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      return await extractTextFromImage(pickedFile.path);
    }
    return null;
  }

  Future<String?> extractTextFromImage(String path) async {
    final inputImage = InputImage.fromFilePath(path);
    final RecognizedText recognizedText = await _textRecognizer.processImage(inputImage);

    String extractedText = '';
    // for (TextBlock block in recognizedText.blocks) {
    //   for (TextLine line in block.lines) {
    //     print(line.text);
    //     extractedText += line.text + '\n';
    //   }
    // }
    for (TextBlock block in recognizedText.blocks) {
      // วนลูปผ่าน TextLine แต่ละบรรทัดใน block
      for (TextLine line in block.lines) {
        // วนลูปผ่าน TextElement ซึ่งเป็นองค์ประกอบแต่ละคำในบรรทัด
        for (TextElement element in line.elements) {
          print(element.text);
          final RegExp decimalPattern = RegExp(r'(?<!\S)(\d{1,3}(?:,\d{3})*)?\.\d{2}(?!\S)');
          if (decimalPattern.hasMatch(element.text)) {
            print("Matched Decimal: ${element.text}");  // ดูว่าเลขทศนิยมใดถูกจับได้
            extractedText += element.text + '\n ';
          }
        }
      }
      }

    await _textRecognizer.close();  // ปิด TextRecognizer

   // ใช้ RegExp เพื่อค้นหาและกรองเฉพาะตัวเลขทศนิยม
   //  final RegExp decimalPattern = RegExp(r'\d+\.\d{2}');
   //   //final RegExp decimalPattern = RegExp(r'\b\d{1,3}(?:,\d{3})*(?:\.\d{2})?\b');
   //
   //  final Iterable<Match> matches = decimalPattern.allMatches(extractedText);
   //
   //  // รวมค่าทศนิยมทั้งหมดเข้าด้วยกัน
   //  double totalAmount = matches.isNotEmpty
   //      ? matches.map((match) {
   //    return double.parse(match.group(0)!);
   //  }).reduce((a, b) => a + b)
   //      : 0.0;
   //
   //  // คืนค่าผลรวมของจำนวนเงินในรูปแบบสตริง
   //  return totalAmount.toStringAsFixed(2);
    //final RegExp decimalPattern = RegExp(r'\b\d{1,3}(?:,\d{3})*(?:\.\d{2})\b'); // regex สำหรับจับทศนิยมที่ถูกต้อง
    final RegExp decimalPattern = RegExp(r'(จำนวนเงิน)?\s*(\d{1,3}(?:,\d{3})*\.\d{2})\s*');


    final Iterable<Match> matches = decimalPattern.allMatches(extractedText);

// รวมค่าทศนิยมทั้งหมดเข้าด้วยกัน
    double totalAmount = matches.isNotEmpty
        ? matches.map((match) {
      String numberString = match.group(0)!.replaceAll(',', ''); // ลบลูกน้ำออก
      return double.parse(numberString);
    }).reduce((a, b) => a + b)
        : 0.0;

// คืนค่าผลรวมของจำนวนเงินในรูปแบบสตริง
    return totalAmount.toStringAsFixed(2);

//     final RegExp decimalPattern = RegExp(r'\b\d{1,3}(?:,\d{3})*(?:\.\d{2})?\b');
//
//     final Iterable<Match> matches = decimalPattern.allMatches(extractedText);
//
// // รวมค่าทศนิยมทั้งหมดเข้าด้วยกัน
//     double totalAmount = matches.isNotEmpty
//         ? matches.map((match) {
//       String numberString = match.group(0)!.replaceAll(',', ''); // ลบลูกน้ำออก
//       return double.parse(numberString);
//     }).reduce((a, b) => a + b)
//         : 0.0;
//
// // คืนค่าผลรวมของจำนวนเงินในรูปแบบสตริง
//     return totalAmount.toStringAsFixed(2);


  }
  }
