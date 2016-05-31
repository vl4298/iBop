//
//  UserModelController.swift
//  iBop
//
//  Created by Van Luu on 30/05/2016.
//  Copyright © 2016 Van Luu. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase

class UserModelController {
  private let detail_ref = FIRDatabase.database().reference().child("user_detail")
  private let list_ref = FIRDatabase.database().reference().child("list_user")
  
}