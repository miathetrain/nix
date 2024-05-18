import Launcher from "./Launcher"

const Left = Widget.Box({
  children: [Launcher()],
})

const Center = Widget.Box({
  // children: [Time, Media()]
})

const Right = Widget.Box({
  hpack: "end",
  spacing: 10,
  // children: [
  //   stats_box,
  //   connectedList,
  //   NetworkIndicator(),
  //   Volume(),
  //   sysTray,
  //   profile_pic]
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