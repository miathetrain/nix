import { NotificationPopups, notification_list, hasNotifications } from "../notification/notification.js"

export default () => Widget.Window({
  name: "clockbar",
  className: "clockbar",
  visible: false,
  keymode: "exclusive",
  setup: self => self.keybind("Escape", () => {
    App.closeWindow("clockbar")
  }),
  anchor: ['top'],
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
            Widget.CenterBox({
              hpack: "fill",
              hexpand: true,
              start_widget: Widget.Label({
                hpack: "start",
                label: "Notifications",
                class_name: "notification-title"
              }),
              end_widget: Widget.Label({
                hpack: "end",
                label: "",
                class_name: "notification-clear"
              })
            }),
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