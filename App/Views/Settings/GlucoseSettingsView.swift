//
//  GlucoseSettingsView.swift
//  GlucoseDirect
//

import SwiftUI

// MARK: - GlucoseSettingsView

struct GlucoseSettingsView: View {
    // MARK: Internal

    @EnvironmentObject var store: DirectStore

    var body: some View {
        Section(
            content: {
                Picker("Glucose unit", selection: selectedGlucoseUnit) {
                    Text(GlucoseUnit.mgdL.localizedDescription).tag(GlucoseUnit.mgdL.rawValue)
                    Text(GlucoseUnit.mmolL.localizedDescription).tag(GlucoseUnit.mmolL.rawValue)
                }.pickerStyle(.menu)

                NumberSelectorView(key: LocalizedString("Lower limit"), value: store.state.alarmLow, step: 5, max: store.state.alarmHigh, displayValue: store.state.alarmLow.asGlucose(glucoseUnit: store.state.glucoseUnit, withUnit: true)) { value in
                    store.dispatch(.setAlarmLow(lowerLimit: value))
                }

                NumberSelectorView(key: LocalizedString("Upper limit"), value: store.state.alarmHigh, step: 5, min: store.state.alarmLow, displayValue: store.state.alarmHigh.asGlucose(glucoseUnit: store.state.glucoseUnit, withUnit: true)) { value in
                    store.dispatch(.setAlarmHigh(upperLimit: value))
                }

                Toggle("Sleep mode", isOn: enableSleepMode).toggleStyle(SwitchToggleStyle(tint: Color.ui.accent))

                if enableSleepMode.wrappedValue {
                    DatePicker("Bed time",
                               selection: beginSleepTime,
                               displayedComponents: .hourAndMinute
                    )
                    .onAppear {
                        UIDatePicker.appearance().minuteInterval = 15
                    }

                    DatePicker("Wake up time",
                               selection: endSleepTime,
                               displayedComponents: .hourAndMinute
                    )
                    .onAppear {
                        UIDatePicker.appearance().minuteInterval = 15
                    }

                    NumberSelectorView(key: LocalizedString("Lower limit"), value: store.state.alarmLowSleep, step: 5, max: store.state.alarmHighSleep, displayValue: store.state.alarmLowSleep.asGlucose(glucoseUnit: store.state.glucoseUnit, withUnit: true)) { value in
                        store.dispatch(.setAlarmLowSleep(lowerLimit: value))
                    }

                    NumberSelectorView(key: LocalizedString("Upper limit"), value: store.state.alarmHighSleep, step: 5, min: store.state.alarmLowSleep, displayValue: store.state.alarmHighSleep.asGlucose(glucoseUnit: store.state.glucoseUnit, withUnit: true)) { value in
                        store.dispatch(.setAlarmHighSleep(upperLimit: value))
                    }
                }

                Toggle("Normal glucose notification", isOn: normalGlucoseNotification).toggleStyle(SwitchToggleStyle(tint: Color.ui.accent))
                Toggle("Alarm glucose notification", isOn: alarmGlucoseNotification).toggleStyle(SwitchToggleStyle(tint: Color.ui.accent))

                if #available(iOS 16.1, *) {
                    Toggle("Glucose Live Activity", isOn: glucoseLiveActivity).toggleStyle(SwitchToggleStyle(tint: Color.ui.accent))
                }
                
                Toggle("Glucose read aloud", isOn: readGlucose).toggleStyle(SwitchToggleStyle(tint: Color.ui.accent))
                Toggle("Notify alarms", isOn: notifyAlarms).toggleStyle(SwitchToggleStyle(tint: Color.ui.accent))
            },
            header: {
                Label("Glucose settings", systemImage: "cross.case")
            }
        )
    }

    // MARK: Private

    private var beginSleepTime: Binding<Date> {
        Binding(
            get: { store.state.beginSleepTime },
            set: { store.dispatch(.setBeginSleepTime(beginSleepTime: $0)) }
        )
    }

    private var endSleepTime: Binding<Date> {
        Binding(
            get: { store.state.endSleepTime },
            set: { store.dispatch(.setEndSleepTime(endSleepTime: $0)) }
        )
    }

    private var normalGlucoseNotification: Binding<Bool> {
        Binding(
            get: { store.state.normalGlucoseNotification },
            set: { store.dispatch(.setNormalGlucoseNotification(enabled: $0)) }
        )
    }

    private var enableSleepMode: Binding<Bool> {
        Binding(
            get: { store.state.enableSleepMode },
            set: { store.dispatch(.setEnableSleepMode(enabled: $0)) }
        )
    }

    private var alarmGlucoseNotification: Binding<Bool> {
        Binding(
            get: { store.state.alarmGlucoseNotification },
            set: { store.dispatch(.setAlarmGlucoseNotification(enabled: $0)) }
        )
    }

    private var glucoseLiveActivity: Binding<Bool> {
        Binding(
            get: { store.state.glucoseLiveActivity },
            set: { store.dispatch(.setGlucoseLiveActivity(enabled: $0)) }
        )
    }

    private var readGlucose: Binding<Bool> {
        Binding(
            get: { store.state.readGlucose },
            set: { store.dispatch(.setReadGlucose(enabled: $0)) }
        )
    }

    private var notifyAlarms: Binding<Bool> {
        Binding(
            get: { store.state.notifyAlarms },
            set: { store.dispatch(.setNotifyAlarms(enabled: $0)) }
        )
    }

    private var selectedGlucoseUnit: Binding<String> {
        Binding(
            get: { store.state.glucoseUnit.rawValue },
            set: { store.dispatch(.setGlucoseUnit(unit: GlucoseUnit(rawValue: $0)!)) }
        )
    }
}
