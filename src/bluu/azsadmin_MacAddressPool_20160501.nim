
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: FabricAdminClient
## version: 2016-05-01
## termsOfService: (not provided)
## license: (not provided)
## 
## MAC address pool operation endpoints and objects.
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

  OpenApiRestCall_574457 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_574457](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_574457): Option[Scheme] {.used.} =
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
  macServiceName = "azsadmin-MacAddressPool"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_MacAddressPoolsList_574679 = ref object of OpenApiRestCall_574457
proc url_MacAddressPoolsList_574681(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "location" in path, "`location` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Fabric.Admin/fabricLocations/"),
               (kind: VariableSegment, value: "location"),
               (kind: ConstantSegment, value: "/macAddressPools")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MacAddressPoolsList_574680(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Returns a list of all MAC address pools at a location.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   location: JString (required)
  ##           : Location of the resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574842 = path.getOrDefault("resourceGroupName")
  valid_574842 = validateParameter(valid_574842, JString, required = true,
                                 default = nil)
  if valid_574842 != nil:
    section.add "resourceGroupName", valid_574842
  var valid_574843 = path.getOrDefault("subscriptionId")
  valid_574843 = validateParameter(valid_574843, JString, required = true,
                                 default = nil)
  if valid_574843 != nil:
    section.add "subscriptionId", valid_574843
  var valid_574844 = path.getOrDefault("location")
  valid_574844 = validateParameter(valid_574844, JString, required = true,
                                 default = nil)
  if valid_574844 != nil:
    section.add "location", valid_574844
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  ##   $filter: JString
  ##          : OData filter parameter.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574858 = query.getOrDefault("api-version")
  valid_574858 = validateParameter(valid_574858, JString, required = true,
                                 default = newJString("2016-05-01"))
  if valid_574858 != nil:
    section.add "api-version", valid_574858
  var valid_574859 = query.getOrDefault("$filter")
  valid_574859 = validateParameter(valid_574859, JString, required = false,
                                 default = nil)
  if valid_574859 != nil:
    section.add "$filter", valid_574859
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574886: Call_MacAddressPoolsList_574679; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a list of all MAC address pools at a location.
  ## 
  let valid = call_574886.validator(path, query, header, formData, body)
  let scheme = call_574886.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574886.url(scheme.get, call_574886.host, call_574886.base,
                         call_574886.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574886, url, valid)

proc call*(call_574957: Call_MacAddressPoolsList_574679; resourceGroupName: string;
          subscriptionId: string; location: string;
          apiVersion: string = "2016-05-01"; Filter: string = ""): Recallable =
  ## macAddressPoolsList
  ## Returns a list of all MAC address pools at a location.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   location: string (required)
  ##           : Location of the resource.
  ##   Filter: string
  ##         : OData filter parameter.
  var path_574958 = newJObject()
  var query_574960 = newJObject()
  add(path_574958, "resourceGroupName", newJString(resourceGroupName))
  add(query_574960, "api-version", newJString(apiVersion))
  add(path_574958, "subscriptionId", newJString(subscriptionId))
  add(path_574958, "location", newJString(location))
  add(query_574960, "$filter", newJString(Filter))
  result = call_574957.call(path_574958, query_574960, nil, nil, nil)

var macAddressPoolsList* = Call_MacAddressPoolsList_574679(
    name: "macAddressPoolsList", meth: HttpMethod.HttpGet,
    host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Fabric.Admin/fabricLocations/{location}/macAddressPools",
    validator: validate_MacAddressPoolsList_574680, base: "",
    url: url_MacAddressPoolsList_574681, schemes: {Scheme.Https})
type
  Call_MacAddressPoolsGet_574999 = ref object of OpenApiRestCall_574457
proc url_MacAddressPoolsGet_575001(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "location" in path, "`location` is a required path parameter"
  assert "macAddressPool" in path, "`macAddressPool` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Fabric.Admin/fabricLocations/"),
               (kind: VariableSegment, value: "location"),
               (kind: ConstantSegment, value: "/macAddressPools/"),
               (kind: VariableSegment, value: "macAddressPool")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MacAddressPoolsGet_575000(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Returns the requested MAC address pool.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group.
  ##   macAddressPool: JString (required)
  ##                 : Name of the MAC address pool.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   location: JString (required)
  ##           : Location of the resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575011 = path.getOrDefault("resourceGroupName")
  valid_575011 = validateParameter(valid_575011, JString, required = true,
                                 default = nil)
  if valid_575011 != nil:
    section.add "resourceGroupName", valid_575011
  var valid_575012 = path.getOrDefault("macAddressPool")
  valid_575012 = validateParameter(valid_575012, JString, required = true,
                                 default = nil)
  if valid_575012 != nil:
    section.add "macAddressPool", valid_575012
  var valid_575013 = path.getOrDefault("subscriptionId")
  valid_575013 = validateParameter(valid_575013, JString, required = true,
                                 default = nil)
  if valid_575013 != nil:
    section.add "subscriptionId", valid_575013
  var valid_575014 = path.getOrDefault("location")
  valid_575014 = validateParameter(valid_575014, JString, required = true,
                                 default = nil)
  if valid_575014 != nil:
    section.add "location", valid_575014
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575015 = query.getOrDefault("api-version")
  valid_575015 = validateParameter(valid_575015, JString, required = true,
                                 default = newJString("2016-05-01"))
  if valid_575015 != nil:
    section.add "api-version", valid_575015
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575016: Call_MacAddressPoolsGet_574999; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the requested MAC address pool.
  ## 
  let valid = call_575016.validator(path, query, header, formData, body)
  let scheme = call_575016.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575016.url(scheme.get, call_575016.host, call_575016.base,
                         call_575016.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575016, url, valid)

proc call*(call_575017: Call_MacAddressPoolsGet_574999; resourceGroupName: string;
          macAddressPool: string; subscriptionId: string; location: string;
          apiVersion: string = "2016-05-01"): Recallable =
  ## macAddressPoolsGet
  ## Returns the requested MAC address pool.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   macAddressPool: string (required)
  ##                 : Name of the MAC address pool.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   location: string (required)
  ##           : Location of the resource.
  var path_575018 = newJObject()
  var query_575019 = newJObject()
  add(path_575018, "resourceGroupName", newJString(resourceGroupName))
  add(query_575019, "api-version", newJString(apiVersion))
  add(path_575018, "macAddressPool", newJString(macAddressPool))
  add(path_575018, "subscriptionId", newJString(subscriptionId))
  add(path_575018, "location", newJString(location))
  result = call_575017.call(path_575018, query_575019, nil, nil, nil)

var macAddressPoolsGet* = Call_MacAddressPoolsGet_574999(
    name: "macAddressPoolsGet", meth: HttpMethod.HttpGet,
    host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Fabric.Admin/fabricLocations/{location}/macAddressPools/{macAddressPool}",
    validator: validate_MacAddressPoolsGet_575000, base: "",
    url: url_MacAddressPoolsGet_575001, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
