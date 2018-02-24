# README #

### Install ###

cordova plugin add https://github.com/retailos/cordova-plugin-barcode-scanner.git

### Uninstall ###

cordova plugin remove com.redant.barcodescanner

### JS Call ###

```
scanner.scan(function(val) {
    console.log(val);
}, function(err) {
    console.log(err);
});
```

### Example Response ###
```
{
    "event": {
        "type": "ERROR",
        "message": "The error message"
    }
}
```
```
{
    "event": {
        "type": "SCANNED",
        "message": "Z1189081460GB"
    }
}
```

### Event types ###
* SCANNED
* ERROR
* CONNECTED
* DISCONNECTED
