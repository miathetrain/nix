const hyprland = await Service.import("hyprland")
import { NotificationPopups } from "./notificationPopups.js"
import { format } from 'date-fns'

const mpris = await Service.import('mpris')
const audio = await Service.import('audio')
const notifications = await Service.import('notifications');
const notif = notifications.bind("popups");

// main scss file
const scss = `${App.configDir}/css/style.scss`

// target css file
const css = `/tmp/my-style.css`

// make sure sassc is installed on your system
Utils.exec(`sassc ${scss} ${css}`)

Utils.monitorFile(
  // directory that contains the scss files
  `${App.configDir}/css`,

  // reload function
  function () {
    // main scss file
    const scss = `${App.configDir}/css/style.scss`

    // target css file
    const css = `/tmp/my-style.css`

    // compile, reset, apply
    Utils.exec(`sassc ${scss} ${css}`)
    App.resetCss()
    App.applyCss(css)
  },
)

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
  child: Widget.Label({
    label: time.bind()
  })
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
    Widget.Label({
      label: time.bind()
    })]
})

/** @param {import('resource:///com/github/Aylur/ags/service/notifications.js').Notification} n */
const NotificationIcon = ({ app_entry, app_icon, image }) => {
  if (image) {
    return Widget.Box({
      css: `
                background-image: url("${image}");
                background-size: contain;
                background-repeat: no-repeat;
                background-position: center;
            `,
    });
  }

  let icon = 'dialog-information-symbolic';
  if (Utils.lookUpIcon(app_icon))
    icon = app_icon;

  if (app_entry && Utils.lookUpIcon(app_entry))
    icon = app_entry;

  return Widget.Icon(icon);
};

const Notification = n => {

  // @ts-ignore
  const icon = Widget.Box({
    vpack: 'start',
    class_name: 'icon',
    child: NotificationIcon(n),
  });

  const title = Widget.Label({
    class_name: 'title',
    xalign: 0,
    justification: 'center',
    hexpand: true,
    max_width_chars: 24,
    truncate: 'end',
    wrap: true,
    label: n.summary,
    use_markup: true,
  });

  const body = Widget.Label({
    class_name: 'body',
    hexpand: true,
    use_markup: true,
    xalign: 0,
    justification: 'left',
    label: n.body,
    wrap: true,
  });

  const actions = Widget.Box({
    class_name: 'actions',
    children: n.actions.map(({ id, label }) => Widget.Button({
      class_name: 'action-button',
      on_clicked: () => n.invoke(id),
      hexpand: true,
      child: Widget.Label(label),
    })),
  });

  return Widget.EventBox({
    child: Widget.Box({
      class_name: `notification ${n.urgency}`,
      vertical: true,
      children: [
        Widget.Box({
          children: [
            icon,
            Widget.Box({
              vertical: true,
              children: [
                title,
                body,
              ],
            }),
          ],
        }),
        actions,
      ],
    }),
  });
};

const Bar = (monitor: number) => Widget.Window({
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

const InfoBar = Widget.Window({
  name: 'infobar',
  anchor: ['top'],
  layer: "overlay",
  child: Widget.Box({
    class_name: 'infobar',
    css: 'padding: 1px;',
    vertical: true,
    children: notif.as(gay => gay.map(Notification)),
  }),
});

App.config({
  icons: "./assets",
  style: css,
  windows: [
    Bar(0),
    // InfoBar,
    // notificationPopup
  ],
});

App.addIcons(`${App.configDir}/assets`);

export { };

