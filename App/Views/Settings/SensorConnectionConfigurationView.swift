//
//  SensorConfiguration.swift
//  GlucoseDirectApp
//

import SwiftUI
import Toast

struct SensorConnectionConfigurationView: View {
    @EnvironmentObject var store: DirectStore

    var body: some View {
        if !store.state.selectedConfiguration.isEmpty {
            Section(
                content: {
                    VStack() {
                        ForEach(store.state.selectedConfiguration, id: \.id) { entry in
                            VStack(alignment: .leading) {
                                Text(entry.name)
                                
                                if entry.isSecret {
                                    SecureInputView("", text: entry.value)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .textFieldStyle(RoundedBorderTextFieldStyle())
                                        .submitLabel(.done)
                                } else {
                                    TextField("", text: entry.value)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .textFieldStyle(RoundedBorderTextFieldStyle())
                                }
                            }
                        }
                    }
                    .onSubmit(of: .text, {() -> Void in
                        let toast = Toast.default(
                            image: UIImage(systemName: "person.crop.circle.badge.checkmark")!,
                            title: "Logged into LibreLinkUp"
                        )

                        store.dispatch(.connectConnection)
                        toast.show()
                    })
                },
                header: {
                    Label("Connection settings", systemImage: "app.connected.to.app.below.fill")
                }
            )
        }
    }
}
