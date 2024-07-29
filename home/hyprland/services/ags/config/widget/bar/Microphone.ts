const audio = await Service.import("audio");

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

const is_muted = audio["microphone"].bind("is_muted");

export default () =>
  Widget.EventBox({
    "on-primary-click": () => {
      Utils.exec(
        "swayosd-client --input-volume mute-toggle && canberra-gtk-play -i audio-volume-change"
      );
    },
    visible: recording_mic.bind(),
    child: Widget.Label({
      tooltip_text: recording_mic.bind().as((value) => {
        if (value) return "Your Mic is currently being recorded.";
        return "";
      }),
      label: is_muted.as((value) => {
        if (value) return "";
        return "";
      }),
    }),
  });
