//
//  ImageDetailsViewController.swift
//  PixBay
//
//  Created by Pinpay Graphic on 17/10/2021.
//

import Foundation
import RxSwift
import UIKit
import RxCocoa
import SharedUI

public class ImageDetailsViewController: UIViewController, Storyboarded {
	@IBOutlet private var hitImageView: UIImageView!
	@IBOutlet private var hitType: UILabel!
	@IBOutlet private var hitTags: UILabel!
	@IBOutlet private var hitUserName: UILabel!
	@IBOutlet private var hitViews: UILabel!
	@IBOutlet private var hitLikes: UILabel!
	@IBOutlet private var hitComments: UILabel!
	@IBOutlet private var hitDownloads: UILabel!
	@IBOutlet private var hitSize: UILabel!

	private var viewModel: ImageDetailsViewModel!
	private let disposeBag = DisposeBag()

	//MARK: Initialization
	public init?(coder: NSCoder, viewModel: ImageDetailsViewModel) {
		self.viewModel = viewModel
		super.init(coder: coder)
	}

	required init?(coder _: NSCoder) {
		fatalError("Use `init(coder:ImageDetailsViewModel:)` to initialize a `ImageDetailsViewModel` instance.")
	}
}

extension ImageDetailsViewController {
	public override func viewDidLoad() {
		super.viewDidLoad()
		setupUI()
	}

	func setupUI() {
		self.viewModel.output.imageSize
			.drive(self.hitSize.rx.text)
			.disposed(by: self.disposeBag)

		self.viewModel.output.imageTags
			.drive(self.hitTags.rx.text)
			.disposed(by: self.disposeBag)

		self.viewModel.output.imageType
			.drive(self.hitType.rx.text)
			.disposed(by: self.disposeBag)

		self.viewModel.output.imageTags
			.drive(self.hitTags.rx.text)
			.disposed(by: self.disposeBag)

		self.viewModel.output.numberOfViews
			.drive(self.hitViews.rx.text)
			.disposed(by: self.disposeBag)

		self.viewModel.output.numberOfLikes
			.drive(self.hitLikes.rx.text)
			.disposed(by: self.disposeBag)

		self.viewModel.output.numberOfComments
			.drive(self.hitComments.rx.text)
			.disposed(by: self.disposeBag)

		self.viewModel.output.numberOfDownloads
			.drive(self.hitDownloads.rx.text)
			.disposed(by: self.disposeBag)

		self.viewModel.output.feedImageData
			.map(UIImage.init)
			.drive(self.hitImageView.rx.image)
			.disposed(by: self.disposeBag)
	}
}
