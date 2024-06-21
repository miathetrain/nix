const audio = await Service.import('audio')

export default () => {
  const icons = {
    101: 'overamplified',
    67: 'high',
    34: 'medium',
    1: 'low',
    0: 'muted',
  }

  function getIcon() {
    const icon: any = audio.speaker.is_muted ? 0 : [101, 67, 34, 1, 0].find(
      threshold => threshold <= audio.speaker.volume * 100)

    return `audio-volume-${icons[icon]}-symbolic`
  }

  const icon = Widget.Icon({
    class_name: "icons",
    icon: Utils.watch(getIcon(), audio.speaker, getIcon),
    setup: self => self.hook(audio.speaker, () => {
      self.tooltip_text = Math.floor(audio.speaker.volume * 100) + "%"
    }),
  })

  const slider = Widget.Slider({
    hexpand: true,
    draw_value: false,
    on_change: ({ value }) => audio.speaker.volume = value,
    setup: self => self.hook(audio.speaker, () => {
      self.value = audio.speaker.volume || 0
      self.tooltip_text = Math.floor(audio.speaker.volume * 100) + "%"
    }),
  })

  return Widget.Box({
    class_name: 'volume',
    css: 'min-width: 130px',
    children: [icon, slider],
  })
}