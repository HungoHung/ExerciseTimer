//
//  ViewController.swift
//  ExerciseTimer
//
//  Created by Hungo on 15/02/2017.
//  Copyright © 2017 Hungo. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource{
    
    var player: AVAudioPlayer = AVAudioPlayer()
    var timer = Timer()
    var pickerInfo = [String]()
    var workoutTime: Int?
    var isStarted: Bool = false
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var startBtnLbl: UIButton!
    
    @IBOutlet weak var timerLbl: UILabel!
    
    @IBAction func resetBtnPressed(_ sender: Any) {
        resetTimer()
    }
    @IBAction func startBtnPressed(_ sender: Any) {
        startStopTimer()
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        pickerView.delegate = self
        pickerView.dataSource = self
        
        pickerInfo = ["Warm up", "Low intensity workout", "High intensity workout", "Cool down"]
    
        startBtnLbl.isEnabled = false
        startBtnLbl.alpha = 0.3
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func workoutSelection(selection: Int){
        
        switch selection{
        case 0:
            print("你選擇了熱身")
            workoutTime = 300
            
        case 1:
            print("你選擇了低強度訓練")
            workoutTime = 600
        case 2:
            print("你選擇了高強度訓練")
            workoutTime = 900
        case 3:
            print("你選擇了休息")
            workoutTime = 5
        default:
            print("not able to go here")
        }
        timerLbl.text = workoutMinuteSecondConvert(interval: workoutTime!)
        startBtnLbl.isEnabled = true
        startBtnLbl.alpha = 1
    }
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerInfo.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerInfo[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        workoutSelection(selection: row)
        
    }
    
    func workoutMinuteSecondConvert(interval: Int) -> String{
        let minutes = interval / 60
        let seconds = interval % 60
        
        return String(format: "%02d:%02d", minutes,seconds)
    }
    
    func startStopTimer(){
        if !isStarted{
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ViewController.decrementWorkouttime), userInfo: nil, repeats: true)
            timer.fire()
            isStarted = true
            startBtnLbl.setTitle("Pause", for: .normal)
        }else{
            timer.invalidate()
            isStarted = false
            startBtnLbl.setTitle("Start", for: .normal)
        }
    }
    
    func resetTimer(){
        isStarted = false
        workoutTime = 0
        timerLbl.text = workoutMinuteSecondConvert(interval: workoutTime!)
        startBtnLbl.isEnabled = false
        startBtnLbl.alpha = 0.3
        
    }

    func decrementWorkouttime(){
        if workoutTime == 0{
            resetTimer()
            timerLbl.textColor = UIColor.darkGray
            alarm()
        }else{
            self.workoutTime! -= 1
            timerLbl.text = workoutMinuteSecondConvert(interval: workoutTime!)

        }
    }
    
    func alarm(){
        let filePath = Bundle.main.path(forResource: "timer_or_desk_bell", ofType: "mp3")
        do{
            try player = AVAudioPlayer(contentsOf: URL(fileURLWithPath: filePath!))
            player.play()
        }catch{
            print("play error")
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        let labelForRow = UILabel(frame: CGRect(x: 0, y: 0, width: pickerView.frame.size.width, height: 45.0))
        labelForRow.text = pickerInfo[row]
        labelForRow.textAlignment = .center
        labelForRow.font = UIFont(name: "Helvetica Neue", size: 22)
        labelForRow.textColor = UIColor.white
        
        return labelForRow
    }
}

