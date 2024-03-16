//
//  HomeView.swift
//  AIDoctor
//
//  Created by Mark Parker on 16/03/2024.
//

import SwiftUI

struct HomeView: View {
    
    @StateObject var presenter: HomePresenter
    
    var body: some View {
        NavigationStack(path: $presenter.navigationPath) {
            VStack {
                Text("How are you?")
                TextField("...", text: $presenter.message)
                    .lineLimit(5)
                Button("Send", action: presenter.onSend)
            }
        }.navigationDestination(for: NavigationPage.self) { page in
            switch page {
            case .questinary(let questions):
                QuestionaryView(
                    presenter: QuestionaryPresenter(
                        questions: questions,
                        answers: FilledQuestionary(filledQuestions: [:]),
                        completion: presenter.onQuestionaryFilled
                    )
                )
            case .answer(let string):
                Text("Result: " + string)
            }
        }
    }
}
