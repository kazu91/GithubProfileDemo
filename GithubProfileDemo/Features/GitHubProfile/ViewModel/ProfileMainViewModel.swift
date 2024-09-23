//
//  ProfileMainViewModel.swift
//  GithubProfileDemo
//
//  Created by Kazu on 23/9/24.
//

import Foundation

class ProfileMainViewModel: ObservableObject {
    
    @Published var profileViewModel = GithubProfileViewModel()
    @Published var repoListViewModel = RepoListViewModel()
    @Published var isLoading = false
    @Published var isError = false
    var errorMessage = ""
    
    var orgName : String {
        Constant.GoogleName
    }
    
    @MainActor
    func loadData() async {
        do {
            isLoading = true
            defer { isLoading = false }
            async let _ = try profileViewModel.fetchProfile(orgName: Constant.GoogleName)
            async let _ = try repoListViewModel.fetchFreshListRepo()
            
            try await profileViewModel.fetchProfile(orgName: Constant.GoogleName)
            try await repoListViewModel.fetchFreshListRepo()
            
        } catch {
            switch error {
            case APIError.clientError(let message):
                errorMessage = message
            case APIError.serverError:
                errorMessage = "Please try again later."
            default:
                errorMessage = error.localizedDescription
            }
            print(error)
            isError = true
        }
    }
    
}
