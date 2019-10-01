
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

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
  macServiceName = "monitor-metricsCreate_API"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_MetricsCreate_567879 = ref object of OpenApiRestCall_567657
proc url_MetricsCreate_567881(protocol: Scheme; host: string; base: string;
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

proc validate_MetricsCreate_567880(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## **Post the metric values for a resource**.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The ARM resource group name
  ##   subscriptionId: JString (required)
  ##                 : The azure subscription id
  ##   resourceName: JString (required)
  ##               : The ARM resource name
  ##   resourceTypeName: JString (required)
  ##                   : The ARM resource type name
  ##   resourceProvider: JString (required)
  ##                   : The ARM resource provider name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568054 = path.getOrDefault("resourceGroupName")
  valid_568054 = validateParameter(valid_568054, JString, required = true,
                                 default = nil)
  if valid_568054 != nil:
    section.add "resourceGroupName", valid_568054
  var valid_568055 = path.getOrDefault("subscriptionId")
  valid_568055 = validateParameter(valid_568055, JString, required = true,
                                 default = nil)
  if valid_568055 != nil:
    section.add "subscriptionId", valid_568055
  var valid_568056 = path.getOrDefault("resourceName")
  valid_568056 = validateParameter(valid_568056, JString, required = true,
                                 default = nil)
  if valid_568056 != nil:
    section.add "resourceName", valid_568056
  var valid_568057 = path.getOrDefault("resourceTypeName")
  valid_568057 = validateParameter(valid_568057, JString, required = true,
                                 default = nil)
  if valid_568057 != nil:
    section.add "resourceTypeName", valid_568057
  var valid_568058 = path.getOrDefault("resourceProvider")
  valid_568058 = validateParameter(valid_568058, JString, required = true,
                                 default = nil)
  if valid_568058 != nil:
    section.add "resourceProvider", valid_568058
  result.add "path", section
  section = newJObject()
  result.add "query", section
  ## parameters in `header` object:
  ##   Authorization: JString (required)
  ##                : Authorization token issue for issued for audience "https:\\monitoring.azure.com\"
  ##   Content-Type: JString (required)
  ##               : Supports application/json and application/x-ndjson
  ##   Content-Length: JInt (required)
  ##                 : Content length of the payload
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `Authorization` field"
  var valid_568059 = header.getOrDefault("Authorization")
  valid_568059 = validateParameter(valid_568059, JString, required = true,
                                 default = nil)
  if valid_568059 != nil:
    section.add "Authorization", valid_568059
  var valid_568060 = header.getOrDefault("Content-Type")
  valid_568060 = validateParameter(valid_568060, JString, required = true,
                                 default = nil)
  if valid_568060 != nil:
    section.add "Content-Type", valid_568060
  var valid_568061 = header.getOrDefault("Content-Length")
  valid_568061 = validateParameter(valid_568061, JInt, required = true, default = nil)
  if valid_568061 != nil:
    section.add "Content-Length", valid_568061
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

proc call*(call_568085: Call_MetricsCreate_567879; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## **Post the metric values for a resource**.
  ## 
  let valid = call_568085.validator(path, query, header, formData, body)
  let scheme = call_568085.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568085.url(scheme.get, call_568085.host, call_568085.base,
                         call_568085.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568085, url, valid)

proc call*(call_568156: Call_MetricsCreate_567879; resourceGroupName: string;
          subscriptionId: string; resourceName: string; resourceTypeName: string;
          resourceProvider: string; body: JsonNode): Recallable =
  ## metricsCreate
  ## **Post the metric values for a resource**.
  ##   resourceGroupName: string (required)
  ##                    : The ARM resource group name
  ##   subscriptionId: string (required)
  ##                 : The azure subscription id
  ##   resourceName: string (required)
  ##               : The ARM resource name
  ##   resourceTypeName: string (required)
  ##                   : The ARM resource type name
  ##   resourceProvider: string (required)
  ##                   : The ARM resource provider name
  ##   body: JObject (required)
  ##       : The Azure metrics document json payload
  var path_568157 = newJObject()
  var body_568159 = newJObject()
  add(path_568157, "resourceGroupName", newJString(resourceGroupName))
  add(path_568157, "subscriptionId", newJString(subscriptionId))
  add(path_568157, "resourceName", newJString(resourceName))
  add(path_568157, "resourceTypeName", newJString(resourceTypeName))
  add(path_568157, "resourceProvider", newJString(resourceProvider))
  if body != nil:
    body_568159 = body
  result = call_568156.call(path_568157, nil, nil, nil, body_568159)

var metricsCreate* = Call_MetricsCreate_567879(name: "metricsCreate",
    meth: HttpMethod.HttpPost, host: "monitoring.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/{resourceProvider}/{resourceTypeName}/{resourceName}/metrics",
    validator: validate_MetricsCreate_567880, base: "", url: url_MetricsCreate_567881,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
