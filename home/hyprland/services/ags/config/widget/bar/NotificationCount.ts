import { notification_count, doNotDisturb } from "../notification/notification.js"

function update_label(count: number, dnd: boolean): string {
  const icons = ["󰂚", "󱅫", "󰂛"];

  if (dnd) {
    return icons[2] + ` (${count})`;
  }
  else if (count == 0) {
    return icons[0] + ` (${count})`;
  }
  else {
    return icons[1] + ` (${count})`;
  }
}

export default () => Widget.Label({
  label: update_label(0, false),

  setup(self) {
    notification_count.connect('changed', ({value}) => {
      self.label = update_label(value, doNotDisturb.value)
    })

    doNotDisturb.connect('changed', ({value}) => {
      self.label = update_label(notification_count.value, value)
    })
  }
})