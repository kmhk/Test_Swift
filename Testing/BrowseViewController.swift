//
//  BrowseViewController.swift
//  Testing
//
//  Created by Com on 19/02/2017.
//  Copyright © 2017 Com. All rights reserved.
//

import UIKit

enum SortType: Int {
	case byTitle = 0
	case byDistance
	
	mutating func chooseSort(btn: UIBarButtonItem) {
		if self == .byTitle {
			btn.title = NSLocalizedString("By Title", comment: "")
			self = .byDistance
		} else {
			btn.title = NSLocalizedString("By Distance", comment: "")
			self = .byTitle
		}
	}
}

class BrowseViewController: UIViewController {
	
	let viewModel = BrowseViewModel()
	var sortType: SortType = .byTitle
	
	@IBOutlet weak var collectionView: UICollectionView!
	@IBOutlet weak var barBtnSort: UIBarButtonItem!

	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		let lpgr = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongPress(gestureReconizer:)))
		lpgr.minimumPressDuration = 0.5
		lpgr.delaysTouchesBegan = true
		lpgr.delegate = self
		self.collectionView.addGestureRecognizer(lpgr)
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		collectionView.reloadData()
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
		if segue.identifier == "segueDetail" {
			let vc = segue.destination as! DetailViewController
			
			let dict = viewModel.arrayImages[(sender as! IndexPath).row]
			vc.imageTitle = dict.title
			vc.imageSrcURL = dict.url.absoluteString
			vc.imageSrcLocalURL = dict.url.absoluteString
		}
    }

	
	@IBAction func onSort(_ sender: Any) {
		sortType.chooseSort(btn: barBtnSort)
		if sortType == .byTitle {
			viewModel.arrayImages.sort(by: {return $0.0.title < $0.1.title})
		} else {
			viewModel.arrayImages.sort(by: {return $0.0.distance! < $0.1.distance!})
		}
		collectionView.reloadData()
	}
}


// MARK: - UIColloectionView delegate & data source
extension BrowseViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
	public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return viewModel.arrayImages.count
	}
	
	public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.id, for: indexPath) as! ImageCollectionViewCell
		cell.setCell(with: viewModel.arrayImages[indexPath.row])
		
		return cell
	}
	
	public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		performSegue(withIdentifier: "segueDetail", sender: indexPath)
	}
	
	public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
		return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
	}
}


// MARK: - UIGesture delegate
extension BrowseViewController: UIGestureRecognizerDelegate {
	func handleLongPress(gestureReconizer: UILongPressGestureRecognizer) {
		if gestureReconizer.state != UIGestureRecognizerState.ended {
			return
		}
		
		let alert = UIAlertController(title: "", message: NSLocalizedString("Are you sure remove?", comment: ""), preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: NSLocalizedString("YES", comment: ""), style: .default, handler: { (action) in
			let p = gestureReconizer.location(in: self.collectionView)
			let indexPath = self.collectionView.indexPathForItem(at: p)
			
			if let index = indexPath {
				self.viewModel.arrayImages.remove(at: index.row)
				self.collectionView.reloadData()
			}
		}))
		alert.addAction(UIAlertAction(title: NSLocalizedString("NO", comment: ""), style: .cancel, handler: nil))
		self.present(alert, animated: true, completion: nil)
	}
}
