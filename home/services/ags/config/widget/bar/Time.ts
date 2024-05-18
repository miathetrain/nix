import { format } from 'date-fns'

export default () => Widget.EventBox({
  class_name: "date",
  hpack: "center",
  on_primary_click: () => {
    // if (clockBar.visible) {
    //   App.closeWindow("clockbar");
    // }
    // else {
    //   clockBar.visible = true;
    //   App.openWindow("clockbar")
    // }
  },
  child: Widget.Label({
    label: time.bind()
  })
})

const time = Variable('', {
  poll: [1000, function () {
    return format(new Date(), "HH:mm - MMM do");
  }],
});