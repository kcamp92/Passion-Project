//
//  LaunchController.swift
//  PassionProjectDraft1
//
//  Created by Krystal Campbell on 11/18/19.
//  Copyright © 2019 Krystal Campbell. All rights reserved.
//

import UIKit
import UserNotifications

class RemindMeController: UIViewController {
    
    
    lazy var alarmButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "alarm"), for: .normal)
        button.tintColor = #colorLiteral(red: 0.3941933513, green: 0.3437153101, blue: 1, alpha: 1)
        button.setTitleColor(.blue, for: .normal)
        button.backgroundColor = .clear
        button.showsTouchWhenHighlighted = true
        button.contentMode = .scaleAspectFill
        button.addTarget(self, action: #selector(alarmButtonPressed), for: .touchUpInside)
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .orange
        setupButton()
        setUpAlarm()
    }
    
    @objc func alarmButtonPressed(_ sender: Any){
        
        let content = UNMutableNotificationContent()
        content.title = "Its time to move your car!"
        content.subtitle = "PlaceHolder"
        content.body = "PlaceHolder II"
        content.sound = UNNotificationSound.default

        
        let imageName = "carLogo"
        guard let imageURL = Bundle.main.url(forResource: imageName, withExtension: "png") else {return}
        
        let attachment = try! UNNotificationAttachment(identifier: imageName, url: imageURL, options: .none)
        
        content.attachments = [attachment]
        
        let trigger  = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
        let request = UNNotificationRequest(identifier: "notification.id.01", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
    
    private func setUpAlarm(){
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert]) {
            (granted, error) in
            if granted {
                print("yes")
            } else {
                print("No")
            }
        }
        
    }
    private func setupButton() {
        view.addSubview(alarmButton)
    alarmButton.translatesAutoresizingMaskIntoConstraints = false
        alarmButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    alarmButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 275).isActive = true
  //  alarmButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant:  -150).isActive = true
    alarmButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -275).isActive = true
    alarmButton.widthAnchor.constraint(equalToConstant: 105).isActive = true
    alarmButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
         
               }
}


