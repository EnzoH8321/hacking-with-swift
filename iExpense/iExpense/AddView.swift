//
//  AddView.swift
//  iExpense
//
//  Created by Enzo Herrera on 9/3/21.
//

import SwiftUI
import Combine

struct AddView: View {
	@Environment(\.presentationMode) var presentationMode
	//So, what we’re going to do is add a property to AddView to store an Expenses object. It won’t create the object there, just say that it will exist. Please add this property to AddView:
	@ObservedObject var expenses: Expenses
	@State private var name = ""
	@State private var type = "Personal"
	@State private var amount = ""
	
	static let types = ["Business", "Personal"]

	var body: some View {
		NavigationView {
			Form {
				TextField("Name", text: $name)
				Picker("Type", selection: $type, content: {
					ForEach(Self.types, id: \.self, content: {Text($0)})
				})
				TextField("Amount", text: $amount)
					.keyboardType(.numberPad)
					.onReceive(Just(amount)) { newValue in
						let filtered = newValue.filter { "0123456789".contains($0) }
						if filtered != newValue {
							self.amount = filtered
						}
					}
			}
			.navigationBarTitle("Add new expense")
			.navigationBarItems(trailing: Button("Save") {
				if let actualAmount = Int(self.amount) {
					let item = ExpenseItem(name: self.name, type: self.type, amount: actualAmount)
					self.expenses.items.append(item)
				}
				self.presentationMode.wrappedValue.dismiss()

			})
		}

	}
}

struct AddView_Previews: PreviewProvider {
	static var previews: some View {
		AddView(expenses: Expenses())
	}
}
