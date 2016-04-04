# Analytics Web Service

This web service provides endpoints for counters and trends

# Start Server

```bash
rackup
```

# Usage

The service exposes a RESTful API for **analytics** and **trends**. In analytics sense, it exposes the count of a counter type. In trends it exposes the trending trend.

The schema of a **count call** in general looks like below

```
:enterprise_id/count/:counter_name/:counter_type/:timestamp/:limit
```

Similarly the schema of a **trend call** in general looks like below

```
:enterprise_id/trend/:trend_name/:trend_type/:timestamp/:limit
```

The meaning of these variables are:

- **`:enterprise_id`** : The enterprise ID of the enterprise for whom the call should be billed to.
- **`:counter_name`/`:trend_name`** : The name of the counter or the trend. Example: If it is a `Octo::ApiHit` count that you want to fetch, the `:counter_name` will be `api_hit`. If you want to fetch a trend for `Octo::ProductTrend`, the `:trend_name` will be `product_trend`. 
- **`:counter type`/`:trend_type`** : The type of counter that you wish to call. Currently following counter types are defined:
	-  	`TYPE_MINUTE`
	- 	`TYPE_MINUTE_30`
	-	`TYPE_HOUR`
	-	`TYPE_HOUR_3`
	- 	`TYPE_HOUR_6`
	-  `TYPE_HOUR_12`
	-  `TYPE_DAY`
	-  `TYPE_DAY_3`
	-  `TYPE_DAY_6`
	-  `TYPE_WEEK`
	
	Each represent a counter for a sliding window duration. For more details refer to the [Counter Documentation here](https://bitbucket.org/auroraborealisinc/gems/src/1420c68d6a96ea58d67a07cc8ed14c4a392cd211/octo-core/lib/octocore/counter.rb?at=master&fileviewer=file-view-default#counter.rb-12)
- **`:timestamp`** : The timestamp in epoch representation for which the details have to be fetched. This timestamp would be floored down to the nearest minute.
- **`:limit`** : The max size of results desired.

## Example


### Get API Hits for last 30 minutes now

**Request**

```bash
http://localhost:9292/57ff6653-c136-4ddf-8dba-15c7bd4995d2/count/api_hit/type_minute_30/now/10
```

**Response**

```json
[{"id":"app.init","count":50707,"ts":1459759980},{"id":"productpage.view","count":50706,"ts":1459759980}]
```

### Get Product Trends for last 30 minutes now

**Request**

```bash
http://localhost:9292/57ff6653-c136-4ddf-8dba-15c7bd4995d2/trend/product_trend/type_minute_30/now/10
```

**Response**

```json
[{"enterprise_id":{"n":116968946773727379778064150383982908882,"s":"57ff6653-c136-4ddf-8dba-15c7bd4995d2"},"id":100,"price":99.99,"name":"Smartphone Series 100","routeurl":"/Home/DealsOfTheDay/34","customid":null,"categories":["shopping","handbags","rajasthani"],"tags":["handbags","aldo","yellow"],"updated_at":"2016-04-04T07:59:00.025Z","created_at":"2016-04-04T07:59:00.025Z"}]
```

# Updating

The service would automatically account for all new counters and trends, assuming they have been set up properly. Nothing special should be required in this repo.
