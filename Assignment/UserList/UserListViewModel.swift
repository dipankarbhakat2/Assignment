//
//  UserListViewModel.swift
//  Assignment
//
//  Created by Dipankar Bhakat on 12/10/26.
//

import Foundation

@available(iOS 17.0, *)
@MainActor
@Observable
final class UserListViewModel {
    var users: UserModel?
    var userError: ErrorHandling?
    var shouldShowError = false
    var errorMessage: String?
    var isLoading = false

    // Dependency injection point for fetching users; defaults to WebService
    var fetcher: () async throws -> UserModel = {
        try await WebService.getUsersData()
    }
    //Get user API method to get reault
    func getUsers() async {
        // Begin loading state and reset transient error flags
        isLoading = true
        shouldShowError = false
        errorMessage = nil
        userError = nil
        do {
            let result = try await fetcher()
            // Success: update users and clear errors
            users = result
            isLoading = false
        } catch {
            // Failure: record error details and clear users
            users = nil
            userError = ErrorHandling.custom(error: error)
            errorMessage = error.localizedDescription
            shouldShowError = true
            isLoading = false
        }
    }
}
