//
//  RMLocationViewViewModel.swift
//  RickAndMorty
//
//  Created by Arun on 14/07/23.
//

import UIKit

protocol RMLocationViewViewModelDelegate: AnyObject {
    func didLoadInitialLocations()
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
    
    private var locationInfo: RMInfo?
    
    weak var delegate: RMLocationViewViewModelDelegate?
    
    weak var selectionDelegate: RMSelectionDelegate?
    
    private var cellViewModels: [RMLocationCellViewViewModel] = []
    
    func fetchInitialLocations() {
        RMService.shared.execute(
            .listLocationsRequest,
            expecting: RMAllLocations.self
        ) {
            [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let model):
                locationInfo = model.info
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
}

extension RMLocationViewViewModel: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let locationViewModel = locations[indexPath.row]
        selectionDelegate?.didSelect(with: locationViewModel)
    }
}
