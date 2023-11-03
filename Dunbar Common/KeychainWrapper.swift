//
//  KeychainWrapper.swift
//  iOS Keyboard
//
//  Created by George Birch on 9/5/23.
//

import Foundation

public protocol KeychainWrapping {
    
    func storeToken(accountName: String, token: String) throws
    func retrieveToken(accountName: String) throws -> String?
    
}

public class KeychainWrapper: KeychainWrapping {
    
    public init() {}
    
    public func storeToken(accountName: String, token: String) throws {
        if try retrieveToken(accountName: accountName) == nil {
            try addToken(accountName: accountName, token: token)
        } else {
            try updateToken(accountName: accountName, token: token)
        }
    }
    
    public func retrieveToken(accountName: String) throws -> String? {
        var query = baseQuery(accountName: accountName)
        query[kSecReturnData] = true
        var queryResult: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &queryResult)
        if status == errSecSuccess {
            let data = queryResult as! Data
            return String(data: data, encoding: .utf8)
        } else if status == errSecItemNotFound {
            return nil
        } else {
            throw KeychainError.KeychainRetrieveError(status)
        }
    }
    
    private func addToken(accountName: String, token: String) throws {
        let attributes = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: "dunbar-keyboard-id-token",
            kSecAttrAccount: accountName,
            kSecValueData: Data(token.utf8)
        ] as [CFString: Any]
        
        let status = SecItemAdd(attributes as CFDictionary, nil)
        guard status == errSecSuccess else { throw KeychainError.KeychainAddError(status) }
    }
    
    private func updateToken(accountName: String, token: String) throws {
        let query = baseQuery(accountName: accountName)
        let attributesToUpdate = [
            kSecAttrAccount: accountName,
            kSecValueData: Data(token.utf8)
        ] as [CFString: Any]
        let status = SecItemUpdate(query as CFDictionary, attributesToUpdate as CFDictionary)
        guard status == errSecSuccess else {
            throw KeychainError.KeychainUpdateError(status)
        }
    }
    
    private func baseQuery(accountName: String) -> [CFString: Any] {
        return [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: "dunbar-keyboard-id-token",
            kSecAttrAccount: accountName
        ] as [CFString: Any]
    }
    
}

enum KeychainError: Error {
    case KeychainAddError(OSStatus)
    case KeychainRetrieveError(OSStatus)
    case KeychainUpdateError(OSStatus)
}
