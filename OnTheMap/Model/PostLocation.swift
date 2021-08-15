//
//  PostLocationResponse.swift
//  OnTheMap
//
//  Created by Andi Xu on 7/27/21.
//

import Foundation

struct PostLocationResponse: Codable {
    let createdAt: String?
    let objectId: String?
}

struct PostLocationRequest: Codable {
    let uniqueKey: String?
    let firstName: String?
    let lastName: String?
    let mapString: String?
    let mediaURL: String?
    let latitude: Float?
    let longitude: Float?
}
