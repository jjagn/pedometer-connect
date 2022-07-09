//
//  PedometerConnectViewModel.swift
//  Pedometer Connect
//
//  Created by Jackson Crawford on 30/06/22.
//

import Foundation
import CoreBluetooth

class PedometerViewModel: NSObject, ObservableObject, Identifiable {
    var id = UUID()
    
    @Published var output = "Disconnected" // current text to display in the output
    
    @Published var stepsThisUnit:Int32 = 0
    
    @Published var stepsTotal:Int = 0
    
    @Published var stepsDataOverTime:[Double] = [0]
    
    @Published var changeRate = 0
    
    @Published var connected = false // true when BLE connection becomes active
    
    @Published var date = Date().timeIntervalSinceReferenceDate
    
    private var centralQueue: DispatchQueue?
    
    private let serviceUUID = CBUUID(string: "97108D83-8D51-46F2-93B1-678D129C1E8B")
    private let outputUUID = CBUUID(string: "ED01FEB8-A2A6-45F0-A70D-3B328414514C")
    private var outputChar: CBCharacteristic?
    
    // service and peripheral objects
    private var centralManager: CBCentralManager?
    private var connectedPeripheral: CBPeripheral?
    
    func connectPedometer() {
        output = "Connecting..."
        centralQueue = DispatchQueue(label: "test.discovery")
        centralManager = CBCentralManager(delegate: self, queue: centralQueue)
    }
    
    func disconnectPedometer() {
        guard let manager = centralManager,
              let peripheral = connectedPeripheral else { return }
              
        manager.cancelPeripheralConnection(peripheral)
    }
}

extension PedometerViewModel: CBCentralManagerDelegate {
    
    // this method monitors the state of the BT radios
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        print("Central manager state changed \(central.state)")
        if central.state == .poweredOn {
            central.scanForPeripherals(withServices: [serviceUUID], options: nil)
        }
    }
    
    // called for each peripheral found that advertises the serviceUUID
    // this program assumes only one peripheral will be powered up (should be fine for now)
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi: NSNumber) {
        print("Discovered \(peripheral.name ?? "UNKNOWN")")
        central.stopScan()
        
        connectedPeripheral = peripheral
        central.connect(peripheral, options: nil)
    }
    
    // after BLE connection to peripheral, enumerate its services
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Connected to \(peripheral.name ?? "UNKNOWN")")
        peripheral.delegate = self
        peripheral.discoverServices(nil)
    }
    
    // after BLE connection, cleanup
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        print("Disconnected from \(peripheral.name ?? "UNKNOWN")")
        
        centralManager = nil
        
        DispatchQueue.main.async {
            self.connected = false
            self.output = "Disconnected"
        }
    }
}

extension PedometerViewModel : CBPeripheralDelegate {
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        print("Discovered services for \(peripheral.name ?? "UNKOWN")")
        
        guard let services = peripheral.services else {
            return
        }
        
        for service in services {
            peripheral.discoverCharacteristics(nil, for: service)
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        print("Discovered characteristics for \(peripheral.name ?? "UNKNOWN")")
        
        guard let characteristics = service.characteristics else {
            return
        }
        
        for ch in characteristics {
            switch ch.uuid {
            case outputUUID:
                outputChar = ch
                // subscribe to notification events for the output characteristic
                peripheral.setNotifyValue(true, for: ch)
            default:
                break
            }
        }
        
        DispatchQueue.main.async {
            self.connected = true
            self.output = "Connected"
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
        print("Notification state changed to \(characteristic.isNotifying)")
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        print("Characteristic updated: \(characteristic.uuid)")
        if characteristic.uuid == outputUUID, let data = characteristic.value {
            let bytes:[UInt8] = data.map {$0}
            
//            // convert rxd 8 bit uints to 32 bit ints and left shift before recombining bits back into 32 bit
//            let rx:UInt32 = (UInt32(bytes[3]) << 24) | (UInt32(bytes[2]) << 16) | (UInt32(bytes[1]) << 8 ) | (UInt32(bytes[0]))
//            steps = long
//            print("Data rx: \(long)")
            
            // convert rxd 8 bit uints to 32 bit ints and left shift before recombining bits back into 32 bit
            // updated iterative version allows for different lengths of input
            var rx:Int32 = 0
            
            for (index, element) in bytes.enumerated() {
                let temp:Int32 = (Int32(element) << (8*index))
                rx += temp
            }
            
            print("data rx: \(rx)")
            
            DispatchQueue.main.async {
                if rx < 0 {
                    if rx == -65535 {
                        rx = 0
                    }
                    
                    // remove negation added during BLE send
                    rx = -rx
                    
                    self.stepsDataOverTime.append(Double(rx))
                    
                    self.stepsTotal = Int(self.stepsDataOverTime.reduce(0, {x,y in
                        x + y
                    }))
                    
                    let numElements = self.stepsDataOverTime.count
                    
                    if numElements > 2 {
                        var copy = self.stepsDataOverTime
                        if let last = copy.popLast() {
                            if let secondLast = copy.popLast() {
                                if secondLast > 0 {
                                    self.changeRate = Int((last-secondLast)/secondLast*100)
                                } else if (secondLast == last) && (last == 0) {
                                    self.changeRate = 0
                                } else {
                                    self.changeRate = 10000 // set change rate from 0 to any number to 10,000 % because *shrug*
                                }
                            }
                        }
                    }
                } else {
                        self.stepsThisUnit = rx
                }
                self.output = "\(rx)"
            }
        }
    }
}
