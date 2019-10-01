
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: MonitorManagementClient
## version: 2018-01-01
## termsOfService: (not provided)
## license: (not provided)
## 
## 
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

  OpenApiRestCall_567657 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_567657](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_567657): Option[Scheme] {.used.} =
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
  macServiceName = "monitor-metrics_API"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_MetricsList_567879 = ref object of OpenApiRestCall_567657
proc url_MetricsList_567881(protocol: Scheme; host: string; base: string;
                           route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "resourceUri" in path, "`resourceUri` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceUri"), (
        kind: ConstantSegment, value: "/providers/microsoft.insights/metrics")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MetricsList_567880(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## **Lists the metric values for a resource**.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceUri: JString (required)
  ##              : The identifier of the resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceUri` field"
  var valid_568055 = path.getOrDefault("resourceUri")
  valid_568055 = validateParameter(valid_568055, JString, required = true,
                                 default = nil)
  if valid_568055 != nil:
    section.add "resourceUri", valid_568055
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   metricnames: JString
  ##              : The names of the metrics (comma separated) to retrieve.
  ##   orderby: JString
  ##          : The aggregation to use for sorting results and the direction of the sort.
  ## Only one order can be specified.
  ## Examples: sum asc.
  ##   timespan: JString
  ##           : The timespan of the query. It is a string with the following format 'startDateTime_ISO/endDateTime_ISO'.
  ##   resultType: JString
  ##             : Reduces the set of data collected. The syntax allowed depends on the operation. See the operation's description for details.
  ##   top: JInt
  ##      : The maximum number of records to retrieve.
  ## Valid only if $filter is specified.
  ## Defaults to 10.
  ##   metricnamespace: JString
  ##                  : Metric namespace to query metric definitions for.
  ##   interval: JString
  ##           : The interval (i.e. timegrain) of the query.
  ##   aggregation: JString
  ##              : The list of aggregation types (comma separated) to retrieve.
  ##   $filter: JString
  ##          : The **$filter** is used to reduce the set of metric data returned.<br>Example:<br>Metric contains metadata A, B and C.<br>- Return all time series of C where A = a1 and B = b1 or b2<br>**$filter=A eq ‘a1’ and B eq ‘b1’ or B eq ‘b2’ and C eq ‘*’**<br>- Invalid variant:<br>**$filter=A eq ‘a1’ and B eq ‘b1’ and C eq ‘*’ or B = ‘b2’**<br>This is invalid because the logical or operator cannot separate two different metadata names.<br>- Return all time series where A = a1, B = b1 and C = c1:<br>**$filter=A eq ‘a1’ and B eq ‘b1’ and C eq ‘c1’**<br>- Return all time series where A = a1<br>**$filter=A eq ‘a1’ and B eq ‘*’ and C eq ‘*’**.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568056 = query.getOrDefault("api-version")
  valid_568056 = validateParameter(valid_568056, JString, required = true,
                                 default = nil)
  if valid_568056 != nil:
    section.add "api-version", valid_568056
  var valid_568057 = query.getOrDefault("metricnames")
  valid_568057 = validateParameter(valid_568057, JString, required = false,
                                 default = nil)
  if valid_568057 != nil:
    section.add "metricnames", valid_568057
  var valid_568058 = query.getOrDefault("orderby")
  valid_568058 = validateParameter(valid_568058, JString, required = false,
                                 default = nil)
  if valid_568058 != nil:
    section.add "orderby", valid_568058
  var valid_568059 = query.getOrDefault("timespan")
  valid_568059 = validateParameter(valid_568059, JString, required = false,
                                 default = nil)
  if valid_568059 != nil:
    section.add "timespan", valid_568059
  var valid_568073 = query.getOrDefault("resultType")
  valid_568073 = validateParameter(valid_568073, JString, required = false,
                                 default = newJString("Data"))
  if valid_568073 != nil:
    section.add "resultType", valid_568073
  var valid_568074 = query.getOrDefault("top")
  valid_568074 = validateParameter(valid_568074, JInt, required = false, default = nil)
  if valid_568074 != nil:
    section.add "top", valid_568074
  var valid_568075 = query.getOrDefault("metricnamespace")
  valid_568075 = validateParameter(valid_568075, JString, required = false,
                                 default = nil)
  if valid_568075 != nil:
    section.add "metricnamespace", valid_568075
  var valid_568076 = query.getOrDefault("interval")
  valid_568076 = validateParameter(valid_568076, JString, required = false,
                                 default = nil)
  if valid_568076 != nil:
    section.add "interval", valid_568076
  var valid_568077 = query.getOrDefault("aggregation")
  valid_568077 = validateParameter(valid_568077, JString, required = false,
                                 default = nil)
  if valid_568077 != nil:
    section.add "aggregation", valid_568077
  var valid_568078 = query.getOrDefault("$filter")
  valid_568078 = validateParameter(valid_568078, JString, required = false,
                                 default = nil)
  if valid_568078 != nil:
    section.add "$filter", valid_568078
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568101: Call_MetricsList_567879; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## **Lists the metric values for a resource**.
  ## 
  let valid = call_568101.validator(path, query, header, formData, body)
  let scheme = call_568101.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568101.url(scheme.get, call_568101.host, call_568101.base,
                         call_568101.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568101, url, valid)

proc call*(call_568172: Call_MetricsList_567879; apiVersion: string;
          resourceUri: string; metricnames: string = ""; orderby: string = "";
          timespan: string = ""; resultType: string = "Data"; top: int = 0;
          metricnamespace: string = ""; interval: string = ""; aggregation: string = "";
          Filter: string = ""): Recallable =
  ## metricsList
  ## **Lists the metric values for a resource**.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   metricnames: string
  ##              : The names of the metrics (comma separated) to retrieve.
  ##   orderby: string
  ##          : The aggregation to use for sorting results and the direction of the sort.
  ## Only one order can be specified.
  ## Examples: sum asc.
  ##   timespan: string
  ##           : The timespan of the query. It is a string with the following format 'startDateTime_ISO/endDateTime_ISO'.
  ##   resultType: string
  ##             : Reduces the set of data collected. The syntax allowed depends on the operation. See the operation's description for details.
  ##   top: int
  ##      : The maximum number of records to retrieve.
  ## Valid only if $filter is specified.
  ## Defaults to 10.
  ##   metricnamespace: string
  ##                  : Metric namespace to query metric definitions for.
  ##   interval: string
  ##           : The interval (i.e. timegrain) of the query.
  ##   resourceUri: string (required)
  ##              : The identifier of the resource.
  ##   aggregation: string
  ##              : The list of aggregation types (comma separated) to retrieve.
  ##   Filter: string
  ##         : The **$filter** is used to reduce the set of metric data returned.<br>Example:<br>Metric contains metadata A, B and C.<br>- Return all time series of C where A = a1 and B = b1 or b2<br>**$filter=A eq ‘a1’ and B eq ‘b1’ or B eq ‘b2’ and C eq ‘*’**<br>- Invalid variant:<br>**$filter=A eq ‘a1’ and B eq ‘b1’ and C eq ‘*’ or B = ‘b2’**<br>This is invalid because the logical or operator cannot separate two different metadata names.<br>- Return all time series where A = a1, B = b1 and C = c1:<br>**$filter=A eq ‘a1’ and B eq ‘b1’ and C eq ‘c1’**<br>- Return all time series where A = a1<br>**$filter=A eq ‘a1’ and B eq ‘*’ and C eq ‘*’**.
  var path_568173 = newJObject()
  var query_568175 = newJObject()
  add(query_568175, "api-version", newJString(apiVersion))
  add(query_568175, "metricnames", newJString(metricnames))
  add(query_568175, "orderby", newJString(orderby))
  add(query_568175, "timespan", newJString(timespan))
  add(query_568175, "resultType", newJString(resultType))
  add(query_568175, "top", newJInt(top))
  add(query_568175, "metricnamespace", newJString(metricnamespace))
  add(query_568175, "interval", newJString(interval))
  add(path_568173, "resourceUri", newJString(resourceUri))
  add(query_568175, "aggregation", newJString(aggregation))
  add(query_568175, "$filter", newJString(Filter))
  result = call_568172.call(path_568173, query_568175, nil, nil, nil)

var metricsList* = Call_MetricsList_567879(name: "metricsList",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/{resourceUri}/providers/microsoft.insights/metrics",
                                        validator: validate_MetricsList_567880,
                                        base: "", url: url_MetricsList_567881,
                                        schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
