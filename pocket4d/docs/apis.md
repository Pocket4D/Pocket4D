# APIs
---
## Basic
### Life Cycles
### Updates
### Timers
### Application Events
### Enviorment
---
## Networking
### HTTP
#### p4d.request
To make a Http Request
##### Gramma
```typescript
p4d.request(options)
``` 
##### Params
| Properties   | Type                     | Default Value                          | Required? | Description                                     | Min Version |
| :----------- | :----------------------- | :------------------------------------- | :-------- | :---------------------------------------------- | :---------- |
| url          | string                   | --                                     | yes       | Request url                                     | 1.0.0       |
| header       | object                   | `{"content-type": "application/json"}` | no        | Request header                                  | 1.0.0       |
| method       | string                   | `get`                                  | no        | Request method, support POST/GET                | 1.0.0       |
| data         | object/array/arraybuffer | --                                     | no        | Request paramaters                              | 1.0.0       |
| dataType     | string                   | `json`                                 | no        | Expected dataType returns, support json/string  | 1.0.0       |
| responseType | string                   | `text`                                 | no        | Expected responseType ,support text/arrayBuffer | 1.0.0       |
| success      | function                 | --                                     | no        | Callback Function when request is successful    | 1.0.0       |
| fail         | function                 | --                                     | no        | Callback Function when request is failed        | 1.0.0       |
| complete     | function                 | --                                     | no        | Callback Function when request is completed     | 1.0.0       |


#### Example
```typescript

p4d.request({
    url: 'http://someUrl',
    data: {},
    header: {},
    method: 'get',
    success: function (response) {
        //do with success
    },
    fail: function (error) {
        // do with error
    },
    complete: function () {
        // do with complete
    },
});

```




### WebSocket
---
## Media
### Image
### Recorder
### Audio
### Video
---
## Map
---
## File
---
## Open Interface
### Login
### Wallet
### AD
### Jump To
### Share
### Setting
### Authorization
### Data Analytics
### Subscribes
---
### Data Storage
---
### Geo Locations
---
### Device Info
---
### Interface
---
### Navigator
#### p4d.navigateTo
---
### Others
#### Pullup Crypto Wallet
#### Web3
#### Local Storage
#### Scheme