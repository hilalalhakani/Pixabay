//
//  ImageDetailsSnapshots.swift
//  PixBaySnapshotsTests
//
//  Created by Pinpay Graphic on 17/10/2021.
//

import Foundation
import XCTest
import RxSwift
import RxCocoa
import HomeDetailsPresentation
import HomeNetwork
import SharedUI
import Networking

class ImageDetailsSnapshotTests: XCTestCase {
	func test_ImageDetails() {
		let sut = makeSUT()
		assert(snapshot: sut.snapshot(for: .iPhone8(style: .light)), named: "ImageDetails_light")
		assert(snapshot: sut.snapshot(for: .iPhone8(style: .dark)), named: "ImageDetails_dark")
	}

	// MARK: - Helpers

	private func makeSUT() -> ImageDetailsViewController {
		let viewModel = ImageDetailsViewModel(hit: makeHit(), imageDownloader: ImageDownloaderStub())
		let controller = ImageDetailsViewController.instantiate { coder in
			ImageDetailsViewController(coder: coder, viewModel: viewModel)
		}
		controller.loadViewIfNeeded()
		return controller
	}

	private func makeHit() -> Hit {
		Hit(id: 0, pageURL: "", type: "Test", tags: "Tag", previewURL: "", previewWidth: 0, previewHeight: 30, webformatURL: "", webformatWidth: 0, webformatHeight: 0, largeImageURL: "anyurl.com", imageWidth: 20, imageHeight: 0, imageSize: 100, views: 60, downloads: 70, collections: 100, likes: 990, comments: 10, userID: 20, user: "Snapshot User", userImageURL: "")
	}

	private class ImageDownloaderStub: ImageDownloader
	{
		func downloadImage(url: URL) -> Observable<Data> {
			let data = UIImage.make(withColor: .red).pngData()!
			return Observable.just(data)
		}

		func cancelDownloadImage(url: URL) {}
	}
}
