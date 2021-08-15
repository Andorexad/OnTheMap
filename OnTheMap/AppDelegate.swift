//
//  AppDelegate.swift
//  OnTheMap
//
//  Created by Andi Xu on 7/25/21.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    //var userEnteredPlace = false
    //var studentLocationCollection = [StudentLocation]()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
  /*  func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        
        let components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        if url == URL(string: "https://auth.udacity.com/sign-up") {
            let loginVC = window?.rootViewController as! LoginViewController
            Client.postSession(username: <#T##String#>, password: <#T##String#>, completion: <#T##(Bool, Error?) -> Void#>)
            
        }
        if components?.scheme == "themoviemanager" && components?.path == "authenticate" {
            let loginVC = window?.rootViewController as! LoginViewController
            _ = TMDBClient.createSessionId(completion: loginVC.handleSessionResponse(success:error:))
        }
        
        return true
    }*/


}

