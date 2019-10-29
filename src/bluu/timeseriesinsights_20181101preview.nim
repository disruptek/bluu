
import
  json, options, hashes, uri, rest, os, uri, httpcore

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

  OpenApiRestCall_563566 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_563566](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_563566): Option[Scheme] {.used.} =
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
    case js.kind
    of JInt, JFloat, JNull, JBool:
      head = $js
    of JString:
      head = js.getStr
    else:
      return
  var remainder = input.hydratePath(segments[1 ..^ 1])
  if remainder.isNone:
    return
  result = some(head & remainder.get)

const
  macServiceName = "timeseriesinsights"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_QueryGetAvailability_563788 = ref object of OpenApiRestCall_563566
proc url_QueryGetAvailability_563790(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_QueryGetAvailability_563789(path: JsonNode; query: JsonNode;
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
  var valid_563964 = query.getOrDefault("api-version")
  valid_563964 = validateParameter(valid_563964, JString, required = true,
                                 default = newJString("2018-11-01-preview"))
  if valid_563964 != nil:
    section.add "api-version", valid_563964
  result.add "query", section
  ## parameters in `header` object:
  ##   x-ms-client-request-id: JString
  ##                         : Optional client request ID. Service records this value. Allows the service to trace operation across services, and allows the customer to contact support regarding a particular request.
  ##   x-ms-client-session-id: JString
  ##                         : Optional client session ID. Service records this value. Allows the service to trace a group of related operations across services, and allows the customer to contact support regarding a particular group of requests.
  section = newJObject()
  var valid_563965 = header.getOrDefault("x-ms-client-request-id")
  valid_563965 = validateParameter(valid_563965, JString, required = false,
                                 default = nil)
  if valid_563965 != nil:
    section.add "x-ms-client-request-id", valid_563965
  var valid_563966 = header.getOrDefault("x-ms-client-session-id")
  valid_563966 = validateParameter(valid_563966, JString, required = false,
                                 default = nil)
  if valid_563966 != nil:
    section.add "x-ms-client-session-id", valid_563966
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_563989: Call_QueryGetAvailability_563788; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the time range and distribution of event count over the event timestamp ($ts). This API can be used to provide landing experience of navigating to the environment.
  ## 
  let valid = call_563989.validator(path, query, header, formData, body)
  let scheme = call_563989.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_563989.url(scheme.get, call_563989.host, call_563989.base,
                         call_563989.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_563989, url, valid)

proc call*(call_564060: Call_QueryGetAvailability_563788;
          apiVersion: string = "2018-11-01-preview"): Recallable =
  ## queryGetAvailability
  ## Returns the time range and distribution of event count over the event timestamp ($ts). This API can be used to provide landing experience of navigating to the environment.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Currently supported version is "2018-11-01-preview".
  var query_564061 = newJObject()
  add(query_564061, "api-version", newJString(apiVersion))
  result = call_564060.call(nil, query_564061, nil, nil, nil)

var queryGetAvailability* = Call_QueryGetAvailability_563788(
    name: "queryGetAvailability", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/availability", validator: validate_QueryGetAvailability_563789,
    base: "", url: url_QueryGetAvailability_563790, schemes: {Scheme.Https})
type
  Call_QueryGetEventSchema_564101 = ref object of OpenApiRestCall_563566
proc url_QueryGetEventSchema_564103(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_QueryGetEventSchema_564102(path: JsonNode; query: JsonNode;
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
  var valid_564104 = query.getOrDefault("api-version")
  valid_564104 = validateParameter(valid_564104, JString, required = true,
                                 default = newJString("2018-11-01-preview"))
  if valid_564104 != nil:
    section.add "api-version", valid_564104
  result.add "query", section
  ## parameters in `header` object:
  ##   x-ms-client-request-id: JString
  ##                         : Optional client request ID. Service records this value. Allows the service to trace operation across services, and allows the customer to contact support regarding a particular request.
  ##   x-ms-client-session-id: JString
  ##                         : Optional client session ID. Service records this value. Allows the service to trace a group of related operations across services, and allows the customer to contact support regarding a particular group of requests.
  section = newJObject()
  var valid_564105 = header.getOrDefault("x-ms-client-request-id")
  valid_564105 = validateParameter(valid_564105, JString, required = false,
                                 default = nil)
  if valid_564105 != nil:
    section.add "x-ms-client-request-id", valid_564105
  var valid_564106 = header.getOrDefault("x-ms-client-session-id")
  valid_564106 = validateParameter(valid_564106, JString, required = false,
                                 default = nil)
  if valid_564106 != nil:
    section.add "x-ms-client-session-id", valid_564106
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

proc call*(call_564108: Call_QueryGetEventSchema_564101; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns environment event schema for a given search span. Event schema is a set of property definitions. Event schema may not be contain all persisted properties when there are too many properties.
  ## 
  let valid = call_564108.validator(path, query, header, formData, body)
  let scheme = call_564108.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564108.url(scheme.get, call_564108.host, call_564108.base,
                         call_564108.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564108, url, valid)

proc call*(call_564109: Call_QueryGetEventSchema_564101; parameters: JsonNode;
          apiVersion: string = "2018-11-01-preview"): Recallable =
  ## queryGetEventSchema
  ## Returns environment event schema for a given search span. Event schema is a set of property definitions. Event schema may not be contain all persisted properties when there are too many properties.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Currently supported version is "2018-11-01-preview".
  ##   parameters: JObject (required)
  ##             : Parameters to get event schema.
  var query_564110 = newJObject()
  var body_564111 = newJObject()
  add(query_564110, "api-version", newJString(apiVersion))
  if parameters != nil:
    body_564111 = parameters
  result = call_564109.call(nil, query_564110, nil, nil, body_564111)

var queryGetEventSchema* = Call_QueryGetEventSchema_564101(
    name: "queryGetEventSchema", meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/eventSchema", validator: validate_QueryGetEventSchema_564102, base: "",
    url: url_QueryGetEventSchema_564103, schemes: {Scheme.Https})
type
  Call_TimeSeriesHierarchiesGet_564112 = ref object of OpenApiRestCall_563566
proc url_TimeSeriesHierarchiesGet_564114(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_TimeSeriesHierarchiesGet_564113(path: JsonNode; query: JsonNode;
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
  var valid_564115 = query.getOrDefault("api-version")
  valid_564115 = validateParameter(valid_564115, JString, required = true,
                                 default = newJString("2018-11-01-preview"))
  if valid_564115 != nil:
    section.add "api-version", valid_564115
  result.add "query", section
  ## parameters in `header` object:
  ##   x-ms-continuation: JString
  ##                    : Continuation token from previous page of results to retrieve the next page of the results in calls that support pagination. To get the first page results, specify null continuation token as parameter value. Returned continuation token is null if all results have been returned, and there is no next page of results.
  ##   x-ms-client-request-id: JString
  ##                         : Optional client request ID. Service records this value. Allows the service to trace operation across services, and allows the customer to contact support regarding a particular request.
  ##   x-ms-client-session-id: JString
  ##                         : Optional client session ID. Service records this value. Allows the service to trace a group of related operations across services, and allows the customer to contact support regarding a particular group of requests.
  section = newJObject()
  var valid_564116 = header.getOrDefault("x-ms-continuation")
  valid_564116 = validateParameter(valid_564116, JString, required = false,
                                 default = nil)
  if valid_564116 != nil:
    section.add "x-ms-continuation", valid_564116
  var valid_564117 = header.getOrDefault("x-ms-client-request-id")
  valid_564117 = validateParameter(valid_564117, JString, required = false,
                                 default = nil)
  if valid_564117 != nil:
    section.add "x-ms-client-request-id", valid_564117
  var valid_564118 = header.getOrDefault("x-ms-client-session-id")
  valid_564118 = validateParameter(valid_564118, JString, required = false,
                                 default = nil)
  if valid_564118 != nil:
    section.add "x-ms-client-session-id", valid_564118
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564119: Call_TimeSeriesHierarchiesGet_564112; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns time series hierarchies definitions in pages.
  ## 
  let valid = call_564119.validator(path, query, header, formData, body)
  let scheme = call_564119.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564119.url(scheme.get, call_564119.host, call_564119.base,
                         call_564119.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564119, url, valid)

proc call*(call_564120: Call_TimeSeriesHierarchiesGet_564112;
          apiVersion: string = "2018-11-01-preview"): Recallable =
  ## timeSeriesHierarchiesGet
  ## Returns time series hierarchies definitions in pages.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Currently supported version is "2018-11-01-preview".
  var query_564121 = newJObject()
  add(query_564121, "api-version", newJString(apiVersion))
  result = call_564120.call(nil, query_564121, nil, nil, nil)

var timeSeriesHierarchiesGet* = Call_TimeSeriesHierarchiesGet_564112(
    name: "timeSeriesHierarchiesGet", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/timeseries/hierarchies",
    validator: validate_TimeSeriesHierarchiesGet_564113, base: "",
    url: url_TimeSeriesHierarchiesGet_564114, schemes: {Scheme.Https})
type
  Call_TimeSeriesHierarchiesExecuteBatch_564122 = ref object of OpenApiRestCall_563566
proc url_TimeSeriesHierarchiesExecuteBatch_564124(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_TimeSeriesHierarchiesExecuteBatch_564123(path: JsonNode;
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
  var valid_564125 = query.getOrDefault("api-version")
  valid_564125 = validateParameter(valid_564125, JString, required = true,
                                 default = newJString("2018-11-01-preview"))
  if valid_564125 != nil:
    section.add "api-version", valid_564125
  result.add "query", section
  ## parameters in `header` object:
  ##   x-ms-client-request-id: JString
  ##                         : Optional client request ID. Service records this value. Allows the service to trace operation across services, and allows the customer to contact support regarding a particular request.
  ##   x-ms-client-session-id: JString
  ##                         : Optional client session ID. Service records this value. Allows the service to trace a group of related operations across services, and allows the customer to contact support regarding a particular group of requests.
  section = newJObject()
  var valid_564126 = header.getOrDefault("x-ms-client-request-id")
  valid_564126 = validateParameter(valid_564126, JString, required = false,
                                 default = nil)
  if valid_564126 != nil:
    section.add "x-ms-client-request-id", valid_564126
  var valid_564127 = header.getOrDefault("x-ms-client-session-id")
  valid_564127 = validateParameter(valid_564127, JString, required = false,
                                 default = nil)
  if valid_564127 != nil:
    section.add "x-ms-client-session-id", valid_564127
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

proc call*(call_564129: Call_TimeSeriesHierarchiesExecuteBatch_564122;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Executes a batch get, create, update, delete operation on multiple time series hierarchy definitions.
  ## 
  let valid = call_564129.validator(path, query, header, formData, body)
  let scheme = call_564129.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564129.url(scheme.get, call_564129.host, call_564129.base,
                         call_564129.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564129, url, valid)

proc call*(call_564130: Call_TimeSeriesHierarchiesExecuteBatch_564122;
          parameters: JsonNode; apiVersion: string = "2018-11-01-preview"): Recallable =
  ## timeSeriesHierarchiesExecuteBatch
  ## Executes a batch get, create, update, delete operation on multiple time series hierarchy definitions.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Currently supported version is "2018-11-01-preview".
  ##   parameters: JObject (required)
  ##             : Time series hierarchies batch request body.
  var query_564131 = newJObject()
  var body_564132 = newJObject()
  add(query_564131, "api-version", newJString(apiVersion))
  if parameters != nil:
    body_564132 = parameters
  result = call_564130.call(nil, query_564131, nil, nil, body_564132)

var timeSeriesHierarchiesExecuteBatch* = Call_TimeSeriesHierarchiesExecuteBatch_564122(
    name: "timeSeriesHierarchiesExecuteBatch", meth: HttpMethod.HttpPost,
    host: "azure.local", route: "/timeseries/hierarchies/$batch",
    validator: validate_TimeSeriesHierarchiesExecuteBatch_564123, base: "",
    url: url_TimeSeriesHierarchiesExecuteBatch_564124, schemes: {Scheme.Https})
type
  Call_TimeSeriesInstancesGet_564133 = ref object of OpenApiRestCall_563566
proc url_TimeSeriesInstancesGet_564135(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_TimeSeriesInstancesGet_564134(path: JsonNode; query: JsonNode;
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
  var valid_564136 = query.getOrDefault("api-version")
  valid_564136 = validateParameter(valid_564136, JString, required = true,
                                 default = newJString("2018-11-01-preview"))
  if valid_564136 != nil:
    section.add "api-version", valid_564136
  result.add "query", section
  ## parameters in `header` object:
  ##   x-ms-continuation: JString
  ##                    : Continuation token from previous page of results to retrieve the next page of the results in calls that support pagination. To get the first page results, specify null continuation token as parameter value. Returned continuation token is null if all results have been returned, and there is no next page of results.
  ##   x-ms-client-request-id: JString
  ##                         : Optional client request ID. Service records this value. Allows the service to trace operation across services, and allows the customer to contact support regarding a particular request.
  ##   x-ms-client-session-id: JString
  ##                         : Optional client session ID. Service records this value. Allows the service to trace a group of related operations across services, and allows the customer to contact support regarding a particular group of requests.
  section = newJObject()
  var valid_564137 = header.getOrDefault("x-ms-continuation")
  valid_564137 = validateParameter(valid_564137, JString, required = false,
                                 default = nil)
  if valid_564137 != nil:
    section.add "x-ms-continuation", valid_564137
  var valid_564138 = header.getOrDefault("x-ms-client-request-id")
  valid_564138 = validateParameter(valid_564138, JString, required = false,
                                 default = nil)
  if valid_564138 != nil:
    section.add "x-ms-client-request-id", valid_564138
  var valid_564139 = header.getOrDefault("x-ms-client-session-id")
  valid_564139 = validateParameter(valid_564139, JString, required = false,
                                 default = nil)
  if valid_564139 != nil:
    section.add "x-ms-client-session-id", valid_564139
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564140: Call_TimeSeriesInstancesGet_564133; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets time series instances in pages.
  ## 
  let valid = call_564140.validator(path, query, header, formData, body)
  let scheme = call_564140.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564140.url(scheme.get, call_564140.host, call_564140.base,
                         call_564140.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564140, url, valid)

proc call*(call_564141: Call_TimeSeriesInstancesGet_564133;
          apiVersion: string = "2018-11-01-preview"): Recallable =
  ## timeSeriesInstancesGet
  ## Gets time series instances in pages.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Currently supported version is "2018-11-01-preview".
  var query_564142 = newJObject()
  add(query_564142, "api-version", newJString(apiVersion))
  result = call_564141.call(nil, query_564142, nil, nil, nil)

var timeSeriesInstancesGet* = Call_TimeSeriesInstancesGet_564133(
    name: "timeSeriesInstancesGet", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/timeseries/instances", validator: validate_TimeSeriesInstancesGet_564134,
    base: "", url: url_TimeSeriesInstancesGet_564135, schemes: {Scheme.Https})
type
  Call_TimeSeriesInstancesExecuteBatch_564143 = ref object of OpenApiRestCall_563566
proc url_TimeSeriesInstancesExecuteBatch_564145(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_TimeSeriesInstancesExecuteBatch_564144(path: JsonNode;
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
  var valid_564146 = query.getOrDefault("api-version")
  valid_564146 = validateParameter(valid_564146, JString, required = true,
                                 default = newJString("2018-11-01-preview"))
  if valid_564146 != nil:
    section.add "api-version", valid_564146
  result.add "query", section
  ## parameters in `header` object:
  ##   x-ms-client-request-id: JString
  ##                         : Optional client request ID. Service records this value. Allows the service to trace operation across services, and allows the customer to contact support regarding a particular request.
  ##   x-ms-client-session-id: JString
  ##                         : Optional client session ID. Service records this value. Allows the service to trace a group of related operations across services, and allows the customer to contact support regarding a particular group of requests.
  section = newJObject()
  var valid_564147 = header.getOrDefault("x-ms-client-request-id")
  valid_564147 = validateParameter(valid_564147, JString, required = false,
                                 default = nil)
  if valid_564147 != nil:
    section.add "x-ms-client-request-id", valid_564147
  var valid_564148 = header.getOrDefault("x-ms-client-session-id")
  valid_564148 = validateParameter(valid_564148, JString, required = false,
                                 default = nil)
  if valid_564148 != nil:
    section.add "x-ms-client-session-id", valid_564148
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

proc call*(call_564150: Call_TimeSeriesInstancesExecuteBatch_564143;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Executes a batch get, create, update, delete operation on multiple time series instances.
  ## 
  let valid = call_564150.validator(path, query, header, formData, body)
  let scheme = call_564150.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564150.url(scheme.get, call_564150.host, call_564150.base,
                         call_564150.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564150, url, valid)

proc call*(call_564151: Call_TimeSeriesInstancesExecuteBatch_564143;
          parameters: JsonNode; apiVersion: string = "2018-11-01-preview"): Recallable =
  ## timeSeriesInstancesExecuteBatch
  ## Executes a batch get, create, update, delete operation on multiple time series instances.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Currently supported version is "2018-11-01-preview".
  ##   parameters: JObject (required)
  ##             : Time series instances suggest request body.
  var query_564152 = newJObject()
  var body_564153 = newJObject()
  add(query_564152, "api-version", newJString(apiVersion))
  if parameters != nil:
    body_564153 = parameters
  result = call_564151.call(nil, query_564152, nil, nil, body_564153)

var timeSeriesInstancesExecuteBatch* = Call_TimeSeriesInstancesExecuteBatch_564143(
    name: "timeSeriesInstancesExecuteBatch", meth: HttpMethod.HttpPost,
    host: "azure.local", route: "/timeseries/instances/$batch",
    validator: validate_TimeSeriesInstancesExecuteBatch_564144, base: "",
    url: url_TimeSeriesInstancesExecuteBatch_564145, schemes: {Scheme.Https})
type
  Call_TimeSeriesInstancesSearch_564154 = ref object of OpenApiRestCall_563566
proc url_TimeSeriesInstancesSearch_564156(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_TimeSeriesInstancesSearch_564155(path: JsonNode; query: JsonNode;
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
  var valid_564157 = query.getOrDefault("api-version")
  valid_564157 = validateParameter(valid_564157, JString, required = true,
                                 default = newJString("2018-11-01-preview"))
  if valid_564157 != nil:
    section.add "api-version", valid_564157
  result.add "query", section
  ## parameters in `header` object:
  ##   x-ms-continuation: JString
  ##                    : Continuation token from previous page of results to retrieve the next page of the results in calls that support pagination. To get the first page results, specify null continuation token as parameter value. Returned continuation token is null if all results have been returned, and there is no next page of results.
  ##   x-ms-client-request-id: JString
  ##                         : Optional client request ID. Service records this value. Allows the service to trace operation across services, and allows the customer to contact support regarding a particular request.
  ##   x-ms-client-session-id: JString
  ##                         : Optional client session ID. Service records this value. Allows the service to trace a group of related operations across services, and allows the customer to contact support regarding a particular group of requests.
  section = newJObject()
  var valid_564158 = header.getOrDefault("x-ms-continuation")
  valid_564158 = validateParameter(valid_564158, JString, required = false,
                                 default = nil)
  if valid_564158 != nil:
    section.add "x-ms-continuation", valid_564158
  var valid_564159 = header.getOrDefault("x-ms-client-request-id")
  valid_564159 = validateParameter(valid_564159, JString, required = false,
                                 default = nil)
  if valid_564159 != nil:
    section.add "x-ms-client-request-id", valid_564159
  var valid_564160 = header.getOrDefault("x-ms-client-session-id")
  valid_564160 = validateParameter(valid_564160, JString, required = false,
                                 default = nil)
  if valid_564160 != nil:
    section.add "x-ms-client-session-id", valid_564160
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

proc call*(call_564162: Call_TimeSeriesInstancesSearch_564154; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Partial list of hits on search for time series instances based on instance attributes.
  ## 
  let valid = call_564162.validator(path, query, header, formData, body)
  let scheme = call_564162.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564162.url(scheme.get, call_564162.host, call_564162.base,
                         call_564162.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564162, url, valid)

proc call*(call_564163: Call_TimeSeriesInstancesSearch_564154;
          parameters: JsonNode; apiVersion: string = "2018-11-01-preview"): Recallable =
  ## timeSeriesInstancesSearch
  ## Partial list of hits on search for time series instances based on instance attributes.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Currently supported version is "2018-11-01-preview".
  ##   parameters: JObject (required)
  ##             : Time series instances search request body.
  var query_564164 = newJObject()
  var body_564165 = newJObject()
  add(query_564164, "api-version", newJString(apiVersion))
  if parameters != nil:
    body_564165 = parameters
  result = call_564163.call(nil, query_564164, nil, nil, body_564165)

var timeSeriesInstancesSearch* = Call_TimeSeriesInstancesSearch_564154(
    name: "timeSeriesInstancesSearch", meth: HttpMethod.HttpPost,
    host: "azure.local", route: "/timeseries/instances/search",
    validator: validate_TimeSeriesInstancesSearch_564155, base: "",
    url: url_TimeSeriesInstancesSearch_564156, schemes: {Scheme.Https})
type
  Call_TimeSeriesInstancesSuggest_564166 = ref object of OpenApiRestCall_563566
proc url_TimeSeriesInstancesSuggest_564168(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_TimeSeriesInstancesSuggest_564167(path: JsonNode; query: JsonNode;
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
  var valid_564169 = query.getOrDefault("api-version")
  valid_564169 = validateParameter(valid_564169, JString, required = true,
                                 default = newJString("2018-11-01-preview"))
  if valid_564169 != nil:
    section.add "api-version", valid_564169
  result.add "query", section
  ## parameters in `header` object:
  ##   x-ms-client-request-id: JString
  ##                         : Optional client request ID. Service records this value. Allows the service to trace operation across services, and allows the customer to contact support regarding a particular request.
  ##   x-ms-client-session-id: JString
  ##                         : Optional client session ID. Service records this value. Allows the service to trace a group of related operations across services, and allows the customer to contact support regarding a particular group of requests.
  section = newJObject()
  var valid_564170 = header.getOrDefault("x-ms-client-request-id")
  valid_564170 = validateParameter(valid_564170, JString, required = false,
                                 default = nil)
  if valid_564170 != nil:
    section.add "x-ms-client-request-id", valid_564170
  var valid_564171 = header.getOrDefault("x-ms-client-session-id")
  valid_564171 = validateParameter(valid_564171, JString, required = false,
                                 default = nil)
  if valid_564171 != nil:
    section.add "x-ms-client-session-id", valid_564171
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

proc call*(call_564173: Call_TimeSeriesInstancesSuggest_564166; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Suggests keywords based on time series instance attributes to be later used in Search Instances.
  ## 
  let valid = call_564173.validator(path, query, header, formData, body)
  let scheme = call_564173.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564173.url(scheme.get, call_564173.host, call_564173.base,
                         call_564173.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564173, url, valid)

proc call*(call_564174: Call_TimeSeriesInstancesSuggest_564166;
          parameters: JsonNode; apiVersion: string = "2018-11-01-preview"): Recallable =
  ## timeSeriesInstancesSuggest
  ## Suggests keywords based on time series instance attributes to be later used in Search Instances.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Currently supported version is "2018-11-01-preview".
  ##   parameters: JObject (required)
  ##             : Time series instances suggest request body.
  var query_564175 = newJObject()
  var body_564176 = newJObject()
  add(query_564175, "api-version", newJString(apiVersion))
  if parameters != nil:
    body_564176 = parameters
  result = call_564174.call(nil, query_564175, nil, nil, body_564176)

var timeSeriesInstancesSuggest* = Call_TimeSeriesInstancesSuggest_564166(
    name: "timeSeriesInstancesSuggest", meth: HttpMethod.HttpPost,
    host: "azure.local", route: "/timeseries/instances/suggest",
    validator: validate_TimeSeriesInstancesSuggest_564167, base: "",
    url: url_TimeSeriesInstancesSuggest_564168, schemes: {Scheme.Https})
type
  Call_ModelSettingsGet_564177 = ref object of OpenApiRestCall_563566
proc url_ModelSettingsGet_564179(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_ModelSettingsGet_564178(path: JsonNode; query: JsonNode;
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
  var valid_564180 = query.getOrDefault("api-version")
  valid_564180 = validateParameter(valid_564180, JString, required = true,
                                 default = newJString("2018-11-01-preview"))
  if valid_564180 != nil:
    section.add "api-version", valid_564180
  result.add "query", section
  ## parameters in `header` object:
  ##   x-ms-client-request-id: JString
  ##                         : Optional client request ID. Service records this value. Allows the service to trace operation across services, and allows the customer to contact support regarding a particular request.
  ##   x-ms-client-session-id: JString
  ##                         : Optional client session ID. Service records this value. Allows the service to trace a group of related operations across services, and allows the customer to contact support regarding a particular group of requests.
  section = newJObject()
  var valid_564181 = header.getOrDefault("x-ms-client-request-id")
  valid_564181 = validateParameter(valid_564181, JString, required = false,
                                 default = nil)
  if valid_564181 != nil:
    section.add "x-ms-client-request-id", valid_564181
  var valid_564182 = header.getOrDefault("x-ms-client-session-id")
  valid_564182 = validateParameter(valid_564182, JString, required = false,
                                 default = nil)
  if valid_564182 != nil:
    section.add "x-ms-client-session-id", valid_564182
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564183: Call_ModelSettingsGet_564177; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the model settings which includes model display name, Time Series ID properties and default type ID. Every pay-as-you-go environment has a model that is automatically created.
  ## 
  let valid = call_564183.validator(path, query, header, formData, body)
  let scheme = call_564183.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564183.url(scheme.get, call_564183.host, call_564183.base,
                         call_564183.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564183, url, valid)

proc call*(call_564184: Call_ModelSettingsGet_564177;
          apiVersion: string = "2018-11-01-preview"): Recallable =
  ## modelSettingsGet
  ## Returns the model settings which includes model display name, Time Series ID properties and default type ID. Every pay-as-you-go environment has a model that is automatically created.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Currently supported version is "2018-11-01-preview".
  var query_564185 = newJObject()
  add(query_564185, "api-version", newJString(apiVersion))
  result = call_564184.call(nil, query_564185, nil, nil, nil)

var modelSettingsGet* = Call_ModelSettingsGet_564177(name: "modelSettingsGet",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/timeseries/modelSettings", validator: validate_ModelSettingsGet_564178,
    base: "", url: url_ModelSettingsGet_564179, schemes: {Scheme.Https})
type
  Call_ModelSettingsUpdate_564186 = ref object of OpenApiRestCall_563566
proc url_ModelSettingsUpdate_564188(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_ModelSettingsUpdate_564187(path: JsonNode; query: JsonNode;
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
  var valid_564189 = query.getOrDefault("api-version")
  valid_564189 = validateParameter(valid_564189, JString, required = true,
                                 default = newJString("2018-11-01-preview"))
  if valid_564189 != nil:
    section.add "api-version", valid_564189
  result.add "query", section
  ## parameters in `header` object:
  ##   x-ms-client-request-id: JString
  ##                         : Optional client request ID. Service records this value. Allows the service to trace operation across services, and allows the customer to contact support regarding a particular request.
  ##   x-ms-client-session-id: JString
  ##                         : Optional client session ID. Service records this value. Allows the service to trace a group of related operations across services, and allows the customer to contact support regarding a particular group of requests.
  section = newJObject()
  var valid_564190 = header.getOrDefault("x-ms-client-request-id")
  valid_564190 = validateParameter(valid_564190, JString, required = false,
                                 default = nil)
  if valid_564190 != nil:
    section.add "x-ms-client-request-id", valid_564190
  var valid_564191 = header.getOrDefault("x-ms-client-session-id")
  valid_564191 = validateParameter(valid_564191, JString, required = false,
                                 default = nil)
  if valid_564191 != nil:
    section.add "x-ms-client-session-id", valid_564191
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

proc call*(call_564193: Call_ModelSettingsUpdate_564186; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates time series model settings - either the model name or default type ID.
  ## 
  let valid = call_564193.validator(path, query, header, formData, body)
  let scheme = call_564193.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564193.url(scheme.get, call_564193.host, call_564193.base,
                         call_564193.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564193, url, valid)

proc call*(call_564194: Call_ModelSettingsUpdate_564186; parameters: JsonNode;
          apiVersion: string = "2018-11-01-preview"): Recallable =
  ## modelSettingsUpdate
  ## Updates time series model settings - either the model name or default type ID.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Currently supported version is "2018-11-01-preview".
  ##   parameters: JObject (required)
  ##             : Model settings update request body.
  var query_564195 = newJObject()
  var body_564196 = newJObject()
  add(query_564195, "api-version", newJString(apiVersion))
  if parameters != nil:
    body_564196 = parameters
  result = call_564194.call(nil, query_564195, nil, nil, body_564196)

var modelSettingsUpdate* = Call_ModelSettingsUpdate_564186(
    name: "modelSettingsUpdate", meth: HttpMethod.HttpPatch, host: "azure.local",
    route: "/timeseries/modelSettings", validator: validate_ModelSettingsUpdate_564187,
    base: "", url: url_ModelSettingsUpdate_564188, schemes: {Scheme.Https})
type
  Call_QueryExecute_564197 = ref object of OpenApiRestCall_563566
proc url_QueryExecute_564199(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_QueryExecute_564198(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_564200 = query.getOrDefault("api-version")
  valid_564200 = validateParameter(valid_564200, JString, required = true,
                                 default = newJString("2018-11-01-preview"))
  if valid_564200 != nil:
    section.add "api-version", valid_564200
  result.add "query", section
  ## parameters in `header` object:
  ##   x-ms-continuation: JString
  ##                    : Continuation token from previous page of results to retrieve the next page of the results in calls that support pagination. To get the first page results, specify null continuation token as parameter value. Returned continuation token is null if all results have been returned, and there is no next page of results.
  ##   x-ms-client-request-id: JString
  ##                         : Optional client request ID. Service records this value. Allows the service to trace operation across services, and allows the customer to contact support regarding a particular request.
  ##   x-ms-client-session-id: JString
  ##                         : Optional client session ID. Service records this value. Allows the service to trace a group of related operations across services, and allows the customer to contact support regarding a particular group of requests.
  section = newJObject()
  var valid_564201 = header.getOrDefault("x-ms-continuation")
  valid_564201 = validateParameter(valid_564201, JString, required = false,
                                 default = nil)
  if valid_564201 != nil:
    section.add "x-ms-continuation", valid_564201
  var valid_564202 = header.getOrDefault("x-ms-client-request-id")
  valid_564202 = validateParameter(valid_564202, JString, required = false,
                                 default = nil)
  if valid_564202 != nil:
    section.add "x-ms-client-request-id", valid_564202
  var valid_564203 = header.getOrDefault("x-ms-client-session-id")
  valid_564203 = validateParameter(valid_564203, JString, required = false,
                                 default = nil)
  if valid_564203 != nil:
    section.add "x-ms-client-session-id", valid_564203
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

proc call*(call_564205: Call_QueryExecute_564197; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Executes Time Series Query in pages of results - Get Events, Get Series or Aggregate Series.
  ## 
  let valid = call_564205.validator(path, query, header, formData, body)
  let scheme = call_564205.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564205.url(scheme.get, call_564205.host, call_564205.base,
                         call_564205.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564205, url, valid)

proc call*(call_564206: Call_QueryExecute_564197; parameters: JsonNode;
          apiVersion: string = "2018-11-01-preview"): Recallable =
  ## queryExecute
  ## Executes Time Series Query in pages of results - Get Events, Get Series or Aggregate Series.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Currently supported version is "2018-11-01-preview".
  ##   parameters: JObject (required)
  ##             : Time series query request body.
  var query_564207 = newJObject()
  var body_564208 = newJObject()
  add(query_564207, "api-version", newJString(apiVersion))
  if parameters != nil:
    body_564208 = parameters
  result = call_564206.call(nil, query_564207, nil, nil, body_564208)

var queryExecute* = Call_QueryExecute_564197(name: "queryExecute",
    meth: HttpMethod.HttpPost, host: "azure.local", route: "/timeseries/query",
    validator: validate_QueryExecute_564198, base: "", url: url_QueryExecute_564199,
    schemes: {Scheme.Https})
type
  Call_TimeSeriesTypesGet_564209 = ref object of OpenApiRestCall_563566
proc url_TimeSeriesTypesGet_564211(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_TimeSeriesTypesGet_564210(path: JsonNode; query: JsonNode;
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
  var valid_564212 = query.getOrDefault("api-version")
  valid_564212 = validateParameter(valid_564212, JString, required = true,
                                 default = newJString("2018-11-01-preview"))
  if valid_564212 != nil:
    section.add "api-version", valid_564212
  result.add "query", section
  ## parameters in `header` object:
  ##   x-ms-continuation: JString
  ##                    : Continuation token from previous page of results to retrieve the next page of the results in calls that support pagination. To get the first page results, specify null continuation token as parameter value. Returned continuation token is null if all results have been returned, and there is no next page of results.
  ##   x-ms-client-request-id: JString
  ##                         : Optional client request ID. Service records this value. Allows the service to trace operation across services, and allows the customer to contact support regarding a particular request.
  ##   x-ms-client-session-id: JString
  ##                         : Optional client session ID. Service records this value. Allows the service to trace a group of related operations across services, and allows the customer to contact support regarding a particular group of requests.
  section = newJObject()
  var valid_564213 = header.getOrDefault("x-ms-continuation")
  valid_564213 = validateParameter(valid_564213, JString, required = false,
                                 default = nil)
  if valid_564213 != nil:
    section.add "x-ms-continuation", valid_564213
  var valid_564214 = header.getOrDefault("x-ms-client-request-id")
  valid_564214 = validateParameter(valid_564214, JString, required = false,
                                 default = nil)
  if valid_564214 != nil:
    section.add "x-ms-client-request-id", valid_564214
  var valid_564215 = header.getOrDefault("x-ms-client-session-id")
  valid_564215 = validateParameter(valid_564215, JString, required = false,
                                 default = nil)
  if valid_564215 != nil:
    section.add "x-ms-client-session-id", valid_564215
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564216: Call_TimeSeriesTypesGet_564209; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets time series types in pages.
  ## 
  let valid = call_564216.validator(path, query, header, formData, body)
  let scheme = call_564216.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564216.url(scheme.get, call_564216.host, call_564216.base,
                         call_564216.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564216, url, valid)

proc call*(call_564217: Call_TimeSeriesTypesGet_564209;
          apiVersion: string = "2018-11-01-preview"): Recallable =
  ## timeSeriesTypesGet
  ## Gets time series types in pages.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Currently supported version is "2018-11-01-preview".
  var query_564218 = newJObject()
  add(query_564218, "api-version", newJString(apiVersion))
  result = call_564217.call(nil, query_564218, nil, nil, nil)

var timeSeriesTypesGet* = Call_TimeSeriesTypesGet_564209(
    name: "timeSeriesTypesGet", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/timeseries/types", validator: validate_TimeSeriesTypesGet_564210,
    base: "", url: url_TimeSeriesTypesGet_564211, schemes: {Scheme.Https})
type
  Call_TimeSeriesTypesExecuteBatch_564219 = ref object of OpenApiRestCall_563566
proc url_TimeSeriesTypesExecuteBatch_564221(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_TimeSeriesTypesExecuteBatch_564220(path: JsonNode; query: JsonNode;
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
  var valid_564222 = query.getOrDefault("api-version")
  valid_564222 = validateParameter(valid_564222, JString, required = true,
                                 default = newJString("2018-11-01-preview"))
  if valid_564222 != nil:
    section.add "api-version", valid_564222
  result.add "query", section
  ## parameters in `header` object:
  ##   x-ms-client-request-id: JString
  ##                         : Optional client request ID. Service records this value. Allows the service to trace operation across services, and allows the customer to contact support regarding a particular request.
  ##   x-ms-client-session-id: JString
  ##                         : Optional client session ID. Service records this value. Allows the service to trace a group of related operations across services, and allows the customer to contact support regarding a particular group of requests.
  section = newJObject()
  var valid_564223 = header.getOrDefault("x-ms-client-request-id")
  valid_564223 = validateParameter(valid_564223, JString, required = false,
                                 default = nil)
  if valid_564223 != nil:
    section.add "x-ms-client-request-id", valid_564223
  var valid_564224 = header.getOrDefault("x-ms-client-session-id")
  valid_564224 = validateParameter(valid_564224, JString, required = false,
                                 default = nil)
  if valid_564224 != nil:
    section.add "x-ms-client-session-id", valid_564224
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

proc call*(call_564226: Call_TimeSeriesTypesExecuteBatch_564219; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Executes a batch get, create, update, delete operation on multiple time series types.
  ## 
  let valid = call_564226.validator(path, query, header, formData, body)
  let scheme = call_564226.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564226.url(scheme.get, call_564226.host, call_564226.base,
                         call_564226.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564226, url, valid)

proc call*(call_564227: Call_TimeSeriesTypesExecuteBatch_564219;
          parameters: JsonNode; apiVersion: string = "2018-11-01-preview"): Recallable =
  ## timeSeriesTypesExecuteBatch
  ## Executes a batch get, create, update, delete operation on multiple time series types.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Currently supported version is "2018-11-01-preview".
  ##   parameters: JObject (required)
  ##             : Time series types batch request body.
  var query_564228 = newJObject()
  var body_564229 = newJObject()
  add(query_564228, "api-version", newJString(apiVersion))
  if parameters != nil:
    body_564229 = parameters
  result = call_564227.call(nil, query_564228, nil, nil, body_564229)

var timeSeriesTypesExecuteBatch* = Call_TimeSeriesTypesExecuteBatch_564219(
    name: "timeSeriesTypesExecuteBatch", meth: HttpMethod.HttpPost,
    host: "azure.local", route: "/timeseries/types/$batch",
    validator: validate_TimeSeriesTypesExecuteBatch_564220, base: "",
    url: url_TimeSeriesTypesExecuteBatch_564221, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
