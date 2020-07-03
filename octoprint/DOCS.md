# Documentation

## Access

There is a default user created called `homeassistant`, this is for access through Ingress. The password is randomized at first launch.

In order to access OctoPrint without Ingress, specify a port in the port section of the addon.

## Camera support?

Everything should now be in place for camera support. In the options for the addon you can specify input and parameters for mjpg-streamer.
In order to access the camera stream you have to specify a port in the port section of the addon, Ingress is not supported for the video stream. You can either expose OctoPrint UI (5000) and use /webcam/ in the URL, or only expose mjpg-streamer (8080).
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
