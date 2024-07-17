import InternetButton from "./buttons/InternetButton"

export default () => Widget.Window({
    name: "profile",
    class_name: "transparent",
    visible: false,
    keymode: "exclusive",
    setup: self => self.keybind("Escape", () => {
        App.closeWindow("profile")
    }),
    anchor: ['top', 'right'],
    layer: "top",
    margins: [10, 0],

    child: Widget.Box({
        class_name: "profile",
        spacing: 20,
        vertical: true,
        children: [
            Widget.CenterBox({
                start_widget: Widget.Box({
                    spacing: 5,
                    children: [
                        Widget.Box({
                            class_name: "profile-pfp",
                            hexpand: false,
                            hpack: "center",
                            vexpand: false,
                            vpack: "center",
                            child: Widget.Box({
                                class_name: "profile-pfp",
                                css: `background-image: url("/home/mia/.face");`
                                    + "background-size: cover;"
                                    + "background-repeat: no-repeat;"
                                    + "background-position: center;",
                            })
                        }),
                        Widget.Box({
                            spacing: 2,
                            class_name: "battery",
                            children: [Widget.Label({ class_name: "battery-icon", label: "󰂊" }), Widget.Label({ class_name: "battery-text", label: "56% - 1:54 until full" })]
                        })]
                }),

                end_widget: Widget.Box({
                    spacing: 5,
                    hpack: "end",
                    children: [
                        button("󰑓", "Reload Hyprland", true),
                        button("", "Lock", true),
                        button("⏻", "Power", true)
                    ]
                })
            }),

            Widget.Box({
                spacing: 30,
                hpack: "center",
                vexpand: false,
                children: [InternetButton(), button(), button(), button()]
            }),

            Widget.Box({
                spacing: 30,
                children: [button("󰖩", "Wi-Fi"), button(), button(), button()]
            }),

            Widget.Box({
                class_name: "profile-slider-volume",
                hpack: "fill",
                hexpand: true,
                children: [Widget.Label(""), Widget.Slider({
                    onChange: ({ value }) => print(value),
                    hexpand: true,
                    value: 50,
                    min: 0,
                    max: 100,
                    marks: [0.1],
                })]
            }),

            Widget.Box({
                class_name: "profile-slider-brightness",
                hpack: "fill",
                hexpand: true,
                children: [Widget.Label("󰃠"), Widget.Slider({
                    onChange: ({ value }) => print(value),
                    hexpand: true,
                    value: 70,
                    min: 0,
                    max: 100,
                    marks: [0.5],
                })]
            })
        ]
    })
})

function button(icon = "dialog-information-symbolic", tooltip = "", small = false) {
    if (small) {
        return Widget.Button({
            class_name: "profile-small-button circular",
            tooltip_text: tooltip,
            child: Widget.Icon({ class_name: "profile-small-button-icon", icon: icon })
        })
    } else {
        return Widget.ToggleButton({
            class_name: "profile-normal-button circular",
            tooltip_text: tooltip,
            child: Widget.Icon({ class_name: "profile-normal-button-icon", icon: icon })
        })
    }
}