const battery = await Service.import('battery')

const divide = ([total, free]: string[]) => Number.parseInt(free) / Number.parseInt(total)
const cpu = Variable(0, {
  poll: [1000, 'pinfo cpu', out => divide(["100", out])],
})
const memory_usage = Variable(0.0, {
  poll: [1000, 'pinfo memory']
})
const memory_free = Variable(0, {
  poll: [1000, 'pinfo freememory']
})
const gpu_usage = Variable(0, {
  poll: [1000, 'pinfo gpu']
})
const gpu_memory = Variable(0, {
  poll: [1000, 'pinfo gpumemory']
})

const hostName = Utils.exec('hostname')

const batteryProgress = Widget.CircularProgress({
  visible: battery.bind('available'),
  value: battery.bind('percent').as(p => p > 0 ? p / 100 : 0),
  class_name: battery.bind('charging').as(ch => ch ? 'charging' : ''),
  css: 'min-width: 15px;'  // its size is min(min-height, min-width)
    + 'min-height: 15px;'
    + 'font-size: 4px;' // to set its thickness set font-size on it
    + 'background-color: #45475a;' // set its bg color
    + 'color: green;', // set its fg color
  startAt: 0.75,
  tooltip_text: battery.bind('percent').as(p => Math.round(p).toString())
})

export default () => Widget.Box({
  spacing: 10,
  css: 'background-color: #313244;'
    + 'border-radius: 20pt;'
    + 'min-width: 70pt;'
    + 'padding: 3pt;'
    + 'border: solid #1e1e2e 5px;',
  children: [
    Widget.CircularProgress({
      css: 'min-width: 15px;'  // its size is min(min-height, min-width)
        + 'min-height: 15px;'
        + 'font-size: 4px;' // to set its thickness set font-size on it
        + 'background-color: #45475a;' // set its bg color
        + 'color: #f38ba8;', // set its fg color
      startAt: 0.75,
      tooltip_text: cpu.bind().as(value => 'CPU Usage: ' + value.toString().replace("0.0", "").replace("0.", "") + '%'),
      value: cpu.bind(),
    }),

    Widget.CircularProgress({
      css: 'min-width: 15px;'  // its size is min(min-height, min-width)
        + 'min-height: 15px;'
        + 'font-size: 4px;' // to set its thickness set font-size on it
        + 'background-color: #45475a;' // set its bg color
        + 'color: #eba0ac;', // set its fg color
      startAt: 0.75,
      tooltip_text: memory_free.bind().as(value => 'Memory: ' + (Math.round(value * 100) / 100) + 'GB'),
      value: memory_usage.bind().as(value => Math.round(value * 100) / 100),
    }),

    Widget.CircularProgress({
      css: 'min-width: 15px;'  // its size is min(min-height, min-width)
        + 'min-height: 15px;'
        + 'font-size: 4px;' // to set its thickness set font-size on it
        + 'background-color: #45475a;' // set its bg color
        + 'color: #89b4fa;', // set its fg color
      startAt: 0.75,
      visible: (hostName == "dreamhouse"),
      tooltip_text: gpu_usage.bind().as(value => 'GPU Usage: ' + value.toString() + '%'),
      value: gpu_usage.bind().as(value => value / 100),
    }),

    Widget.CircularProgress({
      css: 'min-width: 15px;'  // its size is min(min-height, min-width)
        + 'min-height: 15px;'
        + 'font-size: 4px;' // to set its thickness set font-size on it
        + 'background-color: #45475a;' // set its bg color
        + 'color: #74c7ec;', // set its fg color
      startAt: 0.75,
      visible: (hostName == "dreamhouse"),
      tooltip_text: gpu_memory.bind().as(value => 'GPU Memory: ' + value.toString() + '%'),
      value: gpu_memory.bind().as(value => value / 100),
    }),

    batteryProgress
  ],
})