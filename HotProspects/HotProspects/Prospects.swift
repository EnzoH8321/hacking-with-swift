//
//  Prospects.swift
//  Prospects
//
//  Created by Enzo Herrera on 9/16/21.
//

import SwiftUI

class Prospect: Identifiable, Codable {
	let id = UUID()
	var name = "Anonymous"
	var emailAddress = ""
	//this property can be read from anywhere, but only written from the current file
	fileprivate(set) var isContacted = false
}

class Prospects: ObservableObject {
	//Even better, we can use access control to stop external writes to the people array, meaning that our views must use the add() method to add prospects
	@Published private(set) var people: [Prospect]

	static let saveKey = "SavedData"
	static let appDirectoryLocation = "HotProspects"

	func toggle(_ prospect: Prospect) {
		//You should call objectWillChange.send() before changing your property, to ensure SwiftUI gets its animations correct.
		objectWillChange.send()
		prospect.isContacted.toggle()
//		save()
	}

//	//Saves data to system
//	private func save() {
//		if let encoded = try? JSONEncoder().encode(people) {
//			UserDefaults.standard.set(encoded, forKey: Self.saveKey)
//		}
//	}

	func readFromDirectory() {
		let url = self.getDocumentsDirectory().appendingPathComponent(Prospects.appDirectoryLocation).appendingPathExtension("json")

		let data = try! Data(contentsOf: url)

		let decodedJson = try! JSONDecoder().decode([Prospect].self, from: data )

		people = decodedJson

		print(decodedJson)

	}

	func add(_ prospect: Prospect) {
		//Adds current prospect to prospect array
		people.append(prospect)
		//Converts prospect array(var people) into JSON
		let url = self.getDocumentsDirectory().appendingPathComponent(Prospects.appDirectoryLocation).appendingPathExtension("json")

		do {
			let data = try? JSONEncoder().encode(people)
			try data?.write(to: url, options: .atomic)
//			//Test
//			readFromDirectory()
			let input = try String(contentsOf: url)
			print("NEW URL \(input)")
		} catch {
			print("Error!")
			print(error.localizedDescription)
		}
	}

	//Database
	func getDocumentsDirectory() -> URL {
		// find all possible documents directories for this user
		let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)

		// just send back the first one, which ought to be the only one
		return paths[0]
	}

	//Updating the Prospects initializer so that it loads its data from UserDefaults where possible.
	init() {
		if let data = UserDefaults.standard.data(forKey: Self.saveKey) {
			if let decoded = try? JSONDecoder().decode([Prospect].self, from: data) {
				self.people = decoded
				return
			}
		}

		self.people = []
	}

}
