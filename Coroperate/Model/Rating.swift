//
//  Rating.swift
//  Coroperate
//
//  Created by Lars Schwegmann on 21.03.20.
//  Copyright © 2020 Lars Schwegmann. All rights reserved.
//

import Foundation
import Tagged

struct Rating: Codable {
    typealias Id = Tagged<Rating, Int>

    var id: Id
    var rated: User.Id
    var author: User.Id
    var rating: Int
    var comment: String
}
