
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

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

  OpenApiRestCall_567658 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_567658](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_567658): Option[Scheme] {.used.} =
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
  macServiceName = "monitor-baseline_API"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_BaselineGet_567880 = ref object of OpenApiRestCall_567658
proc url_BaselineGet_567882(protocol: Scheme; host: string; base: string;
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

proc validate_BaselineGet_567881(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_568056 = path.getOrDefault("resourceUri")
  valid_568056 = validateParameter(valid_568056, JString, required = true,
                                 default = nil)
  if valid_568056 != nil:
    section.add "resourceUri", valid_568056
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   metricnames: JString
  ##              : The names of the metrics (comma separated) to retrieve.
  ##   metricnamespace: JString
  ##                  : Metric namespace to query metric definitions for.
  ##   timespan: JString
  ##           : The timespan of the query. It is a string with the following format 'startDateTime_ISO/endDateTime_ISO'.
  ##   resultType: JString
  ##             : Allows retrieving only metadata of the baseline. On data request all information is retrieved.
  ##   sensitivities: JString
  ##                : The list of sensitivities (comma separated) to retrieve.
  ##   interval: JString
  ##           : The interval (i.e. timegrain) of the query.
  ##   aggregation: JString
  ##              : The aggregation type of the metric to retrieve the baseline for.
  ##   $filter: JString
  ##          : The **$filter** is used to describe a set of dimensions with their concrete values which produce a specific metric's time series, in which a baseline is requested for.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568057 = query.getOrDefault("api-version")
  valid_568057 = validateParameter(valid_568057, JString, required = true,
                                 default = nil)
  if valid_568057 != nil:
    section.add "api-version", valid_568057
  var valid_568058 = query.getOrDefault("metricnames")
  valid_568058 = validateParameter(valid_568058, JString, required = false,
                                 default = nil)
  if valid_568058 != nil:
    section.add "metricnames", valid_568058
  var valid_568059 = query.getOrDefault("metricnamespace")
  valid_568059 = validateParameter(valid_568059, JString, required = false,
                                 default = nil)
  if valid_568059 != nil:
    section.add "metricnamespace", valid_568059
  var valid_568060 = query.getOrDefault("timespan")
  valid_568060 = validateParameter(valid_568060, JString, required = false,
                                 default = nil)
  if valid_568060 != nil:
    section.add "timespan", valid_568060
  var valid_568074 = query.getOrDefault("resultType")
  valid_568074 = validateParameter(valid_568074, JString, required = false,
                                 default = newJString("Data"))
  if valid_568074 != nil:
    section.add "resultType", valid_568074
  var valid_568075 = query.getOrDefault("sensitivities")
  valid_568075 = validateParameter(valid_568075, JString, required = false,
                                 default = nil)
  if valid_568075 != nil:
    section.add "sensitivities", valid_568075
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

proc call*(call_568101: Call_BaselineGet_567880; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## **Gets the baseline values for a resource**.
  ## 
  let valid = call_568101.validator(path, query, header, formData, body)
  let scheme = call_568101.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568101.url(scheme.get, call_568101.host, call_568101.base,
                         call_568101.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568101, url, valid)

proc call*(call_568172: Call_BaselineGet_567880; apiVersion: string;
          resourceUri: string; metricnames: string = ""; metricnamespace: string = "";
          timespan: string = ""; resultType: string = "Data";
          sensitivities: string = ""; interval: string = ""; aggregation: string = "";
          Filter: string = ""): Recallable =
  ## baselineGet
  ## **Gets the baseline values for a resource**.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   metricnames: string
  ##              : The names of the metrics (comma separated) to retrieve.
  ##   metricnamespace: string
  ##                  : Metric namespace to query metric definitions for.
  ##   timespan: string
  ##           : The timespan of the query. It is a string with the following format 'startDateTime_ISO/endDateTime_ISO'.
  ##   resultType: string
  ##             : Allows retrieving only metadata of the baseline. On data request all information is retrieved.
  ##   sensitivities: string
  ##                : The list of sensitivities (comma separated) to retrieve.
  ##   interval: string
  ##           : The interval (i.e. timegrain) of the query.
  ##   resourceUri: string (required)
  ##              : The identifier of the resource. It has the following structure: 
  ## subscriptions/{subscriptionName}/resourceGroups/{resourceGroupName}/providers/{providerName}/{resourceName}. For example: 
  ## subscriptions/b368ca2f-e298-46b7-b0ab-012281956afa/resourceGroups/vms/providers/Microsoft.Compute/virtualMachines/vm1
  ##   aggregation: string
  ##              : The aggregation type of the metric to retrieve the baseline for.
  ##   Filter: string
  ##         : The **$filter** is used to describe a set of dimensions with their concrete values which produce a specific metric's time series, in which a baseline is requested for.
  var path_568173 = newJObject()
  var query_568175 = newJObject()
  add(query_568175, "api-version", newJString(apiVersion))
  add(query_568175, "metricnames", newJString(metricnames))
  add(query_568175, "metricnamespace", newJString(metricnamespace))
  add(query_568175, "timespan", newJString(timespan))
  add(query_568175, "resultType", newJString(resultType))
  add(query_568175, "sensitivities", newJString(sensitivities))
  add(query_568175, "interval", newJString(interval))
  add(path_568173, "resourceUri", newJString(resourceUri))
  add(query_568175, "aggregation", newJString(aggregation))
  add(query_568175, "$filter", newJString(Filter))
  result = call_568172.call(path_568173, query_568175, nil, nil, nil)

var baselineGet* = Call_BaselineGet_567880(name: "baselineGet",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/{resourceUri}/providers/microsoft.insights/baseline",
                                        validator: validate_BaselineGet_567881,
                                        base: "", url: url_BaselineGet_567882,
                                        schemes: {Scheme.Https})
type
  Call_MetricBaselineGet_568214 = ref object of OpenApiRestCall_567658
proc url_MetricBaselineGet_568216(protocol: Scheme; host: string; base: string;
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

proc validate_MetricBaselineGet_568215(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## **Gets the baseline values for a specific metric**.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   metricName: JString (required)
  ##             : The name of the metric to retrieve the baseline for.
  ##   resourceUri: JString (required)
  ##              : The identifier of the resource. It has the following structure: 
  ## subscriptions/{subscriptionName}/resourceGroups/{resourceGroupName}/providers/{providerName}/{resourceName}. For example: 
  ## subscriptions/b368ca2f-e298-46b7-b0ab-012281956afa/resourceGroups/vms/providers/Microsoft.Compute/virtualMachines/vm1
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `metricName` field"
  var valid_568217 = path.getOrDefault("metricName")
  valid_568217 = validateParameter(valid_568217, JString, required = true,
                                 default = nil)
  if valid_568217 != nil:
    section.add "metricName", valid_568217
  var valid_568218 = path.getOrDefault("resourceUri")
  valid_568218 = validateParameter(valid_568218, JString, required = true,
                                 default = nil)
  if valid_568218 != nil:
    section.add "resourceUri", valid_568218
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   metricnamespace: JString
  ##                  : Metric namespace to query metric definitions for.
  ##   timespan: JString
  ##           : The timespan of the query. It is a string with the following format 'startDateTime_ISO/endDateTime_ISO'.
  ##   resultType: JString
  ##             : Allows retrieving only metadata of the baseline. On data request all information is retrieved.
  ##   sensitivities: JString
  ##                : The list of sensitivities (comma separated) to retrieve.
  ##   interval: JString
  ##           : The interval (i.e. timegrain) of the query.
  ##   aggregation: JString
  ##              : The aggregation type of the metric to retrieve the baseline for.
  ##   $filter: JString
  ##          : The **$filter** is used to describe a set of dimensions with their concrete values which produce a specific metric's time series, in which a baseline is requested for.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568219 = query.getOrDefault("api-version")
  valid_568219 = validateParameter(valid_568219, JString, required = true,
                                 default = nil)
  if valid_568219 != nil:
    section.add "api-version", valid_568219
  var valid_568220 = query.getOrDefault("metricnamespace")
  valid_568220 = validateParameter(valid_568220, JString, required = false,
                                 default = nil)
  if valid_568220 != nil:
    section.add "metricnamespace", valid_568220
  var valid_568221 = query.getOrDefault("timespan")
  valid_568221 = validateParameter(valid_568221, JString, required = false,
                                 default = nil)
  if valid_568221 != nil:
    section.add "timespan", valid_568221
  var valid_568222 = query.getOrDefault("resultType")
  valid_568222 = validateParameter(valid_568222, JString, required = false,
                                 default = newJString("Data"))
  if valid_568222 != nil:
    section.add "resultType", valid_568222
  var valid_568223 = query.getOrDefault("sensitivities")
  valid_568223 = validateParameter(valid_568223, JString, required = false,
                                 default = nil)
  if valid_568223 != nil:
    section.add "sensitivities", valid_568223
  var valid_568224 = query.getOrDefault("interval")
  valid_568224 = validateParameter(valid_568224, JString, required = false,
                                 default = nil)
  if valid_568224 != nil:
    section.add "interval", valid_568224
  var valid_568225 = query.getOrDefault("aggregation")
  valid_568225 = validateParameter(valid_568225, JString, required = false,
                                 default = nil)
  if valid_568225 != nil:
    section.add "aggregation", valid_568225
  var valid_568226 = query.getOrDefault("$filter")
  valid_568226 = validateParameter(valid_568226, JString, required = false,
                                 default = nil)
  if valid_568226 != nil:
    section.add "$filter", valid_568226
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568227: Call_MetricBaselineGet_568214; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## **Gets the baseline values for a specific metric**.
  ## 
  let valid = call_568227.validator(path, query, header, formData, body)
  let scheme = call_568227.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568227.url(scheme.get, call_568227.host, call_568227.base,
                         call_568227.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568227, url, valid)

proc call*(call_568228: Call_MetricBaselineGet_568214; apiVersion: string;
          metricName: string; resourceUri: string; metricnamespace: string = "";
          timespan: string = ""; resultType: string = "Data";
          sensitivities: string = ""; interval: string = ""; aggregation: string = "";
          Filter: string = ""): Recallable =
  ## metricBaselineGet
  ## **Gets the baseline values for a specific metric**.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   metricnamespace: string
  ##                  : Metric namespace to query metric definitions for.
  ##   timespan: string
  ##           : The timespan of the query. It is a string with the following format 'startDateTime_ISO/endDateTime_ISO'.
  ##   resultType: string
  ##             : Allows retrieving only metadata of the baseline. On data request all information is retrieved.
  ##   sensitivities: string
  ##                : The list of sensitivities (comma separated) to retrieve.
  ##   metricName: string (required)
  ##             : The name of the metric to retrieve the baseline for.
  ##   interval: string
  ##           : The interval (i.e. timegrain) of the query.
  ##   resourceUri: string (required)
  ##              : The identifier of the resource. It has the following structure: 
  ## subscriptions/{subscriptionName}/resourceGroups/{resourceGroupName}/providers/{providerName}/{resourceName}. For example: 
  ## subscriptions/b368ca2f-e298-46b7-b0ab-012281956afa/resourceGroups/vms/providers/Microsoft.Compute/virtualMachines/vm1
  ##   aggregation: string
  ##              : The aggregation type of the metric to retrieve the baseline for.
  ##   Filter: string
  ##         : The **$filter** is used to describe a set of dimensions with their concrete values which produce a specific metric's time series, in which a baseline is requested for.
  var path_568229 = newJObject()
  var query_568230 = newJObject()
  add(query_568230, "api-version", newJString(apiVersion))
  add(query_568230, "metricnamespace", newJString(metricnamespace))
  add(query_568230, "timespan", newJString(timespan))
  add(query_568230, "resultType", newJString(resultType))
  add(query_568230, "sensitivities", newJString(sensitivities))
  add(path_568229, "metricName", newJString(metricName))
  add(query_568230, "interval", newJString(interval))
  add(path_568229, "resourceUri", newJString(resourceUri))
  add(query_568230, "aggregation", newJString(aggregation))
  add(query_568230, "$filter", newJString(Filter))
  result = call_568228.call(path_568229, query_568230, nil, nil, nil)

var metricBaselineGet* = Call_MetricBaselineGet_568214(name: "metricBaselineGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/{resourceUri}/providers/microsoft.insights/baseline/{metricName}",
    validator: validate_MetricBaselineGet_568215, base: "",
    url: url_MetricBaselineGet_568216, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
