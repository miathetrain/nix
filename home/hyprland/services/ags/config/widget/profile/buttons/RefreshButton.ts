export default () =>
  Widget.Button({
    class_name: "profile-small-button circular",
    tooltip_text: "Refresh",
    child: Widget.Icon({
      class_name: "profile-small-button-icon",
      icon: "view-refresh",
    }),
  });
