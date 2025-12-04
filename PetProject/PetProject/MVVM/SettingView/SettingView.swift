//
//  SettingView.swift
//  PetProject
//
//  Created by user on 30.11.2025.
//

import SwiftUI

struct SettingView: View {

    @State private var selectedTemperatureUnit = AppSettings.shared.temperatureUnit
    @State private var selectedRainThreshold = AppSettings.shared.rainThreshold
    @State private var isRainAlertEnabled = AppSettings.shared.isRainAlertEnabled
    @State private var selectedWindSpeedUnit = AppSettings.shared.windSpeedUnit

    var body: some View {
        NavigationStack {
            Form {
                // MARK: - Температура
                Section("Temperature") {
                    Picker("Units", selection: $selectedTemperatureUnit) {
                        ForEach(TemperatureUnit.allCases, id: \.self) { unit in
                            Text(unit == .celsius ? "°C" : "°F")
                                .tag(unit)
                        }
                    }
                    .onChange(of: selectedTemperatureUnit) {
                        AppSettings.shared.temperatureUnit = selectedTemperatureUnit
                    }
                }

                // MARK: - Попередження про дощ
                Section("Rain warning") {
                    Toggle("Show warnings", isOn: $isRainAlertEnabled)
                        .onChange(of: isRainAlertEnabled) {
                            AppSettings.shared.isRainAlertEnabled = isRainAlertEnabled
                        }

                    Picker("Precipitation threshold", selection: $selectedRainThreshold) {
                        ForEach(RainThreshold.allCases) { threshold in
                            Text(threshold.title)
                                .tag(threshold)
                        }
                    }
                    .pickerStyle(.segmented)
                    .disabled(!isRainAlertEnabled)
                    .onChange(of: selectedRainThreshold) {
                        AppSettings.shared.rainThreshold = selectedRainThreshold
                    }
                }

                // MARK: - Вітер
                Section("Wind Speed") {
                    Picker("Units", selection: $selectedWindSpeedUnit) {
                        ForEach(WindSpeedUnit.allCases, id: \.self) { unit in
                            Text(unit.title)
                                .tag(unit)
                        }
                    }
                    .pickerStyle(.segmented)
                    .onChange(of: selectedWindSpeedUnit) {
                        AppSettings.shared.windSpeedUnit = selectedWindSpeedUnit
                    }
                }

                // MARK: - Останні координати
                if let location = AppSettings.shared.lastLocation() {
                    Section("Last location") {
                        Text("latitude: \(location.lat, specifier: "%.4f")")
                        Text("longitude: \(location.lon, specifier: "%.4f")")
                    }
                }
            }
            .navigationTitle("Settings")
        }
        .onAppear {
            selectedTemperatureUnit = AppSettings.shared.temperatureUnit
            selectedRainThreshold   = AppSettings.shared.rainThreshold
            isRainAlertEnabled      = AppSettings.shared.isRainAlertEnabled
            selectedWindSpeedUnit   = AppSettings.shared.windSpeedUnit
        }
    }
}

