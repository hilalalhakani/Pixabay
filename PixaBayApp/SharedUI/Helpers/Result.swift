//
//  Result.swift
//  PixaBayiOS
//
//  Created by Hilal Hakkani on 06/03/2022.
//

import Foundation

extension Result
{
	public func error() -> Error?
	{
		guard case let .failure(error) = self else { return nil }
		return error
	}
}
