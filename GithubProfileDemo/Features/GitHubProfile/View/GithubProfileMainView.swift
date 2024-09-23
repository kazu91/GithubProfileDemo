//
//  ContentView.swift
//  GithubProfileDemo
//
//  Created by Kazu on 18/9/24.
//

import SwiftUI
import SDWebImageSwiftUI

struct GithubProfileMainView: View {
    let previewing: Bool
    @State private var scrollOffset: CGFloat = 0
    
    @State private var isShowingLargeHeader: Bool = true
    @State private var isShowingRepoTitle: Bool = true
    
    @StateObject private var viewModel = ProfileMainViewModel()
    
    let maxHeight: CGFloat = 200
    let minHeight: CGFloat = 80
    
    //MARK: - Body
    var body: some View {
        getMainView()
            .alert("Error Occurred", isPresented: $viewModel.isError) {
                Button("Okay") {
                    viewModel.isError.toggle()
                }
            } message: {
                Text(viewModel.errorMessage)
            }
            .task {
                if previewing {
                    return
                }
                await viewModel.loadData()
            }
    }
    
    // MARK: - Functions
    
    private func offsetForHeader() -> CGFloat {
        let offset = scrollOffset
        let extraSpace = minHeight - minHeight
        
        
        if offset < extraSpace {
            return 0
        }
        return -offset
    }
    
    private func heightForHeaderView() -> CGFloat {
        let offset = scrollOffset
        
        return max(minHeight, maxHeight + offset)
        
    }
    
    //
    //MARK: - Views
    @ViewBuilder
    func getMainView() -> some View {
        if viewModel.isLoading {
            SkeletonLoadingHomeView()
        } else {
            if #available(iOS 17.0, *) {
                mainView()
                    .onChange(of: scrollOffset) {
                        isShowingLargeHeader =  scrollOffset < 0 ? false : true
                        isShowingRepoTitle = scrollOffset < -80 ? false : true
                    }
            } else {
                mainView()
                    .onChange(of: scrollOffset) { newValue in
                        isShowingLargeHeader =  newValue < 0 ? false : true
                        isShowingRepoTitle = newValue < -80 ? false : true
                    }
            }
        }
    }
    
    @ViewBuilder
    func mainView() -> some View {
        ObservableScrollView(contentOffset: $scrollOffset) {
            VStack(alignment: .leading, spacing: 0) {
                ProfileView(isShowingLargeHeader: $isShowingLargeHeader, viewModel: viewModel.profileViewModel)
                    .frame(height: heightForHeaderView())
                    .offset(y: -scrollOffset)
                    .zIndex(1000)
                
                Spacer(minLength: 20)
                
                isShowingRepoTitle ? Text("Popular Repositories")
                    .font(.system(size: 15, weight: .medium))
                    .padding(.horizontal)
                : nil
                
                RepoListView(viewModel: viewModel.repoListViewModel)
                    .padding()
            }
        }
        .refreshable {
            Task {
                await viewModel.loadData()
            }
        }
        .padding(.top)
    }
}

#Preview {
    GithubProfileMainView(previewing: true)
}
