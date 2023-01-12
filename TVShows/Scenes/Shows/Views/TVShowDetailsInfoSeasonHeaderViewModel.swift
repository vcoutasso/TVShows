import UIKit

// MARK: - TVShowDetailsEpisodeCollectionViewCell

final class TVShowDetailsEpisodeNameCollectionViewCell: UICollectionViewCell, ReusableView {
    // MARK: Lifecycle

    override init(frame: CGRect) {
        super.init(frame: .zero)
        setUpView()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Internal

    func configure(with name: String) {
        titleLabel.text = name
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
    }

    // MARK: Private

    private func setUpView() {
        addSubview(titleLabel)
        addSubview(bottomSeparator)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.rightAnchor.constraint(equalTo: rightAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: bottomSeparator.topAnchor),
            titleLabel.leftAnchor.constraint(equalTo: leftAnchor),

            bottomSeparator.heightAnchor.constraint(equalToConstant: 2),
            bottomSeparator.leadingAnchor.constraint(equalTo: leadingAnchor),
            bottomSeparator.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .callout)
        label.textColor = .secondaryLabel
        return label
    }()

    private lazy var bottomSeparator: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .separator
        return view
    }()
}
