import UIKit

// MARK: - TVShowDetailsViewCollectionViewAdapterProtocol

@MainActor
protocol TVShowDetailsViewCollectionViewAdapterProtocol: AnyObject, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    var delegate: TVShowDetailsViewCollectionViewAdapterDelegate? { get set }

    var show: TVShow { get }
    var sections: [TVShowDetailsViewCollectionSections] { get }
    var stretchyHeaderImage: UIImage? { get set }
}

// MARK: - TVShowDetailsViewCollectionSections

enum TVShowDetailsViewCollectionSections {
    case info
    case seasons
}

// MARK: - TVShowDetailsViewCollectionViewAdapterDelegate

@MainActor
protocol TVShowDetailsViewCollectionViewAdapterDelegate: AnyObject {
    func didSelectCell(at indexPath: IndexPath)
}

// MARK: - TVShowDetailsViewCollectionViewAdapter

final class TVShowDetailsViewCollectionViewAdapter: NSObject, TVShowDetailsViewCollectionViewAdapterProtocol {
    // MARK: Lifecycle

    init(show: TVShow, sections: [TVShowDetailsViewCollectionSections]) {
        self.show = show
        self.sections = sections
    }

    // MARK: Internal

    weak var delegate: TVShowDetailsViewCollectionViewAdapterDelegate?

    var stretchyHeaderImage: UIImage?

    private(set) var show: TVShow
    private(set) var sections: [TVShowDetailsViewCollectionSections]

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        stretchyHeader?.scrollViewDidScroll(scrollView: scrollView)
    }

    // MARK: Private

    private var stretchyHeader: StretchyImageHeaderView?
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout

extension TVShowDetailsViewCollectionViewAdapter: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        sections.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch sections[section] {
            case .info:
                return 1
            case .seasons:
                return 10
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch sections[indexPath.section] {
            case .info:
                guard let cell = collectionView.dequeueReusableCell(TVShowDetailsInfoCollectionViewCell.self, for: indexPath) else {
                    preconditionFailure("Unsupported cell")
                }
                cell.configure(with: show)
                return cell
            case .seasons:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
                cell.backgroundColor = .systemPink
                return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader else {
            preconditionFailure("Unsupported supplementary view kind")
        }
        return sectionHeader(collectionView, at: indexPath)
    }

    private func sectionHeader(_ collectionView: UICollectionView, at indexPath: IndexPath) -> UICollectionReusableView {
        switch sections[indexPath.section] {
            case .info:
                guard let header = collectionView.dequeueReusableSupplementaryView(StretchyImageHeaderView.self, ofKind: UICollectionView.elementKindSectionHeader, for: indexPath) else {
                    preconditionFailure("Unsupported cell type")
                }
                stretchyHeader = header
                if let stretchyHeaderImage {
                    header.configure(with: stretchyHeaderImage)
                }
                return header
            case .seasons:
                guard let header = collectionView.dequeueReusableSupplementaryView(TVShowDetailsInfoSeasonHeaderView.self, ofKind: UICollectionView.elementKindSectionHeader, for: indexPath) else {
                    preconditionFailure("Unsupported cell type")
                }
                header.configure(with: indexPath.section)
                return header
        }
    }
}

