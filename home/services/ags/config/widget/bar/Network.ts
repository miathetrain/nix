const network = await Service.import('network')

const WifiIndicator = () => Widget.Icon({
  icon: network.wifi.bind('icon_name'),
  // tooltip_text: network.wifi.bind('ssid').as(ssid => ssid || 'Unknown')

  // tooltip_text: network.bind('wifi').as(p => `ssid: ${p.ssid}\nstrength: ${p.strength}`)

  setup: (self) => {
    Utils.interval(60000, () => {
      const wifi = network.wifi
      self.tooltip_text = `ssid: ${wifi.ssid}\nstrength: ${wifi.strength}\nstate: ${wifi.state}`;
    })
  }
})

const WiredIndicator = () => Widget.Icon({
  icon: network.wired.bind('icon_name'),
})

export default () => Widget.Stack({
  class_name: "icons",
  children: {
    wifi: WifiIndicator(),
    wired: WiredIndicator(),
  },
  shown: network.bind('primary').as(p => p || 'wifi'),
})