//
//  CreateRequestRequest.swift
//  Coroperate
//
//  Created by Lars Schwegmann on 22.03.20.
//  Copyright © 2020 Lars Schwegmann. All rights reserved.
//

import Foundation

struct CreateRequestRequest {
    let request: Request
}

extension CreateRequestRequest: APIRequest {
    typealias Response = Request

    var resourcePath: String {
        return "/requests/"
    }

    var method: HTTPMethod {
        return .POST
    }

    var task: HTTPTask {
        return .requestJSONEncodable(self.request)
    }
}
