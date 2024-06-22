export default () => Widget.EventBox({
  "on-primary-click": () => {
    Utils.exec('systemctl --user start swww-random-img.service')
  },
  child: Widget.Label({
    label: '󰸉 ',
    tooltip_text: 'Change wallpaper'
  })
})