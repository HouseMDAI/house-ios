//
//  OnboardingProvider.swift
//  AIDoctor
//
//  Created by Mark Parker on 16/03/2024.
//

import Foundation

class OnboardingProvider: ObservableObject {
    
    @Published private(set) public var needsOnboarding: Bool = true
    private(set) public var filledOnboarding: FilledQuestionary? = nil
    
    func getOnboardingQuestionary() -> Questionary {
        Questionary(questions: [
            Question(text: "Name"),
            Question(text: "Sex"),
            Question(text: "Age"),
            Question(text: "Special conditions"),
        ])
    }
    
    func saveOnboardingAnswers(filledQuestionary: FilledQuestionary) {
        needsOnboarding = false
        filledOnboarding = filledQuestionary
    }
}
