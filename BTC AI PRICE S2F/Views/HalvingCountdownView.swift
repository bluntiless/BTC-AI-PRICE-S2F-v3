import SwiftUI

struct HalvingCountdownView: View {
    @StateObject private var viewModel = HalvingCountdownViewModel()
    
    var body: some View {
        VStack(spacing: 12) {
            Text("Next Bitcoin Halving")
                .font(.headline)
            
            Text(viewModel.formattedDate)
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            HStack(spacing: 20) {
                CountdownUnit(value: viewModel.days, unit: "DAYS")
                CountdownUnit(value: viewModel.hours, unit: "HOURS")
                CountdownUnit(value: viewModel.minutes, unit: "MINUTES")
                CountdownUnit(value: viewModel.seconds, unit: "SECONDS")
            }
            
            Text("Blocks until halving: \(viewModel.remainingBlocks)")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(15)
    }
}

struct CountdownUnit: View {
    let value: Int
    let unit: String
    
    var body: some View {
        VStack(spacing: 4) {
            Text("\(value)")
                .font(.system(size: 24, weight: .bold, design: .monospaced))
            Text(unit)
                .font(.system(size: 10, weight: .medium))
                .foregroundColor(.secondary)
        }
    }
} 