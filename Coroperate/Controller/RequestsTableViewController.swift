//
//  RequestsTableViewController.swift
//  Coroperate
//
//  Created by Lars Schwegmann on 22.03.20.
//  Copyright © 2020 Lars Schwegmann. All rights reserved.
//

import Foundation
import UIKit
import Combine

class RequestsTableViewController: UITableViewController {
    enum Section {
        case main
    }

    var requests = [Request]()
    var ds: UITableViewDiffableDataSource<Section, Request>?
    var cancellable: Cancellable?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.register(UINib(nibName: "RequestCell", bundle: nil), forCellReuseIdentifier: "request_cell")
        let ds = UITableViewDiffableDataSource<Section, Request>(tableView: self.tableView) { (table, indexPath, request) -> UITableViewCell? in
            let cell = table.dequeueReusableCell(withIdentifier: "request_cell", for: indexPath) as! RequestCell

            cell.zipCodeLabel.text = request.zipCode
            cell.articleCountLabel.text = "\(request.items.count) Artikel"
            cell.tipLabel.text = "\(request.tip)€ Trinkgeld"

            let fmt = DateFormatter()
            fmt.dateStyle = .long
            fmt.timeStyle = .short
            fmt.locale = Locale(identifier: "de_DE")

            cell.dateLabel.text = fmt.string(from: request.date!) + " Uhr"
            cell.accessoryType = .disclosureIndicator

            return cell
        }
        self.ds = ds
        self.tableView.dataSource = ds
        self.tableView.delegate = self

        self.fetchRequests()
    }

    func fetchRequests() {
        let req = GetRequestListRequest(zipCode: SettingsManager.shared.zipCode)
        self.cancellable = APIClient(token: SettingsManager.shared.accessToken).send(req).sink(receiveCompletion: { (completion) in
            print(completion)
        }) { (result) in
            print(result)
            self.requests = result.value
            var snapshot = NSDiffableDataSourceSnapshot<Section, Request>()
            snapshot.appendSections([.main])
            snapshot.appendItems(self.requests)
            self.ds?.apply(snapshot)
        }
    }

}

extension RequestsTableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = RequestDetailViewController(request: self.requests[indexPath.row])
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
