//
//  Model.swift
//
//
//  Created by Leo Haufs on 13.06.18.
//

import Foundation

public class Model: NSObject {
    var startknoten: [Knoten]
    var endknoten: [Knoten]
    
    var knoten: [Knoten]
    var kritischePfade: [[Knoten]]
    var zyklus: [Knoten]
    
    var isZusammenhaengend: Bool
    var gueltigeReferenzen: Bool
    
    var name: String
    
    override init() {
        self.knoten = []
        self.name = "not set"
        
        self.startknoten = []
        self.endknoten = []
        
        self.kritischePfade = []
        self.zyklus = []
        self.gueltigeReferenzen = true
        self.isZusammenhaengend = true
    }
    
    convenience init(knoten: [Knoten], name: String) {
        self.init()
        self.knoten = knoten
        self.name = name
        
        self.initKnoten(knoten: knoten);
        self.startknoten = self.getStartknoten(knoten: knoten)
        self.endknoten = self.getEndknoten(knoten: knoten)
    }
    
    /**
     * Initialisiert eine liste von Knoten, setzt also die Vorgänger und Nachfolger
     * der Knoten
     *
     * @param knoten
     *            Liste von Knoten
     */
    private func initKnoten(knoten: [Knoten]){
        for k in knoten {
            for vorgaengerNr in k.vorgaengerNummern{
                for k2 in knoten{
                    if k2.vorgangsnummer == vorgaengerNr{
                        k.vorgaenger.append(k2)
                    }
                }
            }
            
            for nachfolgerNr in k.nachfolgerNummern{
                for k2 in knoten{
                    if k2.vorgangsnummer == nachfolgerNr{
                        k.nachfolger.append(k2)
                    }
                }
            }
        }
    }
    
    /**
     * Bestimmt die Startknoten einer Liste von Knoten
     *
     * @param knoten
     *            Liste von Knoten
     * @return Startknoten einer Liste von Knoten
     */
    private func getStartknoten(knoten:[Knoten]) -> [Knoten]{
        var startknoten: [Knoten] = []
        for k in knoten {
            if (k.vorgaengerNummern.count == 0){
                startknoten.append(k)
            }
        }
        return startknoten
    }
    
    /**
     * Bestimmt die Endknoten einer Liste von Knoten
     *
     * @param knoten
     *            Liste von Knoten
     * @return Endknoten einer Liste von Knoten
     */
    private func getEndknoten(knoten:[Knoten]) -> [Knoten]{
        var endknoten: [Knoten] = []
        for k in knoten {
            if (k.nachfolgerNummern.count == 0){
                endknoten.append(k)
            }
        }
        return endknoten
    }
    
    

}
