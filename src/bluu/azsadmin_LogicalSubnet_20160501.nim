
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

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

  OpenApiRestCall_593408 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_593408](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_593408): Option[Scheme] {.used.} =
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
  macServiceName = "azsadmin-LogicalSubnet"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_LogicalSubnetsList_593630 = ref object of OpenApiRestCall_593408
proc url_LogicalSubnetsList_593632(protocol: Scheme; host: string; base: string;
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

proc validate_LogicalSubnetsList_593631(path: JsonNode; query: JsonNode;
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
  var valid_593806 = path.getOrDefault("resourceGroupName")
  valid_593806 = validateParameter(valid_593806, JString, required = true,
                                 default = nil)
  if valid_593806 != nil:
    section.add "resourceGroupName", valid_593806
  var valid_593807 = path.getOrDefault("logicalNetwork")
  valid_593807 = validateParameter(valid_593807, JString, required = true,
                                 default = nil)
  if valid_593807 != nil:
    section.add "logicalNetwork", valid_593807
  var valid_593808 = path.getOrDefault("subscriptionId")
  valid_593808 = validateParameter(valid_593808, JString, required = true,
                                 default = nil)
  if valid_593808 != nil:
    section.add "subscriptionId", valid_593808
  var valid_593809 = path.getOrDefault("location")
  valid_593809 = validateParameter(valid_593809, JString, required = true,
                                 default = nil)
  if valid_593809 != nil:
    section.add "location", valid_593809
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  ##   $filter: JString
  ##          : OData filter parameter.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593823 = query.getOrDefault("api-version")
  valid_593823 = validateParameter(valid_593823, JString, required = true,
                                 default = newJString("2016-05-01"))
  if valid_593823 != nil:
    section.add "api-version", valid_593823
  var valid_593824 = query.getOrDefault("$filter")
  valid_593824 = validateParameter(valid_593824, JString, required = false,
                                 default = nil)
  if valid_593824 != nil:
    section.add "$filter", valid_593824
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593847: Call_LogicalSubnetsList_593630; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a list of all logical subnets.
  ## 
  let valid = call_593847.validator(path, query, header, formData, body)
  let scheme = call_593847.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593847.url(scheme.get, call_593847.host, call_593847.base,
                         call_593847.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593847, url, valid)

proc call*(call_593918: Call_LogicalSubnetsList_593630; resourceGroupName: string;
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
  var path_593919 = newJObject()
  var query_593921 = newJObject()
  add(path_593919, "resourceGroupName", newJString(resourceGroupName))
  add(query_593921, "api-version", newJString(apiVersion))
  add(path_593919, "logicalNetwork", newJString(logicalNetwork))
  add(path_593919, "subscriptionId", newJString(subscriptionId))
  add(path_593919, "location", newJString(location))
  add(query_593921, "$filter", newJString(Filter))
  result = call_593918.call(path_593919, query_593921, nil, nil, nil)

var logicalSubnetsList* = Call_LogicalSubnetsList_593630(
    name: "logicalSubnetsList", meth: HttpMethod.HttpGet,
    host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Fabric.Admin/fabricLocations/{location}/logicalNetworks/{logicalNetwork}/logicalSubnets",
    validator: validate_LogicalSubnetsList_593631, base: "",
    url: url_LogicalSubnetsList_593632, schemes: {Scheme.Https})
type
  Call_LogicalSubnetsGet_593960 = ref object of OpenApiRestCall_593408
proc url_LogicalSubnetsGet_593962(protocol: Scheme; host: string; base: string;
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

proc validate_LogicalSubnetsGet_593961(path: JsonNode; query: JsonNode;
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
  var valid_593963 = path.getOrDefault("resourceGroupName")
  valid_593963 = validateParameter(valid_593963, JString, required = true,
                                 default = nil)
  if valid_593963 != nil:
    section.add "resourceGroupName", valid_593963
  var valid_593964 = path.getOrDefault("logicalSubnet")
  valid_593964 = validateParameter(valid_593964, JString, required = true,
                                 default = nil)
  if valid_593964 != nil:
    section.add "logicalSubnet", valid_593964
  var valid_593965 = path.getOrDefault("logicalNetwork")
  valid_593965 = validateParameter(valid_593965, JString, required = true,
                                 default = nil)
  if valid_593965 != nil:
    section.add "logicalNetwork", valid_593965
  var valid_593966 = path.getOrDefault("subscriptionId")
  valid_593966 = validateParameter(valid_593966, JString, required = true,
                                 default = nil)
  if valid_593966 != nil:
    section.add "subscriptionId", valid_593966
  var valid_593967 = path.getOrDefault("location")
  valid_593967 = validateParameter(valid_593967, JString, required = true,
                                 default = nil)
  if valid_593967 != nil:
    section.add "location", valid_593967
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593968 = query.getOrDefault("api-version")
  valid_593968 = validateParameter(valid_593968, JString, required = true,
                                 default = newJString("2016-05-01"))
  if valid_593968 != nil:
    section.add "api-version", valid_593968
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593969: Call_LogicalSubnetsGet_593960; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the requested logical subnet.
  ## 
  let valid = call_593969.validator(path, query, header, formData, body)
  let scheme = call_593969.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593969.url(scheme.get, call_593969.host, call_593969.base,
                         call_593969.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593969, url, valid)

proc call*(call_593970: Call_LogicalSubnetsGet_593960; resourceGroupName: string;
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
  var path_593971 = newJObject()
  var query_593972 = newJObject()
  add(path_593971, "resourceGroupName", newJString(resourceGroupName))
  add(query_593972, "api-version", newJString(apiVersion))
  add(path_593971, "logicalSubnet", newJString(logicalSubnet))
  add(path_593971, "logicalNetwork", newJString(logicalNetwork))
  add(path_593971, "subscriptionId", newJString(subscriptionId))
  add(path_593971, "location", newJString(location))
  result = call_593970.call(path_593971, query_593972, nil, nil, nil)

var logicalSubnetsGet* = Call_LogicalSubnetsGet_593960(name: "logicalSubnetsGet",
    meth: HttpMethod.HttpGet, host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Fabric.Admin/fabricLocations/{location}/logicalNetworks/{logicalNetwork}/logicalSubnets/{logicalSubnet}",
    validator: validate_LogicalSubnetsGet_593961, base: "",
    url: url_LogicalSubnetsGet_593962, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
