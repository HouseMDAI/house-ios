//
//  HouseMDAI.swift
//  HouseMDAI
//
//  Created by Mark Parker on 16/03/2024.
//

import SwiftUI

@main
struct HouseMDAI: App {
    
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
        
        let doctor = BackendDoctorProvider(baseUrl: "https://localhost:8000") // DirectDoctorProvider(apiToken: "")
        let homePresenter = HomePresenter(doctor: doctor)
        
        _onboardingProvider = StateObject(wrappedValue: onboardingProvider)
        _onboardingPresenter = StateObject(wrappedValue: onboardingPresenter)
        _homePresenter = StateObject(wrappedValue: homePresenter)
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
