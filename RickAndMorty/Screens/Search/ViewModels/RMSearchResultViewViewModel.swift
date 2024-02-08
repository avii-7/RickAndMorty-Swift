//
//  RMSearchResultViewModel.swift
//  RickAndMorty
//
//  Created by Arun on 26/07/23.
//

import UIKit

enum RMSearchResultType {
    case characters([RMCharacter], String?)
    case locations([RMLocation], String?)
    case episodes([RMEpisode], String?)
}

final class RMSearchResultViewViewModel: NSObject {
    
    weak var delegate: RMSearchResultViewViewModelDelegate?
    
    private var contentStatus: RMContentStatus = .notYetStarted
    
    private var searchResultType: RMSearchResultType?
    
    private var locationCellViewViewModels: [RMLocationCellViewViewModel] = []
    
    private var characterCellViewModels: [RMCharacterCollectionViewCellViewModel] = []
    
    private var allCharacters: [RMCharacter] = [] {
        didSet {
            for character in allCharacters where
            !characterCellViewModels.contains(where: { $0.id == character.id }) {
                characterCellViewModels.append(.init(
                    id: character.id,
                    name: character.name,
                    status: character.status,
                    imageUrlString: character.image
                ))
            }
        }
    }
    
    private var allEpisodes: [RMEpisode] = [] {
        didSet {
            for episode in allEpisodes where
            !episodeCellViewModels.contains(.init(episodeUrl: URL(string: episode.url))) {
                episodeCellViewModels.append(.init(
                    episodeUrl: URL(string: episode.url)
                ))
            }
        }
    }
    
    private var allLocations: [RMLocation] = [] {
        didSet {
            for location in allLocations where
            !locationCellViewViewModels.contains(where: { $0.id == location.id }) {
                locationCellViewViewModels.append(.init(location: location))
            }
        }
    }
    
    private var episodeCellViewModels: [RMEpisodeCollectionViewCellViewModel] = []
    
    private var nextPageURL: String?
    
    private var shouldShowLoadMoreIndicator: Bool {
        nextPageURL != nil
    }
    
    private var moduleType: RMModuleType?
    
    func configure(with searchResultType: RMSearchResultType) {
        self.searchResultType = searchResultType
        processViewModel()
    }
    
    private func processViewModel() {
        
        guard let searchResultType else { return }
        
        switch searchResultType {
        case .characters(let allCharacters, let nextPageUrl):
            self.nextPageURL = nextPageUrl
            characterCellViewModels.removeAll()
            self.allCharacters = allCharacters
            moduleType = .Character
            delegate?.didLoadCharactersOrEpisodes()
        case .locations(let allLocations, let nextPageUrl):
            self.nextPageURL = nextPageUrl
            locationCellViewViewModels.removeAll()
            self.allLocations = allLocations
            moduleType = .Location
            delegate?.didLoadLocations()
        case .episodes(let allEpisodes, let nextPageUrl):
            self.nextPageURL = nextPageUrl
            episodeCellViewModels.removeAll()
            self.allEpisodes = allEpisodes
            moduleType = .Episode
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
        let viewModel = allLocations[indexPath.row]
        delegate?.didSelectLocation(with: viewModel)
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
                withReuseIdentifier: RMCharacterCollectionViewCell.Identifier, for: indexPath
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
        
        if moduleType == .Character {
            let viewModel = allCharacters[indexPath.row]
            delegate?.didSelectCharacter(with: viewModel)
        }
        else if moduleType == .Episode {
            let viewModel = allEpisodes[indexPath.row]
            delegate?.didSelectEpisode(with: viewModel)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let moduleType else { return .zero }
        
        switch moduleType {
        case .Character:
            let bounds = collectionView.bounds
            var width: CGFloat
            
            if UIDevice.isIphone {
                width = (bounds.width - 30) / 2
            }
            else{
                // iPad
                width = (bounds.width - 60 )/4
            }
            
            return CGSize(width: width, height: width * 1.5)
        case .Episode:
            let bounds = collectionView.bounds
            
            let width = UIDevice.isIphone ? bounds.width - 20 : (bounds.width - 40)/3
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
                  let urlString = nextPageURL,
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
        
        Task {
            let response = await RMService.shared.execute(request, expecting: RMAllLocations.self)
            
            switch response {
            case .success(let responseModel):
                
                nextPageURL = responseModel.info.next
                
                let startIndex = allLocations.endIndex
                
                allLocations.append(contentsOf: responseModel.results)
                
                let endIndex = allLocations.endIndex - 1
                
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
        Task {
            let response = await RMService.shared.execute(request, expecting: RMAllCharacters.self)
            switch response {
            case .success(let responseModel):
                
                nextPageURL = responseModel.info.next
                
                let startIndex = allCharacters.endIndex
                
                allCharacters.append(contentsOf: responseModel.results)
                
                let endIndex = allCharacters.endIndex - 1
                
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
        Task {
            let response = await RMService.shared.execute(request, expecting: RMAllEpisodes.self)
            switch response {
            case .success(let responseModel):
                
                nextPageURL = responseModel.info.next
                
                let startIndex = allEpisodes.endIndex
                
                allEpisodes.append(contentsOf: responseModel.results)
                
                let endIndex = allEpisodes.endIndex - 1
                
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
