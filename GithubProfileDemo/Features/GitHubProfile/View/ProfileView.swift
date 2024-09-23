//
//  ProfileView.swift
//  GithubProfileDemo
//
//  Created by Kazu on 23/9/24.
//

import SwiftUI
import SDWebImageSwiftUI

struct ProfileView: View {
    
    @Binding var isShowingLargeHeader: Bool
    
    @ObservedObject var viewModel: GithubProfileViewModel
    
    var body: some View {
        
        ZStack {
            
            Rectangle().fill(.white.opacity(1))
                .shadow(color: .black, radius: isShowingLargeHeader ? 0 : 2)
            
            HStack(alignment: .top,spacing: 0) {
                WebImage(url: URL(string: viewModel.profile?.avatarURL ?? "")) { image in
                    image.resizable()
                } placeholder: {
                    Rectangle().foregroundColor(.gray)
                }
                .scaledToFit()
                .frame(width: 100)
                .padding()
                .borderRadius(.black, width: 0.5, cornerRadius: 10, corners: .allCorners)
                .padding(.trailing)
                
                VStack(alignment: .leading, spacing: 20) {
                    Text(viewModel.profile?.name ?? "Profile Name")
                        .font(.system(size: 28, weight: .semibold))
                    
                    Text(viewModel.profile?.description ?? "Profile Description")
                        .font(.system(size: 17, weight: .medium))
                        .foregroundStyle(.gray)
                    isShowingLargeHeader ?
                    VStack(alignment: .leading, spacing: 20) {
                        // Follower count
                        HStack(alignment: .bottom, spacing: 5) {
                            Image(systemName: "person.2")
                                .frame(width: 20)
                            HStack(alignment: .lastTextBaseline, spacing: 0) {
                                Text((viewModel.profile?.followers ?? 0).formattedWithK)
                                    .font(.system(size: 16, weight: .bold))
                                    .padding(.trailing, 5)
                                Text("followers")
                                    .font(.system(size: 13))
                                    .foregroundStyle(.gray)
                            }
                        }
                        
                        profileHeadline(icon: "map", title: viewModel.profile?.location ?? "Location")
                        
                        profileHeadline(icon: "link", title: viewModel.profile?.blog ?? "Blog url")
                    }
                    : nil
                }
                
                Spacer()
            }
            .padding()
            .animation(.default, value: isShowingLargeHeader)
        }
        
    }
    
    func profileHeadline(icon: String, title: String) -> some View {
        return HStack(alignment: .bottom, spacing: 5) {
            Image(systemName: icon)
                .frame(width: 20)
            HStack(alignment: .lastTextBaseline, spacing: 0) {
                
                Text(title)
                    .font(.system(size: 14))
                
            }
            
        }
    }

}
