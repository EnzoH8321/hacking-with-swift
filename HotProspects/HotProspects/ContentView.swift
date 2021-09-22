//
//  ContentView.swift
//  HotProspects
//
//  Created by Enzo Herrera on 9/15/21.
//¸

import SwiftUI
import UserNotifications
import SamplePackage

struct ContentView: View {

	var prospects = Prospects()


	var body: some View {
		TabView {
			ProspectsView(filter: .none)
				.tabItem {
					Image(systemName: "person.3")
					Text("Everyone")
				}
			ProspectsView(filter: .contacted)
				.tabItem {
					Image(systemName: "checkmark.circle")
					Text("Contacted")
				}
			ProspectsView(filter: .uncontacted)
				.tabItem {
					Image(systemName: "questionmark.diamond")
					Text("Uncontacted")
				}
			MeView()
				.tabItem {
					Image(systemName: "person.crop.square")
					Text("Me")
				}
		}
		.environmentObject(prospects)
		.onAppear(perform: {
			let url = prospects.getDocumentsDirectory().appendingPathComponent("HotProspects").appendingPathExtension("json")

			prospects.readFromDirectory()
		})
	}

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

