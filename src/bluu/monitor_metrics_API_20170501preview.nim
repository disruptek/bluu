
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: MonitorManagementClient
## version: 2017-05-01-preview
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

  OpenApiRestCall_593424 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_593424](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_593424): Option[Scheme] {.used.} =
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
  macServiceName = "monitor-metrics_API"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_MetricsList_593646 = ref object of OpenApiRestCall_593424
proc url_MetricsList_593648(protocol: Scheme; host: string; base: string;
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

proc validate_MetricsList_593647(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_593822 = path.getOrDefault("resourceUri")
  valid_593822 = validateParameter(valid_593822, JString, required = true,
                                 default = nil)
  if valid_593822 != nil:
    section.add "resourceUri", valid_593822
  result.add "path", section
  ## parameters in `query` object:
  ##   $orderby: JString
  ##           : The aggregation to use for sorting results and the direction of the sort.
  ## Only one order can be specified.
  ## Examples: sum asc.
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   timespan: JString
  ##           : The timespan of the query. It is a string with the following format 'startDateTime_ISO/endDateTime_ISO'.
  ##   resultType: JString
  ##             : Reduces the set of data collected. The syntax allowed depends on the operation. See the operation's description for details.
  ##   $top: JFloat
  ##       : The maximum number of records to retrieve.
  ## Valid only if $filter is specified.
  ## Defaults to 10.
  ##   metric: JString
  ##         : The name of the metric to retrieve.
  ##   interval: JString
  ##           : The interval (i.e. timegrain) of the query.
  ##   aggregation: JString
  ##              : The list of aggregation types (comma separated) to retrieve.
  ##   $filter: JString
  ##          : The **$filter** is used to reduce the set of metric data returned.<br>Example:<br>Metric contains metadata A, B and C.<br>- Return all time series of C where A = a1 and B = b1 or b2<br>**$filter=A eq ‘a1’ and B eq ‘b1’ or B eq ‘b2’ and C eq ‘*’**<br>- Invalid variant:<br>**$filter=A eq ‘a1’ and B eq ‘b1’ and C eq ‘*’ or B = ‘b2’**<br>This is invalid because the logical or operator cannot separate two different metadata names.<br>- Return all time series where A = a1, B = b1 and C = c1:<br>**$filter=A eq ‘a1’ and B eq ‘b1’ and C eq ‘c1’**<br>- Return all time series where A = a1<br>**$filter=A eq ‘a1’ and B eq ‘*’ and C eq ‘*’**.
  section = newJObject()
  var valid_593823 = query.getOrDefault("$orderby")
  valid_593823 = validateParameter(valid_593823, JString, required = false,
                                 default = nil)
  if valid_593823 != nil:
    section.add "$orderby", valid_593823
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593824 = query.getOrDefault("api-version")
  valid_593824 = validateParameter(valid_593824, JString, required = true,
                                 default = nil)
  if valid_593824 != nil:
    section.add "api-version", valid_593824
  var valid_593825 = query.getOrDefault("timespan")
  valid_593825 = validateParameter(valid_593825, JString, required = false,
                                 default = nil)
  if valid_593825 != nil:
    section.add "timespan", valid_593825
  var valid_593839 = query.getOrDefault("resultType")
  valid_593839 = validateParameter(valid_593839, JString, required = false,
                                 default = newJString("Data"))
  if valid_593839 != nil:
    section.add "resultType", valid_593839
  var valid_593840 = query.getOrDefault("$top")
  valid_593840 = validateParameter(valid_593840, JFloat, required = false,
                                 default = nil)
  if valid_593840 != nil:
    section.add "$top", valid_593840
  var valid_593841 = query.getOrDefault("metric")
  valid_593841 = validateParameter(valid_593841, JString, required = false,
                                 default = nil)
  if valid_593841 != nil:
    section.add "metric", valid_593841
  var valid_593842 = query.getOrDefault("interval")
  valid_593842 = validateParameter(valid_593842, JString, required = false,
                                 default = nil)
  if valid_593842 != nil:
    section.add "interval", valid_593842
  var valid_593843 = query.getOrDefault("aggregation")
  valid_593843 = validateParameter(valid_593843, JString, required = false,
                                 default = nil)
  if valid_593843 != nil:
    section.add "aggregation", valid_593843
  var valid_593844 = query.getOrDefault("$filter")
  valid_593844 = validateParameter(valid_593844, JString, required = false,
                                 default = nil)
  if valid_593844 != nil:
    section.add "$filter", valid_593844
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593867: Call_MetricsList_593646; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## **Lists the metric values for a resource**.
  ## 
  let valid = call_593867.validator(path, query, header, formData, body)
  let scheme = call_593867.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593867.url(scheme.get, call_593867.host, call_593867.base,
                         call_593867.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593867, url, valid)

proc call*(call_593938: Call_MetricsList_593646; apiVersion: string;
          resourceUri: string; Orderby: string = ""; timespan: string = "";
          resultType: string = "Data"; Top: float = 0.0; metric: string = "";
          interval: string = ""; aggregation: string = ""; Filter: string = ""): Recallable =
  ## metricsList
  ## **Lists the metric values for a resource**.
  ##   Orderby: string
  ##          : The aggregation to use for sorting results and the direction of the sort.
  ## Only one order can be specified.
  ## Examples: sum asc.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   timespan: string
  ##           : The timespan of the query. It is a string with the following format 'startDateTime_ISO/endDateTime_ISO'.
  ##   resultType: string
  ##             : Reduces the set of data collected. The syntax allowed depends on the operation. See the operation's description for details.
  ##   Top: float
  ##      : The maximum number of records to retrieve.
  ## Valid only if $filter is specified.
  ## Defaults to 10.
  ##   metric: string
  ##         : The name of the metric to retrieve.
  ##   interval: string
  ##           : The interval (i.e. timegrain) of the query.
  ##   resourceUri: string (required)
  ##              : The identifier of the resource.
  ##   aggregation: string
  ##              : The list of aggregation types (comma separated) to retrieve.
  ##   Filter: string
  ##         : The **$filter** is used to reduce the set of metric data returned.<br>Example:<br>Metric contains metadata A, B and C.<br>- Return all time series of C where A = a1 and B = b1 or b2<br>**$filter=A eq ‘a1’ and B eq ‘b1’ or B eq ‘b2’ and C eq ‘*’**<br>- Invalid variant:<br>**$filter=A eq ‘a1’ and B eq ‘b1’ and C eq ‘*’ or B = ‘b2’**<br>This is invalid because the logical or operator cannot separate two different metadata names.<br>- Return all time series where A = a1, B = b1 and C = c1:<br>**$filter=A eq ‘a1’ and B eq ‘b1’ and C eq ‘c1’**<br>- Return all time series where A = a1<br>**$filter=A eq ‘a1’ and B eq ‘*’ and C eq ‘*’**.
  var path_593939 = newJObject()
  var query_593941 = newJObject()
  add(query_593941, "$orderby", newJString(Orderby))
  add(query_593941, "api-version", newJString(apiVersion))
  add(query_593941, "timespan", newJString(timespan))
  add(query_593941, "resultType", newJString(resultType))
  add(query_593941, "$top", newJFloat(Top))
  add(query_593941, "metric", newJString(metric))
  add(query_593941, "interval", newJString(interval))
  add(path_593939, "resourceUri", newJString(resourceUri))
  add(query_593941, "aggregation", newJString(aggregation))
  add(query_593941, "$filter", newJString(Filter))
  result = call_593938.call(path_593939, query_593941, nil, nil, nil)

var metricsList* = Call_MetricsList_593646(name: "metricsList",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/{resourceUri}/providers/microsoft.insights/metrics",
                                        validator: validate_MetricsList_593647,
                                        base: "", url: url_MetricsList_593648,
                                        schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
