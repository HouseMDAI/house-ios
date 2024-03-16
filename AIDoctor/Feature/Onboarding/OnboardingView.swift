//
//  OnboardingView.swift
//  AIDoctor
//
//  Created by Mark Parker on 16/03/2024.
//

import SwiftUI

struct OnboardingView: View {
    
    @StateObject var presenter: OnboardingPresenter
    
    var body: some View {
        ScrollView {
            Spacer()
            VStack {
                ForEach(presenter.questions.questions) { question in
                    VStack {
                        Text(question.text)
                        TextField("", text: bindingForQuestion(question))
                            .formItem()
                    }
                    .padding()
                }
            }.padding()
            
            Button("Save", action: presenter.save)
            Spacer()
        }
    }
    
    private func bindingForQuestion(_ question: Question) -> Binding<String> {
        Binding(
            get: { self.presenter.answers.filledQuestions[question] ?? "" },
            set: { self.presenter.answers.filledQuestions[question] = $0 }
        )
    }
}
