//
//  SecureRegistrationStorage.swift
//  CoLocate
//
//  Created by NHSX.
//  Copyright © 2020 NHSX. All rights reserved.
//

import Foundation
import Security

struct Registration: Codable {
    let id: UUID
    let secretKey: String

    init(id: UUID, secretKey: String) {
        self.id = id
        self.secretKey = secretKey
    }
}

class SecureRegistrationStorage {

    enum Error: Swift.Error {
        case invalidSecretKey
        case keychain(OSStatus)
    }

    // There's no need for this to be a singleton,
    // but this feels more idiomatic.
    static var shared = SecureRegistrationStorage()
    static let secService = "registration"

    func get() throws -> Registration? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: SecureRegistrationStorage.secService,
            kSecReturnAttributes as String: true,
            kSecReturnData as String: true
        ]
        var result: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &result)

        switch status {
        case errSecSuccess: break
        case errSecItemNotFound: return nil
        default: throw Error.keychain(status)
        }

        guard let item = result as? [String : Any],
            let data = item[kSecValueData as String] as? Data,
            let secretKey = String(data: data, encoding: String.Encoding.utf8),
            let idString = item[kSecAttrAccount as String] as? String,
            let id = UUID(uuidString: idString) else {
                // TODO log this error?
                return nil
        }

        return Registration(id: id, secretKey: secretKey)
    }

    func set(registration: Registration) throws {
        guard let secretKey = registration.secretKey.data(using: .utf8) else {
            throw Error.invalidSecretKey
        }

        try clear()

        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: SecureRegistrationStorage.secService,
            kSecAttrAccount as String: registration.id.uuidString,
            kSecValueData as String: secretKey,
        ]
        let status = SecItemAdd(query as CFDictionary, nil)

        guard status == errSecSuccess || status == errSecDuplicateItem else {
            throw Error.keychain(status)
        }
    }

    func clear() throws {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: SecureRegistrationStorage.secService,
        ]
        let status = SecItemDelete(query as CFDictionary)

        guard status == errSecSuccess || status == errSecItemNotFound else {
            throw Error.keychain(status)
        }
    }

}
