//
//  SettingView.swift
//  RickAndMorty
//
//  Created by Arun on 12/07/23.
//

import SwiftUI
import StoreKit

struct SettingView: View {
    
    @Environment(\.openURL) private var openURL
    
    var body: some View {
        NavigationStack {
            content
                .navigationTitle("Settings")
        }
    }
    
    private var content: some View {
        List(SettingOption.allCases) { option in
            
            HStack(spacing: 12) {
                Image(systemName: option.systemImageName)
                    .resizable()
                    .renderingMode(.template)
                    .foregroundColor(.white)
                    .frame(width: 18, height: 18)
                    .padding(6)
                    .foregroundColor(.red)
                    .background(option.imageContainerColor)
                    .cornerRadius(6)
                
                Text(option.displayTitle)
                
                Spacer()
            }
            .padding(.vertical, 7)
            .onTapGesture {
                if let url = option.targetUrl {
                    if #available(iOS 26.0, *) {
                        openURL(url, prefersInApp: true)
                    } else {
                        openURL(url)
                    }
                }
                else if option == .rateApp {
                    requestReview()
                }
            }
        }
    }
    
    private func requestReview() {
        if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            SKStoreReviewController.requestReview(in: scene)
        }
    }
}

#Preview {
    SettingView()
}
