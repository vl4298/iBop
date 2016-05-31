//
//  BaseModelController.swift
//  iBop
//
//  Created by Van Luu on 30/05/2016.
//  Copyright © 2016 Van Luu. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase


func firebaseRequest<A>(firebase_ref ref: FIRDatabaseReference, resource: Resource<A>?, failure: FailureHandler?, completion: (A)-> Void) -> FIRDatabaseHandle? {
  guard let resource = resource else {
    failure?(reason: .Other(nil), errorString: "No Resource")
    return nil
  }
  
  let _failure: FailureHandler
  if let failure = failure {
    _failure = failure
  } else {
    _failure = defaultFailureHandler
  }
  
  func processGET(values observeType: FIRDataEventType, getMethod: GETMethod) -> FIRDatabaseHandle? {
    if case GETMethod.Single = getMethod {
      ref.observeSingleEventOfType(observeType, withBlock: { snapData in
        
        if !snapData.exists() {
          _failure(reason: .NoData, errorString: "No Data")
        } else {
          let data = snapData.value as! JSONDictionary
          if let result = resource.parse(data) {
            completion(result)
          }
        }
      })
    }
    
    if case GETMethod.Observe = getMethod {
      let handler = ref.observeEventType(observeType, withBlock: { snapData in
        
        if !snapData.exists() {
          _failure(reason: .NoData, errorString: "No Data")
        } else {
          let data = snapData.value as! JSONDictionary
          if let result = resource.parse(data) {
            completion(result)
          }
        }
      })
      return handler
    }
    
    return nil
  }
  
  func processSET(values values: JSONDictionary) -> FIRDatabaseHandle? {
    ref.setValue(values, withCompletionBlock: { (error, firebase_ref) in
      
      if error != nil {
        _failure(reason: .NoSuccessStatusCode(error: error!), errorString: error?.description)
      } else {
        let _jsonResult = ["result" : "success"]
        if let result = resource.parse(_jsonResult) {
          completion(result)
        }
      }
    })
    return nil
  }
  
  func processUPDATE(values values: JSONDictionary) -> FIRDatabaseHandle? {
    ref.updateChildValues(values, withCompletionBlock: { (error, firebase_ref) in
      
      if error != nil {
        _failure(reason: .NoSuccessStatusCode(error: error!), errorString: error?.description)
      } else {
        let _jsonResult = ["result" : "success"]
        if let result = resource.parse(_jsonResult) {
          completion(result)
        }
      }
    })
    return nil
  }
  
  func processDELETE() -> FIRDatabaseHandle? {
    ref.removeValueWithCompletionBlock({ (error, firebase_ref) in
      if error != nil {
        _failure(reason: .NoSuccessStatusCode(error: error!), errorString: error!.description)
      } else {
        let _jsonResult = ["result" : "success"]
        if let result = resource.parse(_jsonResult) {
          completion(result)
        }
      }
    })
    return nil
  }
  
  switch resource.method {
  case .SET(let values):
    return processSET(values: values)
  case .GET(let getMethod, let observeType):
    return processGET(values: observeType, getMethod: getMethod)
  case .UPDATE(let values):
    return processUPDATE(values: values)
  case .DELETE:
    return processDELETE()
  }
}

func removeHandler(from_ref from: FIRDatabaseReference, handler: FIRDatabaseHandle) {
  from.removeObserverWithHandle(handler)
}
