
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
  macServiceName = "network-privateEndpoint"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_AvailablePrivateEndpointTypesList_573863 = ref object of OpenApiRestCall_573641
proc url_AvailablePrivateEndpointTypesList_573865(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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
               (kind: ConstantSegment, value: "/availablePrivateEndpointTypes")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AvailablePrivateEndpointTypesList_573864(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns all of the resource types that can be linked to a Private Endpoint in this subscription in this region.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   location: JString (required)
  ##           : The location of the domain name.
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

proc call*(call_574054: Call_AvailablePrivateEndpointTypesList_573863;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns all of the resource types that can be linked to a Private Endpoint in this subscription in this region.
  ## 
  let valid = call_574054.validator(path, query, header, formData, body)
  let scheme = call_574054.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574054.url(scheme.get, call_574054.host, call_574054.base,
                         call_574054.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574054, url, valid)

proc call*(call_574125: Call_AvailablePrivateEndpointTypesList_573863;
          apiVersion: string; subscriptionId: string; location: string): Recallable =
  ## availablePrivateEndpointTypesList
  ## Returns all of the resource types that can be linked to a Private Endpoint in this subscription in this region.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   location: string (required)
  ##           : The location of the domain name.
  var path_574126 = newJObject()
  var query_574128 = newJObject()
  add(query_574128, "api-version", newJString(apiVersion))
  add(path_574126, "subscriptionId", newJString(subscriptionId))
  add(path_574126, "location", newJString(location))
  result = call_574125.call(path_574126, query_574128, nil, nil, nil)

var availablePrivateEndpointTypesList* = Call_AvailablePrivateEndpointTypesList_573863(
    name: "availablePrivateEndpointTypesList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Network/locations/{location}/availablePrivateEndpointTypes",
    validator: validate_AvailablePrivateEndpointTypesList_573864, base: "",
    url: url_AvailablePrivateEndpointTypesList_573865, schemes: {Scheme.Https})
type
  Call_PrivateEndpointsListBySubscription_574167 = ref object of OpenApiRestCall_573641
proc url_PrivateEndpointsListBySubscription_574169(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/privateEndpoints")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PrivateEndpointsListBySubscription_574168(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all private endpoints in a subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_574170 = path.getOrDefault("subscriptionId")
  valid_574170 = validateParameter(valid_574170, JString, required = true,
                                 default = nil)
  if valid_574170 != nil:
    section.add "subscriptionId", valid_574170
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574171 = query.getOrDefault("api-version")
  valid_574171 = validateParameter(valid_574171, JString, required = true,
                                 default = nil)
  if valid_574171 != nil:
    section.add "api-version", valid_574171
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574172: Call_PrivateEndpointsListBySubscription_574167;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets all private endpoints in a subscription.
  ## 
  let valid = call_574172.validator(path, query, header, formData, body)
  let scheme = call_574172.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574172.url(scheme.get, call_574172.host, call_574172.base,
                         call_574172.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574172, url, valid)

proc call*(call_574173: Call_PrivateEndpointsListBySubscription_574167;
          apiVersion: string; subscriptionId: string): Recallable =
  ## privateEndpointsListBySubscription
  ## Gets all private endpoints in a subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_574174 = newJObject()
  var query_574175 = newJObject()
  add(query_574175, "api-version", newJString(apiVersion))
  add(path_574174, "subscriptionId", newJString(subscriptionId))
  result = call_574173.call(path_574174, query_574175, nil, nil, nil)

var privateEndpointsListBySubscription* = Call_PrivateEndpointsListBySubscription_574167(
    name: "privateEndpointsListBySubscription", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Network/privateEndpoints",
    validator: validate_PrivateEndpointsListBySubscription_574168, base: "",
    url: url_PrivateEndpointsListBySubscription_574169, schemes: {Scheme.Https})
type
  Call_AvailablePrivateEndpointTypesListByResourceGroup_574176 = ref object of OpenApiRestCall_573641
proc url_AvailablePrivateEndpointTypesListByResourceGroup_574178(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
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
               (kind: ConstantSegment, value: "/availablePrivateEndpointTypes")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AvailablePrivateEndpointTypesListByResourceGroup_574177(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Returns all of the resource types that can be linked to a Private Endpoint in this subscription in this region.
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
  var valid_574179 = path.getOrDefault("resourceGroupName")
  valid_574179 = validateParameter(valid_574179, JString, required = true,
                                 default = nil)
  if valid_574179 != nil:
    section.add "resourceGroupName", valid_574179
  var valid_574180 = path.getOrDefault("subscriptionId")
  valid_574180 = validateParameter(valid_574180, JString, required = true,
                                 default = nil)
  if valid_574180 != nil:
    section.add "subscriptionId", valid_574180
  var valid_574181 = path.getOrDefault("location")
  valid_574181 = validateParameter(valid_574181, JString, required = true,
                                 default = nil)
  if valid_574181 != nil:
    section.add "location", valid_574181
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574182 = query.getOrDefault("api-version")
  valid_574182 = validateParameter(valid_574182, JString, required = true,
                                 default = nil)
  if valid_574182 != nil:
    section.add "api-version", valid_574182
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574183: Call_AvailablePrivateEndpointTypesListByResourceGroup_574176;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns all of the resource types that can be linked to a Private Endpoint in this subscription in this region.
  ## 
  let valid = call_574183.validator(path, query, header, formData, body)
  let scheme = call_574183.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574183.url(scheme.get, call_574183.host, call_574183.base,
                         call_574183.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574183, url, valid)

proc call*(call_574184: Call_AvailablePrivateEndpointTypesListByResourceGroup_574176;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          location: string): Recallable =
  ## availablePrivateEndpointTypesListByResourceGroup
  ## Returns all of the resource types that can be linked to a Private Endpoint in this subscription in this region.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   location: string (required)
  ##           : The location of the domain name.
  var path_574185 = newJObject()
  var query_574186 = newJObject()
  add(path_574185, "resourceGroupName", newJString(resourceGroupName))
  add(query_574186, "api-version", newJString(apiVersion))
  add(path_574185, "subscriptionId", newJString(subscriptionId))
  add(path_574185, "location", newJString(location))
  result = call_574184.call(path_574185, query_574186, nil, nil, nil)

var availablePrivateEndpointTypesListByResourceGroup* = Call_AvailablePrivateEndpointTypesListByResourceGroup_574176(
    name: "availablePrivateEndpointTypesListByResourceGroup",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/locations/{location}/availablePrivateEndpointTypes",
    validator: validate_AvailablePrivateEndpointTypesListByResourceGroup_574177,
    base: "", url: url_AvailablePrivateEndpointTypesListByResourceGroup_574178,
    schemes: {Scheme.Https})
type
  Call_PrivateEndpointsList_574187 = ref object of OpenApiRestCall_573641
proc url_PrivateEndpointsList_574189(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/privateEndpoints")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PrivateEndpointsList_574188(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all private endpoints in a resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574190 = path.getOrDefault("resourceGroupName")
  valid_574190 = validateParameter(valid_574190, JString, required = true,
                                 default = nil)
  if valid_574190 != nil:
    section.add "resourceGroupName", valid_574190
  var valid_574191 = path.getOrDefault("subscriptionId")
  valid_574191 = validateParameter(valid_574191, JString, required = true,
                                 default = nil)
  if valid_574191 != nil:
    section.add "subscriptionId", valid_574191
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574192 = query.getOrDefault("api-version")
  valid_574192 = validateParameter(valid_574192, JString, required = true,
                                 default = nil)
  if valid_574192 != nil:
    section.add "api-version", valid_574192
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574193: Call_PrivateEndpointsList_574187; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all private endpoints in a resource group.
  ## 
  let valid = call_574193.validator(path, query, header, formData, body)
  let scheme = call_574193.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574193.url(scheme.get, call_574193.host, call_574193.base,
                         call_574193.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574193, url, valid)

proc call*(call_574194: Call_PrivateEndpointsList_574187;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## privateEndpointsList
  ## Gets all private endpoints in a resource group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_574195 = newJObject()
  var query_574196 = newJObject()
  add(path_574195, "resourceGroupName", newJString(resourceGroupName))
  add(query_574196, "api-version", newJString(apiVersion))
  add(path_574195, "subscriptionId", newJString(subscriptionId))
  result = call_574194.call(path_574195, query_574196, nil, nil, nil)

var privateEndpointsList* = Call_PrivateEndpointsList_574187(
    name: "privateEndpointsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/privateEndpoints",
    validator: validate_PrivateEndpointsList_574188, base: "",
    url: url_PrivateEndpointsList_574189, schemes: {Scheme.Https})
type
  Call_PrivateEndpointsCreateOrUpdate_574210 = ref object of OpenApiRestCall_573641
proc url_PrivateEndpointsCreateOrUpdate_574212(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "privateEndpointName" in path,
        "`privateEndpointName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/privateEndpoints/"),
               (kind: VariableSegment, value: "privateEndpointName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PrivateEndpointsCreateOrUpdate_574211(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates an private endpoint in the specified resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   privateEndpointName: JString (required)
  ##                      : The name of the private endpoint.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574239 = path.getOrDefault("resourceGroupName")
  valid_574239 = validateParameter(valid_574239, JString, required = true,
                                 default = nil)
  if valid_574239 != nil:
    section.add "resourceGroupName", valid_574239
  var valid_574240 = path.getOrDefault("subscriptionId")
  valid_574240 = validateParameter(valid_574240, JString, required = true,
                                 default = nil)
  if valid_574240 != nil:
    section.add "subscriptionId", valid_574240
  var valid_574241 = path.getOrDefault("privateEndpointName")
  valid_574241 = validateParameter(valid_574241, JString, required = true,
                                 default = nil)
  if valid_574241 != nil:
    section.add "privateEndpointName", valid_574241
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574242 = query.getOrDefault("api-version")
  valid_574242 = validateParameter(valid_574242, JString, required = true,
                                 default = nil)
  if valid_574242 != nil:
    section.add "api-version", valid_574242
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the create or update private endpoint operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_574244: Call_PrivateEndpointsCreateOrUpdate_574210; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates an private endpoint in the specified resource group.
  ## 
  let valid = call_574244.validator(path, query, header, formData, body)
  let scheme = call_574244.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574244.url(scheme.get, call_574244.host, call_574244.base,
                         call_574244.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574244, url, valid)

proc call*(call_574245: Call_PrivateEndpointsCreateOrUpdate_574210;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          privateEndpointName: string; parameters: JsonNode): Recallable =
  ## privateEndpointsCreateOrUpdate
  ## Creates or updates an private endpoint in the specified resource group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   privateEndpointName: string (required)
  ##                      : The name of the private endpoint.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the create or update private endpoint operation.
  var path_574246 = newJObject()
  var query_574247 = newJObject()
  var body_574248 = newJObject()
  add(path_574246, "resourceGroupName", newJString(resourceGroupName))
  add(query_574247, "api-version", newJString(apiVersion))
  add(path_574246, "subscriptionId", newJString(subscriptionId))
  add(path_574246, "privateEndpointName", newJString(privateEndpointName))
  if parameters != nil:
    body_574248 = parameters
  result = call_574245.call(path_574246, query_574247, nil, nil, body_574248)

var privateEndpointsCreateOrUpdate* = Call_PrivateEndpointsCreateOrUpdate_574210(
    name: "privateEndpointsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/privateEndpoints/{privateEndpointName}",
    validator: validate_PrivateEndpointsCreateOrUpdate_574211, base: "",
    url: url_PrivateEndpointsCreateOrUpdate_574212, schemes: {Scheme.Https})
type
  Call_PrivateEndpointsGet_574197 = ref object of OpenApiRestCall_573641
proc url_PrivateEndpointsGet_574199(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "privateEndpointName" in path,
        "`privateEndpointName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/privateEndpoints/"),
               (kind: VariableSegment, value: "privateEndpointName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PrivateEndpointsGet_574198(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Gets the specified private endpoint by resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   privateEndpointName: JString (required)
  ##                      : The name of the private endpoint.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574201 = path.getOrDefault("resourceGroupName")
  valid_574201 = validateParameter(valid_574201, JString, required = true,
                                 default = nil)
  if valid_574201 != nil:
    section.add "resourceGroupName", valid_574201
  var valid_574202 = path.getOrDefault("subscriptionId")
  valid_574202 = validateParameter(valid_574202, JString, required = true,
                                 default = nil)
  if valid_574202 != nil:
    section.add "subscriptionId", valid_574202
  var valid_574203 = path.getOrDefault("privateEndpointName")
  valid_574203 = validateParameter(valid_574203, JString, required = true,
                                 default = nil)
  if valid_574203 != nil:
    section.add "privateEndpointName", valid_574203
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $expand: JString
  ##          : Expands referenced resources.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574204 = query.getOrDefault("api-version")
  valid_574204 = validateParameter(valid_574204, JString, required = true,
                                 default = nil)
  if valid_574204 != nil:
    section.add "api-version", valid_574204
  var valid_574205 = query.getOrDefault("$expand")
  valid_574205 = validateParameter(valid_574205, JString, required = false,
                                 default = nil)
  if valid_574205 != nil:
    section.add "$expand", valid_574205
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574206: Call_PrivateEndpointsGet_574197; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the specified private endpoint by resource group.
  ## 
  let valid = call_574206.validator(path, query, header, formData, body)
  let scheme = call_574206.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574206.url(scheme.get, call_574206.host, call_574206.base,
                         call_574206.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574206, url, valid)

proc call*(call_574207: Call_PrivateEndpointsGet_574197; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; privateEndpointName: string;
          Expand: string = ""): Recallable =
  ## privateEndpointsGet
  ## Gets the specified private endpoint by resource group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   Expand: string
  ##         : Expands referenced resources.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   privateEndpointName: string (required)
  ##                      : The name of the private endpoint.
  var path_574208 = newJObject()
  var query_574209 = newJObject()
  add(path_574208, "resourceGroupName", newJString(resourceGroupName))
  add(query_574209, "api-version", newJString(apiVersion))
  add(query_574209, "$expand", newJString(Expand))
  add(path_574208, "subscriptionId", newJString(subscriptionId))
  add(path_574208, "privateEndpointName", newJString(privateEndpointName))
  result = call_574207.call(path_574208, query_574209, nil, nil, nil)

var privateEndpointsGet* = Call_PrivateEndpointsGet_574197(
    name: "privateEndpointsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/privateEndpoints/{privateEndpointName}",
    validator: validate_PrivateEndpointsGet_574198, base: "",
    url: url_PrivateEndpointsGet_574199, schemes: {Scheme.Https})
type
  Call_PrivateEndpointsDelete_574249 = ref object of OpenApiRestCall_573641
proc url_PrivateEndpointsDelete_574251(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "privateEndpointName" in path,
        "`privateEndpointName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/privateEndpoints/"),
               (kind: VariableSegment, value: "privateEndpointName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PrivateEndpointsDelete_574250(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the specified private endpoint.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   privateEndpointName: JString (required)
  ##                      : The name of the private endpoint.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574252 = path.getOrDefault("resourceGroupName")
  valid_574252 = validateParameter(valid_574252, JString, required = true,
                                 default = nil)
  if valid_574252 != nil:
    section.add "resourceGroupName", valid_574252
  var valid_574253 = path.getOrDefault("subscriptionId")
  valid_574253 = validateParameter(valid_574253, JString, required = true,
                                 default = nil)
  if valid_574253 != nil:
    section.add "subscriptionId", valid_574253
  var valid_574254 = path.getOrDefault("privateEndpointName")
  valid_574254 = validateParameter(valid_574254, JString, required = true,
                                 default = nil)
  if valid_574254 != nil:
    section.add "privateEndpointName", valid_574254
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574255 = query.getOrDefault("api-version")
  valid_574255 = validateParameter(valid_574255, JString, required = true,
                                 default = nil)
  if valid_574255 != nil:
    section.add "api-version", valid_574255
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574256: Call_PrivateEndpointsDelete_574249; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified private endpoint.
  ## 
  let valid = call_574256.validator(path, query, header, formData, body)
  let scheme = call_574256.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574256.url(scheme.get, call_574256.host, call_574256.base,
                         call_574256.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574256, url, valid)

proc call*(call_574257: Call_PrivateEndpointsDelete_574249;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          privateEndpointName: string): Recallable =
  ## privateEndpointsDelete
  ## Deletes the specified private endpoint.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   privateEndpointName: string (required)
  ##                      : The name of the private endpoint.
  var path_574258 = newJObject()
  var query_574259 = newJObject()
  add(path_574258, "resourceGroupName", newJString(resourceGroupName))
  add(query_574259, "api-version", newJString(apiVersion))
  add(path_574258, "subscriptionId", newJString(subscriptionId))
  add(path_574258, "privateEndpointName", newJString(privateEndpointName))
  result = call_574257.call(path_574258, query_574259, nil, nil, nil)

var privateEndpointsDelete* = Call_PrivateEndpointsDelete_574249(
    name: "privateEndpointsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/privateEndpoints/{privateEndpointName}",
    validator: validate_PrivateEndpointsDelete_574250, base: "",
    url: url_PrivateEndpointsDelete_574251, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
