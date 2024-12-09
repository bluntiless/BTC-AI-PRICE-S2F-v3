import Foundation

class S2FDataService {
    private let calculator = S2FCalculator()
    
    func fetchS2FData() async throws -> [S2FDataPoint] {
        var dataPoints: [S2FDataPoint] = []
        let calendar = Calendar.current
        
        // Generate data points for past 4 years and future 4 years
        let startDate = calendar.date(byAdding: .year, value: -4, to: Date()) ?? Date()
        let endDate = calendar.date(byAdding: .year, value: 4, to: Date()) ?? Date()
        var currentDate = startDate
        
        while currentDate <= endDate {
            let s2fRatio = calculator.calculateS2FRatio(at: currentDate)
            let predictedPrice = calculator.predictPrice(fromS2FRatio: s2fRatio)
            
            let dataPoint = S2FDataPoint(
                date: currentDate,
                price: predictedPrice,
                s2fRatio: s2fRatio
            )
            
            dataPoints.append(dataPoint)
            
            // Move to next month
            currentDate = calendar.date(byAdding: .month, value: 1, to: currentDate) ?? currentDate
        }
        
        return dataPoints
    }
    
    func getPredictedPrice(for date: Date) -> Double {
        let s2fRatio = calculator.calculateS2FRatio(at: date)
        return calculator.predictPrice(fromS2FRatio: s2fRatio)
    }
} 