import GLib from 'types/@girs/glib-2.0/glib-2.0';
import { Align } from 'types/@girs/gtk-3.0/gtk-3.0.cjs';

const notifications = await Service.import("notifications")

export const hasNotifications = Variable(false);

export const notification_list = Widget.Box({
    vertical: true,
    children:
        notifications.notifications.map(Notification)
    ,
});

/** @param {import('resource:///com/github/Aylur/ags/service/notifications.js').Notification} n */
function NotificationIcon({ app_entry, app_icon, image }) {
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

/** @param {import('resource:///com/github/Aylur/ags/service/notifications.js').Notification} n */
function Notification(n) {
    const icon = Widget.Box({
        vpack: "start",
        class_name: "icon",
        child: NotificationIcon(n),
    })

    const title = Widget.Label({
        class_name: "title",
        xalign: 0,
        justification: "left",
        hexpand: true,
        max_width_chars: 24,
        truncate: "end",
        wrap: true,
        label: n.summary,
        use_markup: true,
    })

    const body = Widget.Label({
        class_name: "body",
        hexpand: true,
        use_markup: true,
        xalign: 0,
        justification: "left",
        label: n.body,
        wrap: true,
    })

    const actions = Widget.Box({
        class_name: "actions",
        children: n.actions.map(({ id, label }) => Widget.Button({
            class_name: "action-button",
            on_clicked: () => {
                n.invoke(id)
                n.dismiss()
            },
            hexpand: true,
            child: Widget.Label(label),
        })),
    })

    return Widget.EventBox(
        {
            attribute: { id: n.id },
            on_primary_click: n.dismiss,
        },
        Widget.Box(
            {
                class_name: `notification ${n.urgency}`,
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
        ),
    )
}

function smallNotification(n) {
    if (hasNotifications.value == false)
        hasNotifications.setValue(true)

    const icon = Widget.Box({
        vpack: "start",
        class_name: "small-icon",
        child: NotificationIcon(n),
    })

    const big_icon = Widget.Box({
        hpack: "start",
        class_name: "big-small-icon",
        child: NotificationIcon(n),
    })

    const title = Widget.Label({
        class_name: "small-title",
        xalign: 0,
        justification: "left",
        max_width_chars: 24,
        truncate: "end",
        wrap: true,
        label: n.summary,
        use_markup: true,
    })

    const time = Widget.Label({
        class_name: "small-time",
        justification: "left",
        label: GLib.DateTime.new_from_unix_local(n.time).get_minute() + ' minutes ago.'
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
            n.close();
        }

    })

    const body = Widget.Label({
        class_name: "small-body",
        hexpand: true,
        use_markup: true,
        xalign: 0,
        justification: "left",
        label: n.body,
        wrap: true,
    })

    const actions = Widget.Box({
        class_name: "small-actions",
        children: n.actions.map(({ id, label }) => Widget.Button({
            class_name: "small-action-button",
            on_clicked: () => {
                n.invoke(id)
                n.dismiss()
            },
            hexpand: true,
            child: Widget.Label(label),
        })),
    })

    switch (n.app_name) {
        case "wallpaper":
        case "screenshot":
            return Widget.EventBox({
                attribute: { id: n.id },
                class_name: "small-box",
                child: Widget.Box({
                    class_name: `small-notification ${n.urgency}`,
                    vertical: true,
                    spacing: 5,
                    children: [
                        Widget.Box([
                            Widget.Box(
                                { vertical: true },
                                Widget.Box({
                                    spacing: 20,
                                }, title, time, dismiss),
                                body

                            ),
                        ]),

                        big_icon
                    ]
                })
            })
        default:
            return Widget.EventBox({
                attribute: { id: n.id },
                class_name: "small-box",
                child: Widget.Box({
                    class_name: `small-notification ${n.urgency}`,
                    vertical: true,
                    children: [
                        Widget.Box([
                            icon,
                            Widget.Box(
                                { vertical: true },
                                Widget.Box({
                                    spacing: 20,
                                }, title, time, dismiss),
                                body,
                            ),
                        ])
                    ]
                })
            })
    }
}

export function NotificationPopups(monitor = 0) {
    notifications.forceTimeout = true;



    const list = Widget.Box({
        vertical: true,
        children: notifications.popups.map(Notification),
    })

    function onNotified(_, /** @type {number} */ id) {
        const n = notifications.getNotification(id)
        if (n) {
            list.children = [Notification(n), ...list.children]
            // @ts-ignore
            notification_list.children = [smallNotification(n), ...notification_list.children]
        }
    }

    function onDismissed(_, /** @type {number} */ id) {
        list.children.find(n => n.attribute.id === id)?.destroy()
    }

    function onClosed(_, /** @type {number} */ id) {
        // notification_list.children.find(n => n.attribute.id === id)?.destroy()s
    }

    list.hook(notifications, onNotified, "notified")
    list.hook(notifications, onDismissed, "dismissed")

    notification_list.hook(notifications, onClosed, "closed")

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
            child: list,
        }),
    })
}
