
import
  json, options, hashes, uri, rest, os, uri, httpcore

## auto-generated via openapi macro
## title: MonitorClient
## version: 2016-09-01
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

  OpenApiRestCall_563556 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_563556](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_563556): Option[Scheme] {.used.} =
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
  Call_MetricsList_563778 = ref object of OpenApiRestCall_563556
proc url_MetricsList_563780(protocol: Scheme; host: string; base: string;
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

proc validate_MetricsList_563779(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the metric values for a resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceUri: JString (required)
  ##              : The identifier of the resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceUri` field"
  var valid_563956 = path.getOrDefault("resourceUri")
  valid_563956 = validateParameter(valid_563956, JString, required = true,
                                 default = nil)
  if valid_563956 != nil:
    section.add "resourceUri", valid_563956
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $filter: JString
  ##          : Reduces the set of data collected.<br>The filter is optional. If present it must contain a list of metric names to retrieve of the form: *(name.value eq 'metricName' [or name.value eq 'metricName' or ...])*. Optionally, the filter can contain conditions for the following attributes *aggregationType*, *startTime*, *endTime*, and *timeGrain* of the form *attributeName operator value*. Where operator is one of *ne*, *eq*, *gt*, *lt*.<br>Several conditions can be combined with parentheses and logical operators, e.g: *and*, *or*.<br>Some example filter expressions are:<br>- $filter=(name.value eq 'RunsSucceeded') and aggregationType eq 'Total' and startTime eq 2016-02-20 and endTime eq 2016-02-21 and timeGrain eq duration'PT1M',<br>- $filter=(name.value eq 'RunsSucceeded') and (aggregationType eq 'Total' or aggregationType eq 'Average') and startTime eq 2016-02-20 and endTime eq 2016-02-21 and timeGrain eq duration'PT1H',<br>- $filter=(name.value eq 'ActionsCompleted' or name.value eq 'RunsSucceeded') and (aggregationType eq 'Total' or aggregationType eq 'Average') and startTime eq 2016-02-20 and endTime eq 2016-02-21 and timeGrain eq duration'PT1M'.<br><br>**NOTE**: When a metrics query comes in with multiple metrics, but with no aggregation types defined, the service will pick the Primary aggregation type of the first metrics to be used as the default aggregation type for all the metrics.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_563957 = query.getOrDefault("api-version")
  valid_563957 = validateParameter(valid_563957, JString, required = true,
                                 default = nil)
  if valid_563957 != nil:
    section.add "api-version", valid_563957
  var valid_563958 = query.getOrDefault("$filter")
  valid_563958 = validateParameter(valid_563958, JString, required = false,
                                 default = nil)
  if valid_563958 != nil:
    section.add "$filter", valid_563958
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_563981: Call_MetricsList_563778; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the metric values for a resource.
  ## 
  let valid = call_563981.validator(path, query, header, formData, body)
  let scheme = call_563981.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_563981.url(scheme.get, call_563981.host, call_563981.base,
                         call_563981.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_563981, url, valid)

proc call*(call_564052: Call_MetricsList_563778; apiVersion: string;
          resourceUri: string; Filter: string = ""): Recallable =
  ## metricsList
  ## Lists the metric values for a resource.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   resourceUri: string (required)
  ##              : The identifier of the resource.
  ##   Filter: string
  ##         : Reduces the set of data collected.<br>The filter is optional. If present it must contain a list of metric names to retrieve of the form: *(name.value eq 'metricName' [or name.value eq 'metricName' or ...])*. Optionally, the filter can contain conditions for the following attributes *aggregationType*, *startTime*, *endTime*, and *timeGrain* of the form *attributeName operator value*. Where operator is one of *ne*, *eq*, *gt*, *lt*.<br>Several conditions can be combined with parentheses and logical operators, e.g: *and*, *or*.<br>Some example filter expressions are:<br>- $filter=(name.value eq 'RunsSucceeded') and aggregationType eq 'Total' and startTime eq 2016-02-20 and endTime eq 2016-02-21 and timeGrain eq duration'PT1M',<br>- $filter=(name.value eq 'RunsSucceeded') and (aggregationType eq 'Total' or aggregationType eq 'Average') and startTime eq 2016-02-20 and endTime eq 2016-02-21 and timeGrain eq duration'PT1H',<br>- $filter=(name.value eq 'ActionsCompleted' or name.value eq 'RunsSucceeded') and (aggregationType eq 'Total' or aggregationType eq 'Average') and startTime eq 2016-02-20 and endTime eq 2016-02-21 and timeGrain eq duration'PT1M'.<br><br>**NOTE**: When a metrics query comes in with multiple metrics, but with no aggregation types defined, the service will pick the Primary aggregation type of the first metrics to be used as the default aggregation type for all the metrics.
  var path_564053 = newJObject()
  var query_564055 = newJObject()
  add(query_564055, "api-version", newJString(apiVersion))
  add(path_564053, "resourceUri", newJString(resourceUri))
  add(query_564055, "$filter", newJString(Filter))
  result = call_564052.call(path_564053, query_564055, nil, nil, nil)

var metricsList* = Call_MetricsList_563778(name: "metricsList",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/{resourceUri}/providers/microsoft.insights/metrics",
                                        validator: validate_MetricsList_563779,
                                        base: "", url: url_MetricsList_563780,
                                        schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
