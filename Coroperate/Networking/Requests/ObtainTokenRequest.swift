//
//  ObtainTokenRequest.swift
//  Coroperate
//
//  Created by Lars Schwegmann on 22.03.20.
//  Copyright © 2020 Lars Schwegmann. All rights reserved.
//

import Foundation

struct ObtainTokenRequest: Encodable {
    let username: String
    let password: String
}

struct TokenResponse: Decodable {
    let access: String
    let refresh: String
}

extension ObtainTokenRequest: APIRequest {
    typealias Response = TokenResponse

    var resourcePath: String {
        return "/token/"
    }

    var method: HTTPMethod {
        .POST
    }

    var task: HTTPTask {
        .requestJSONEncodable(self)
    }

}
