//
//  Pokemon.swift
//  Pokedex3
//
//  Created by AADITYA NARVEKAR on 6/3/17.
//  Copyright © 2017 Aaditya Narvekar. All rights reserved.
//

import Foundation

class Pokemon {
    fileprivate var _name: String!
    var name: String {
        return _name
    }
    
    fileprivate var _pokedexId: Int!
    var pokedexId: Int {
        return _pokedexId
    }
    
    init(name: String, id: Int) {
        _name = name
        _pokedexId = id
    }
    
    private var _description: String! = "-"
    var description: String {
        get {
            return _description == nil ? "" : _description
        }
        
        set {
            if newValue.characters.count > 0 {
                _description = newValue
            }
        }
    }
    
    private var _type: String!
    var type: String {
        get {
            return _type == nil ? "" : _type
        }
        
        set {
            if newValue.characters.count > 0 {
                _type = newValue
            }
        }
    }
    
    private var _defense: Int! = -1
    var defenseAsInt: Int {
        get {
            return _defense
        }
        
        set {
            _defense = newValue
        }
    }
    
    var defense: String {
        get {
            return _defense == -1 ? "-" : "\(_defense!)"
        }
        
        set {
            _defense = Int(newValue)
        }
    }
    
    
    private var _height: Int! = -1
    var heightAsInt: Int {
        get {
            return _height
        }
        
        set {
            _height = newValue
        }
    }
    
    var height: String {
        get {
            return _height == -1 ? "-" : "\(_height!)"
        }
        
        set {
            _height = Int(newValue)
        }
    }
    
    private var _weight: Int! = -1
    var weightAsInt: Int {
        get {
            return _weight
        }
        
        set {
            _weight = newValue
        }
    }
    var weight: String {
        get {
            return _weight == -1 ? "-" : "\(_weight!)"
        }
        
        set {
            _weight = Int(newValue)
        }
    }
    
    private var _baseAttack: Int! = -1
    var baseAttackAsInt: Int {
        get {
            return _baseAttack
        }
        
        set {
            _baseAttack = newValue
        }
    }
    var baseAttack: String {
        get {
            return _baseAttack == -1 ? "-" : "\(_baseAttack!)"
        }
        
        set {
            _baseAttack = Int(newValue)
        }
    }
    
    private var _nextEvolutionPokemon: Pokemon!
    var nextEvolutionPokemon: Pokemon {
        get {
            return _nextEvolutionPokemon == nil ? Pokemon(name: "-", id: 0) : _nextEvolutionPokemon
        }
        
        set {
            _nextEvolutionPokemon = newValue
        }
    }
    
    private var _pokemonDetailsDownloadComplete: Bool! = false
    private var _pokemonDescriptionDownloadComplete: Bool! = false
    var pokemonDownloadComplete: Bool {
        return _pokemonDetailsDownloadComplete && _pokemonDescriptionDownloadComplete
    }
    
    
    func downloadPokemonDetails(completed: @escaping PokemonDetailsDownloadComplete) {
        let pokemonDetailsDownloadUrl = URL(string: "\(BASE_URL)\(POKEMON_END_POINT)\(self.pokedexId)")!
        
        if self._pokemonDetailsDownloadComplete && _pokemonDescriptionDownloadComplete {
            return
        }
        
        URLSession.shared.dataTask(with: pokemonDetailsDownloadUrl) { (data: Data?, response: URLResponse?, err: Error?) in
            guard err == nil && data != nil else {
                print("Error donwloading pokemon degtails. Error: \(err.debugDescription)")
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments)
                if let dict = json as? Dictionary<String, Any> {
                    if let height = dict["height"] as? String {
                        self.height = height
                    }
                    
                    if let weight = dict["weight"] as? String {
                        self.weight = weight
                    }
                    
                    if let defense = dict["defense"] as? Int {
                        self.defenseAsInt = defense
                    }
                    
                    if let attack = dict["attack"] as? Int {
                        self.baseAttackAsInt = attack
                    }
                    
                    if let types = dict["types"] as? [Dictionary<String, Any>] {
                        for i in 0 ..< types.count {
                            if let name = types[i]["name"] as? String {
                                if i >= 1 {
                                    self.type.append("/")
                                }
                                self.type.append(name.capitalized)
                            }
                        }
                    }
                    
                    if let evolutions = dict["evolutions"] as? [Dictionary<String, Any>] {
                        if evolutions.count > 0, let to = evolutions[0]["to"] as? String {
                            self.nextEvolutionPokemon = PokemonList.sharedInstace.pokemonWithName(name: to)
                        }
                    }
                    
                    
                    if let descriptions = dict["descriptions"] as? [Dictionary<String, Any>] {
                        if descriptions.count > 0 {
                            if let resource_uri = descriptions.first!["resource_uri"] as? String {
                                let pokeDescriptionUrl = URL(string: "http://pokeapi.co\(resource_uri)")!
                                URLSession.shared.dataTask(with: pokeDescriptionUrl, completionHandler: { (data: Data?, response: URLResponse?, err: Error?) in
                                    if err == nil && data != nil {
                                        do {
                                            let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments)
                                            if let detailsDict = json as? Dictionary<String, Any> {
                                                if let description = detailsDict["description"] as? String {
                                                    self.description = description
                                                    self.description = self.description.replacingOccurrences(of: "POKMON", with: "POKEMON")
                                                    self._pokemonDescriptionDownloadComplete = true
                                                    completed(true)
                                                }
                                            }
                                        } catch let jsonError as NSError {
                                            print("Error creating JSON for details: \(jsonError.debugDescription)")
                                            
                                        }
                                    } else {
                                        print("Error downloading details for pokemon: \(err.debugDescription))")
                                    }
                                }).resume()
                            }
                            
                        }
                    }
                    self._pokemonDetailsDownloadComplete = true
                    completed(false)
                    
                }
            } catch let err as NSError {
                print("Error creating JSON object: \(err.debugDescription)")
            }
            
            }.resume()
        
        
    }
    
    
}
