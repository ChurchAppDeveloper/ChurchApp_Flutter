/*
 * *
 *  Created by Gayathri , Kanmalai Technologies Pvt. Ltd on 3/30/21 4:43 PM.
 *  Copyright (c) 2021. All rights reserved.
 *  Last modified 3/30/21 2:42 PM by welcome.
 * /
 */
class LoginRequest {
  String contactNumber;
  String role;
  LoginRequest({this.contactNumber,this.role});

  LoginRequest.fromJson(Map<String, dynamic> json) {
    contactNumber = json['contactNumber'];
    role = json['role'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['contactNumber'] = this.contactNumber;
    data['role'] = this.role;
    return data;
  }
}
