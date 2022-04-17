//
//  ImageDownloaderStub.swift
//  HomePresentationTests
//
//  Created by Hilal Hakkani on 08/04/2022.
//

import Foundation
import RxCocoa
import RxSwift
import Networking
import XCTest

class ImageDownloaderStub: ImageDownloader
{
	var loadedRequests = [String]()
	var canceledRequests = [String]()
	var images = [URL: Data]()

	var arrayOfObservables = [URL: ReplaySubject<Data>]()

	func downloadImage(url: URL) -> Observable<Data>
	{
		loadedRequests.append(url.absoluteString)
		let subject = getOrCreateSubjectForURL(url)
		return subject.asObservable()
	}

	func cancelDownloadImage(url: URL)
	{
		self.canceledRequests.append(url.absoluteString)
	}

	func stubImage(_ imageData: Data, for url: URL)
	{
		images[url] = imageData
		let subject = getOrCreateSubjectForURL(url)
		subject.onNext(imageData)
	}

	func getOrCreateSubjectForURL(_ url: URL) -> ReplaySubject<Data>
	{
		let subject = self.arrayOfObservables[url] ?? ReplaySubject<Data>.create(bufferSize: 1)
		self.arrayOfObservables[url] = subject
		return subject
	}

	func completeImageLoadingWithError(_ url: URL)
	{
		let subject = getOrCreateSubjectForURL(url)
		subject.onError(APIError.networkProblem)
	}

	func deleteCachedResponseForURL(url: URL)
	{
		self.arrayOfObservables[url] = nil
	}
}
