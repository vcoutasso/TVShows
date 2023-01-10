import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemPink
        Task {
            let shows = await TVMazeService.default.execute(.init(endpoint: .shows, pathComponents: nil, queryItems: nil), expecting: [TVShow].self)
            print(shows)
        }
    }


}

