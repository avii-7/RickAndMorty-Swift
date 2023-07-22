//
//  RMSearchOptionPickerViewController.swift
//  RickAndMorty
//
//  Created by Arun on 22/07/23.
//

import UIKit

final class RMSearchOptionPickerViewController: UIViewController {

    private let option: RMSearchInputViewViewModel.RMDynamicOption
    
    private let selection: ((String) -> Void)
    
    private let tableView: UITableView = {
       let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        return tableView
    }()
    
    init(with option: RMSearchInputViewViewModel.RMDynamicOption, selection: @escaping ((String) -> Void)) {
        self.selection = selection
        self.option = option
        super.init(nibName: nil, bundle: .none)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unsupported !")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupTableView()
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

extension RMSearchOptionPickerViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        var config = cell.defaultContentConfiguration()
        config.text = option.choices[indexPath.row].uppercased()
        config.textProperties.alignment = .center
        cell.contentConfiguration = config
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        option.choices.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedOption = option.choices[indexPath.row].uppercased()
        selection(selectedOption)
        dismiss(animated: true)
    }
}
