import "style/style"

import Bar from "widget/bar/Bar"
import Clock from "widget/clock/Clock";
import { NotificationPopups } from "./widget/notification/notification.js"

App.config({
  closeWindowDelay: {

  },
  windows: () => [
    Bar(),
    Clock(),
    NotificationPopups(),
  ],

  iconTheme: "Flat-Remix-Green-Dark",
});

