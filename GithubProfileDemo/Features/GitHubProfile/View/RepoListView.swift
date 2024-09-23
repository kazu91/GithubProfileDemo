//
//  RepoListView.swift
//  GithubProfileDemo
//
//  Created by Kazu on 23/9/24.
//

import SwiftUI

struct RepoListView: View {
    
    @ObservedObject var viewModel: RepoListViewModel
    
    var body: some View {
        if viewModel.repos.isEmpty {
            VStack {
                if #available(iOS 17.0, *) {
                    ContentUnavailableView{
                        Label("No Repository found", systemImage: "wifi.exclamationmark")
                    } description: {
                        Text("The repository retrieval is currently unavailable. Please attempt again at a later time.")
                    }
                } else {
                    Text("Cannot find any repositories. Please try again later.")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(.black.opacity(0.8))
                    Spacer()
                }
               
            }
        } else {
            LazyVStack(spacing: 20) {
                ForEach(viewModel.repos, id: \.self) { repo in
                    repositoryView(repo: repo)
                        .onAppear {
                            if repo == viewModel.repos.last {
                                Task {
                                    await viewModel.fetchNextListRepo()
                                }
                            }
                        }
                }
                
                if viewModel.isLoading {
                    ProgressView("Loading more...")
                        .padding()
                }
            }
        }
    }
    
    //MARK: Views
    
    func repositoryView(repo: GithubRepoModel) -> some View {
        return VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .center, spacing: 10) {
                Text(repo.name)
                    .font(.system(size: 14, weight: .bold))
                    .lineLimit(1)
                    .foregroundStyle(.blue)
                Spacer()
                Text("Public")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(.black.opacity(0.8))
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .borderRadius(.gray.opacity(0.5), cornerRadius: 10, corners: .allCorners)
            }
            Text(repo.description ?? "Repository doesn't have description.")
                .lineLimit(3)
                .multilineTextAlignment(.leading)
                .font(.system(size: 13, weight: .regular))
                .foregroundStyle(.black.opacity(0.7))
            
            HStack(alignment: .center, spacing: 10) {
                repo.language != nil ?
                languageUsageView(language: repo.language!)
                : nil
                
                starCountView(count: repo.stargazersCount)
                
                forkCountView(count: repo.forksCount)
            }
        }
        .padding()
        .borderRadius(.gray, cornerRadius: 10, corners: .allCorners)
    }
    
    func languageUsageView(language: ProgrammingLanguage) -> some View {
        return HStack(alignment: .center, spacing: 5) {
            Circle()
                .fill(language.color)
                .frame(width: 13, height: 13)
            Text(language.languageName)
                .lineLimit(3)
                .multilineTextAlignment(.leading)
                .font(.system(size: 13, weight: .regular))
                .foregroundStyle(.black.opacity(0.7))
        }
    }
    
    func starCountView(count: Int) -> some View {
        return HStack(alignment: .center, spacing: 5) {
            Text(Image(systemName: "star"))
                .font(.system(size: 13, weight: .semibold))
                .baselineOffset(0)
            Text(count.formattedWithK)
                .lineLimit(3)
                .multilineTextAlignment(.leading)
                .font(.system(size: 13, weight: .regular))
                .foregroundStyle(.black.opacity(0.7))
            
        }
    }
    
    func forkCountView(count: Int) -> some View {
        return HStack(alignment: .center, spacing: 5) {
            Image(.icFork)
                .resizable()
                .frame(width: 16, height: 20)
            Text(count.formattedWithK)
                .lineLimit(3)
                .multilineTextAlignment(.leading)
                .font(.system(size: 13, weight: .regular))
                .foregroundStyle(.black.opacity(0.7))
        }
    }
}

