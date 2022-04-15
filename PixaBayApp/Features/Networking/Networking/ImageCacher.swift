//
//  ImageCacher.swift
//  PixabayNetwork
//
//  Created by Hilal Hakkani on 04/03/2022.
//

import Foundation
import RxSwift
import SDWebImage

public protocol ImageDownloader {
	func downloadImage(url: URL) -> Observable<Data>
	func cancelDownloadImage(url: URL)
}

public class SDWebImageCacher: ImageDownloader {
	public init() {}

	var imageDownloader = [URL: SDWebImageDownloadToken]()

	public func downloadImage(url: URL) -> Observable<Data> {
		Observable.create { [unowned self] observer in
			if let data = SDImageCache.shared.imageFromCache(forKey: url.absoluteString)
			{
				observer.onNext(data.pngData()!)
				observer.onCompleted()
			} else {
				self.imageDownloader[url] = SDWebImageDownloader.shared.downloadImage(with: url) { image, data, error, _ in
					if error != nil {
						self.imageDownloader[url] = nil
						observer.onError(error!)
					} else {
						observer.onNext(data!)
						SDImageCache.shared.storeImageData(toDisk: data!, forKey: url.absoluteString)
						self.imageDownloader[url] = nil
						observer.onCompleted()
					}
				}
			}
			return Disposables.create()
		}
		.observe(on: MainScheduler.instance)
		.subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background))
	}

	public func cancelDownloadImage(url: URL) {
		self.imageDownloader[url]?.cancel()
		self.imageDownloader[url] = nil
	}
}
