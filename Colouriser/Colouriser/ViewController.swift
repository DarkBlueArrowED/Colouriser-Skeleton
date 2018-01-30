
import UIKit

class ViewController: UIViewController {
    
//    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var screenCoverButton: UIButton!
    @IBOutlet weak var menuView: UIView!
    
    @IBOutlet weak var profileImageView: UIImageViewX!
    @IBOutlet weak var homeButton: UIButton!
    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var breakButton: UIButton!
    @IBOutlet weak var alertButton: UIButton!
    @IBOutlet weak var hotButton: UIButton!
    @IBOutlet weak var cameraView: UIImageView!
    
    @IBOutlet weak var menuCurveImageView: UIImageView!

// For removed table
//    var tableData: [Model] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
//loads GUI menu body main
        menuCurveImageView.image = #imageLiteral(resourceName: "MenuCurve")
//        tableView.dataSource = self
        
        Data.getData { (data) in
// For removed table please refere to ¯\_(ツ)_/¯
//            self.tableData = data
//            self.tableView.reloadData()
        }
        
        hideMenu()
    }
    
/////////////////////////////////////////// For GUI Basic Functions and Side MENU ///////////////////////////////////////////////////////////////////////////////////////
    @IBAction func menuTapped(_ sender: UIButton) {
        showMenu()
    }
    
    @IBAction func screenCoverTapped(_ sender: UIButton) {
        hideMenu()
    }
    
    // Show Menu Function
    func showMenu() {
        menuView.isHidden = false
        
        UIView.animate(withDuration: 0.7, animations: {
            self.screenCoverButton.alpha = 1
        })
        
        UIView.animate(withDuration: 0.5, delay: 0.06, options: .curveEaseOut, animations: {
            self.menuCurveImageView.transform = .identity
        })
        UIView.animate(withDuration: 0.4, delay: 0, options: [.curveEaseOut, .allowUserInteraction], animations: {
            self.searchButton.transform = .identity
        })
        
        UIView.animate(withDuration: 0.4, delay: 0.06, options: [.curveEaseOut, .allowUserInteraction], animations: {
            self.locationButton.transform = .identity
            self.breakButton.transform = .identity
        })
        
        UIView.animate(withDuration: 0.4, delay: 0.12, options: [.curveEaseOut, .allowUserInteraction], animations: {
            self.homeButton.transform = .identity
            self.alertButton.transform = .identity
        })

         UIView.animate(withDuration: 0.4, delay: 0.18, options: [.curveEaseOut, .allowUserInteraction], animations: {
            self.profileImageView.transform = .identity
            self.hotButton.transform = .identity
        })
    }
    
    // Hide Menu Function
    func hideMenu() {
        UIView.animate(withDuration: 0.7, animations: {
            self.screenCoverButton.alpha = 0
        })
        
        UIView.animate(withDuration: 0.4, delay: 0, options: [.curveEaseOut, .allowUserInteraction], animations: {
            self.profileImageView.transform = CGAffineTransform(translationX: -self.menuView.frame.width, y: 0)
            self.hotButton.transform = CGAffineTransform(translationX: -self.menuView.frame.width, y: 0)
        })
        
        UIView.animate(withDuration: 0.4, delay: 0.08, options: [.curveEaseOut, .allowUserInteraction], animations: {
            self.homeButton.transform = CGAffineTransform(translationX: -self.menuView.frame.width, y: 0)
            self.alertButton.transform = CGAffineTransform(translationX: -self.menuView.frame.width, y: 0)
        })
        
        UIView.animate(withDuration: 0.4, delay: 0.16, options: [.curveEaseOut, .allowUserInteraction], animations: {
            self.locationButton.transform = CGAffineTransform(translationX: -self.menuView.frame.width, y: 0)
            self.breakButton.transform = CGAffineTransform(translationX: -self.menuView.frame.width, y: 0)
        })
        
        UIView.animate(withDuration: 0.5, delay: 0.08, options: .curveEaseOut, animations: {
            self.menuCurveImageView.transform = CGAffineTransform(translationX: -self.menuCurveImageView.frame.width, y: 0)
        })
        
        //This is for a search feature but will probly never be used - WB
        UIView.animate(withDuration: 0.4, delay: 0.21, options: [.curveEaseOut, .allowUserInteraction], animations: {
            self.searchButton.transform = CGAffineTransform(translationX: -self.menuView.frame.width, y: 0)
        }) { success in
            self.menuView.isHidden = true
        }
    }
}

// For old data table stuff, I can remember what ¯\_(ツ)_/¯
//extension ViewController: UITableViewDataSource {
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return tableData.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "tableViewCell") as! TableViewCell
//        cell.setup(model: tableData[indexPath.row])
//        return cell
//    }
//}

/////////////////////////////////////////// End of GUI Basic Functions and Side MENU /////////////////////////////////////////////////////////////////////////////////////
 /*
 Notes:


 */


