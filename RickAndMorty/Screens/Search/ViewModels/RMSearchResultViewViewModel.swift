//
//  RMSearchResultViewModel.swift
//  RickAndMorty
//
//  Created by Arun on 26/07/23.
//

import UIKit

struct RMSearchResult {
    let searchResultType: RMSearchResultType
    var nextResultURL: String?
}

enum RMSearchResultType {
    case characters([RMCharacterCollectionViewCellViewModel])
    case locations([RMLocationCellViewViewModel])
    case episodes([RMEpisodeCollectionViewCellViewModel])
}

final class RMSearchResultViewViewModel: NSObject {
    
    weak var delegate: RMSearchResultViewViewModelDelegate?
    
    private var contentStatus: RMContentStatus = .notYetStarted
    
    private var searchResult: RMSearchResult?
    
    private var locationCellViewViewModels: [RMLocationCellViewViewModel] = []
    
    private var collectionViewCellViewModels: [any Hashable] = [] {
        didSet{
            delegate?.didLoadCharactersOrEpisodes()
        }
    }
    
    private var shouldShowLoadMoreIndicator: Bool {
        searchResult?.nextResultURL != nil
    }
    
    func configure(with searchResult: RMSearchResult) {
        self.searchResult = searchResult
        processViewModel()
    }
    
    private func processViewModel() {
        
        guard let searchResult else { return }
        
        switch searchResult.searchResultType {
        case .characters(let viewModels):
            collectionViewCellViewModels = viewModels
        case .locations(let locationCellViewViewModels):
            self.locationCellViewViewModels = locationCellViewViewModels
            self.delegate?.didLoadLocations()
        case .episodes(let viewModels):
            collectionViewCellViewModels = viewModels
        }
    }
    
}

// MARK: - Location search result
extension RMSearchResultViewViewModel : UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        locationCellViewViewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: RMLocationTableViewCell.cellIdentifier,
            for: indexPath
        ) as? RMLocationTableViewCell else { fatalError("Something went wrong !") }
        cell.config(with: locationCellViewViewModels[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        delegate?.didSelectLocation(at: indexPath)
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

// MARK: - Character and episodes search result view
extension RMSearchResultViewViewModel: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let searchResult else { fatalError() }
        
        switch searchResult.searchResultType {
        case .characters(let viewModels):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: RMCharacterCollectionViewCell.cellIdentifier, for: indexPath
            ) as? RMCharacterCollectionViewCell else { fatalError() }
            cell.configure(with: viewModels[indexPath.row])
            return cell;
        case .episodes(let viewModels):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: RMEpisodeCollectionViewCell.cellIdentifier, for: indexPath
            ) as? RMEpisodeCollectionViewCell else { fatalError() }
            cell.configure(with: viewModels[indexPath.row])
            return cell;
        default:
            fatalError()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        collectionViewCellViewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        delegate?.didSelectCharacterOrEpisode(at: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        guard let searchResult else { return .zero }
        // Make iPad compatible
        switch searchResult.searchResultType {
        case .characters:
            let bounds = collectionView.bounds
            let width = (bounds.width - 30) / 2
            return CGSize(width: width, height: width * 1.5)
        case .episodes:
            let bounds = collectionView.bounds
            let width = bounds.width - 20
            return CGSize(width: width, height: 150)
        default:
            return .zero
        }
    }
}

// Location Pagination
extension RMSearchResultViewViewModel: UIScrollViewDelegate {
    
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
                  let urlString = searchResult?.nextResultURL,
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
        
        RMService.shared.execute(request, expecting: RMAllLocations.self) { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let responseModel):
                self.searchResult?.nextResultURL = responseModel.info.next
                
                let startIndex = self.locationCellViewViewModels.endIndex
                
                self.locationCellViewViewModels.append(contentsOf: responseModel.results.compactMap({
                    RMLocationCellViewViewModel(location: $0)
                }))
                let endIndex = self.locationCellViewViewModels.endIndex - 1

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
}


