import SwiftUI
import Charts

struct S2FChartView: View {
    let data: [S2FDataPoint]
    
    var body: some View {
        Chart(data) { dataPoint in
            LineMark(
                x: .value("Date", dataPoint.date),
                y: .value("Price", dataPoint.price)
            )
            .foregroundStyle(.blue)
            
            LineMark(
                x: .value("Date", dataPoint.date),
                y: .value("S2F", dataPoint.s2fRatio * 100)
            )
            .foregroundStyle(.orange)
        }
        .chartXAxis {
            AxisMarks(values: .automatic(desiredCount: 5))
        }
        .chartYAxis {
            AxisMarks(position: .leading)
        }
        .chartLegend(position: .bottom, spacing: 20)
    }
} 