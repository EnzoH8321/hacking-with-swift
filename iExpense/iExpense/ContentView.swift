//
//  ContentView.swift
//  iExpense
//
//  Created by Enzo Herrera on 9/3/21.
//

import SwiftUI

struct ExpenseItem: Identifiable, Codable {
	let name: String
	let type: String
	let amount: Int
	var id = UUID()
}

enum Colors {
	case red
	case green
	case blue
}

class Expenses: ObservableObject {
	@Published var items = [ExpenseItem]() {
		didSet {
			let encoder = JSONEncoder()
			if let encoded = try? encoder.encode(items) {
				UserDefaults.standard.set(encoded, forKey: "Items")
			}
		}
	}

	init() {
		if let items = UserDefaults.standard.data(forKey: "Items") {
			let decoder = JSONDecoder()
			if let decoded = try? decoder.decode([ExpenseItem].self, from: items) {
				self.items = decoded
				return
			}
		}

		self.items = []
	}

}

struct ContentView: View {
	//Observable
	@ObservedObject var expenses = Expenses()
	//
	@State private var user = User(firstName: "Taylor", lastName: "Swift")
	@State private var showingAddExpense = false

	
	
	struct User: Codable {
		var firstName: String
		var lastName: String
	}
	
	
	var body: some View {
		NavigationView {
			List {
				ForEach(expenses.items) { item in
					HStack {
						VStack(alignment: .leading) {
							Text(item.name)
								.font(.headline)
							Text(item.type)
						}

						Spacer()
						Text("$\(item.amount)")
							.foregroundColor(item.amount < 100 ? .red : item.amount < 200 ? .yellow : .blue)
						Button(action: {
							if let chosen = expenses.items.firstIndex(where: {element in element.id == item.id}) {
								expenses.items.remove(at: chosen)
							}

						}, label: {
							Image(systemName: "minus")
						})
					}

				}

				.onDelete(perform: removeItems)
			}
			.navigationBarTitle("iExpense")
			.navigationBarItems(trailing:
									Button(action: {
										self.showingAddExpense = true
									}) {
										Image(systemName: "plus")
									}
			)
		}
		.sheet(isPresented: $showingAddExpense) {
			AddView(expenses: self.expenses)
		}
	}
	
	func removeItems(at offsets: IndexSet) {
		expenses.items.remove(atOffsets: offsets)
	}

	struct ContentView_Previews: PreviewProvider {
		static var previews: some View {
			Group {
				ContentView()
				ContentView()
			}
		}
	}
	
}
