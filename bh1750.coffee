module.exports = (env) ->
  # Require the  bluebird promise library
  Promise = env.require 'bluebird'

  # Require the [cassert library](https://github.com/rhoot/cassert).
  assert = env.require 'cassert'
  
  declapi = env.require 'decl-api'
  t = declapi.types

  class BH1750Plugin extends env.plugins.Plugin

    init: (app, @framework, @config) =>
	
      deviceConfigDef = require("./device-config-schema")

      @framework.deviceManager.registerDeviceClass("BH1750Sensor", {
        configDef: deviceConfigDef.BH1750Sensor, 
        createCallback: (config, lastState) => 
          device = new BH1750Sensor(config, lastState)
          return device
      })
	  
  class LightIntensitySensor extends env.devices.Sensor

    attributes:
      temperature:
        description: "The measured light intensity"
        type: t.number
        unit: 'lux'
        acronym: 'lx'

    template: "temperature"	  
	  
  class BH1750Sensor extends LightIntensitySensor
    _temperature: null

    constructor: (@config, lastState) ->
      @id = config.id
      @name = config.name
      @_temperature = lastState?.temperature?.value
      BH1750 = require 'bh1750'
      @sensor = new BH1750({
        address: config.address,
        device: config.device,
        command: 0x10,
        length: 2
      });
      Promise.promisifyAll(@sensor)

      super()

      @requestValue()
      setInterval( ( => @requestValue() ), @config.interval)

    requestValue: ->
      @sensor.readLight( (value) =>
        #if value isnt @_temperature
          @_temperature = value
          @emit 'temperature', value
        #else
        #  env.logger.debug("Sensor value (#{value}) did not change.")
      #).catch( (error) =>
      #  env.logger.error(
      #    "Error reading BH1750Sensor with address #{@config.address}: #{error.message}"
      #  )
      #  env.logger.debug(error.stack)
      )

    getTemperature: -> Promise.resolve(@_temperature)

  # Create a instance and return it to the framework
  myPlugin = new BH1750Plugin
  return myPlugin
