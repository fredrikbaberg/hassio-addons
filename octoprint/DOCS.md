# Documentation

## Access

There is a default user created called `homeassistant`, this is for access through Ingress. The password is randomized at first launch.

In order to access OctoPrint without Ingress, specify a port in the port section of the addon.

## Camera support?

Everything should now be in place for basic camera support. In the options for the addon you can specify input and parameters for mjpg-streamer.
In order to access the camera stream you have to specify a port in the port section of the addon, the stream does not work through Ingress. You can either expose only the stream (8000) or full OctoPrint UI (5000) and use /webcam/ in the URL.
Note that for screenshots you do not need to open any ports!
You may have to do some additional configuration for it to work, the following excerpt from config.yaml may be helpful:

```
system:
    actions:
    -   action: mjpgstart
        command: supervisorctl start mjpg-streamer
        name: Start mjpg-streamer
    -   action: mjpgstop
        command: supervisorctl stop mjpg-streamer
        name: Stop mjpg-streamer
webcam:
    ffmpeg: /usr/bin/ffmpeg
    snapshot: http://localhost:8080/?action=snapshot
    stream: http://<device IP address>:5000/webcam/?action=stream
```

## FAQ

- `pip` is not found?
  - Try to refresh the page, or restart the Add-On.
- I have multiple devices connected, ttyUSB0 is not always the correct device?
  - Try to specify the device ID. In Home Assistant this can be found under "Supervisor" - "System" - "Hardware" `/dev/serial/by-id/usb-...`
- There is no webcam stream?
  - Are you accessing through Ingress? Right now it does not seem possible to have the video stream available through Ingress.
  - Is mjpg-streamer running? You can launch it from OctoPrint UI, it´s in the same menu used to restart OctoPrint.
- How do I get Raspberry Pi camera to work on Home Assistant?
  - Probably not recommended, but based on [https://raspberrypi.stackexchange.com/a/51440](https://raspberrypi.stackexchange.com/a/51440) I did the steps related to `start_x.elf` and `fixup_x.dat`. Note that I skipped the `gpu_mem`, `apk`, `modprobe` and `v4l2-ctl` parts.