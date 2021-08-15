//
//  ErrorResponse.swift
//  OnTheMap
//
//  Created by Andi Xu on 7/28/21.
//

import Foundation
struct ErrorResponse: Codable, LocalizedError {
    let statusCode: Int
    let statusMessage: String
    
    enum CodingKeys: String, CodingKey {
        case statusCode = "status_code"
        case statusMessage = "status_message"
    }
    
    var errorDescription: String? {
        return statusMessage
    }
}


