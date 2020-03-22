//
//  SettingsManager.swift
//  Coroperate
//
//  Created by Lars Schwegmann on 21.03.20.
//  Copyright © 2020 Lars Schwegmann. All rights reserved.
//

import Foundation
import KeychainAccess

fileprivate struct SettingsKeys {
    static let onboardingComplete = "onboarding_complete"
    static let accountType = "account_type" // risiko oder helfer
    static let accessToken = "access_token"
    static let refreshToken = "refresh_token"

    static let userId = "userid"
    static let email = "email"
    static let password = "password"
    static let zipCode = "zip"
    static let firstName = "firstname"
    static let lastName = "lastname"
}

class SettingsManager {
    static let shared = SettingsManager()

    let keychain = Keychain()

    var userId: Int {
        get {
            return UserDefaults.standard.integer(forKey: SettingsKeys.userId)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: SettingsKeys.userId)
            UserDefaults.standard.synchronize()
        }
    }

    var onboardingComplete: Bool {
        get {
            return UserDefaults.standard.bool(forKey: SettingsKeys.onboardingComplete)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: SettingsKeys.onboardingComplete)
            UserDefaults.standard.synchronize()
        }
    }

    var accountType: String? {
        get {
            return UserDefaults.standard.string(forKey: SettingsKeys.accountType)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: SettingsKeys.accountType)
            UserDefaults.standard.synchronize()
        }
    }

    var email: String? {
        get {
            return UserDefaults.standard.string(forKey: SettingsKeys.email)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: SettingsKeys.email)
            UserDefaults.standard.synchronize()
        }
    }

    var zipCode: String? {
        get {
            return UserDefaults.standard.string(forKey: SettingsKeys.zipCode)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: SettingsKeys.zipCode)
            UserDefaults.standard.synchronize()
        }
    }

    var firstName: String? {
        get {
            return UserDefaults.standard.string(forKey: SettingsKeys.firstName)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: SettingsKeys.firstName)
            UserDefaults.standard.synchronize()
        }
    }

    var lastName: String? {
        get {
            return UserDefaults.standard.string(forKey: SettingsKeys.lastName)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: SettingsKeys.lastName)
            UserDefaults.standard.synchronize()
        }
    }

    var password: String? {
        get {
            return keychain[SettingsKeys.password]
        }
        set {
            keychain[SettingsKeys.password] = newValue
        }
    }

    var accessToken: String? {
        get {
            return keychain[SettingsKeys.accessToken]
        }
        set {
            keychain[SettingsKeys.accessToken] = newValue
        }
    }

    var refreshToken: String? {
        get {
            return keychain[SettingsKeys.refreshToken]
        }
        set {
            keychain[SettingsKeys.refreshToken] = newValue
        }
    }

    

    private init() {
    }
}
