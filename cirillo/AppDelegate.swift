import SwiftUI
import Swinject


let sharedContainer = Container()

class AppDelegate: NSResponder, NSApplicationDelegate {
    var window: NSWindow?
    let container: Container = {
        print("I'm here")
        sharedContainer.register(Animal.self) { _ in Cat(name: "Mimi") }
        sharedContainer.register(Person.self) { r in
            PetOwner(pet: r.resolve(Animal.self)!)
        }
               
        return sharedContainer
    }()

}
