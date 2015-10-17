//
//  ViewController.swift
//  WaveAttack
//
//  Created by yat on 18/10/2015.
//
//

import UIKit

class MissionsController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        GameViewController.currentMissionId = indexPath.row + 1
        
        print("selected \(indexPath.row)")
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        var game = storyBoard.instantiateViewControllerWithIdentifier("Game")
        self.presentViewController(game, animated: false, completion: nil)
        

    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var info = PlayerInfo.playerInfo
        var numDisplay = info!.passMission!.integerValue + 1
        if (numDisplay > Mission.missionList.count){
            numDisplay = Mission.missionList.count
        }
        return numDisplay
        
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("LabelCell", forIndexPath: indexPath) as! UITableViewCell
        cell.textLabel!.text = Mission.missionList[indexPath.row+1]!
        
        return cell
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
