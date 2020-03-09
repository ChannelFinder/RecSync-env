## This is the ESS EPICS environment example
## Monday, March  9 12:57:59 PDT 2020

require iocStats,3.1.16
require recsync, 1.3.0-9705e52

epicsEnvSet("TOP", "$(E3_CMD_TOP)")

epicsEnvSet("IOC", "recsynctest")
epicsEnvSet("ENGINEER", "Jeong Han Lee")
epicsEnvSet("LOCATION", "Han's OFFICE")
epicsEnvSet("IOCNAME", $(IOC))

var(reccastTimeout, 5.0)
var(reccastMaxHoldoff, 5.0)


dbLoadRecords("reccaster.db", "P=$(IOC):RecSync-")

iocshLoad("$(iocStats_DIR)/iocStats.iocsh", "IOCNAME=$(IOC)")

iocInit()

dbl > "$(TOP)/../${IOCNAME}_PVs.list"
