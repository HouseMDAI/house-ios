//
//  HomePresenter.swift
//  AIDoctor
//
//  Created by Mark Parker on 16/03/2024.
//

import Foundation

enum NavigationPage: Hashable {
    case questinary(Questionary)
    case answer(String)
}

class HomePresenter: ObservableObject {
    
    @Published var message: String = ""
    @Published var navigationPath: [NavigationPage] = []
    
    init(message: String = "") {
        self.message = message
    }
    
    func onSend() {
        Task {
            let doctor = DoctorProvider()
            let answer = try! await doctor.sendMessage(message: message)
            switch answer {
            case .questions(let questions):
                navigationPath.append(.questinary(questions))
            case .answer(let string):
                navigationPath.append(.answer(string))
            }
        }
    }
    
    func onQuestionaryFilled(filled: FilledQuestionary) {
        Task {
            let doctor = DoctorProvider()
            let answer = try! await doctor.sendAnswers(message: message, answers: filled)
            switch answer {
            case .questions(let questions):
                navigationPath.append(.questinary(questions))
            case .answer(let string):
                navigationPath.append(.answer(string))
            }
        }
    }
}
