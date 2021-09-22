//
//  ContentView.swift
//  BucketList
//
//  Created by Enzo Herrera on 9/14/21.
//

import SwiftUI
import LocalAuthentication
import MapKit
import LocalAuthentication

struct ContentView: View {

	@State private var isUnlocked = false
	@State private var centerCoordinate = CLLocationCoordinate2D()
	@State private var locations = [CodableMKPointAnnotation]()

	@State private var selectedPlace: MKPointAnnotation?
	@State private var showingPlaceDetails = false

	@State private var showingEditScreen = false
	@State private var biometricAuthFailed = false

	//Authenticate for  Touch ID
	func authenticate() {
		//Creating an LAContext so we have something that can check and perform biometric authentication.
		let context = LAContext()
		var error: NSError?

		//Ask it whether the current device is capable of biometric authentication.
		if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
			let reason = "Please authenticate yourself to unlock your places."

			// If it is, start the request and provide a closure to run when it completes.
			context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in


				//When the request finishes, push our work back to the main thread and check the resul
				DispatchQueue.main.async {
					if success {
						//If it was successful, we’ll set isUnlocked to true so we can run our app as normal.
						self.isUnlocked = true
					} else {
						// error
						self.biometricAuthFailed = true
					}
				}
			}
		} else {

		}
	}

	func getDocumentsDirectory() -> URL {
		// find all possible documents directories for this user
		let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
		// just send back the first one, which ought to be the only one
		return paths[0]
	}

	//Loads data. We can now using getDocumentsDirectory().appendingPathComponent() to create new URLs that point to a specific file in the documents directory. Once we have that, it’s as simple as using Data(contentsOf:) and JSONDecoder() to load our data
	func loadData() {
		let filename = getDocumentsDirectory().appendingPathComponent("SavedPlaces")

		do {
			let data = try Data(contentsOf: filename)
			locations = try JSONDecoder().decode([CodableMKPointAnnotation].self, from: data)
		} catch {
			print("Unable to load saved data.")
		}
	}

	//Saves Data
	func saveData() {
		do {
			let filename = getDocumentsDirectory().appendingPathComponent("SavedPlaces")
			let data = try JSONEncoder().encode(self.locations)
			try data.write(to: filename, options: [.atomicWrite, .completeFileProtection])
		} catch {
			print("Unable to save data.")
		}
	}

	public struct MainContentView: View {
		@Binding  var centerCoordinate: CLLocationCoordinate2D
		@State  var locations: [CodableMKPointAnnotation]
		@Binding  var showingEditScreen: Bool
		@Binding  var selectedPlace: MKPointAnnotation?
		@Binding  var showingPlaceDetails: Bool

		var body: some View {
			MapView(centerCoordinate: self.$centerCoordinate, selectedPlace: self.$selectedPlace, showingPlaceDetails: self.$showingPlaceDetails, annotations: self.locations)
				.edgesIgnoringSafeArea(.all)
			Circle()
				.fill(Color.blue)
				.opacity(0.3)
				.frame(width: 32, height: 32)
			VStack {
				Spacer()
				HStack {
					Spacer()
					Button(action: {
						let newLocation = CodableMKPointAnnotation()
						newLocation.coordinate = self.centerCoordinate
						newLocation.title = "Example location"
						self.locations.append(newLocation)
						self.selectedPlace = newLocation
						self.showingEditScreen = true
					}) {
						Image(systemName: "plus")
							.padding()
							.background(Color.black.opacity(0.75))
							.foregroundColor(.white)
							.font(.title)
							.clipShape(Circle())
							.padding(.trailing)
					}
				}
			}
		}
	}


	var body: some View {
		ZStack {
			if isUnlocked {
				MainContentView(centerCoordinate: $centerCoordinate, locations: locations, showingEditScreen: $showingEditScreen,selectedPlace: $selectedPlace ,showingPlaceDetails: $showingPlaceDetails)
			}
			else {
				Button("Unlock Places") {
					self.authenticate()
				}
				.padding()
				.background(Color.blue)
				.foregroundColor(.white)
				.clipShape(Capsule())
			}


		}
		.onAppear(perform: loadData)
		.alert(isPresented: $biometricAuthFailed) {
			Alert(title: Text("Failed"), message: Text("Biometric Auth Failed"), primaryButton: .default(Text("OK")), secondaryButton: .default(Text("Try Again")))
		}
		.alert(isPresented: $showingPlaceDetails) {
			Alert(title: Text(selectedPlace?.title ?? "Unknown"), message: Text(selectedPlace?.subtitle ?? "Missing place information."), primaryButton: .default(Text("OK")), secondaryButton: .default(Text("Edit")) {
				self.showingEditScreen = true
			})
		}
		.sheet(isPresented: $showingEditScreen, onDismiss: saveData) {
			if self.selectedPlace != nil {
				EditView(placemark: self.selectedPlace!)
			}
		}

	}
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
	}
}
