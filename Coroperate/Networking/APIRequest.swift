//
//  APIRequest.swift
//  Coroperate
//
//  Created by Lars Schwegmann on 21.03.20.
//  Copyright © 2020 Lars Schwegmann. All rights reserved.
//

import Foundation

enum HTTPMethod: String {
    case GET
    case HEAD
    case POST
    case PUT
    case DELETE
    case CONNECT
    case OPTIONS
    case TRACE
    case PATCH
}

enum HTTPTask {
    case requestPlain
    case requestData(Data)
    case requestJSONEncodable(Encodable)
    case requestCustomJSONEncodable(Encodable, encoder: JSONEncoder)
    case requestQueryParameters([String: Any])
    case requestComposite(body: Data, queryParameters: [String: Any])
    case requestCompositeJSONEncodable(Encodable, encoder: JSONEncoder, queryParameters: [String: Any])
}

protocol APIRequest {
    associatedtype Response: Decodable

    var resourcePath: String { get }
    var method: HTTPMethod { get }
    var task: HTTPTask { get }
}
