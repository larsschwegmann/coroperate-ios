//
//  CreateRequestController.swift
//  Coroperate
//
//  Created by Lars Schwegmann on 22.03.20.
//  Copyright © 2020 Lars Schwegmann. All rights reserved.
//

import Foundation
import UIKit
import Eureka
import BLTNBoard
import Combine

class CreateReqeustController: FormViewController {

    var bltnManager: BLTNItemManager?
    var items: [ShoppingListItem]

    var cancellable: Cancellable?

    init(items: [ShoppingListItem]) {
        self.items = items
        super.init(style: .grouped)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Bestellung Absenden"

        form +++
        Section()
        <<< TextRow() {
            $0.tag = "address"
            $0.title = "Adresse"
            $0.placeholder = "Musterstraße 1"
        }
        <<< TextRow() {
            $0.tag = "zip"
            $0.title = "Postleitzahl"
            $0.value = SettingsManager.shared.zipCode
        }
        <<< TextRow() {
            $0.tag = "city"
            $0.title = "Stadt"
            $0.placeholder = "Musterstadt"
        }
        +++
        Section()
        <<< StepperRow() {
            $0.tag = "tip"
            $0.title = "Trinkgeld"
            $0.cellUpdate { (cell, row) in
                cell.stepper.minimumValue = 0.0
                cell.stepper.maximumValue = 10.0
                cell.valueLabel.text = "\(Int(row.value ?? 0)) €"
            }
        }
        +++ Section()
        <<< ButtonRow() {
            $0.title = "Kostenpflichtig Bestellen"

            $0.onCellSelection { (cell, row) in
                let item = FeedbackPageBLTNItem(title: "Bestellung abgeschickt!")
                item.image = UIImage(named: "IntroCompletion")!
                item.imageAccessibilityLabel = "Checkmark"
                item.descriptionText = "Wir haben deine Bestellung erhalten. Wir benachrichtigen dich, sobald deine Bestellung von einem Helfer angenommen wurde."
                item.appearance.actionButtonColor = .systemGreen
                item.appearance.imageViewTintColor = .systemGreen
                item.appearance.actionButtonTitleColor = .white
                item.actionButtonTitle = "Okay"
                item.shouldStartWithActivityIndicator = true
                item.isDismissable = true
                item.actionHandler = { item in
                    item.manager?.dismissBulletin(animated: true)
                    self.dismiss(animated: true, completion: nil)
                }
                self.bltnManager = BLTNItemManager(rootItem: item)
                self.bltnManager?.showBulletin(above: self)

                // Start request
                let address = (self.form.rowBy(tag: "address") as! TextRow).value ?? ""
                let zip = (self.form.rowBy(tag: "zip") as! TextRow).value ?? ""
                let city = (self.form.rowBy(tag: "city") as! TextRow).value ?? ""
                let tip = (self.form.rowBy(tag: "tip") as! StepperRow).value ?? 0

                let request = Request(owner: nil,
                                      address: address,
                                      zipCode: zip,
                                      city: city,
                                      tip: Int(tip),
                                      date: nil,
                                      accepted: nil,
                                      items: self.items)
                let createRequest = CreateRequestRequest(request: request)

                self.cancellable = APIClient(token: SettingsManager.shared.accessToken!).send(createRequest).sink(receiveCompletion: { (completion) in
                    // HAndle this
                    print(completion)
                    self.bltnManager?.hideActivityIndicator()
                }) { (result) in
                    print(result)
                }

            }
        }
    }
}
