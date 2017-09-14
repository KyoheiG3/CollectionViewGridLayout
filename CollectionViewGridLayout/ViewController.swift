//
//  ViewController.swift
//  CollectionViewGridLayout
//
//  Created by Kyohei Ito on 2017/07/25.
//  Copyright © 2017年 Kyohei Ito. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var collectionView: CollectionView!

    private let channels: [String] = ["News", "Anime", "Drama", "MTV", "Music", "Pets", "Documentary", "Soccer", "Cooking", "Gourmet", "Extreme", "Esports"]

    fileprivate lazy var slotList: [[Slot]] = {
        let detailText = "Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda."
        let minutesOfDay = 24 * 60
        let frames = [15, 15, 20, 20, 30, 30, 40, 40, 50, 50, 60, 60, 75, 75, 90, 90]
        return self.channels.enumerated().map { index, channel in
            var slots: [Slot] = []
            var totalMinutes = 0
            while totalMinutes < minutesOfDay {
                var minutes = frames[Int(arc4random_uniform(UInt32(frames.count)))]
                let startAt = totalMinutes + minutes
                minutes -= max(startAt - minutesOfDay, 0)
                let slot = Slot(minutes: minutes, startAt: totalMinutes, title: "\(channel)'s slot", detail: detailText)
                totalMinutes = startAt
                slots.append(slot)
            }
            return slots
        }
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.dataSource = self
        collectionView.delegate = self

        if #available(iOS 10.0, *) {
            collectionView.isPrefetchingEnabled = false
        }
    }

}

extension ViewController: UICollectionViewDataSource, CollectionViewDelegateGridLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return slotList.count * ((collectionView as? CollectionView)?.factor ?? 0)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return slotList[section % slotList.count].count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath)
        if let cell = cell as? CollectionViewCell {
            cell.configure(slotList[indexPath.column % slotList.count][indexPath.item])
        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, widthForColumn column: Int) -> CGFloat {
        return 152
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, heightForItemAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(slotList[indexPath.column % slotList.count][indexPath.item].minutes * 2)
    }
}
