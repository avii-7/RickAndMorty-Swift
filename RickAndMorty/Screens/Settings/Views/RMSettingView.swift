//
//  RMSettingView.swift
//  RickAndMorty
//
//  Created by Arun on 12/07/23.
//

import SwiftUI

struct RMSettingView: View {
    
    private let viewModel: RMSettingViewViewModel
    
    init(viewModel: RMSettingViewViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        List(viewModel.cellViewModels) { model in
            HStack(spacing: 12) {
                if let leftImage = model.image {
                    Image(uiImage: leftImage)
                        .resizable()
                        .renderingMode(.template)
                        .foregroundColor(.white)
                        .frame(width: 18, height: 18)
                        .padding(6)
                        .foregroundColor(.red)
                        .background(Color(uiColor: model.iconContainerColor))
                        .cornerRadius(6)
                }
                Text(model.title)
            }.padding(.init(top: 7, leading: 0, bottom: 7, trailing: 0))
        }
    }
}

struct RMSettingView_Previews: PreviewProvider {
    static var previews: some View {
        RMSettingView(viewModel: .init(
            cellViewModels: RMSettingOption.allCases.compactMap({
                RMSettingCellViewViewModel(type: $0)
            })
        ))
    }
}

