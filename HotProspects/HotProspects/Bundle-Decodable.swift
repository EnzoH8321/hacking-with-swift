//
//  Bundle-Decodable.swift
//  Bundle-Decodable
//
//  Created by Enzo Herrera on 9/17/21.
//

import Foundation


extension Bundle {

	func decode(_ file: String) -> [Prospect] {
		   guard let url = self.url(forResource: file, withExtension: nil) else {
			   fatalError("Failed to locate \(file) in bundle.")
		   }

		   guard let data = try? Data(contentsOf: url) else {
			   fatalError("Failed to load \(file) from bundle.")
		   }

		   let decoder = JSONDecoder()

		   guard let loaded = try? decoder.decode([Prospect].self, from: data) else {
			   fatalError("Failed to decode \(file) from bundle.")
		   }

		   return loaded
	   }
}
