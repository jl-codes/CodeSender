//
//  FirstViewController.swift
//  CodeSender
//
//  Created by MCS on 7/28/19.
//  Copyright © 2019 MCS. All rights reserved.
//

import UIKit
import MessageUI

class FirstViewController: UIViewController {

  @IBOutlet weak var toRecipient: UITextField!
  
  @IBOutlet weak var msgText: UITextField!
  
  @IBOutlet weak var translation: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
  }
}

extension FirstViewController: MFMessageComposeViewControllerDelegate {
  func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
    switch (result) {
    case .cancelled:
      print("Message cancelled")
      dismiss(animated: true, completion: nil)
    case .failed:
      print("Message failed")
      dismiss(animated: true, completion: nil)
    case .sent:
      print("Message sent")
      dismiss(animated: true, completion: nil)
    default:
      break
    }
  }
  
  @IBAction func onSend(_ sender: UIButton) {
    
    
    if MFMessageComposeViewController.canSendText() {
      
      let controller = MFMessageComposeViewController()
      
      do {
        if let pigLatinTranslation = try Cryptor(string: self.msgText.text) {
          translation.text = pigLatinTranslation.translate()
          controller.body = pigLatinTranslation.translate()
        }
      } catch CryptorError.invalidString {
        controller.body = "No string entered"
      } catch {
        controller.body = "Input text only"
      }
      
      //controller.body = self.msgText.text
      //controller.body =
      controller.recipients = ([self.toRecipient.text]) as? [String]
      controller.messageComposeDelegate = self
      
      self.present(controller, animated: true, completion: nil)
    } else {
      print("Message couldn't be sent")
    }
    
  }
}

//extension FirstViewController: MFM
