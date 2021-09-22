//
//  ContentView.swift
//  CupcakeCorner
//
//  Created by Enzo Herrera on 9/9/21.
//
//

import SwiftUI

//struct Response: Codable {
//	var results: [Result]
//}
//
//struct Result: Codable {
//	var trackId: Int
//	var trackName: String
//	var collectionName: String
//}


//class User: ObservableObject, Codable {
//
//    func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//        try container.encode(name, forKey: .name)
//    }
//
//    required init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        name = try container.decode(String.self, forKey: .name)
//    }
//
//    enum CodingKeys: CodingKey {
//        case name
//    }
//
//    var name = "Paul Hudson"
//}

//struct ContentView: View {
//
//	//Functions
//	func loadData() {
//		//Creating the URL we want to read.
//		guard let url = URL(string: "https://itunes.apple.com/search?term=taylor+swift&entity=song") else {
//			print("Invalid URL")
//			return
//		}
//		//Wrapping that in a URLRequest, which allows us to configure how the URL should be accessed.
//		let request = URLRequest(url: url)
//
//		//Create and start a networking task from that URL request.
//		URLSession.shared.dataTask(with: request, completionHandler: {data, response, error in
//
//			if let data = data {
//				if let decodedResponse = try? JSONDecoder().decode(Response.self, from: data) {
//					// we have good data – go back to the main thread
//					DispatchQueue.main.async {
//						// update our UI
//						self.results = decodedResponse.results
//					}
//
//					// everything is good, so we can exit
//					return
//				}
//			}
//
//			// if we're still here it means there was a problem
//			print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
//		} )
//		.resume()
//
//	}
//	//
//	@State private var results = [Result]()
//
//	var body: some View {
//		List(results, id: \.trackId) { item in
//			VStack(alignment: .leading) {
//				Text(item.trackName)
//					.font(.headline)
//				Text(item.collectionName)
//			}
//		}
//		.onAppear(perform: {
//			loadData()
//		})
//	}
//}

struct ContentView: View {
	//Observed Object
	@ObservedObject var order = Order()
	//
	@State private var username = ""
	@State private var email = ""
	//
	

	var disableForm: Bool {
		username.count < 5 || email.count < 5
	}

	var body: some View {
		NavigationView {
			Form {
				Section {
					Picker("Select your cake type", selection: $order.type) {
						ForEach(0..<Order.types.count) {
							Text(Order.types[$0])
						}
					}

					Stepper(value: $order.quantity, in: 3...20) {
						Text("Number of cakes: \(order.quantity)")
					}
				}
				Section {
					Toggle(isOn: $order.specialRequestEnabled.animation()) {
						Text("Any special requests?")
					}

					if order.specialRequestEnabled {
						Toggle(isOn: $order.extraFrosting) {
							Text("Add extra frosting")
						}

						Toggle(isOn: $order.addSprinkles) {
							Text("Add extra sprinkles")
						}
					}
				}
				Section {
					NavigationLink(destination: AddressView(order: order)) {
						Text("Delivery details")
					}
				}
			}
			.navigationBarTitle("Cupcake Corner")
		}
	}
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
	}
}
