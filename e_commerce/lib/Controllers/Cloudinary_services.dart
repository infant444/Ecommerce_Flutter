import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

Future<String?> uploadToCloudinary(XFile? fpr) async {
  if (fpr == null) {
    print("No file is selected");
    return null;
  }
  String cloudName = dotenv.env['CLOUDINARY_NAME'] ?? "";
  var uri = Uri.parse("https://api.cloudinary.com/v1_1/$cloudName/raw/upload");
  var request = http.MultipartRequest("POST", uri);
  var fileBytes = await fpr.readAsBytes();

  var multipartFile = http.MultipartFile.fromBytes(
    'file',
    fileBytes,
    filename: fpr.name,
  );
  request.files.add(multipartFile);
  request.fields['upload_preset'] =
      dotenv.env['CLOUDINARY_CATEGORY_PRESET_NAME'] ?? '';
  request.fields['resource_type'] = "raw";
  var response = await request.send();
  var responseBody = await response.stream.bytesToString();
  print(responseBody);
  if (response.statusCode == 200) {
    var jsonRes = jsonDecode(responseBody);

    print("Upload Successfully");
    return jsonRes["secure_url"];
  }
  print("Upload is failed and the statuscode is ${response.statusCode}");
  return null;
}
