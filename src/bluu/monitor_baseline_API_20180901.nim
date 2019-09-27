
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

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

  OpenApiRestCall_593425 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_593425](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_593425): Option[Scheme] {.used.} =
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
  macServiceName = "monitor-baseline_API"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_BaselineGet_593647 = ref object of OpenApiRestCall_593425
proc url_BaselineGet_593649(protocol: Scheme; host: string; base: string;
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

proc validate_BaselineGet_593648(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_593823 = path.getOrDefault("resourceUri")
  valid_593823 = validateParameter(valid_593823, JString, required = true,
                                 default = nil)
  if valid_593823 != nil:
    section.add "resourceUri", valid_593823
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
  var valid_593824 = query.getOrDefault("api-version")
  valid_593824 = validateParameter(valid_593824, JString, required = true,
                                 default = nil)
  if valid_593824 != nil:
    section.add "api-version", valid_593824
  var valid_593825 = query.getOrDefault("metricnames")
  valid_593825 = validateParameter(valid_593825, JString, required = false,
                                 default = nil)
  if valid_593825 != nil:
    section.add "metricnames", valid_593825
  var valid_593826 = query.getOrDefault("metricnamespace")
  valid_593826 = validateParameter(valid_593826, JString, required = false,
                                 default = nil)
  if valid_593826 != nil:
    section.add "metricnamespace", valid_593826
  var valid_593827 = query.getOrDefault("timespan")
  valid_593827 = validateParameter(valid_593827, JString, required = false,
                                 default = nil)
  if valid_593827 != nil:
    section.add "timespan", valid_593827
  var valid_593841 = query.getOrDefault("resultType")
  valid_593841 = validateParameter(valid_593841, JString, required = false,
                                 default = newJString("Data"))
  if valid_593841 != nil:
    section.add "resultType", valid_593841
  var valid_593842 = query.getOrDefault("sensitivities")
  valid_593842 = validateParameter(valid_593842, JString, required = false,
                                 default = nil)
  if valid_593842 != nil:
    section.add "sensitivities", valid_593842
  var valid_593843 = query.getOrDefault("interval")
  valid_593843 = validateParameter(valid_593843, JString, required = false,
                                 default = nil)
  if valid_593843 != nil:
    section.add "interval", valid_593843
  var valid_593844 = query.getOrDefault("aggregation")
  valid_593844 = validateParameter(valid_593844, JString, required = false,
                                 default = nil)
  if valid_593844 != nil:
    section.add "aggregation", valid_593844
  var valid_593845 = query.getOrDefault("$filter")
  valid_593845 = validateParameter(valid_593845, JString, required = false,
                                 default = nil)
  if valid_593845 != nil:
    section.add "$filter", valid_593845
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593868: Call_BaselineGet_593647; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## **Gets the baseline values for a resource**.
  ## 
  let valid = call_593868.validator(path, query, header, formData, body)
  let scheme = call_593868.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593868.url(scheme.get, call_593868.host, call_593868.base,
                         call_593868.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593868, url, valid)

proc call*(call_593939: Call_BaselineGet_593647; apiVersion: string;
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
  var path_593940 = newJObject()
  var query_593942 = newJObject()
  add(query_593942, "api-version", newJString(apiVersion))
  add(query_593942, "metricnames", newJString(metricnames))
  add(query_593942, "metricnamespace", newJString(metricnamespace))
  add(query_593942, "timespan", newJString(timespan))
  add(query_593942, "resultType", newJString(resultType))
  add(query_593942, "sensitivities", newJString(sensitivities))
  add(query_593942, "interval", newJString(interval))
  add(path_593940, "resourceUri", newJString(resourceUri))
  add(query_593942, "aggregation", newJString(aggregation))
  add(query_593942, "$filter", newJString(Filter))
  result = call_593939.call(path_593940, query_593942, nil, nil, nil)

var baselineGet* = Call_BaselineGet_593647(name: "baselineGet",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/{resourceUri}/providers/microsoft.insights/baseline",
                                        validator: validate_BaselineGet_593648,
                                        base: "", url: url_BaselineGet_593649,
                                        schemes: {Scheme.Https})
type
  Call_MetricBaselineGet_593981 = ref object of OpenApiRestCall_593425
proc url_MetricBaselineGet_593983(protocol: Scheme; host: string; base: string;
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

proc validate_MetricBaselineGet_593982(path: JsonNode; query: JsonNode;
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
  var valid_593984 = path.getOrDefault("metricName")
  valid_593984 = validateParameter(valid_593984, JString, required = true,
                                 default = nil)
  if valid_593984 != nil:
    section.add "metricName", valid_593984
  var valid_593985 = path.getOrDefault("resourceUri")
  valid_593985 = validateParameter(valid_593985, JString, required = true,
                                 default = nil)
  if valid_593985 != nil:
    section.add "resourceUri", valid_593985
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
  var valid_593986 = query.getOrDefault("api-version")
  valid_593986 = validateParameter(valid_593986, JString, required = true,
                                 default = nil)
  if valid_593986 != nil:
    section.add "api-version", valid_593986
  var valid_593987 = query.getOrDefault("metricnamespace")
  valid_593987 = validateParameter(valid_593987, JString, required = false,
                                 default = nil)
  if valid_593987 != nil:
    section.add "metricnamespace", valid_593987
  var valid_593988 = query.getOrDefault("timespan")
  valid_593988 = validateParameter(valid_593988, JString, required = false,
                                 default = nil)
  if valid_593988 != nil:
    section.add "timespan", valid_593988
  var valid_593989 = query.getOrDefault("resultType")
  valid_593989 = validateParameter(valid_593989, JString, required = false,
                                 default = newJString("Data"))
  if valid_593989 != nil:
    section.add "resultType", valid_593989
  var valid_593990 = query.getOrDefault("sensitivities")
  valid_593990 = validateParameter(valid_593990, JString, required = false,
                                 default = nil)
  if valid_593990 != nil:
    section.add "sensitivities", valid_593990
  var valid_593991 = query.getOrDefault("interval")
  valid_593991 = validateParameter(valid_593991, JString, required = false,
                                 default = nil)
  if valid_593991 != nil:
    section.add "interval", valid_593991
  var valid_593992 = query.getOrDefault("aggregation")
  valid_593992 = validateParameter(valid_593992, JString, required = false,
                                 default = nil)
  if valid_593992 != nil:
    section.add "aggregation", valid_593992
  var valid_593993 = query.getOrDefault("$filter")
  valid_593993 = validateParameter(valid_593993, JString, required = false,
                                 default = nil)
  if valid_593993 != nil:
    section.add "$filter", valid_593993
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593994: Call_MetricBaselineGet_593981; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## **Gets the baseline values for a specific metric**.
  ## 
  let valid = call_593994.validator(path, query, header, formData, body)
  let scheme = call_593994.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593994.url(scheme.get, call_593994.host, call_593994.base,
                         call_593994.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593994, url, valid)

proc call*(call_593995: Call_MetricBaselineGet_593981; apiVersion: string;
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
  var path_593996 = newJObject()
  var query_593997 = newJObject()
  add(query_593997, "api-version", newJString(apiVersion))
  add(query_593997, "metricnamespace", newJString(metricnamespace))
  add(query_593997, "timespan", newJString(timespan))
  add(query_593997, "resultType", newJString(resultType))
  add(query_593997, "sensitivities", newJString(sensitivities))
  add(path_593996, "metricName", newJString(metricName))
  add(query_593997, "interval", newJString(interval))
  add(path_593996, "resourceUri", newJString(resourceUri))
  add(query_593997, "aggregation", newJString(aggregation))
  add(query_593997, "$filter", newJString(Filter))
  result = call_593995.call(path_593996, query_593997, nil, nil, nil)

var metricBaselineGet* = Call_MetricBaselineGet_593981(name: "metricBaselineGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/{resourceUri}/providers/microsoft.insights/baseline/{metricName}",
    validator: validate_MetricBaselineGet_593982, base: "",
    url: url_MetricBaselineGet_593983, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
