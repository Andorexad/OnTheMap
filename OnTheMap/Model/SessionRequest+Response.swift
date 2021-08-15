//
//  SessionResponse.swift
//  OnTheMap
//
//  Created by Andi Xu on 7/27/21.
//

import Foundation

struct Account: Codable {
    let registered: Bool?
    let key: String?
}
struct Session: Codable {
    let id: String?
    let expiration: String?
}

struct AccountLoginRequestModel: Codable {
    let username: String
    let password: String
    enum CodingKeys: String, CodingKey {
        case username
        case password
    }
}

/*struct LogoutSession: Codable {
    let id: String
    let expiration: String
}*/

// MARK: Udacity
//-------------response
struct LoginResponse: Codable {
    let account: Account
    let session: Session
}
struct LogoutResponse: Codable {
    let session: Session
}



//--------------request
struct LoginRequest: Codable {
    let udacity: AccountLoginRequestModel
    enum CodingKeys: String, CodingKey {
        case udacity
    }
}

// MARK: FB

struct FBSessionRequest: Codable {
    let facebookMobile: FBAccessToken
    enum CodingKeys: String, CodingKey {
        case facebookMobile = "facebook_mobile"
    }
}

struct FBAccessToken: Codable {
    let accessToken: String
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
    }
}
