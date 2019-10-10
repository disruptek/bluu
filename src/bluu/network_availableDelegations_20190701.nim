
import
  json, options, hashes, uri, rest, os, uri, httpcore

## auto-generated via openapi macro
## title: NetworkManagementClient
## version: 2019-07-01
## termsOfService: (not provided)
## license: (not provided)
## 
## The Microsoft Azure Network management API provides a RESTful set of web services that interact with Microsoft Azure Networks service to manage your network resources. The API has entities that capture the relationship between an end user and the Microsoft Azure Networks service.
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

  OpenApiRestCall_573641 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_573641](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_573641): Option[Scheme] {.used.} =
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
  macServiceName = "network-availableDelegations"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_AvailableDelegationsList_573863 = ref object of OpenApiRestCall_573641
proc url_AvailableDelegationsList_573865(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "location" in path, "`location` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Network/locations/"),
               (kind: VariableSegment, value: "location"),
               (kind: ConstantSegment, value: "/availableDelegations")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AvailableDelegationsList_573864(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all of the available subnet delegations for this subscription in this region.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   location: JString (required)
  ##           : The location of the subnet.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_574025 = path.getOrDefault("subscriptionId")
  valid_574025 = validateParameter(valid_574025, JString, required = true,
                                 default = nil)
  if valid_574025 != nil:
    section.add "subscriptionId", valid_574025
  var valid_574026 = path.getOrDefault("location")
  valid_574026 = validateParameter(valid_574026, JString, required = true,
                                 default = nil)
  if valid_574026 != nil:
    section.add "location", valid_574026
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574027 = query.getOrDefault("api-version")
  valid_574027 = validateParameter(valid_574027, JString, required = true,
                                 default = nil)
  if valid_574027 != nil:
    section.add "api-version", valid_574027
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574054: Call_AvailableDelegationsList_573863; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all of the available subnet delegations for this subscription in this region.
  ## 
  let valid = call_574054.validator(path, query, header, formData, body)
  let scheme = call_574054.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574054.url(scheme.get, call_574054.host, call_574054.base,
                         call_574054.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574054, url, valid)

proc call*(call_574125: Call_AvailableDelegationsList_573863; apiVersion: string;
          subscriptionId: string; location: string): Recallable =
  ## availableDelegationsList
  ## Gets all of the available subnet delegations for this subscription in this region.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   location: string (required)
  ##           : The location of the subnet.
  var path_574126 = newJObject()
  var query_574128 = newJObject()
  add(query_574128, "api-version", newJString(apiVersion))
  add(path_574126, "subscriptionId", newJString(subscriptionId))
  add(path_574126, "location", newJString(location))
  result = call_574125.call(path_574126, query_574128, nil, nil, nil)

var availableDelegationsList* = Call_AvailableDelegationsList_573863(
    name: "availableDelegationsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Network/locations/{location}/availableDelegations",
    validator: validate_AvailableDelegationsList_573864, base: "",
    url: url_AvailableDelegationsList_573865, schemes: {Scheme.Https})
type
  Call_AvailableResourceGroupDelegationsList_574167 = ref object of OpenApiRestCall_573641
proc url_AvailableResourceGroupDelegationsList_574169(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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
        kind: ConstantSegment, value: "/providers/Microsoft.Network/locations/"),
               (kind: VariableSegment, value: "location"),
               (kind: ConstantSegment, value: "/availableDelegations")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AvailableResourceGroupDelegationsList_574168(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all of the available subnet delegations for this resource group in this region.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   location: JString (required)
  ##           : The location of the domain name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574170 = path.getOrDefault("resourceGroupName")
  valid_574170 = validateParameter(valid_574170, JString, required = true,
                                 default = nil)
  if valid_574170 != nil:
    section.add "resourceGroupName", valid_574170
  var valid_574171 = path.getOrDefault("subscriptionId")
  valid_574171 = validateParameter(valid_574171, JString, required = true,
                                 default = nil)
  if valid_574171 != nil:
    section.add "subscriptionId", valid_574171
  var valid_574172 = path.getOrDefault("location")
  valid_574172 = validateParameter(valid_574172, JString, required = true,
                                 default = nil)
  if valid_574172 != nil:
    section.add "location", valid_574172
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574173 = query.getOrDefault("api-version")
  valid_574173 = validateParameter(valid_574173, JString, required = true,
                                 default = nil)
  if valid_574173 != nil:
    section.add "api-version", valid_574173
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574174: Call_AvailableResourceGroupDelegationsList_574167;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets all of the available subnet delegations for this resource group in this region.
  ## 
  let valid = call_574174.validator(path, query, header, formData, body)
  let scheme = call_574174.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574174.url(scheme.get, call_574174.host, call_574174.base,
                         call_574174.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574174, url, valid)

proc call*(call_574175: Call_AvailableResourceGroupDelegationsList_574167;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          location: string): Recallable =
  ## availableResourceGroupDelegationsList
  ## Gets all of the available subnet delegations for this resource group in this region.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   location: string (required)
  ##           : The location of the domain name.
  var path_574176 = newJObject()
  var query_574177 = newJObject()
  add(path_574176, "resourceGroupName", newJString(resourceGroupName))
  add(query_574177, "api-version", newJString(apiVersion))
  add(path_574176, "subscriptionId", newJString(subscriptionId))
  add(path_574176, "location", newJString(location))
  result = call_574175.call(path_574176, query_574177, nil, nil, nil)

var availableResourceGroupDelegationsList* = Call_AvailableResourceGroupDelegationsList_574167(
    name: "availableResourceGroupDelegationsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/locations/{location}/availableDelegations",
    validator: validate_AvailableResourceGroupDelegationsList_574168, base: "",
    url: url_AvailableResourceGroupDelegationsList_574169, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
