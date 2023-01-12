import UIKit

// MARK: - TVShowDetailsViewProtocol

@MainActor
protocol TVShowDetailsViewProtocol {
    var delegate: TVShowsListViewDelegate? { get set }
}

// MARK: - TVShowDetailsViewDelegate

@MainActor
protocol TVShowDetailsViewDelegate {
    func presentEpisodeDetails(_ episode: TVShowEpisode)
}

// MARK: - TVShowDetailsView

final class TVShowDetailsView: UIView, TVShowDetailsViewProtocol {
    // MARK: Lifecycle

    init(viewModel: TVShowDetailsViewModelProtocol, collectionAdapter: TVShowDetailsViewCollectionViewAdapterProtocol) {
        self.viewModel = viewModel
        self.collectionAdapter = collectionAdapter
        super.init(frame: .zero)
        setUpView()
        populateStretchyHeader()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Internal

    weak var delegate: TVShowsListViewDelegate?

    // MARK: Private

    private func setUpView() {
        backgroundColor = .systemBackground

        addSubview(collectionView)

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.rightAnchor.constraint(equalTo: rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            collectionView.leftAnchor.constraint(equalTo: leftAnchor),
        ])

    }

    private func populateStretchyHeader() {
        Task {
            await viewModel.fetchImage()
            if let imageData = viewModel.imageData {
                collectionAdapter.stretchyHeaderImage = UIImage(data: imageData)
                collectionView.reloadData()
            }
        }
    }

    private func createSection(for sectionIndex: Int) -> NSCollectionLayoutSection {
        let sections = TVShowDetailsViewCollectionViewAdapter.Sections.allCases

        switch sections[sectionIndex] {
            case .info:
                let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)))
                item.contentInsets = .init(top: 0, leading: 0, bottom: 10, trailing: 0)
                let group = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)), subitems: [item])
                let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.55))
                let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
                let section = NSCollectionLayoutSection(group: group)
                section.boundarySupplementaryItems = [header]
                return section
            case .episodes:
                let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)))
                item.contentInsets = .init(top: 0, leading: 5, bottom: 0, trailing: 5)
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(0.3), heightDimension: .absolute(150)), subitems: [item])
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .groupPaging
                return section
        }
    }

    private let viewModel: TVShowDetailsViewModelProtocol
    private let collectionAdapter: TVShowDetailsViewCollectionViewAdapterProtocol

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, _ in
            self.createSection(for: sectionIndex)
        }

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = collectionAdapter
        collectionView.dataSource = collectionAdapter

        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.register(TVShowDetailsInfoCollectionViewCell.self)
        collectionView.register(StretchyImageHeaderView.self, forSupplementaryKind: UICollectionView.elementKindSectionHeader)

        return collectionView
    }()
}
