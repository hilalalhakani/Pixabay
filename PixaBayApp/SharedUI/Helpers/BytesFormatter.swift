//
//  BytesFormatter.swift
//  PixBay
//
//  Created by Pinpay Graphic on 17/10/2021.
//

import Foundation

public class BytesFormatter {
	public static func formatSize(_ bytes: Int) -> String {
		let formatter = ByteCountFormatter()
		formatter.countStyle = .binary
		return formatter.string(fromByteCount: Int64(bytes))
	}
}
