const sharing_screen = Variable(true);

export default () =>
  Widget.ToggleButton({
    class_name: "profile-normal-button circular",
      tooltip_text: sharing_screen.bind().as(value => {
          if (value)
              return "Sharing Screen"
          return "Not Sharing Screen"
    }),
    active: sharing_screen.bind(),
    child: Widget.Icon({
      class_name: "profile-normal-button-icon",
    }),
  });
