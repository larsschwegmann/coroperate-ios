//
//  User.swift
//  Coroperate
//
//  Created by Lars Schwegmann on 21.03.20.
//  Copyright © 2020 Lars Schwegmann. All rights reserved.
//

import Foundation
import Tagged

struct User: Codable {
    typealias Id = Tagged<User, Int>

    var id: Id?

    var firstName: String
    var lastName: String

    var username: String
    var password: String?
    var email: String
    var profile: Profile
}

struct Profile: Codable {
    var address: String
    var zipCode: String
    var city: String
}
