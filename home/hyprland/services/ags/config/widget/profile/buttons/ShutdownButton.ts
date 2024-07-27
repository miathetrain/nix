export default () =>
  Widget.Button({
    class_name: "profile-small-button circular",
    tooltip_text: "Shutdown",
    child: Widget.Icon({
      class_name: "profile-small-button-icon",
      icon: "system-shutdown",
    }),
  });
