//
//  ContentView.swift
//  BTC AI PRICE S2F
//
//  Created by WAYNE WRIGHT on 09/12/2024.
//

import SwiftUI
import Charts // For S2F visualization

struct ContentView: View {
    @StateObject private var viewModel = PricePredictionViewModel()
    @State private var selectedDate = Date()
    @State private var showingPrediction = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Halving Countdown
                    HalvingCountdownView()
                        .padding(.horizontal)
                    
                    // Date Selection
                    DatePicker("Select Future Date",
                             selection: $selectedDate,
                             in: Date()...,
                             displayedComponents: [.date, .hourAndMinute])
                        .datePickerStyle(.graphical)
                        .padding()
                    
                    // Prediction Button
                    Button(action: {
                        viewModel.predictPrice(for: selectedDate)
                        showingPrediction = true
                    }) {
                        Text("Predict Price")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                    .padding(.horizontal)
                    
                    // S2F Chart
                    S2FChartView(data: viewModel.s2fData)
                        .frame(height: 300)
                        .padding()
                    
                    // Prediction Result
                    if showingPrediction {
                        PredictionResultView(prediction: viewModel.prediction)
                    }
                }
            }
            .navigationTitle("BTC Price Predictor")
        }
    }
}

struct PredictionResultView: View {
    let prediction: PricePrediction?
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Price Predictions")
                .font(.headline)
            
            if let prediction = prediction {
                VStack(spacing: 8) {
                    Text("Combined Prediction")
                        .font(.subheadline)
                    Text("$\(prediction.price, specifier: "%.2f")")
                        .font(.system(size: 36, weight: .bold))
                    
                    Divider()
                    
                    HStack(spacing: 20) {
                        VStack {
                            Text("S2F Model")
                                .font(.caption)
                            Text("$\(prediction.s2fPrice, specifier: "%.2f")")
                                .font(.headline)
                        }
                        
                        VStack {
                            Text("AI Model")
                                .font(.caption)
                            Text("$\(prediction.aiPrice, specifier: "%.2f")")
                                .font(.headline)
                        }
                    }
                    
                    Text("Confidence: \(prediction.confidence, specifier: "%.1f")%")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            } else {
                ProgressView()
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(10)
        .shadow(radius: 5)
    }
}

#Preview {
    ContentView()
}
