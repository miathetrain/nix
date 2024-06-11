import { Align } from "types/@girs/gtk-3.0/gtk-3.0.cjs"
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
    spacing: 20,

    children: [
      Widget.Box({
        vertical: true,
        spacing: 20,

        children: [


          Widget.Box({
            hpack: "baseline",
            hexpand: true,

            children: [
              Widget.Box({
                hpack: "start",
                halign: Align.START,
                spacing: 20,
                children: [

                  Widget.Label({ label: "Do Not Disturb" }),

                  Widget.Switch({
                    onActivate: ({ active }) => print(active),
                  }),
                ]
              }),

              Widget.Box({
                hpack: "end",
                halign: Align.END,
                child: Widget.EventBox({
                  hpack: "end",

                  "on-primary-click": (event) => {
                    clearNotifications()
                  },
                  child: Widget.Label({
                    label: " ",
                    class_name: "notification-clear",
                    tooltip_text: "Clear notifications. (" + countNotifications() + ")"
                  })
                })
              })
            ]
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

    ]
  })
})