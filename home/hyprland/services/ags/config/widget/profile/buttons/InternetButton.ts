const network = await Service.import('network')

const WifiIndicator = () => Widget.Icon({
    icon: network.wifi.bind('icon_name'),

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

const Icon = () => Widget.Stack({
    class_name: "profile-normal-button-icon",
    children: {
        wifi: WifiIndicator(),
        wired: WiredIndicator(),
    },
    shown: network.bind('primary').as(p => p || 'wifi'),
})

export default () => Widget.ToggleButton({
    class_name: "profile-normal-button circular",
    child: Icon()
})