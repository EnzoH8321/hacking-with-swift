//
//  ProspectsView.swift
//  ProspectsView
//
//  Created by Enzo Herrera on 9/16/21.
//

import SwiftUI
import CodeScanner
import UserNotifications

enum FilterType {
	case none, contacted, uncontacted
}

struct ProspectsView: View {

	let filter: FilterType
	//When you use @EnvironmentObject you are explicitly telling SwiftUI that your object will exist in the environment by the time the view is created. If it isn’t present, your app will crash immediately – be careful, and treat it like an implicitly unwrapped optional.
	@EnvironmentObject var prospects: Prospects
	@State private var isShowingScanner = false

	var title: String {
		switch filter {
		case .none:
			return "Everyone"
		case .contacted:
			return "Contacted people"
		case .uncontacted:
			return "Uncontacted people"
		}
	}

	var filteredProspects: [Prospect] {
		switch filter {
		case .none:
			return prospects.people
		case .contacted:
			return prospects.people.filter { $0.isContacted }
		case .uncontacted:
			return prospects.people.filter { !$0.isContacted }
		}
	}


	//That puts all the code to create a notification for the current prospect into a closure, which we can call whenever we need
	func addNotification(for prospect: Prospect) {
		let center = UNUserNotificationCenter.current()

		let addRequest = {
			let content = UNMutableNotificationContent()
			content.title = "Contact \(prospect.name)"
			content.subtitle = prospect.emailAddress
			content.sound = UNNotificationSound.default

			var dateComponents = DateComponents()
			dateComponents.hour = 9
			//			let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
			let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)

			let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
			center.add(request)
		}

		// to make sure we only schedule notifications when allowed
		center.getNotificationSettings { settings in
			if settings.authorizationStatus == .authorized {
				addRequest()
			} else {
				center.requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
					if success {
						addRequest()
					} else {
						print("D'oh")
					}
				}
			}
		}
	}

	func handleScan(result: Result<String, CodeScannerView.ScanError>) {
		self.isShowingScanner = false

		switch result {
		case .success(let code):
			let details = code.components(separatedBy: "\n")
			guard details.count == 2 else { return }

			let person = Prospect()
			person.name = details[0]
			person.emailAddress = details[1]

			self.prospects.add(person)
		case .failure(let error):
			print("Scanning failed")
		}
	}


	var body: some View {

		NavigationView {
			List {
				ForEach(filteredProspects) { prospect in
					HStack {
						VStack(alignment: .leading) {
							Text(prospect.name)
								.font(.headline)
							Text(prospect.emailAddress)
								.foregroundColor(.secondary)
						}
						Spacer()
						VStack(alignment: .trailing) {
							if (prospect.isContacted) {
								Image(systemName: "person.fill.checkmark")
							} else {
								Image(systemName: "person.fill.xmark")
							}


						}
					}
					.contextMenu {
						Button(prospect.isContacted ? "Mark Uncontacted" : "Mark Contacted" ) {
							self.prospects.toggle(prospect)
						}
						
					}
				}
			}
			.navigationBarTitle(title)
			.navigationBarItems(trailing: Button(action: {
				self.isShowingScanner = true
			}) {
				Image(systemName: "qrcode.viewfinder")
				Text("Scan")
			})
			.sheet(isPresented: $isShowingScanner) {
				CodeScannerView(codeTypes: [.qr], simulatedData: "Jack Rodriguez\njack@gmail.com", completion: self.handleScan)
			}
		}

	}
}

struct ProspectsView_Previews: PreviewProvider {

	static var previews: some View {
		ProspectsView(filter: .contacted)
	}
}
