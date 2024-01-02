//
//  ContentView.swift
//  Pomodome
//
//  Created by Nathan Gaul on 1/2/24.
//

import SwiftUI

struct ContentView: View {
    @State private var currentTimeProportion = 0.0
    @State private var work = 20
    @State private var rest = 5
    
    var totalTime: Int {
        return work + rest
    }
    var workProportion: Double {
        return Double(work) / Double(totalTime)
    }
    
    init() {
        UIStepper.appearance().setDecrementImage(UIImage(systemName: "minus"), for: .normal)
        UIStepper.appearance().setIncrementImage(UIImage(systemName: "plus"), for: .normal)
    }
    
    var body: some View {
        ZStack {
            Color(UIColor(.purple))
                .ignoresSafeArea(.all)
            VStack {
                Spacer()
                ZStack {
                    CircularProgressView(progress: currentTimeProportion, workProportion: workProportion)
                }
                Spacer()
                VStack {
                    Stepper(
                        "Work: \(work) mins", value: $work, in: 1...100, step: 1
                    )
                    .foregroundStyle(.white)
                    .tint(.white)
                    
                    Stepper(
                        "Rest: \(rest) mins", value: $rest, in: 1...100, step: 1
                    )
                    .foregroundStyle(.white)
                    .tint(.white)
                }
                Spacer()
                Button {
                    print("Starting Timer")
                } label: {
                    Text("Start Timer")
                        .fontWeight(.bold)
                        .font(.title)
                        .foregroundStyle(.white)
                }
                .padding(8)
                .background(.orange.opacity(0.75))
                .clipShape(RoundedRectangle(cornerSize: CGSize(width: 20, height: 10)))
            }
            .padding(50.0)
        }
    }
}

#Preview {
    ContentView()
}

struct CircularProgressView: View {
    let progress: Double
    let workProportion: Double
    
    var body: some View {
        ZStack {
            Circle()
                .trim(from: 0.0, to: workProportion)
                .stroke(
                    .orange.opacity(0.75),
                    lineWidth: 30
                )
                .animation(.easeOut, value: workProportion)
            Circle()
                .trim(from: workProportion, to: 1.0)
                .stroke(
                    .green.opacity(0.75),
                    lineWidth: 30
                )
                .animation(.easeOut, value: workProportion)
            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    .white.opacity(0.85),
                    style: StrokeStyle(
                        lineWidth: 20,
                        lineCap: .round
                    )
                )
                .animation(.easeOut, value: progress)
        }
        .rotationEffect(.degrees(-90))
    }
}
