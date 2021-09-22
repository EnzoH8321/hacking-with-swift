//
//  CheckoutView.swift
//  CupcakeCorner
//
//  Created by Enzo Herrera on 9/9/21.
//

import SwiftUI

struct CheckoutView: View {
	@ObservedObject var order: Order
	//To show what we got back from the network request (SUCCESS)
	@State private var confirmationMessage = ""
	@State private var showingConfirmation = false
	//To show what we got back (FAILURE)
	@State private var confirmationMessageFailure = ""
	@State private var showingFailure = false

	//
	func placeOrder() {
		//Encodes the order object into JSON format
		guard let encoded = try? JSONEncoder().encode(order) else {
			print("Failed to encode order")
			return
		}
		//So, the next code for placeOrder() will be to create a URLRequest, configure it to send JSON data using a HTTP POST, and attach our data.
		let url = URL(string: "https://reqres.in/api/cupcakes")!
		var request = URLRequest(url: url)
		request.setValue("application/json", forHTTPHeaderField: "Content-Type")
		request.httpMethod = "POST"
		request.httpBody = encoded
		//Makes Network request
		URLSession.shared.dataTask(with: request) { data, response, error in
			//Work on the response we get back. If we make it past this, it means we got something back from the server
			guard let data = data else {
				print("No data in response: \(error?.localizedDescription ?? "Unknown error").")
				self.confirmationMessageFailure = "FAILURE! \(String(describing: error?.localizedDescription))"
				self.showingFailure = true
				return
			}
			//Do this if it succeeds
			if let decodedOrder = try? JSONDecoder().decode(Order.self, from: data) {
				self.confirmationMessage = "Your order for \(decodedOrder.quantity)x \(Order.types[decodedOrder.type].lowercased()) cupcakes is on its way!"
				self.showingConfirmation = true
			}
		}.resume()
		//
		
	}

	var body: some View {
		GeometryReader { geo in
			ScrollView {
				VStack {
					Image("cupcakes")
						.resizable()
						.scaledToFit()
						.frame(width: geo.size.width)

					Text("Your total is $\(self.order.cost, specifier: "%.2f")")
						.font(.title)

					Button("Place Order") {
						self.placeOrder()
					}
					.padding()
				}
			}
		}
		.navigationBarTitle("Check out", displayMode: .inline)
		.alert(isPresented: $showingConfirmation) {
			Alert(title: Text("Thank you!"), message: Text(confirmationMessage), dismissButton: .default(Text("OK")))
		}
		.alert(isPresented: $showingFailure) {
			Alert(title: Text("FAILURE"), message: Text(confirmationMessageFailure), dismissButton: .default(Text("OK")))
		}
	}
}

struct CheckoutView_Previews: PreviewProvider {
	static var previews: some View {
		CheckoutView(order: Order())
	}
}
