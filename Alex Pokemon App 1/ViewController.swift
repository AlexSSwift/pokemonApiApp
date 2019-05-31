//
//  ViewController.swift
//  Alex Pokemon App 1
//
//  Created by Austin Zheng on 5/18/19.
//  Copyright © 2019 Austin Zheng. All rights reserved.
//

//fix the parseAbilityData function so the abililtyDictionaryArray doesn't start with a blank dictionary



import UIKit

struct Ability {
    let name: String
    let url: URL
    let hidden: Bool
    let slot: Int
}

struct Move {
    let name: String
    let url: URL
    let levelLearnedAt: Int
    let moveLearnMethodName: String
    let moveLearnmethodUrl: URL
    let versionGroupName: String
    let versionGroupUrl: URL
}

class ViewController: UIViewController, URLSessionDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var abilitiesTableView: UITableView!
    @IBOutlet weak var movesTableView: UITableView!
    @IBOutlet weak var pokemonNumberValue: UITextField!
    @IBOutlet weak var pokemonName: UILabel!
    
    var session: URLSession!
    var currentPokemonName: String = ""
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numberOfRow = 0
        switch tableView {
        case abilitiesTableView:
            numberOfRow = pokemonAbilities.count
        case movesTableView:
            numberOfRow = pokemonMoves.count
            
        default:
            print("error, couldn't get the table view number of rows")
        }
        return numberOfRow
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        abilityDictionary = parseAbilityData(pokemonAbilities: pokemonAbilities)
        moveDictionary = parsedMoveData(pokemonMoves: pokemonMoves)
        
        
        if tableView == abilitiesTableView {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "AbilitiesCell") as! AbilityCell
            let cellTask = abilityDictionary[indexPath.row]
            cell.setAbilityCell(name: cellTask["name"]!, url: cellTask["url"]!, hidden: cellTask["hidden"]!, slot: cellTask["slot"]!)
            
            return cell
        } else if tableView == movesTableView {

            let cell = tableView.dequeueReusableCell(withIdentifier: "MovesCell") as! MoveCell

            cell.setMoveCell(Name: moveDictionary["name"]!, level: moveDictionary["url"]!, url: moveDictionary["level"]!, methodName: moveDictionary["methodName"]!, methodUrl: moveDictionary["methodUrl"]!, groupname: moveDictionary["groupName"]!, groupurl: moveDictionary["groupUrl"]!)

            return cell
        } else {
            return UITableViewCell()
        }
     
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        session = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
        // Do any additional setup after loading the view.
        abilitiesTableView.delegate = self
        abilitiesTableView.dataSource = self
        movesTableView.dataSource = self
        movesTableView.delegate = self
        
    }
    
    func loadPokemon(_ id: Int) {
        let requestURL = URL(string: "https://pokeapi.co/api/v2/pokemon/\(id)")!
        let request = URLRequest(url: requestURL)
        
        let task = session.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                print("Error: \(error!)")
                return
            }
            
            do {
                let jsonData = try JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                
                let name = jsonData["name"]!
                self.currentPokemonName = "\(name)"
                
                //ability data
                let abilities = jsonData["abilities"]! as! [Any]
                let parsedAbilities = self.parseAbilityArray(abilities)
                print("Abilities are: \(parsedAbilities)")
                self.pokemonAbilities = self.parseAbilityArray(abilities)
                
                //moves data
                let moves = jsonData["moves"]! as! [Any]
                let parsedMoves = self.parseMoveArray(moves)
                print("Moves are: \(parsedMoves)")
                self.pokemonMoves = self.parseMoveArray(moves)
                
            } catch {
                print("WE couldn't get the JSON data!")
                return
            }
        }
        
        task.resume()
        abilitiesTableView.reloadData()
        movesTableView.reloadData()
        pokemonName.text = currentPokemonName
    }
    
    func parseAbilityArray(_ array: [Any]) -> [Ability] {
        var buffer: [Ability] = []
        
        for rawObject in array {
            let object = rawObject as! [String: Any]
            let ablilityObject = object["ability"] as! [String: Any]
            let name = ablilityObject["name"] as! String
            let url = URL(string: ablilityObject["url"] as! String)!
            let slot = object["slot"] as! Int
            let hidden = object["is_hidden"] as! Bool
            
            buffer.append(Ability(name: name, url: url, hidden: hidden, slot: slot))
        }
        
        return buffer
    }
    
    var pokemonAbilities: [Ability] = []
    var abilityDictionary: [[String:String]] = [[:]]
    
    func parseAbilityData(pokemonAbilities: [Ability]) -> [[String:String]] {
        var abilitydictionaryArray: [[String:String]] = [[:]]
        var abilityDictionary: [String:String] = [:]
        
        for abilityArray in pokemonAbilities {
            abilityDictionary["name"] = abilityArray.name
            abilityDictionary["url"] = "\(abilityArray.url)"
            abilityDictionary["hidden"] = "\(abilityArray.hidden)"
            abilityDictionary["slot"] = "\(abilityArray.slot)"
             abilitydictionaryArray.append(abilityDictionary)
        }
        
        return abilitydictionaryArray
    }
    
    var pokemonMoves: [Move] = []
    var moveDictionary: [String:String] = [:]
    
    func parseMoveArray(_ array: [Any]) -> [Move] {
        var buffer: [Move] = []
        
        for rawObject in array {
            let object = rawObject as! [String: Any]
            
            //first array, move, 2 objects, "name" and "url"
            let moveObject = object["move"] as! [String: Any]
            let name = moveObject["name"] as! String
            let url = URL(string: moveObject["url"] as! String)!
            
            
            let groupDetailObject = object["version_group_details"] as! [Any]
            
            for rawObject in groupDetailObject {
                let object = rawObject as! [String: Any]
                
                let levelLearnedAt = object["level_learned_at"] as! Int
                
                let learnMethod = object["move_learn_method"] as! [String: Any]
                let learnMethodName = learnMethod["name"] as! String
                let learnMethodUrl = URL(string: learnMethod["url"] as! String)!
                
                let versionGroup = object["version_group"] as! [String: Any]
                let versionGroupName = versionGroup["name"] as! String
                let versionGroupUrl = URL(string: versionGroup["url"] as! String)!
                
                buffer.append(Move(name: name, url: url, levelLearnedAt: levelLearnedAt, moveLearnMethodName: learnMethodName, moveLearnmethodUrl: learnMethodUrl, versionGroupName: versionGroupName, versionGroupUrl: versionGroupUrl))
            }
        }
        return buffer
    }
    
    func parsedMoveData(pokemonMoves: [Move]) -> [String:String] {
        var moveDictionary: [String:String] = [:]
        
        for moveArray in pokemonMoves {
            moveDictionary["name"] = moveArray.name
            moveDictionary["url"] = "\(moveArray.url)"
            moveDictionary["level"] = "\(moveArray.levelLearnedAt)"
            moveDictionary["methodName"] = moveArray.moveLearnMethodName
            moveDictionary["methodUrl"] = "\(moveArray.moveLearnmethodUrl)"
            moveDictionary["groupName"] = moveArray.versionGroupName
            moveDictionary["groupUrl"] = "\(moveArray.versionGroupUrl)"
        }
        return moveDictionary
    }
    
    
    //turns individual characters into int
    func whatNumber(number: Character) -> Int {
        switch number {
        case "0":
            return 0
        case "1":
            return 1
        case "2":
            return 2
        case "3":
            return 3
        case "4":
            return 4
        case "5":
            return 5
        case "6":
            return 6
        case "7":
            return 7
        case "8":
            return 8
        case "9":
            return 9
            
        default:
            fatalError("Can never happen.")
        }
    }
    
    func numberNumber(number: String) -> Int {
        var endNumber = 0
        var tempNumber = 0
        var multiplier = 1
        for digit in number.reversed() {
            tempNumber = whatNumber(number: digit)
            endNumber += tempNumber * multiplier
            multiplier = multiplier * 10
        }
        return endNumber
    }
    
    
    @IBAction func pokemonNumberTextField(_ sender: Any) {
        
    }
    
    @IBAction func buttonOnePressed(_ sender: Any) {
        
        let whichPokemon = numberNumber(number: pokemonNumberValue.text!)
        loadPokemon(whichPokemon)
        
    }
    
    
    
}




