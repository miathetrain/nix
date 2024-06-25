import { notification_list, hasNotifications, countNotifications, clearNotifications, doNotDisturb, notification_count } from "../notification/notification.js"
import { format } from 'date-fns'

const day = Variable('', {
  poll: [1000, function () {
    return format(new Date(), "h 'o''clock'");
  }],
});

const daydesc = Variable('', {
  poll: [1000, function () {
    return format(new Date(), "BBBB");
  }],
});

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

          Widget.CenterBox({
            hexpand: true,

            start_widget: Widget.Box({
              spacing: 5,
              children: [

                Widget.Label({ label: "Do Not Disturb" }),

                Widget.Switch({
                  onActivate: ({ active }) => {
                    doNotDisturb.setValue(active);
                  },
                }),
              ]
            }),

            end_widget: Widget.EventBox({
              hpack: "end",
              "on-primary-click": (event) => {
                clearNotifications()
              },

              child: Widget.Label({
                label: " ",
                class_name: "notification-clear",
                tooltip_text: notification_count.bind().as((count) => `Clear notifications. (${count})`)
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

          Widget.Box({
            vertical: true,
            children: [
              Widget.Label({
                label: day.bind(),
              }),
              Widget.Label({
                label: daydesc.bind(),
              })
            ]
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