//
//  AusgabeInDatei.swift
//  Große Prog 2018
//
//  Created by Leo Haufs on 14.06.18.
//  Copyright © 2018 Leo Haufs. All rights reserved.
//

import Foundation
public class AusgabeInDatei: Ausgabe{
    public func schreibeModelInDatei(filename: String){
        
        do {
            // get the documents folder url
            if let documentDirectory = FileManager.default.urls(for: .desktopDirectory, in: .userDomainMask).first {
                // create the destination url for the text file to be saved
                let fileURL = documentDirectory.appendingPathComponent(filename)
                
                let text = super.getAusgabeString()
                
                // writing to disk
                try text.write(to: fileURL, atomically: false, encoding: .utf8)
                print("Datei erfolgreich auf dem Desktop als " + filename + " gespeichert.")
            }
        } catch {
            print("error:", error)
        }
    }
}
