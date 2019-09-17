//
//  ViewController.swift
//  Alex Pokemon App 1
//
//  Created by Austin Zheng on 5/18/19.
//  Copyright © 2019 Austin Zheng. All rights reserved.
//

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
    let groupDetails: [GroupDetails]

    struct GroupDetails {
        let moveLearnMethodName: String
        let moveLearnmethodUrl: URL
        let levelLearnedAt: Int
        let versionGroupName: String
        let versionGroupUrl: URL
    }
}

class ViewController: UIViewController, URLSessionDelegate, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var abilitiesTableView: UITableView!
    @IBOutlet weak var movesTableView: UITableView!
    @IBOutlet weak var pokemonNumberValue: UITextField!
    @IBOutlet weak var pokemonName: UILabel!
    @IBOutlet weak var pokemonPicker: UIPickerView!
    var session: URLSession!
    var currentPokemonName: String = ""
    var whichPokemon: String = ""
    var pokemonAbilities: [Ability] = []
    var pokemonMoves: [Move] = []
    var pokemonNames: [String] = ["bulbasaur","ivysaur","venusaur","charmander","charmeleon","charizard","squirtle","wartortle","blastoise","caterpie","metapod","butterfree","weedle","kakuna","beedrill","pidgey","pidgeotto","pidgeot","rattata","raticate","spearow","fearow","ekans","arbok","pikachu","raichu","sandshrew","sandslash","nidoranf","nidorina","nidoqueen","nidoranm","nidorino","nidoking","clefairy","clefable","vulpix","ninetales","jigglypuff","wigglytuff","zubat","golbat","oddish","gloom","vileplume","paras","parasect","venonat","venomoth","diglett","dugtrio","meowth","persian","psyduck","golduck","mankey","primeape","growlithe","arcanine","poliwag","poliwhirl","poliwrath","abra","kadabra","alakazam","machop","machoke","machamp","bellsprout","weepinbell","victreebel","tentacool","tentacruel","geodude","graveler","golem","ponyta","rapidash","slowpoke","slowbro","magnemite","magneton","farfetchd","doduo","dodrio","seel","dewgong","grimer","muk","shellder","cloyster","gastly","haunter","gengar","onix","drowzee","hypno","krabby","kingler","voltorb","electrode","exeggcute","exeggutor","cubone","marowak","hitmonlee","hitmonchan","lickitung","koffing","weezing","rhyhorn","rhydon","chansey","tangela","kangaskhan","horsea","seadra","goldeen","seaking","staryu","starmie","scyther","jynx","electabuzz","magmar","pinsir","tauros","magikarp","gyarados","lapras","ditto","eevee","vaporeon","jolteon","flareon","porygon","omanyte","omastar","kabuto","kabutops","aerodactyl","snorlax","articuno","zapdos","moltres","dratini","dragonair","dragonite","mewtwo","mew"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        session = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
        // Do any additional setup after loading the view.
        abilitiesTableView.delegate = self
        abilitiesTableView.dataSource = self
        movesTableView.dataSource = self
        movesTableView.delegate = self
        pokemonPicker.dataSource = self
        pokemonPicker.delegate = self
    }
    
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
    
        if tableView == abilitiesTableView {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "AbilitiesCell") as! AbilityCell
            let cellTask = pokemonAbilities[indexPath.row]
            cell.setAbilityCell(name: cellTask.name, url: "\(cellTask.url)", hidden: "\(cellTask.hidden)", slot: "\(cellTask.slot)")
            
            return cell
        } else if tableView == movesTableView {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "MovesCell") as! MoveCell
            let cellTask = pokemonMoves[indexPath.row]
         
            cell.tableView.delegate = cell
            cell.tableView.dataSource = cell
            
            cell.groupDetails = cellTask.groupDetails
            cell.setMoveCell(Name: cellTask.name, url: "\(cellTask.url)")
            
            return cell
        } else {
            return UITableViewCell()
        }
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pokemonNames.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pokemonNames[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        whichPokemon = pokemonNames[row]
    }
    
    @IBAction func buttonOnePressed(_ sender: Any) {
        loadPokemon(whichPokemon)
    }
    
    func loadPokemon(_ id: String) {
        let requestURL = URL(string: "https://pokeapi.co/api/v2/pokemon/\(id)/")!
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
                
                let abilities = jsonData["abilities"]! as! [Any]
                let parsedAbilities = self.parseAbilityArray(abilities)
                //print("Abilities are: \(parsedAbilities)")
                self.pokemonAbilities = self.parseAbilityArray(abilities)
            
                let moves = jsonData["moves"]! as! [Any]
                let parsedMoves = self.parseMoveArray(moves)
                //print("Moves are: \(parsedMoves)")
                self.pokemonMoves = self.parseMoveArray(moves)
                
                DispatchQueue.main.async {
                    self.abilitiesTableView.reloadData()
                    self.movesTableView.reloadData()
                    self.pokemonName.text = self.currentPokemonName
                }
                
            } catch {
                print("WE couldn't get the JSON data!")
                return
            }
        }
        
        task.resume()
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
    
    func parseMoveArray(_ array: [Any]) -> [Move] {
        var buffer: [Move] = []
        var groupBuffer: [Move.GroupDetails] = []
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
                
                groupBuffer.append(Move.GroupDetails(moveLearnMethodName: learnMethodName, moveLearnmethodUrl: learnMethodUrl, levelLearnedAt: levelLearnedAt, versionGroupName: versionGroupName, versionGroupUrl: versionGroupUrl))
            }
            buffer.append(Move(name: name, url: url, groupDetails: groupBuffer ))
            groupBuffer = []
        }
        return buffer
    }
    
}




