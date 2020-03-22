//
//  UpdateRequestRequest.swift
//  Coroperate
//
//  Created by Lars Schwegmann on 22.03.20.
//  Copyright © 2020 Lars Schwegmann. All rights reserved.
//

import Foundation

struct UpdateRequestRequest {
    var request: Request
}

extension UpdateRequestRequest: APIRequest {
    typealias Response = Request

    var resourcePath: String {
        return "/requests/\(request.id!)/"
    }

    var method: HTTPMethod {
        .PUT
    }

    var task: HTTPTask {
        return .requestJSONEncodable(self.request)
    }
}
