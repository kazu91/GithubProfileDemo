//
//  ProfileViewModelTest.swift
//  GithubProfileDemoTests
//
//  Created by Kazu on 24/9/24.
//

import Foundation
import XCTest


class ProfileViewModelTest: XCTestCase {
    var mockAPIClient: MockProfileAPIClient!
    var githubMockService: GithubService<MockProfileAPIClient>!
    
    let testGithubProfileModel = GithubProfileModel(
        login: "testuser",
        id: 123456,
        nodeID: "MDQ6VXNlcjU2NzI3",
        url: "https://api.github.com/users/testuser",
        reposURL: "https://api.github.com/users/testuser/repos",
        eventsURL: "https://api.github.com/users/testuser/events",
        hooksURL: "https://api.github.com/users/testuser/hooks",
        issuesURL: "https://api.github.com/users/testuser/issues",
        membersURL: "https://api.github.com/orgs/testuser/members",
        publicMembersURL: "https://api.github.com/orgs/testuser/public_members",
        avatarURL: "https://avatars.githubusercontent.com/u/123456?v=4",
        description: "Test description",
        name: "Test User",
        company: "Test Company",
        blog: "https://testuserblog.com",
        location: "San Francisco, CA",
        email: "testuser@test.com",
        twitterUsername: "testuser",
        isVerified: true,
        hasOrganizationProjects: true,
        hasRepositoryProjects: true,
        publicRepos: 10,
        publicGists: 5,
        followers: 100,
        following: 50,
        htmlURL: "https://github.com/testuser",
        createdAt: "2020-01-01T00:00:00Z",
        updatedAt: "2023-09-21T00:00:00Z",
        archivedAt: nil,
        type: "User"
    )
    
    override func setUp() {
        super.setUp()
        mockAPIClient = MockProfileAPIClient()
        githubMockService = GithubService(apiClient: mockAPIClient)
    }
    
    override func tearDown() {
        super.tearDown()
        mockAPIClient = nil
        githubMockService = nil
    }
    
    func testGetProfileSuccess() async throws {
        let viewModel = GithubProfileViewModel(
            service: githubMockService
        )
        
        mockAPIClient.result = .success(testGithubProfileModel)
        do {
            try await viewModel.fetchProfile(orgName: "Test")
            
            XCTAssertEqual(viewModel.profile?.name, "Test User", "Expected Test User name")
            XCTAssertEqual(viewModel.profile?.blog, "https://testuserblog.com", "Expected https://testuserblog.com")
            XCTAssertEqual(viewModel.profile?.location, "San Francisco, CA", "Expected San Francisco, CA")

        } catch {
            XCTFail("Unexpected error: \(error)")
        }
      
    }
    
    func testGetProfileFailure() async {
        mockAPIClient.result = .failure(.serverError)
        
        let viewModel = GithubProfileViewModel(
            service: githubMockService
        )
        
        do {
            try await viewModel.fetchProfile(orgName: "Test")
            
            XCTFail("Expected error to be thrown, but no error was thrown.")

        } catch APIError.serverError {
            // Success: Caught the expected error
            XCTAssertNil(viewModel.profile, "Profile should be nil when fetch fails.")
            XCTAssertFalse(viewModel.isLoading, "isLoading should be false after fetch.")
        } catch {
            XCTFail("Unexpected error: \(error)")

        }
    }
    
    func testGetProfileClientFailure() async {
        mockAPIClient.result = .failure(.clientError(message: "Test Client Message"))
        let viewModel = GithubProfileViewModel(
            service: githubMockService
        )
        
        do {
            try await viewModel.fetchProfile(orgName: "Test")
            
            XCTFail("Expected error to be thrown, but no error was thrown.")

        } catch APIError.clientError(let message) {
            // Success: Caught the expected error
            XCTAssertEqual(message, "Test Client Message")
            XCTAssertNil(viewModel.profile, "Profile should be nil when fetch fails.")
            XCTAssertFalse(viewModel.isLoading, "isLoading should be false after fetch.")
        } catch {
            XCTFail("Unexpected error: \(error)")

        }
        
    }
}
