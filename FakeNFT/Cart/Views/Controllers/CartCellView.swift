//
//  CartCellView.swift
//  FakeNFT
//
//  Created by Ruth Dayter on 04.04.2024.
//

import UIKit
import Kingfisher

final class CartViewCell: UITableViewCell, ReuseIdentifying {

    var viewModel: CartCellViewModelProtocol? {
        didSet {
            bindViewModel()
        }
    }

    private let layoutMargin: CGFloat = 16
    private lazy var nftImageView: UIImageView = createNFTImageView()
    private lazy var nftNameLabel: UILabel = createNFTNameLabel()
    private lazy var nftRatingView = RatingView(rating: .zero)
    private lazy var nftPriceLabel: UILabel = createNFTPriceLabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        nftImageView.kf.cancelDownloadTask()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func deleteButtonDidTap() {
        viewModel?.deleteButtonDidTap(image: nftImageView.image)
    }

    private func bindViewModel() {
        let bindings = CartCellViewModelBindings(
            rating: { [weak self] in
                self?.nftRatingView.rating = $0
            },
            price: { [weak self] in
                self?.nftPriceLabel.text = PriceFormatter.formattedPrice($0)
            },
            name: { [weak self] in
                self?.nftNameLabel.text = $0
            },
            imageURL: { [weak self] in
                guard let self else { return }
                let placeholderImage = UIImage(named: "NFTPlaceholder")
                self.nftImageView.kf.indicatorType = .activity
                self.nftImageView.kf.setImage(with: $0, placeholder: placeholderImage)
            }
        )
        viewModel?.bind(bindings)
    }
}

// MARK: Setup UI & Layout
private extension CartViewCell {
    func setupUI() {

        backgroundColor = UIColor(named: "White")
        contentView.addSubview(nftImageView)
        NSLayoutConstraint.activate([
            nftImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: layoutMargin),
            nftImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: layoutMargin),
            nftImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -layoutMargin),
            nftImageView.widthAnchor.constraint(equalTo: nftImageView.heightAnchor)
        ])

        let infoView = createNFTInfoView()
        contentView.addSubview(infoView)
        NSLayoutConstraint.activate([
            infoView.leadingAnchor.constraint(equalTo: nftImageView.trailingAnchor, constant: 20),
            infoView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            infoView.heightAnchor.constraint(equalToConstant: 92)
        ])
        let deleteButton = createDeleteNFTButton()
        contentView.addSubview(deleteButton)
        NSLayoutConstraint.activate([
            deleteButton.heightAnchor.constraint(equalToConstant: 40),
            deleteButton.widthAnchor.constraint(equalTo: deleteButton.heightAnchor),
            deleteButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            deleteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -layoutMargin)
        ])
    }

    func createNFTImageView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }

    func createNFTInfoView() -> UIView {
        let nameStackView = UIStackView(arrangedSubviews: [nftNameLabel, nftRatingView])
        nameStackView.axis = NSLayoutConstraint.Axis(rawValue: 1)!
        nameStackView.alignment = UIStackView.Alignment(rawValue: 1)!
        nameStackView.spacing = 4
        nameStackView.distribution = UIStackView.Distribution(rawValue: 0)!

        let priceView = UILabel()
        priceView.text = "Цена"
        priceView.font = UIFont(name: "SFProText-Medium", size: 13)
        priceView.textColor = UIColor(named: "Black")
        priceView.textAlignment = .left

        let priceStackView = UIStackView(arrangedSubviews: [priceView, nftPriceLabel])
        priceStackView.axis = NSLayoutConstraint.Axis(rawValue: 1)!
        priceStackView.alignment = UIStackView.Alignment(rawValue: 1)!
        priceStackView.spacing = 2
        priceStackView.distribution = UIStackView.Distribution(rawValue: 0)!

        let infoStackView = UIStackView(arrangedSubviews: [nameStackView, priceStackView])
        infoStackView.axis = NSLayoutConstraint.Axis(rawValue: 1)!
        infoStackView.alignment = UIStackView.Alignment(rawValue: 1)!
        infoStackView.spacing = 12
        infoStackView.distribution = UIStackView.Distribution(rawValue: 0)!

        let view = UIView()
        view.addSubview(infoStackView)

        [nameStackView, priceView, priceStackView, infoStackView, view].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        NSLayoutConstraint.activate([
            nftRatingView.heightAnchor.constraint(equalToConstant: 12),
            infoStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            infoStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            infoStackView.topAnchor.constraint(equalTo: view.topAnchor),
            infoStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        return view
    }

    func createNFTNameLabel() -> UILabel {
        let label = UILabel()
        label.text = " "
        label.font = UIFont(name: "SFProText-Bold", size: 17)
        label.textColor = UIColor(named: "Black")
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }

    func createNFTPriceLabel() -> UILabel {
        let label = UILabel()
        label.text = PriceFormatter.formattedPrice(0)
        label.font = UIFont(name: "SFProText-Bold", size: 17)
        label.textColor = UIColor(named: "Black")
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }

    func createDeleteNFTButton() -> UIButton {
        let button = UIButton()
        button.setImage(UIImage(named: "Delete"), for: .normal)
        button.tintColor = UIColor(named: "Black")
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(deleteButtonDidTap), for: .touchUpInside)
        return button
    }
}
