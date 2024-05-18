import "/style/style"

import Bar from "widgets/bar/Bar"

App.config({
  closeWindowDelay: {

  },
  windows: () => [
    Bar()
  ],
});

