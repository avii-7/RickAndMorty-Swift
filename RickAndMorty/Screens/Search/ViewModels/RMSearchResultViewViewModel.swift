//
//  RMSearchResultViewModel.swift
//  RickAndMorty
//
//  Created by Arun on 26/07/23.
//

import UIKit

final class RMSearchResult {
    let searchResultType: RMSearchResultType
    var nextResultURL: String?
    
    init(searchResultType: RMSearchResultType, nextResultURL: String? = nil) {
        self.searchResultType = searchResultType
        self.nextResultURL = nextResultURL
    }
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
    
    private var characterCellViewModels: [RMCharacterCollectionViewCellViewModel] = []
    
    private var episodeCellViewModels: [RMEpisodeCollectionViewCellViewModel] = []
    
    private var shouldShowLoadMoreIndicator: Bool {
        searchResult?.nextResultURL != nil
    }
    
    private var moduleType: RMModuleType?
    
    func configure(with searchResult: RMSearchResult) {
        self.searchResult = searchResult
        switch searchResult.searchResultType {
        case .characters:
            moduleType = .Character
        case .episodes:
            moduleType = .Episode
        case .locations:
            moduleType = .Location
        }
        processViewModel()
    }
    
    private func processViewModel() {
        
        guard let searchResult else { return }
        
        switch searchResult.searchResultType {
        case .characters(let viewModels):
            characterCellViewModels = viewModels
            delegate?.didLoadCharactersOrEpisodes()
        case .locations(let viewModels):
            locationCellViewViewModels = viewModels
            delegate?.didLoadLocations()
        case .episodes(let viewModels):
            episodeCellViewModels = viewModels
            delegate?.didLoadCharactersOrEpisodes()
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
        guard let moduleType else { fatalError() }
        
        switch moduleType {
        case .Character:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: RMCharacterCollectionViewCell.cellIdentifier, for: indexPath
            ) as? RMCharacterCollectionViewCell else { fatalError() }
            cell.configure(with: characterCellViewModels[indexPath.row])
            return cell;
        case .Episode:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: RMEpisodeCollectionViewCell.cellIdentifier, for: indexPath
            ) as? RMEpisodeCollectionViewCell else { fatalError() }
            cell.configure(with: episodeCellViewModels[indexPath.row])
            return cell;
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let moduleType else { return 0 }
        switch moduleType {
        case .Character:
            return characterCellViewModels.count
        case .Episode:
            return episodeCellViewModels.count
        case .Location:
            return 0
        }
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
            var width: CGFloat
            
            let currentIdiom = UIDevice.current.userInterfaceIdiom
            
            if currentIdiom == .phone {
                width = (bounds.width - 30) / 2
            }
            else{
                // iPad
                width = (bounds.width - 60 )/4
            }

            return CGSize(width: width, height: width * 1.5)
        case .episodes:
            let bounds = collectionView.bounds
            let width = bounds.width - 20
            return CGSize(width: width, height: 150)
        default:
            return .zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionFooter,
              let supplementaryFooterView = collectionView.dequeueReusableSupplementaryView(
                ofKind: UICollectionView.elementKindSectionFooter,
                withReuseIdentifier: "RMLoadingFooterCollectionResuableView",
                for: indexPath) as? RMLoadingFooterCollectionResuableView
        else {
            fatalError("Unable to get reusable footer view")
        }
        supplementaryFooterView.startAnimating()
        return supplementaryFooterView
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        guard shouldShowLoadMoreIndicator else {
            return CGSize.zero
        }
        return CGSize(width: collectionView.frame.width, height: 100)
    }
}

// Pagination
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
                  let searchResult,
                  let urlString = searchResult.nextResultURL,
                  let url = URL(string: urlString)
            else { return }
            appendNextPageData(from: url)
        }
    }
    
    private func appendNextPageData(from url: URL) {
        contentStatus = .inProgress
        
        guard let request = RMRequest(url: url) else {
            contentStatus = .failed
            return
        }
        
        guard let moduleType else { return }
        
        switch moduleType {
        case .Character:
            fetchMoreDataForCharacters(with: request)
        case .Location:
            fetchMoreDataForLocations(with: request)
        case .Episode:
            fetchMoreDataForEpisodes(with: request)
        }
    }
    
    private func fetchMoreDataForLocations(with request: RMRequest) {
        
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
    
    private func fetchMoreDataForCharacters(with request: RMRequest) {
        RMService.shared.execute(request, expecting: RMAllCharacters.self) { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let responseModel):
                guard var searchResult else { return }
                
                searchResult.nextResultURL = responseModel.info.next
                
                print(searchResult.nextResultURL)
                
                let startIndex = self.characterCellViewModels.endIndex
                
                self.characterCellViewModels.append(contentsOf: responseModel.results.compactMap({
                    RMCharacterCollectionViewCellViewModel(
                        id: $0.id,
                        name: $0.name,
                        status: $0.status,
                        imageUrlString: $0.image)
                }))
                
                let endIndex = self.characterCellViewModels.endIndex - 1
                
                let indexPathToAdd = Array(startIndex...endIndex).compactMap {
                    IndexPath(row: $0, section: 0)
                }
                
                DispatchQueue.main.async {
                    self.delegate?.didLoadMoreCharactersOrEpisodes(at: indexPathToAdd)
                    self.contentStatus = .finished
                }
            case .failure(let failure):
                self.contentStatus = .failed
                print(" Failed \(failure.localizedDescription)")
            }
        }
    }
    
    private func fetchMoreDataForEpisodes(with request: RMRequest) {
        RMService.shared.execute(request, expecting: RMAllEpisodes.self) { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let responseModel):
                guard var searchResult else { return }
                
                searchResult.nextResultURL = responseModel.info.next
                
                let startIndex = self.episodeCellViewModels.endIndex
                self.episodeCellViewModels.append(contentsOf: responseModel.results.compactMap({
                    let episodeURL = URL(string: $0.url)
                    return RMEpisodeCollectionViewCellViewModel(episodeUrl: episodeURL)
                }))
                let endIndex = self.episodeCellViewModels.endIndex - 1
                
                let indexPathToAdd = Array(startIndex...endIndex).compactMap {
                    IndexPath(row: $0, section: 0)
                }
                
                DispatchQueue.main.async {
                    self.delegate?.didLoadMoreCharactersOrEpisodes(at: indexPathToAdd)
                    self.contentStatus = .finished
                }
            case .failure(let failure):
                self.contentStatus = .failed
                print(" Failed \(failure.localizedDescription)")
            }
        }
    }
}
