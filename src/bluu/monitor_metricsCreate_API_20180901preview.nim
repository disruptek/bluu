
import
  json, options, hashes, uri, rest, os, uri, httpcore

## auto-generated via openapi macro
## title: Azure Metrics
## version: 2018-09-01-preview
## termsOfService: (not provided)
## license: (not provided)
## 
## A client for issuing REST requests to the Azure metrics service.
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
  macServiceName = "monitor-metricsCreate_API"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_MetricsCreate_563777 = ref object of OpenApiRestCall_563555
proc url_MetricsCreate_563779(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceProvider" in path,
        "`resourceProvider` is a required path parameter"
  assert "resourceTypeName" in path,
        "`resourceTypeName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"),
               (kind: ConstantSegment, value: "/providers/"),
               (kind: VariableSegment, value: "resourceProvider"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceTypeName"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/metrics")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MetricsCreate_563778(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## **Post the metric values for a resource**.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceTypeName: JString (required)
  ##                   : The ARM resource type name
  ##   subscriptionId: JString (required)
  ##                 : The azure subscription id
  ##   resourceGroupName: JString (required)
  ##                    : The ARM resource group name
  ##   resourceProvider: JString (required)
  ##                   : The ARM resource provider name
  ##   resourceName: JString (required)
  ##               : The ARM resource name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceTypeName` field"
  var valid_563954 = path.getOrDefault("resourceTypeName")
  valid_563954 = validateParameter(valid_563954, JString, required = true,
                                 default = nil)
  if valid_563954 != nil:
    section.add "resourceTypeName", valid_563954
  var valid_563955 = path.getOrDefault("subscriptionId")
  valid_563955 = validateParameter(valid_563955, JString, required = true,
                                 default = nil)
  if valid_563955 != nil:
    section.add "subscriptionId", valid_563955
  var valid_563956 = path.getOrDefault("resourceGroupName")
  valid_563956 = validateParameter(valid_563956, JString, required = true,
                                 default = nil)
  if valid_563956 != nil:
    section.add "resourceGroupName", valid_563956
  var valid_563957 = path.getOrDefault("resourceProvider")
  valid_563957 = validateParameter(valid_563957, JString, required = true,
                                 default = nil)
  if valid_563957 != nil:
    section.add "resourceProvider", valid_563957
  var valid_563958 = path.getOrDefault("resourceName")
  valid_563958 = validateParameter(valid_563958, JString, required = true,
                                 default = nil)
  if valid_563958 != nil:
    section.add "resourceName", valid_563958
  result.add "path", section
  section = newJObject()
  result.add "query", section
  ## parameters in `header` object:
  ##   Content-Length: JInt (required)
  ##                 : Content length of the payload
  ##   Authorization: JString (required)
  ##                : Authorization token issue for issued for audience "https:\\monitoring.azure.com\"
  ##   Content-Type: JString (required)
  ##               : Supports application/json and application/x-ndjson
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `Content-Length` field"
  var valid_563959 = header.getOrDefault("Content-Length")
  valid_563959 = validateParameter(valid_563959, JInt, required = true, default = nil)
  if valid_563959 != nil:
    section.add "Content-Length", valid_563959
  var valid_563960 = header.getOrDefault("Authorization")
  valid_563960 = validateParameter(valid_563960, JString, required = true,
                                 default = nil)
  if valid_563960 != nil:
    section.add "Authorization", valid_563960
  var valid_563961 = header.getOrDefault("Content-Type")
  valid_563961 = validateParameter(valid_563961, JString, required = true,
                                 default = nil)
  if valid_563961 != nil:
    section.add "Content-Type", valid_563961
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject (required)
  ##       : The Azure metrics document json payload
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_563985: Call_MetricsCreate_563777; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## **Post the metric values for a resource**.
  ## 
  let valid = call_563985.validator(path, query, header, formData, body)
  let scheme = call_563985.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_563985.url(scheme.get, call_563985.host, call_563985.base,
                         call_563985.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_563985, url, valid)

proc call*(call_564056: Call_MetricsCreate_563777; resourceTypeName: string;
          subscriptionId: string; resourceGroupName: string;
          resourceProvider: string; body: JsonNode; resourceName: string): Recallable =
  ## metricsCreate
  ## **Post the metric values for a resource**.
  ##   resourceTypeName: string (required)
  ##                   : The ARM resource type name
  ##   subscriptionId: string (required)
  ##                 : The azure subscription id
  ##   resourceGroupName: string (required)
  ##                    : The ARM resource group name
  ##   resourceProvider: string (required)
  ##                   : The ARM resource provider name
  ##   body: JObject (required)
  ##       : The Azure metrics document json payload
  ##   resourceName: string (required)
  ##               : The ARM resource name
  var path_564057 = newJObject()
  var body_564059 = newJObject()
  add(path_564057, "resourceTypeName", newJString(resourceTypeName))
  add(path_564057, "subscriptionId", newJString(subscriptionId))
  add(path_564057, "resourceGroupName", newJString(resourceGroupName))
  add(path_564057, "resourceProvider", newJString(resourceProvider))
  if body != nil:
    body_564059 = body
  add(path_564057, "resourceName", newJString(resourceName))
  result = call_564056.call(path_564057, nil, nil, nil, body_564059)

var metricsCreate* = Call_MetricsCreate_563777(name: "metricsCreate",
    meth: HttpMethod.HttpPost, host: "monitoring.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/{resourceProvider}/{resourceTypeName}/{resourceName}/metrics",
    validator: validate_MetricsCreate_563778, base: "", url: url_MetricsCreate_563779,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
