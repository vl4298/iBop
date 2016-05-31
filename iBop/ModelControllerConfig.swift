//
//  ModelControllerConfig.swift
//  iBop
//
//  Created by Van Luu on 30/05/2016.
//  Copyright © 2016 Van Luu. All rights reserved.
//

import Foundation
import UIKit
import Firebase

public enum Method {
  case GET(GETMethod,FIRDataEventType)
  case SET(JSONDictionary)
  case UPDATE(JSONDictionary)
  case DELETE
}

public enum GETMethod {
  case Single
  case Observe
}

public struct Resource<A> {
  let method: Method
  let parse: JSONDictionary -> A?
}

public enum ErrorCode: String {
  case BlockedByRecipient = "rejected_your_message"
}

public enum Reason: CustomStringConvertible {
  case CouldNotParseJSON
  case NoData
  case NoSuccessStatusCode(error: NSError)
  case Other(NSError?)
  
  public var description: String {
    switch self {
    case .CouldNotParseJSON:
      return "CouldNotParseJSON"
    case .NoData:
      return "NoData"
    case .NoSuccessStatusCode(let error):
      return "NoSuccessStatusCode: \(error.description)"
    case .Other(let error):
      return "Other, Error: \(error)"
    }
  }
}

public typealias FailureHandler = (reason: Reason, errorString: String?) -> Void
public typealias JSONDictionary = [String : AnyObject]

let defaultFailureHandler: FailureHandler = { reason, errorString in
  print("********Failure*******")
  print("reason: \(reason)")
  if let errString = errorString {
    print("errorString : \(errString)")
  }
}