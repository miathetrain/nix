import GLib from 'gi://GLib'

export default () => Widget.EventBox({
  "on-primary-click": () => {
    const systemctl = GLib.find_program_in_path("systemctl")
    Utils.notify('Test', systemctl!)
    Utils.execAsync(`systemctl --user start swww-random-img.service`)
  },
  child: Widget.Label({
    label: '󰸉 ',
    tooltip_text: 'Change wallpaper'
  })
})