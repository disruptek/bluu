
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: TimeSeriesInsightsClient
## version: 2018-11-01-preview
## termsOfService: (not provided)
## license: (not provided)
## 
## Time Series Insights environment data plane client for PAYG (Preview L1 SKU) environments.
## 
type
  Scheme {.pure.} = enum
    Https = "https", Http = "http", Wss = "wss", Ws = "ws"
  ValidatorSignature = proc (query: JsonNode = nil; body: JsonNode = nil;
                          header: JsonNode = nil; path: JsonNode = nil;
                          formData: JsonNode = nil): JsonNode
  OpenApiRestCall = ref object of RestCall
    validator*: ValidatorSignature
    route*: string
    base*: string
    host*: string
    schemes*: set[Scheme]
    url*: proc (protocol: Scheme; host: string; base: string; route: string;
              path: JsonNode; query: JsonNode): Uri

  OpenApiRestCall_567668 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_567668](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_567668): Option[Scheme] {.used.} =
  ## select a supported scheme from a set of candidates
  for scheme in Scheme.low ..
      Scheme.high:
    if scheme notin t.schemes:
      continue
    if scheme in [Scheme.Https, Scheme.Wss]:
      when defined(ssl):
        return some(scheme)
      else:
        continue
    return some(scheme)

proc validateParameter(js: JsonNode; kind: JsonNodeKind; required: bool;
                      default: JsonNode = nil): JsonNode =
  ## ensure an input is of the correct json type and yield
  ## a suitable default value when appropriate
  if js ==
      nil:
    if default != nil:
      return validateParameter(default, kind, required = required)
  result = js
  if result ==
      nil:
    assert not required, $kind & " expected; received nil"
    if required:
      result = newJNull()
  else:
    assert js.kind ==
        kind, $kind & " expected; received " &
        $js.kind

type
  KeyVal {.used.} = tuple[key: string, val: string]
  PathTokenKind = enum
    ConstantSegment, VariableSegment
  PathToken = tuple[kind: PathTokenKind, value: string]
proc queryString(query: JsonNode): string {.used.} =
  var qs: seq[KeyVal]
  if query == nil:
    return ""
  for k, v in query.pairs:
    qs.add (key: k, val: v.getStr)
  result = encodeQuery(qs)

proc hydratePath(input: JsonNode; segments: seq[PathToken]): Option[string] {.used.} =
  ## reconstitute a path with constants and variable values taken from json
  var head: string
  if segments.len == 0:
    return some("")
  head = segments[0].value
  case segments[0].kind
  of ConstantSegment:
    discard
  of VariableSegment:
    if head notin input:
      return
    let js = input[head]
    if js.kind notin {JString, JInt, JFloat, JNull, JBool}:
      return
    head = $js
  var remainder = input.hydratePath(segments[1 ..^ 1])
  if remainder.isNone:
    return
  result = some(head & remainder.get)

const
  macServiceName = "timeseriesinsights"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_QueryGetAvailability_567890 = ref object of OpenApiRestCall_567668
proc url_QueryGetAvailability_567892(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_QueryGetAvailability_567891(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns the time range and distribution of event count over the event timestamp ($ts). This API can be used to provide landing experience of navigating to the environment.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Currently supported version is "2018-11-01-preview".
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568064 = query.getOrDefault("api-version")
  valid_568064 = validateParameter(valid_568064, JString, required = true,
                                 default = newJString("2018-11-01-preview"))
  if valid_568064 != nil:
    section.add "api-version", valid_568064
  result.add "query", section
  ## parameters in `header` object:
  ##   x-ms-client-session-id: JString
  ##                         : Optional client session ID. Service records this value. Allows the service to trace a group of related operations across services, and allows the customer to contact support regarding a particular group of requests.
  ##   x-ms-client-request-id: JString
  ##                         : Optional client request ID. Service records this value. Allows the service to trace operation across services, and allows the customer to contact support regarding a particular request.
  section = newJObject()
  var valid_568065 = header.getOrDefault("x-ms-client-session-id")
  valid_568065 = validateParameter(valid_568065, JString, required = false,
                                 default = nil)
  if valid_568065 != nil:
    section.add "x-ms-client-session-id", valid_568065
  var valid_568066 = header.getOrDefault("x-ms-client-request-id")
  valid_568066 = validateParameter(valid_568066, JString, required = false,
                                 default = nil)
  if valid_568066 != nil:
    section.add "x-ms-client-request-id", valid_568066
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568089: Call_QueryGetAvailability_567890; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the time range and distribution of event count over the event timestamp ($ts). This API can be used to provide landing experience of navigating to the environment.
  ## 
  let valid = call_568089.validator(path, query, header, formData, body)
  let scheme = call_568089.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568089.url(scheme.get, call_568089.host, call_568089.base,
                         call_568089.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568089, url, valid)

proc call*(call_568160: Call_QueryGetAvailability_567890;
          apiVersion: string = "2018-11-01-preview"): Recallable =
  ## queryGetAvailability
  ## Returns the time range and distribution of event count over the event timestamp ($ts). This API can be used to provide landing experience of navigating to the environment.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Currently supported version is "2018-11-01-preview".
  var query_568161 = newJObject()
  add(query_568161, "api-version", newJString(apiVersion))
  result = call_568160.call(nil, query_568161, nil, nil, nil)

var queryGetAvailability* = Call_QueryGetAvailability_567890(
    name: "queryGetAvailability", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/availability", validator: validate_QueryGetAvailability_567891,
    base: "", url: url_QueryGetAvailability_567892, schemes: {Scheme.Https})
type
  Call_QueryGetEventSchema_568201 = ref object of OpenApiRestCall_567668
proc url_QueryGetEventSchema_568203(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_QueryGetEventSchema_568202(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Returns environment event schema for a given search span. Event schema is a set of property definitions. Event schema may not be contain all persisted properties when there are too many properties.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Currently supported version is "2018-11-01-preview".
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568204 = query.getOrDefault("api-version")
  valid_568204 = validateParameter(valid_568204, JString, required = true,
                                 default = newJString("2018-11-01-preview"))
  if valid_568204 != nil:
    section.add "api-version", valid_568204
  result.add "query", section
  ## parameters in `header` object:
  ##   x-ms-client-session-id: JString
  ##                         : Optional client session ID. Service records this value. Allows the service to trace a group of related operations across services, and allows the customer to contact support regarding a particular group of requests.
  ##   x-ms-client-request-id: JString
  ##                         : Optional client request ID. Service records this value. Allows the service to trace operation across services, and allows the customer to contact support regarding a particular request.
  section = newJObject()
  var valid_568205 = header.getOrDefault("x-ms-client-session-id")
  valid_568205 = validateParameter(valid_568205, JString, required = false,
                                 default = nil)
  if valid_568205 != nil:
    section.add "x-ms-client-session-id", valid_568205
  var valid_568206 = header.getOrDefault("x-ms-client-request-id")
  valid_568206 = validateParameter(valid_568206, JString, required = false,
                                 default = nil)
  if valid_568206 != nil:
    section.add "x-ms-client-request-id", valid_568206
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters to get event schema.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568208: Call_QueryGetEventSchema_568201; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns environment event schema for a given search span. Event schema is a set of property definitions. Event schema may not be contain all persisted properties when there are too many properties.
  ## 
  let valid = call_568208.validator(path, query, header, formData, body)
  let scheme = call_568208.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568208.url(scheme.get, call_568208.host, call_568208.base,
                         call_568208.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568208, url, valid)

proc call*(call_568209: Call_QueryGetEventSchema_568201; parameters: JsonNode;
          apiVersion: string = "2018-11-01-preview"): Recallable =
  ## queryGetEventSchema
  ## Returns environment event schema for a given search span. Event schema is a set of property definitions. Event schema may not be contain all persisted properties when there are too many properties.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Currently supported version is "2018-11-01-preview".
  ##   parameters: JObject (required)
  ##             : Parameters to get event schema.
  var query_568210 = newJObject()
  var body_568211 = newJObject()
  add(query_568210, "api-version", newJString(apiVersion))
  if parameters != nil:
    body_568211 = parameters
  result = call_568209.call(nil, query_568210, nil, nil, body_568211)

var queryGetEventSchema* = Call_QueryGetEventSchema_568201(
    name: "queryGetEventSchema", meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/eventSchema", validator: validate_QueryGetEventSchema_568202, base: "",
    url: url_QueryGetEventSchema_568203, schemes: {Scheme.Https})
type
  Call_TimeSeriesHierarchiesGet_568212 = ref object of OpenApiRestCall_567668
proc url_TimeSeriesHierarchiesGet_568214(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_TimeSeriesHierarchiesGet_568213(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns time series hierarchies definitions in pages.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Currently supported version is "2018-11-01-preview".
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568215 = query.getOrDefault("api-version")
  valid_568215 = validateParameter(valid_568215, JString, required = true,
                                 default = newJString("2018-11-01-preview"))
  if valid_568215 != nil:
    section.add "api-version", valid_568215
  result.add "query", section
  ## parameters in `header` object:
  ##   x-ms-client-session-id: JString
  ##                         : Optional client session ID. Service records this value. Allows the service to trace a group of related operations across services, and allows the customer to contact support regarding a particular group of requests.
  ##   x-ms-client-request-id: JString
  ##                         : Optional client request ID. Service records this value. Allows the service to trace operation across services, and allows the customer to contact support regarding a particular request.
  ##   x-ms-continuation: JString
  ##                    : Continuation token from previous page of results to retrieve the next page of the results in calls that support pagination. To get the first page results, specify null continuation token as parameter value. Returned continuation token is null if all results have been returned, and there is no next page of results.
  section = newJObject()
  var valid_568216 = header.getOrDefault("x-ms-client-session-id")
  valid_568216 = validateParameter(valid_568216, JString, required = false,
                                 default = nil)
  if valid_568216 != nil:
    section.add "x-ms-client-session-id", valid_568216
  var valid_568217 = header.getOrDefault("x-ms-client-request-id")
  valid_568217 = validateParameter(valid_568217, JString, required = false,
                                 default = nil)
  if valid_568217 != nil:
    section.add "x-ms-client-request-id", valid_568217
  var valid_568218 = header.getOrDefault("x-ms-continuation")
  valid_568218 = validateParameter(valid_568218, JString, required = false,
                                 default = nil)
  if valid_568218 != nil:
    section.add "x-ms-continuation", valid_568218
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568219: Call_TimeSeriesHierarchiesGet_568212; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns time series hierarchies definitions in pages.
  ## 
  let valid = call_568219.validator(path, query, header, formData, body)
  let scheme = call_568219.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568219.url(scheme.get, call_568219.host, call_568219.base,
                         call_568219.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568219, url, valid)

proc call*(call_568220: Call_TimeSeriesHierarchiesGet_568212;
          apiVersion: string = "2018-11-01-preview"): Recallable =
  ## timeSeriesHierarchiesGet
  ## Returns time series hierarchies definitions in pages.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Currently supported version is "2018-11-01-preview".
  var query_568221 = newJObject()
  add(query_568221, "api-version", newJString(apiVersion))
  result = call_568220.call(nil, query_568221, nil, nil, nil)

var timeSeriesHierarchiesGet* = Call_TimeSeriesHierarchiesGet_568212(
    name: "timeSeriesHierarchiesGet", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/timeseries/hierarchies",
    validator: validate_TimeSeriesHierarchiesGet_568213, base: "",
    url: url_TimeSeriesHierarchiesGet_568214, schemes: {Scheme.Https})
type
  Call_TimeSeriesHierarchiesExecuteBatch_568222 = ref object of OpenApiRestCall_567668
proc url_TimeSeriesHierarchiesExecuteBatch_568224(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_TimeSeriesHierarchiesExecuteBatch_568223(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Executes a batch get, create, update, delete operation on multiple time series hierarchy definitions.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Currently supported version is "2018-11-01-preview".
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568225 = query.getOrDefault("api-version")
  valid_568225 = validateParameter(valid_568225, JString, required = true,
                                 default = newJString("2018-11-01-preview"))
  if valid_568225 != nil:
    section.add "api-version", valid_568225
  result.add "query", section
  ## parameters in `header` object:
  ##   x-ms-client-session-id: JString
  ##                         : Optional client session ID. Service records this value. Allows the service to trace a group of related operations across services, and allows the customer to contact support regarding a particular group of requests.
  ##   x-ms-client-request-id: JString
  ##                         : Optional client request ID. Service records this value. Allows the service to trace operation across services, and allows the customer to contact support regarding a particular request.
  section = newJObject()
  var valid_568226 = header.getOrDefault("x-ms-client-session-id")
  valid_568226 = validateParameter(valid_568226, JString, required = false,
                                 default = nil)
  if valid_568226 != nil:
    section.add "x-ms-client-session-id", valid_568226
  var valid_568227 = header.getOrDefault("x-ms-client-request-id")
  valid_568227 = validateParameter(valid_568227, JString, required = false,
                                 default = nil)
  if valid_568227 != nil:
    section.add "x-ms-client-request-id", valid_568227
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Time series hierarchies batch request body.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568229: Call_TimeSeriesHierarchiesExecuteBatch_568222;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Executes a batch get, create, update, delete operation on multiple time series hierarchy definitions.
  ## 
  let valid = call_568229.validator(path, query, header, formData, body)
  let scheme = call_568229.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568229.url(scheme.get, call_568229.host, call_568229.base,
                         call_568229.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568229, url, valid)

proc call*(call_568230: Call_TimeSeriesHierarchiesExecuteBatch_568222;
          parameters: JsonNode; apiVersion: string = "2018-11-01-preview"): Recallable =
  ## timeSeriesHierarchiesExecuteBatch
  ## Executes a batch get, create, update, delete operation on multiple time series hierarchy definitions.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Currently supported version is "2018-11-01-preview".
  ##   parameters: JObject (required)
  ##             : Time series hierarchies batch request body.
  var query_568231 = newJObject()
  var body_568232 = newJObject()
  add(query_568231, "api-version", newJString(apiVersion))
  if parameters != nil:
    body_568232 = parameters
  result = call_568230.call(nil, query_568231, nil, nil, body_568232)

var timeSeriesHierarchiesExecuteBatch* = Call_TimeSeriesHierarchiesExecuteBatch_568222(
    name: "timeSeriesHierarchiesExecuteBatch", meth: HttpMethod.HttpPost,
    host: "azure.local", route: "/timeseries/hierarchies/$batch",
    validator: validate_TimeSeriesHierarchiesExecuteBatch_568223, base: "",
    url: url_TimeSeriesHierarchiesExecuteBatch_568224, schemes: {Scheme.Https})
type
  Call_TimeSeriesInstancesGet_568233 = ref object of OpenApiRestCall_567668
proc url_TimeSeriesInstancesGet_568235(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_TimeSeriesInstancesGet_568234(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets time series instances in pages.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Currently supported version is "2018-11-01-preview".
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568236 = query.getOrDefault("api-version")
  valid_568236 = validateParameter(valid_568236, JString, required = true,
                                 default = newJString("2018-11-01-preview"))
  if valid_568236 != nil:
    section.add "api-version", valid_568236
  result.add "query", section
  ## parameters in `header` object:
  ##   x-ms-client-session-id: JString
  ##                         : Optional client session ID. Service records this value. Allows the service to trace a group of related operations across services, and allows the customer to contact support regarding a particular group of requests.
  ##   x-ms-client-request-id: JString
  ##                         : Optional client request ID. Service records this value. Allows the service to trace operation across services, and allows the customer to contact support regarding a particular request.
  ##   x-ms-continuation: JString
  ##                    : Continuation token from previous page of results to retrieve the next page of the results in calls that support pagination. To get the first page results, specify null continuation token as parameter value. Returned continuation token is null if all results have been returned, and there is no next page of results.
  section = newJObject()
  var valid_568237 = header.getOrDefault("x-ms-client-session-id")
  valid_568237 = validateParameter(valid_568237, JString, required = false,
                                 default = nil)
  if valid_568237 != nil:
    section.add "x-ms-client-session-id", valid_568237
  var valid_568238 = header.getOrDefault("x-ms-client-request-id")
  valid_568238 = validateParameter(valid_568238, JString, required = false,
                                 default = nil)
  if valid_568238 != nil:
    section.add "x-ms-client-request-id", valid_568238
  var valid_568239 = header.getOrDefault("x-ms-continuation")
  valid_568239 = validateParameter(valid_568239, JString, required = false,
                                 default = nil)
  if valid_568239 != nil:
    section.add "x-ms-continuation", valid_568239
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568240: Call_TimeSeriesInstancesGet_568233; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets time series instances in pages.
  ## 
  let valid = call_568240.validator(path, query, header, formData, body)
  let scheme = call_568240.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568240.url(scheme.get, call_568240.host, call_568240.base,
                         call_568240.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568240, url, valid)

proc call*(call_568241: Call_TimeSeriesInstancesGet_568233;
          apiVersion: string = "2018-11-01-preview"): Recallable =
  ## timeSeriesInstancesGet
  ## Gets time series instances in pages.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Currently supported version is "2018-11-01-preview".
  var query_568242 = newJObject()
  add(query_568242, "api-version", newJString(apiVersion))
  result = call_568241.call(nil, query_568242, nil, nil, nil)

var timeSeriesInstancesGet* = Call_TimeSeriesInstancesGet_568233(
    name: "timeSeriesInstancesGet", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/timeseries/instances", validator: validate_TimeSeriesInstancesGet_568234,
    base: "", url: url_TimeSeriesInstancesGet_568235, schemes: {Scheme.Https})
type
  Call_TimeSeriesInstancesExecuteBatch_568243 = ref object of OpenApiRestCall_567668
proc url_TimeSeriesInstancesExecuteBatch_568245(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_TimeSeriesInstancesExecuteBatch_568244(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Executes a batch get, create, update, delete operation on multiple time series instances.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Currently supported version is "2018-11-01-preview".
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568246 = query.getOrDefault("api-version")
  valid_568246 = validateParameter(valid_568246, JString, required = true,
                                 default = newJString("2018-11-01-preview"))
  if valid_568246 != nil:
    section.add "api-version", valid_568246
  result.add "query", section
  ## parameters in `header` object:
  ##   x-ms-client-session-id: JString
  ##                         : Optional client session ID. Service records this value. Allows the service to trace a group of related operations across services, and allows the customer to contact support regarding a particular group of requests.
  ##   x-ms-client-request-id: JString
  ##                         : Optional client request ID. Service records this value. Allows the service to trace operation across services, and allows the customer to contact support regarding a particular request.
  section = newJObject()
  var valid_568247 = header.getOrDefault("x-ms-client-session-id")
  valid_568247 = validateParameter(valid_568247, JString, required = false,
                                 default = nil)
  if valid_568247 != nil:
    section.add "x-ms-client-session-id", valid_568247
  var valid_568248 = header.getOrDefault("x-ms-client-request-id")
  valid_568248 = validateParameter(valid_568248, JString, required = false,
                                 default = nil)
  if valid_568248 != nil:
    section.add "x-ms-client-request-id", valid_568248
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Time series instances suggest request body.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568250: Call_TimeSeriesInstancesExecuteBatch_568243;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Executes a batch get, create, update, delete operation on multiple time series instances.
  ## 
  let valid = call_568250.validator(path, query, header, formData, body)
  let scheme = call_568250.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568250.url(scheme.get, call_568250.host, call_568250.base,
                         call_568250.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568250, url, valid)

proc call*(call_568251: Call_TimeSeriesInstancesExecuteBatch_568243;
          parameters: JsonNode; apiVersion: string = "2018-11-01-preview"): Recallable =
  ## timeSeriesInstancesExecuteBatch
  ## Executes a batch get, create, update, delete operation on multiple time series instances.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Currently supported version is "2018-11-01-preview".
  ##   parameters: JObject (required)
  ##             : Time series instances suggest request body.
  var query_568252 = newJObject()
  var body_568253 = newJObject()
  add(query_568252, "api-version", newJString(apiVersion))
  if parameters != nil:
    body_568253 = parameters
  result = call_568251.call(nil, query_568252, nil, nil, body_568253)

var timeSeriesInstancesExecuteBatch* = Call_TimeSeriesInstancesExecuteBatch_568243(
    name: "timeSeriesInstancesExecuteBatch", meth: HttpMethod.HttpPost,
    host: "azure.local", route: "/timeseries/instances/$batch",
    validator: validate_TimeSeriesInstancesExecuteBatch_568244, base: "",
    url: url_TimeSeriesInstancesExecuteBatch_568245, schemes: {Scheme.Https})
type
  Call_TimeSeriesInstancesSearch_568254 = ref object of OpenApiRestCall_567668
proc url_TimeSeriesInstancesSearch_568256(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_TimeSeriesInstancesSearch_568255(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Partial list of hits on search for time series instances based on instance attributes.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Currently supported version is "2018-11-01-preview".
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568257 = query.getOrDefault("api-version")
  valid_568257 = validateParameter(valid_568257, JString, required = true,
                                 default = newJString("2018-11-01-preview"))
  if valid_568257 != nil:
    section.add "api-version", valid_568257
  result.add "query", section
  ## parameters in `header` object:
  ##   x-ms-client-session-id: JString
  ##                         : Optional client session ID. Service records this value. Allows the service to trace a group of related operations across services, and allows the customer to contact support regarding a particular group of requests.
  ##   x-ms-client-request-id: JString
  ##                         : Optional client request ID. Service records this value. Allows the service to trace operation across services, and allows the customer to contact support regarding a particular request.
  ##   x-ms-continuation: JString
  ##                    : Continuation token from previous page of results to retrieve the next page of the results in calls that support pagination. To get the first page results, specify null continuation token as parameter value. Returned continuation token is null if all results have been returned, and there is no next page of results.
  section = newJObject()
  var valid_568258 = header.getOrDefault("x-ms-client-session-id")
  valid_568258 = validateParameter(valid_568258, JString, required = false,
                                 default = nil)
  if valid_568258 != nil:
    section.add "x-ms-client-session-id", valid_568258
  var valid_568259 = header.getOrDefault("x-ms-client-request-id")
  valid_568259 = validateParameter(valid_568259, JString, required = false,
                                 default = nil)
  if valid_568259 != nil:
    section.add "x-ms-client-request-id", valid_568259
  var valid_568260 = header.getOrDefault("x-ms-continuation")
  valid_568260 = validateParameter(valid_568260, JString, required = false,
                                 default = nil)
  if valid_568260 != nil:
    section.add "x-ms-continuation", valid_568260
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Time series instances search request body.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568262: Call_TimeSeriesInstancesSearch_568254; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Partial list of hits on search for time series instances based on instance attributes.
  ## 
  let valid = call_568262.validator(path, query, header, formData, body)
  let scheme = call_568262.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568262.url(scheme.get, call_568262.host, call_568262.base,
                         call_568262.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568262, url, valid)

proc call*(call_568263: Call_TimeSeriesInstancesSearch_568254;
          parameters: JsonNode; apiVersion: string = "2018-11-01-preview"): Recallable =
  ## timeSeriesInstancesSearch
  ## Partial list of hits on search for time series instances based on instance attributes.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Currently supported version is "2018-11-01-preview".
  ##   parameters: JObject (required)
  ##             : Time series instances search request body.
  var query_568264 = newJObject()
  var body_568265 = newJObject()
  add(query_568264, "api-version", newJString(apiVersion))
  if parameters != nil:
    body_568265 = parameters
  result = call_568263.call(nil, query_568264, nil, nil, body_568265)

var timeSeriesInstancesSearch* = Call_TimeSeriesInstancesSearch_568254(
    name: "timeSeriesInstancesSearch", meth: HttpMethod.HttpPost,
    host: "azure.local", route: "/timeseries/instances/search",
    validator: validate_TimeSeriesInstancesSearch_568255, base: "",
    url: url_TimeSeriesInstancesSearch_568256, schemes: {Scheme.Https})
type
  Call_TimeSeriesInstancesSuggest_568266 = ref object of OpenApiRestCall_567668
proc url_TimeSeriesInstancesSuggest_568268(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_TimeSeriesInstancesSuggest_568267(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Suggests keywords based on time series instance attributes to be later used in Search Instances.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Currently supported version is "2018-11-01-preview".
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568269 = query.getOrDefault("api-version")
  valid_568269 = validateParameter(valid_568269, JString, required = true,
                                 default = newJString("2018-11-01-preview"))
  if valid_568269 != nil:
    section.add "api-version", valid_568269
  result.add "query", section
  ## parameters in `header` object:
  ##   x-ms-client-session-id: JString
  ##                         : Optional client session ID. Service records this value. Allows the service to trace a group of related operations across services, and allows the customer to contact support regarding a particular group of requests.
  ##   x-ms-client-request-id: JString
  ##                         : Optional client request ID. Service records this value. Allows the service to trace operation across services, and allows the customer to contact support regarding a particular request.
  section = newJObject()
  var valid_568270 = header.getOrDefault("x-ms-client-session-id")
  valid_568270 = validateParameter(valid_568270, JString, required = false,
                                 default = nil)
  if valid_568270 != nil:
    section.add "x-ms-client-session-id", valid_568270
  var valid_568271 = header.getOrDefault("x-ms-client-request-id")
  valid_568271 = validateParameter(valid_568271, JString, required = false,
                                 default = nil)
  if valid_568271 != nil:
    section.add "x-ms-client-request-id", valid_568271
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Time series instances suggest request body.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568273: Call_TimeSeriesInstancesSuggest_568266; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Suggests keywords based on time series instance attributes to be later used in Search Instances.
  ## 
  let valid = call_568273.validator(path, query, header, formData, body)
  let scheme = call_568273.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568273.url(scheme.get, call_568273.host, call_568273.base,
                         call_568273.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568273, url, valid)

proc call*(call_568274: Call_TimeSeriesInstancesSuggest_568266;
          parameters: JsonNode; apiVersion: string = "2018-11-01-preview"): Recallable =
  ## timeSeriesInstancesSuggest
  ## Suggests keywords based on time series instance attributes to be later used in Search Instances.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Currently supported version is "2018-11-01-preview".
  ##   parameters: JObject (required)
  ##             : Time series instances suggest request body.
  var query_568275 = newJObject()
  var body_568276 = newJObject()
  add(query_568275, "api-version", newJString(apiVersion))
  if parameters != nil:
    body_568276 = parameters
  result = call_568274.call(nil, query_568275, nil, nil, body_568276)

var timeSeriesInstancesSuggest* = Call_TimeSeriesInstancesSuggest_568266(
    name: "timeSeriesInstancesSuggest", meth: HttpMethod.HttpPost,
    host: "azure.local", route: "/timeseries/instances/suggest",
    validator: validate_TimeSeriesInstancesSuggest_568267, base: "",
    url: url_TimeSeriesInstancesSuggest_568268, schemes: {Scheme.Https})
type
  Call_ModelSettingsGet_568277 = ref object of OpenApiRestCall_567668
proc url_ModelSettingsGet_568279(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_ModelSettingsGet_568278(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Returns the model settings which includes model display name, Time Series ID properties and default type ID. Every pay-as-you-go environment has a model that is automatically created.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Currently supported version is "2018-11-01-preview".
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568280 = query.getOrDefault("api-version")
  valid_568280 = validateParameter(valid_568280, JString, required = true,
                                 default = newJString("2018-11-01-preview"))
  if valid_568280 != nil:
    section.add "api-version", valid_568280
  result.add "query", section
  ## parameters in `header` object:
  ##   x-ms-client-session-id: JString
  ##                         : Optional client session ID. Service records this value. Allows the service to trace a group of related operations across services, and allows the customer to contact support regarding a particular group of requests.
  ##   x-ms-client-request-id: JString
  ##                         : Optional client request ID. Service records this value. Allows the service to trace operation across services, and allows the customer to contact support regarding a particular request.
  section = newJObject()
  var valid_568281 = header.getOrDefault("x-ms-client-session-id")
  valid_568281 = validateParameter(valid_568281, JString, required = false,
                                 default = nil)
  if valid_568281 != nil:
    section.add "x-ms-client-session-id", valid_568281
  var valid_568282 = header.getOrDefault("x-ms-client-request-id")
  valid_568282 = validateParameter(valid_568282, JString, required = false,
                                 default = nil)
  if valid_568282 != nil:
    section.add "x-ms-client-request-id", valid_568282
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568283: Call_ModelSettingsGet_568277; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the model settings which includes model display name, Time Series ID properties and default type ID. Every pay-as-you-go environment has a model that is automatically created.
  ## 
  let valid = call_568283.validator(path, query, header, formData, body)
  let scheme = call_568283.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568283.url(scheme.get, call_568283.host, call_568283.base,
                         call_568283.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568283, url, valid)

proc call*(call_568284: Call_ModelSettingsGet_568277;
          apiVersion: string = "2018-11-01-preview"): Recallable =
  ## modelSettingsGet
  ## Returns the model settings which includes model display name, Time Series ID properties and default type ID. Every pay-as-you-go environment has a model that is automatically created.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Currently supported version is "2018-11-01-preview".
  var query_568285 = newJObject()
  add(query_568285, "api-version", newJString(apiVersion))
  result = call_568284.call(nil, query_568285, nil, nil, nil)

var modelSettingsGet* = Call_ModelSettingsGet_568277(name: "modelSettingsGet",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/timeseries/modelSettings", validator: validate_ModelSettingsGet_568278,
    base: "", url: url_ModelSettingsGet_568279, schemes: {Scheme.Https})
type
  Call_ModelSettingsUpdate_568286 = ref object of OpenApiRestCall_567668
proc url_ModelSettingsUpdate_568288(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_ModelSettingsUpdate_568287(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Updates time series model settings - either the model name or default type ID.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Currently supported version is "2018-11-01-preview".
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568289 = query.getOrDefault("api-version")
  valid_568289 = validateParameter(valid_568289, JString, required = true,
                                 default = newJString("2018-11-01-preview"))
  if valid_568289 != nil:
    section.add "api-version", valid_568289
  result.add "query", section
  ## parameters in `header` object:
  ##   x-ms-client-session-id: JString
  ##                         : Optional client session ID. Service records this value. Allows the service to trace a group of related operations across services, and allows the customer to contact support regarding a particular group of requests.
  ##   x-ms-client-request-id: JString
  ##                         : Optional client request ID. Service records this value. Allows the service to trace operation across services, and allows the customer to contact support regarding a particular request.
  section = newJObject()
  var valid_568290 = header.getOrDefault("x-ms-client-session-id")
  valid_568290 = validateParameter(valid_568290, JString, required = false,
                                 default = nil)
  if valid_568290 != nil:
    section.add "x-ms-client-session-id", valid_568290
  var valid_568291 = header.getOrDefault("x-ms-client-request-id")
  valid_568291 = validateParameter(valid_568291, JString, required = false,
                                 default = nil)
  if valid_568291 != nil:
    section.add "x-ms-client-request-id", valid_568291
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Model settings update request body.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568293: Call_ModelSettingsUpdate_568286; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates time series model settings - either the model name or default type ID.
  ## 
  let valid = call_568293.validator(path, query, header, formData, body)
  let scheme = call_568293.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568293.url(scheme.get, call_568293.host, call_568293.base,
                         call_568293.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568293, url, valid)

proc call*(call_568294: Call_ModelSettingsUpdate_568286; parameters: JsonNode;
          apiVersion: string = "2018-11-01-preview"): Recallable =
  ## modelSettingsUpdate
  ## Updates time series model settings - either the model name or default type ID.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Currently supported version is "2018-11-01-preview".
  ##   parameters: JObject (required)
  ##             : Model settings update request body.
  var query_568295 = newJObject()
  var body_568296 = newJObject()
  add(query_568295, "api-version", newJString(apiVersion))
  if parameters != nil:
    body_568296 = parameters
  result = call_568294.call(nil, query_568295, nil, nil, body_568296)

var modelSettingsUpdate* = Call_ModelSettingsUpdate_568286(
    name: "modelSettingsUpdate", meth: HttpMethod.HttpPatch, host: "azure.local",
    route: "/timeseries/modelSettings", validator: validate_ModelSettingsUpdate_568287,
    base: "", url: url_ModelSettingsUpdate_568288, schemes: {Scheme.Https})
type
  Call_QueryExecute_568297 = ref object of OpenApiRestCall_567668
proc url_QueryExecute_568299(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_QueryExecute_568298(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Executes Time Series Query in pages of results - Get Events, Get Series or Aggregate Series.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Currently supported version is "2018-11-01-preview".
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568300 = query.getOrDefault("api-version")
  valid_568300 = validateParameter(valid_568300, JString, required = true,
                                 default = newJString("2018-11-01-preview"))
  if valid_568300 != nil:
    section.add "api-version", valid_568300
  result.add "query", section
  ## parameters in `header` object:
  ##   x-ms-client-session-id: JString
  ##                         : Optional client session ID. Service records this value. Allows the service to trace a group of related operations across services, and allows the customer to contact support regarding a particular group of requests.
  ##   x-ms-client-request-id: JString
  ##                         : Optional client request ID. Service records this value. Allows the service to trace operation across services, and allows the customer to contact support regarding a particular request.
  ##   x-ms-continuation: JString
  ##                    : Continuation token from previous page of results to retrieve the next page of the results in calls that support pagination. To get the first page results, specify null continuation token as parameter value. Returned continuation token is null if all results have been returned, and there is no next page of results.
  section = newJObject()
  var valid_568301 = header.getOrDefault("x-ms-client-session-id")
  valid_568301 = validateParameter(valid_568301, JString, required = false,
                                 default = nil)
  if valid_568301 != nil:
    section.add "x-ms-client-session-id", valid_568301
  var valid_568302 = header.getOrDefault("x-ms-client-request-id")
  valid_568302 = validateParameter(valid_568302, JString, required = false,
                                 default = nil)
  if valid_568302 != nil:
    section.add "x-ms-client-request-id", valid_568302
  var valid_568303 = header.getOrDefault("x-ms-continuation")
  valid_568303 = validateParameter(valid_568303, JString, required = false,
                                 default = nil)
  if valid_568303 != nil:
    section.add "x-ms-continuation", valid_568303
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Time series query request body.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568305: Call_QueryExecute_568297; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Executes Time Series Query in pages of results - Get Events, Get Series or Aggregate Series.
  ## 
  let valid = call_568305.validator(path, query, header, formData, body)
  let scheme = call_568305.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568305.url(scheme.get, call_568305.host, call_568305.base,
                         call_568305.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568305, url, valid)

proc call*(call_568306: Call_QueryExecute_568297; parameters: JsonNode;
          apiVersion: string = "2018-11-01-preview"): Recallable =
  ## queryExecute
  ## Executes Time Series Query in pages of results - Get Events, Get Series or Aggregate Series.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Currently supported version is "2018-11-01-preview".
  ##   parameters: JObject (required)
  ##             : Time series query request body.
  var query_568307 = newJObject()
  var body_568308 = newJObject()
  add(query_568307, "api-version", newJString(apiVersion))
  if parameters != nil:
    body_568308 = parameters
  result = call_568306.call(nil, query_568307, nil, nil, body_568308)

var queryExecute* = Call_QueryExecute_568297(name: "queryExecute",
    meth: HttpMethod.HttpPost, host: "azure.local", route: "/timeseries/query",
    validator: validate_QueryExecute_568298, base: "", url: url_QueryExecute_568299,
    schemes: {Scheme.Https})
type
  Call_TimeSeriesTypesGet_568309 = ref object of OpenApiRestCall_567668
proc url_TimeSeriesTypesGet_568311(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_TimeSeriesTypesGet_568310(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Gets time series types in pages.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Currently supported version is "2018-11-01-preview".
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568312 = query.getOrDefault("api-version")
  valid_568312 = validateParameter(valid_568312, JString, required = true,
                                 default = newJString("2018-11-01-preview"))
  if valid_568312 != nil:
    section.add "api-version", valid_568312
  result.add "query", section
  ## parameters in `header` object:
  ##   x-ms-client-session-id: JString
  ##                         : Optional client session ID. Service records this value. Allows the service to trace a group of related operations across services, and allows the customer to contact support regarding a particular group of requests.
  ##   x-ms-client-request-id: JString
  ##                         : Optional client request ID. Service records this value. Allows the service to trace operation across services, and allows the customer to contact support regarding a particular request.
  ##   x-ms-continuation: JString
  ##                    : Continuation token from previous page of results to retrieve the next page of the results in calls that support pagination. To get the first page results, specify null continuation token as parameter value. Returned continuation token is null if all results have been returned, and there is no next page of results.
  section = newJObject()
  var valid_568313 = header.getOrDefault("x-ms-client-session-id")
  valid_568313 = validateParameter(valid_568313, JString, required = false,
                                 default = nil)
  if valid_568313 != nil:
    section.add "x-ms-client-session-id", valid_568313
  var valid_568314 = header.getOrDefault("x-ms-client-request-id")
  valid_568314 = validateParameter(valid_568314, JString, required = false,
                                 default = nil)
  if valid_568314 != nil:
    section.add "x-ms-client-request-id", valid_568314
  var valid_568315 = header.getOrDefault("x-ms-continuation")
  valid_568315 = validateParameter(valid_568315, JString, required = false,
                                 default = nil)
  if valid_568315 != nil:
    section.add "x-ms-continuation", valid_568315
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568316: Call_TimeSeriesTypesGet_568309; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets time series types in pages.
  ## 
  let valid = call_568316.validator(path, query, header, formData, body)
  let scheme = call_568316.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568316.url(scheme.get, call_568316.host, call_568316.base,
                         call_568316.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568316, url, valid)

proc call*(call_568317: Call_TimeSeriesTypesGet_568309;
          apiVersion: string = "2018-11-01-preview"): Recallable =
  ## timeSeriesTypesGet
  ## Gets time series types in pages.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Currently supported version is "2018-11-01-preview".
  var query_568318 = newJObject()
  add(query_568318, "api-version", newJString(apiVersion))
  result = call_568317.call(nil, query_568318, nil, nil, nil)

var timeSeriesTypesGet* = Call_TimeSeriesTypesGet_568309(
    name: "timeSeriesTypesGet", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/timeseries/types", validator: validate_TimeSeriesTypesGet_568310,
    base: "", url: url_TimeSeriesTypesGet_568311, schemes: {Scheme.Https})
type
  Call_TimeSeriesTypesExecuteBatch_568319 = ref object of OpenApiRestCall_567668
proc url_TimeSeriesTypesExecuteBatch_568321(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_TimeSeriesTypesExecuteBatch_568320(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Executes a batch get, create, update, delete operation on multiple time series types.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Currently supported version is "2018-11-01-preview".
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568322 = query.getOrDefault("api-version")
  valid_568322 = validateParameter(valid_568322, JString, required = true,
                                 default = newJString("2018-11-01-preview"))
  if valid_568322 != nil:
    section.add "api-version", valid_568322
  result.add "query", section
  ## parameters in `header` object:
  ##   x-ms-client-session-id: JString
  ##                         : Optional client session ID. Service records this value. Allows the service to trace a group of related operations across services, and allows the customer to contact support regarding a particular group of requests.
  ##   x-ms-client-request-id: JString
  ##                         : Optional client request ID. Service records this value. Allows the service to trace operation across services, and allows the customer to contact support regarding a particular request.
  section = newJObject()
  var valid_568323 = header.getOrDefault("x-ms-client-session-id")
  valid_568323 = validateParameter(valid_568323, JString, required = false,
                                 default = nil)
  if valid_568323 != nil:
    section.add "x-ms-client-session-id", valid_568323
  var valid_568324 = header.getOrDefault("x-ms-client-request-id")
  valid_568324 = validateParameter(valid_568324, JString, required = false,
                                 default = nil)
  if valid_568324 != nil:
    section.add "x-ms-client-request-id", valid_568324
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Time series types batch request body.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568326: Call_TimeSeriesTypesExecuteBatch_568319; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Executes a batch get, create, update, delete operation on multiple time series types.
  ## 
  let valid = call_568326.validator(path, query, header, formData, body)
  let scheme = call_568326.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568326.url(scheme.get, call_568326.host, call_568326.base,
                         call_568326.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568326, url, valid)

proc call*(call_568327: Call_TimeSeriesTypesExecuteBatch_568319;
          parameters: JsonNode; apiVersion: string = "2018-11-01-preview"): Recallable =
  ## timeSeriesTypesExecuteBatch
  ## Executes a batch get, create, update, delete operation on multiple time series types.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Currently supported version is "2018-11-01-preview".
  ##   parameters: JObject (required)
  ##             : Time series types batch request body.
  var query_568328 = newJObject()
  var body_568329 = newJObject()
  add(query_568328, "api-version", newJString(apiVersion))
  if parameters != nil:
    body_568329 = parameters
  result = call_568327.call(nil, query_568328, nil, nil, body_568329)

var timeSeriesTypesExecuteBatch* = Call_TimeSeriesTypesExecuteBatch_568319(
    name: "timeSeriesTypesExecuteBatch", meth: HttpMethod.HttpPost,
    host: "azure.local", route: "/timeseries/types/$batch",
    validator: validate_TimeSeriesTypesExecuteBatch_568320, base: "",
    url: url_TimeSeriesTypesExecuteBatch_568321, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
