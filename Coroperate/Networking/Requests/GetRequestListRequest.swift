//
//  GetRequestList.swift
//  Coroperate
//
//  Created by Lars Schwegmann on 22.03.20.
//  Copyright © 2020 Lars Schwegmann. All rights reserved.
//

import Foundation

struct GetRequestListRequest {
    let zipCode: String?
}

extension GetRequestListRequest: APIRequest {
    typealias Response = [Request]

    var resourcePath: String {
        return "/requests/"
    }

    var method: HTTPMethod {
        return .GET
    }

    var task: HTTPTask {
        if let zip = self.zipCode {
            return .requestQueryParameters(["zip_code": zip])
        } else {
            return .requestPlain
        }
    }
}
