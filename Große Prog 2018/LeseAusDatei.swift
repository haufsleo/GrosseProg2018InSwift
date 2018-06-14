//
//  LeseAusDatei.swift
//  Große Prog 2018
//
//  Created by Leo Haufs on 14.06.18.
//  Copyright © 2018 Leo Haufs. All rights reserved.
//

import Foundation

public class LeseAusDatei{
    public func getModelAusDatei(path: String)->Model{
        var knoten: [Knoten] = []
        var kommentar: String = "Fehler beim Einlesen"
        var vorgangsnummern : [Int] = []
        
        
        do {
            let data = try String(contentsOfFile:path, encoding: String.Encoding.utf8)
            
            let myStrings = data.components(separatedBy: "\n")
            
            for line in myStrings{
                if line.starts(with: "//"){
                    if line.starts(with: "//+ "){
                        if line.count > 4{
                            kommentar = String(line.dropLast(line.count-4))
                        }
                        continue
                    }
                    continue
                }
                let aktZeileOhneLeer: String = line.replacingOccurrences(of: " ", with: "")
                let zeileSplit = aktZeileOhneLeer.split(separator: ";")
                if zeileSplit.count != 5{
                    print("Ungenügende Eingabe. Es müssen je Zeile genau 5 Argumente getrennt mit einem Semikolon übergeben werden:" + line)
                    return Model()
                }
                guard let nr: Int = Int(zeileSplit[0]) else{
                    print("Fehler")
                    return Model()
                }
                
                vorgangsnummern.append(nr)
                
                let beschr = String(zeileSplit[1])
                guard let dauer = Int(zeileSplit[2]) else{
                    print("Fehler")
                    return Model()
                }
                var vorgaengerNummern: [Int] = []
                if zeileSplit[3] != "-" {
                    let vorgaengerNummernArr = zeileSplit[3].split(separator: ",")
                    for string in vorgaengerNummernArr{
                        if let number: Int = Int(string){
                            vorgaengerNummern.append(number)
                        }else{
                            // error
                        }
                    }
                }
                
                var nachfolgerNummern: [Int] = []
                if !(zeileSplit[4] == "-"){
                    let nachfolgerNummernArr = zeileSplit[4].split(separator: ",")
                    for string in nachfolgerNummernArr{
                        if let number: Int = Int(string){
                            nachfolgerNummern.append(number)
                        }else{
                            // error
                        }
                    }
                }
                // Prüfe, ob vorgangsnummern nicht doppelt vorliegen
                if !(vorgangsnummernNichtDoppelt(vorgangsnummern: vorgangsnummern)){
                    print("Ungenügende Eingabe: Es kommt mindestens eine Vorgangsnummer mehrfach vor.")
                    return Model()
                }
                let k : Knoten = Knoten(vorgangsnummer: nr, vorgangsbezeichnung: beschr, dauer: dauer, vorgaengerNummern: vorgaengerNummern, nachfolgerNummern: nachfolgerNummern)
                knoten.append(k)
            }
        } catch let err as NSError {
            //do sth with Error
            //print("file not found")
            print(err)
            print("Ungenügende Eingabe: Datei konnte nicht geöffnet werden")
        }
        
        return Model(knoten: knoten, name: kommentar)
    
    }
    
    
    /**
     * Prüft, ob die Vorgangsnummern nicht doppelt vorliegen
     *
     * @param vorgangsnummern
     *            die zu Prüfen sind
     * @return true, falls die Vorgangsnummern nicht doppelt vorliegen
     */
    private func vorgangsnummernNichtDoppelt(vorgangsnummern: [Int])-> Bool{
        var vorgangsnummernCopy = vorgangsnummern
        for vorgangsnummer in vorgangsnummernCopy {
            vorgangsnummernCopy = Array(vorgangsnummernCopy.dropFirst())
            if(vorgangsnummernCopy.contains(vorgangsnummer)){
                return false
            }
        }
        return true
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
