# README #

### Install ###

cordova plugin add https://bitbucket.org/retailos/barcodescanner

### Uninstall ###

cordova plugin remove com.redant.barcodescanner

### Response ###

Event types:
* SCANNED
* ERROR
* CONNECTED
* DISCONNECTED

### Example Response ###
```
{
    "event": {
        "type": "ERROR",
        "message": "The error message"
    }
}
```