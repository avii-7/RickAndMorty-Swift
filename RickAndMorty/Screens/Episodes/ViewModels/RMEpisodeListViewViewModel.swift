//
//  RMEpisodeListViewViewModel.swift
//  RickAndMorty
//
//  Created by Arun on 05/07/23.
//

import Foundation
import UIKit

protocol RMEpisodeListViewModelDelegate: AnyObject {
    func didLoadInitialEpisode()
    func didSelectEpisode(_ episode: RMEpisode)
    func didLoadMoreEpisodes(at indexPaths: [IndexPath])
}

enum FetchingMoreEpisodesStatus {
    case notYetStarted, inProgress, finished, failed
}
/// View model to handle character list logic
final class RMEpisodeListViewViewModel: NSObject {
    
    private var episodes: [RMEpisode] = [] {
        didSet {
            for episode in episodes {
                let url = URL(string: episode.url)
                let cellViewModel = RMEpisodeCollectionViewCellViewModel(episodeUrl: url)
                if cellViewModels.contains(cellViewModel) {
                    return
                }
                cellViewModels.append(cellViewModel)
            }
        }
    }
    
    private var fetchingMoreEpisodesStatus: FetchingMoreEpisodesStatus = .notYetStarted
    
    private var cellViewModels: [RMEpisodeCollectionViewCellViewModel] = []
    
    public weak var delegate: RMEpisodeListViewModelDelegate?
    
    private var allEpisodeInfo: Info?
    
    /// Fetch initial set of characters ( 20 )
    func fetchInitialEpisodes() {
        RMService.shared.execute(.listEpisodesRequest, expecting: RMAllEpisodes.self) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let model):
                self.episodes = model.results
                self.allEpisodeInfo = model.info
                DispatchQueue.main.async {
                    self.delegate?.didLoadInitialEpisode()
                }
            case .failure(let error):
                print(String(describing: error))
            }
        }
    }
    
    /// Paginate if possible
    func fetchAdditionalEpisodes(url: URL) {
        fetchingMoreEpisodesStatus = .inProgress
        
        guard let request = RMRequest(url: url) else {
            fetchingMoreEpisodesStatus = .failed
            return
        }
        
        RMService.shared.execute(request, expecting: RMAllEpisodes.self) { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let responseModel):
                self.allEpisodeInfo = responseModel.info
                
                let startIndex = self.episodes.endIndex
                self.episodes.append(contentsOf: responseModel.results)
                let endIndex = self.episodes.endIndex - 1
                
                let indexPathToAdd = Array(startIndex...endIndex).compactMap {
                    IndexPath(row: $0, section: 0)
                }
                
                DispatchQueue.main.async {
                    self.delegate?.didLoadMoreEpisodes(at: indexPathToAdd)
                    self.fetchingMoreEpisodesStatus = .finished
                }
            case .failure(let failure):
                self.fetchingMoreEpisodesStatus = .failed
                print(" Failed \(failure.localizedDescription)")
            }
        }
    }
    
    var shouldShowLoadMoreIndicator: Bool {
       allEpisodeInfo?.next != nil
    }
}

// MARK: - CollectionView

extension RMEpisodeListViewViewModel: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
     
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        cellViewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RMEpisodeCollectionViewCell.cellIdentifier, for: indexPath) as? RMEpisodeCollectionViewCell else {
            fatalError("Unsupported Cell")
        }
        
        cell.configure(with: cellViewModels[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let bounds = UIScreen.main.bounds
        let width = (bounds.width - 30) / 2
        
        return CGSize(width: width, height: width * 0.7)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let episode = episodes[indexPath.row]
        delegate?.didSelectEpisode(episode)
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

extension RMEpisodeListViewViewModel: UIScrollViewDelegate {
    
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
            fetchingMoreEpisodesStatus != .inProgress,
            let urlString = allEpisodeInfo?.next,
            let url = URL(string: urlString)
            else { return }
            fetchAdditionalEpisodes(url: url)
        }
    }
}
