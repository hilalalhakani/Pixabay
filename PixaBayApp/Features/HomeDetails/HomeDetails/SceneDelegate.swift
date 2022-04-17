//
//  SceneDelegate.swift
//  HomeDetails
//
//  Created by Hilal Hakkani on 29/03/2022.
//

import UIKit
import HomeDetailsPresentation
import HomeNetwork
import Networking
import RxSwift

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
	var window: UIWindow?

	func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
		guard let scene = (scene as? UIWindowScene) else { return }

		let hit = makeHit()
		let imageDownloader = DummyImageDownloader()
		let vc = ImageDetailsViewController.instantiate { coder in
			let viewModel = ImageDetailsViewModel(hit: hit, imageDownloader: imageDownloader)
			return ImageDetailsViewController(coder: coder, viewModel: viewModel)
		}
		self.window = UIWindow(windowScene: scene)
		self.window?.rootViewController = vc

		window?.makeKeyAndVisible()
	}

	private func makeHit() -> Hit
	{
		Hit(id: Int.random(in: 0 ... 1000),
		    pageURL: "pageURL",
		    type: "Type",
		    tags: "Tags",
		    previewURL: "",
		    previewWidth: Int.random(in: 0 ... 1000),
		    previewHeight: 0, webformatURL: "",
		    webformatWidth: Int.random(in: 0 ... 10000),
		    webformatHeight: Int.random(in: 0 ... 10000),
		    largeImageURL: "test.com",
		    imageWidth: Int.random(in: 0 ... 1000),
		    imageHeight: Int.random(in: 0 ... 1000),
		    imageSize: Int.random(in: 0 ... 10000),
		    views: 200,
		    downloads: Int.random(in: 0 ... 10000),
		    collections: Int.random(in: 0 ... 100000),
		    likes: 10,
		    comments: 3330,
		    userID: 0,
		    user: "UserName",
		    userImageURL: "1000")
	}

	private class DummyImageDownloader: ImageDownloader
	{
		func cancelDownloadImage(url: URL) {}

		public func downloadImage(url: URL) -> Observable<Data> {
			.just(UIImage.make(withColor: .red).pngData()!)
		}
	}
}
