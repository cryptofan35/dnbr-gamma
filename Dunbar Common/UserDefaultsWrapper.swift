//
//  UserDefaultsWrapper.swift
//  iOS Keyboard
//
//  Created by George Birch on 9/11/23.
//

import Foundation

public protocol UserDefaultsWrapping {
    
    func storeAccountID(accountID: String)
    func retrieveAccountID() -> String?
    
}

public class UserDefaultsWrapper: UserDefaultsWrapping {
    
    var userDefaults: UserDefaults!
    
    public init() throws {
        userDefaults = UserDefaults(suiteName: "group.com.withdunbar.iOS-Keyboard")
        if userDefaults == nil {
            throw UserDefaultsError.InitializationError
        }
    }
    
    public func storeAccountID(accountID: String) {
        storeItem(key: "accountID", value: accountID)
    }
    
    public func retrieveAccountID() -> String? {
        return retrieveItem(key: "accountID")
    }
    
    private func storeItem(key: String, value: String) {
        userDefaults.set(value, forKey: key)
    }
    
    private func retrieveItem(key: String) -> String? {
        return userDefaults.string(forKey: key)
    }
    
}

enum UserDefaultsError: Error {
    case InitializationError
}
