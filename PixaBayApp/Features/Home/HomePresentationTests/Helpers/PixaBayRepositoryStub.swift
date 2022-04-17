//
//  PixaBayRepositoryStub.swift
//  HomePresentationTests
//
//  Created by Hilal Hakkani on 08/04/2022.
//

import Foundation
import RxSwift
import HomeNetwork
import Networking
class PixaBayRepositoryStub: PixaBayRepository
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

	func completeFeedLoadingWithError(error: Error = APIError.networkProblem)
	{
		self.feedsSubject.onError(error)
	}
}
