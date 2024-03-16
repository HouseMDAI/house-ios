//
//  HomePresenter.swift
//  AIDoctor
//
//  Created by Mark Parker on 16/03/2024.
//

import Foundation

enum NavigationPage: Hashable {
    case questinary(Questionary, FilledQuestionary)
    case answer(String)
}

class HomePresenter: ObservableObject {
    
    @Published var message: String = ""
    @Published var navigationPath: [NavigationPage] = []
    
    init(message: String = "") {
        self.message = message
    }
    
    func onSend() {
        // test
//        navigationPath.append(.questinary(Questionary(questions: [
//            Question(text: "When did it start?"),
//            Question(text: "Did you do something unusual yesterday?")
//        ]), FilledQuestionary(filledQuestions: [:])))
//        
//        return;
        
        Task {
            let doctor = DoctorProvider()
            let answer = try! await doctor.sendMessage(message: message)
            switch answer {
            case .questions(let questions):
                navigationPath.append(.questinary(questions, FilledQuestionary(filledQuestions: [:])))
            case .answer(let string):
                navigationPath.append(.answer(string))
            }
        }
    }
    
    func onQuestionaryFilled(filled: FilledQuestionary) {
        // test
        
//        navigationPath.append(.answer("an apple a day keeps the doctor away"))
//        
//        return;
        
        Task {
            let doctor = DoctorProvider()
            let answer = try! await doctor.sendAnswers(message: message, answers: filled)
            switch answer {
            case .questions(let newQuestions):
                navigationPath.append(.questinary(newQuestions, filled))
            case .answer(let string):
                navigationPath.append(.answer(string))
            }
        }
    }
}
