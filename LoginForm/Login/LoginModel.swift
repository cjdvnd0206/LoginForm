//
//  LoginModel.swift
//  LoginForm
//
//  Created by 윤병진 on 2020/11/27.
//

import Foundation

struct LoginModel: Codable {
    
    var responseCode : Int = 0
    var information : LoginInformations?

    enum CodingKeys : String, CodingKey {
        case responseCode = "rt_code"
        case information = "information"
    }
    
    init(from decoder: Decoder) throws {
        let unkeyedContainer = try decoder.container(keyedBy: CodingKeys.self)
        responseCode = try unkeyedContainer.decode(Int.self, forKey : .responseCode)
        information = try? unkeyedContainer.decode(LoginInformations.self, forKey : .information)
    }
}

struct LoginInformations: Codable {
    
    var memName : String = ""
    var memCName : String = ""
    var memLevel : String = ""
    var memArea : String = ""
    
    enum CodingKeys : String, CodingKey {
        case memName = "mem_name"
        case memCName = "mem_c_name"
        case memLevel = "mem_level"
        case memArea = "mem_area"
    }
}
