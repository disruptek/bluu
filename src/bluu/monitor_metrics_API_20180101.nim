
import
  json, options, hashes, uri, rest, os, uri, httpcore

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

  OpenApiRestCall_563555 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_563555](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_563555): Option[Scheme] {.used.} =
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
  macServiceName = "monitor-metrics_API"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_MetricsList_563777 = ref object of OpenApiRestCall_563555
proc url_MetricsList_563779(protocol: Scheme; host: string; base: string;
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

proc validate_MetricsList_563778(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_563955 = path.getOrDefault("resourceUri")
  valid_563955 = validateParameter(valid_563955, JString, required = true,
                                 default = nil)
  if valid_563955 != nil:
    section.add "resourceUri", valid_563955
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   aggregation: JString
  ##              : The list of aggregation types (comma separated) to retrieve.
  ##   timespan: JString
  ##           : The timespan of the query. It is a string with the following format 'startDateTime_ISO/endDateTime_ISO'.
  ##   metricnamespace: JString
  ##                  : Metric namespace to query metric definitions for.
  ##   interval: JString
  ##           : The interval (i.e. timegrain) of the query.
  ##   resultType: JString
  ##             : Reduces the set of data collected. The syntax allowed depends on the operation. See the operation's description for details.
  ##   orderby: JString
  ##          : The aggregation to use for sorting results and the direction of the sort.
  ## Only one order can be specified.
  ## Examples: sum asc.
  ##   metricnames: JString
  ##              : The names of the metrics (comma separated) to retrieve.
  ##   $filter: JString
  ##          : The **$filter** is used to reduce the set of metric data returned.<br>Example:<br>Metric contains metadata A, B and C.<br>- Return all time series of C where A = a1 and B = b1 or b2<br>**$filter=A eq ‘a1’ and B eq ‘b1’ or B eq ‘b2’ and C eq ‘*’**<br>- Invalid variant:<br>**$filter=A eq ‘a1’ and B eq ‘b1’ and C eq ‘*’ or B = ‘b2’**<br>This is invalid because the logical or operator cannot separate two different metadata names.<br>- Return all time series where A = a1, B = b1 and C = c1:<br>**$filter=A eq ‘a1’ and B eq ‘b1’ and C eq ‘c1’**<br>- Return all time series where A = a1<br>**$filter=A eq ‘a1’ and B eq ‘*’ and C eq ‘*’**.
  ##   top: JInt
  ##      : The maximum number of records to retrieve.
  ## Valid only if $filter is specified.
  ## Defaults to 10.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_563956 = query.getOrDefault("api-version")
  valid_563956 = validateParameter(valid_563956, JString, required = true,
                                 default = nil)
  if valid_563956 != nil:
    section.add "api-version", valid_563956
  var valid_563957 = query.getOrDefault("aggregation")
  valid_563957 = validateParameter(valid_563957, JString, required = false,
                                 default = nil)
  if valid_563957 != nil:
    section.add "aggregation", valid_563957
  var valid_563958 = query.getOrDefault("timespan")
  valid_563958 = validateParameter(valid_563958, JString, required = false,
                                 default = nil)
  if valid_563958 != nil:
    section.add "timespan", valid_563958
  var valid_563959 = query.getOrDefault("metricnamespace")
  valid_563959 = validateParameter(valid_563959, JString, required = false,
                                 default = nil)
  if valid_563959 != nil:
    section.add "metricnamespace", valid_563959
  var valid_563960 = query.getOrDefault("interval")
  valid_563960 = validateParameter(valid_563960, JString, required = false,
                                 default = nil)
  if valid_563960 != nil:
    section.add "interval", valid_563960
  var valid_563974 = query.getOrDefault("resultType")
  valid_563974 = validateParameter(valid_563974, JString, required = false,
                                 default = newJString("Data"))
  if valid_563974 != nil:
    section.add "resultType", valid_563974
  var valid_563975 = query.getOrDefault("orderby")
  valid_563975 = validateParameter(valid_563975, JString, required = false,
                                 default = nil)
  if valid_563975 != nil:
    section.add "orderby", valid_563975
  var valid_563976 = query.getOrDefault("metricnames")
  valid_563976 = validateParameter(valid_563976, JString, required = false,
                                 default = nil)
  if valid_563976 != nil:
    section.add "metricnames", valid_563976
  var valid_563977 = query.getOrDefault("$filter")
  valid_563977 = validateParameter(valid_563977, JString, required = false,
                                 default = nil)
  if valid_563977 != nil:
    section.add "$filter", valid_563977
  var valid_563978 = query.getOrDefault("top")
  valid_563978 = validateParameter(valid_563978, JInt, required = false, default = nil)
  if valid_563978 != nil:
    section.add "top", valid_563978
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564001: Call_MetricsList_563777; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## **Lists the metric values for a resource**.
  ## 
  let valid = call_564001.validator(path, query, header, formData, body)
  let scheme = call_564001.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564001.url(scheme.get, call_564001.host, call_564001.base,
                         call_564001.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564001, url, valid)

proc call*(call_564072: Call_MetricsList_563777; apiVersion: string;
          resourceUri: string; aggregation: string = ""; timespan: string = "";
          metricnamespace: string = ""; interval: string = "";
          resultType: string = "Data"; orderby: string = ""; metricnames: string = "";
          Filter: string = ""; top: int = 0): Recallable =
  ## metricsList
  ## **Lists the metric values for a resource**.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   aggregation: string
  ##              : The list of aggregation types (comma separated) to retrieve.
  ##   timespan: string
  ##           : The timespan of the query. It is a string with the following format 'startDateTime_ISO/endDateTime_ISO'.
  ##   metricnamespace: string
  ##                  : Metric namespace to query metric definitions for.
  ##   interval: string
  ##           : The interval (i.e. timegrain) of the query.
  ##   resultType: string
  ##             : Reduces the set of data collected. The syntax allowed depends on the operation. See the operation's description for details.
  ##   orderby: string
  ##          : The aggregation to use for sorting results and the direction of the sort.
  ## Only one order can be specified.
  ## Examples: sum asc.
  ##   metricnames: string
  ##              : The names of the metrics (comma separated) to retrieve.
  ##   resourceUri: string (required)
  ##              : The identifier of the resource.
  ##   Filter: string
  ##         : The **$filter** is used to reduce the set of metric data returned.<br>Example:<br>Metric contains metadata A, B and C.<br>- Return all time series of C where A = a1 and B = b1 or b2<br>**$filter=A eq ‘a1’ and B eq ‘b1’ or B eq ‘b2’ and C eq ‘*’**<br>- Invalid variant:<br>**$filter=A eq ‘a1’ and B eq ‘b1’ and C eq ‘*’ or B = ‘b2’**<br>This is invalid because the logical or operator cannot separate two different metadata names.<br>- Return all time series where A = a1, B = b1 and C = c1:<br>**$filter=A eq ‘a1’ and B eq ‘b1’ and C eq ‘c1’**<br>- Return all time series where A = a1<br>**$filter=A eq ‘a1’ and B eq ‘*’ and C eq ‘*’**.
  ##   top: int
  ##      : The maximum number of records to retrieve.
  ## Valid only if $filter is specified.
  ## Defaults to 10.
  var path_564073 = newJObject()
  var query_564075 = newJObject()
  add(query_564075, "api-version", newJString(apiVersion))
  add(query_564075, "aggregation", newJString(aggregation))
  add(query_564075, "timespan", newJString(timespan))
  add(query_564075, "metricnamespace", newJString(metricnamespace))
  add(query_564075, "interval", newJString(interval))
  add(query_564075, "resultType", newJString(resultType))
  add(query_564075, "orderby", newJString(orderby))
  add(query_564075, "metricnames", newJString(metricnames))
  add(path_564073, "resourceUri", newJString(resourceUri))
  add(query_564075, "$filter", newJString(Filter))
  add(query_564075, "top", newJInt(top))
  result = call_564072.call(path_564073, query_564075, nil, nil, nil)

var metricsList* = Call_MetricsList_563777(name: "metricsList",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/{resourceUri}/providers/microsoft.insights/metrics",
                                        validator: validate_MetricsList_563778,
                                        base: "", url: url_MetricsList_563779,
                                        schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
