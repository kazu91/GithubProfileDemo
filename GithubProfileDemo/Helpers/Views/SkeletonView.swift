//
//  SkeletonView.swift
//  GithubProfileDemo
//
//  Created by Kazu on 23/9/24.
//

import SwiftUI


struct SkeletonLoadingHomeView: View {
        
    let frameHeight: CGFloat = 20
    var body: some View {
        VStack {
            HStack(alignment: .top) {
                ShimmerAnimatedView()
                    .frame(width: 120, height: 120)
                    .cornerRadius(25)
                
                VStack(spacing: 30) {
                    ShimmerAnimatedView()
                        .frame(height: frameHeight)
                        .cornerRadius(frameHeight / 2)
                    
                    ShimmerAnimatedView()
                        .frame(height: frameHeight)
                        .cornerRadius(frameHeight / 2)
                        .padding(.trailing, 30)
                    
                    ShimmerAnimatedView()
                        .frame(height: frameHeight)
                        .cornerRadius(frameHeight / 2)
                        
                    
                    ShimmerAnimatedView()
                        .frame(height: frameHeight)
                        .cornerRadius(frameHeight / 2)
                        .padding(.trailing, 30)
                }
                .padding()
                
                
               
            }
            .padding(.horizontal)
           
            Spacer()

            ForEach(0..<3) { _ in
                VStack(alignment: .leading, spacing: 10) {
                    HStack(alignment: .center, spacing: 10) {
                        ShimmerAnimatedView()
                            .frame(height: frameHeight)
                            .cornerRadius(frameHeight / 2)
                            .padding(.bottom, 10)
                        Spacer()
                        ShimmerAnimatedView()
                            .frame(width: 40, height: frameHeight)
                            .cornerRadius(frameHeight / 2)
                            .padding(.bottom, 10)
                    }
                    ShimmerAnimatedView()
                        .frame(height: frameHeight)
                        .cornerRadius(frameHeight / 2)
                        .padding(.bottom, 10)
                    
                    HStack(alignment: .center, spacing: 20) {
                        ShimmerAnimatedView()
                            .frame(width: 50, height: frameHeight)
                            .cornerRadius(frameHeight / 2)
                            .padding(.bottom, 10)
                        
                        ShimmerAnimatedView()
                            .frame(width: 50, height: frameHeight)
                            .cornerRadius(frameHeight / 2)
                            .padding(.bottom, 10)
                        
                        ShimmerAnimatedView()
                            .frame(width: 50, height: frameHeight)
                            .cornerRadius(frameHeight / 2)
                            .padding(.bottom, 10)
                    }
                }
                .padding()
                .borderRadius(.black.opacity(0.2), cornerRadius: 10, corners: .allCorners)
                .padding()
            }
            
            
        }
        .background(Color.gray)
    }
   
}


#Preview {
    SkeletonLoadingHomeView()
}

