import Foundation
import CoreML

class PricePredictionViewModel: ObservableObject {
    @Published var prediction: PricePrediction?
    @Published var s2fData: [S2FDataPoint] = []
    
    private let s2fService = S2FDataService()
    private var aiModel: BTCPricePredictor?
    
    init() {
        Task {
            await loadS2FData()
        }
        setupAIModel()
    }
    
    func predictPrice(for date: Date) {
        // Get S2F prediction
        let s2fPrice = s2fService.getPredictedPrice(for: date)
        
        // For now, we'll use S2F prediction with some random variation
        // Later, this will be replaced with actual AI prediction
        let variationPercent = Double.random(in: -15...15)
        let aiPrice = s2fPrice * (1 + variationPercent / 100)
        
        // Average both predictions
        let finalPrice = (s2fPrice + aiPrice) / 2
        
        DispatchQueue.main.async {
            self.prediction = PricePrediction(
                price: finalPrice,
                confidence: 85.0, // This should be calculated based on model confidence
                date: date,
                s2fPrice: s2fPrice,
                aiPrice: aiPrice
            )
        }
    }
    
    private func loadS2FData() async {
        do {
            let data = try await s2fService.fetchS2FData()
            DispatchQueue.main.async {
                self.s2fData = data
            }
        } catch {
            print("Error loading S2F data: \(error)")
        }
    }
    
    private func setupAIModel() {
        // Initialize CoreML model
        // This will be implemented later
    }
}

struct PricePrediction {
    let price: Double
    let confidence: Double
    let date: Date
    let s2fPrice: Double
    let aiPrice: Double
}

struct S2FDataPoint: Identifiable {
    let id = UUID()
    let date: Date
    let price: Double
    let s2fRatio: Double
    
    static var sampleData: [S2FDataPoint] {
        // Generate sample data points for testing
        let calendar = Calendar.current
        var dataPoints: [S2FDataPoint] = []
        
        for i in 0..<100 {
            let date = calendar.date(byAdding: .day, value: i, to: Date()) ?? Date()
            let price = Double.random(in: 30000...60000)
            let s2fRatio = Double.random(in: 50...100)
            
            dataPoints.append(S2FDataPoint(date: date, price: price, s2fRatio: s2fRatio))
        }
        
        return dataPoints
    }
} 