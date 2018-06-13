//
//  Knoten.swift
//  
//
//  Created by Leo Haufs on 13.06.18.
//

import Foundation

class Knoten: NSObject {
    vorgangsnummer: int
    vorgangsbezeichnung: String
    faz: int
    fez: int
    dauer: int
    gp: int
    fp: int
    saz: int
    sez: int
    
    vorgaenger: [Knoten]
    vorgaengerNummern: [int]
    
    nachfolger: [Knoten]
    nachfolgerNummern: [int]
    
    init(vorgangsnummer: int, vorgangsbezeichnung: String, dauer: int, vorgangsNummern: [int], nachfolgerNummern: [int]) {
        self.vorgangsnummer = vorgangsnummer
        self.vorgangsbezeichnung = vorgangsbezeichnung
        self.dauer = dauer
        self.vorgangsNummern = vorgangsNummern
        self.nachfolgerNummern = nachfolgerNummern
        
        self.vorgaenger = []
        self.nachfolger = []
    }
}
