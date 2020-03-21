//
//  ShoppingList.swift
//  Coroperate
//
//  Created by Lars Schwegmann on 21.03.20.
//  Copyright © 2020 Lars Schwegmann. All rights reserved.
//

import Foundation
import Tagged

struct ShoppingList: Codable {
    typealias Id = Tagged<ShoppingList, Int>

    var items: [ShoppingListItem]
    var maxPrice: Int
    var checked: Bool?
}
