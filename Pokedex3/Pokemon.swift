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
    
    
    
}
