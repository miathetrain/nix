export default () => Widget.Window({
    name: "profile",
    class_name: "transparent",
    visible: false,
    keymode: "exclusive",
    setup: self => self.keybind("Escape", () => {
        App.closeWindow("clockbar")
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
                    children: [Widget.Button({ label: "Pfp" }), Widget.Button({ label: "Battery" })]
                })
            })
        ]
    })
})