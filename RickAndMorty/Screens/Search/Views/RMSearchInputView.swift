//
//  RMSearchInputView.swift
//  RickAndMorty
//
//  Created by Arun on 22/07/23.
//

import UIKit

@MainActor
protocol RMSearchBarDelegate: AnyObject {
    
    func rmSearchInputView(_ inputView: RMSearchInputView, didChangeSearchText text: String)
    
    func rmSearchInputView_DidTapCrossButton(_ inputView: RMSearchInputView)
    
    func rmSearchInputView_DidTapSearchKeyboardButton(_ inputView: RMSearchInputView)
}

final class RMSearchInputView: UIStackView {
    
    private var viewModel: RMSearchInputViewViewModel? {
        didSet {
            guard let viewModel, !viewModel.options.isEmpty else { return }
            let options = viewModel.options
            createOptionSelectionViews(with: options)
        }
    }
    
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.searchBarStyle = .minimal
        return searchBar
    }()
    
    private let buttonsStackView: UIStackView = {
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
    
    weak var delegate: RMSelectionDelegate?
    weak var searchBarDelegate: RMSearchBarDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .red
        axis = .vertical
        distribution = .fillEqually
        alignment = .fill
        backgroundColor = .clear
        searchBar.delegate = self
        searchBar.searchTextField.delegate = self
        addArrangedSubview(searchBar)
    }
    
    required init(coder: NSCoder) {
        fatalError("Unsupported !")
    }
    
    func config(viewModel: RMSearchInputViewViewModel) {
        self.viewModel = viewModel
        searchBar.placeholder = viewModel.searchPlaceholderText
    }
    
    func presentKeyboard() {
        searchBar.becomeFirstResponder()
    }
    
    private func createOptionSelectionViews(with options: [RMSearchInputViewViewModel.RMDynamicOption]) {
        
        addArrangedSubview(buttonsStackView)
        for (index, option) in options.enumerated() {
            let button = UIButton()
            button.backgroundColor = .secondarySystemFill
            button.setTitle(option.rawValue, for: .normal)
            button.titleLabel?.font = .preferredFont(forTextStyle: .body)
            button.setTitleColor(.label, for: .normal)
            button.addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)
            button.layer.cornerRadius = 6
            button.tag = index
            buttonsStackView.addArrangedSubview(button)
        }
    }
    
    @objc
    private func didTapButton(_ sender: UIButton) {
        guard let options = viewModel?.options, !options.isEmpty else { return }
        let buttonIndex = sender.tag
        let selectedOption = options[buttonIndex]
        delegate?.didSelect(with: selectedOption)
    }
    
    func update(option: RMDynamicOption, value: String) {
        guard let buttons = buttonsStackView.arrangedSubviews as? [UIButton],
              let allOptions = viewModel?.options,
              let selectedOptionIndex = allOptions.firstIndex(of: option)
        else { return }
        let selectedButton = buttons[selectedOptionIndex]
        selectedButton.setTitle(value.uppercased(), for: .normal)
        selectedButton.setTitleColor(.link, for: .normal)
    }
}

// MARK: - UISearchBar Delegate
extension RMSearchInputView: UISearchBarDelegate, UITextFieldDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchBarDelegate?.rmSearchInputView(
            self,
            didChangeSearchText: searchText
        )
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBarDelegate?.rmSearchInputView_DidTapSearchKeyboardButton(self)
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        //searchBarDelegate?.rmSearchInputView_DidTapCrossButton(self)
        return true
    }
}
