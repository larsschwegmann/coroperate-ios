//
//  Request.swift
//  Coroperate
//
//  Created by Lars Schwegmann on 21.03.20.
//  Copyright © 2020 Lars Schwegmann. All rights reserved.
//

import Foundation

struct Request: Codable {
    var shoppingList: ShoppingList.Id

    // Address
    var street: String
    var city: String
    var zipCode: String
    var co: String

    var tip: Int
    var date: Date

    var accepted: User.Id?
}
