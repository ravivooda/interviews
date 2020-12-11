//
//  WebClient.swift
//  ApplePaySecurityTeam
//
//  Created by Ravi Vooda on 12/10/20.
//  Copyright © 2020 Ravi Vooda. All rights reserved.
//

import Foundation

enum RequestMethod: String {
    case get = "GET"
    case unsupported = "UNSUPPORTED"
    // Other are not needed for this project
}

final class WebClient {
    private var baseUrl: String

    init(baseUrl: String) {
        self.baseUrl = baseUrl
    }

    func load(path: String, method: RequestMethod, params: [String: String], completion: @escaping (Any?, Error?) -> ()) -> URLSessionDataTask? {
        guard let request = URLRequest(baseUrl: baseUrl, path: path, method: method, params: params) else { return nil }

        // Sending request to the server.
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            // Parsing incoming data
            var object: Any? = nil
            if let data = data {
                object = try? JSONSerialization.jsonObject(with: data, options: [])
            }

            // We should delay the decision of who is the caller 
            DispatchQueue.main.sync {
                if let httpResponse = response as? HTTPURLResponse, (200..<300) ~= httpResponse.statusCode {
                    completion(object, nil)
                } else {
                    completion(nil, error)
                }
            }
        }

        task.resume()

        return task
    }
}


extension URL {
    init?(baseUrl: String, path: String, params: [String: String], method: RequestMethod) {
        guard var components = URLComponents(string: baseUrl) else {
            return nil
        }
        components.path += path

        switch method {
        case .get:
            components.queryItems = params.map {
                URLQueryItem(name: $0.key, value: String(describing: $0.value))
            }
        default:
            break
        }
        
        guard let url = components.url else {
            return nil
        }

        self = url
    }
}


extension URLRequest {
    init?(baseUrl: String, path: String, method: RequestMethod, params: [String: String]) {
        guard let url = URL(baseUrl: baseUrl, path: path, params: params, method: method) else {
            return nil
        }
        self.init(url: url)
        httpMethod = method.rawValue
        setValue("application/json", forHTTPHeaderField: "Accept")
        setValue("application/json", forHTTPHeaderField: "Content-Type")
    }
}
