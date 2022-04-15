//
//  Injection.swift
//  PixaBayApp
//
//  Created by Hilal Hakkani on 22/02/2022.
//

import Foundation
import Resolver
import Network
import HomeNetwork
import HomePresentation
import RegistrationNetwork
import RegistrationPresentation

extension Resolver: ResolverRegistering
{
	public static func registerAllServices()
	{
		//MARK: Repositories
		register { PixaBayRepositoryImple(httpClient: resolve(), hostURL: URL(string: "https://pixabay.com")!) as PixaBayRepository }
		register { UserRepositoryMock() as UserRepository }

		//MARK: Helpers
		register { URLSessionHTTPClient() as HTTPClient }
		register { SDWebImageCacher() as ImageDownloader }.scope(.application)
	}
}
