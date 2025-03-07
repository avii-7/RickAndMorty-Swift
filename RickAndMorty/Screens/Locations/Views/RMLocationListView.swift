//
//  RMLocationView.swift
//  RickAndMorty
//
//  Created by Arun on 14/07/23.
//

import UIKit

@MainActor
protocol RMLocationListViewDelegate: AnyObject {
    func rmLocationListView(didSelectLocation location: RMLocation)
}

final class RMLocationListView: UIView {
    
    private var nextURL: String?
    
    private let viewModel: RMLocationViewViewModel
    
    var delegate: RMLocationListViewDelegate?
    
    private var cellViewModels: [RMLocationCellViewViewModel] = []
    
    private var locations = [RMLocation]()
    
    private var fetchingMoreLocationStatus = fetchStatus.notYetStarted
    
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.hidesWhenStopped = true
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.alpha = 1
        tableView.isHidden = true
        tableView.sectionHeaderTopPadding = 0
        tableView.register(
            RMLocationTableViewCell.self,
            forCellReuseIdentifier: RMLocationTableViewCell.Identifier
        )
        tableView.register(RMLoadingFooterTableView.self, forHeaderFooterViewReuseIdentifier: RMLoadingFooterTableView.cellIdentifier)
        
        return tableView
    }()
    
    init(viewModel: RMLocationViewViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        addSubviews(spinner, tableView)
        addConstraints()
        configTableView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            spinner.widthAnchor.constraint(equalToConstant: 100),
            spinner.heightAnchor.constraint(equalToConstant: 100),
            spinner.centerXAnchor.constraint(equalTo: centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private func configTableView() {
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func loadInitialLocations() {
        spinner.startAnimating()
        Task { @MainActor [weak self] in
            
            let response = try await self!.viewModel.fetchInitialLocations()
            
            guard let self else { return }
            
            switch response {
            case .success(let rmAllLocations):
                self.nextURL = rmAllLocations.info.next
                self.locations.append(contentsOf: rmAllLocations.results)
                let cellViewModels = RMLocationHelper.createCellViewModels(from: locations)
                self.cellViewModels.append(contentsOf: cellViewModels)
            case .failure(let errror):
                debugPrint("Error \(errror)")
            }
            
            self.spinner.stopAnimating()
            self.tableView.isHidden = false
            self.tableView.reloadData()
            UIView.animate(withDuration: 0.4) {
                self.tableView.alpha = 1
            }
        }
    }
}

extension RMLocationListView: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cellViewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RMLocationTableViewCell.Identifier) as? RMLocationTableViewCell else {
            fatalError()
        }
        let viewModel = cellViewModels[indexPath.row]
        cell.config(with: viewModel)
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView: RMLoadingFooterTableView = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: RMLoadingFooterTableView.cellIdentifier)
        as? RMLoadingFooterTableView ?? RMLoadingFooterTableView(reuseIdentifier: RMLoadingFooterTableView.cellIdentifier)
        
        footerView.startAnimating()
        return footerView
    }
    
    // Make dynmaic size
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if nextURL != nil {
            return 100
        } else {
            return CGFloat.zero
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let locationViewModel = locations[indexPath.row]
        delegate?.rmLocationListView(didSelectLocation: locationViewModel)
    }
}

// Pagination
extension RMLocationListView: UIScrollViewDelegate {
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate{
            checkReachAtBottom(scrollView)
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        checkReachAtBottom(scrollView)
    }
    
    private func checkReachAtBottom(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y + 1 >= (scrollView.contentSize.height - scrollView.frame.height - 120) {
            
            if let nextURL, fetchingMoreLocationStatus != .inProgress {
                
                fetchingMoreLocationStatus = .inProgress
                
                Task { @MainActor [weak self] in
                    
                    do {
                        let response = try await self!.viewModel.fetchAdditionalLocations(urlString: nextURL)
                        
                        let cellViewModels: [RMLocationCellViewViewModel]?
                        
                        guard let self else { return }
                        
                        switch response {
                        case .success(let rmAllLocations):
                            self.nextURL = rmAllLocations.info.next
                            let newLocations = rmAllLocations.results
                            self.locations.append(contentsOf: newLocations)
                            cellViewModels = RMLocationHelper.createCellViewModels(from: newLocations)
                        case .failure(let error):
                            debugPrint("Error \(error.localizedDescription)")
                            cellViewModels = nil
                        }
                        
                        if let cellViewModels {
                            let startIndex = self.cellViewModels.endIndex
                            self.cellViewModels.append(contentsOf: cellViewModels)
                            let endIndex = self.cellViewModels.endIndex - 1
                            let indexPaths = RMSharedHelper.getIndexPaths(start: startIndex, end: endIndex)
                            
                            self.tableView.performBatchUpdates {
                                self.tableView.insertRows(at: indexPaths, with: .automatic)
                            }
                        }
                        
                    } catch {
                        debugPrint("Eror \(error)")
                    }
                    
                    self?.fetchingMoreLocationStatus = .finished
                }
            }
        }
    }
}

