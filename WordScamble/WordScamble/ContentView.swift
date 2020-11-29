//
//  ContentView.swift
//  WordScamble
//
//  Created by Dave Spina on 11/29/20.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        let people = ["John", "Paul", "George", "Ringo"]
        
        // file URL usage
        if let fileURL = Bundle.main.url(forResource: "some-file", withExtension: "txt") {
            if let fileContent = try? String(contentsOf: fileURL) {
                // the file contents are loaded into a string
            }
            
        }
        
        List {
            Section(header: Text("Dynamic Data")) {
                ForEach(people, id: \.self) {
                    Text($0)
                }
            }
            Section(header: Text("Static Data")) {
                Text("And Bobby!")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
