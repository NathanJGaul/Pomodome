//
//  ContentView.swift
//  Pomodome
//
//  Created by Nathan Gaul on 1/2/24.
//

import SwiftUI

struct ContentView: View {
    @State private var work = 20
    @State private var rest = 5
    @State private var timeRemaining = 0
    
    @State var isTimerRunning = false
    @State private var startTime = Date()
    @State private var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var totalTime: Int {
        return work + rest
    }
    
    var currentTimeProportion: Double {
        return Double(timeRemaining) / Double(totalTime * 60)
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
                        .onReceive(timer, perform: { _ in
                            if self.isTimerRunning {
                                self.timeRemaining = Int(Date().timeIntervalSince(startTime))
                            }
                        })
                }
                Spacer()
                VStack {
                    Stepper(
                        "Work: \(work) mins", value: $work, in: 1...100, step: 1
                    )
                    .foregroundStyle(.white)
                    .tint(.white)
                    .disabled(isTimerRunning)
                    Stepper(
                        "Rest: \(rest) mins", value: $rest, in: 1...100, step: 1
                    )
                    .foregroundStyle(.white)
                    .tint(.white)
                    .disabled(isTimerRunning)
                }
                Spacer()
                Button {
                    if isTimerRunning {
                        self.stopTimer()
                    } else {
                        startTime = Date()
                        self.startTimer()
                    }
                    self.isTimerRunning.toggle()
                } label: {
                    if isTimerRunning {
                        Text("Stop Timer")
                            .fontWeight(.bold)
                            .font(.title)
                            .foregroundStyle(.white)
                    } else {
                        Text("Start Timer")
                            .fontWeight(.bold)
                            .font(.title)
                            .foregroundStyle(.white)
                    }
                    
                }
                .padding(8)
                .background(.orange.opacity(0.75))
                .clipShape(RoundedRectangle(cornerSize: CGSize(width: 20, height: 10)))
                
            }
            .padding(50.0)
        }
    }
    
    func stopTimer() {
        self.timer.upstream.connect().cancel()
        self.timeRemaining = 0
    }
    
    func startTimer() {
        self.timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
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
