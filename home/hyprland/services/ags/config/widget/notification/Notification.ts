import { Notification } from "resource:///com/github/Aylur/ags/service/notifications.js";
import { GLib } from "types/@girs/glib-2.0/glib-2.0";
import Gtk from "types/@girs/gtk-3.0/gtk-3.0";
import { Align } from "types/@girs/gtk-3.0/gtk-3.0.cjs";
import Revealer from "types/widgets/revealer";

const notifications = await Service.import("notifications")
const hyprland = await Service.import("hyprland")

export const hasNotifications = Variable(false);
export const notification_count = Variable(0);
export const doNotDisturb = Variable(false);

export const popups_widget = Widget.Box({
  vertical: true
})

export const notifications_widget = Widget.Box({
  vertical: true
});

export function totalNotifications(): number {
  return notifications.notifications.length
}

export function clearNotifications() {
  notifications.clear()
}

export function removeNotification(notification: Notification) {
  notification.close()
}

function NotificationIcon(notification: Notification) {
  const { image, app_icon, app_entry } = notification

  if (image) {
    return Widget.Box({
      css: `background-image: url("${image}");`
        + "background-size: cover;"
        + "background-repeat: no-repeat;"
        + "background-position: center;",
    })
  }

  let icon = "dialog-information-symbolic"
  if (Utils.lookUpIcon(app_icon))
    icon = app_icon

  if (app_entry && Utils.lookUpIcon(app_entry))
    icon = app_entry

  return Widget.Box({
    child: Widget.Icon({
      icon: icon,
      size: 48
    })
  })
}

function NotificationWidget(notification: Notification, small?: boolean) {

  const icon = Widget.Box({
    vpack: "start",
    child: NotificationIcon(notification),

    setup(self) {
      if (small) {
        self.class_name = "small-icon"
      } else {
        self.class_name = "icon"
      }
    },
  })

  const preview = Widget.Box({
    hpack: "start",
    class_name: "preview",
    child: NotificationIcon(notification),
  })

  const title = Widget.Label({
    xalign: 0,
    justification: "left",
    hexpand: true,
    max_width_chars: 24,
    truncate: "end",
    wrap: true,
    label: notification.summary,
    use_markup: true,

    setup(self) {
      if (small) {
        self.class_name = "small-title"
      } else {
        self.class_name = "title"
      }
    },
  })

  const body = Widget.Label({
    hexpand: true,
    use_markup: true,
    xalign: 0,
    justification: "left",
    label: notification.body,
    wrap: true,

    setup(self) {
      if (small) {
        self.class_name = "small-body"
      } else {
        self.class_name = "body"
      }
    },
  })

  const actions = Widget.Box({
    setup(self) {
      if (small) {
        self.class_name = "small-actions"
        self.children = notification.actions.map(({ id, label }) => Widget.Button({
          class_name: "small-action-button",
          on_clicked: () => {
            notification.invoke(id)
          },
          hexpand: false,
          child: Widget.Label(label),
        }))
      } else {
        self.class_name = "actions"
        self.children = notification.actions.map(({ id, label }) => Widget.Button({
          class_name: "action-button",
          on_clicked: () => {
            notification.invoke(id)
          },
          hexpand: true,
          child: Widget.Label(label),
        }))
      }
    },
  })

  if (small) {

    const time_string = Variable('', {
      poll: [1000, function () {
        const now = GLib.DateTime.new_now_local();
        const then = GLib.DateTime.new_from_unix_local(notification.time);
        const hour_diff = Math.round(now.get_hour() - then.get_hour());
        const minutes_diff = Math.round(now.get_minute() - then.get_minute());

        const s1 = hour_diff > 0 ? hour_diff + " Hour(s)" : "";
        const s2 = minutes_diff > 0 ? minutes_diff + " Minute(s)" : "";
        const s3 = ((hour_diff > 0 || minutes_diff > 0) ? "  " : "") + s1 + s2 + ((hour_diff > 0 || minutes_diff > 0) ? " ago." : "");
        return s3;
      }],
    });

    const time = Widget.Label({
      class_name: "small-time",
      justification: "left",
      label: time_string.bind(),
    })

    const dismiss = Widget.EventBox({
      hpack: "end",
      hexpand: true,
      halign: Align.END,
      child: Widget.Label({
        label: " ",
        tooltip_text: "Dismiss Notification"
      }),

      "on-primary-click": () => {
        notification.close();
      }
    })

    switch (notification.app_name) {
      case "Spotify":
        return Widget.Revealer({
          revealChild: false,
          transitionDuration: 500,
          transition: 'slide_down',
          attribute: { id: notification.id, hint: "spotify" },
          setup: (self) => {
            Utils.timeout(500, () => {
              self.reveal_child = true;
            })
          },
          child: Widget.Box({
            class_name: `small-notification ${notification.urgency}`,
            children: [
              icon,
              Widget.Box({
                vertical: true,
                spacing: 5,
                children: [
                  Widget.Box({
                    spacing: 10,
                    children: [title, time, dismiss]
                  }),
                  body,
                  actions
                ],
              })
            ],
          })
        })
        break;
      case "wallpaper":
      case "screenshot":
        return Widget.Revealer({
          revealChild: false,
          transitionDuration: 500,
          transition: 'slide_down',
          attribute: { id: notification.id, hint: notification.hints['hint']?.get_string()[0] },
          setup: (self) => {
            Utils.timeout(500, () => {
              self.reveal_child = true;
            })
          },
          child: Widget.Box({
            class_name: `small-notification ${notification.urgency}`,
            vertical: true,
            spacing: 14,
            children: [
              Widget.Box({
                vertical: true,
                children: [
                  Widget.Box({
                    spacing: 5,
                    children: [title, time, dismiss]
                  }),
                  body
                ],
              }),
              preview,
              Widget.Box({
                class_name: "small-actions",
                children: [
                  Widget.Button({
                    class_name: "small-action-button",
                    on_clicked: () => {

                      //
                    },
                    hexpand: false,
                    child: Widget.Label("Copy to Clipboard"),
                  })],
              })
            ]
          })
        })
        break;
      case "discord":
        return Widget.Revealer({
          revealChild: false,
          transitionDuration: 500,
          transition: 'slide_down',
          attribute: { id: notification.id },
          setup: (self) => {
            Utils.timeout(500, () => {
              self.reveal_child = true;
            })
          },
          child: Widget.Box({
            attribute: { id: notification.id },
            class_name: `small-notification ${notification.urgency}`,
            children: [
              icon,
              Widget.Box({
                vertical: true,
                spacing: 5,
                children: [
                  Widget.Box({
                    spacing: 10,
                    children: [title, time, dismiss]
                  }),
                  body,
                  Widget.Box({
                    class_name: "small-actions",
                    children: [
                      Widget.Button({
                        class_name: "small-action-button",
                        on_clicked: () => {
                          hyprland.messageAsync(`dispatch workspace 3`)
                          // switch to discord
                        },
                        hexpand: false,
                        child: Widget.Label("View"),
                      })],
                  })
                ],
              })
            ],
          })
        })
        break;
      default:
        return Widget.Revealer({
          revealChild: false,
          transitionDuration: 500,
          transition: 'slide_down',
          attribute: { id: notification.id, hint: notification.hints['hint']?.get_string()[0] },
          setup: (self) => {
            Utils.timeout(500, () => {
              self.reveal_child = true;
            })
          },
          child: Widget.Box({
            attribute: { id: notification.id },
            class_name: `small-notification ${notification.urgency}`,
            children: [
              icon,
              Widget.Box({
                vertical: true,
                spacing: 5,
                children: [
                  Widget.Box({
                    spacing: 10,
                    children: [title, time, dismiss]
                  }),
                  body,
                  actions
                ],
              })
            ],
          })
        })
        break;
    }
  } else {

    switch (notification.app_name) {
      case "Spotify":
        return Widget.Revealer({
          revealChild: false,
          transitionDuration: 500,
          transition: 'slide_down',
          attribute: { id: notification.id, hint: "spotify" },
          setup: (self) => {
            Utils.timeout(500, () => {
              self.reveal_child = true;
            })
          },
          child: Widget.EventBox({
            on_primary_click: notification.dismiss,
            child: Widget.Box(
              {
                class_name: `notification ${notification.urgency}`,
                vertical: true,
              },
              Widget.Box([
                icon,
                Widget.Box(
                  { vertical: true },
                  title,
                  body,
                ),
              ]),
              actions,
            )
          })
        })
      default:
        return Widget.Revealer({
          revealChild: false,
          transitionDuration: 500,
          transition: 'slide_down',
          attribute: { id: notification.id, hint: notification.hints['hint']?.get_string()[0] },
          setup: (self) => {
            Utils.timeout(500, () => {
              self.reveal_child = true;
            })
          },
          child: Widget.EventBox({
            on_primary_click: notification.dismiss,
            child: Widget.Box(
              {
                class_name: `notification ${notification.urgency}`,
                vertical: true,
              },
              Widget.Box([
                icon,
                Widget.Box(
                  { vertical: true },
                  title,
                  body,
                ),
              ]),
              actions,
            )
          })
        })
    }
  }
}

export function NotificationPopups(monitor = 0) {
  notifications.popupTimeout = 10000;

  function onNotified(_, id: number) {
    const notificationInstance = notifications.getNotification(id)
    if (notificationInstance != null) {
      notification_count.setValue(notification_count.value + 1);

      const hint = notificationInstance.hints['hint']?.get_string()[0]

      if (hint && hint != "") {
        for (var n of notifications.notifications) {
          const h = n.hints['hint']?.get_string()[0]
          if (h && h != "") {
            n.close()
          }
        }
      }

      popups_widget.children = [...popups_widget.children, NotificationWidget(notificationInstance)]
      notifications_widget.children = [...notifications_widget.children, NotificationWidget(notificationInstance)]
    }
  }

  type Popup = {

  }

  function onDismissed(_, id: number) {
    const notificationInstance = notifications.getNotification(id)
    if (notificationInstance != null) {
      try {
        const child = popups_widget.children.find(n => n.attribute.id === id)


        Widget.Revealer

        if (child != null) {

          // @ts-ignore
          child.transition = "slide_right"
          // @ts-ignore
          child.transitionDuration = 1000
          // @ts-ignore
          child.revealChild = false
          Utils.timeout(1000, () => {
            child.destroy()
          })
        }
      } catch (exception) {

      }
    }
  }

  function onClosed(_, /** @type {number} */ id) {
    // @ts-ignore
    notifications_widget.children.find(n => n.attribute.id === id)?.destroy()

    // @ts-ignore
    list.children.find(n => n.attribute.id === id)?.destroy()
    if (notifications_widget.children[0] == null) {
      hasNotifications.setValue(false)
    }
  }

  popups_widget.hook(notifications, onDismissed, "dismissed")

  notifications_widget.hook(notifications, onNotified, "notified")
  notifications_widget.hook(notifications, onClosed, "closed")

  return Widget.Window({
    monitor,
    name: `notifications${monitor}`,
    class_name: "notification-popups",
    layer: "overlay",
    anchor: ["top", "right"],
    child: Widget.Box({
      css: "min-width: 2px; min-height: 2px;",
      class_name: "notifications",
      vertical: true,
      child: popups_widget,
    }),
  })


}

