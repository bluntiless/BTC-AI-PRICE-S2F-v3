import Foundation
import Combine

class HalvingCountdownViewModel: ObservableObject {
    @Published var days: Int = 0
    @Published var hours: Int = 0
    @Published var minutes: Int = 0
    @Published var seconds: Int = 0
    @Published var remainingBlocks: Int = 0
    @Published var formattedDate: String = ""
    
    private var timer: Timer?
    private let calendar = Calendar.current
    
    init() {
        setupTimer()
        updateCountdown()
    }
    
    deinit {
        timer?.invalidate()
    }
    
    private func setupTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.updateCountdown()
        }
    }
    
    private func updateCountdown() {
        let nextHalving = calculateNextHalvingDate()
        formattedDate = formatDate(nextHalving)
        
        let components = calendar.dateComponents([.day, .hour, .minute, .second],
                                              from: Date(),
                                              to: nextHalving)
        
        days = max(components.day ?? 0, 0)
        hours = max(components.hour ?? 0, 0)
        minutes = max(components.minute ?? 0, 0)
        seconds = max(components.second ?? 0, 0)
        
        updateRemainingBlocks()
    }
    
    private func calculateNextHalvingDate() -> Date {
        // Next halving is expected around April 2024 (block 840,000)
        let targetBlock = 840_000
        let currentBlock = getCurrentBlockHeight()
        remainingBlocks = targetBlock - currentBlock
        
        // Calculate remaining time based on 10-minute block time
        let remainingSeconds = Double(remainingBlocks) * 600 // 10 minutes = 600 seconds
        return Date().addingTimeInterval(remainingSeconds)
    }
    
    private func getCurrentBlockHeight() -> Int {
        // In a real app, you would fetch this from a Bitcoin node or API
        // For now, we'll estimate it
        let secondsSinceGenesis = Date().timeIntervalSince(BitcoinConstants.genesisDate)
        return Int(secondsSinceGenesis / 600) // 600 seconds per block
    }
    
    private func updateRemainingBlocks() {
        remainingBlocks = 840_000 - getCurrentBlockHeight()
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
} 