const audio = await Service.import('audio')

const recording_mic = Variable(false, {
  poll: [
    1000,
    "pinfo mic",
    (out) => {
      print(out);
      if (out == "true") return true;
      return false;
    },
  ],
});

const is_muted = audio.microphone.stream?.isMuted

const widget = Widget.ToggleButton({
  class_name: "indicator circular",
  tooltip_text: recording_mic.bind().as((value) => {
    if (value) return "Your Mic is currently being recorded. Muted?" + is_muted;
    return "";
  }),
  active: recording_mic.bind(),
  child: Widget.Label({
    class_name: "profile-normal-button-label",
    label: "",
  }),
});

widget.set_sensitive(false);

export default () => widget;
