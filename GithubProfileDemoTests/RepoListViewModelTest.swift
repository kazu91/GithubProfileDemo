//
//  RepoListViewModelTest.swift
//  GithubProfileDemoTests
//
//  Created by Kazu on 24/9/24.
//

import Foundation
import XCTest


class RepoListViewModelTest: XCTestCase {
    var mockAPIClient: MockRepoListAPIClient!
    var githubMockService: GithubService<MockRepoListAPIClient>!
    
    override func setUp() {
        super.setUp()
        mockAPIClient = MockRepoListAPIClient()
        githubMockService = GithubService(apiClient: mockAPIClient)
    }
    
    override func tearDown() {
        super.tearDown()
        mockAPIClient = nil
        githubMockService = nil
    }
    
    func testGetFreshListSuccess() async throws {
        let viewModel = RepoListViewModel(
            service: githubMockService
        )
        
        mockAPIClient.result = .success(testGithubRepoModels)
        
        do {
            try await viewModel.fetchFreshListRepo()
            
            XCTAssertEqual(viewModel.repos.count, 2, "Expected 2 repos in list")
            
            XCTAssertEqual(viewModel.repos[0].language, .java, "Expected Java language")
            XCTAssertEqual(viewModel.repos[1].language, .javaScript, "Expected JavaScript")
            
            XCTAssertEqual(viewModel.repos[0].name, "Repo 1", "Expected Repo 1")
            XCTAssertEqual(viewModel.repos[1].name, "Repo 2", "Expected Repo 2")
            
            XCTAssertEqual(viewModel.repos[0].description, "This is a test repository 1", "Expected Repo 1")
            XCTAssertEqual(viewModel.repos[1].description, "This is a test repository 2", "Expected Repo 2")
            
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
        
    }
    
    func testGetFirstRepoListFailure() async {
        
        let viewModel = RepoListViewModel(
            service: githubMockService
        )
        
        mockAPIClient.result = .failure(.serverError)
        
        do {
            try await viewModel.fetchFreshListRepo()
            
            XCTFail("Expected error to be thrown, but no error was thrown.")
            
        } catch APIError.serverError {
            // Success: Caught the expected error
            XCTAssertEqual(viewModel.repos.count, 0, "Repos should be empty when fetch fails.")
            XCTAssertFalse(viewModel.isLoading, "isLoading should be false after fetch.")
        } catch {
            XCTFail("Unexpected error: \(error)")
            
        }
    }
    
    func testGetFirstRepoListClientFailure() async {
        mockAPIClient.result = .failure(.clientError(message: "Test Client Message"))
        
        let viewModel = RepoListViewModel(
            service: githubMockService
        )
        
        do {
            try await viewModel.fetchFreshListRepo()
            
            XCTFail("Expected error to be thrown, but no error was thrown.")
            
        } catch APIError.clientError(let message) {
            // Success: Caught the expected error
            XCTAssertEqual(message, "Test Client Message")
            XCTAssertEqual(viewModel.repos.count, 0, "Repos should be empty when fetch fails.")
            XCTAssertFalse(viewModel.isLoading, "isLoading should be false after fetch.")
        } catch {
            XCTFail("Unexpected error: \(error)")
            
        }
        
    }
    
    let testGithubRepoModels =
    [
        GithubRepoModel(
            id: 987654,
            nodeID: "MDEwOlJlcG9zaXRvcnkxMjM0NTY=",
            name: "Repo 1",
            fullName: "testuser/TestRepo1",
            githubProjectPrivate: false,
            htmlURL: "https://github.com/testuser/TestRepo",
            description: "This is a test repository 1",
            fork: false,
            url: "https://api.github.com/repos/testuser/TestRepo",
            forksURL: "https://api.github.com/repos/testuser/TestRepo/forks",
            keysURL: "https://api.github.com/repos/testuser/TestRepo/keys{/key_id}",
            collaboratorsURL: "https://api.github.com/repos/testuser/TestRepo/collaborators{/collaborator}",
            teamsURL: "https://api.github.com/repos/testuser/TestRepo/teams",
            hooksURL: "https://api.github.com/repos/testuser/TestRepo/hooks",
            issueEventsURL: "https://api.github.com/repos/testuser/TestRepo/issues/events{/number}",
            eventsURL: "https://api.github.com/repos/testuser/TestRepo/events",
            assigneesURL: "https://api.github.com/repos/testuser/TestRepo/assignees{/user}",
            branchesURL: "https://api.github.com/repos/testuser/TestRepo/branches{/branch}",
            tagsURL: "https://api.github.com/repos/testuser/TestRepo/tags",
            blobsURL: "https://api.github.com/repos/testuser/TestRepo/git/blobs{/sha}",
            gitTagsURL: "https://api.github.com/repos/testuser/TestRepo/git/tags{/sha}",
            gitRefsURL: "https://api.github.com/repos/testuser/TestRepo/git/refs{/sha}",
            treesURL: "https://api.github.com/repos/testuser/TestRepo/git/trees{/sha}",
            statusesURL: "https://api.github.com/repos/testuser/TestRepo/statuses/{sha}",
            languagesURL: "https://api.github.com/repos/testuser/TestRepo/languages",
            stargazersURL: "https://api.github.com/repos/testuser/TestRepo/stargazers",
            contributorsURL: "https://api.github.com/repos/testuser/TestRepo/contributors",
            subscribersURL: "https://api.github.com/repos/testuser/TestRepo/subscribers",
            subscriptionURL: "https://api.github.com/repos/testuser/TestRepo/subscription",
            commitsURL: "https://api.github.com/repos/testuser/TestRepo/commits{/sha}",
            gitCommitsURL: "https://api.github.com/repos/testuser/TestRepo/git/commits{/sha}",
            commentsURL: "https://api.github.com/repos/testuser/TestRepo/comments{/number}",
            issueCommentURL: "https://api.github.com/repos/testuser/TestRepo/issues/comments{/number}",
            contentsURL: "https://api.github.com/repos/testuser/TestRepo/contents/{+path}",
            compareURL: "https://api.github.com/repos/testuser/TestRepo/compare/{base}...{head}",
            mergesURL: "https://api.github.com/repos/testuser/TestRepo/merges",
            archiveURL: "https://api.github.com/repos/testuser/TestRepo/{archive_format}{/ref}",
            downloadsURL: "https://api.github.com/repos/testuser/TestRepo/downloads",
            issuesURL: "https://api.github.com/repos/testuser/TestRepo/issues{/number}",
            pullsURL: "https://api.github.com/repos/testuser/TestRepo/pulls{/number}",
            milestonesURL: "https://api.github.com/repos/testuser/TestRepo/milestones{/number}",
            notificationsURL: "https://api.github.com/repos/testuser/TestRepo/notifications{?since,all,participating}",
            labelsURL: "https://api.github.com/repos/testuser/TestRepo/labels{/name}",
            releasesURL: "https://api.github.com/repos/testuser/TestRepo/releases{/id}",
            deploymentsURL: "https://api.github.com/repos/testuser/TestRepo/deployments",
            createdAt: "2020-01-01T00:00:00Z",
            updatedAt: "2023-09-21T00:00:00Z",
            pushedAt: "2023-09-21T00:00:00Z",
            gitURL: "git://github.com/testuser/TestRepo.git",
            sshURL: "git@github.com:testuser/TestRepo.git",
            cloneURL: "https://github.com/testuser/TestRepo.git",
            svnURL: "https://svn.github.com/testuser/TestRepo",
            homepage: "https://testrepo.com",
            size: 100,
            stargazersCount: 50,
            watchersCount: 50,
            language: .java,
            hasIssues: true,
            hasProjects: true,
            hasDownloads: true,
            hasWiki: true,
            hasPages: false,
            hasDiscussions: true,
            forksCount: 10,
            mirrorURL: nil, // Optional field, can be nil
            archived: false,
            disabled: false,
            openIssuesCount: 5,
            allowForking: true,
            isTemplate: false,
            webCommitSignoffRequired: false,
            topics: ["ios", "swift", "mobile-development"],
            forks: 10,
            openIssues: 5,
            watchers: 50,
            defaultBranch: "main"
        ),
        GithubRepoModel(
            id: 987654,
            nodeID: "MDEwOlJlcG9zaXRvcnkxMjM0NTY=",
            name: "Repo 2",
            fullName: "testuser/TestRepo2",
            githubProjectPrivate: false,
            htmlURL: "https://github.com/testuser/TestRepo2",
            description: "This is a test repository 2",
            fork: false,
            url: "https://api.github.com/repos/testuser/TestRepo",
            forksURL: "https://api.github.com/repos/testuser/TestRepo/forks",
            keysURL: "https://api.github.com/repos/testuser/TestRepo/keys{/key_id}",
            collaboratorsURL: "https://api.github.com/repos/testuser/TestRepo/collaborators{/collaborator}",
            teamsURL: "https://api.github.com/repos/testuser/TestRepo/teams",
            hooksURL: "https://api.github.com/repos/testuser/TestRepo/hooks",
            issueEventsURL: "https://api.github.com/repos/testuser/TestRepo/issues/events{/number}",
            eventsURL: "https://api.github.com/repos/testuser/TestRepo/events",
            assigneesURL: "https://api.github.com/repos/testuser/TestRepo/assignees{/user}",
            branchesURL: "https://api.github.com/repos/testuser/TestRepo/branches{/branch}",
            tagsURL: "https://api.github.com/repos/testuser/TestRepo/tags",
            blobsURL: "https://api.github.com/repos/testuser/TestRepo/git/blobs{/sha}",
            gitTagsURL: "https://api.github.com/repos/testuser/TestRepo/git/tags{/sha}",
            gitRefsURL: "https://api.github.com/repos/testuser/TestRepo/git/refs{/sha}",
            treesURL: "https://api.github.com/repos/testuser/TestRepo/git/trees{/sha}",
            statusesURL: "https://api.github.com/repos/testuser/TestRepo/statuses/{sha}",
            languagesURL: "https://api.github.com/repos/testuser/TestRepo/languages",
            stargazersURL: "https://api.github.com/repos/testuser/TestRepo/stargazers",
            contributorsURL: "https://api.github.com/repos/testuser/TestRepo/contributors",
            subscribersURL: "https://api.github.com/repos/testuser/TestRepo/subscribers",
            subscriptionURL: "https://api.github.com/repos/testuser/TestRepo/subscription",
            commitsURL: "https://api.github.com/repos/testuser/TestRepo/commits{/sha}",
            gitCommitsURL: "https://api.github.com/repos/testuser/TestRepo/git/commits{/sha}",
            commentsURL: "https://api.github.com/repos/testuser/TestRepo/comments{/number}",
            issueCommentURL: "https://api.github.com/repos/testuser/TestRepo/issues/comments{/number}",
            contentsURL: "https://api.github.com/repos/testuser/TestRepo/contents/{+path}",
            compareURL: "https://api.github.com/repos/testuser/TestRepo/compare/{base}...{head}",
            mergesURL: "https://api.github.com/repos/testuser/TestRepo/merges",
            archiveURL: "https://api.github.com/repos/testuser/TestRepo/{archive_format}{/ref}",
            downloadsURL: "https://api.github.com/repos/testuser/TestRepo/downloads",
            issuesURL: "https://api.github.com/repos/testuser/TestRepo/issues{/number}",
            pullsURL: "https://api.github.com/repos/testuser/TestRepo/pulls{/number}",
            milestonesURL: "https://api.github.com/repos/testuser/TestRepo/milestones{/number}",
            notificationsURL: "https://api.github.com/repos/testuser/TestRepo/notifications{?since,all,participating}",
            labelsURL: "https://api.github.com/repos/testuser/TestRepo/labels{/name}",
            releasesURL: "https://api.github.com/repos/testuser/TestRepo/releases{/id}",
            deploymentsURL: "https://api.github.com/repos/testuser/TestRepo/deployments",
            createdAt: "2020-01-01T00:00:00Z",
            updatedAt: "2023-09-21T00:00:00Z",
            pushedAt: "2023-09-21T00:00:00Z",
            gitURL: "git://github.com/testuser/TestRepo.git",
            sshURL: "git@github.com:testuser/TestRepo.git",
            cloneURL: "https://github.com/testuser/TestRepo.git",
            svnURL: "https://svn.github.com/testuser/TestRepo",
            homepage: "https://testrepo.com",
            size: 100,
            stargazersCount: 50,
            watchersCount: 50,
            language: .javaScript,
            hasIssues: true,
            hasProjects: true,
            hasDownloads: true,
            hasWiki: true,
            hasPages: false,
            hasDiscussions: true,
            forksCount: 10,
            mirrorURL: nil, // Optional field, can be nil
            archived: false,
            disabled: false,
            openIssuesCount: 5,
            allowForking: true,
            isTemplate: false,
            webCommitSignoffRequired: false,
            topics: ["ios", "swift", "mobile-development"],
            forks: 10,
            openIssues: 5,
            watchers: 50,
            defaultBranch: "main"
        )
    ]
}
