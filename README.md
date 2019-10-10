# bluu
Microsoft Azure Cloud Computing Platform and Services (MAC) APIs

## Work in Progress

The request signing hasn't been implemented yet...

## Supported APIs

[Sadly, only the 675 most popular Azure APIs are supported at this time.](https://github.com/disruptek/bluu/tree/master/src/bluu) :cry:

## Example

Your import statement names the APIs you want to use and the versions of same,
with any punctuation turned into underscores or omitted from version identifiers.

```nim
import asyncdispatch
import httpclient
import httpcore

import bluu/cdn_20190415 # ie. CDN API released 2019-04-15

let
  # the call() gets arguments you might expect; they have sensible
  # defaults depending upon the call, the API, whether they are
  # required, what their types are, whether we can infer a default...
  myUsage = resourceUsageList.call(subscriptionId="my-subscription")
for response in myUsage.retried(tries=3):
  if response.code.is2xx:
    echo waitfor response.body
    break

```

## Details

This project is based almost entirely upon the following:

- OpenAPI Code Generator https://github.com/disruptek/openapi

Patches welcome!

## License

MIT
