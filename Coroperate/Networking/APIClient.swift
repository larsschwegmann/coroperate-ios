//
//  APIClient.swift
//  Coroperate
//
//  Created by Lars Schwegmann on 21.03.20.
//  Copyright © 2020 Lars Schwegmann. All rights reserved.
//

import Foundation
import AnyCodable
import Combine

public typealias ResultCallback<Value> = (Result<Value, Error>) -> Void

public class APIClient {
    private let baseURL = URL(string: "http://<inserturlhere>")!
    private let session = URLSession(configuration: .default)

    init() {
        // Add some params here
    }

    /// Sends the given request
    func send<T: APIRequest>(_ request: T, completion: @escaping ResultCallback<T.Response>) -> AnyPublisher<APIResponse<T.Response>, Error> {
        let endpoint = self.endpoint(for: request)
        let body = self.body(for: request)

        var urlRequest = URLRequest(url: endpoint)
        urlRequest.httpBody = body
        urlRequest.httpMethod = request.method.rawValue

        return session.dataTaskPublisher(for: urlRequest).tryMap { (data, response) -> APIResponse<T.Response> in
            let value = try JSONDecoder().decode(T.Response.self, from: data)
            return APIResponse(value: value, response: response)
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }

    /// Builds the Request body for the given request
    private func body<T: APIRequest>(for request: T) -> Data? {
        guard request.method != .GET else {
            return nil
        }

        switch request.task {
        case .requestData(let data):
            return data
        case .requestJSONEncodable(let encodable):
            let encoder = JSONEncoder()
            let anyEncodable = AnyEncodable(encodable)
            return try? encoder.encode(anyEncodable)
        case .requestCustomJSONEncodable(let encodable, encoder: let encoder),
             .requestCompositeJSONEncodable(let encodable, encoder: let encoder, queryParameters: _):
            let anyEncodable = AnyEncodable(encodable)
            return try? encoder.encode(anyEncodable)
        default:
            return nil
        }
    }

    /// Builds the URL for the given request
    private func endpoint<T: APIRequest>(for request: T) -> URL {
        guard let endpointURL = URL(string: request.resourcePath, relativeTo: baseURL) else {
            fatalError("Bad path: \(request.resourcePath)")
        }

        switch request.task {
        case .requestQueryParameters(let params),
             .requestComposite(body: _, queryParameters: let params),
             .requestCompositeJSONEncodable(_, encoder: _, queryParameters: let params):
            var components = URLComponents(url: endpointURL, resolvingAgainstBaseURL: true)!
            let queryItems = params.compactMap { param -> URLQueryItem? in
                guard !(param.value is NSNull) else {
                    return nil
                }
                return URLQueryItem(name: param.key, value: String(describing: param.value))
            }
            components.queryItems = queryItems
            return components.url!
        default:
            return endpointURL
        }
    }
}
