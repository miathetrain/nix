import { notification_list, hasNotifications, countNotifications, clearNotifications } from "../notification/notification.js"

export default () => Widget.Window({
  name: "clockbar",
  class_name: "transparent",
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
                class_name: "notification-title",
                tooltip_text: "Notifications show below.",
              }),
              end_widget: Widget.EventBox({
                "on-primary-click": (event) => {
                  clearNotifications()
                },
                child: Widget.Label({
                  hpack: "end",
                  label: " ",
                  class_name: "notification-clear",
                  tooltip_text: "Clear notifications. (" + countNotifications() + ")"
                })
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
                    label: "No Notifications"
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