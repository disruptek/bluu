
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
  macServiceName = "monitor-calculateBaseline_API"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_MetricBaselineCalculateBaseline_567880 = ref object of OpenApiRestCall_567658
proc url_MetricBaselineCalculateBaseline_567882(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "resourceUri" in path, "`resourceUri` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceUri"), (
        kind: ConstantSegment,
        value: "/providers/microsoft.insights/calculatebaseline")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MetricBaselineCalculateBaseline_567881(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## **Lists the baseline values for a resource**.
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
  var valid_568072 = path.getOrDefault("resourceUri")
  valid_568072 = validateParameter(valid_568072, JString, required = true,
                                 default = nil)
  if valid_568072 != nil:
    section.add "resourceUri", valid_568072
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568073 = query.getOrDefault("api-version")
  valid_568073 = validateParameter(valid_568073, JString, required = true,
                                 default = nil)
  if valid_568073 != nil:
    section.add "api-version", valid_568073
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   TimeSeriesInformation: JObject (required)
  ##                        : Information that need to be specified to calculate a baseline on a time series.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568097: Call_MetricBaselineCalculateBaseline_567880;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## **Lists the baseline values for a resource**.
  ## 
  let valid = call_568097.validator(path, query, header, formData, body)
  let scheme = call_568097.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568097.url(scheme.get, call_568097.host, call_568097.base,
                         call_568097.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568097, url, valid)

proc call*(call_568168: Call_MetricBaselineCalculateBaseline_567880;
          apiVersion: string; resourceUri: string; TimeSeriesInformation: JsonNode): Recallable =
  ## metricBaselineCalculateBaseline
  ## **Lists the baseline values for a resource**.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   resourceUri: string (required)
  ##              : The identifier of the resource. It has the following structure: 
  ## subscriptions/{subscriptionName}/resourceGroups/{resourceGroupName}/providers/{providerName}/{resourceName}. For example: 
  ## subscriptions/b368ca2f-e298-46b7-b0ab-012281956afa/resourceGroups/vms/providers/Microsoft.Compute/virtualMachines/vm1
  ##   TimeSeriesInformation: JObject (required)
  ##                        : Information that need to be specified to calculate a baseline on a time series.
  var path_568169 = newJObject()
  var query_568171 = newJObject()
  var body_568172 = newJObject()
  add(query_568171, "api-version", newJString(apiVersion))
  add(path_568169, "resourceUri", newJString(resourceUri))
  if TimeSeriesInformation != nil:
    body_568172 = TimeSeriesInformation
  result = call_568168.call(path_568169, query_568171, nil, nil, body_568172)

var metricBaselineCalculateBaseline* = Call_MetricBaselineCalculateBaseline_567880(
    name: "metricBaselineCalculateBaseline", meth: HttpMethod.HttpPost,
    host: "management.azure.com",
    route: "/{resourceUri}/providers/microsoft.insights/calculatebaseline",
    validator: validate_MetricBaselineCalculateBaseline_567881, base: "",
    url: url_MetricBaselineCalculateBaseline_567882, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
