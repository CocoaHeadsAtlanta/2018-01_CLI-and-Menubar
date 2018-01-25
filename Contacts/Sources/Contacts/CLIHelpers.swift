//
//  CLIHelpers.swift
//  Contacts
//
//  Created by Michael L. Ward on 1/25/18.
//

import Foundation
import Utility
import Basic

func printUsage(withMessage message: String = "Something went wrong.\n") {
    stdoutStream.write(message)
    print(parser.printUsage(on: stdoutStream))
    stdoutStream.flush()
}

func processArguments(arguments: ArgumentParser.Result) -> (store: PersonStore, shouldYell: Bool) {
    guard let file = arguments.get(pathArg) else {
        printUsage(withMessage: "No file provided!\n")
        exit(EXIT_FAILURE)
    }
    
    guard let store = PersonStore(path: file) else {
        printUsage(withMessage: "Couldn't find the file.\n")
        exit(EXIT_FAILURE)
    }
    
    let shouldYell = arguments.get(yellArg) ?? false
    
    return (store: store, shouldYell: shouldYell)
}
