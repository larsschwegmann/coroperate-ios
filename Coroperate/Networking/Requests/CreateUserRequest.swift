//
//  CreateUserRequest.swift
//  Coroperate
//
//  Created by Lars Schwegmann on 22.03.20.
//  Copyright © 2020 Lars Schwegmann. All rights reserved.
//

import Foundation

struct CreateUserRequest {
    let user: User
}

extension CreateUserRequest: APIRequest {
    typealias Response = User

    var resourcePath: String {
        return "/users/"
    }

    var method: HTTPMethod {
        return .POST
    }

    var task: HTTPTask {
        return .requestJSONEncodable(self.user)
    }
}
