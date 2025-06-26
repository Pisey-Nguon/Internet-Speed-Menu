import Foundation

struct Speed {
    var download: String
    var upload: String
}

class NetworkMonitor {
    private var lastReceived: UInt64 = 0
    private var lastSent: UInt64 = 0

    init() {
        updateStats()
    }

    func getSpeed() -> Speed {
        let current = getNetworkBytes()

        guard lastReceived <= current.received,
              lastSent <= current.sent else {
            lastReceived = current.received
            lastSent = current.sent
            return Speed(download: "0 KB/s", upload: "0 KB/s")
        }

        let downSpeed = current.received - lastReceived
        let upSpeed = current.sent - lastSent

        lastReceived = current.received
        lastSent = current.sent

        return Speed(download: formatBytes(bytes: downSpeed),
                     upload: formatBytes(bytes: upSpeed))
    }

    private func updateStats() {
        let stats = getNetworkBytes()
        lastReceived = stats.received
        lastSent = stats.sent
    }

    private func getNetworkBytes() -> (received: UInt64, sent: UInt64) {
        var ifaddr: UnsafeMutablePointer<ifaddrs>? = nil
        var received: UInt64 = 0
        var sent: UInt64 = 0

        if getifaddrs(&ifaddr) == 0 {
            var ptr = ifaddr
            while ptr != nil {
                if let info = ptr?.pointee, info.ifa_addr.pointee.sa_family == UInt8(AF_LINK) {
                    let data = unsafeBitCast(info.ifa_data, to: UnsafeMutablePointer<if_data>.self)
                    received += UInt64(data.pointee.ifi_ibytes)
                    sent += UInt64(data.pointee.ifi_obytes)
                }
                ptr = ptr?.pointee.ifa_next
            }
            freeifaddrs(ifaddr)
        }

        return (received, sent)
    }

    private func formatBytes(bytes: UInt64) -> String {
        let kb = Double(bytes) / 1024.0
        let mb = kb / 1024.0
        return mb > 1.0 ? String(format: "%.1f MB/s", mb) : String(format: "%.1f KB/s", kb)
    }
}
