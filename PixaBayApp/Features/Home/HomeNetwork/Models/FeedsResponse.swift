//
//  PixaBayRemoteResponse.swift
//  PixBayNetwork
//
//  Created by Pinpay Graphic on 16/10/2021.
//

import Foundation

import Foundation

public struct FeedsResponse: Decodable {
	public init(total: Int, totalHits: Int, hits: [Hit]) {
		self.total = total
		self.totalHits = totalHits
		self.hits = hits
	}

	public let total, totalHits: Int
	public let hits: [Hit]
}

public struct Hit: Decodable, Equatable {
	public init(id: Int, pageURL: String, type: String, tags: String, previewURL: String, previewWidth: Int, previewHeight: Int, webformatURL: String, webformatWidth: Int, webformatHeight: Int, largeImageURL: String, imageWidth: Int, imageHeight: Int, imageSize: Int, views: Int, downloads: Int, collections: Int, likes: Int, comments: Int, userID: Int, user: String, userImageURL: String) {
		self.id = id
		self.pageURL = pageURL
		self.type = type
		self.tags = tags
		self.previewURL = previewURL
		self.previewWidth = previewWidth
		self.previewHeight = previewHeight
		self.webformatURL = webformatURL
		self.webformatWidth = webformatWidth
		self.webformatHeight = webformatHeight
		self.largeImageURL = largeImageURL
		self.imageWidth = imageWidth
		self.imageHeight = imageHeight
		self.imageSize = imageSize
		self.views = views
		self.downloads = downloads
		self.collections = collections
		self.likes = likes
		self.comments = comments
		self.userID = userID
		self.user = user
		self.userImageURL = userImageURL
	}

	enum CodingKeys: String, CodingKey {
		case id, pageURL, type, tags, previewURL, previewWidth, previewHeight, webformatURL, webformatWidth, webformatHeight, largeImageURL, imageWidth, imageHeight, imageSize, views, downloads, collections, likes, comments
		case userID = "user_id"
		case user, userImageURL
	}

	public let id: Int
	public let pageURL: String
	public let type, tags: String
	public let previewURL: String
	public let previewWidth, previewHeight: Int
	public let webformatURL: String
	public let webformatWidth, webformatHeight: Int
	public let largeImageURL: String
	public let imageWidth, imageHeight, imageSize, views: Int
	public let downloads, collections, likes, comments: Int
	public let userID: Int
	public let user, userImageURL: String
}
