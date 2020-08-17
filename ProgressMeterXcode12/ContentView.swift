//
//  ContentView.swift
//  ProgressMeter
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        ProgressMeter(meterWidth: 100, borderWidth: 2, verticalPadding: 100, correctResponses: 7, questionCount: 10)
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
         ContentView()
    }
}
