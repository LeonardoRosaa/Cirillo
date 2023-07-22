import Foundation

protocol Animal {
    var name: String? { get }
}

class Cat: Animal {
    let name: String?

    init(name: String?) {
        self.name = name
    }
}

protocol Person {
    func play()
}

class PetOwner: Person {
    let pet: Animal

    init(pet: Animal) {
        self.pet = pet
    }

    func play() {
        let name = pet.name ?? "someone"
        print("I'm playing with \(name).")
    }
}
