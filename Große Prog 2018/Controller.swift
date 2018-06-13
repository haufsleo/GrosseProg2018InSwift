//
//  Controller.swift
//  Große Prog 2018
//
//  Created by Leo Haufs on 13.06.18.
//  Copyright © 2018 Leo Haufs. All rights reserved.
//

import Foundation


class Controller: NSObject {
    var model: Model
    var validationsListe: [Knoten] = []
    
    init(model: Model) {
        self.model = model
    }
    
    /**
     * Hauptberechnungsmethode des Controllers.
     *
     * Falls noch nicht initialisiert wurde, wird auf Zyklen und Zusammenhängigkeit
     * geprüft . Falls der Netzplan Zyklen enthällt, wird im Model in zyklus ein
     * zyclus gespeichert. Wenn der Netzplan nicht nicht zusammenhängend ist, wird
     * im Model isZusammenhaengend auf false gesetzt. Sonst auf true.
     *
     * Anschließend wird das Model initialisiert, also die kenngrößen berechnet und
     * anschließend der kritische Pfad, falls er existiert, berechnet
     */
    public func calculate(){
        // Prüfe, ob der im Model gekapselte Netzplan keine Zyklen enthällt
        if !hatKeineZyklen(){
            print(self.model.name + ": Zyklen enthalten")
            return
        }
        
        // Prüfe, ob der im Model gekapselte Netzplan zusammenhängend ist
        if !self.isZusammenhaengend(){
            print(self.model.name + ": Fehler (nicht zusammenhängend")
            return
        }else{
            model.isZusammenhaengend = true
        }
        
        // Prüft, ob alle Referenzen in model.knoten korrekt sind, also ob jeder
        // Nachfolger auch in dessen Vorgaengern enthalten ist bzw. umgekehrt.
        if !hatGueltigeReferenzen(){
            print(model.name + "Referenzen der Eingabe sind ungenügend. nicht jeder Nachfolger auch in dessen Vorgaengern enthalten bzw. umgekehrt ist.")
            model.gueltigeReferenzen = false
        }else{
            model.gueltigeReferenzen = false
        }
        
        self.initModel()
    }
    
    /**
     * Initialisiert das Model. Dabei werden drei Phasen durchlaufen:
     *
     * 1. Phase: Vorwärtsrechnung Bei gegebenem Anfangstermin werden aufgrund der
     * angegebenen Dauer eines Vorganges die frühestmöglichen Anfangs- und
     * Endzeiten eingetragen. Weiterhin lässt sich die Gesamtdauer eines Projekts
     * bestimmen.
     *
     * 2. Phase: Rückwärtsrechnung: Bei der Rückwärtsrechnung wird ermittelt,
     * wann die einzelnen Vorgänge spätestens begonnen und fertiggestellt sein
     * müssen, damit die Gesamtprojektzeit nicht gefährdet ist.
     *
     *
     * 3. Phase: Ermittlung der Zeitreserven und des kritischen Pfades: In dieser
     * Phase wird ermittelt, welche Zeitreserven existieren und welche Vorgänge
     * besonders problematisch sind (kritischer Vorgang), weil es bei diesen keine
     * Zeitreserven gibt. Dazu wird für alle Knoten der Gesamtpuffer (GP)
     * berechnet, sowie der freie Puffer (FP).
     */
    private func initModel(){
        // Prüfe, ob das Model bereits initialisiert wurde
        if model.isInitialized(){
            return
        }
        
        /*
         * 1. Phase: Vorwärtsrechnung
         *
         * Setze FAZ der Startknoten
         */
        for startK in model.startknoten {
            startK.faz = 0
        }
        
        // Setze FEZ aller Knoten als FEZ = FAZ + Dauer
        for startK in model.startknoten {
            self.setFezAndFaz(aktKnoten: startK)
        }
        
        /*
         * 2. Phase: Rückwärtsrechnung
         *
         * Bei der Rückwärtsrechnung wird ermittelt, wann die einzelnen Vorgänge
         * spätestens begonnen und fertiggestellt sein müssen, damit die
         * Gesamtprojektzeit nicht gefährdet ist.
         *
         * Für den letzten Vorgang ist der früheste Endzeitpunkt (FEZ) auch der
         * späteste Endzeitpunkt (SEZ), also SEZ = FEZ.
         */
        for endK in model.endknoten {
            endK.sez = endK.fez
        }
        
        /*
         * Für den spätesten Anfangszeitpunkt gilt: SAZ = SEZ – Dauer.
         */
        for endK in model.endknoten {
            self.setSazAndSez(aktKnoten: endK)
        }
        
        // 3. Phase: Ermittlung der Zeitreserven
        for startK in model.startknoten {
            /*
             * Berechnung des Gesamtpuffers für jeden Knoten
             */
            self.setGp(aktKnoten: startK)
            
            /*
             * Berechnung des freien Puffers
             */
            self.setFp(aktKnoten: startK)
        }
        
        /*
         * Bestimmung der kritischen Vorgänges
         */
        self.setKritischePfade()
        
        model.initialize()
    }
    
    
    
    /**
     * Prüft, ob der im Model gekapselte Netzplan keine Zyklen enthällt
     *
     * @return true, falls der Netzplan im Model keine Zyklen enthällt, sonst true
     */
    private func hatKeineZyklen()->Bool{
        var check : [Bool] = []
        
        /*
         * Rufe für ausgehend von allen Startknoten die Helpermethode
         * hatKeineZyklenHelper auf. Falls ein Ergebnis negativ ausfällt wird false
         * zurückgegeben
         */
        for s in self.model.startknoten{
            self.validationsListe = []
            check.append(self.hatKeineZyklenHelper(aktKnoten: s))
            if check.contains(false){
                model.zyklus = self.validationsListe
                return false
            }
        }
        
        return true
    }
    
    /**
     * Hilfsfunktion zur Überprüfung, ob keine Zyklen existieren
     *
     * @param aktKnoten
     * @return
     */
    private func hatKeineZyklenHelper(aktKnoten: Knoten)->Bool{
        // Abbruchbedingung
        if(self.validationsListe.contains(aktKnoten)){
            // Falls aktueller Knoten bereits in ValidationListe enthalten ist, füge
            // aktuellen Knoten zu ValidationListe zu und gebe false zurück
            self.validationsListe.append(aktKnoten)
            return false
        }
        // Füge aktuellen Knoten zur Validationliste hinzu
        self.validationsListe.append(aktKnoten)
        // Für jeden nachfolger des aktuellen Knotens führe rekursiv
        // hatKeineZyklenHelper aus und gebe den Wert zurück.
        for nachfolger in aktKnoten.nachfolger {
            return self.hatKeineZyklenHelper(aktKnoten:nachfolger)
        }
        return true
    }
    
    /**
     * Prüft, ob der Netzplan zusammenhängend ist.
     *
     * @return true, falls der Netzplan zusammenhängend ist, sonst false
     */
    private func isZusammenhaengend()->Bool{
        self.validationsListe = []
        
        for startK in self.model.startknoten {
            isZusammenhaengendHelper(aktKnoten: startK)
        }
        
        if self.validationsListe.count == self.model.knoten.count{
            return true
        }else{
            return false
        }
    }
    
    private func isZusammenhaengendHelper(aktKnoten: Knoten){
        // Falls die ValidationListe den aktuellen Knoten noch nicht enthällt, füge
        // diesen ein.
        if !self.validationsListe.contains(aktKnoten){
            self.validationsListe.append(aktKnoten)
        }
        // rufe isZusammenhaengendHelper für jeden Nachfolger des aktuellen Knotens auf
        for nachfolger in aktKnoten.nachfolger {
            self.isZusammenhaengendHelper(aktKnoten: nachfolger)
        }
    }
    
    /**
     * Setzt FEZ und FAZ ausgehend von einem aktuellen Knoten für diesen und alle
     * Nachfolger dieses Knotens
     *
     * @param aktKnoten
     */
    private func setFezAndFaz(aktKnoten: Knoten){
        // Für den FEZ gilt: FEZ = FAZ + Dauer
        aktKnoten.fez = aktKnoten.faz + aktKnoten.dauer
        
        // Wenn Endknoten wird FAZ auf den maximalen FEZ der Vorgängerknoten gesetzt
        if(aktKnoten.nachfolger.count == 0){
            aktKnoten.faz = getMaxFezOfVorgaenger(aktKnoten: aktKnoten)
        }
        
        for nachfolger in aktKnoten.nachfolger {
            nachfolger.faz = getMaxFezOfVorgaenger(aktKnoten: aktKnoten)
            setFezAndFaz(aktKnoten: nachfolger)
        }
    }
    
    /**
     * Berechnet den Maximalen FEZ aller Vorgänger eines Knotens
     *
     * @param aktKnoten
     *            aktuell betrachteter Knoten
     * @return maximalen FEZ aller Vorgänger des Knoten
     */
    private func getMaxFezOfVorgaenger(aktKnoten : Knoten) -> Int{
        var maxValue: Int = Int.min
        for vorgaenger in aktKnoten.vorgaenger {
            if vorgaenger.fez > maxValue{
                maxValue = vorgaenger.fez
            }
        }
        return maxValue
    }
    
    /**
     * Berechnet SAZ für den aktuell betrachteten Knoten sowie alle Vorgängerknoten,
     * ausgehend vom aktuell betrachteten Knoten
     *
     * @param aktKnoten
     *            aktuell betrachteter Knoten
     */
    private func setSazAndSez(aktKnoten: Knoten){
        // Wenn aktueller Knoten ein Anfangsknoten ist, so wird Sez als minimaler SAZ
        // der Nachfolger gesetzt
        if aktKnoten.vorgaenger.count == 0{
            aktKnoten.sez = self.getMinSazOfNachfolger(aktKnoten: aktKnoten)
        }
        
        // SAZ = SEZ – Dauer.
        aktKnoten.saz = aktKnoten.sez - aktKnoten.dauer
        
        for vorgaenger in aktKnoten.vorgaenger {
            /*
             * Der SAZ eines Vorgangs wird SEZ aller unmittelbarer Vorgänger
             *
             * Haben mehrere Vorgänge einen gemeinsamen Vorgänger, so ist dessen SEZ der
             * früheste (kleinste) SAZ aller Nachfolger.
             */
            vorgaenger.sez = self.getMinSazOfNachfolger(aktKnoten: vorgaenger)
            setSazAndSez(aktKnoten: vorgaenger)
        }
    }
    
    /**
     * Berechnet den minimalen SAZ der Nachfolgenden Knoten eines betrachteten
     * Knoten
     *
     * @param aktKnoten
     *            aktuell betrachteter Knoten
     * @return minimaler SAZ der Nachfolgenden Knoten eines betrachteten Knoten
     */
    private func getMinSazOfNachfolger(aktKnoten: Knoten) -> Int{
        var minValue = Int.max
        for nachfolger in aktKnoten.nachfolger {
            if nachfolger.saz < minValue{
                minValue = nachfolger.saz
            }
        }
        return minValue
    }
    
    /**
     * Berechnet den GP aller Knoten ausgehend vom aktuell betrachteten Knoten
     *
     * @param aktKnoten
     *            aktuell betrachteter Knoten
     */
    private func setGp(aktKnoten: Knoten){
        /*
         * Berechnung des Gesamtpuffers für jeden Knoten: GP = SAZ – FAZ = SEZ – FEZ
         */
        aktKnoten.gp = aktKnoten.saz - aktKnoten.faz
        
        for nachfolger in aktKnoten.nachfolger {
            setGp(aktKnoten: nachfolger)
        }
    }
    
    /**
     * Berechnet den FP aller Knoten ausgehend vom aktuell betrachteten Knoten
     *
     * @param aktKnoten
     *            aktuell betrachteter Knoten
     */
    private func setFp(aktKnoten: Knoten){
        /*
         * Für die Berechnung des freien Puffers gilt: FP= (kleinster FAZ der
         * nachfolgenden Knoten) - FEZ Ist der aktuelle Knoten der Endknoten, so ist der
         * Freie Puffer 0, da FAZ==FEZ
         */
        aktKnoten.fp = self.getMinFazOfNachfolger(aktKnoten: aktKnoten) - aktKnoten.fez
        for nachfolger in aktKnoten.nachfolger {
            setFp(aktKnoten: nachfolger)
        }
    }
    
    /**
     * Berechnet den kleinsten FAZ aller Nachfolger eines betrachteten Knoten
     *
     * @param aktKnoten
     *            aktuell betrachteter Knoten
     * @return kleinste FAZ aller Nachfolger eines betrachteten Knoten
     */
    private func getMinFazOfNachfolger(aktKnoten: Knoten)->Int{
        var minValue = Int.max
        if aktKnoten.nachfolger.count == 0{
            return aktKnoten.fez
        }
        for nachfolger in aktKnoten.nachfolger {
            if(nachfolger.faz < minValue){
                minValue = nachfolger.faz
            }
        }
        
        return minValue
    }
    
    /**
     * Berechnet die Kritischen Pfade eines Netzplans und setzt sie im Model als
     * kritischePfade
     */
    private func setKritischePfade(){
        self.model.kritischePfade = []
        /*
         * Bestimmung der kritischen Vorgänge ausgehend von jedem Startknoten
         */
        for startK in model.startknoten {
            var pfad:[Knoten] = []
            setKritischePfadeHelper(pfad: &pfad, aktKnoten: startK)
        }
    }
    
    /**
     * Rekursive Hilfsmethode zur Berechnung der Kritischen Pfade nach dem Prinzip
     * des Backtracking. Fügt bei erreichen des Endknotens den berechneten Pfad zum
     * kritischePfade-Array im Model hinzu
     *
     * @param pfad
     *            aktuell berechneter Pfad
     * @param aktKnoten
     *            aktuell betrachteter Knoten
     */
    private func setKritischePfadeHelper(pfad: inout [Knoten], aktKnoten: Knoten){
        /*
         * Abbruchkriterium:Endknoten ist erreicht
         */
        if aktKnoten.nachfolger.count == 0{
            // Füge aktuellen Knoten in pfad ein
            pfad.append(aktKnoten)
            // Füge errechneten Kritischen Pfad zu den im Model gekapselten Kritischen
            // Pfaden hinzu
            model.kritischePfade.append(pfad)
            return
        }
        
        /*
         * Bestimmung der kritischen Vorgänge, d.h. GP = 0 und FP = 0
         */
        if aktKnoten.gp == 0 && aktKnoten.fp == 0{
            // füge aktuellen Knoten zum kritischen Pfad hinzu
            pfad.append(aktKnoten)
            // Führe für alle Nachfolger rekursiv die Methode setKritischePfadehelper aus
            // und durchlaufe so nach Backtraking den virtuellen Baum
            for nachfolger in aktKnoten.nachfolger{
                self.setKritischePfadeHelper(pfad: &pfad, aktKnoten: nachfolger)
            }
        }
    }
    
    /**
     * Prüft, ob alle Referenzen in model.knoten korrekt sind, also ob jeder
     * Nachfolger auch in dessen Vorgaengern enthalten ist bzw. umgekehrt.
     *
     * Darf erst nach der Prüfung der Zyklen aufgerufen werden!
     *
     * @return true, falls alle Referenzen korrekt sind, sonst false.
     */
    private func hatGueltigeReferenzen()->Bool{
        for k1 in self.model.knoten {
            for nachfolger in k1.nachfolger{
                if !nachfolger.vorgaenger.contains(k1){
                    return false
                }
            }
        }
        
        for k1 in self.model.knoten {
            for vorgaenger in k1.vorgaenger{
                if !vorgaenger.nachfolger.contains(k1){
                    return false
                }
            }
        }
        
        return true
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
