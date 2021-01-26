import SwiftUI

struct ContentView: View {
    @State private var usedWords = [String]()
    @State private var rootWord = ""
    @State private var newWord = ""
    
    @State private var errorTitle = ""
    @State private var errorMessage = ""
    @State private var showingError = false
    @State private var currentScore: Double = 0.0;
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [.blue, .green, .yellow]), startPoint: .top, endPoint: .bottom)
                    .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                VStack {
                    TextField("Enter your word", text: $newWord, onCommit: addNewWord)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                        .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                    List(usedWords, id: \.self) { word in
                        HStack {
                            Image(systemName: "\(word.count).circle")
                            Text(word)
                        }
                        .accessibilityElement(children: .ignore)
                        .accessibility(label: Text("\(word), \(word.count) letters."))
                    }
                    .padding()
                    Text("Score: \(currentScore, specifier: "%g")")
                        .foregroundColor(.black)
                        .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                        .fontWeight(.heavy)
                    Spacer()
                    
                }.navigationBarTitle(rootWord)
                .onAppear(perform: startGame)
                .navigationBarItems(leading: Button("New Game"){
                    startGame()
                }.foregroundColor(.white))
                .alert(isPresented: $showingError) {
                    Alert(title: Text(errorTitle), message: Text(errorMessage), dismissButton: .default(Text("Ok")))
                }
            }
        }
    }
    
    func isReal(word: String) -> Bool {
        guard word.count > 3 else {
            return false
        }
        
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspellings = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        
        return misspellings.location == NSNotFound
    }
    
    func isPossible(word: String) -> Bool {
        var tempWord = rootWord.lowercased()
        for letter in word {
            if let pos = tempWord.firstIndex(of:  letter) {
                tempWord.remove(at: pos)
            } else {
                return false
            }
        }
        return true
    }
    
    func isOriginal(word: String) -> Bool {
        return !usedWords.contains(word) && rootWord.lowercased() != word.lowercased()
    }
    
    func startGame() {
        currentScore = 0.0
        if let wordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            if let startWords = try? String(contentsOf: wordsURL) {
                let wordsArray = startWords.components(separatedBy: "\n")
                rootWord = wordsArray.randomElement() ?? "balderdash"
                self.usedWords = [String]()
                return
            }
        }
        
        fatalError("Could not load dictionary file.")
    }
    
    func wordError(title: String, message: String) {
        self.errorTitle = title
        self.errorMessage = message
        self.showingError = true
    }
    
    func addNewWord() {
        let answer = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard answer.count > 0 else {
            wordError(title: "Empty", message: "You cannot provide an empty word.")
            return
        }
        
        guard isOriginal(word: answer) else {
            wordError(title: "Not Original", message: "You've already specified that word or it is the root word.")
            return
        }
        
        guard isPossible(word: answer) else {
            wordError(title: "Not Possible", message: "You need to use the letters provided.")
            return
        }
        
        guard isReal(word: answer) else {
            wordError(title: "Misspelled", message: "The word you entered is not a real word or it is too short.")
            return
        }
        
        usedWords.insert(answer, at: 0)
        newWord = ""
        
        setScore()
    }
    
    func setScore() {
        guard usedWords.count > 0 else {
            currentScore = 0.0
            return
        }
        var currentAmount = 0.0
        for word in usedWords {
            currentAmount += Double(word.count)
        }
        
        currentScore = currentAmount / Double(usedWords.count)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
