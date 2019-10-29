
import
  json, options, hashes, uri, rest, os, uri, httpcore

## auto-generated via openapi macro
## title: MonitorManagementClient
## version: 2018-09-01
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
  Call_BaselineGet_563778 = ref object of OpenApiRestCall_563556
proc url_BaselineGet_563780(protocol: Scheme; host: string; base: string;
                           route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "resourceUri" in path, "`resourceUri` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceUri"), (
        kind: ConstantSegment, value: "/providers/microsoft.insights/baseline")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BaselineGet_563779(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## **Gets the baseline values for a resource**.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceUri: JString (required)
  ##              : The identifier of the resource. It has the following structure: 
  ## subscriptions/{subscriptionName}/resourceGroups/{resourceGroupName}/providers/{providerName}/{resourceName}. For example: 
  ## subscriptions/b368ca2f-e298-46b7-b0ab-012281956afa/resourceGroups/vms/providers/Microsoft.Compute/virtualMachines/vm1
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
  ##   aggregation: JString
  ##              : The aggregation type of the metric to retrieve the baseline for.
  ##   timespan: JString
  ##           : The timespan of the query. It is a string with the following format 'startDateTime_ISO/endDateTime_ISO'.
  ##   metricnamespace: JString
  ##                  : Metric namespace to query metric definitions for.
  ##   interval: JString
  ##           : The interval (i.e. timegrain) of the query.
  ##   resultType: JString
  ##             : Allows retrieving only metadata of the baseline. On data request all information is retrieved.
  ##   sensitivities: JString
  ##                : The list of sensitivities (comma separated) to retrieve.
  ##   metricnames: JString
  ##              : The names of the metrics (comma separated) to retrieve.
  ##   $filter: JString
  ##          : The **$filter** is used to describe a set of dimensions with their concrete values which produce a specific metric's time series, in which a baseline is requested for.
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
  var valid_563960 = query.getOrDefault("metricnamespace")
  valid_563960 = validateParameter(valid_563960, JString, required = false,
                                 default = nil)
  if valid_563960 != nil:
    section.add "metricnamespace", valid_563960
  var valid_563961 = query.getOrDefault("interval")
  valid_563961 = validateParameter(valid_563961, JString, required = false,
                                 default = nil)
  if valid_563961 != nil:
    section.add "interval", valid_563961
  var valid_563975 = query.getOrDefault("resultType")
  valid_563975 = validateParameter(valid_563975, JString, required = false,
                                 default = newJString("Data"))
  if valid_563975 != nil:
    section.add "resultType", valid_563975
  var valid_563976 = query.getOrDefault("sensitivities")
  valid_563976 = validateParameter(valid_563976, JString, required = false,
                                 default = nil)
  if valid_563976 != nil:
    section.add "sensitivities", valid_563976
  var valid_563977 = query.getOrDefault("metricnames")
  valid_563977 = validateParameter(valid_563977, JString, required = false,
                                 default = nil)
  if valid_563977 != nil:
    section.add "metricnames", valid_563977
  var valid_563978 = query.getOrDefault("$filter")
  valid_563978 = validateParameter(valid_563978, JString, required = false,
                                 default = nil)
  if valid_563978 != nil:
    section.add "$filter", valid_563978
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564001: Call_BaselineGet_563778; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## **Gets the baseline values for a resource**.
  ## 
  let valid = call_564001.validator(path, query, header, formData, body)
  let scheme = call_564001.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564001.url(scheme.get, call_564001.host, call_564001.base,
                         call_564001.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564001, url, valid)

proc call*(call_564072: Call_BaselineGet_563778; apiVersion: string;
          resourceUri: string; aggregation: string = ""; timespan: string = "";
          metricnamespace: string = ""; interval: string = "";
          resultType: string = "Data"; sensitivities: string = "";
          metricnames: string = ""; Filter: string = ""): Recallable =
  ## baselineGet
  ## **Gets the baseline values for a resource**.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   aggregation: string
  ##              : The aggregation type of the metric to retrieve the baseline for.
  ##   timespan: string
  ##           : The timespan of the query. It is a string with the following format 'startDateTime_ISO/endDateTime_ISO'.
  ##   metricnamespace: string
  ##                  : Metric namespace to query metric definitions for.
  ##   interval: string
  ##           : The interval (i.e. timegrain) of the query.
  ##   resultType: string
  ##             : Allows retrieving only metadata of the baseline. On data request all information is retrieved.
  ##   sensitivities: string
  ##                : The list of sensitivities (comma separated) to retrieve.
  ##   metricnames: string
  ##              : The names of the metrics (comma separated) to retrieve.
  ##   resourceUri: string (required)
  ##              : The identifier of the resource. It has the following structure: 
  ## subscriptions/{subscriptionName}/resourceGroups/{resourceGroupName}/providers/{providerName}/{resourceName}. For example: 
  ## subscriptions/b368ca2f-e298-46b7-b0ab-012281956afa/resourceGroups/vms/providers/Microsoft.Compute/virtualMachines/vm1
  ##   Filter: string
  ##         : The **$filter** is used to describe a set of dimensions with their concrete values which produce a specific metric's time series, in which a baseline is requested for.
  var path_564073 = newJObject()
  var query_564075 = newJObject()
  add(query_564075, "api-version", newJString(apiVersion))
  add(query_564075, "aggregation", newJString(aggregation))
  add(query_564075, "timespan", newJString(timespan))
  add(query_564075, "metricnamespace", newJString(metricnamespace))
  add(query_564075, "interval", newJString(interval))
  add(query_564075, "resultType", newJString(resultType))
  add(query_564075, "sensitivities", newJString(sensitivities))
  add(query_564075, "metricnames", newJString(metricnames))
  add(path_564073, "resourceUri", newJString(resourceUri))
  add(query_564075, "$filter", newJString(Filter))
  result = call_564072.call(path_564073, query_564075, nil, nil, nil)

var baselineGet* = Call_BaselineGet_563778(name: "baselineGet",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/{resourceUri}/providers/microsoft.insights/baseline",
                                        validator: validate_BaselineGet_563779,
                                        base: "", url: url_BaselineGet_563780,
                                        schemes: {Scheme.Https})
type
  Call_MetricBaselineGet_564114 = ref object of OpenApiRestCall_563556
proc url_MetricBaselineGet_564116(protocol: Scheme; host: string; base: string;
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

proc validate_MetricBaselineGet_564115(path: JsonNode; query: JsonNode;
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
  var valid_564117 = path.getOrDefault("resourceUri")
  valid_564117 = validateParameter(valid_564117, JString, required = true,
                                 default = nil)
  if valid_564117 != nil:
    section.add "resourceUri", valid_564117
  var valid_564118 = path.getOrDefault("metricName")
  valid_564118 = validateParameter(valid_564118, JString, required = true,
                                 default = nil)
  if valid_564118 != nil:
    section.add "metricName", valid_564118
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   aggregation: JString
  ##              : The aggregation type of the metric to retrieve the baseline for.
  ##   timespan: JString
  ##           : The timespan of the query. It is a string with the following format 'startDateTime_ISO/endDateTime_ISO'.
  ##   metricnamespace: JString
  ##                  : Metric namespace to query metric definitions for.
  ##   interval: JString
  ##           : The interval (i.e. timegrain) of the query.
  ##   resultType: JString
  ##             : Allows retrieving only metadata of the baseline. On data request all information is retrieved.
  ##   sensitivities: JString
  ##                : The list of sensitivities (comma separated) to retrieve.
  ##   $filter: JString
  ##          : The **$filter** is used to describe a set of dimensions with their concrete values which produce a specific metric's time series, in which a baseline is requested for.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564119 = query.getOrDefault("api-version")
  valid_564119 = validateParameter(valid_564119, JString, required = true,
                                 default = nil)
  if valid_564119 != nil:
    section.add "api-version", valid_564119
  var valid_564120 = query.getOrDefault("aggregation")
  valid_564120 = validateParameter(valid_564120, JString, required = false,
                                 default = nil)
  if valid_564120 != nil:
    section.add "aggregation", valid_564120
  var valid_564121 = query.getOrDefault("timespan")
  valid_564121 = validateParameter(valid_564121, JString, required = false,
                                 default = nil)
  if valid_564121 != nil:
    section.add "timespan", valid_564121
  var valid_564122 = query.getOrDefault("metricnamespace")
  valid_564122 = validateParameter(valid_564122, JString, required = false,
                                 default = nil)
  if valid_564122 != nil:
    section.add "metricnamespace", valid_564122
  var valid_564123 = query.getOrDefault("interval")
  valid_564123 = validateParameter(valid_564123, JString, required = false,
                                 default = nil)
  if valid_564123 != nil:
    section.add "interval", valid_564123
  var valid_564124 = query.getOrDefault("resultType")
  valid_564124 = validateParameter(valid_564124, JString, required = false,
                                 default = newJString("Data"))
  if valid_564124 != nil:
    section.add "resultType", valid_564124
  var valid_564125 = query.getOrDefault("sensitivities")
  valid_564125 = validateParameter(valid_564125, JString, required = false,
                                 default = nil)
  if valid_564125 != nil:
    section.add "sensitivities", valid_564125
  var valid_564126 = query.getOrDefault("$filter")
  valid_564126 = validateParameter(valid_564126, JString, required = false,
                                 default = nil)
  if valid_564126 != nil:
    section.add "$filter", valid_564126
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564127: Call_MetricBaselineGet_564114; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## **Gets the baseline values for a specific metric**.
  ## 
  let valid = call_564127.validator(path, query, header, formData, body)
  let scheme = call_564127.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564127.url(scheme.get, call_564127.host, call_564127.base,
                         call_564127.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564127, url, valid)

proc call*(call_564128: Call_MetricBaselineGet_564114; apiVersion: string;
          resourceUri: string; metricName: string; aggregation: string = "";
          timespan: string = ""; metricnamespace: string = ""; interval: string = "";
          resultType: string = "Data"; sensitivities: string = ""; Filter: string = ""): Recallable =
  ## metricBaselineGet
  ## **Gets the baseline values for a specific metric**.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   aggregation: string
  ##              : The aggregation type of the metric to retrieve the baseline for.
  ##   timespan: string
  ##           : The timespan of the query. It is a string with the following format 'startDateTime_ISO/endDateTime_ISO'.
  ##   metricnamespace: string
  ##                  : Metric namespace to query metric definitions for.
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
  ##   Filter: string
  ##         : The **$filter** is used to describe a set of dimensions with their concrete values which produce a specific metric's time series, in which a baseline is requested for.
  ##   metricName: string (required)
  ##             : The name of the metric to retrieve the baseline for.
  var path_564129 = newJObject()
  var query_564130 = newJObject()
  add(query_564130, "api-version", newJString(apiVersion))
  add(query_564130, "aggregation", newJString(aggregation))
  add(query_564130, "timespan", newJString(timespan))
  add(query_564130, "metricnamespace", newJString(metricnamespace))
  add(query_564130, "interval", newJString(interval))
  add(query_564130, "resultType", newJString(resultType))
  add(query_564130, "sensitivities", newJString(sensitivities))
  add(path_564129, "resourceUri", newJString(resourceUri))
  add(query_564130, "$filter", newJString(Filter))
  add(path_564129, "metricName", newJString(metricName))
  result = call_564128.call(path_564129, query_564130, nil, nil, nil)

var metricBaselineGet* = Call_MetricBaselineGet_564114(name: "metricBaselineGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/{resourceUri}/providers/microsoft.insights/baseline/{metricName}",
    validator: validate_MetricBaselineGet_564115, base: "",
    url: url_MetricBaselineGet_564116, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
