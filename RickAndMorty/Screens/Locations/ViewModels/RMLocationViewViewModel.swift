//
//  RMLocationViewViewModel.swift
//  RickAndMorty
//
//  Created by Arun on 14/07/23.
//

import UIKit

protocol RMLocationViewViewModelDelegate: AnyObject {
    func didLoadInitialLocations()
    func didLoadMoreLocations(at indexPaths: [IndexPath])
}

final class RMLocationViewViewModel: NSObject {
    
    private var locations: [RMLocation] = [] {
        didSet {
            for location in locations where !cellViewModels.contains(where: { $0.id == location.id })  {
                let cellViewModel = RMLocationCellViewViewModel(location: location)
                cellViewModels.append(cellViewModel)
            }
        }
    }
    
    private var contentStatus: RMContentStatus = .notYetStarted
    
    private var allLocationInfo: RMInfo?
    
    weak var delegate: RMLocationViewViewModelDelegate?
    
    weak var selectionDelegate: RMSelectionDelegate?
    
    private var cellViewModels: [RMLocationCellViewViewModel] = []
    
    func fetchInitialLocations() {
        
        Task {
            
            let response = await RMService.shared.execute(
                .listLocationsRequest,
                expecting: RMAllLocations.self
            )
            
            switch response {
            case .success(let model):
                allLocationInfo = model.info
                locations.append(contentsOf: model.results)
                DispatchQueue.main.async {
                    self.delegate?.didLoadInitialLocations()
                }
                
            case .failure(let failure):
                print(String(describing: failure))
            }
        }
    }
}

extension RMLocationViewViewModel: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cellViewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RMLocationTableViewCell.cellIdentifier) as? RMLocationTableViewCell else {
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
        guard shouldShowLoadMoreIndicator else {
            return CGFloat.zero
        }
        return 100
    }
}

extension RMLocationViewViewModel: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let locationViewModel = locations[indexPath.row]
        selectionDelegate?.didSelect(with: locationViewModel)
    }
}

// Pagination
extension RMLocationViewViewModel: UIScrollViewDelegate {
    
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
            guard shouldShowLoadMoreIndicator,
                  contentStatus != .inProgress,
                  let urlString = allLocationInfo?.next,
                  let url = URL(string: urlString)
            else { return }
            fetchAdditionalLocations(url: url)
        }
    }
    
    func fetchAdditionalLocations(url: URL) {
        contentStatus = .inProgress
        
        guard let request = RMRequest(url: url) else {
            contentStatus = .failed
            return
        }
        
        Task {
            let response = await RMService.shared.execute(request, expecting: RMAllLocations.self)
            
            switch response {
            case .success(let responseModel):
                self.allLocationInfo = responseModel.info
                
                let startIndex = self.locations.endIndex
                self.locations.append(contentsOf: responseModel.results)
                let endIndex = self.locations.endIndex - 1
                
                let indexPathToAdd = Array(startIndex...endIndex).compactMap {
                    IndexPath(row: $0, section: 0)
                }
                
                DispatchQueue.main.async {
                    self.delegate?.didLoadMoreLocations(at: indexPathToAdd)
                    self.contentStatus = .finished
                }
            case .failure(let failure):
                self.contentStatus = .failed
                print(" Failed \(failure.localizedDescription)")
            }
        }
    }
    
    var shouldShowLoadMoreIndicator: Bool {
        allLocationInfo?.next != nil
    }
}
