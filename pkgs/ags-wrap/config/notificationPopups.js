import GLib from 'types/@girs/glib-2.0/glib-2.0';
import { Align } from 'types/@girs/gtk-3.0/gtk-3.0.cjs';

const notifications = await Service.import("notifications")

export const hasNotifications = Variable(false);

export const notification_list = Widget.Box({
    vertical: true,
    children: notifications.notifications.map(smallNotification),
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
                // n.dismiss()
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

/** @param {import('resource:///com/github/Aylur/ags/service/notifications.js').Notification} n */
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

    const time_string = Variable('', { // 5:30 vs 6:15
        poll: [1000, function () {
            const now = GLib.DateTime.new_now_local();
            const then = GLib.DateTime.new_from_unix_local(n.time);
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
                // n.dismiss()
            },
            hexpand: false,
            child: Widget.Label(label),
        })),
    })

    switch (n.app_name) {
        case "wallpaper":
        case "screenshot":
            return Widget.Box({
                attribute: { id: n.id },
                class_name: `small-notification ${n.urgency}`,
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
                    big_icon,
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
            break;
        case "discord":
            return Widget.Box({
                attribute: { id: n.id },
                class_name: `small-notification ${n.urgency}`,
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
            break;
        default:
            return Widget.Box({
                attribute: { id: n.id },
                class_name: `small-notification ${n.urgency}`,
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
            break;
    }
}

export function NotificationPopups(monitor = 0) {
    notifications.popupTimeout = 10000;
    notifications.forceTimeout = true;



    const list = Widget.Box({
        vertical: true,
        children: notifications.popups.map(Notification),
    })

    function onNotified(_, /** @type {number} */ id) {
        const n = notifications.getNotification(id)
        if (n) {
            list.children = [Notification(n), ...list.children]
        }
    }

    function onNotifiedList(_, /** @type {number} */ id) {
        const n = notifications.getNotification(id)
        if (n) {
            notification_list.children = [smallNotification(n), ...notification_list.children]
        }
    }

    function onDismissed(_, /** @type {number} */ id) {
        // list.children.find(n => n.attribute.id === id)?.destroy() // make noti invisible instead of destroying it.
    }

    function onClosed(_, /** @type {number} */ id) {
        notification_list.children.find(n => n.attribute.id === id)?.destroy()
        if (notification_list.children[0] == null) {
            hasNotifications.setValue(false)
        }


    }

    // list.hook(notifications, onNotified, "notified")
    // .hook(notifications, onDismissed, "dismissed")

    notification_list.hook(notifications, onNotifiedList, "notified")
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
            children: notifications.bind('popups').as(popups => popups.map(Notification)),
        }),
    })
}
