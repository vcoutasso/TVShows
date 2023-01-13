import Foundation

enum TVShowsPeopleViewControllerFactory {
    static func `default`() -> TVShowsPeopleViewController {
        make()
    }

    static func make() -> TVShowsPeopleViewController {
        TVShowsPeopleViewController()
    }
}


