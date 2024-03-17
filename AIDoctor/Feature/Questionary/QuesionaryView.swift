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
            Spacer()
            VStack {
                ForEach(presenter.questions.questions) { question in
                    VStack {
                        Text(question.text)
                            .font(.title3)
                        TextField("", text: bindingForQuestion(question))
                            .formItem()
                    }
                    .padding()
                }
                Button("Next", action: presenter.save)
            }
            .padding()
            Spacer()
        }
    }
    
    private func bindingForQuestion(_ question: Question) -> Binding<String> {
        Binding(
            get: { self.presenter.answers.filledQuestions[question.text] ?? "" },
            set: { self.presenter.answers.filledQuestions[question.text] = $0 }
        )
    }
}

