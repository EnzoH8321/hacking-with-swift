//
//  Bundle-Decodable.swift
//  Moonshot
//
//  Created by Enzo Herrera on 9/7/21.
//

import Foundation

extension Bundle {
	func decode<T: Codable>(_ file: String) -> T {
		//Find the the url of the file
		guard let url = self.url(forResource: file, withExtension: nil) else {
			fatalError("Failed to locate \(file) in bundle.")
		}
		//once located, turn the JSON into a data type
		guard let data = try? Data(contentsOf: url) else {
			fatalError("Failed to load \(file) from bundle.")
		}

		let decoder = JSONDecoder()
		let formatter = DateFormatter()
		formatter.dateFormat = "y-MM-dd"
		decoder.dateDecodingStrategy = .formatted(formatter)
		//Decode the data type and return an array of astronauts
		guard let loaded = try? decoder.decode(T.self, from: data) else {
			fatalError("Failed to decode \(file) from bundle.")
		}

		return loaded
	}
}
