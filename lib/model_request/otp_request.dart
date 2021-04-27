/*
 * *
 *  Created by Gayathri , Kanmalai Technologies Pvt. Ltd on 3/30/21 4:43 PM.
 *  Copyright (c) 2021. All rights reserved.
 *  Last modified 3/30/21 2:42 PM by welcome.
 * /
 */
class OTPRequest {
  String userName;
  String otp;

  OTPRequest({this.userName, this.otp});

  OTPRequest.fromJson(Map<String, dynamic> json) {
    // contactNumber = json['grant_type'];
    userName = json['username'];
    otp = json['password'];
    // contactNumber = json['client_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['grant_type'] = "password";
    data['username'] = this.userName;
    data['password'] = this.otp;
    data['client_id'] = "barnabas";
    return data;
  }
}
