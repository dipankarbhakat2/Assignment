//
//  AssignmentTests.swift
//  AssignmentTests
//
//  Created by Dipankar Bhakat on 12/10/26.
//

import XCTest
@testable import Assignment

// A protocol to allow dependency injection for fetching users
protocol UsersFetching {
    func fetch() async throws -> UserModel
}
// Test success
struct MockSuccessFetcher: UsersFetching {
    let result: UserModel
    func fetch() async throws -> UserModel { result }
}
// Test failure
struct MockFailureFetcher: UsersFetching {
    struct DummyError: Error, LocalizedError { var errorDescription: String? { "dummy" } }
    func fetch() async throws -> UserModel { throw DummyError() }
}

@MainActor
final class AssignmentTests: XCTestCase {
    
    private var sut: UserListViewModel!

    override func setUp() async throws {
        try await super.setUp()
        // default SUT with a no-op model; we will reassign per-test
        sut = UserListViewModel()
    }
    override func tearDown() async throws {
        sut = nil
        try await super.tearDown()
    }
    //Initial state
    func test_initialState_isEmptyAndNotLoading() async {
        let vm = UserListViewModel()
        XCTAssertNil(vm.users)
        XCTAssertNil(vm.userError)
        XCTAssertFalse(vm.shouldShowError)
        XCTAssertNil(vm.errorMessage)
        XCTAssertFalse(vm.isLoading)
    }
    //Success
    func test_getUsers_success_setsUsersAndStopsLoading() async {
        // Arrange a model and a fetcher that returns it
        let expected = UserModel(users: [])
        let vm = UserListViewModel()
        vm.fetcher = { try await MockSuccessFetcher(result: expected).fetch() }
        // Act
        await vm.getUsers()
        // Assert
        XCTAssertFalse(vm.isLoading, "Loading should be false after success")
        XCTAssertNotNil(vm.users, "Users should be set on success")
        XCTAssertFalse(vm.shouldShowError, "Error flag should be false on success")
        XCTAssertNil(vm.errorMessage, "Error message should be nil on success")
        XCTAssertNil(vm.userError, "UserError should be nil on success")
    }
    //Failure
    func test_getUsers_failure_setsErrorFlagsAndMessage() async {
        let vm = UserListViewModel()
        vm.fetcher = { try await MockFailureFetcher().fetch() }
        await vm.getUsers()
        XCTAssertNil(vm.users)
        XCTAssertNotNil(vm.userError)
        XCTAssertTrue(vm.shouldShowError)
        XCTAssertFalse(vm.isLoading)
        XCTAssertEqual(vm.errorMessage, "dummy")
    }
}
