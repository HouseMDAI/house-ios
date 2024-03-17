//
//  OnboardingProvider.swift
//  AIDoctor
//
//  Created by Mark Parker on 16/03/2024.
//

import Foundation

class OnboardingProvider: ObservableObject {
    
    @Published private(set) var needsOnboarding: Bool = true
    
    private(set) var filledOnboarding: FilledQuestionary? {
        didSet {
            if let filledOnboarding {
                saveFilledOnboardingToDefaults(filledQuestionary: filledOnboarding)
            }
        }
    }
    
    init() {
        loadFilledOnboardingFromDefaults()
    }
    
    func getOnboardingQuestionary() -> Questionary {
        Questionary(questions: [
//            Question(text: "Name"),
            Question(text: "sex"),
            Question(text: "age"),
            Question(text: "weight"),
            Question(text: "height"),
            Question(text: "special_conditions"),
        ])
    }
    
    func saveOnboardingAnswers(filledQuestionary: FilledQuestionary) {
        needsOnboarding = false
        filledOnboarding = filledQuestionary
    }
    
    private func saveFilledOnboardingToDefaults(filledQuestionary: FilledQuestionary) {
        UserDefaults.standard.removeObject(forKey: "filledOnboarding")
        let encoder = JSONEncoder()
        let encoded = try! encoder.encode(filledQuestionary)
        UserDefaults.standard.set(encoded, forKey: "filledOnboarding")
    }
    
    private func loadFilledOnboardingFromDefaults() {
        guard let object = UserDefaults.standard.object(forKey: "filledOnboarding") else {
            print("NIL")
            needsOnboarding = true
            return
        }
        let savedFilledQuestionary = object as! Data
        let decoder = JSONDecoder()
        let loadedQuestionary = try! decoder.decode(FilledQuestionary.self, from: savedFilledQuestionary)
        self.filledOnboarding = loadedQuestionary
        self.needsOnboarding = false
    
    }
}

