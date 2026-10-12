//
//  ErrorHandling.swift
//  Assignment
//
//  Created by Dipankar Bhakat on 12/10/26.
//

import Foundation

// Error handling depending on error case
enum ErrorHandling: LocalizedError {
    case invalidURL
    case invalidResponse
    case invalidData
    case custom(error: Error)
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .invalidResponse:
            return "Invalid Response"
        case .invalidData:
            return "Invalid data"
        case .custom(let error):
            return error.localizedDescription
        }
    }
}
