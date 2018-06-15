//
//  Ausgabe.swift
//  Große Prog 2018
//
//  Created by Leo Haufs on 14.06.18.
//  Copyright © 2018 Leo Haufs. All rights reserved.
//

import Foundation

// Ermöglicht zu einem Model die Ausgabe der kenngrößen und kritischen Pfade
// auszugeben
public class Ausgabe {
    private var model: Model
    
    init(model: Model) {
        self.model = model
    }
    
    public func getAusgabeString() -> String{
        var res: String = ""
        
        if self.model.knoten.count == 0{
            res.append("Berechnung nicht möglich")
            res.append("\n")
            res.append("Bitte sehen Sie sich die Konsolenausgabe an, um weitere Informationen zu erhalten.")
        }else if self.model.zyklus.count != 0{
            res.append(self.model.name)
            res.append("\n")
            res.append("\n")
            res.append("Berechnung nicht möglich.")
            res.append("\n")
            res.append("Zyklus erkannt: ")
            res.append(self.getZyklusString())
        }else if !(model.isZusammenhaengend){
            res.append(self.model.name)
            res.append("\n")
            res.append("\n")
            res.append("Berechnung nicht möglich.")
            res.append("\n")
            res.append("Nicht zusammenhängend.")
        }else if self.model.gueltigeReferenzen{
            res.append(self.model.name)
            res.append("\n")
            res.append("\n")
            res.append("Berechnung nicht möglich.")
            res.append("\n")
            res.append(
                "Referenzen der Eingabe sind nicht gültig! Es gibt also mindestens einen Knoten,\ndessen Nachfolger den Knoten selbst nicht als Vorgänger hat\nbzw. dessen Vorgänger den Knoten selbst nicht als Nachfolger hat.")
        }else{
            res.append("Vorgangsnummer; Vorgangreseschreibung; D; FAZ; FEZ; SAZ; SEZ; GP; FP")
            res.append("\n")
            res.append(self.getKnotenbeschreibung())
            res.append("\n")
            res.append(self.getVorgangString())
            res.append("\n")
            res.append(self.getGesamtdauer())
            res.append("\n")
            res.append("\n")
            res.append(self.getKritischerPfadString())
        }
        return res
    }
    
    /**
     * Gibt die Beschreibung eines Knotens im Netzplan. Dabei wird der übergebene
     * StringBuilder verändert.
     *
     * @param res
     *            Stringbuilder, an den die Beschreibung angehängt werden soll
     */
    private func getKnotenbeschreibung() -> String {
        var res: String = ""
        for knoten in model.knoten{
            res.append(String(knoten.vorgangsnummer))
            res.append("; ")
            res.append(knoten.vorgangsbezeichnung)
            res.append("; ")
            res.append(String(knoten.dauer))
            res.append("; ")
            res.append(String(knoten.faz))
            res.append("; ")
            res.append(String(knoten.fez))
            res.append("; ")
            res.append(String(knoten.saz))
            res.append("; ")
            res.append(String(knoten.sez))
            res.append("; ")
            res.append(String(knoten.gp))
            res.append("; ")
            res.append(String(knoten.fp))
            res.append("\n")
        }
        return res
    }
    
    /**
     * Gibt die Beschreibung von Anfangs- und Endvorgang zurück
     *
     * @param res
     *            Stringbuilder, an den die Beschreibung von Anfangs- und Endvorgang
     *            angehängt werden soll
     */
    private func getVorgangString() -> String{
        var res: String = "Anfangsvorgang: "
        for i in 0..<model.startknoten.count{
            let startK: Knoten = model.startknoten[i]
            
            res.append(String(startK.vorgangsnummer))
            if (i != model.startknoten.count - 1) {
                res.append(",")
            }
        }
        res.append("\n")
        res.append("Endvorgang: ")
        for i in 0..<model.endknoten.count{
            let endK: Knoten = model.endknoten[i]
            
            res.append(String(endK.vorgangsnummer))
            if i != model.endknoten.count - 1 {
                res.append(",")
            }
        }
        return res
    }
    
    /**
     * * Gibt die Gesamtdauer des kritischen Pfades zurück. Sind mehrere Kritische
     * Pfade enthalten, so wird "Nicht eindeutig" zurückgegeben
     *
     * @param res
     *            StringBuilder, an den der Gesamtdauerstring angehängt werden soll.
     */
    private func getGesamtdauer()-> String {
        var res: String = ""
        res.append("Gesamtdauer: ")
        if self.model.kritischePfade.count == 0 {
            res.append("0")
        } else if self.model.kritischePfade.count > 1 {
            res.append("Nicht eindeutig")
        } else {
            var gesamtdauer: Int = 0
            let firstKritPfad: [Knoten] = self.model.kritischePfade[0]
            for knoten in firstKritPfad {
                gesamtdauer += knoten.dauer
            }
            res.append(String(gesamtdauer))
        }
        return res
    }
    
    /**
     * Hängt die String- Repräsentation des/der Kritischen Pfade(s) an einen
     * übergebenen Stringbuilder an
     *
     * @param res
     *            StringBuilder, an den die String- Repräsentation des/der
     *            Kritischen Pfade(s) angehängt werden soll
     */
    private func getKritischerPfadString() -> String{
        var res: String = ""
        if (self.model.kritischePfade.count > 1) {
            res.append("Kritische Pfade")
        } else {
            res.append("Kritischer Pfad")
        }
        res.append("\n")
        
        
        for kritischerPfad in model.kritischePfade{
            for i in 0..<kritischerPfad.count{
                let  knoten: Knoten = kritischerPfad[i]
                res.append(String(knoten.vorgangsnummer))
                if i != kritischerPfad.count - 1 {
                    res.append("->")
                }
            }
            res.append("\n")
        }
        return res
    }
    
    /**
     * Hängt die String- Repräsentation eines Zyklus an einen übergebenen
     * Stringbuilder an
     *
     * @param res
     *            StringBuilder, an den die String- Repräsentation des/der Zyklus
     *            angehängt werden soll
     */
    private func getZyklusString() -> String{
        var res: String = ""
        let posDerErstenWiederholung: Int = self.posDerErstenWiederholung(knoten: self.model.zyklus)
        
        for i in posDerErstenWiederholung..<self.model.zyklus.count{
            let knoten: Knoten = self.model.zyklus[i]
            res.append(String(knoten.vorgangsnummer))
            if i != self.model.zyklus.count - 1 {
                res.append("->")
            }
        }
        res.append("\n")
        return res
    }
    
    /**
     * Gibt die Position des ersten Elementes in einer ArrayList von Knoten zurück,
     * die doppelt vorkommt
     *
     * @param knoten
     *            ArrayList<Knoten>, die überprüft werden soll
     * @return Position des ersten Elementes in einer ArrayList von Knoten, die
     *         doppelt vorkommt
     */
    private func posDerErstenWiederholung(knoten: [Knoten])-> Int {
        var ks: [Knoten] = []
        
        for i in 0..<knoten.count{
            let k: Knoten = knoten[i]
            if ks.contains(k) {
                guard let i = ks.index(of: k) else{
                    return 0
                }
                return i
            }
            ks.append(k)
        }
        return 0
    }
    
}
