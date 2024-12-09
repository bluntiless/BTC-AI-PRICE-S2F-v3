import Foundation

class S2FCalculator {
    // Constants for S2F model
    private let btcMaxSupply: Double = 21_000_000
    private let blocksPerHalving: Double = 210_000
    private let blockTime: Double = 10 * 60 // 10 minutes in seconds
    
    // Current block subsidy (gets halved every 210,000 blocks)
    private var currentBlockSubsidy: Double = 6.25
    
    func calculateS2FRatio(at date: Date) -> Double {
        let blockHeight = getEstimatedBlockHeight(at: date)
        let halvings = floor(blockHeight / blocksPerHalving)
        
        // Calculate current block subsidy based on halvings
        let subsidy = currentBlockSubsidy * pow(0.5, halvings)
        
        // Calculate flow (new supply per year)
        let blocksPerYear = 365.25 * 24 * 60 * 60 / blockTime
        let annualProduction = subsidy * blocksPerYear
        
        // Calculate stock (total supply at given date)
        let totalSupply = calculateTotalSupply(at: blockHeight)
        
        // S2F ratio is stock divided by flow
        return totalSupply / annualProduction
    }
    
    func predictPrice(fromS2FRatio s2f: Double) -> Double {
        // Plan B's model uses this formula: Price = exp(-1.84) * S2F^3.36
        let coefficient: Double = exp(-1.84)
        let exponent: Double = 3.36
        
        return coefficient * pow(s2f, exponent)
    }
    
    private func getEstimatedBlockHeight(at date: Date) -> Double {
        let secondsSinceGenesis = date.timeIntervalSince(BitcoinConstants.genesisDate)
        return secondsSinceGenesis / blockTime
    }
    
    private func calculateTotalSupply(at blockHeight: Double) -> Double {
        var supply: Double = 0
        var currentSubsidy = 50.0 // Initial block reward
        let halvings = floor(blockHeight / blocksPerHalving)
        
        for halving in 0...Int(halvings) {
            let blocksInEra: Double
            if halving == Int(halvings) {
                blocksInEra = blockHeight.truncatingRemainder(dividingBy: blocksPerHalving)
            } else {
                blocksInEra = blocksPerHalving
            }
            
            supply += blocksInEra * currentSubsidy
            currentSubsidy /= 2
        }
        
        return supply
    }
}

enum BitcoinConstants {
    static let genesisDate = Date(timeIntervalSince1970: 1231006505) // Bitcoin genesis block timestamp
} 