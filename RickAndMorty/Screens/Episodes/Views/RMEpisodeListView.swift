//
//  RMEpisodeListView.swift
//  RickAndMorty
//
//  Created by Arun on 05/07/23.
//

import UIKit

protocol RMEpisodeListViewDelegate: AnyObject {
    func rmEpisodeListView(didSelectEpisode episode: RMEpisode)
}

/// Custom view that showing list of episodes, loader, infinite loading etc
final class RMEpisodeListView: UIView {
    
    var viewModel: RMEpisodeListViewViewModel?
    
    private var nextURL: String?
    
    private var cellViewModels: [RMEpisodeCollectionViewCellViewModel] = []
    
    private var episodes = [RMEpisode]()
    
    private var fetchingMoreEpisodeStatus = fetchStatus.notYetStarted
    
    weak var delegate: RMEpisodeListViewDelegate?
    
    // Block pattern
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.hidesWhenStopped = true
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 10)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isHidden = true
        collectionView.alpha = 0
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(
            RMEpisodeCollectionViewCell.self,
            forCellWithReuseIdentifier: RMEpisodeCollectionViewCell.Identifier)
        collectionView.register(
            RMLoadingFooterCollectionResuableView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
            withReuseIdentifier: "RMLoadingFooterCollectionResuableView"
        )
        return collectionView
    }()
    
    // MARK: - Int
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        addSubviews(collectionView, spinner)
        addConstraints()
        setupCollectionView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unsupported constructor")
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            spinner.widthAnchor.constraint(equalToConstant: 100),
            spinner.heightAnchor.constraint(equalToConstant: 100),
            spinner.centerXAnchor.constraint(equalTo: centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    func loadInitialEpisodes() {
        spinner.startAnimating()
        
        Task { @MainActor in
            
            if let viewModel {
                let response = try await viewModel.fetchInitialEpisodes()
                
                switch response {
                case .success(let rmAllEpisodes):
                    nextURL = rmAllEpisodes.info.next
                    self.episodes.append(contentsOf: rmAllEpisodes.results)
                    let cellViewModels = RMEpisodeHelper.createCellViewModels(from: episodes)
                    self.cellViewModels.append(contentsOf: cellViewModels)
                case .failure(let errror):
                    debugPrint("Error \(errror)")
                }
            }
            
            spinner.stopAnimating()
            collectionView.isHidden = false
            collectionView.reloadData()
            UIView.animate(withDuration: 0.4) {
                self.collectionView.alpha = 1
            }
        }
    }
}

extension RMEpisodeListView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        cellViewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RMEpisodeCollectionViewCell.Identifier, for: indexPath) as? RMEpisodeCollectionViewCell else {
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
        delegate?.rmEpisodeListView(didSelectEpisode: episode)
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
        if nextURL != nil {
            return CGSize(width: collectionView.frame.width, height: 100)
        }
        else {
            return CGSize.zero
        }
    }
}

extension RMEpisodeListView: UIScrollViewDelegate {
    
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
            
            if let nextURL, fetchingMoreEpisodeStatus != .inProgress, viewModel != nil {
                
                fetchingMoreEpisodeStatus = .inProgress
                
                Task { @MainActor in
                    let response = try await viewModel!.fetchAdditionalEpisodes(urlString: nextURL)
                    
                    let cellViewModels: [RMEpisodeCollectionViewCellViewModel]?
                    
                    switch response {
                    case .success(let rmAllEpisodes):
                        self.nextURL = rmAllEpisodes.info.next
                        let newEpisodes = rmAllEpisodes.results
                        self.episodes.append(contentsOf: newEpisodes)
                        cellViewModels = RMEpisodeHelper.createCellViewModels(from: newEpisodes)
                    case .failure(let error):
                        debugPrint("Error \(error.localizedDescription)")
                        cellViewModels = nil
                    }
                    
                    if let cellViewModels {
                        let startIndex = self.cellViewModels.endIndex
                        self.cellViewModels.append(contentsOf: cellViewModels)
                        let endIndex = self.cellViewModels.endIndex - 1
                        let indexPaths = RMSharedHelper.getIndexPaths(start: startIndex, end: endIndex)
                        
                        collectionView.performBatchUpdates {
                            collectionView.insertItems(at: indexPaths)
                        }
                    }
                    
                    fetchingMoreEpisodeStatus = .finished
                }
            }
        }
    }
}


