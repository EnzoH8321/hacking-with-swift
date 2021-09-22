//
//  ContentView.swift
//  BetterRest
//
//  Created by Enzo Herrera on 9/1/21.
//

import SwiftUI

struct ContentView: View {
	
	func calculateBedtime() {
		
		let model = SleepCalculator()
		
		let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
		let hour = (components.hour ?? 0) * 60 * 60
		let minute = (components.minute ?? 0) * 60
		
		do {
			let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))
			let sleepTime = wakeUp - prediction.actualSleep
			let formatter = DateFormatter()
			formatter.timeStyle = .short
			
			alertMessage = formatter.string(from: sleepTime)
			alertTitle = "Your ideal bedtime is…"
		} catch {
			alertTitle = "Error"
			alertMessage = "Sorry, there was a problem calculating your bedtime."
		}
		showingAlert = true
		
	}
	
	static var defaultWakeTime: Date {
		var components = DateComponents()
		components.hour = 7
		components.minute = 0
		return Calendar.current.date(from: components) ?? Date()
	}
	
	@State private var wakeUp = defaultWakeTime
	@State private var sleepAmount = 8.0
	@State private var coffeeAmount = 1
	@State private var alertTitle = ""
	@State private var alertMessage = ""
	@State private var showingAlert = false
	
	
	
	var body: some View {
		NavigationView {
			Form {
				Section(header: Text("When do you want to wake up").bold()){
					DatePicker("Please enter a time", selection: $wakeUp, displayedComponents: .hourAndMinute)
						.labelsHidden()
						.datePickerStyle(WheelDatePickerStyle())
				}
				Section(header: Text("Desired amount of sleep"), content: {
					Stepper(value: $sleepAmount, in: 4...12, step: 0.25) {
						Text("\(sleepAmount, specifier: "%g") hours")
					}
				})
				Section(header: Text("Daily coffee intake"), content: {
					Picker("Coffee Intake", selection: $coffeeAmount, content: {
						ForEach(1..<21) {element in
							if element == 1 {
								Text("\(element) cup")
								
							} else {
								Text("\(element) cups")
								
							}
						}
					})
					.onChange(of: coffeeAmount, perform: { value in
						calculateBedtime()
						print(value)
					})
					
				})
				Text("Your ideal bedtime is \(alertMessage)")
			}
			.navigationBarTitle("BetterRest")
//			.navigationBarItems(trailing:
//									Button(action: calculateBedtime) {
//										Text("Calculate")
//									}
//			)
//			.alert(isPresented: $showingAlert) {
//				Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK")))
//			}
		}
		
	}
	
}



struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
	}
}
