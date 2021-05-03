import 'dart:io';

import 'package:amazon_s3_cognito/amazon_s3_cognito.dart';
import 'package:amazon_s3_cognito/aws_region.dart';

Future<String> uploadToS3(File file, String bucketName) async {
  String format = file.path.split(".").last;

  String uploadedImageUrl = await AmazonS3Cognito.uploadImage(
      file.path,
      bucketName,
      "us-east-1:add1dc33-229e-4f2a-af19-f239438fd463",
     );
  return uploadedImageUrl;
}
