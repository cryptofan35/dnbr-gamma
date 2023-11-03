//
//  AppDelegate.swift
//  iOS Keyboard
//
//  Created by George Birch on 8/8/23.
//

import UIKit
import GoogleSignIn
import Dunbar_Common

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    // TODO: try! = bad
    let gSignInProvider = GoogleSignInProvider(dunbarAPI: DunbarBackendAPI(), keychainWrapper: KeychainWrapper(), userDefaultsWrapper: try! UserDefaultsWrapper())
    
    func getGoogleSignInProvider() -> SignInProviding {
        return gSignInProvider
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        GIDSignIn.sharedInstance.restorePreviousSignIn { [weak self] user, error in
            // TODO: fill in proper responses for restoring sign-in
            if error != nil || user == nil {
                // Show the app's signed-out state.
            } else {
//                self?.gSignInProvider.signInCompletion(signInResult: user, signInError: error)
            }
        }
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        var handled: Bool
        
        handled = GIDSignIn.sharedInstance.handle(url)
        if handled {
            return true
        }
        
        // Handle other custom URL types.
        
        // If not handled by this app, return false.
        return false
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


}

