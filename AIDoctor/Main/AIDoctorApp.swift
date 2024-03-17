//
//  AIDoctorApp.swift
//  AIDoctor
//
//  Created by Mark Parker on 16/03/2024.
//

import SwiftUI
import AlamofireNetworkActivityLogger

@main
struct AIDoctorApp: App {
    
    @StateObject private var onboardingProvider: OnboardingProvider
    @StateObject private var onboardingPresenter: OnboardingPresenter
    @StateObject private var homePresenter: HomePresenter
    
    init() {
        let onboardingProvider = OnboardingProvider()
        let onboardingPresenter = OnboardingPresenter(
            questions: onboardingProvider.getOnboardingQuestionary(),
            answers: FilledQuestionary(filledQuestions: [:]),
            completion: onboardingProvider.saveOnboardingAnswers
        )
        let homePresenter = HomePresenter()
        
        _onboardingProvider = StateObject(wrappedValue: onboardingProvider)
        _onboardingPresenter = StateObject(wrappedValue: onboardingPresenter)
        _homePresenter = StateObject(wrappedValue: homePresenter)
        NetworkActivityLogger.shared.level = .debug
        NetworkActivityLogger.shared.startLogging()
    }
    
    var body: some Scene {
        WindowGroup {
            if onboardingProvider.needsOnboarding {
                OnboardingView(presenter: onboardingPresenter)
            } else {
                TabView {
                    HomeView(presenter: homePresenter)
                    if let profile = onboardingProvider.filledOnboarding {
                        ProfileView(profile: profile)
                    }
                }
            }
        }
    } // body
    
}
