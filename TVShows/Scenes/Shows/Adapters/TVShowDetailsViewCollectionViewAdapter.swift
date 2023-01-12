import UIKit

// MARK: - TVShowDetailsViewCollectionViewAdapterProtocol

@MainActor
protocol TVShowDetailsViewCollectionViewAdapterProtocol: AnyObject, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    var delegate: TVShowDetailsViewCollectionViewAdapterDelegate? { get set }

    var show: TVShow { get }
    var stretchyHeaderImage: UIImage? { get set }
}

// MARK: - TVShowDetailsViewCollectionViewAdapterDelegate

@MainActor
protocol TVShowDetailsViewCollectionViewAdapterDelegate: AnyObject {
    func didSelectCell(at indexPath: IndexPath)
}

// MARK: - TVShowDetailsViewCollectionViewAdapter

final class TVShowDetailsViewCollectionViewAdapter: NSObject, TVShowDetailsViewCollectionViewAdapterProtocol {
    // MARK: Lifecycle

    init(show: TVShow) {
        self.show = show
    }

    // MARK: Internal

    weak var delegate: TVShowDetailsViewCollectionViewAdapterDelegate?
    var stretchyHeaderImage: UIImage?
    private(set) var show: TVShow

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        stretchyHeader?.scrollViewDidScroll(scrollView: scrollView)
    }

    enum Sections: Int, CaseIterable {
        case info
        case episodes
    }

    // MARK: Private

    private var stretchyHeader: StretchyImageHeaderView?
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout

extension TVShowDetailsViewCollectionViewAdapter: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        Sections.allCases.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let section = Sections(rawValue: section) else { return 0 }
        switch section {
            case .info:
                return 1
            case .episodes:
                return 10
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let section = Sections(rawValue: indexPath.section) else { preconditionFailure("Unsupported section") }

        switch section {
            case .info:
                guard let cell = collectionView.dequeueReusableCell(TVShowDetailsInfoCollectionViewCell.self, for: indexPath) else {
                    preconditionFailure("Unsupported cell")
                }
                cell.configure(with: show)
                return cell
            case .episodes:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
                cell.backgroundColor = .systemPink
                return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader,
              let header = collectionView.dequeueReusableSupplementaryView(StretchyImageHeaderView.self, ofKind: kind, for: indexPath) else {
            preconditionFailure("Unsupported supplementary view kind")
        }
        stretchyHeader = header
        if let stretchyHeaderImage {
            header.configure(with: stretchyHeaderImage)
        }
        return header
    }
}

