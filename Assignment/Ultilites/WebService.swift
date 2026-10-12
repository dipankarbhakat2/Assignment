//
//  WebService.swift
//  Assignment
//
//  Created by Dipankar Bhakat on 12/10/26.
//

import Foundation

final class WebService {
    static func getUsersData() async throws -> UserModel {
        let urlString =  "https://dummyjson.com/users"
        guard let url = URL(string: urlString) else {
            throw ErrorHandling.invalidURL
        }
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let response = response as? HTTPURLResponse,
                response.statusCode == 200 else {
            throw ErrorHandling.invalidResponse
        }
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(UserModel.self, from: data)
        } catch {
            throw ErrorHandling.invalidData
        }
    }
}
