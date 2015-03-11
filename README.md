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