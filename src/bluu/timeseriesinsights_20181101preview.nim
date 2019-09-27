
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

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

  OpenApiRestCall_593439 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_593439](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_593439): Option[Scheme] {.used.} =
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
proc queryString(query: JsonNode): string =
  var qs: seq[KeyVal]
  if query == nil:
    return ""
  for k, v in query.pairs:
    qs.add (key: k, val: v.getStr)
  result = encodeQuery(qs)

proc hydratePath(input: JsonNode; segments: seq[PathToken]): Option[string] =
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
  Call_QueryGetAvailability_593661 = ref object of OpenApiRestCall_593439
proc url_QueryGetAvailability_593663(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_QueryGetAvailability_593662(path: JsonNode; query: JsonNode;
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
  var valid_593835 = query.getOrDefault("api-version")
  valid_593835 = validateParameter(valid_593835, JString, required = true,
                                 default = newJString("2018-11-01-preview"))
  if valid_593835 != nil:
    section.add "api-version", valid_593835
  result.add "query", section
  ## parameters in `header` object:
  ##   x-ms-client-session-id: JString
  ##                         : Optional client session ID. Service records this value. Allows the service to trace a group of related operations across services, and allows the customer to contact support regarding a particular group of requests.
  ##   x-ms-client-request-id: JString
  ##                         : Optional client request ID. Service records this value. Allows the service to trace operation across services, and allows the customer to contact support regarding a particular request.
  section = newJObject()
  var valid_593836 = header.getOrDefault("x-ms-client-session-id")
  valid_593836 = validateParameter(valid_593836, JString, required = false,
                                 default = nil)
  if valid_593836 != nil:
    section.add "x-ms-client-session-id", valid_593836
  var valid_593837 = header.getOrDefault("x-ms-client-request-id")
  valid_593837 = validateParameter(valid_593837, JString, required = false,
                                 default = nil)
  if valid_593837 != nil:
    section.add "x-ms-client-request-id", valid_593837
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593860: Call_QueryGetAvailability_593661; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the time range and distribution of event count over the event timestamp ($ts). This API can be used to provide landing experience of navigating to the environment.
  ## 
  let valid = call_593860.validator(path, query, header, formData, body)
  let scheme = call_593860.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593860.url(scheme.get, call_593860.host, call_593860.base,
                         call_593860.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593860, url, valid)

proc call*(call_593931: Call_QueryGetAvailability_593661;
          apiVersion: string = "2018-11-01-preview"): Recallable =
  ## queryGetAvailability
  ## Returns the time range and distribution of event count over the event timestamp ($ts). This API can be used to provide landing experience of navigating to the environment.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Currently supported version is "2018-11-01-preview".
  var query_593932 = newJObject()
  add(query_593932, "api-version", newJString(apiVersion))
  result = call_593931.call(nil, query_593932, nil, nil, nil)

var queryGetAvailability* = Call_QueryGetAvailability_593661(
    name: "queryGetAvailability", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/availability", validator: validate_QueryGetAvailability_593662,
    base: "", url: url_QueryGetAvailability_593663, schemes: {Scheme.Https})
type
  Call_QueryGetEventSchema_593972 = ref object of OpenApiRestCall_593439
proc url_QueryGetEventSchema_593974(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_QueryGetEventSchema_593973(path: JsonNode; query: JsonNode;
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
  var valid_593975 = query.getOrDefault("api-version")
  valid_593975 = validateParameter(valid_593975, JString, required = true,
                                 default = newJString("2018-11-01-preview"))
  if valid_593975 != nil:
    section.add "api-version", valid_593975
  result.add "query", section
  ## parameters in `header` object:
  ##   x-ms-client-session-id: JString
  ##                         : Optional client session ID. Service records this value. Allows the service to trace a group of related operations across services, and allows the customer to contact support regarding a particular group of requests.
  ##   x-ms-client-request-id: JString
  ##                         : Optional client request ID. Service records this value. Allows the service to trace operation across services, and allows the customer to contact support regarding a particular request.
  section = newJObject()
  var valid_593976 = header.getOrDefault("x-ms-client-session-id")
  valid_593976 = validateParameter(valid_593976, JString, required = false,
                                 default = nil)
  if valid_593976 != nil:
    section.add "x-ms-client-session-id", valid_593976
  var valid_593977 = header.getOrDefault("x-ms-client-request-id")
  valid_593977 = validateParameter(valid_593977, JString, required = false,
                                 default = nil)
  if valid_593977 != nil:
    section.add "x-ms-client-request-id", valid_593977
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

proc call*(call_593979: Call_QueryGetEventSchema_593972; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns environment event schema for a given search span. Event schema is a set of property definitions. Event schema may not be contain all persisted properties when there are too many properties.
  ## 
  let valid = call_593979.validator(path, query, header, formData, body)
  let scheme = call_593979.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593979.url(scheme.get, call_593979.host, call_593979.base,
                         call_593979.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593979, url, valid)

proc call*(call_593980: Call_QueryGetEventSchema_593972; parameters: JsonNode;
          apiVersion: string = "2018-11-01-preview"): Recallable =
  ## queryGetEventSchema
  ## Returns environment event schema for a given search span. Event schema is a set of property definitions. Event schema may not be contain all persisted properties when there are too many properties.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Currently supported version is "2018-11-01-preview".
  ##   parameters: JObject (required)
  ##             : Parameters to get event schema.
  var query_593981 = newJObject()
  var body_593982 = newJObject()
  add(query_593981, "api-version", newJString(apiVersion))
  if parameters != nil:
    body_593982 = parameters
  result = call_593980.call(nil, query_593981, nil, nil, body_593982)

var queryGetEventSchema* = Call_QueryGetEventSchema_593972(
    name: "queryGetEventSchema", meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/eventSchema", validator: validate_QueryGetEventSchema_593973, base: "",
    url: url_QueryGetEventSchema_593974, schemes: {Scheme.Https})
type
  Call_TimeSeriesHierarchiesGet_593983 = ref object of OpenApiRestCall_593439
proc url_TimeSeriesHierarchiesGet_593985(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_TimeSeriesHierarchiesGet_593984(path: JsonNode; query: JsonNode;
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
  var valid_593986 = query.getOrDefault("api-version")
  valid_593986 = validateParameter(valid_593986, JString, required = true,
                                 default = newJString("2018-11-01-preview"))
  if valid_593986 != nil:
    section.add "api-version", valid_593986
  result.add "query", section
  ## parameters in `header` object:
  ##   x-ms-client-session-id: JString
  ##                         : Optional client session ID. Service records this value. Allows the service to trace a group of related operations across services, and allows the customer to contact support regarding a particular group of requests.
  ##   x-ms-client-request-id: JString
  ##                         : Optional client request ID. Service records this value. Allows the service to trace operation across services, and allows the customer to contact support regarding a particular request.
  ##   x-ms-continuation: JString
  ##                    : Continuation token from previous page of results to retrieve the next page of the results in calls that support pagination. To get the first page results, specify null continuation token as parameter value. Returned continuation token is null if all results have been returned, and there is no next page of results.
  section = newJObject()
  var valid_593987 = header.getOrDefault("x-ms-client-session-id")
  valid_593987 = validateParameter(valid_593987, JString, required = false,
                                 default = nil)
  if valid_593987 != nil:
    section.add "x-ms-client-session-id", valid_593987
  var valid_593988 = header.getOrDefault("x-ms-client-request-id")
  valid_593988 = validateParameter(valid_593988, JString, required = false,
                                 default = nil)
  if valid_593988 != nil:
    section.add "x-ms-client-request-id", valid_593988
  var valid_593989 = header.getOrDefault("x-ms-continuation")
  valid_593989 = validateParameter(valid_593989, JString, required = false,
                                 default = nil)
  if valid_593989 != nil:
    section.add "x-ms-continuation", valid_593989
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593990: Call_TimeSeriesHierarchiesGet_593983; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns time series hierarchies definitions in pages.
  ## 
  let valid = call_593990.validator(path, query, header, formData, body)
  let scheme = call_593990.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593990.url(scheme.get, call_593990.host, call_593990.base,
                         call_593990.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593990, url, valid)

proc call*(call_593991: Call_TimeSeriesHierarchiesGet_593983;
          apiVersion: string = "2018-11-01-preview"): Recallable =
  ## timeSeriesHierarchiesGet
  ## Returns time series hierarchies definitions in pages.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Currently supported version is "2018-11-01-preview".
  var query_593992 = newJObject()
  add(query_593992, "api-version", newJString(apiVersion))
  result = call_593991.call(nil, query_593992, nil, nil, nil)

var timeSeriesHierarchiesGet* = Call_TimeSeriesHierarchiesGet_593983(
    name: "timeSeriesHierarchiesGet", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/timeseries/hierarchies",
    validator: validate_TimeSeriesHierarchiesGet_593984, base: "",
    url: url_TimeSeriesHierarchiesGet_593985, schemes: {Scheme.Https})
type
  Call_TimeSeriesHierarchiesExecuteBatch_593993 = ref object of OpenApiRestCall_593439
proc url_TimeSeriesHierarchiesExecuteBatch_593995(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_TimeSeriesHierarchiesExecuteBatch_593994(path: JsonNode;
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
  var valid_593996 = query.getOrDefault("api-version")
  valid_593996 = validateParameter(valid_593996, JString, required = true,
                                 default = newJString("2018-11-01-preview"))
  if valid_593996 != nil:
    section.add "api-version", valid_593996
  result.add "query", section
  ## parameters in `header` object:
  ##   x-ms-client-session-id: JString
  ##                         : Optional client session ID. Service records this value. Allows the service to trace a group of related operations across services, and allows the customer to contact support regarding a particular group of requests.
  ##   x-ms-client-request-id: JString
  ##                         : Optional client request ID. Service records this value. Allows the service to trace operation across services, and allows the customer to contact support regarding a particular request.
  section = newJObject()
  var valid_593997 = header.getOrDefault("x-ms-client-session-id")
  valid_593997 = validateParameter(valid_593997, JString, required = false,
                                 default = nil)
  if valid_593997 != nil:
    section.add "x-ms-client-session-id", valid_593997
  var valid_593998 = header.getOrDefault("x-ms-client-request-id")
  valid_593998 = validateParameter(valid_593998, JString, required = false,
                                 default = nil)
  if valid_593998 != nil:
    section.add "x-ms-client-request-id", valid_593998
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

proc call*(call_594000: Call_TimeSeriesHierarchiesExecuteBatch_593993;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Executes a batch get, create, update, delete operation on multiple time series hierarchy definitions.
  ## 
  let valid = call_594000.validator(path, query, header, formData, body)
  let scheme = call_594000.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594000.url(scheme.get, call_594000.host, call_594000.base,
                         call_594000.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594000, url, valid)

proc call*(call_594001: Call_TimeSeriesHierarchiesExecuteBatch_593993;
          parameters: JsonNode; apiVersion: string = "2018-11-01-preview"): Recallable =
  ## timeSeriesHierarchiesExecuteBatch
  ## Executes a batch get, create, update, delete operation on multiple time series hierarchy definitions.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Currently supported version is "2018-11-01-preview".
  ##   parameters: JObject (required)
  ##             : Time series hierarchies batch request body.
  var query_594002 = newJObject()
  var body_594003 = newJObject()
  add(query_594002, "api-version", newJString(apiVersion))
  if parameters != nil:
    body_594003 = parameters
  result = call_594001.call(nil, query_594002, nil, nil, body_594003)

var timeSeriesHierarchiesExecuteBatch* = Call_TimeSeriesHierarchiesExecuteBatch_593993(
    name: "timeSeriesHierarchiesExecuteBatch", meth: HttpMethod.HttpPost,
    host: "azure.local", route: "/timeseries/hierarchies/$batch",
    validator: validate_TimeSeriesHierarchiesExecuteBatch_593994, base: "",
    url: url_TimeSeriesHierarchiesExecuteBatch_593995, schemes: {Scheme.Https})
type
  Call_TimeSeriesInstancesGet_594004 = ref object of OpenApiRestCall_593439
proc url_TimeSeriesInstancesGet_594006(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_TimeSeriesInstancesGet_594005(path: JsonNode; query: JsonNode;
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
  var valid_594007 = query.getOrDefault("api-version")
  valid_594007 = validateParameter(valid_594007, JString, required = true,
                                 default = newJString("2018-11-01-preview"))
  if valid_594007 != nil:
    section.add "api-version", valid_594007
  result.add "query", section
  ## parameters in `header` object:
  ##   x-ms-client-session-id: JString
  ##                         : Optional client session ID. Service records this value. Allows the service to trace a group of related operations across services, and allows the customer to contact support regarding a particular group of requests.
  ##   x-ms-client-request-id: JString
  ##                         : Optional client request ID. Service records this value. Allows the service to trace operation across services, and allows the customer to contact support regarding a particular request.
  ##   x-ms-continuation: JString
  ##                    : Continuation token from previous page of results to retrieve the next page of the results in calls that support pagination. To get the first page results, specify null continuation token as parameter value. Returned continuation token is null if all results have been returned, and there is no next page of results.
  section = newJObject()
  var valid_594008 = header.getOrDefault("x-ms-client-session-id")
  valid_594008 = validateParameter(valid_594008, JString, required = false,
                                 default = nil)
  if valid_594008 != nil:
    section.add "x-ms-client-session-id", valid_594008
  var valid_594009 = header.getOrDefault("x-ms-client-request-id")
  valid_594009 = validateParameter(valid_594009, JString, required = false,
                                 default = nil)
  if valid_594009 != nil:
    section.add "x-ms-client-request-id", valid_594009
  var valid_594010 = header.getOrDefault("x-ms-continuation")
  valid_594010 = validateParameter(valid_594010, JString, required = false,
                                 default = nil)
  if valid_594010 != nil:
    section.add "x-ms-continuation", valid_594010
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594011: Call_TimeSeriesInstancesGet_594004; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets time series instances in pages.
  ## 
  let valid = call_594011.validator(path, query, header, formData, body)
  let scheme = call_594011.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594011.url(scheme.get, call_594011.host, call_594011.base,
                         call_594011.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594011, url, valid)

proc call*(call_594012: Call_TimeSeriesInstancesGet_594004;
          apiVersion: string = "2018-11-01-preview"): Recallable =
  ## timeSeriesInstancesGet
  ## Gets time series instances in pages.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Currently supported version is "2018-11-01-preview".
  var query_594013 = newJObject()
  add(query_594013, "api-version", newJString(apiVersion))
  result = call_594012.call(nil, query_594013, nil, nil, nil)

var timeSeriesInstancesGet* = Call_TimeSeriesInstancesGet_594004(
    name: "timeSeriesInstancesGet", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/timeseries/instances", validator: validate_TimeSeriesInstancesGet_594005,
    base: "", url: url_TimeSeriesInstancesGet_594006, schemes: {Scheme.Https})
type
  Call_TimeSeriesInstancesExecuteBatch_594014 = ref object of OpenApiRestCall_593439
proc url_TimeSeriesInstancesExecuteBatch_594016(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_TimeSeriesInstancesExecuteBatch_594015(path: JsonNode;
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
  var valid_594017 = query.getOrDefault("api-version")
  valid_594017 = validateParameter(valid_594017, JString, required = true,
                                 default = newJString("2018-11-01-preview"))
  if valid_594017 != nil:
    section.add "api-version", valid_594017
  result.add "query", section
  ## parameters in `header` object:
  ##   x-ms-client-session-id: JString
  ##                         : Optional client session ID. Service records this value. Allows the service to trace a group of related operations across services, and allows the customer to contact support regarding a particular group of requests.
  ##   x-ms-client-request-id: JString
  ##                         : Optional client request ID. Service records this value. Allows the service to trace operation across services, and allows the customer to contact support regarding a particular request.
  section = newJObject()
  var valid_594018 = header.getOrDefault("x-ms-client-session-id")
  valid_594018 = validateParameter(valid_594018, JString, required = false,
                                 default = nil)
  if valid_594018 != nil:
    section.add "x-ms-client-session-id", valid_594018
  var valid_594019 = header.getOrDefault("x-ms-client-request-id")
  valid_594019 = validateParameter(valid_594019, JString, required = false,
                                 default = nil)
  if valid_594019 != nil:
    section.add "x-ms-client-request-id", valid_594019
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

proc call*(call_594021: Call_TimeSeriesInstancesExecuteBatch_594014;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Executes a batch get, create, update, delete operation on multiple time series instances.
  ## 
  let valid = call_594021.validator(path, query, header, formData, body)
  let scheme = call_594021.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594021.url(scheme.get, call_594021.host, call_594021.base,
                         call_594021.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594021, url, valid)

proc call*(call_594022: Call_TimeSeriesInstancesExecuteBatch_594014;
          parameters: JsonNode; apiVersion: string = "2018-11-01-preview"): Recallable =
  ## timeSeriesInstancesExecuteBatch
  ## Executes a batch get, create, update, delete operation on multiple time series instances.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Currently supported version is "2018-11-01-preview".
  ##   parameters: JObject (required)
  ##             : Time series instances suggest request body.
  var query_594023 = newJObject()
  var body_594024 = newJObject()
  add(query_594023, "api-version", newJString(apiVersion))
  if parameters != nil:
    body_594024 = parameters
  result = call_594022.call(nil, query_594023, nil, nil, body_594024)

var timeSeriesInstancesExecuteBatch* = Call_TimeSeriesInstancesExecuteBatch_594014(
    name: "timeSeriesInstancesExecuteBatch", meth: HttpMethod.HttpPost,
    host: "azure.local", route: "/timeseries/instances/$batch",
    validator: validate_TimeSeriesInstancesExecuteBatch_594015, base: "",
    url: url_TimeSeriesInstancesExecuteBatch_594016, schemes: {Scheme.Https})
type
  Call_TimeSeriesInstancesSearch_594025 = ref object of OpenApiRestCall_593439
proc url_TimeSeriesInstancesSearch_594027(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_TimeSeriesInstancesSearch_594026(path: JsonNode; query: JsonNode;
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
  var valid_594028 = query.getOrDefault("api-version")
  valid_594028 = validateParameter(valid_594028, JString, required = true,
                                 default = newJString("2018-11-01-preview"))
  if valid_594028 != nil:
    section.add "api-version", valid_594028
  result.add "query", section
  ## parameters in `header` object:
  ##   x-ms-client-session-id: JString
  ##                         : Optional client session ID. Service records this value. Allows the service to trace a group of related operations across services, and allows the customer to contact support regarding a particular group of requests.
  ##   x-ms-client-request-id: JString
  ##                         : Optional client request ID. Service records this value. Allows the service to trace operation across services, and allows the customer to contact support regarding a particular request.
  ##   x-ms-continuation: JString
  ##                    : Continuation token from previous page of results to retrieve the next page of the results in calls that support pagination. To get the first page results, specify null continuation token as parameter value. Returned continuation token is null if all results have been returned, and there is no next page of results.
  section = newJObject()
  var valid_594029 = header.getOrDefault("x-ms-client-session-id")
  valid_594029 = validateParameter(valid_594029, JString, required = false,
                                 default = nil)
  if valid_594029 != nil:
    section.add "x-ms-client-session-id", valid_594029
  var valid_594030 = header.getOrDefault("x-ms-client-request-id")
  valid_594030 = validateParameter(valid_594030, JString, required = false,
                                 default = nil)
  if valid_594030 != nil:
    section.add "x-ms-client-request-id", valid_594030
  var valid_594031 = header.getOrDefault("x-ms-continuation")
  valid_594031 = validateParameter(valid_594031, JString, required = false,
                                 default = nil)
  if valid_594031 != nil:
    section.add "x-ms-continuation", valid_594031
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

proc call*(call_594033: Call_TimeSeriesInstancesSearch_594025; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Partial list of hits on search for time series instances based on instance attributes.
  ## 
  let valid = call_594033.validator(path, query, header, formData, body)
  let scheme = call_594033.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594033.url(scheme.get, call_594033.host, call_594033.base,
                         call_594033.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594033, url, valid)

proc call*(call_594034: Call_TimeSeriesInstancesSearch_594025;
          parameters: JsonNode; apiVersion: string = "2018-11-01-preview"): Recallable =
  ## timeSeriesInstancesSearch
  ## Partial list of hits on search for time series instances based on instance attributes.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Currently supported version is "2018-11-01-preview".
  ##   parameters: JObject (required)
  ##             : Time series instances search request body.
  var query_594035 = newJObject()
  var body_594036 = newJObject()
  add(query_594035, "api-version", newJString(apiVersion))
  if parameters != nil:
    body_594036 = parameters
  result = call_594034.call(nil, query_594035, nil, nil, body_594036)

var timeSeriesInstancesSearch* = Call_TimeSeriesInstancesSearch_594025(
    name: "timeSeriesInstancesSearch", meth: HttpMethod.HttpPost,
    host: "azure.local", route: "/timeseries/instances/search",
    validator: validate_TimeSeriesInstancesSearch_594026, base: "",
    url: url_TimeSeriesInstancesSearch_594027, schemes: {Scheme.Https})
type
  Call_TimeSeriesInstancesSuggest_594037 = ref object of OpenApiRestCall_593439
proc url_TimeSeriesInstancesSuggest_594039(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_TimeSeriesInstancesSuggest_594038(path: JsonNode; query: JsonNode;
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
  var valid_594040 = query.getOrDefault("api-version")
  valid_594040 = validateParameter(valid_594040, JString, required = true,
                                 default = newJString("2018-11-01-preview"))
  if valid_594040 != nil:
    section.add "api-version", valid_594040
  result.add "query", section
  ## parameters in `header` object:
  ##   x-ms-client-session-id: JString
  ##                         : Optional client session ID. Service records this value. Allows the service to trace a group of related operations across services, and allows the customer to contact support regarding a particular group of requests.
  ##   x-ms-client-request-id: JString
  ##                         : Optional client request ID. Service records this value. Allows the service to trace operation across services, and allows the customer to contact support regarding a particular request.
  section = newJObject()
  var valid_594041 = header.getOrDefault("x-ms-client-session-id")
  valid_594041 = validateParameter(valid_594041, JString, required = false,
                                 default = nil)
  if valid_594041 != nil:
    section.add "x-ms-client-session-id", valid_594041
  var valid_594042 = header.getOrDefault("x-ms-client-request-id")
  valid_594042 = validateParameter(valid_594042, JString, required = false,
                                 default = nil)
  if valid_594042 != nil:
    section.add "x-ms-client-request-id", valid_594042
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

proc call*(call_594044: Call_TimeSeriesInstancesSuggest_594037; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Suggests keywords based on time series instance attributes to be later used in Search Instances.
  ## 
  let valid = call_594044.validator(path, query, header, formData, body)
  let scheme = call_594044.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594044.url(scheme.get, call_594044.host, call_594044.base,
                         call_594044.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594044, url, valid)

proc call*(call_594045: Call_TimeSeriesInstancesSuggest_594037;
          parameters: JsonNode; apiVersion: string = "2018-11-01-preview"): Recallable =
  ## timeSeriesInstancesSuggest
  ## Suggests keywords based on time series instance attributes to be later used in Search Instances.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Currently supported version is "2018-11-01-preview".
  ##   parameters: JObject (required)
  ##             : Time series instances suggest request body.
  var query_594046 = newJObject()
  var body_594047 = newJObject()
  add(query_594046, "api-version", newJString(apiVersion))
  if parameters != nil:
    body_594047 = parameters
  result = call_594045.call(nil, query_594046, nil, nil, body_594047)

var timeSeriesInstancesSuggest* = Call_TimeSeriesInstancesSuggest_594037(
    name: "timeSeriesInstancesSuggest", meth: HttpMethod.HttpPost,
    host: "azure.local", route: "/timeseries/instances/suggest",
    validator: validate_TimeSeriesInstancesSuggest_594038, base: "",
    url: url_TimeSeriesInstancesSuggest_594039, schemes: {Scheme.Https})
type
  Call_ModelSettingsGet_594048 = ref object of OpenApiRestCall_593439
proc url_ModelSettingsGet_594050(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_ModelSettingsGet_594049(path: JsonNode; query: JsonNode;
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
  var valid_594051 = query.getOrDefault("api-version")
  valid_594051 = validateParameter(valid_594051, JString, required = true,
                                 default = newJString("2018-11-01-preview"))
  if valid_594051 != nil:
    section.add "api-version", valid_594051
  result.add "query", section
  ## parameters in `header` object:
  ##   x-ms-client-session-id: JString
  ##                         : Optional client session ID. Service records this value. Allows the service to trace a group of related operations across services, and allows the customer to contact support regarding a particular group of requests.
  ##   x-ms-client-request-id: JString
  ##                         : Optional client request ID. Service records this value. Allows the service to trace operation across services, and allows the customer to contact support regarding a particular request.
  section = newJObject()
  var valid_594052 = header.getOrDefault("x-ms-client-session-id")
  valid_594052 = validateParameter(valid_594052, JString, required = false,
                                 default = nil)
  if valid_594052 != nil:
    section.add "x-ms-client-session-id", valid_594052
  var valid_594053 = header.getOrDefault("x-ms-client-request-id")
  valid_594053 = validateParameter(valid_594053, JString, required = false,
                                 default = nil)
  if valid_594053 != nil:
    section.add "x-ms-client-request-id", valid_594053
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594054: Call_ModelSettingsGet_594048; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the model settings which includes model display name, Time Series ID properties and default type ID. Every pay-as-you-go environment has a model that is automatically created.
  ## 
  let valid = call_594054.validator(path, query, header, formData, body)
  let scheme = call_594054.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594054.url(scheme.get, call_594054.host, call_594054.base,
                         call_594054.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594054, url, valid)

proc call*(call_594055: Call_ModelSettingsGet_594048;
          apiVersion: string = "2018-11-01-preview"): Recallable =
  ## modelSettingsGet
  ## Returns the model settings which includes model display name, Time Series ID properties and default type ID. Every pay-as-you-go environment has a model that is automatically created.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Currently supported version is "2018-11-01-preview".
  var query_594056 = newJObject()
  add(query_594056, "api-version", newJString(apiVersion))
  result = call_594055.call(nil, query_594056, nil, nil, nil)

var modelSettingsGet* = Call_ModelSettingsGet_594048(name: "modelSettingsGet",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/timeseries/modelSettings", validator: validate_ModelSettingsGet_594049,
    base: "", url: url_ModelSettingsGet_594050, schemes: {Scheme.Https})
type
  Call_ModelSettingsUpdate_594057 = ref object of OpenApiRestCall_593439
proc url_ModelSettingsUpdate_594059(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_ModelSettingsUpdate_594058(path: JsonNode; query: JsonNode;
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
  var valid_594060 = query.getOrDefault("api-version")
  valid_594060 = validateParameter(valid_594060, JString, required = true,
                                 default = newJString("2018-11-01-preview"))
  if valid_594060 != nil:
    section.add "api-version", valid_594060
  result.add "query", section
  ## parameters in `header` object:
  ##   x-ms-client-session-id: JString
  ##                         : Optional client session ID. Service records this value. Allows the service to trace a group of related operations across services, and allows the customer to contact support regarding a particular group of requests.
  ##   x-ms-client-request-id: JString
  ##                         : Optional client request ID. Service records this value. Allows the service to trace operation across services, and allows the customer to contact support regarding a particular request.
  section = newJObject()
  var valid_594061 = header.getOrDefault("x-ms-client-session-id")
  valid_594061 = validateParameter(valid_594061, JString, required = false,
                                 default = nil)
  if valid_594061 != nil:
    section.add "x-ms-client-session-id", valid_594061
  var valid_594062 = header.getOrDefault("x-ms-client-request-id")
  valid_594062 = validateParameter(valid_594062, JString, required = false,
                                 default = nil)
  if valid_594062 != nil:
    section.add "x-ms-client-request-id", valid_594062
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

proc call*(call_594064: Call_ModelSettingsUpdate_594057; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates time series model settings - either the model name or default type ID.
  ## 
  let valid = call_594064.validator(path, query, header, formData, body)
  let scheme = call_594064.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594064.url(scheme.get, call_594064.host, call_594064.base,
                         call_594064.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594064, url, valid)

proc call*(call_594065: Call_ModelSettingsUpdate_594057; parameters: JsonNode;
          apiVersion: string = "2018-11-01-preview"): Recallable =
  ## modelSettingsUpdate
  ## Updates time series model settings - either the model name or default type ID.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Currently supported version is "2018-11-01-preview".
  ##   parameters: JObject (required)
  ##             : Model settings update request body.
  var query_594066 = newJObject()
  var body_594067 = newJObject()
  add(query_594066, "api-version", newJString(apiVersion))
  if parameters != nil:
    body_594067 = parameters
  result = call_594065.call(nil, query_594066, nil, nil, body_594067)

var modelSettingsUpdate* = Call_ModelSettingsUpdate_594057(
    name: "modelSettingsUpdate", meth: HttpMethod.HttpPatch, host: "azure.local",
    route: "/timeseries/modelSettings", validator: validate_ModelSettingsUpdate_594058,
    base: "", url: url_ModelSettingsUpdate_594059, schemes: {Scheme.Https})
type
  Call_QueryExecute_594068 = ref object of OpenApiRestCall_593439
proc url_QueryExecute_594070(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_QueryExecute_594069(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594071 = query.getOrDefault("api-version")
  valid_594071 = validateParameter(valid_594071, JString, required = true,
                                 default = newJString("2018-11-01-preview"))
  if valid_594071 != nil:
    section.add "api-version", valid_594071
  result.add "query", section
  ## parameters in `header` object:
  ##   x-ms-client-session-id: JString
  ##                         : Optional client session ID. Service records this value. Allows the service to trace a group of related operations across services, and allows the customer to contact support regarding a particular group of requests.
  ##   x-ms-client-request-id: JString
  ##                         : Optional client request ID. Service records this value. Allows the service to trace operation across services, and allows the customer to contact support regarding a particular request.
  ##   x-ms-continuation: JString
  ##                    : Continuation token from previous page of results to retrieve the next page of the results in calls that support pagination. To get the first page results, specify null continuation token as parameter value. Returned continuation token is null if all results have been returned, and there is no next page of results.
  section = newJObject()
  var valid_594072 = header.getOrDefault("x-ms-client-session-id")
  valid_594072 = validateParameter(valid_594072, JString, required = false,
                                 default = nil)
  if valid_594072 != nil:
    section.add "x-ms-client-session-id", valid_594072
  var valid_594073 = header.getOrDefault("x-ms-client-request-id")
  valid_594073 = validateParameter(valid_594073, JString, required = false,
                                 default = nil)
  if valid_594073 != nil:
    section.add "x-ms-client-request-id", valid_594073
  var valid_594074 = header.getOrDefault("x-ms-continuation")
  valid_594074 = validateParameter(valid_594074, JString, required = false,
                                 default = nil)
  if valid_594074 != nil:
    section.add "x-ms-continuation", valid_594074
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

proc call*(call_594076: Call_QueryExecute_594068; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Executes Time Series Query in pages of results - Get Events, Get Series or Aggregate Series.
  ## 
  let valid = call_594076.validator(path, query, header, formData, body)
  let scheme = call_594076.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594076.url(scheme.get, call_594076.host, call_594076.base,
                         call_594076.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594076, url, valid)

proc call*(call_594077: Call_QueryExecute_594068; parameters: JsonNode;
          apiVersion: string = "2018-11-01-preview"): Recallable =
  ## queryExecute
  ## Executes Time Series Query in pages of results - Get Events, Get Series or Aggregate Series.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Currently supported version is "2018-11-01-preview".
  ##   parameters: JObject (required)
  ##             : Time series query request body.
  var query_594078 = newJObject()
  var body_594079 = newJObject()
  add(query_594078, "api-version", newJString(apiVersion))
  if parameters != nil:
    body_594079 = parameters
  result = call_594077.call(nil, query_594078, nil, nil, body_594079)

var queryExecute* = Call_QueryExecute_594068(name: "queryExecute",
    meth: HttpMethod.HttpPost, host: "azure.local", route: "/timeseries/query",
    validator: validate_QueryExecute_594069, base: "", url: url_QueryExecute_594070,
    schemes: {Scheme.Https})
type
  Call_TimeSeriesTypesGet_594080 = ref object of OpenApiRestCall_593439
proc url_TimeSeriesTypesGet_594082(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_TimeSeriesTypesGet_594081(path: JsonNode; query: JsonNode;
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
  var valid_594083 = query.getOrDefault("api-version")
  valid_594083 = validateParameter(valid_594083, JString, required = true,
                                 default = newJString("2018-11-01-preview"))
  if valid_594083 != nil:
    section.add "api-version", valid_594083
  result.add "query", section
  ## parameters in `header` object:
  ##   x-ms-client-session-id: JString
  ##                         : Optional client session ID. Service records this value. Allows the service to trace a group of related operations across services, and allows the customer to contact support regarding a particular group of requests.
  ##   x-ms-client-request-id: JString
  ##                         : Optional client request ID. Service records this value. Allows the service to trace operation across services, and allows the customer to contact support regarding a particular request.
  ##   x-ms-continuation: JString
  ##                    : Continuation token from previous page of results to retrieve the next page of the results in calls that support pagination. To get the first page results, specify null continuation token as parameter value. Returned continuation token is null if all results have been returned, and there is no next page of results.
  section = newJObject()
  var valid_594084 = header.getOrDefault("x-ms-client-session-id")
  valid_594084 = validateParameter(valid_594084, JString, required = false,
                                 default = nil)
  if valid_594084 != nil:
    section.add "x-ms-client-session-id", valid_594084
  var valid_594085 = header.getOrDefault("x-ms-client-request-id")
  valid_594085 = validateParameter(valid_594085, JString, required = false,
                                 default = nil)
  if valid_594085 != nil:
    section.add "x-ms-client-request-id", valid_594085
  var valid_594086 = header.getOrDefault("x-ms-continuation")
  valid_594086 = validateParameter(valid_594086, JString, required = false,
                                 default = nil)
  if valid_594086 != nil:
    section.add "x-ms-continuation", valid_594086
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594087: Call_TimeSeriesTypesGet_594080; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets time series types in pages.
  ## 
  let valid = call_594087.validator(path, query, header, formData, body)
  let scheme = call_594087.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594087.url(scheme.get, call_594087.host, call_594087.base,
                         call_594087.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594087, url, valid)

proc call*(call_594088: Call_TimeSeriesTypesGet_594080;
          apiVersion: string = "2018-11-01-preview"): Recallable =
  ## timeSeriesTypesGet
  ## Gets time series types in pages.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Currently supported version is "2018-11-01-preview".
  var query_594089 = newJObject()
  add(query_594089, "api-version", newJString(apiVersion))
  result = call_594088.call(nil, query_594089, nil, nil, nil)

var timeSeriesTypesGet* = Call_TimeSeriesTypesGet_594080(
    name: "timeSeriesTypesGet", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/timeseries/types", validator: validate_TimeSeriesTypesGet_594081,
    base: "", url: url_TimeSeriesTypesGet_594082, schemes: {Scheme.Https})
type
  Call_TimeSeriesTypesExecuteBatch_594090 = ref object of OpenApiRestCall_593439
proc url_TimeSeriesTypesExecuteBatch_594092(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_TimeSeriesTypesExecuteBatch_594091(path: JsonNode; query: JsonNode;
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
  var valid_594093 = query.getOrDefault("api-version")
  valid_594093 = validateParameter(valid_594093, JString, required = true,
                                 default = newJString("2018-11-01-preview"))
  if valid_594093 != nil:
    section.add "api-version", valid_594093
  result.add "query", section
  ## parameters in `header` object:
  ##   x-ms-client-session-id: JString
  ##                         : Optional client session ID. Service records this value. Allows the service to trace a group of related operations across services, and allows the customer to contact support regarding a particular group of requests.
  ##   x-ms-client-request-id: JString
  ##                         : Optional client request ID. Service records this value. Allows the service to trace operation across services, and allows the customer to contact support regarding a particular request.
  section = newJObject()
  var valid_594094 = header.getOrDefault("x-ms-client-session-id")
  valid_594094 = validateParameter(valid_594094, JString, required = false,
                                 default = nil)
  if valid_594094 != nil:
    section.add "x-ms-client-session-id", valid_594094
  var valid_594095 = header.getOrDefault("x-ms-client-request-id")
  valid_594095 = validateParameter(valid_594095, JString, required = false,
                                 default = nil)
  if valid_594095 != nil:
    section.add "x-ms-client-request-id", valid_594095
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

proc call*(call_594097: Call_TimeSeriesTypesExecuteBatch_594090; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Executes a batch get, create, update, delete operation on multiple time series types.
  ## 
  let valid = call_594097.validator(path, query, header, formData, body)
  let scheme = call_594097.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594097.url(scheme.get, call_594097.host, call_594097.base,
                         call_594097.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594097, url, valid)

proc call*(call_594098: Call_TimeSeriesTypesExecuteBatch_594090;
          parameters: JsonNode; apiVersion: string = "2018-11-01-preview"): Recallable =
  ## timeSeriesTypesExecuteBatch
  ## Executes a batch get, create, update, delete operation on multiple time series types.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Currently supported version is "2018-11-01-preview".
  ##   parameters: JObject (required)
  ##             : Time series types batch request body.
  var query_594099 = newJObject()
  var body_594100 = newJObject()
  add(query_594099, "api-version", newJString(apiVersion))
  if parameters != nil:
    body_594100 = parameters
  result = call_594098.call(nil, query_594099, nil, nil, body_594100)

var timeSeriesTypesExecuteBatch* = Call_TimeSeriesTypesExecuteBatch_594090(
    name: "timeSeriesTypesExecuteBatch", meth: HttpMethod.HttpPost,
    host: "azure.local", route: "/timeseries/types/$batch",
    validator: validate_TimeSeriesTypesExecuteBatch_594091, base: "",
    url: url_TimeSeriesTypesExecuteBatch_594092, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
