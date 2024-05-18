const network = await Service.import('network')

const WifiIndicator = () => Widget.Icon({
  icon: network.wifi.bind('icon_name'),
  tooltip_text: network.wifi.bind('ssid').as(ssid => ssid || 'Unknown')
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