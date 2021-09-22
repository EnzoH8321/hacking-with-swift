//
//  Order.swift
//  CupcakeCorner
//
//  Created by Enzo Herrera on 9/9/21.
//

import Foundation

class Order: ObservableObject, Codable {
	//Enum
	enum CodingKeys: CodingKey {
		case type, quantity, extraFrosting, addSprinkles, name, streetAddress, city, zip
	}
	//The second step requires us to write an encode(to:) method that creates a container using the coding keys enum we just created, then writes out all the properties attached to their respective key.
	func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)

		try container.encode(type, forKey: .type)
		try container.encode(quantity, forKey: .quantity)

		try container.encode(extraFrosting, forKey: .extraFrosting)
		try container.encode(addSprinkles, forKey: .addSprinkles)

		try container.encode(name, forKey: .name)
		try container.encode(streetAddress, forKey: .streetAddress)
		try container.encode(city, forKey: .city)
		try container.encode(zip, forKey: .zip)
	}
	//Initializers
	required init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)

		type = try container.decode(Int.self, forKey: .type)
		quantity = try container.decode(Int.self, forKey: .quantity)

		extraFrosting = try container.decode(Bool.self, forKey: .extraFrosting)
		addSprinkles = try container.decode(Bool.self, forKey: .addSprinkles)

		name = try container.decode(String.self, forKey: .name)
		streetAddress = try container.decode(String.self, forKey: .streetAddress)
		city = try container.decode(String.self, forKey: .city)
		zip = try container.decode(String.self, forKey: .zip)
	}
	//
	init() { }


	static let types = ["Vanilla", "Strawberry", "Chocolate", "Rainbow"]

	@Published var type = 0
	@Published var quantity = 3
	@Published var name = ""
	@Published var streetAddress = ""
	@Published var city = ""
	@Published var zip = ""

	var hasValidAddress: Bool {
		if name.isEmpty || streetAddress.isEmpty || city.isEmpty || zip.isEmpty {
			return false
		}

		if checkIfAllWhiteSpace(in: name) || checkIfAllWhiteSpace(in: streetAddress) || checkIfAllWhiteSpace(in: city) || checkIfAllWhiteSpace(in: zip) {
			return false
		}

		return true
	}

	//Checks to see if inputted string is only whitespace
	func checkIfAllWhiteSpace(in testString: String) -> Bool {
		var onlyWhitespace = true

		for char in testString {
			if (!char.isWhitespace) {
				onlyWhitespace = false
			}

		}
		return onlyWhitespace
	}

	var cost: Double {
		// $2 per cake
		var cost = Double(quantity) * 2

		// complicated cakes cost more
		cost += (Double(type) / 2)

		// $1/cake for extra frosting
		if extraFrosting {
			cost += Double(quantity)
		}

		// $0.50/cake for sprinkles
		if addSprinkles {
			cost += Double(quantity) / 2
		}

		return cost
	}

	@Published var specialRequestEnabled = false {
		didSet {
			if specialRequestEnabled == false {
				extraFrosting = false
				addSprinkles = false
			}
		}
	}
	@Published var extraFrosting = false
	@Published var addSprinkles = false
}


