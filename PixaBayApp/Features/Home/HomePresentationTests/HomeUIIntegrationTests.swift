//
//  HomePresentationTests.swift
//  HomePresentationTests
//
//  Created by Hilal Hakkani on 29/03/2022.
//

import XCTest
import HomePresentation
import HomeNetwork
import Network
import RxSwift
import RxCocoa

class HomeUIIntegrationTests: XCTestCase {
	func test_imageSelection_notifiesHandler()
	{
		let (vc, _, _, repo) = self.makeSUT()
		let image0 = makeFeedImage()
		let image1 = makeFeedImage()
		let selectedImage = StateSpy<Hit>(observable: vc.rx.navigateToImageDetails.asObservable())
		vc.loadViewIfNeeded()

		repo.stub(hits: [image0, image1])

		vc.simulateTapOnFeedImageAtIndex(0)
		XCTAssertEqual(image0, selectedImage.values.first!)
		XCTAssertEqual(1, selectedImage.values.count)

		vc.simulateTapOnFeedImageAtIndex(1)
		XCTAssertEqual(image1, selectedImage.values.last!)
		XCTAssertEqual(2, selectedImage.values.count)
	}

	func test_loadFeedActions_requestFeedFromLoader() {
		let (vc, _, _, repo) = self.makeSUT()
		XCTAssertEqual(repo.loadFeedCallCount, 1, "Expected one loading request before loading the view")
		vc.loadViewIfNeeded()
		XCTAssertEqual(repo.loadFeedCallCount, 1, "Expected one loading request once view is loaded")

		vc.simulateUserInitiatedReload()
		XCTAssertEqual(repo.loadFeedCallCount, 2, "Expected another loading request once user initiates a reload")

		vc.simulateUserInitiatedReload()
		XCTAssertEqual(repo.loadFeedCallCount, 3, "Expected yet another loading request once user initiates another reload")
	}

	func test_loadingFeedIndicator_isVisibleWhileLoadingFeed() {
		let (vc, _, _, repo) = self.makeSUT()

		vc.loadViewIfNeeded()
		XCTAssertTrue(vc.isShowingLoadingIndicator, "Expected loading indicator once view is loaded")

		let image0 = makeFeedImage()
		repo.stub(hits: [image0])
		XCTAssertFalse(vc.isShowingLoadingIndicator, "Expected no loading indicator once loading completes successfully")

		vc.simulateUserInitiatedReload()
		XCTAssertTrue(vc.isShowingLoadingIndicator, "Expected loading indicator once user initiates a reload")

		repo.stub(hits: [image0])
		XCTAssertFalse(vc.isShowingLoadingIndicator, "Expected no loading indicator once user initiated loading completes with error")
	}

	func test_loadFeedCompletion_rendersSuccessfullyLoadedFeed() {
		let (vc, _, imageDownloader, repo) = self.makeSUT()
		let imageFeed0 = makeFeedImage()
		let data0 = UIImage.make(withColor: .red).pngData()!
		let url0 = URL(string: imageFeed0.largeImageURL)!

		let imageFeed1 = makeFeedImage()
		let data1 = UIImage.make(withColor: .blue).pngData()!
		let url1 = URL(string: imageFeed1.largeImageURL)!

		let imageFeed2 = makeFeedImage()
		let data2 = UIImage.make(withColor: .black).pngData()!
		let url2 = URL(string: imageFeed2.largeImageURL)!
		imageDownloader.stubImage(data2, for: url2)

		vc.loadViewIfNeeded()
		assertThat(vc, isRendering: [], imagesData: [])

		repo.stub(hits: [imageFeed0])

		imageDownloader.stubImage(data0, for: url0)
		assertThat(vc, isRendering: [imageFeed0], imagesData: [data0])

		repo.stub(hits: [imageFeed0, imageFeed1])
		vc.simulateUserInitiatedReload()

		imageDownloader.stubImage(data1, for: url1)
		assertThat(vc, isRendering: [imageFeed0, imageFeed1], imagesData: [data0, data1])

		repo.stub(hits: [imageFeed0, imageFeed1, imageFeed2])
		vc.simulateUserInitiatedReload()
		assertThat(vc, isRendering: [imageFeed0, imageFeed1, imageFeed2], imagesData: [data0, data1, data2])

		repo.stub(hits: [])
		assertThat(vc, isRendering: [], imagesData: [])
	}

	func test_loadFeedCompletion_doesNotAlterCurrentRenderingStateOnError() {
		let (vc, _, imageDownloader, repo) = self.makeSUT()
		let imageFeed0 = makeFeedImage()
		let data0 = UIImage.make(withColor: .red).pngData()!
		let url0 = URL(string: imageFeed0.largeImageURL)!
		imageDownloader.stubImage(data0, for: url0)

		vc.loadViewIfNeeded()
		assertThat(vc, isRendering: [], imagesData: [])

		repo.stub(hits: [imageFeed0])
		assertThat(vc, isRendering: [imageFeed0], imagesData: [data0])

		repo.completeFeedLoadingWithError()
		assertThat(vc, isRendering: [imageFeed0], imagesData: [data0])
	}

	func test_loadFeedCompletion_rendersErrorMessageOnErrorUntilNextReload() {
		let (vc, vm, _, repo) = self.makeSUT()
		let errorSpy = StateSpy<String>(observable: vm.output.error.asObservable())

		vc.loadViewIfNeeded()
		XCTAssertTrue(errorSpy.values.isEmpty)

		repo.completeFeedLoadingWithError()
		XCTAssertEqual(errorSpy.values, [APIError.networkProblem.localizedDescription])
	}

	// MARK: - Image View Tests

	func test_feedImageView_loadsImageURLWhenVisible() {
		let (vc, _, imageDownloader, repo) = self.makeSUT()

		let imageFeed0 = makeFeedImage()
		let redImage = UIImage.make(withColor: .red).pngData()!
		imageDownloader.stubImage(redImage, for: URL(string: imageFeed0.largeImageURL)!)

		let imageFeed1 = makeFeedImage()
		let blueImage = UIImage.make(withColor: .blue).pngData()!
		imageDownloader.stubImage(blueImage, for: URL(string: imageFeed1.largeImageURL)!)

		vc.loadViewIfNeeded()

		repo.stub(hits: [imageFeed0, imageFeed1])

		XCTAssertEqual(imageDownloader.loadedRequests, [], "Expected no image URL requests until views become visible")

		vc.simulateFeedImageViewVisible(at: 0)
		XCTAssertEqual(imageDownloader.loadedRequests, [imageFeed0.largeImageURL], "Expected first image URL request once first view becomes visible")

		vc.simulateFeedImageViewVisible(at: 1)
		XCTAssertEqual(imageDownloader.loadedRequests, [imageFeed0.largeImageURL, imageFeed1.largeImageURL], "Expected second image URL request once second view also becomes visible")
	}

	func test_feedImageView_cancelsImageLoadingWhenNotVisibleAnymore() {
		let (vc, _, imageDownloader, repo) = self.makeSUT()

		let imageFeed0 = makeFeedImage()
		let redImage = UIImage.make(withColor: .red).pngData()!

		let imageFeed1 = makeFeedImage()
		let blueImage = UIImage.make(withColor: .blue).pngData()!

		vc.loadViewIfNeeded()

		repo.stub(hits: [imageFeed0, imageFeed1])
		imageDownloader.stubImage(redImage, for: URL(string: imageFeed0.largeImageURL)!)
		imageDownloader.stubImage(blueImage, for: URL(string: imageFeed1.largeImageURL)!)

		XCTAssertEqual(imageDownloader.canceledRequests, [], "Expected no cancelled image URL requests until image is not visible")

		vc.simulateFeedImageViewNotVisible(at: 0)
		XCTAssertEqual(imageDownloader.canceledRequests, [imageFeed0.largeImageURL], "Expected one cancelled image URL request once first image is not visible anymore")

		vc.simulateFeedImageViewNotVisible(at: 1)
		XCTAssertEqual(imageDownloader.canceledRequests, [imageFeed0.largeImageURL, imageFeed1.largeImageURL], "Expected two cancelled image URL requests once second image is also not visible anymore")
	}

	func test_feedImageViewLoadingIndicator_isVisibleWhileLoadingImage() {
		let (vc, _, imageDownloader, repo) = self.makeSUT()

		let imageFeed0 = makeFeedImage()
		let image0 = UIImage.make(withColor: .red).pngData()!

		let imageFeed1 = makeFeedImage()

		vc.loadViewIfNeeded()

		repo.stub(hits: [imageFeed0, imageFeed1])

		let view0 = vc.simulateFeedImageViewVisible(at: 0)
		let view1 = vc.simulateFeedImageViewVisible(at: 1)
		XCTAssertEqual(view0?.isShowingImageLoadingIndicator, true, "Expected loading indicator for first view while loading first image")
		XCTAssertEqual(view1?.isShowingImageLoadingIndicator, true, "Expected loading indicator for second view while loading second image")

		imageDownloader.stubImage(image0, for: URL(string: imageFeed0.largeImageURL)!)

		XCTAssertEqual(view0?.isShowingImageLoadingIndicator, false, "Expected no loading indicator for first view once first image loading completes successfully")
		XCTAssertEqual(view1?.isShowingImageLoadingIndicator, true, "Expected no loading indicator state change for second view once first image loading completes successfully")

		imageDownloader.completeImageLoadingWithError(URL(string: imageFeed1.largeImageURL)!)
		XCTAssertEqual(view0?.isShowingImageLoadingIndicator, false, "Expected no loading indicator state change for first view once second image loading completes with error")
		XCTAssertEqual(view1?.isShowingImageLoadingIndicator, false, "Expected no loading indicator for second view once second image loading completes with error")

		view1?.simulateRetryAction()

		XCTAssertEqual(view0?.isShowingImageLoadingIndicator, false, "Expected no loading indicator state change for first view once second image loading completes with error")
		XCTAssertEqual(view1?.isShowingImageLoadingIndicator, true, "Expected loading indicator state change for second view on retry action")
	}

	func test_feedImageViewRetryButton_isVisibleOnImageURLLoadError() {
		let (vc, _, imageDownloader, repo) = self.makeSUT()

		vc.loadViewIfNeeded()
		let imageFeed0 = makeFeedImage()
		let imageFeed1 = makeFeedImage()

		let image0 = UIImage.make(withColor: .red).pngData()!
		repo.stub(hits: [imageFeed0, imageFeed1])

		let view0 = vc.simulateFeedImageViewVisible(at: 0)
		let view1 = vc.simulateFeedImageViewVisible(at: 1)
		XCTAssertEqual(view0?.isShowingRetryAction, false, "Expected no retry action for first view while loading first image")
		XCTAssertEqual(view1?.isShowingRetryAction, false, "Expected no retry action for second view while loading second image")

		imageDownloader.stubImage(image0, for: URL(string: imageFeed0.largeImageURL)!)
		XCTAssertEqual(view0?.isShowingRetryAction, false, "Expected no retry action for first view once first image loading completes successfully")
		XCTAssertEqual(view1?.isShowingRetryAction, false, "Expected no retry action state change for second view once first image loading completes successfully")

		imageDownloader.completeImageLoadingWithError(URL(string: imageFeed1.largeImageURL)!)
		XCTAssertEqual(view0?.isShowingRetryAction, false, "Expected no retry action state change for first view once second image loading completes with error")
		XCTAssertEqual(view1?.isShowingRetryAction, true, "Expected retry action for second view once second image loading completes with error")

		imageDownloader.deleteCachedResponseForURL(url: URL(string: imageFeed1.largeImageURL)!)
		view1?.simulateRetryAction()
		XCTAssertEqual(view0?.isShowingRetryAction, false, "Expected no retry action state change for first view on  second image retry")
		XCTAssertEqual(view1?.isShowingRetryAction, false, "Expected no retry action for second view on retry")
	}

	func test_feedImageViewRetryButton_isVisibleOnInvalidImageData() {
		let (vc, _, imageDownloader, repo) = self.makeSUT()
		vc.loadViewIfNeeded()
		let imageFeed0 = makeFeedImage()

		repo.stub(hits: [imageFeed0])

		let view = vc.simulateFeedImageViewVisible(at: 0)
		XCTAssertEqual(view?.isShowingRetryAction, false, "Expected no retry action while loading image")

		let invalidImageData = Data("invalid image data".utf8)
		imageDownloader.stubImage(invalidImageData, for: URL(string: imageFeed0.largeImageURL)!)

		XCTAssertEqual(view?.isShowingRetryAction, true, "Expected retry action once image loading completes with invalid image data")
	}

	func test_feedImageViewRetryAction_retriesImageLoad() {
		let (vc, _, imageDownloader, repo) = self.makeSUT()

		vc.loadViewIfNeeded()
		let imageFeed0 = makeFeedImage()
		let imageFeed1 = makeFeedImage()

		repo.stub(hits: [imageFeed0, imageFeed1])

		let view0 = vc.simulateFeedImageViewVisible(at: 0)
		let view1 = vc.simulateFeedImageViewVisible(at: 1)
		XCTAssertEqual(imageDownloader.loadedRequests, [imageFeed0.largeImageURL, imageFeed1.largeImageURL], "Expected two image URL request for the two visible views")

		imageDownloader.completeImageLoadingWithError(URL(string: imageFeed0.largeImageURL)!)
		imageDownloader.completeImageLoadingWithError(URL(string: imageFeed1.largeImageURL)!)

		XCTAssertEqual(imageDownloader.loadedRequests, [imageFeed0.largeImageURL, imageFeed1.largeImageURL], "Expected only two image URL requests before retry action")

		view0?.simulateRetryAction()
		XCTAssertEqual(imageDownloader.loadedRequests, [imageFeed0.largeImageURL, imageFeed1.largeImageURL, imageFeed0.largeImageURL], "Expected third imageURL request after first view retry action")

		view1?.simulateRetryAction()
		XCTAssertEqual(imageDownloader.loadedRequests, [imageFeed0.largeImageURL, imageFeed1.largeImageURL, imageFeed0.largeImageURL, imageFeed1.largeImageURL], "Expected third imageURL request after first view retry action")
	}

	func test_feedImageView_preloadsImageURLWhenNearVisible() {
		let (vc, _, imageDownloader, repo) = self.makeSUT()

		vc.loadViewIfNeeded()
		let imageFeed0 = makeFeedImage()
		let imageFeed1 = makeFeedImage()
		let image0 = UIImage.make(withColor: .red).pngData()!

		imageDownloader.stubImage(image0, for: URL(string: imageFeed0.largeImageURL)!)
		repo.stub(hits: [imageFeed0, imageFeed1])

		XCTAssertEqual(imageDownloader.loadedRequests, [], "Expected no image URL requests until image is near visible")

		vc.simulateFeedImageViewNearVisible(at: 0)

		XCTAssertEqual(imageDownloader.loadedRequests, [imageFeed0.largeImageURL], "Expected first image URL request once first image is near visible")

		vc.simulateFeedImageViewNearVisible(at: 1)
		XCTAssertEqual(imageDownloader.loadedRequests, [imageFeed0.largeImageURL, imageFeed1.largeImageURL], "Expected second image URL request once second image is near visible")
	}

	func test_feedImageView_cancelsImageURLPreloadingWhenNotNearVisibleAnymore() {
		let (vc, _, imageDownloader, repo) = self.makeSUT()

		vc.loadViewIfNeeded()
		let imageFeed0 = makeFeedImage()
		let imageFeed1 = makeFeedImage()
		let image0 = UIImage.make(withColor: .red).pngData()!

		imageDownloader.stubImage(image0, for: URL(string: imageFeed0.largeImageURL)!)
		repo.stub(hits: [imageFeed0, imageFeed1])

		XCTAssertEqual(imageDownloader.canceledRequests, [], "Expected no cancelled image URL requests until image is not near visible")

		vc.simulateFeedImageViewNotNearVisible(at: 0)
		XCTAssertEqual(imageDownloader.canceledRequests, [imageFeed0.largeImageURL], "Expected first cancelled image URL request once first image is not near visible anymore")

		vc.simulateFeedImageViewNotNearVisible(at: 1)
		XCTAssertEqual(imageDownloader.canceledRequests, [imageFeed0.largeImageURL, imageFeed1.largeImageURL], "Expected second cancelled image URL request once second image is not near visible anymore")
	}

	// MARK: - Helpers
	private func makeSUT(
		selection: @escaping (Hit) -> Void = { _ in },
		file: StaticString = #filePath,
		line: UInt = #line
	) -> (sut: HomeViewController, vm: HomeViewModel,
	      imageDownloader: ImageDownloaderStub, repo: PixaBayRepositoryStub) {
		let pixaBayRepository = PixaBayRepositoryStub()
		let imageDownloader = ImageDownloaderStub()
		let homeViewModel = HomeViewModel(pixaBayRepository: pixaBayRepository, imageDownloader: imageDownloader)

		let sut = HomeViewController.instantiate { coder in
			HomeViewController(coder: coder, viewModel: homeViewModel)
		}
		trackForMemoryLeaks(sut, file: file, line: line)
		trackForMemoryLeaks(homeViewModel, file: file, line: line)
		trackForMemoryLeaks(imageDownloader, file: file, line: line)
		trackForMemoryLeaks(pixaBayRepository, file: file, line: line)

		return (sut, homeViewModel, imageDownloader, pixaBayRepository)
	}

	private func makeFeedImage() -> Hit
	{
		Hit(id: Int.random(in: 0 ... 1000), pageURL: "", type: "",
		    tags: "", previewURL: "",
		    previewWidth: Int.random(in: 0 ... 1000),
		    previewHeight: 0, webformatURL: "",
		    webformatWidth: Int.random(in: 0 ... 10000),
		    webformatHeight: Int.random(in: 0 ... 10000),
		    largeImageURL: randomString(of: 5) + ".com",
		    imageWidth: Int.random(in: 0 ... 1000),
		    imageHeight: Int.random(in: 0 ... 1000),
		    imageSize: Int.random(in: 0 ... 10000),
		    views: 200,
		    downloads: Int.random(in: 0 ... 10000),
		    collections: Int.random(in: 0 ... 100000),
		    likes: 0, comments: 0, userID: 0, user: "", userImageURL: "1000")
	}

	func assertThat(_ sut: HomeViewController, isRendering hits: [Hit], imagesData: [Data], file: StaticString = #filePath, line: UInt = #line) {
		guard sut.numberOfRenderedFeedImageViews() == hits.count else {
			return XCTFail("Expected \(hits.count) images, got \(sut.numberOfRenderedFeedImageViews()) instead.", file: file, line: line)
		}

		zip(hits, imagesData).enumerated().forEach { index, element in
			let hit = element.0
			let data = element.1
			assertThat(sut, hasViewConfiguredFor: hit, at: index, imageData: data, file: file, line: line)
		}
	}

	private func executeRunLoopToCleanUpReferences() {
		RunLoop.current.run(until: Date())
	}

	func assertThat(_ sut: HomeViewController, hasViewConfiguredFor hit: Hit, at index: Int, imageData: Data, file: StaticString = #filePath, line: UInt = #line) {
		let view = sut.feedImageView(at: index)

		guard let cell = view as? HomeTableViewCell else {
			return XCTFail("Expected \(HomeTableViewCell.self) instance, got \(String(describing: view)) instead", file: file, line: line)
		}

		XCTAssertEqual(cell.title, hit.user, "Different title at index (\(index))", file: file, line: line)

		XCTAssertEqual(cell.imageData, imageData, "Differant image at index (\(index))", file: file, line: line)
	}

	func randomString(of length: Int) -> String {
		let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
		var s = ""
		for _ in 0 ..< length {
			s.append(letters.randomElement()!)
		}
		return s
	}
}
