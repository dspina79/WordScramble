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
        // handling mispellings
        let word = "wastekdkd"
        let checker = UITextChecker()

        let range = NSRange(location: 0, length: word.utf16.count)
        let mispelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
       let mispellingResult = mispelledRange.location == NSNotFound ? "All good" : "Oops!"
        
        let inputLetters = """
                            a
                            b
                            c
                            dave
                            """
        let arrayLetters = inputLetters.components(separatedBy: "\n")
        
        List {
            Text("Mispelling Message: \(mispellingResult)")
            Section(header: Text("Dynamic Data")) {
                ForEach(people, id: \.self) {
                    Text($0)
                }
            }
            Section(header: Text("Static Data")) {
                Text("And Bobby!")
            }
            Section(header: Text("Data from String")) {
                ForEach(arrayLetters, id: \.self) {
                    Text($0)
                }
            }
            // random letter
            Section(header: Text("Random Letter")) {
                Text("\(arrayLetters.randomElement() ?? "")")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
