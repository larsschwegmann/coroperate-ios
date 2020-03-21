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

    var id: Id
    
    var firstName: String
    var lastName: String

    var lat: Double
    var long: Double
    var range: Double

    var phone: String

    var verified: Bool
}
