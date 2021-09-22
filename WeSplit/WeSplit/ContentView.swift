//
//  ContentView.swift
//  WeSplit
//
//  Created by Enzo Herrera on 8/31/21.
//

import SwiftUI

struct ContentView: View {
	
	@State private var checkAmount = ""
	@State private var numberOfPeople = ""
	@State private var tipPercentage = 2
	
	let tipPercentages = [10, 15, 20, 25, 0]
	
	
	
	var totalPerPerson: (Double, Double) {
		let peopleCount = Double(numberOfPeople) ?? 0
		let tipSelection = Double(tipPercentage)
		let orderAmount = Double(checkAmount) ?? 0

		let tipValue = orderAmount / 100 * tipSelection
		let grandTotal = orderAmount + tipValue
		let amountPerPerson = grandTotal / peopleCount

		return (amountPerPerson, grandTotal)
	}
	
	var body: some View {
		NavigationView {
		Form {
			Section {
				TextField("Amount", text: $checkAmount)
					.keyboardType(.decimalPad)
				Picker("Number of People", selection: $numberOfPeople, content: {
//					ForEach(2 ..< 100) {
//								Text("\($0) people")
//								TextField("Amount", text: "\($0)")
//							}
					TextField("Amount", text: $numberOfPeople)
				})
			}
			
			//For Tip
			Section(header: Text("How much tip do you want to leave?")) {
				Picker("Tip percentage", selection: $tipPercentage) {
					ForEach(0 ..< tipPercentages.count) {
						Text("\(self.tipPercentages[$0])%")
					}
				}
			}
			.pickerStyle(SegmentedPickerStyle())
			
			//Original amount + TIP
			Section(header: Text("Amount + Tip")) {
				Text("\(totalPerPerson.1)")
			}
			
			Section(header: Text("Amount per Person")) {
				Text("$\(totalPerPerson.0, specifier: "%.2f")")
			}
		}
		.navigationBarTitle("WeSplit")
		}
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
	}
}
}

