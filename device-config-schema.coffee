module.exports = {
  title: "pimatic-bh1750 device config schemas"
  BH1750Sensor: {
    title: "BH1750Sensor config options"
    type: "object"
    extensions: ["xLink"]
    properties:
      device:
        description: "device file to use, for example /dev/i2c-0"
        type: "string"
        default: "/dev/i2c-1"
      address:
        description: "the address of the sensor"
        type: "string"
        default: "0x23"
      command:
        description:"Command (resolution; measurement time); 
                     0x10 (1lx; 120ms); 0x11 (0.5lx; 120ms); 0x13 (4lx; 16ms); default: 0x10"
        type: "string"
        default: "0x10"
      interval:
        interval: "Interval in ms so read the sensor"
        type: "integer"
        default: 10000
  }
}
