#!/usr/bin/env python

#
# Quick hack to read tikitags
# based on MOBIB extractor:
# http://www.uclouvain.be/sites/security/mobib.html
#


from smartcard.System import readers
from smartcard.util import toHexString, toBytes
debug = 0

j = 0
r=readers()
#print "Readers List: %s" %r
for i in range(len(r)):
        if str(r[i]) == "ACS ACR 38U-CCID 00 00":
                        j = i

connection = r[j].createConnection()
connection.connect()

get_response = [0xFF, 0xC0, 00, 00]
antenna_power_on = toBytes("FF 00 00 00 04 D4 32 01 01")
antenna_power_off = toBytes("FF 00 00 00 04 D4 32 01 00")
set_retry_timer = toBytes("FF 00 00 00 06 D4 32 05 00 00")
polling = toBytes("FF 00 00 00 04 D4 4A 01 00") #ultralight
deselect_card = toBytes("FF 00 00 00 03 D4 44 01")

data,sw1,sw2 = connection.transmit(antenna_power_on)
if debug:
        print "Antenna Power On: %02x %02x" % (sw1,sw2)

data,sw1,sw2 = connection.transmit(set_retry_timer)
if debug:
        print "Set Retry Timer: %02x %02x" % (sw1,sw2)

data,sw1,sw2 = connection.transmit(polling)
if debug:
        print "Polling: %02x %02x" % (sw1,sw2)
if sw2 == 0x5:
        print "No tikitag on the reader"

else:
        data,sw1,sw2 = connection.transmit(get_response + [sw2])
        print ''.join(['%02x'% i for i in data])
        #print "tikitag: %02x %02x %02x %02x %02x %02x %02x" % (data[8],data[9],data[10],data[11],data[12],data[13],data[14])

data,sw1,sw2 = connection.transmit(deselect_card)
if debug:
        print "Deselect Card: %02x %02x" % (sw1,sw2)

data,sw1,sw2 = connection.transmit(antenna_power_off)
if debug:
        print "Antenna Power Off: %02x %02x" % (sw1,sw2)

exit()
