//
//  ProgressMeter.swift
//  ProgressMeter
//
//

import SwiftUI

struct ProgressMeter: View {
    
    // For driving animation to reveal rectangle with progress meter fill
    @State private var progressMeterOffset = CGSize.zero
    
    // Width of the meter
    var meterWidth: CGFloat

    // Thickness of meter's border
    var borderWidth: CGFloat

    // Padding above and below progress meter
    var verticalPadding: CGFloat

    // Needed data to calculate colors and size of meter
    var correctResponses: Int
    var questionCount: Int

    // Percentage of full progress meter
    // If the progress meter is full, this will equal 1.0
    private var fractionOfFullMeter: Double {
        Double(correctResponses) / Double(questionCount)
    }
    
    // Ending color for progress meter
    // 120/360 degrees or 0.333 in Color struct terms is green
    // which is the top of the meter when all questions are correct
    private var endColor: Color {
        
        // If you had 10 out of 10 questions correct, this will equal 120.0 degrees
        let endingHue = fractionOfFullMeter * 120.0
        
        // Color is:
        // hue: 0-360 degrees, expressed as a value between 0 and 1
        // saturation: 0-100%, expressed as a value between 0 and 1
        // brightness: 0-100%, expressed as a value between 0 and 1
        // see: https://russellgordon.ca/lcs/HSB_Color_Model_Summary_Swift.pdf
        return Color(hue: endingHue / 360.0, saturation: 0.8, brightness: 0.9)
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                
                Spacer()
                
                HStack {
                    
                    Spacer()
                    
                    ZStack {

                        VStack(spacing: 0) {
                            
                            // This pushes the filled part of the progress meter down
                            Rectangle()
                                .fill(Color.primary)
                                .colorInvert()
                                .frame(width: meterWidth, height: (geometry.size.height - verticalPadding) - CGFloat(fractionOfFullMeter) * (geometry.size.height - verticalPadding), alignment: .center)
                            
                            // "Fill" for progress meter; stationary
                            Rectangle()
                                .fill(LinearGradient(gradient: Gradient(colors: [Color.red, endColor]),
                                                     startPoint: .bottom,
                                                     endPoint: .top))
                                .frame(width: meterWidth, height: CGFloat(fractionOfFullMeter) * (geometry.size.height - verticalPadding), alignment: .center)

                        }

                        // Will slide up
                        Rectangle()
                            .fill(Color.primary)
                            .colorInvert()
                            .frame(width: meterWidth, height: geometry.size.height - verticalPadding, alignment: .center)
                            .offset(progressMeterOffset)
                            .onAppear(perform: {
                                withAnimation(Animation.easeIn(duration: 4.0)) {
                                    // Offset is moves the opaque rectangle up
                                    progressMeterOffset = CGSize(width: 0, height: -1 * (geometry.size.height - verticalPadding))
                                }
                            })

                        // Sits above the rectangle that slides up (in the z-axis)
                        // This means the rectangle sliding up will pass beneath this view
                        Rectangle()
                            .fill(Color(hue: 0, saturation: 0, brightness: 0, opacity: 0))
                            .frame(width: meterWidth + borderWidth, height: geometry.size.height - verticalPadding + borderWidth, alignment: .center)
                            .overlay(
                                Rectangle()
                                    .stroke(Color.primary, lineWidth: borderWidth)
                            )

                    }
                    
                    Spacer()

                }
                
                Spacer()
                
            }
        }
    }
}

struct ProgressMeter_Previews: PreviewProvider {
    static var previews: some View {
         ProgressMeter(meterWidth: 100, borderWidth: 2, verticalPadding: 44, correctResponses: 7, questionCount: 10)
    }
}
