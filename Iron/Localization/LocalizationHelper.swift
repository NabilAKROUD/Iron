//
//  LocalizationHelper.swift
//  Iron
//
//  Created for Arabic and Multi-language Support
//  Copyright © 2026. All rights reserved.
//

import Foundation
import SwiftUI

// MARK: - Localization Helper
/// A helper to manage localized strings throughout the app
class LocalizationHelper {
    static let shared = LocalizationHelper()
    
    // MARK: - Main Tab Titles
    var tabFeed: String { NSLocalizedString("tab.feed", comment: "Feed tab title") }
    var tabHistory: String { NSLocalizedString("tab.history", comment: "History tab title") }
    var tabWorkout: String { NSLocalizedString("tab.workout", comment: "Workout tab title") }
    var tabExercises: String { NSLocalizedString("tab.exercises", comment: "Exercises tab title") }
    var tabSettings: String { NSLocalizedString("tab.settings", comment: "Settings tab title") }
    
    // MARK: - Feed View
    var feedTitle: String { NSLocalizedString("feed.title", comment: "Feed view title") }
    var feedEdit: String { NSLocalizedString("feed.edit", comment: "Edit button in feed") }
    var feedPinChart: String { NSLocalizedString("feed.pinChart", comment: "Pin chart button") }
    var feedNoChartsPinned: String { NSLocalizedString("feed.noChartsPinned", comment: "No charts pinned message") }
    
    // MARK: - History View
    var historyTitle: String { NSLocalizedString("history.title", comment: "History view title") }
    
    // MARK: - Workout View
    var workoutTitle: String { NSLocalizedString("workout.title", comment: "Workout view title") }
    var workoutStartNew: String { NSLocalizedString("workout.startNew", comment: "Start new workout") }
    var workoutContinue: String { NSLocalizedString("workout.continue", comment: "Continue workout") }
    var workoutFinish: String { NSLocalizedString("workout.finish", comment: "Finish workout") }
    var workoutCancel: String { NSLocalizedString("workout.cancel", comment: "Cancel workout") }
    
    // MARK: - Exercises View
    var exercisesTitle: String { NSLocalizedString("exercises.title", comment: "Exercises view title") }
    
    // MARK: - Settings View
    var settingsTitle: String { NSLocalizedString("settings.title", comment: "Settings view title") }
    
    // MARK: - Common Actions
    var actionClose: String { NSLocalizedString("action.close", comment: "Close button") }
    var actionEdit: String { NSLocalizedString("action.edit", comment: "Edit button") }
    var actionDelete: String { NSLocalizedString("action.delete", comment: "Delete button") }
    var actionSave: String { NSLocalizedString("action.save", comment: "Save button") }
    var actionAdd: String { NSLocalizedString("action.add", comment: "Add button") }
    var actionCancel: String { NSLocalizedString("action.cancel", comment: "Cancel button") }
    
    // MARK: - Empty States
    var emptyNoData: String { NSLocalizedString("empty.noData", comment: "No data available") }
    var emptyNoWorkouts: String { NSLocalizedString("empty.noWorkouts", comment: "No workouts") }
    
    // MARK: - Charts & Analytics
    var chartPin: String { NSLocalizedString("chart.pin", comment: "Pin chart") }
    var chartEdit: String { NSLocalizedString("chart.edit", comment: "Edit charts") }
    var chartTitle: String { NSLocalizedString("chart.title", comment: "Chart title") }
    var chartWorkoutsPerWeek: String { NSLocalizedString("chart.workoutsPerWeek", comment: "Workouts per week") }
    var chartActivityCalendar: String { NSLocalizedString("chart.activityCalendar", comment: "Activity calendar") }
    
    // MARK: - Alerts
    var alertError: String { NSLocalizedString("alert.error", comment: "Error alert") }
    var alertSuccess: String { NSLocalizedString("alert.success", comment: "Success alert") }
    var alertConfirm: String { NSLocalizedString("alert.confirm", comment: "Confirm alert") }
    
    // MARK: - Localization Direction
    /// Returns true if the current language is Right-to-Left (Arabic, Hebrew, etc.)
    var isRTL: Bool {
        let language = NSLocale.preferredLanguages.first ?? "en"
        let rtlLanguages = ["ar", "ar-AE", "ar-SA", "ar-EG", "ar-DZ", "he"]
        return rtlLanguages.contains { language.hasPrefix($0) }
    }
    
    /// Returns the text direction environment modifier for RTL support
    var textDirection: Locale.LanguageDirection {
        return isRTL ? .rightToLeft : .leftToRight
    }
}

// MARK: - SwiftUI View Extension
extension View {
    /// Applies RTL modifier if current language is RTL
    func applyRTLSupport() -> some View {
        if LocalizationHelper.shared.isRTL {
            return AnyView(self.environment(\.layoutDirection, .rightToLeft))
        } else {
            return AnyView(self.environment(\.layoutDirection, .leftToRight))
        }
    }
}

// MARK: - NSLocalizedString Shortcut
/// Global function for quick localized string access
func L(_ key: String, comment: String = "") -> String {
    return NSLocalizedString(key, comment: comment)
}

// MARK: - Text View Extension
extension Text {
    /// Creates a localized Text view
    init(localized key: String) {
        self.init(L(key))
    }
}
