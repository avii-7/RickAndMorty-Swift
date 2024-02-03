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


/// View model to handle character list logic
final class RMEpisodeListViewViewModel: NSObject {
    
    let episodeDataRepository = RMEpisodeDataRepository()
    
    private var randomColor: UIColor {
        let red = CGFloat.random(in: 0...1)
        let green = CGFloat.random(in: 0...1)
        let blue = CGFloat.random(in: 0...1)
        
        return UIColor(
            red: red,
            green: green,
            blue: blue,
            alpha: 1
        )
    }
    
    private var episodes: [RMEpisode] = [] {
        didSet {
            for episode in episodes {
                let url = URL(string: episode.url)
                let cellViewModel = RMEpisodeCollectionViewCellViewModel(
                    episodeUrl: url,
                    borderColor: randomColor)
                if !cellViewModels.contains(cellViewModel) {
                    cellViewModels.append(cellViewModel)
                }
            }
        }
    }
    
    private var fetchingMoreEpisodesStatus: RMContentStatus = .notYetStarted
    
    private var cellViewModels: [RMEpisodeCollectionViewCellViewModel] = []
    
    weak var delegate: RMEpisodeListViewModelDelegate?
    
    private var allEpisodeInfo: RMInfo?
    
    /// Fetch initial set of characters ( 20 )
    func fetchInitialEpisodes() {
        Task {
            //let response = await RMService.shared.execute(.listEpisodesRequest, expecting: RMAllEpisodes.self)
            let response = await episodeDataRepository.fetchInitialEpisodes()
            
            switch response {
            case .success(let model):
                self.episodes = model.results
                self.allEpisodeInfo = model.info
                
                DispatchQueue.main.async {
                    self.delegate?.didLoadInitialEpisode()
                }
            case .failure(let error):
                debugPrint(error)
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
        
        Task {
            //let response = await RMService.shared.execute(request, expecting: RMAllEpisodes.self)
            
            let response = await episodeDataRepository.fetchAdditionalEpisodes()
            
            switch response {
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
        let bounds = collectionView.bounds
        let width = bounds.width - 20
        return CGSize(width: width, height: 150)
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
    
    // Make dynmaic size
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
