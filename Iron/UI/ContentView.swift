//
//  SessionContentView.swift
//  SwiftUI Playground
//
//  Created by Karim Abou Zeid on 19.06.19.
//  Copyright © 2019 Karim Abou Zeid. All rights reserved.
//

import SwiftUI
import WorkoutDataKit

let NAVIGATION_BAR_SPACING: CGFloat = 16

struct ContentView : View {
    @EnvironmentObject private var sceneState: SceneState
    
    @State private var restoreResult: IdentifiableHolder<Result<Void, Error>>?
    @State private var restoreBackupData: IdentifiableHolder<Data>?
    
    var body: some View {
        tabView
            .edgesIgnoringSafeArea([.top, .bottom])
            .onReceive(NotificationCenter.default.publisher(for: Notification.Name.RestoreFromBackup)) { output in
                guard let backupData = output.userInfo?[restoreFromBackupDataUserInfoKey] as? Data else { return }
                self.restoreBackupData = IdentifiableHolder(value: backupData)
            }
            .overlay(
                Color.clear.frame(width: 0, height: 0)
                    // This is a hack, we need to have this in an overlay and in Color.clear so it also works on iPad, tested on iOS 13.4
                    .actionSheet(item: $restoreBackupData) { restoreBackupDataHolder in
                        RestoreActionSheet.create(context: WorkoutDataStorage.shared.persistentContainer.viewContext, exerciseStore: ExerciseStore.shared, data: { restoreBackupDataHolder.value }) { result in
                            self.restoreResult = IdentifiableHolder(value: result)
                        }
                    }
            )
            .alert(item: $restoreResult) { restoreResultHolder in
                RestoreActionSheet.restoreResultAlert(restoreResult: restoreResultHolder.value)
            }
            .applyRTLSupport()
    }
    
    @ViewBuilder
    private var tabView: some View {
        let localization = LocalizationHelper.shared
        
        if #available(iOS 14, *) {
            TabView(selection: $sceneState.selectedTabNumber) {
                FeedView()
                    .tag(SceneState.Tab.feed.rawValue)
                    .tabItem {
                        Label(localization.tabFeed, systemImage: "house")
                    }

                HistoryView()
                    .tag(SceneState.Tab.history.rawValue)
                    .tabItem {
                        Label(localization.tabHistory, systemImage: "clock")
                    }

                WorkoutTab()
                    .tag(SceneState.Tab.workout.rawValue)
                    .tabItem {
                        Label(localization.tabWorkout, systemImage: "plus.diamond")
                    }

                ExerciseMuscleGroupsView()
                    .tag(SceneState.Tab.exercises.rawValue)
                    .tabItem {
                        Label(localization.tabExercises, systemImage: "tray.full")
                    }

                SettingsView()
                    .tag(SceneState.Tab.settings.rawValue)
                    .tabItem {
                        Label(localization.tabSettings, systemImage: "gear")
                    }
            }
            .productionEnvironment()
        } else {
            /**
             *  We inject .productionEnvironment() for every tab, because when the "screen reading" accessibility setting is enabled,
             *  some Tabs get created by the system in the background without its parents environment! This is probably a bug and it happens since iOS 13.4
             */
            UITabView(viewControllers: [
                FeedView()
                    .productionEnvironment()
                    .hostingController()
                    .tabItem(title: localization.tabFeed, image: UIImage(systemName: "house"), tag: 0),

                HistoryView()
                    .productionEnvironment()
                    .hostingController()
                    .tabItem(title: localization.tabHistory, image: UIImage(systemName: "clock"), tag: 1),

                WorkoutTab()
                    .productionEnvironment()
                    .hostingController()
                    .tabItem(title: localization.tabWorkout, image: UIImage(systemName: "plus.square"), tag: 2),

                ExerciseMuscleGroupsView()
                    .productionEnvironment()
                    .hostingController()
                    .tabItem(title: localization.tabExercises, image: UIImage(systemName: "tray.full"), tag: 3),

                SettingsView()
                    .productionEnvironment()
                    .hostingController()
                    .tabItem(title: localization.tabSettings, image: UIImage(systemName: "gear"), tag: 4),
            ], selection: sceneState.selectedTabNumber)
        }
    }
}

private extension View {
    func productionEnvironment() -> some View {
        self
            .environmentObject(SettingsStore.shared)
            .environmentObject(RestTimerStore.shared)
            .environmentObject(ExerciseStore.shared)
            .environment(\.managedObjectContext, WorkoutDataStorage.shared.persistentContainer.viewContext)
    }
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
            .mockEnvironment(weightUnit: .metric)
    }
}
#endif
