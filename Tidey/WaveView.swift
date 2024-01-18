//
//  WaveView.swift
//  Tidey
//  Lifted from https://stackoverflow.com/questions/63397067/fill-circle-with-wave-animation-in-swiftui
//  Created by Ben Reed on 18/01/2024.
//

import SwiftUI

struct Wave: Shape {

    var offset: Angle
    var percent: Double
    
    var heightMultiplier: Double = 0.015
    
    var animatableData: Double {
        get { offset.degrees }
        set { offset = Angle(degrees: newValue) }
    }
    
    func path(in rect: CGRect) -> Path {
        
        //Create the path object to hold the waveform path we will draw
        var p = Path()

        // empirically determined values for wave to be seen
        // at 0 and 100 percent
        let lowfudge = 0.02
        let highfudge = 0.98
        
        let newpercent = lowfudge + (highfudge - lowfudge) * percent
        let waveHeight = heightMultiplier * rect.height
        let yoffset = CGFloat(1 - newpercent) * (rect.height - 4 * waveHeight) + 2 * waveHeight
        let startAngle = offset
        let endAngle = offset + Angle(degrees: 360)
        
        p.move(to: CGPoint(x: 0, y: yoffset + waveHeight * CGFloat(sin(offset.radians))))
        
        for angle in stride(from: startAngle.degrees, 
                            through: endAngle.degrees, by: 5) {
            
            let x = CGFloat((angle - startAngle.degrees) / 360) * rect.width
            p.addLine(to: CGPoint(x: x, y: yoffset + waveHeight * CGFloat(sin(Angle(degrees: angle).radians))))
            
        }
        
        p.addLine(to: CGPoint(x: rect.width, y: rect.height))
        p.addLine(to: CGPoint(x: 0, y: rect.height))
        p.closeSubpath()
        
        return p
    }
}

struct WaveView<S:Shape>: View {
    
    @State private var waveOffset = Angle(degrees: 0)
    let percent: Int
    var boundingShape:S
    var showLabel:Bool = false
    var waveColour:Color = .blue
    var boundingShapeColour:Color = .blue
    var borderPadding:Double = 0.92
    var borderStrokeWidthMultiplier:Double = 0.025
    var labelFontSizeMultiplier:Double = 0.25
    
    
    var body: some View {

        GeometryReader { geo in
            ZStack {
                
                if showLabel {
                    Text("\(self.percent)%")
                        .foregroundColor(.black)
                        .font(Font.system(size: labelFontSizeMultiplier * min(geo.size.width, geo.size.height)))
                }
                
                boundingShape
                    .stroke(boundingShapeColour, lineWidth: borderStrokeWidthMultiplier * min(geo.size.width, geo.size.height))
                    .overlay(
                        Wave(offset: Angle(degrees: self.waveOffset.degrees), 
                             percent: Double(percent)/100)
                            .fill(waveColour)
                            .clipShape(boundingShape.scale(borderPadding))
                    )
            }
        }
        .aspectRatio(1, contentMode: .fit)
        .onAppear {
            withAnimation(Animation.linear(duration: 5).repeatForever(autoreverses: false)) {
            self.waveOffset = Angle(degrees: 360)
            }
        }
    }
}

#Preview {
    VStack {
        WaveView<Rectangle>(percent: 50, boundingShape: Rectangle())
    }
    .padding()
}
