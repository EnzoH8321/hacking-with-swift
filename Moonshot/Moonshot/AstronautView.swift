//
//  AstronautView.swift
//  Moonshot
//
//  Created by Enzo Herrera on 9/7/21.
//

import SwiftUI

func findNumberOfMissions(_ missionArray: [Mission], _ astronautInfo: Astronaut) -> Int {
	let missions = missionArray
	var numberOfMissions = 0

	for element in missions {
		for element2 in element.crew {
			if element2.name == astronautInfo.id {
				numberOfMissions += 1
			}
		}
	}

	return numberOfMissions

}

struct AstronautView: View {

	init(astronaut: Astronaut) {
		self.astronaut = astronaut
		missions = Bundle.main.decode("missions.json")
		missionNumbers = findNumberOfMissions(missions, astronaut)
	}

	var astronaut: Astronaut
	var missions: [Mission]
	var missionNumbers:Int = 0

	var body: some View {
		GeometryReader { geometry in
			ScrollView(.vertical) {
				VStack {
					Text("Missions Flew: \(String(missionNumbers))")
						.font(.title2)
					Image(self.astronaut.id)
						.resizable()
						.scaledToFit()
						.frame(width: geometry.size.width)

					Text(self.astronaut.description)
						.padding()
				}
			}
		}
		.navigationBarTitle(Text(astronaut.name), displayMode: .inline)
	}
}


struct AstronautView_Previews: PreviewProvider {

	static let astronauts: [Astronaut] = Bundle.main.decode("astronauts.json")

	static var previews: some View {
		AstronautView(astronaut: astronauts[0])
	}
}
