import { format } from 'date-fns'
import { notification_count } from "../notification/notification.js"

var visible = false;

const time = Variable('', {
  poll: [1000, function () {
    return format(new Date(), "HH:mm — EEEE"); // MMM do
  }],
});

const tooltip = Variable('', {
  poll: [1000, function () {
    return format(new Date(), "MMMM 'the' do"); //January the 14th
  }],
});

export default () => Widget.EventBox({
  class_name: "date",
  on_primary_click: () => {
    if (visible) {
      visible = false;
      App.closeWindow("clockbar");
    }
    else {
      notification_count.setValue(0);
      visible = true;
      App.openWindow("clockbar")
    }
  },
  child: Widget.Label({
    label: time.bind(),
    tooltip_text: tooltip.bind()
  })
})