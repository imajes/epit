###!/usr/bin/env ruby

require 'rubygems'
require 'usb'

USB_RT_PORT = USB::USB_TYPE_CLASS | USB::USB_RECIP_OTHER
USB_PORT_FEAT_POWER = 8

rdr = USB.devices[7]

#p rdr.configurations.first.settings.first.methods.sort

rdr.open { |h|
  bytes = "                                    "
  h.usb_get_string_simple(0, bytes)
  p bytes
}