import UIKit
import Foundation

protocol Parkable {
    var plate: String { get }
    var checkInTime: Date { get }
    var parkedTime: Int { get }
    var discountCard: String? { get }
    var type: VehicleType { get }
}

enum VehicleType: CaseIterable {
    case car
    case moto
    case miniBus
    case bus
    
    var rate: Int {
        switch self {
        case .car:
            return 20
        case .moto:
            return 15
        case .miniBus:
            return 25
        case .bus:
            return 30
        }
    }
}

struct Parking {
    
    var vehicles: Set<Vehicle> = []
    let maxSlots = 20
    var (totalVehicles, totalEarnings): (Int, Int) = (0, 0)
    
    mutating func checkInVehicle(_ vehicle: Vehicle, onFinish: (Bool) -> Void) {
        guard vehicles.count <= maxSlots - 1 else {
            onFinish(false)
            return
        }
        for v in vehicles {
            if vehicle.plate == v.plate {
                onFinish(false)
                return
            }
        }
        
        onFinish(true)
        vehicles.insert(vehicle)
    }
    
    func calculateFee(vehicle: Vehicle, parkedTime: Int, hasDiscountCard: Bool) -> Int {
        let totalFee: Int
        
        if parkedTime <= 120 {
            totalFee = vehicle.type.rate
        } else {
            let extraTime = Double(parkedTime) - 120
            let extraFee = Int(ceil(extraTime / 15) * 5) //Hacemos este proceso para que el resultado sea redondeado hacia arriba.
            totalFee = extraFee + vehicle.type.rate
        }
        if hasDiscountCard {
            return totalFee - Int(ceil(Double(totalFee) * 0.15))
        } else {
            return totalFee
        }
    }
}

//MARK: - Check data
extension Parking {
    
    mutating func checkOutVehicle(plate: String, onSuccess:(Int) -> (), onError:(String) -> ()) {
        
        let selectedVehicle = vehicles.first {$0.plate == plate}
        
        if let currentVehicle = selectedVehicle {
            let hasDiscount = currentVehicle.discountCard != nil
            let fee = calculateFee(vehicle: currentVehicle, parkedTime: currentVehicle.parkedTime, hasDiscountCard: hasDiscount)
            totalEarnings += fee
            onSuccess(fee)
            vehicles.remove(currentVehicle)
            totalVehicles += 1
            return
        } else {
            onError("Sorry, the check-out failed")
            return
        }
        
    }
    
    func checkEarnigns() {
        print("\(totalVehicles) vehicles have checked out and we have earned $\(totalEarnings)")
    }
    
    func listVehicles() {
        print("There are \(alkeParking.vehicles.count) parked vehicles right now. Here are their plates:")
        alkeParking.vehicles.forEach({ vehicle in
            print(vehicle.plate)
        })
    }
    
}

//MARK: - Vehicle
struct Vehicle: Parkable, Hashable {
    
    let plate: String
    let type: VehicleType
    let checkInTime: Date
    var parkedTime: Int {
        Calendar.current.dateComponents([.minute], from: checkInTime, to: Date()).minute ?? 0
    }
    let discountCard: String?
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(plate)
    }
    
    static func == (lhs: Vehicle, rhs: Vehicle) -> Bool {
        return lhs.plate == rhs.plate
    }
}

//MARK: - Vehicle creator

func carCreator(amount: Int) -> [Vehicle] {
    var vehicles: [Vehicle] = []
    
    while vehicles.count < amount {
        let hasDiscount = Bool.random()
        let newVehicle = Vehicle(plate: randomPlate(), type: VehicleType.allCases.randomElement() ?? .car, checkInTime: Date().advanced(by: (-TimeInterval(Int.random(in: 0...12000)))), discountCard: hasDiscount ? "DISCOUNT_CARD" : nil)
        vehicles.append(newVehicle)
    }
    
    return vehicles
}

func randomPlate() -> String {
    let letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    let numbers = "0123456789"
    return String((0...2).map{ _ in letters.randomElement()! }) + String((0...2).map{ _ in numbers.randomElement()! })
}

//MARK: - Tests

// Creation of parking and vehicles
var alkeParking = Parking()
let vehicleArray = carCreator(amount: 25)

// Check-in test
for v in vehicleArray {
    alkeParking.checkInVehicle(v) { check in
        check ? print("Welcome to AlkeParking Los Jorge's Station.") : print("Sorry, the check-in failed.")
    }
}

// Check-out test
print("\(vehicleArray[2].type) with plate: \(vehicleArray[2].plate), your time was: \(vehicleArray[2].parkedTime) minutes, \(vehicleArray[2].discountCard ?? "NO_DISCOUNT_CARD").")

alkeParking.checkOutVehicle(plate: vehicleArray[2].plate) { rate in
    print("Your fee is $\(rate). Come back soon.")
} onError: { error in
    print(error)
}

print("\(vehicleArray[7].type) with plate: \(vehicleArray[7].plate), your time was: \(vehicleArray[7].parkedTime) minutes, \(vehicleArray[7].discountCard ?? "NO_DISCOUNT_CARD").")

alkeParking.checkOutVehicle(plate: vehicleArray[7].plate) { rate in
    print("Your fee is $\(rate). Come back soon.")
} onError: { error in
    print(error)
}

// Check total vehicles and earnings
alkeParking.checkEarnigns()

// Check parked vehicles plates
alkeParking.listVehicles()

//MARK: - Respuestas
/*
 ¿Por qué se define vehicles como un Set?
  Porque un Set es más ligero que un arreglo ya que no tiene en cuenta el orden de los elementos ni permite duplicados.
  En este caso, además, resulta conveniente porque ayuda a garantizar que nunca tendremos vehículos duplicados en nuestro
  parqueadero.
 
 ¿Qué elemento de control de flujos podría ser útil para determinar la tarifa de cada vehículo en la
  computed property : ciclo for, if o switch?
  Switch contempla de una vez todos los casos posibles dentrol del enum y es más limpio.
 
 ¿Dónde deben agregarse las propiedades, en Parkable, Vehicle o en ambos?
  En ambos porque en el protocolo definimos el requisito y en la estructura satisfacemos el requisito.
 
 La tarjeta de descuentos es opcional, es decir que un vehículo puede no tener una tarjeta y su valor será nil.
 ¿Qué tipo de dato de Swift permite tener este comportamiento?
 El string opcional.
  
 El tiempo de estacionamiento dependerá de parkedTime y deberá computarse cada vez que se consulta, teniendo como referencia la fecha actual.
 ¿Qué tipo de propiedad permite este comportamiento: lazy properties, computed properties o static properties?
  Se usa una propiedad computada ya que esta calcula el valor cuando es llamada.
 
 Se está modificando una propiedad de un struct ¿Qué consideración debe tenerse en la definición de la función?
 La función tiene que ser mutating para poder modificar el struct.
 
 ¿Qué validación debe hacerse para determinar si el vehículo tiene descuento?
 Verificar que el valor de la tarjeta no sea nil.
 
¿Puede cambiar el tipo del vehículo en el tiempo?¿Debe definirse como variable o constante en Vehicle?
 No puede cambiar porque no tiene sentido para el objeto que el tipo pueda cambiar entonces debe ser constante.

*/
