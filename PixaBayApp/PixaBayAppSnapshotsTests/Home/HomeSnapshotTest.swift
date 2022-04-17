//
//  HomeSnapshotTest.swift
//  PixBaySnapshotsTests
//
//  Created by Pinpay Graphic on 17/10/2021.
//

import Foundation
import XCTest
import HomePresentation
import HomeNetwork
import RxSwift
import RxCocoa
import SharedUI
import Networking

class HomeSnapshotTests: XCTestCase {
	func test_emptyHome() {
		let sut = makeSUT()
		assert(snapshot: sut.vc.snapshot(for: .iPhone8(style: .light)), named: "EMPTY_HomeTableView_light")
		assert(snapshot: sut.vc.snapshot(for: .iPhone8(style: .dark)), named: "EMPTY_HomeTableView_dark")
	}

	func test_HomeWithContent() {
		let sut = makeSUT()

		let feed1 = makeFeedImage(id: 1)
		let feed2 = makeFeedImage(id: 2)
		let feed3 = makeFeedImage(id: 3)

		sut.repo.stub(hits: [feed1, feed2, feed3])

		record(snapshot: sut.vc.snapshot(for: .iPhone8(style: .light)), named: "HomeTableView_WITH_CONTENT_light")
		record(snapshot: sut.vc.snapshot(for: .iPhone8(style: .dark)), named: "HomeTableView_WITH_CONTENT_dark")
	}

	// MARK: - Helpers

	private func makeSUT() -> (vc: HomeViewController, repo: PixaBayRepositoryStub) {
		let pixaBayRepository = PixaBayRepositoryStub()
		let imageDownloader = ImageDownloaderStub()
		let homeViewModel = HomeViewModel(pixaBayRepository: pixaBayRepository, imageDownloader: imageDownloader)

		let vc = HomeViewController.instantiate { coder in
			HomeViewController(coder: coder, viewModel: homeViewModel)
		}

		return (vc: vc, repo: pixaBayRepository)
	}

	private func makeFeedImage(id: Int) -> Hit
	{
		Hit(id: id, pageURL: "", type: "",
		    tags: "", previewURL: "",
		    previewWidth: 0,
		    previewHeight: 0, webformatURL: "",
		    webformatWidth: 0,
		    webformatHeight: 0,
		    largeImageURL: "anyURL.com",
		    imageWidth: 0,
		    imageHeight: 0,
		    imageSize: 0,
		    views: 0,
		    downloads: 0,
		    collections: 0,
		    likes: 0, comments: 0, userID: 0, user: "Title",
		    userImageURL: "1000")
	}

	private class PixaBayRepositoryStub: PixaBayRepository
	{
		let feedsSubject = PublishSubject<FeedsResponse>()
		var loadFeedCallCount = 0

		func getFeeds() -> Observable<FeedsResponse> {
			self.loadFeedCallCount += 1
			return feedsSubject.asObservable()
		}

		func stub(hits: [Hit])
		{
			let feedsResponse = FeedsResponse(total: 0, totalHits: 0, hits: hits)
			self.feedsSubject.onNext(feedsResponse)
		}
	}

	private class ImageDownloaderStub: ImageDownloader
	{
		public func cancelDownloadImage(url: URL) {}

		func downloadImage(url: URL) -> Observable<Data>
		{
			let data = UIImage.make(withColor: .blue).pngData()!
			return Observable.just(data)
		}
	}
}
