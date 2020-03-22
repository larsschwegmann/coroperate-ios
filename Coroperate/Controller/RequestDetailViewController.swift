//
//  RequestDetailViewController.swift
//  Coroperate
//
//  Created by Lars Schwegmann on 22.03.20.
//  Copyright © 2020 Lars Schwegmann. All rights reserved.
//

import Foundation
import Eureka
import UIKit
import Combine

class RequestDetailViewController: FormViewController {

    var request: Request
    var cancellable: Cancellable?

    init(request: Request) {
        self.request = request
        super.init(style: .grouped)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Einakufsliste von Lars"

        form +++
        Section()
        <<< LabelRow() {
            $0.title = "Adresse"
            $0.value = request.address
        }
        <<< LabelRow() {
            $0.title = "Postleitzahl"
            $0.value = request.zipCode
        }
        <<< LabelRow() {
            $0.title = "Stadt"
            $0.value = request.city
        }
        +++
        Section()
        <<< LabelRow() {
            $0.title = "Trinkgeld"
            $0.value = "\(self.request.tip)€"
        }

        form
        +++
        Section()
        <<< ButtonRow() {
            $0.title = "Für Lars einkaufen gehen!"
            $0.onCellSelection { (cell, row) in
                let req = UpdateRequestRequest(request: self.request)
                self.cancellable = APIClient(token: SettingsManager.shared.accessToken).send(req).sink(receiveCompletion: { (completion) in
                    print(completion)
                }) { (response) in
                    print(response)

                }
                row.disabled = true
                let alert = UIAlertController(title: "Danke! ❤️", message: "Danke für deinen Einsatz! Wenn du die Einkäufe für Lars besorgt hast, kannst du dich wieder in der App melden.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Okay!", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }

        let section = Section("Einkaufsliste:")

        for item in request.items {
            section
            <<< LabelRow() {
                $0.title = item.item
            }
        }

        form +++ section
    }
}
