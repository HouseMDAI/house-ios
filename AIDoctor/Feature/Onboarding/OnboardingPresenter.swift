//
//  OnboardingPresenter.swift
//  AIDoctor
//
//  Created by Mark Parker on 16/03/2024.
//

import Foundation

class OnboardingPresenter: ObservableObject {
    private(set) public var questions: Questionary
    @Published public var answers: FilledQuestionary
    private var completion: (FilledQuestionary) -> Void
    
    init(questions: Questionary, answers: FilledQuestionary, completion: @escaping (FilledQuestionary) -> Void) {
        self.questions = questions
        self.answers = answers
        self.completion = completion
    }
    
    func save() {
        completion(answers)
    }
}
