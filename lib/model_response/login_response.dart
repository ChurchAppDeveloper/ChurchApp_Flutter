/*
 * *
 *  Created by Gayathri , Kanmalai Technologies Pvt. Ltd on 3/30/21 4:43 PM.
 *  Copyright (c) 2021. All rights reserved.
 *  Last modified 3/30/21 2:16 PM by welcome.
 * /
 */
class LoginResponse {
  bool success;
  String message;
  String content;

  LoginResponse({this.success, this.message, this.content});

  LoginResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    content = json['content'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['iserror'] = this.success;
    data['message'] = this.message;
    data['content'] = this.content;
    return data;
  }
}
