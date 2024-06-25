import Launcher from "./Launcher"
import ClientTitle from "./ClientTitle"
import Workspaces from "./Workspaces"
import Time from "./Time"
import NotificationCount from "./NotificationCount"
import Media from "./Media"
import Stats from "./Stats"
import Bluetooth from "./Bluetooth"
import Wallpaper from "./Wallpaper"
import Network from "./Network"
import Volume from "./Volume"
import SysTray from "./SysTray"
import Profile from "./Profile"

const Left = Widget.Box({
  spacing: 2,
  children: [Launcher(), Workspaces(), ClientTitle() ],
})

const Center = Widget.Box({
  spacing: 15,
  children: [Time(), NotificationCount()]
})

const Right = Widget.Box({
  hpack: "end",
  spacing: 10,
  children: [
    Media(),
    Stats(),
    Bluetooth(),
    Wallpaper(),
    Network(),
    Volume(),
    SysTray(),
    Profile()]
})

export default (monitor: number = 0) => Widget.Window({
  monitor,
  name: `bar${monitor}`,
  className: "bar",
  anchor: ['top', 'left', 'right'],
  exclusivity: 'exclusive',
  vexpand: false,
  child: Widget.CenterBox({
    spacing: 8,
    start_widget: Left,
    center_widget: Center,
    end_widget: Right,
  }),
})