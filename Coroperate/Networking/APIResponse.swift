//
//  APIResponse.swift
//  Coroperate
//
//  Created by Lars Schwegmann on 21.03.20.
//  Copyright © 2020 Lars Schwegmann. All rights reserved.
//

import Foundation

struct APIResponse<T> {
    let value: T
    let response: URLResponse
}
