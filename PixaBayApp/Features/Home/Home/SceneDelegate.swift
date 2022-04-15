//
//  SceneDelegate.swift
//  Home
//
//  Created by Hilal Hakkani on 29/03/2022.
//

import UIKit
import HomeNetwork
import HomePresentation
import Network
import RxSwift

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
	var window: UIWindow?

	func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
		guard let scene = (scene as? UIWindowScene) else { return }

		self.window = UIWindow(windowScene: scene)
		self.window?.rootViewController = UINavigationController(rootViewController: setupController())

		window?.makeKeyAndVisible()
	}

	// MARK: - Helpers
	private func setupController() -> HomeViewController {
		let pixaBayRepository = PixaBayRepositoryStub()
		let imageDownloader = ImageDownloaderStub()
		let homeViewModel = HomeViewModel(pixaBayRepository: pixaBayRepository, imageDownloader: imageDownloader)

		let feed1 = makeFeedImage()
		let feed2 = makeFeedImage()
		let feed3 = makeFeedImage()
		pixaBayRepository.stub(hits: [feed1, feed2, feed3])

		return HomeViewController.instantiate { coder in
			HomeViewController(coder: coder, viewModel: homeViewModel)
		}
	}

	private func makeFeedImage() -> Hit
	{
		Hit(id: Int.random(in: 0 ... 1000), pageURL: "", type: "",
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
			let color = UIColor(red: .random(in: 0 ... 1), green: .random(in: 0 ... 1), blue: .random(in: 0 ... 1), alpha: 1)
			let data = UIImage.make(withColor: color).pngData()!
			return Observable.just(data)
		}
	}
}
