
import
  json, options, hashes, uri, rest, os, uri, httpcore

## auto-generated via openapi macro
## title: MonitorManagementClient
## version: 2017-11-01-preview
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
  macServiceName = "monitor-baseline_API"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_MetricBaselineGet_563778 = ref object of OpenApiRestCall_563556
proc url_MetricBaselineGet_563780(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "resourceUri" in path, "`resourceUri` is a required path parameter"
  assert "metricName" in path, "`metricName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceUri"), (
        kind: ConstantSegment, value: "/providers/microsoft.insights/baseline/"),
               (kind: VariableSegment, value: "metricName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MetricBaselineGet_563779(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## **Gets the baseline values for a specific metric**.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceUri: JString (required)
  ##              : The identifier of the resource. It has the following structure: 
  ## subscriptions/{subscriptionName}/resourceGroups/{resourceGroupName}/providers/{providerName}/{resourceName}. For example: 
  ## subscriptions/b368ca2f-e298-46b7-b0ab-012281956afa/resourceGroups/vms/providers/Microsoft.Compute/virtualMachines/vm1
  ##   metricName: JString (required)
  ##             : The name of the metric to retrieve the baseline for.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceUri` field"
  var valid_563955 = path.getOrDefault("resourceUri")
  valid_563955 = validateParameter(valid_563955, JString, required = true,
                                 default = nil)
  if valid_563955 != nil:
    section.add "resourceUri", valid_563955
  var valid_563956 = path.getOrDefault("metricName")
  valid_563956 = validateParameter(valid_563956, JString, required = true,
                                 default = nil)
  if valid_563956 != nil:
    section.add "metricName", valid_563956
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   aggregation: JString
  ##              : The aggregation type of the metric to retrieve the baseline for.
  ##   timespan: JString
  ##           : The timespan of the query. It is a string with the following format 'startDateTime_ISO/endDateTime_ISO'.
  ##   interval: JString
  ##           : The interval (i.e. timegrain) of the query.
  ##   resultType: JString
  ##             : Allows retrieving only metadata of the baseline. On data request all information is retrieved.
  ##   sensitivities: JString
  ##                : The list of sensitivities (comma separated) to retrieve.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_563957 = query.getOrDefault("api-version")
  valid_563957 = validateParameter(valid_563957, JString, required = true,
                                 default = nil)
  if valid_563957 != nil:
    section.add "api-version", valid_563957
  var valid_563958 = query.getOrDefault("aggregation")
  valid_563958 = validateParameter(valid_563958, JString, required = false,
                                 default = nil)
  if valid_563958 != nil:
    section.add "aggregation", valid_563958
  var valid_563959 = query.getOrDefault("timespan")
  valid_563959 = validateParameter(valid_563959, JString, required = false,
                                 default = nil)
  if valid_563959 != nil:
    section.add "timespan", valid_563959
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
  var valid_563975 = query.getOrDefault("sensitivities")
  valid_563975 = validateParameter(valid_563975, JString, required = false,
                                 default = nil)
  if valid_563975 != nil:
    section.add "sensitivities", valid_563975
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_563998: Call_MetricBaselineGet_563778; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## **Gets the baseline values for a specific metric**.
  ## 
  let valid = call_563998.validator(path, query, header, formData, body)
  let scheme = call_563998.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_563998.url(scheme.get, call_563998.host, call_563998.base,
                         call_563998.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_563998, url, valid)

proc call*(call_564069: Call_MetricBaselineGet_563778; apiVersion: string;
          resourceUri: string; metricName: string; aggregation: string = "";
          timespan: string = ""; interval: string = ""; resultType: string = "Data";
          sensitivities: string = ""): Recallable =
  ## metricBaselineGet
  ## **Gets the baseline values for a specific metric**.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   aggregation: string
  ##              : The aggregation type of the metric to retrieve the baseline for.
  ##   timespan: string
  ##           : The timespan of the query. It is a string with the following format 'startDateTime_ISO/endDateTime_ISO'.
  ##   interval: string
  ##           : The interval (i.e. timegrain) of the query.
  ##   resultType: string
  ##             : Allows retrieving only metadata of the baseline. On data request all information is retrieved.
  ##   sensitivities: string
  ##                : The list of sensitivities (comma separated) to retrieve.
  ##   resourceUri: string (required)
  ##              : The identifier of the resource. It has the following structure: 
  ## subscriptions/{subscriptionName}/resourceGroups/{resourceGroupName}/providers/{providerName}/{resourceName}. For example: 
  ## subscriptions/b368ca2f-e298-46b7-b0ab-012281956afa/resourceGroups/vms/providers/Microsoft.Compute/virtualMachines/vm1
  ##   metricName: string (required)
  ##             : The name of the metric to retrieve the baseline for.
  var path_564070 = newJObject()
  var query_564072 = newJObject()
  add(query_564072, "api-version", newJString(apiVersion))
  add(query_564072, "aggregation", newJString(aggregation))
  add(query_564072, "timespan", newJString(timespan))
  add(query_564072, "interval", newJString(interval))
  add(query_564072, "resultType", newJString(resultType))
  add(query_564072, "sensitivities", newJString(sensitivities))
  add(path_564070, "resourceUri", newJString(resourceUri))
  add(path_564070, "metricName", newJString(metricName))
  result = call_564069.call(path_564070, query_564072, nil, nil, nil)

var metricBaselineGet* = Call_MetricBaselineGet_563778(name: "metricBaselineGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/{resourceUri}/providers/microsoft.insights/baseline/{metricName}",
    validator: validate_MetricBaselineGet_563779, base: "",
    url: url_MetricBaselineGet_563780, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
