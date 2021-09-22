//
//  ContentView.swift
//  Moonshot
//
//  Created by Enzo Herrera on 9/7/21.
//

import SwiftUI
import LocalAuthentication

struct User: Codable {
	var name: String
	var address: Address
}

struct Address: Codable {
	var street: String
	var city: String
}


struct ContentView: View {


	func returnFormattedCrews(_ missionArray: Mission ) -> some View {
		var masterText = ""
		for element in missionArray.crew {
			print(element)
			masterText += (element.name + " ")
		}
		return Text("\(masterText)")
	}

	//uses the extended decode function. returns an array of astronauts
	let astronauts: [Astronaut] = Bundle.main.decode("astronauts.json")
	let missions: [Mission] = Bundle.main.decode("missions.json")

	//False shows mission dates, True shows Astronaut names
	@State var missionSelector:Bool = false
	
	var body: some View {
		VStack {
			Toggle("Advanced Info", isOn: $missionSelector)
			NavigationView {
				List(missions) { mission in
					NavigationLink(destination: MissionView(mission: mission, astronauts: self.astronauts)) {

						Image(mission.image)
							.resizable()
							.scaledToFit()
							.frame(width: 44, height: 44)

						VStack(alignment: .leading) {
							Text(mission.displayName)
								.font(.headline)

							if missionSelector {
								returnFormattedCrews(mission)
							} else {
								Text(mission.formattedLaunchDate )
							}

						}

					}

				}
				.navigationBarTitle("Moonshot")

			}
		}

	}
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
	}
}
