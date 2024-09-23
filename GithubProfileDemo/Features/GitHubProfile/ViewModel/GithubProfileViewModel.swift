//
//  GithubProfileViewModel.swift
//  GithubProfileDemo
//
//  Created by Kazu on 23/9/24.
//

import Foundation
import SwiftUI

class GithubProfileViewModel: ObservableObject {
    
    @Published var profile: GithubProfileModel?
    
    @Published var isLoading: Bool = false
        
    let service: GithubServiceProtocol
    
    
    init(service: GithubServiceProtocol = GithubService(apiClient: URLSessionAPIClient<GitHubEndpoint>())) {
        self.service = service
    }
    
    @MainActor
    func fetchProfile(orgName: String) async throws {

        isLoading = true
        defer { isLoading = false }
        
        let model: GithubProfileModel = try await service.getProfile(name: orgName)
        
        self.profile = model
        
    }
}
