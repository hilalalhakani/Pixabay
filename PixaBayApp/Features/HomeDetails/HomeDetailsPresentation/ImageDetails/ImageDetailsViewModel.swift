//
//  ImageDetailsViewModel.swift
//  PixBay
//
//  Created by Pinpay Graphic on 17/10/2021.
//

import Foundation
import HomeNetwork
import RxSwift
import UIKit
import RxCocoa
import Network
import SharedUI

public class ImageDetailsViewModel {
	struct Output
	{
		let imageSize: Driver<String>
		let imageType: Driver<String>
		let imageTags: Driver<String>
		let imageUser: Driver<String>
		let numberOfViews: Driver<String>
		let numberOfLikes: Driver<String>
		let numberOfComments: Driver<String>
		let numberOfDownloads: Driver<String>
		let feedImageData: Driver<Data>
	}

	let output: Output

	public init(hit: Hit, imageDownloader: ImageDownloader) {
		let imageType = Observable.just(hit.type)
		let imageTags = Observable.just(hit.tags)
		let imageUser = Observable.just(hit.user)
		let numberOfViews = Observable.just("\(hit.views)")
		let numberOfLikes = Observable.just("\(hit.likes)")
		let numberOfComments = Observable.just("\(hit.comments)")
		let numberOfDownloads = Observable.just("\(hit.downloads)")
		let imageSize = Observable.just(BytesFormatter.formatSize(hit.imageSize))

		let feedImageData = Observable.just(())
			.flatMap { () -> Observable<Data> in
				let url = URL(string: hit.largeImageURL)!
				return imageDownloader.downloadImage(url: url)
			}

		self.output = Output(
			imageSize: imageSize.asDriver(onErrorDriveWith: .empty()),
			imageType: imageType.asDriver(onErrorDriveWith: .empty()),
			imageTags: imageTags.asDriver(onErrorDriveWith: .empty()),
			imageUser: imageUser.asDriver(onErrorDriveWith: .empty()),
			numberOfViews: numberOfViews.asDriver(onErrorDriveWith: .empty()),
			numberOfLikes: numberOfLikes.asDriver(onErrorDriveWith: .empty()),
			numberOfComments: numberOfComments.asDriver(onErrorDriveWith: .empty()),
			numberOfDownloads: numberOfDownloads.asDriver(onErrorDriveWith: .empty()),
			feedImageData: feedImageData.asDriver(onErrorDriveWith: .empty()))
	}
}
