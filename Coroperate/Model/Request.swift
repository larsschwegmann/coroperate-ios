//
//  Request.swift
//  Coroperate
//
//  Created by Lars Schwegmann on 21.03.20.
//  Copyright © 2020 Lars Schwegmann. All rights reserved.
//

import Foundation

struct Request: Codable, Hashable {
    var id: Int?
    // Address
    var owner: String?

    var address: String
    var zipCode: String
    var city: String

    var tip: Int
    var date: Date?

    var accepted: User.Id?

    var items: [ShoppingListItem]
}

struct ShoppingListItem: Codable, Hashable {
    var item: String
}
