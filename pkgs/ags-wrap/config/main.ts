const hyprland = await Service.import("hyprland")
const systemtray = await Service.import('systemtray')

import { Align } from "types/@girs/gtk-3.0/gtk-3.0.cjs"
import { NotificationPopups, notification_list, hasNotifications } from "./notificationPopups.js"
import { format } from 'date-fns'

const mpris = await Service.import('mpris')
const audio = await Service.import('audio')
const notifications = await Service.import('notifications');

// main scss file
const scss = `${App.configDir}/css/style.scss`

// target css file
const css = `/tmp/my-style.css`

// make sure sassc is installed on your system
Utils.exec(`dart-sass ${scss} ${css}`)

const Launcher = Widget.Icon({
  class_name: "launcher",
  icon: `${App.configDir}/assets/nixos.svg`,
  tooltip_text: "Quick Search",
  size: 20,
})

const Workspaces = Widget.Box({
  class_name: "workspaces",
  children: Array.from({ length: 5 }, (_, i) => i + 1).map(i => Widget.Label({
    attribute: i,
    class_name: "workspace",
    vpack: "center",
    hpack: "center",
    tooltip_text: `Workspace: ${i}`,
    label: `${i}`,
    setup: self => self.hook(hyprland, () => {
      self.toggleClassName("active", hyprland.active.workspace.id === i)
      self.toggleClassName("occupied", (hyprland.getWorkspace(i)?.windows || 0) > 0)
    })
  })),
});

/** @param {import('types/service/systemtray').TrayItem} item */
const SysTrayItem = item => Widget.Button({
  child: Widget.Icon().bind('icon', item, 'icon'),
  tooltipMarkup: item.bind('tooltip_markup'),
  onPrimaryClick: (_, event) => item.activate(event),
  onSecondaryClick: (_, event) => item.openMenu(event),
});

const ClientTitle = Widget.Label({
  class_name: "client-title",
  tooltip_text: hyprland.active.client.bind("title"),
  label: hyprland.active.client.bind("title").as(title => {
    return title.length <= 25 ? title : title.substring(0, 20) + "..."
  })
})

const time = Variable('', {
  poll: [1000, function () {
    return format(new Date(), "HH:mm - MMM do");
  }],
});

const Time = Widget.EventBox({
  class_name: "date",
  hpack: "center",
  on_primary_click: () => {
    if (clockBar.visible) {
      // clockBar.visible = false;
      App.closeWindow("clockbar");

    }
    else {
      clockBar.visible = true;
      App.openWindow("clockbar")
    }
    // clockBar.visible = !clockBar.visible;
  },
  child: Widget.Label({
    label: time.bind()
  })
})

const sysTray = Widget.Box({
  children: systemtray.bind('items').as(i => i.map(SysTrayItem))
})

function Media() {
  const label = Utils.watch("", mpris, "player-changed", () => {
    if (mpris.players[0]) {
      const { track_artists, track_title } = mpris.players[0]
      const title = `${track_title} `
      return title.length <= 25 ? title : title.substring(0, 20) + "..." // return `${track_artists.join(', ')} ─ ${track_title}`
    } else {
      return ''
    }
  })

  const tooltip = Utils.watch("", mpris, "player-changed", () => {
    if (mpris.players[0]) {
      const { track_artists, track_title } = mpris.players[0]
      return `${track_title} ─ ${track_artists.join(', ')}` // return `${track_artists.join(', ')} ─ ${track_title}`
    } else {
      return ''
    }
  })

  const playicon = Utils.watch("", mpris, "changed", () => {
    if (mpris.players[0]) {
      const { play_back_status } = mpris.players[0]
      if (play_back_status == "Playing") {
        return ""
      }
    }
    return ""
  })

  const source = Utils.watch("", mpris, "player-changed", () => {
    if (mpris.players[0]) {
      const { identity } = mpris.players[0]
      switch (identity) {
        case 'Spotify':
          return ``
        case 'Kodi':
          return `󰌔`
        case 'Mozilla Firefox':
          return ``
      }
      return `󰎈`
    } else {
      return ''
    }
  })

  const revealer = Widget.Revealer({
    transitionDuration: 1000,
    transition: 'slide_right',
    child: Widget.Box({

      children: [
        Widget.EventBox({ // 
          class_name: "media-buttons",
          child: Widget.Label({
            label: ""
          })
        }),

        Widget.EventBox({ // 
          class_name: "media-buttons",
          child: Widget.Label({
            label: playicon
          })
        }),

        Widget.EventBox({ // 
          class_name: "media-buttons",
          child: Widget.Label({
            label: ""
          })
        })
      ]
    }),
  })

  const widget = Widget.EventBox({
    on_hover: (event) => {
      if ("" + label != "") {
        revealer.reveal_child = true;
        Utils.timeout(3000, () => {
          revealer.reveal_child = false;
        })
      }
    },

    child: Widget.Box({
      hpack: "end",
      children: [
        Widget.Label({
          class_name: "media-icon",
          label: source
        }),
        Widget.Label({
          class_name: "media-name",
          tooltip_text: tooltip,
          label
        }),
        revealer]
    })
  })

  return widget
}

function Volume() {
  const icons = {
    101: 'overamplified',
    67: 'high',
    34: 'medium',
    1: 'low',
    0: 'muted',
  }

  function getIcon() {
    const icon: any = audio.speaker.is_muted ? 0 : [101, 67, 34, 1, 0].find(
      threshold => threshold <= audio.speaker.volume * 100)

    return `audio-volume-${icons[icon]}-symbolic`
  }

  const icon = Widget.Icon({
    icon: Utils.watch(getIcon(), audio.speaker, getIcon)
  })

  const slider = Widget.Slider({
    hexpand: true,
    draw_value: false,
    on_change: ({ value }) => audio.speaker.volume = value,
    setup: self => self.hook(audio.speaker, () => {
      self.value = audio.speaker.volume || 0
    }),
  })

  return Widget.Box({
    class_name: 'volume',
    css: 'min-width: 180px',
    children: [icon, slider],
  })
}

const Left = Widget.Box({
  children: [Launcher, Workspaces, ClientTitle]
})

const Center = Widget.Box({
  children: [Time, Media()]
})

const Right = Widget.Box({
  hpack: "end",
  children: [
    Volume(),
    sysTray]
})

export const Bar = (monitor: number) => Widget.Window({
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
});


export const clockBar = Widget.Window({
  name: "clockbar",
  className: "clockbar",
  visible: false,
  anchor: ['top'],
  keymode: "on-demand",
  layer: "top",
  margins: [10, 0],

  child: Widget.Box({
    class_name: "clockbar",
    vertical: true,
    spacing: 20,

    children: [Widget.Label({
      label: "Here's Everything to Know.",
      vpack: "start",
    }),

    Widget.Box({
      spacing: 20,

      children: [
        Widget.Box({
          vertical: true,
          hpack: "fill",
          hexpand: true,

          children: [
            Widget.Scrollable({
              hscroll: 'never',
              vscroll: 'automatic',
              visible: hasNotifications.bind(),
              child: notification_list,
              vexpand: true,
              vpack: "fill",
            }),

            Widget.CenterBox({
              vertical: true,
              vexpand: true,
              vpack: "fill",
              visible: hasNotifications.bind().as(value => value ? false : true),

              center_widget: Widget.Box({
                class_name: "empty-notifications",
                vertical: true,
                children: [
                  Widget.Label({
                    class_name: "empty-notifications-icon",
                    label: ""
                  }),

                  Widget.Label({
                    class_name: "empty-notifications",
                    label: "No Noti's"
                  })
                ],
              })
            }),

          ],
        }),

        Widget.Separator({ vertical: true }),

        Widget.Box({
          class_name: "right-side",
          spacing: 30,
          vertical: true,

          children: [
            Widget.Label({
              label: "To This Day!",
            }),

            Widget.Calendar({
              class_name: "calendar",
              showDayNames: true,
              showDetails: false,
              showHeading: true,
              showWeekNumbers: false,
              onDaySelected: ({ date: [y, m, d] }) => {
                print(`${y}. ${m}. ${d}.`)
              },
            }),

            Widget.Label("Insert-Random-Widget")

          ]
        })

      ],
    }),

    Widget.Label({
      label: "The End!",
      vpack: "end",
    })
    ],
  })
})

App.config({
  icons: "./assets",
  style: css,
  windows: [
    Bar(0),
    clockBar,
    NotificationPopups()
  ],
});

export { };

