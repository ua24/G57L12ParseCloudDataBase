//
//  MasterViewController.swift
//  G57L12
//
//  Created by Ivan Vasilevich on 11/2/17.
//  Copyright © 2017 RockSoft. All rights reserved.
//

import UIKit
import Parse

class MasterViewController: UITableViewController {

	@IBOutlet weak var refresher: UIRefreshControl!
	var detailViewController: DetailViewController? = nil
	var objects = [PFObject]()


	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		fetchData()
	}
	
	func fetchData() {
		let query = PFQuery(className: "Quote")
		query.whereKey("authorName", equalTo: "Dima")
		query.findObjectsInBackground { (objects, error) in
			if let realObjects = objects {
				self.objects = realObjects
				self.tableView.reloadData()
				self.refresher.endRefreshing()
			}
		}
	}

	@IBAction func updateResults(_ sender: UIRefreshControl) {
		fetchData()
	}
	

	// MARK: - Segues

	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "showDetail" {
		    if let indexPath = tableView.indexPathForSelectedRow {
		        let object = objects[indexPath.row] as! NSDate
		        let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
		        controller.detailItem = object
		        controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
		        controller.navigationItem.leftItemsSupplementBackButton = true
		    }
		}
	}

	// MARK: - Table View

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return objects.count
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

		let object = objects[indexPath.row]
		cell.textLabel!.text = object["text"] as? String
		return cell
	}


}

