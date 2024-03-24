//
//  HomeView.swift
//  HouseMDAI
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
                    .lineLimit(5...10)
                    .formItem()
                Button("Send", action: presenter.onSend)
            }
            .padding()
            .navigationDestination(for: NavigationPage.self) { page in
                switch page {
                case .questinary(let questions, let answers):
                    QuestionaryView(
                        presenter: QuestionaryPresenter(
                            questions: questions,
                            answers: answers,
                            completion: presenter.onQuestionaryFilled
                        )
                    )
                case .answer(let string):
                    VStack {
                        Text("The doctor says...")
                        Text(string)
                            .font(.title2)
                            .padding()
                    }
                }
            }
        }
    }
}
