//
//  MissionView.swift
//  Project8
//
//  Created by Paul Hudson on 17/02/2020.
//  Copyright © 2020 Paul Hudson. All rights reserved.
//

import SwiftUI

struct MissionView: View {
	struct CrewMember {
		let role: String
		let astronaut: Astronaut
	}

	let mission: Mission
	let astronauts: [CrewMember]

	init(mission: Mission, astronauts: [Astronaut]) {
		self.mission = mission

		var matches = [CrewMember]()

		for member in mission.crew {
			if let match = astronauts.first(where: { $0.id == member.name }) {
				matches.append(CrewMember(role: member.role, astronaut: match))
			} else {
				fatalError("Missing \(member)")
			}
		}

		self.astronauts = matches
	}

	var body: some View {
		GeometryReader { missionView in
			ScrollView(.vertical) {
				VStack {
					GeometryReader { logoImage in
						Image(self.mission.image)
							.resizable()
							.scaledToFit()
							.frame(width:
									max(missionView.size.width * 0.11, min(missionView.size.width * 0.7, logoImage.frame(in: .global).maxY - missionView.frame(in: .global).minY)),
								   height: missionView.size.width * 0.7,
								   alignment: .bottom
							)
							.position(x: logoImage.size.width / 2, y: logoImage.size.height / 2)
							.padding(.top)
							.accessibility(label: Text("Logo of \(self.mission.displayName)"))
					}
					.frame(height: missionView.size.width * 0.7)


					Text(self.mission.description)
						.padding()

					ForEach(self.astronauts, id: \.role) { crewMember in
						NavigationLink(destination: AstronautView(astronaut: crewMember.astronaut)) {
							HStack {
								Image(crewMember.astronaut.id)
									.resizable()
									.frame(width: 83, height: 60)
									.clipShape(Capsule())
									.overlay(Capsule().stroke(Color.primary, lineWidth: 1))

								VStack(alignment: .leading) {
									Text(crewMember.astronaut.name)
										.font(.headline)
									Text(crewMember.role)
										.foregroundColor(.secondary)
								}

								Spacer()
							}
							.padding(.horizontal)
						}
						.buttonStyle(PlainButtonStyle())
					}

					Spacer(minLength: 25)
				}
			}
		}
		.navigationBarTitle(Text(mission.displayName), displayMode: .inline)
	}
}

struct MissionView_Previews: PreviewProvider {
	static let missions: [Mission] = Bundle.main.decode("missions.json")
	static let astronauts: [Astronaut] = Bundle.main.decode("astronauts.json")

	static var previews: some View {
		MissionView(mission: missions[0], astronauts: astronauts)
	}
}
