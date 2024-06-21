import { format } from 'date-fns'

var visible = false;

export default () => Widget.EventBox({
  class_name: "date",
  on_primary_click: () => {
    if (visible) {
      visible = false;
      App.closeWindow("clockbar");
    }
    else {
      visible = true;
      App.openWindow("clockbar")
    }
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