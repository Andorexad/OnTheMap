//
//  StudentLocation.swift
//  OnTheMap
//
//  Created by Andi Xu on 7/25/21.
//

import Foundation
import CoreLocation



struct StudentLocation: Codable {
    let objectId: String?
    let uniqueKey: String?
    let firstName: String?
    let lastName: String?
    let mapString: String?
    let mediaURL: String?
    let latitude: Float?
    let longitude: Float?
}

// -- Singleton --
class StudentLocationCollection {
    static var studentLocationCollection = [StudentLocation]()
}
