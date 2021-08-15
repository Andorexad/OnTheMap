//
//  Udacity.swift
//  OnTheMap
//
//  Created by Andi Xu on 7/28/21.
//

import Foundation
struct UserInfo: Codable {
    let firstName: String
    let lastName: String
    let key: String
    
    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
        case key
    }
}

