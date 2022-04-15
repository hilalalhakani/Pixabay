//
//  HomeTableViewCell.swift
//  PixBay
//
//  Created by Pinpay Graphic on 16/10/2021.
//
import Foundation
import RxCocoa
import RxSwift
import SharedUI
import UIKit

public class HomeTableViewCell: UITableViewCell {
	@IBOutlet public var feedImageView: UIImageView!
	@IBOutlet public var feedImageContainer: UIView!
	@IBOutlet public var feedUserLabel: UILabel!
	@IBOutlet public var retryButton: UIButton!

	private var disposeBag = DisposeBag()
	public var cellViewModel: HitImageCellViewModel? {
		didSet {
			guard let vm = cellViewModel else { return }
			setupBinding(viewModel: vm)
		}
	}

	public override func awakeFromNib() {
		super.awakeFromNib()
		self.feedImageContainer.startShimmering()
	}

	override public func prepareForReuse() {
		self.disposeBag = DisposeBag()
		self.feedImageView.image = nil
		self.feedImageContainer.stopShimmering()
		self.retryButton.isHidden = true
	}

	private func setupBinding(viewModel: HitImageCellViewModel) {
		viewModel.output.isFeedImageContainerShimmering
			.drive(onNext: { [weak self] shouldShimmer in
				if shouldShimmer {
					self?.feedImageContainer.startShimmering()
				} else {
					self?.feedImageContainer.stopShimmering()
				}
			}).disposed(by: self.disposeBag)

		self.retryButton.rx.tap
			.map({ _ in () })
			.bind(to: viewModel.input.retry)
			.disposed(by: self.disposeBag)

		viewModel.output.feedUserLabel
			.drive(self.feedUserLabel.rx.text)
			.disposed(by: self.disposeBag)

		let feedImage =
			viewModel.output.feedImageData
				.map({ UIImage(data: $0) })
				.asSharedSequence()

		Driver.merge(
			feedImage.map { $0 != nil },
			viewModel.output.isRetryButtonHidden)
			.drive(self.retryButton.rx.isHidden)
			.disposed(by: self.disposeBag)

		feedImage
			.filter({ $0 != nil })
			.drive(self.feedImageView.rx.image)
			.disposed(by: self.disposeBag)
	}
}
