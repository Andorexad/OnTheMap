//
//  Client.swift
//  OnTheMap
//
//  Created by Andi Xu on 7/25/21.
//

import Foundation

class Client {
    
    // endpoint
    enum Endpoints {
        static let base = "https://onthemap-api.udacity.com/v1"
        
        struct Auth {
            static var accountKey = ""
            static var firstName = ""
            static var lastName = ""
            static var objectID = ""
        }
        
        
        case session
        case getStudentLocation(String)
        case postStudentLocation
        case putStudentLocation(String)
        case getUserData
        case webAuth
        
        
        var stringValue: String {
            switch self {
            case .getStudentLocation(let query):
                return Endpoints.base + "/StudentLocation" + query
            //case .getStudentLocation:
                //return Endpoints.base + "/StudentLocation?limit=100&order=-updatedAt"
            case .postStudentLocation:
                return Endpoints.base + "/StudentLocation"
            case .session:
                return Endpoints.base + "/session"
            case .getUserData:
                return Endpoints.base + "/users/" + Auth.accountKey
            case .putStudentLocation(let objectID):
                return Endpoints.base + "/StudentLocation/" + objectID
            case .webAuth:
                return "https://auth.udacity.com/sign-up."
            }
        }
            
        var url: URL {
            URL(string: self.stringValue)!
        }
    }
    
    class func createQuery(limit: Int?, skip: Int?, order: String?, uniqueKey: String?) -> String {
        var query = ""
        var next = false
        
        if limit != nil || skip != nil || order != nil || uniqueKey != nil {query += "?"}
        
        if let limit = limit {
            query += "limit=\(limit)"
            next = true
        }
        if let skip = skip {
            if next == true { query += "&" }
            query += "skip=\(skip)"
            next = true
        }
            
        if let order = order {
            if next == true { query += "&" }
            query += "order=\(order)"
            next = true
        }
            
        if let uniqueKey = uniqueKey {
            if next == true { query += "&" }
            query += "uniqueKey=\(uniqueKey)"
            next = true
        }
        print("StudentLocation query is \(query)")
        return query
    }
    
    class func taskForGETRequest<ResponseType: Decodable>(url: URL, fromUdacity: Bool, responseType: ResponseType.Type, completion: @escaping (ResponseType?, Error?) -> Void)  {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            var newData = data
            if fromUdacity {
                let range = 5..<data.count
                newData = newData.subdata(in: range)
            }
            
            let decoder = JSONDecoder()
            do {
                let err = try decoder.decode(ResponseType.self, from: newData)
                DispatchQueue.main.async {
                    completion(err, nil)
                }
            } catch {
                do {
                    let errorResponse = try decoder.decode(ErrorResponse.self, from: data) as Error
                    DispatchQueue.main.async {
                        completion(nil, errorResponse)
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(nil, error)
                    }
                }
            }
        }
        task.resume()
        
    }
    
    
    
    class func taskForPOSTRequest<RequestType: Encodable, ResponseType: Decodable>(url: URL, fromUdacity: Bool, post: Bool, responseType: ResponseType.Type, requestType: RequestType, completion: @escaping (ResponseType?, Error?) -> Void) {
        
        var request = URLRequest(url: url)
        if post{
            request.httpMethod = "POST"
        }else {
            request.httpMethod = "PUT"
        }
        
        if fromUdacity{
            request.addValue("application/json", forHTTPHeaderField: "Accept")
        }
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try! JSONEncoder().encode(requestType)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            var newData = data
            if fromUdacity {
                let range = 5..<data.count
                newData = data.subdata(in: range)
            }
            let decoder = JSONDecoder()
            //decoder.dateDecodingStrategy = .iso8601
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: newData)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                do {
                    let errorResponse = try decoder.decode(ErrorResponse.self, from: data) as Error
                    DispatchQueue.main.async {
                        completion(nil, errorResponse)
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(nil, error)
                    }
                }
            }
        }
        task.resume()
    }
    
    
    // MARK: fetch all locations
    class func getStudentLocation(limit: Int? = nil, skip: Int? = nil, order: String? = nil, uniqueKey: String? = nil, completion: @escaping ([StudentLocation], Error?) -> Void) {
        let query = createQuery(limit: limit, skip: skip, order: order, uniqueKey: uniqueKey)
        taskForGETRequest(url: Endpoints.getStudentLocation(query).url, fromUdacity: false, responseType: GetLocationResponse.self) { (response, error) in
            if let response = response {
                completion(response.results, nil)
            } else {
                completion([], error)
            }
        }
    }
    
    // MARK: update or create new location
    class func postOrPutLocation(post: Bool, objectId: String, firstName: String, lastName: String, mapString: String, mediaURL: String, latitude: Float, longitude: Float, completion: @escaping (Bool,Error?) -> Void) {
        let body=PostLocationRequest(uniqueKey: Endpoints.Auth.accountKey, firstName: firstName, lastName: lastName, mapString: mapString, mediaURL: mediaURL, latitude: latitude, longitude: longitude)
        var url = Endpoints.putStudentLocation(objectId).url
        if post {
            url = Endpoints.postStudentLocation.url
        }
        taskForPOSTRequest(url: url, fromUdacity: false, post: true, responseType: PostLocationResponse.self, requestType: body) { (response, error) in
                completion(error==nil, error)
        }
    }
    
    
    // MARK: session
    class func postSession(username: String, password: String, completion: @escaping (Bool,Error?) -> Void){
        let body = LoginRequest(udacity: AccountLoginRequestModel(username: username, password: password))
        taskForPOSTRequest(url: Endpoints.session.url, fromUdacity: true, post: true, responseType: LoginResponse.self, requestType: body) { (response, error) in
            if let response = response {
                Endpoints.Auth.accountKey = response.account.key!
                completion(true, nil)
            } else {
                completion (false, error)
            }
        }
    }
    /*
    class func createFBSessionId(fbToken: String, completion: @escaping (Bool, Error?) -> Void) {
        let body = FBSessionRequest(facebookMobile: FBAccessToken(accessToken: fbToken))
        taskForPOSTRequest(url: EndPoints.session.url, responseType: SessionResponse.self, body: body) { response, error in
            if let response = response {
                print("facebook-udacity session succeeded, now adding to Auth...")
                Auth.sessionId = response.session.id
                Auth.accountKey = response.account.key
                print(Auth.sessionId)
                print(Auth.accountKey)
                completion(true, nil)
            } else {
                print("no SessionResponse")
                completion(false, error)
            }
        }
    }*/
        
    class func deleteSession(completion: @escaping (Bool,Error?) -> Void){
        var request = URLRequest(url: Endpoints.session.url)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
          if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
          request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
          if error == nil {
            Endpoints.Auth.accountKey = ""
            Endpoints.Auth.firstName = ""
            Endpoints.Auth.lastName = ""
            Endpoints.Auth.objectID = ""
            DispatchQueue.main.async {
                completion(true,nil)
            }
          }else{
            DispatchQueue.main.async {
                let range = 5..<data!.count
                let newData = data?.subdata(in: range)
                print(String(data: newData!, encoding: .utf8)!)
                print("Failed to logout\n")
                completion(false,error)
            }
          }
            
        }
        task.resume()
    }
    
    
    class func getUserData(completion: @ escaping (Bool, Error?) -> Void) {
        taskForGETRequest(url: Endpoints.getUserData.url, fromUdacity: true, responseType: UserInfo.self) { (response, error) in
            if let response = response {
                Endpoints.Auth.firstName = response.firstName
                Endpoints.Auth.lastName = response.lastName
                Endpoints.Auth.accountKey = response.key
                completion (true, nil)
            } else {
                print("Failed to get user data\n")
                completion (false, error)
            }
        }
    }
    
    class func getUserDataWithDetail(completion: @escaping (String?, String?, Error?) -> Void) {
        taskForGETRequest(url: Endpoints.getUserData.url, fromUdacity: true, responseType: UserInfo.self) { (response, error) in
            if let response = response {
                completion (response.firstName, response.lastName, nil)
            } else {
                completion (nil,nil,error)
            }
        }
    }
    
    
}






    
