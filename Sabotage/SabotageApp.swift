//
//  SabotageApp.swift
//  Sabotage
//
//  Created by 김하람 on 12/27/23.
//

import SwiftUI
import FamilyControls

@main
struct ScreenTime_SabotageApp: App {
    @StateObject var familyControlsManager = FamilyControlsManager.shared
    @StateObject var scheduleVM = ScheduleVM()
    init() {
        Task {
            handleRequestAuthorization()
            requestNotificationPermission()
        }
    }
    var body: some Scene {
        WindowGroup {
            VStack {
                // MARK: - ram 권한에 대한 조건 설정
                if !familyControlsManager.hasScreenTimePermission {
                    ContentView()
                } else {
                    ContentView()
                }
            }
            .onReceive(familyControlsManager.authorizationCenter.$authorizationStatus) { newValue in
                // here
                DispatchQueue.main.asyncAfter(deadline: .now()) {
                    familyControlsManager.updateAuthorizationStatus(authStatus: newValue)
                }
            }
            .environmentObject(familyControlsManager)
            .environmentObject(scheduleVM)
        }
    }
}

func requestNotificationPermission() {
    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
        if granted {
            print("Notification Permission Granted.")
        } else {
            print("Notification Permission Denied.")
        }
    }
}
@MainActor
func handleRequestAuthorization() {
    FamilyControlsManager.shared.requestAuthorization()
}
