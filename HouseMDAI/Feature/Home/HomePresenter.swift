//
//  HomePresenter.swift
//  HouseMDAI
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
    
    private let doctor: any DoctorProvider
    
    init(message: String = "", doctor: any DoctorProvider) {
        self.message = message
        self.doctor = doctor
    }
    
    func onSend() {
        Task {
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
        Task {
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
