//
//  OnboardingProvider.swift
//  AIDoctor
//
//  Created by Mark Parker on 16/03/2024.
//

import Foundation

class OnboardingProvider: ObservableObject {
    
    @Published private(set) var needsOnboarding: Bool = true {
        didSet {
            UserDefaults.standard.set(needsOnboarding, forKey: "needsOnboarding")
        }
    }
    
    private(set) var filledOnboarding: FilledQuestionary? {
        didSet {
            saveFilledOnboardingToDefaults(filledQuestionary: filledOnboarding)
        }
    }
    
    init() {
        self.needsOnboarding = UserDefaults.standard.bool(forKey: "needsOnboarding")
        loadFilledOnboardingFromDefaults()
    }
    
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
    
    private func saveFilledOnboardingToDefaults(filledQuestionary: FilledQuestionary?) {
        guard let filledQuestionary = filledQuestionary else {
            UserDefaults.standard.removeObject(forKey: "filledOnboarding")
            return
        }
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(filledQuestionary) {
            UserDefaults.standard.set(encoded, forKey: "filledOnboarding")
        }
    }
    
    private func loadFilledOnboardingFromDefaults() {
        guard let savedFilledQuestionary = UserDefaults.standard.object(forKey: "filledOnboarding") as? Data else {
            return
        }
        let decoder = JSONDecoder()
        if let loadedQuestionary = try? decoder.decode(FilledQuestionary.self, from: savedFilledQuestionary) {
            self.filledOnboarding = loadedQuestionary
            self.needsOnboarding = false
        }
    }
}

