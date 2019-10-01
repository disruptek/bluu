
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: NetworkAdminManagementClient
## version: 2015-06-15
## termsOfService: (not provided)
## license: (not provided)
## 
## Virtual Network admin operation endpoints and objects.
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

  OpenApiRestCall_574441 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_574441](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_574441): Option[Scheme] {.used.} =
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
  macServiceName = "azsadmin-VirtualNetworks"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_VirtualNetworksList_574663 = ref object of OpenApiRestCall_574441
proc url_VirtualNetworksList_574665(protocol: Scheme; host: string; base: string;
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
        value: "/providers/Microsoft.Network.Admin/adminVirtualNetworks")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualNetworksList_574664(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Get a list of all virtual networks.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_574826 = path.getOrDefault("subscriptionId")
  valid_574826 = validateParameter(valid_574826, JString, required = true,
                                 default = nil)
  if valid_574826 != nil:
    section.add "subscriptionId", valid_574826
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  ##   $inlineCount: JString
  ##               : OData inline count parameter.
  ##   $top: JString
  ##       : OData top parameter.
  ##   $orderBy: JString
  ##           : OData orderBy parameter.
  ##   $skip: JString
  ##        : OData skip parameter.
  ##   $filter: JString
  ##          : OData filter parameter.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574840 = query.getOrDefault("api-version")
  valid_574840 = validateParameter(valid_574840, JString, required = true,
                                 default = newJString("2015-06-15"))
  if valid_574840 != nil:
    section.add "api-version", valid_574840
  var valid_574841 = query.getOrDefault("$inlineCount")
  valid_574841 = validateParameter(valid_574841, JString, required = false,
                                 default = nil)
  if valid_574841 != nil:
    section.add "$inlineCount", valid_574841
  var valid_574842 = query.getOrDefault("$top")
  valid_574842 = validateParameter(valid_574842, JString, required = false,
                                 default = nil)
  if valid_574842 != nil:
    section.add "$top", valid_574842
  var valid_574843 = query.getOrDefault("$orderBy")
  valid_574843 = validateParameter(valid_574843, JString, required = false,
                                 default = nil)
  if valid_574843 != nil:
    section.add "$orderBy", valid_574843
  var valid_574844 = query.getOrDefault("$skip")
  valid_574844 = validateParameter(valid_574844, JString, required = false,
                                 default = nil)
  if valid_574844 != nil:
    section.add "$skip", valid_574844
  var valid_574845 = query.getOrDefault("$filter")
  valid_574845 = validateParameter(valid_574845, JString, required = false,
                                 default = nil)
  if valid_574845 != nil:
    section.add "$filter", valid_574845
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574872: Call_VirtualNetworksList_574663; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a list of all virtual networks.
  ## 
  let valid = call_574872.validator(path, query, header, formData, body)
  let scheme = call_574872.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574872.url(scheme.get, call_574872.host, call_574872.base,
                         call_574872.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574872, url, valid)

proc call*(call_574943: Call_VirtualNetworksList_574663; subscriptionId: string;
          apiVersion: string = "2015-06-15"; InlineCount: string = ""; Top: string = "";
          OrderBy: string = ""; Skip: string = ""; Filter: string = ""): Recallable =
  ## virtualNetworksList
  ## Get a list of all virtual networks.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   InlineCount: string
  ##              : OData inline count parameter.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   Top: string
  ##      : OData top parameter.
  ##   OrderBy: string
  ##          : OData orderBy parameter.
  ##   Skip: string
  ##       : OData skip parameter.
  ##   Filter: string
  ##         : OData filter parameter.
  var path_574944 = newJObject()
  var query_574946 = newJObject()
  add(query_574946, "api-version", newJString(apiVersion))
  add(query_574946, "$inlineCount", newJString(InlineCount))
  add(path_574944, "subscriptionId", newJString(subscriptionId))
  add(query_574946, "$top", newJString(Top))
  add(query_574946, "$orderBy", newJString(OrderBy))
  add(query_574946, "$skip", newJString(Skip))
  add(query_574946, "$filter", newJString(Filter))
  result = call_574943.call(path_574944, query_574946, nil, nil, nil)

var virtualNetworksList* = Call_VirtualNetworksList_574663(
    name: "virtualNetworksList", meth: HttpMethod.HttpGet,
    host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Network.Admin/adminVirtualNetworks",
    validator: validate_VirtualNetworksList_574664, base: "",
    url: url_VirtualNetworksList_574665, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
