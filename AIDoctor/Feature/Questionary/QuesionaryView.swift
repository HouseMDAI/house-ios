//
//  QuesionaryView.swift
//  AIDoctor
//
//  Created by Mark Parker on 16/03/2024.
//

import SwiftUI

struct QuestionaryView: View {
    
    @StateObject var presenter: QuestionaryPresenter
    
    var body: some View {
        ScrollView {
            ForEach(presenter.questions.questions) { question in
                VStack {
                    Text(question.text)
                    TextField("", text: bindingForQuestion(question))
                }
                .padding()
            }
            
            
            Button("Save", action: presenter.save)
        }
    }
    
    private func bindingForQuestion(_ question: Question) -> Binding<String> {
        Binding(
            get: { self.presenter.answers.filledQuestions[question] ?? "" },
            set: { self.presenter.answers.filledQuestions[question] = $0 }
        )
    }
}

