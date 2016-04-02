# Analytics Web Service

This web service provides endpoints for counters and trends

# Usage

The usage is of the form of `/count` or `/trend`

# Example


**Request URL**
```
http://localhost:9292/57ff6653-c136-4ddf-8dba-15c7bd4995d2/count/api_hit/type_minute/now/10
```

**Response**
```
[{"id":"app.init","count":1544,"ts":1459594380},
{"id":"productpage.view","count":1544,"ts":1459594380}]
```
