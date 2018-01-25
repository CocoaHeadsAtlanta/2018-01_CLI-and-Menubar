import Cocoa
import Utility
import Basic

var store: PersonStore
var shouldYell = false

// Prepare the argument parser
let args = Array(CommandLine.arguments.dropFirst())

let parser = ArgumentParser(usage: "[-y] file",
                            overview: "This tool just prints buttheads to the console.")

let yellArg: OptionArgument<Bool> = parser.add(option: "--yell",
                                               shortName: "-y",
                                               kind: Bool.self,
                                               usage: "YELL ALL OUTPUT!")

let pathArg: PositionalArgument<String> = parser.add(positional: "file",
                                                     kind: String.self,
                                                     optional: false,
                                                     usage: "JSON file to load the contacts from.",
                                                     completion: .filename)


// Handle the Arguments
do {
    let parsedArgs = try parser.parse(args)
    let results = processArguments(arguments: parsedArgs)
    
    store = results.store
    shouldYell = results.shouldYell
    
} catch let error as ArgumentParserError {
    print(error.description)
    printUsage()
    exit(EXIT_FAILURE)
} catch {
    print(error.localizedDescription)
    exit(EXIT_FAILURE)
}

// Do Whatever Else You Want
try! store.loadPeople()
if shouldYell {
    store.people.forEach { print($0.description.uppercased()) }
} else {
    store.people.forEach { print($0.description) }
}

// Get some input?
var inputAccepted = false

repeat {
    print("\n\nReally fire these people? [y|N] ")
    let input = readLine() ?? ""
    switch input {
    case "y", "Y":
        print("It is done.")
        inputAccepted = true
    case "n", "N", "":
        print("Whew! They'll thank you.")
        inputAccepted = true
    default:
        print("I didn't get that.")
    }
} while inputAccepted == false
