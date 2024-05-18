import "style/style"

import Bar from "widget/bar/Bar"

App.config({
  closeWindowDelay: {

  },
  windows: () => [
    Bar()
  ],
});

