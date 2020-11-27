//
//  LoginViewModel.swift
//  LoginForm
//
//  Created by 윤병진 on 2020/11/27.
//

import Foundation
import RxSwift
import RxCocoa
import FirebaseMessaging
import FirebaseInstanceID

class LoginViewModel {
    
    var model : BehaviorRelay<LoginModel?> = BehaviorRelay<LoginModel?>(value: nil)
    var responseError : BehaviorRelay<String> = BehaviorRelay(value: "")
    var inputId : BehaviorRelay<String?> = BehaviorRelay<String?>(value: nil)
    var inputPhoneNum : BehaviorRelay<String?> = BehaviorRelay<String?>(value: nil)
    private final let enCodeNumber : Int = 71087008440
    
    var idTextCheck : Bool {
        if let idText = inputId.value {
            return !idText.isEmpty
        } else {
            return false
        }
    }
    
    var loginCheck : Int {
        if inputId.value!.isEmpty {
            return 2
        }
        else if inputPhoneNum.value!.isEmpty {
            return 3
        }
        else {
            return 1
        }
    }
    
    func request() {
        InstanceID.instanceID().instanceID { (result, error) in
            if let error = error {
                print("Error fetching remote instance ID: \(error)")
            }
            else if let result = result {
                let parameters = ["mem_id" : self.inputId.value!,
                                  "mem_hp" : self.encodePhoneNumber,
                                  "mem_uuid" : UserDefaults().string(forKey: Constants.macAddress)!,
                                  "token" : result.token]
                //print("token: \(result.token)")
                Api.loginRequest(parameters) { responseData in
                    if responseData is Data {
                        let responseData : Data = responseData as! Data
                        let json : LoginModel? = try? JSONDecoder().decode(LoginModel.self, from: responseData)
                        self.model.accept(json)
                    } else {
                        let responseError = responseData as? Error
                        self.responseError.accept(responseError.debugDescription)
                    }
                }
            }
        }
    }

    var encodePhoneNumber: String {
        if let encodePhoneNumber = Int(inputPhoneNum.value!) {
            return "PMS\(encodePhoneNumber + enCodeNumber)"
        }
        return ""
    }
}
