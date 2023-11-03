//
//  GoogleSignInService.swift
//  iOS Keyboard
//
//  Created by George Birch on 8/10/23.
//

import GoogleSignIn
import OSLog
import Dunbar_Common

protocol SignInProviding {
    
    func signInButton() -> UIControl
    func addSignOutAction(_: UIButton)
    
}


// TODO:
class GoogleSignInProvider: SignInProviding {
    
    var credentials: NSDictionary?
    
    let dunbarAPI: DunbarAPI
    let keychainWrapper: KeychainWrapping
    let userDefaultsWrapper: UserDefaultsWrapping
    
    let logger = Logger(subsystem: "com.withdunbar.iOS-Keyboard", category: "googleSignInService")
    
    init(dunbarAPI: DunbarAPI, keychainWrapper: KeychainWrapping, userDefaultsWrapper: UserDefaultsWrapping) {
        self.dunbarAPI = dunbarAPI
        self.keychainWrapper = keychainWrapper
        self.userDefaultsWrapper = userDefaultsWrapper
        loadCredentials()
    }
    
    // TODO: investigate if this main thread disk access could ever cause performance issues
    func loadCredentials() {
         if let path = Bundle.main.path(forResource: "credentials", ofType: "plist") {
            credentials = NSDictionary(contentsOfFile: path)
         }
    }
    
    func signInButton() -> UIControl {
        let btn = GIDSignInButton()
        btn.colorScheme = GIDSignInButtonColorScheme.dark
        btn.style = GIDSignInButtonStyle.wide
        btn.addAction(UIAction { [weak self] _ in
            guard let credentials = self?.credentials, let clientID = credentials["CLIENT_ID"] as? String else {
                self?.logger.notice("Unable to retrieve Google Sign In credentials")
                return
            }
            guard let parentVC = self?.findParentViewController(btn) else {
                self?.logger.notice("Unable to find parent VC for Google Sign In button")
                return
            }
            let signInConfig = GIDConfiguration(clientID: clientID)
            GIDSignIn.sharedInstance.signIn(with: signInConfig, presenting: parentVC) { signInResult, error in
                self?.processGoogleSignInResult(signInResult: signInResult, signInError: error)
            }
        }, for: .touchUpInside)
        return btn
    }
    
    func addSignOutAction(_ btn: UIButton) {
        btn.addAction(UIAction { _ in
            GIDSignIn.sharedInstance.signOut()
        }, for: .touchUpInside)
    }
    
    private func findParentViewController(_ view: UIView) -> UIViewController? {
        if let nextResponder = view.next as? UIViewController {
            return nextResponder
        } else if let nextResponder = view.next as? UIView {
            return findParentViewController(nextResponder)
        } else {
            return nil
        }
    }
    
    private func processGoogleSignInResult(signInResult: GIDGoogleUser?, signInError: Error?) {
        guard signInError == nil, let signInResult = signInResult else {
            logger.notice("GIDSignIn returned error: \(signInError)")
            return
        }
        guard let idToken = signInResult.authentication.idToken, let userID = signInResult.userID else {
            logger.notice("Missing Google user ID/token")
            return
        }
        
        // TODO: can potentially remove the Task since this function will already be called as the completion to an async process (not sure)
        Task {
            do {
                let dunbarToken = try await dunbarAPI.signIn(googleToken: idToken)
                try keychainWrapper.storeToken(accountName: userID, token: dunbarToken)
                userDefaultsWrapper.storeAccountID(accountID: userID)
            } catch {
                logger.notice("Error signing into Dunbar and propagating to keychain: \(error)")
            }
        }
        
        #if DEBUG
//        Task {
//            do {
//                let dnbrToken = try await DunbarBackendAPI().signIn(googleToken: idToken)
//                print(dnbrToken)
//                let eventDatas = try await DunbarBackendAPI().getEvents(dnbrToken: dnbrToken)
//                print(eventDatas)
//                await eventReceiptCallback?(eventDatas)
//                for i in 0...5 { try await DunbarBackendAPI().createEvent(name: "testevent\(i)", dnbrToken: dnbrToken)}
//            } catch { print(error) }
//        }
        #endif
    }
    
}
