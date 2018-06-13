//
//  Knoten.swift
//
//
//  Created by Leo Haufs on 13.06.18.
//

import Foundation

public class Knoten: NSObject {
    var vorgangsnummer: Int
    var vorgangsbezeichnung: String
    var faz: Int = 0
    var fez: Int = 0
    var dauer: Int = 0
    var gp: Int = 0
    var fp: Int = 0
    var saz: Int = 0
    var sez: Int = 0
    
    var vorgaenger: [Knoten]
    var vorgaengerNummern: [Int]
    
    var nachfolger: [Knoten]
    var nachfolgerNummern: [Int]
    
    init(vorgangsnummer: Int, vorgangsbezeichnung: String, dauer: Int, vorgaengerNummern: [Int], nachfolgerNummern: [Int]) {
        self.vorgangsnummer = vorgangsnummer
        self.vorgangsbezeichnung = vorgangsbezeichnung
        self.dauer = dauer
        self.vorgaengerNummern = vorgaengerNummern
        self.nachfolgerNummern = nachfolgerNummern
        
        self.vorgaenger = []
        self.nachfolger = []
    }
}
