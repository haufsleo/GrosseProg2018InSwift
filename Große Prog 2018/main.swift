//
//  main.swift
//  Große Prog 2018
//
//  Created by Leo Haufs on 13.06.18.
//  Copyright © 2018 Leo Haufs. All rights reserved.
//

import Foundation

//let path = "/Users/hfs23/Desktop/N_LinearerGraph.in"

print("Pfad eingeben (z.B. /Users/hfs23/Desktop/N_LinearerGraph.in):")

if let path = readLine() {
    let input = LeseAusDatei()
    let model: Model = input.getModelAusDatei(path: path)
    let c : Controller = Controller(model: model)
    c.calculate()
    
    let ausgabeInKonsole: AusgabeInKonsole = AusgabeInKonsole(model: model)
    ausgabeInKonsole.gebeAufKonsoleAus()
    
    let ausgabeInDatei: AusgabeInDatei = AusgabeInDatei(model: model)
    ausgabeInDatei.schreibeModelInDatei(filename: "Ausgabe.txt")
    
    print("done")

} else {
    print("Fehler bei der EIngabe")
}


