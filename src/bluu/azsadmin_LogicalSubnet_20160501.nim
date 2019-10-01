
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: FabricAdminClient
## version: 2016-05-01
## termsOfService: (not provided)
## license: (not provided)
## 
## Logical subnet operation endpoints and objects.
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
  macServiceName = "azsadmin-LogicalSubnet"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_LogicalSubnetsList_574663 = ref object of OpenApiRestCall_574441
proc url_LogicalSubnetsList_574665(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "location" in path, "`location` is a required path parameter"
  assert "logicalNetwork" in path, "`logicalNetwork` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Fabric.Admin/fabricLocations/"),
               (kind: VariableSegment, value: "location"),
               (kind: ConstantSegment, value: "/logicalNetworks/"),
               (kind: VariableSegment, value: "logicalNetwork"),
               (kind: ConstantSegment, value: "/logicalSubnets")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LogicalSubnetsList_574664(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Returns a list of all logical subnets.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group.
  ##   logicalNetwork: JString (required)
  ##                 : Name of the logical network.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   location: JString (required)
  ##           : Location of the resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574839 = path.getOrDefault("resourceGroupName")
  valid_574839 = validateParameter(valid_574839, JString, required = true,
                                 default = nil)
  if valid_574839 != nil:
    section.add "resourceGroupName", valid_574839
  var valid_574840 = path.getOrDefault("logicalNetwork")
  valid_574840 = validateParameter(valid_574840, JString, required = true,
                                 default = nil)
  if valid_574840 != nil:
    section.add "logicalNetwork", valid_574840
  var valid_574841 = path.getOrDefault("subscriptionId")
  valid_574841 = validateParameter(valid_574841, JString, required = true,
                                 default = nil)
  if valid_574841 != nil:
    section.add "subscriptionId", valid_574841
  var valid_574842 = path.getOrDefault("location")
  valid_574842 = validateParameter(valid_574842, JString, required = true,
                                 default = nil)
  if valid_574842 != nil:
    section.add "location", valid_574842
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  ##   $filter: JString
  ##          : OData filter parameter.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574856 = query.getOrDefault("api-version")
  valid_574856 = validateParameter(valid_574856, JString, required = true,
                                 default = newJString("2016-05-01"))
  if valid_574856 != nil:
    section.add "api-version", valid_574856
  var valid_574857 = query.getOrDefault("$filter")
  valid_574857 = validateParameter(valid_574857, JString, required = false,
                                 default = nil)
  if valid_574857 != nil:
    section.add "$filter", valid_574857
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574880: Call_LogicalSubnetsList_574663; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a list of all logical subnets.
  ## 
  let valid = call_574880.validator(path, query, header, formData, body)
  let scheme = call_574880.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574880.url(scheme.get, call_574880.host, call_574880.base,
                         call_574880.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574880, url, valid)

proc call*(call_574951: Call_LogicalSubnetsList_574663; resourceGroupName: string;
          logicalNetwork: string; subscriptionId: string; location: string;
          apiVersion: string = "2016-05-01"; Filter: string = ""): Recallable =
  ## logicalSubnetsList
  ## Returns a list of all logical subnets.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   logicalNetwork: string (required)
  ##                 : Name of the logical network.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   location: string (required)
  ##           : Location of the resource.
  ##   Filter: string
  ##         : OData filter parameter.
  var path_574952 = newJObject()
  var query_574954 = newJObject()
  add(path_574952, "resourceGroupName", newJString(resourceGroupName))
  add(query_574954, "api-version", newJString(apiVersion))
  add(path_574952, "logicalNetwork", newJString(logicalNetwork))
  add(path_574952, "subscriptionId", newJString(subscriptionId))
  add(path_574952, "location", newJString(location))
  add(query_574954, "$filter", newJString(Filter))
  result = call_574951.call(path_574952, query_574954, nil, nil, nil)

var logicalSubnetsList* = Call_LogicalSubnetsList_574663(
    name: "logicalSubnetsList", meth: HttpMethod.HttpGet,
    host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Fabric.Admin/fabricLocations/{location}/logicalNetworks/{logicalNetwork}/logicalSubnets",
    validator: validate_LogicalSubnetsList_574664, base: "",
    url: url_LogicalSubnetsList_574665, schemes: {Scheme.Https})
type
  Call_LogicalSubnetsGet_574993 = ref object of OpenApiRestCall_574441
proc url_LogicalSubnetsGet_574995(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "location" in path, "`location` is a required path parameter"
  assert "logicalNetwork" in path, "`logicalNetwork` is a required path parameter"
  assert "logicalSubnet" in path, "`logicalSubnet` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Fabric.Admin/fabricLocations/"),
               (kind: VariableSegment, value: "location"),
               (kind: ConstantSegment, value: "/logicalNetworks/"),
               (kind: VariableSegment, value: "logicalNetwork"),
               (kind: ConstantSegment, value: "/logicalSubnets/"),
               (kind: VariableSegment, value: "logicalSubnet")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LogicalSubnetsGet_574994(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Returns the requested logical subnet.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group.
  ##   logicalSubnet: JString (required)
  ##                : Name of the logical subnet.
  ##   logicalNetwork: JString (required)
  ##                 : Name of the logical network.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   location: JString (required)
  ##           : Location of the resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574996 = path.getOrDefault("resourceGroupName")
  valid_574996 = validateParameter(valid_574996, JString, required = true,
                                 default = nil)
  if valid_574996 != nil:
    section.add "resourceGroupName", valid_574996
  var valid_574997 = path.getOrDefault("logicalSubnet")
  valid_574997 = validateParameter(valid_574997, JString, required = true,
                                 default = nil)
  if valid_574997 != nil:
    section.add "logicalSubnet", valid_574997
  var valid_574998 = path.getOrDefault("logicalNetwork")
  valid_574998 = validateParameter(valid_574998, JString, required = true,
                                 default = nil)
  if valid_574998 != nil:
    section.add "logicalNetwork", valid_574998
  var valid_574999 = path.getOrDefault("subscriptionId")
  valid_574999 = validateParameter(valid_574999, JString, required = true,
                                 default = nil)
  if valid_574999 != nil:
    section.add "subscriptionId", valid_574999
  var valid_575000 = path.getOrDefault("location")
  valid_575000 = validateParameter(valid_575000, JString, required = true,
                                 default = nil)
  if valid_575000 != nil:
    section.add "location", valid_575000
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575001 = query.getOrDefault("api-version")
  valid_575001 = validateParameter(valid_575001, JString, required = true,
                                 default = newJString("2016-05-01"))
  if valid_575001 != nil:
    section.add "api-version", valid_575001
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575002: Call_LogicalSubnetsGet_574993; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the requested logical subnet.
  ## 
  let valid = call_575002.validator(path, query, header, formData, body)
  let scheme = call_575002.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575002.url(scheme.get, call_575002.host, call_575002.base,
                         call_575002.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575002, url, valid)

proc call*(call_575003: Call_LogicalSubnetsGet_574993; resourceGroupName: string;
          logicalSubnet: string; logicalNetwork: string; subscriptionId: string;
          location: string; apiVersion: string = "2016-05-01"): Recallable =
  ## logicalSubnetsGet
  ## Returns the requested logical subnet.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   logicalSubnet: string (required)
  ##                : Name of the logical subnet.
  ##   logicalNetwork: string (required)
  ##                 : Name of the logical network.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   location: string (required)
  ##           : Location of the resource.
  var path_575004 = newJObject()
  var query_575005 = newJObject()
  add(path_575004, "resourceGroupName", newJString(resourceGroupName))
  add(query_575005, "api-version", newJString(apiVersion))
  add(path_575004, "logicalSubnet", newJString(logicalSubnet))
  add(path_575004, "logicalNetwork", newJString(logicalNetwork))
  add(path_575004, "subscriptionId", newJString(subscriptionId))
  add(path_575004, "location", newJString(location))
  result = call_575003.call(path_575004, query_575005, nil, nil, nil)

var logicalSubnetsGet* = Call_LogicalSubnetsGet_574993(name: "logicalSubnetsGet",
    meth: HttpMethod.HttpGet, host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Fabric.Admin/fabricLocations/{location}/logicalNetworks/{logicalNetwork}/logicalSubnets/{logicalSubnet}",
    validator: validate_LogicalSubnetsGet_574994, base: "",
    url: url_LogicalSubnetsGet_574995, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
