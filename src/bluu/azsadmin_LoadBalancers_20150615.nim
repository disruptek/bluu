
import
  json, options, hashes, uri, rest, os, uri, httpcore

## auto-generated via openapi macro
## title: NetworkAdminManagementClient
## version: 2015-06-15
## termsOfService: (not provided)
## license: (not provided)
## 
## Load balancer admin operation endpoints and objects.
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

  OpenApiRestCall_563539 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_563539](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_563539): Option[Scheme] {.used.} =
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
  macServiceName = "azsadmin-LoadBalancers"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_LoadBalancersList_563761 = ref object of OpenApiRestCall_563539
proc url_LoadBalancersList_563763(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network.Admin/adminLoadBalancers")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LoadBalancersList_563762(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Get a list of all load balancers.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_563926 = path.getOrDefault("subscriptionId")
  valid_563926 = validateParameter(valid_563926, JString, required = true,
                                 default = nil)
  if valid_563926 != nil:
    section.add "subscriptionId", valid_563926
  result.add "path", section
  ## parameters in `query` object:
  ##   $inlineCount: JString
  ##               : OData inline count parameter.
  ##   api-version: JString (required)
  ##              : Client API Version.
  ##   $top: JString
  ##       : OData top parameter.
  ##   $skip: JString
  ##        : OData skip parameter.
  ##   $filter: JString
  ##          : OData filter parameter.
  ##   $orderBy: JString
  ##           : OData orderBy parameter.
  section = newJObject()
  var valid_563927 = query.getOrDefault("$inlineCount")
  valid_563927 = validateParameter(valid_563927, JString, required = false,
                                 default = nil)
  if valid_563927 != nil:
    section.add "$inlineCount", valid_563927
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_563941 = query.getOrDefault("api-version")
  valid_563941 = validateParameter(valid_563941, JString, required = true,
                                 default = newJString("2015-06-15"))
  if valid_563941 != nil:
    section.add "api-version", valid_563941
  var valid_563942 = query.getOrDefault("$top")
  valid_563942 = validateParameter(valid_563942, JString, required = false,
                                 default = nil)
  if valid_563942 != nil:
    section.add "$top", valid_563942
  var valid_563943 = query.getOrDefault("$skip")
  valid_563943 = validateParameter(valid_563943, JString, required = false,
                                 default = nil)
  if valid_563943 != nil:
    section.add "$skip", valid_563943
  var valid_563944 = query.getOrDefault("$filter")
  valid_563944 = validateParameter(valid_563944, JString, required = false,
                                 default = nil)
  if valid_563944 != nil:
    section.add "$filter", valid_563944
  var valid_563945 = query.getOrDefault("$orderBy")
  valid_563945 = validateParameter(valid_563945, JString, required = false,
                                 default = nil)
  if valid_563945 != nil:
    section.add "$orderBy", valid_563945
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_563972: Call_LoadBalancersList_563761; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a list of all load balancers.
  ## 
  let valid = call_563972.validator(path, query, header, formData, body)
  let scheme = call_563972.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_563972.url(scheme.get, call_563972.host, call_563972.base,
                         call_563972.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_563972, url, valid)

proc call*(call_564043: Call_LoadBalancersList_563761; subscriptionId: string;
          InlineCount: string = ""; apiVersion: string = "2015-06-15"; Top: string = "";
          Skip: string = ""; Filter: string = ""; OrderBy: string = ""): Recallable =
  ## loadBalancersList
  ## Get a list of all load balancers.
  ##   InlineCount: string
  ##              : OData inline count parameter.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   Top: string
  ##      : OData top parameter.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   Skip: string
  ##       : OData skip parameter.
  ##   Filter: string
  ##         : OData filter parameter.
  ##   OrderBy: string
  ##          : OData orderBy parameter.
  var path_564044 = newJObject()
  var query_564046 = newJObject()
  add(query_564046, "$inlineCount", newJString(InlineCount))
  add(query_564046, "api-version", newJString(apiVersion))
  add(query_564046, "$top", newJString(Top))
  add(path_564044, "subscriptionId", newJString(subscriptionId))
  add(query_564046, "$skip", newJString(Skip))
  add(query_564046, "$filter", newJString(Filter))
  add(query_564046, "$orderBy", newJString(OrderBy))
  result = call_564043.call(path_564044, query_564046, nil, nil, nil)

var loadBalancersList* = Call_LoadBalancersList_563761(name: "loadBalancersList",
    meth: HttpMethod.HttpGet, host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Network.Admin/adminLoadBalancers",
    validator: validate_LoadBalancersList_563762, base: "",
    url: url_LoadBalancersList_563763, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
