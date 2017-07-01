//
//  PokemonDetailVC.swift
//  Pokedex3
//
//  Created by AADITYA NARVEKAR on 6/9/17.
//  Copyright © 2017 Aaditya Narvekar. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class PokemonDetailVC: UIViewController {
    
    @IBOutlet weak var activityIndicator: NVActivityIndicatorView!
    private var descriptionDetailsUpdated: Bool! = false
    private var detailsUpdated: Bool! = false
    var swipeGesture: UISwipeGestureRecognizer!
    
    private var _selectedPokemon: Pokemon!
    var selectedPokemon: Pokemon {
        get {
            return _selectedPokemon == nil ? Pokemon(name: "-", id: 0) : _selectedPokemon
        }
        
        set {
            _selectedPokemon = newValue
        }
    }
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var mainImg: UIImageView!
    @IBOutlet weak var descriptionTxt: UITextView!
    @IBOutlet weak var typeLbl: UILabel!
    @IBOutlet weak var defenseLbl: UILabel!
    @IBOutlet weak var heightLbl: UILabel!
    @IBOutlet weak var pokedexIdLbl: UILabel!
    @IBOutlet weak var weightLbl: UILabel!
    @IBOutlet weak var baseAttackLbl: UILabel!
    @IBOutlet weak var nextEvolutionLbl: UILabel!
    @IBOutlet weak var currentEvolutionImg: UIImageView!
    @IBOutlet weak var nextEvolutionImg: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.startAnimating()
        updateBasicPokemonInfo()
        if selectedPokemon.pokemonDownloadComplete {
            updateDetailsForPokemon()
            updateDescriptionDetailsForPokemon()
        } else {
            selectedPokemon.downloadPokemonDetails() { completedDescriptionDownload in
                if completedDescriptionDownload {
                    DispatchQueue.main.async {
                        self.updateDescriptionDetailsForPokemon()
                    }
                } else {
                    DispatchQueue.main.async {
                        self.updateDetailsForPokemon()
                    }
                }
                
            }
        }
        
        // Initialize Swipe Gesture
        swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(PokemonDetailVC.handleSwipe))
        swipeGesture.direction = .down
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backBtnTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func updateDetailsForPokemon() {
        descriptionTxt.scrollRangeToVisible(NSMakeRange(0, 0))
        heightLbl.text = selectedPokemon.height
        weightLbl.text = selectedPokemon.weight
        defenseLbl.text = selectedPokemon.defense
        baseAttackLbl.text = selectedPokemon.baseAttack
        typeLbl.text = selectedPokemon.type
        nextEvolutionLbl.text = "Next Evolution: \(selectedPokemon.nextEvolutionPokemon.name)"
        if selectedPokemon.nextEvolutionPokemon.name == "-" {
            nextEvolutionImg.isHidden = true
        } else {
            nextEvolutionImg.image = UIImage(named: "\(selectedPokemon.nextEvolutionPokemon.pokedexId)")
        }
        detailsUpdated = true
        if descriptionDetailsUpdated {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                self.activityIndicator.stopAnimating()
                self.view.addGestureRecognizer(self.swipeGesture)
            })
        }
        
    }
    
    func updateDescriptionDetailsForPokemon() {
        descriptionTxt.text = selectedPokemon.description
        descriptionDetailsUpdated = true
        if detailsUpdated {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                self.activityIndicator.stopAnimating()
                self.view.addGestureRecognizer(self.swipeGesture)
            })
        }
    }
    
    func updateBasicPokemonInfo() {
        nameLbl.text = selectedPokemon.name
        pokedexIdLbl.text = "\(selectedPokemon.pokedexId)"
        mainImg.image = UIImage(named: "\(selectedPokemon.pokedexId)")
        currentEvolutionImg.image = UIImage(named: "\(selectedPokemon.pokedexId)")
    }
    
    
    @IBAction func shareBtnTapped(_ sender: Any) {
        print("Share Pokemon Details")
        let pokeImage = UIImage(named: "\(selectedPokemon.pokedexId)")
        let pokeName = selectedPokemon.name
        let pokeDescription = selectedPokemon.description
        
        let activityViewController = UIActivityViewController(activityItems: [pokeName, pokeDescription, pokeImage as Any], applicationActivities: nil)
        present(activityViewController, animated: true, completion: nil)
        
    }
    
    func handleSwipe() {
        print("Swipe Gesture Recongnized")
        dismiss(animated: true, completion: nil)
    }
}
