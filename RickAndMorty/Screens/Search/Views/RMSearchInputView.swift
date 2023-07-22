//
//  RMSearchInputView.swift
//  RickAndMorty
//
//  Created by Arun on 22/07/23.
//

import UIKit

final class RMSearchInputView: UIStackView {
    
    private var viewModel: RMSearchInputViewViewModel? {
        didSet {
            guard let viewModel, viewModel.hasDynamicOptions else { return }
            let options = viewModel.options
            createOptionSelectionViews(with: options)
        }
    }
    
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.searchBarStyle = .minimal
        return searchBar
    }()
    
    private let subStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        stackView.spacing = 6
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.directionalLayoutMargins = .init(
            top: 0,
            leading: 10,
            bottom: 0,
            trailing: 10
        )
        
        return stackView
    }()
    
    public weak var delegate: RMSelectionDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .red
        axis = .vertical
        distribution = .fillEqually
        alignment = .fill
        backgroundColor = .clear
        addArrangedSubview(searchBar)
    }
    
    required init(coder: NSCoder) {
        fatalError("Unsupported !")
    }
    
    public func config(viewModel: RMSearchInputViewViewModel) {
        self.viewModel = viewModel
        searchBar.placeholder = viewModel.searchPlaceholderText
    }
    
    public func presentKeyboard() {
        searchBar.becomeFirstResponder()
    }
    
    private func createOptionSelectionViews(with options: [RMSearchInputViewViewModel.RMDynamicOption]) {
        if !options.isEmpty {
            addArrangedSubview(subStackView)
        }
        for (index, option) in options.enumerated() {
            let button = UIButton()
            button.backgroundColor = .secondarySystemFill
            button.setTitle(option.rawValue, for: .normal)
            button.titleLabel?.font = .preferredFont(forTextStyle: .body)
            button.setTitleColor(.label, for: .normal)
            button.addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)
            button.layer.cornerRadius = 6
            button.tag = index
            subStackView.addArrangedSubview(button)
        }
    }
    
    @objc
    private func didTapButton(_ sender: UIButton) {
        guard let options = viewModel?.options, !options.isEmpty else { return }
        let buttonIndex = sender.tag
        let selectedOption = options[buttonIndex]
        delegate?.didSelect(with: selectedOption)
    }
}
