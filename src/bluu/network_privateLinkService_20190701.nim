
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
  macServiceName = "network-privateLinkService"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_PrivateLinkServicesListAutoApprovedPrivateLinkServices_573863 = ref object of OpenApiRestCall_573641
proc url_PrivateLinkServicesListAutoApprovedPrivateLinkServices_573865(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
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
               (kind: VariableSegment, value: "location"), (kind: ConstantSegment,
        value: "/autoApprovedPrivateLinkServices")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PrivateLinkServicesListAutoApprovedPrivateLinkServices_573864(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Returns all of the private link service ids that can be linked to a Private Endpoint with auto approved in this subscription in this region.
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

proc call*(call_574054: Call_PrivateLinkServicesListAutoApprovedPrivateLinkServices_573863;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns all of the private link service ids that can be linked to a Private Endpoint with auto approved in this subscription in this region.
  ## 
  let valid = call_574054.validator(path, query, header, formData, body)
  let scheme = call_574054.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574054.url(scheme.get, call_574054.host, call_574054.base,
                         call_574054.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574054, url, valid)

proc call*(call_574125: Call_PrivateLinkServicesListAutoApprovedPrivateLinkServices_573863;
          apiVersion: string; subscriptionId: string; location: string): Recallable =
  ## privateLinkServicesListAutoApprovedPrivateLinkServices
  ## Returns all of the private link service ids that can be linked to a Private Endpoint with auto approved in this subscription in this region.
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

var privateLinkServicesListAutoApprovedPrivateLinkServices* = Call_PrivateLinkServicesListAutoApprovedPrivateLinkServices_573863(
    name: "privateLinkServicesListAutoApprovedPrivateLinkServices",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Network/locations/{location}/autoApprovedPrivateLinkServices",
    validator: validate_PrivateLinkServicesListAutoApprovedPrivateLinkServices_573864,
    base: "", url: url_PrivateLinkServicesListAutoApprovedPrivateLinkServices_573865,
    schemes: {Scheme.Https})
type
  Call_PrivateLinkServicesCheckPrivateLinkServiceVisibility_574167 = ref object of OpenApiRestCall_573641
proc url_PrivateLinkServicesCheckPrivateLinkServiceVisibility_574169(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
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
               (kind: VariableSegment, value: "location"), (kind: ConstantSegment,
        value: "/checkPrivateLinkServiceVisibility")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PrivateLinkServicesCheckPrivateLinkServiceVisibility_574168(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Checks whether the subscription is visible to private link service.
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
  var valid_574196 = path.getOrDefault("subscriptionId")
  valid_574196 = validateParameter(valid_574196, JString, required = true,
                                 default = nil)
  if valid_574196 != nil:
    section.add "subscriptionId", valid_574196
  var valid_574197 = path.getOrDefault("location")
  valid_574197 = validateParameter(valid_574197, JString, required = true,
                                 default = nil)
  if valid_574197 != nil:
    section.add "location", valid_574197
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574198 = query.getOrDefault("api-version")
  valid_574198 = validateParameter(valid_574198, JString, required = true,
                                 default = nil)
  if valid_574198 != nil:
    section.add "api-version", valid_574198
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The request body of CheckPrivateLinkService API call.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_574200: Call_PrivateLinkServicesCheckPrivateLinkServiceVisibility_574167;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Checks whether the subscription is visible to private link service.
  ## 
  let valid = call_574200.validator(path, query, header, formData, body)
  let scheme = call_574200.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574200.url(scheme.get, call_574200.host, call_574200.base,
                         call_574200.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574200, url, valid)

proc call*(call_574201: Call_PrivateLinkServicesCheckPrivateLinkServiceVisibility_574167;
          apiVersion: string; subscriptionId: string; parameters: JsonNode;
          location: string): Recallable =
  ## privateLinkServicesCheckPrivateLinkServiceVisibility
  ## Checks whether the subscription is visible to private link service.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : The request body of CheckPrivateLinkService API call.
  ##   location: string (required)
  ##           : The location of the domain name.
  var path_574202 = newJObject()
  var query_574203 = newJObject()
  var body_574204 = newJObject()
  add(query_574203, "api-version", newJString(apiVersion))
  add(path_574202, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_574204 = parameters
  add(path_574202, "location", newJString(location))
  result = call_574201.call(path_574202, query_574203, nil, nil, body_574204)

var privateLinkServicesCheckPrivateLinkServiceVisibility* = Call_PrivateLinkServicesCheckPrivateLinkServiceVisibility_574167(
    name: "privateLinkServicesCheckPrivateLinkServiceVisibility",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Network/locations/{location}/checkPrivateLinkServiceVisibility",
    validator: validate_PrivateLinkServicesCheckPrivateLinkServiceVisibility_574168,
    base: "", url: url_PrivateLinkServicesCheckPrivateLinkServiceVisibility_574169,
    schemes: {Scheme.Https})
type
  Call_PrivateLinkServicesListBySubscription_574205 = ref object of OpenApiRestCall_573641
proc url_PrivateLinkServicesListBySubscription_574207(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/privateLinkServices")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PrivateLinkServicesListBySubscription_574206(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all private link service in a subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_574208 = path.getOrDefault("subscriptionId")
  valid_574208 = validateParameter(valid_574208, JString, required = true,
                                 default = nil)
  if valid_574208 != nil:
    section.add "subscriptionId", valid_574208
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574209 = query.getOrDefault("api-version")
  valid_574209 = validateParameter(valid_574209, JString, required = true,
                                 default = nil)
  if valid_574209 != nil:
    section.add "api-version", valid_574209
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574210: Call_PrivateLinkServicesListBySubscription_574205;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets all private link service in a subscription.
  ## 
  let valid = call_574210.validator(path, query, header, formData, body)
  let scheme = call_574210.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574210.url(scheme.get, call_574210.host, call_574210.base,
                         call_574210.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574210, url, valid)

proc call*(call_574211: Call_PrivateLinkServicesListBySubscription_574205;
          apiVersion: string; subscriptionId: string): Recallable =
  ## privateLinkServicesListBySubscription
  ## Gets all private link service in a subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_574212 = newJObject()
  var query_574213 = newJObject()
  add(query_574213, "api-version", newJString(apiVersion))
  add(path_574212, "subscriptionId", newJString(subscriptionId))
  result = call_574211.call(path_574212, query_574213, nil, nil, nil)

var privateLinkServicesListBySubscription* = Call_PrivateLinkServicesListBySubscription_574205(
    name: "privateLinkServicesListBySubscription", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Network/privateLinkServices",
    validator: validate_PrivateLinkServicesListBySubscription_574206, base: "",
    url: url_PrivateLinkServicesListBySubscription_574207, schemes: {Scheme.Https})
type
  Call_PrivateLinkServicesListAutoApprovedPrivateLinkServicesByResourceGroup_574214 = ref object of OpenApiRestCall_573641
proc url_PrivateLinkServicesListAutoApprovedPrivateLinkServicesByResourceGroup_574216(
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
               (kind: VariableSegment, value: "location"), (kind: ConstantSegment,
        value: "/autoApprovedPrivateLinkServices")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PrivateLinkServicesListAutoApprovedPrivateLinkServicesByResourceGroup_574215(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Returns all of the private link service ids that can be linked to a Private Endpoint with auto approved in this subscription in this region.
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
  var valid_574217 = path.getOrDefault("resourceGroupName")
  valid_574217 = validateParameter(valid_574217, JString, required = true,
                                 default = nil)
  if valid_574217 != nil:
    section.add "resourceGroupName", valid_574217
  var valid_574218 = path.getOrDefault("subscriptionId")
  valid_574218 = validateParameter(valid_574218, JString, required = true,
                                 default = nil)
  if valid_574218 != nil:
    section.add "subscriptionId", valid_574218
  var valid_574219 = path.getOrDefault("location")
  valid_574219 = validateParameter(valid_574219, JString, required = true,
                                 default = nil)
  if valid_574219 != nil:
    section.add "location", valid_574219
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574220 = query.getOrDefault("api-version")
  valid_574220 = validateParameter(valid_574220, JString, required = true,
                                 default = nil)
  if valid_574220 != nil:
    section.add "api-version", valid_574220
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574221: Call_PrivateLinkServicesListAutoApprovedPrivateLinkServicesByResourceGroup_574214;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns all of the private link service ids that can be linked to a Private Endpoint with auto approved in this subscription in this region.
  ## 
  let valid = call_574221.validator(path, query, header, formData, body)
  let scheme = call_574221.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574221.url(scheme.get, call_574221.host, call_574221.base,
                         call_574221.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574221, url, valid)

proc call*(call_574222: Call_PrivateLinkServicesListAutoApprovedPrivateLinkServicesByResourceGroup_574214;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          location: string): Recallable =
  ## privateLinkServicesListAutoApprovedPrivateLinkServicesByResourceGroup
  ## Returns all of the private link service ids that can be linked to a Private Endpoint with auto approved in this subscription in this region.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   location: string (required)
  ##           : The location of the domain name.
  var path_574223 = newJObject()
  var query_574224 = newJObject()
  add(path_574223, "resourceGroupName", newJString(resourceGroupName))
  add(query_574224, "api-version", newJString(apiVersion))
  add(path_574223, "subscriptionId", newJString(subscriptionId))
  add(path_574223, "location", newJString(location))
  result = call_574222.call(path_574223, query_574224, nil, nil, nil)

var privateLinkServicesListAutoApprovedPrivateLinkServicesByResourceGroup* = Call_PrivateLinkServicesListAutoApprovedPrivateLinkServicesByResourceGroup_574214(name: "privateLinkServicesListAutoApprovedPrivateLinkServicesByResourceGroup",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/locations/{location}/autoApprovedPrivateLinkServices", validator: validate_PrivateLinkServicesListAutoApprovedPrivateLinkServicesByResourceGroup_574215,
    base: "", url: url_PrivateLinkServicesListAutoApprovedPrivateLinkServicesByResourceGroup_574216,
    schemes: {Scheme.Https})
type
  Call_PrivateLinkServicesCheckPrivateLinkServiceVisibilityByResourceGroup_574225 = ref object of OpenApiRestCall_573641
proc url_PrivateLinkServicesCheckPrivateLinkServiceVisibilityByResourceGroup_574227(
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
               (kind: VariableSegment, value: "location"), (kind: ConstantSegment,
        value: "/checkPrivateLinkServiceVisibility")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PrivateLinkServicesCheckPrivateLinkServiceVisibilityByResourceGroup_574226(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Checks whether the subscription is visible to private link service in the specified resource group.
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
  var valid_574228 = path.getOrDefault("resourceGroupName")
  valid_574228 = validateParameter(valid_574228, JString, required = true,
                                 default = nil)
  if valid_574228 != nil:
    section.add "resourceGroupName", valid_574228
  var valid_574229 = path.getOrDefault("subscriptionId")
  valid_574229 = validateParameter(valid_574229, JString, required = true,
                                 default = nil)
  if valid_574229 != nil:
    section.add "subscriptionId", valid_574229
  var valid_574230 = path.getOrDefault("location")
  valid_574230 = validateParameter(valid_574230, JString, required = true,
                                 default = nil)
  if valid_574230 != nil:
    section.add "location", valid_574230
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574231 = query.getOrDefault("api-version")
  valid_574231 = validateParameter(valid_574231, JString, required = true,
                                 default = nil)
  if valid_574231 != nil:
    section.add "api-version", valid_574231
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The request body of CheckPrivateLinkService API call.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_574233: Call_PrivateLinkServicesCheckPrivateLinkServiceVisibilityByResourceGroup_574225;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Checks whether the subscription is visible to private link service in the specified resource group.
  ## 
  let valid = call_574233.validator(path, query, header, formData, body)
  let scheme = call_574233.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574233.url(scheme.get, call_574233.host, call_574233.base,
                         call_574233.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574233, url, valid)

proc call*(call_574234: Call_PrivateLinkServicesCheckPrivateLinkServiceVisibilityByResourceGroup_574225;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          parameters: JsonNode; location: string): Recallable =
  ## privateLinkServicesCheckPrivateLinkServiceVisibilityByResourceGroup
  ## Checks whether the subscription is visible to private link service in the specified resource group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : The request body of CheckPrivateLinkService API call.
  ##   location: string (required)
  ##           : The location of the domain name.
  var path_574235 = newJObject()
  var query_574236 = newJObject()
  var body_574237 = newJObject()
  add(path_574235, "resourceGroupName", newJString(resourceGroupName))
  add(query_574236, "api-version", newJString(apiVersion))
  add(path_574235, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_574237 = parameters
  add(path_574235, "location", newJString(location))
  result = call_574234.call(path_574235, query_574236, nil, nil, body_574237)

var privateLinkServicesCheckPrivateLinkServiceVisibilityByResourceGroup* = Call_PrivateLinkServicesCheckPrivateLinkServiceVisibilityByResourceGroup_574225(name: "privateLinkServicesCheckPrivateLinkServiceVisibilityByResourceGroup",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/locations/{location}/checkPrivateLinkServiceVisibility", validator: validate_PrivateLinkServicesCheckPrivateLinkServiceVisibilityByResourceGroup_574226,
    base: "", url: url_PrivateLinkServicesCheckPrivateLinkServiceVisibilityByResourceGroup_574227,
    schemes: {Scheme.Https})
type
  Call_PrivateLinkServicesList_574238 = ref object of OpenApiRestCall_573641
proc url_PrivateLinkServicesList_574240(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
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
        value: "/providers/Microsoft.Network/privateLinkServices")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PrivateLinkServicesList_574239(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all private link services in a resource group.
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
  var valid_574241 = path.getOrDefault("resourceGroupName")
  valid_574241 = validateParameter(valid_574241, JString, required = true,
                                 default = nil)
  if valid_574241 != nil:
    section.add "resourceGroupName", valid_574241
  var valid_574242 = path.getOrDefault("subscriptionId")
  valid_574242 = validateParameter(valid_574242, JString, required = true,
                                 default = nil)
  if valid_574242 != nil:
    section.add "subscriptionId", valid_574242
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574243 = query.getOrDefault("api-version")
  valid_574243 = validateParameter(valid_574243, JString, required = true,
                                 default = nil)
  if valid_574243 != nil:
    section.add "api-version", valid_574243
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574244: Call_PrivateLinkServicesList_574238; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all private link services in a resource group.
  ## 
  let valid = call_574244.validator(path, query, header, formData, body)
  let scheme = call_574244.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574244.url(scheme.get, call_574244.host, call_574244.base,
                         call_574244.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574244, url, valid)

proc call*(call_574245: Call_PrivateLinkServicesList_574238;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## privateLinkServicesList
  ## Gets all private link services in a resource group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_574246 = newJObject()
  var query_574247 = newJObject()
  add(path_574246, "resourceGroupName", newJString(resourceGroupName))
  add(query_574247, "api-version", newJString(apiVersion))
  add(path_574246, "subscriptionId", newJString(subscriptionId))
  result = call_574245.call(path_574246, query_574247, nil, nil, nil)

var privateLinkServicesList* = Call_PrivateLinkServicesList_574238(
    name: "privateLinkServicesList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/privateLinkServices",
    validator: validate_PrivateLinkServicesList_574239, base: "",
    url: url_PrivateLinkServicesList_574240, schemes: {Scheme.Https})
type
  Call_PrivateLinkServicesCreateOrUpdate_574261 = ref object of OpenApiRestCall_573641
proc url_PrivateLinkServicesCreateOrUpdate_574263(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/privateLinkServices/"),
               (kind: VariableSegment, value: "serviceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PrivateLinkServicesCreateOrUpdate_574262(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates an private link service in the specified resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: JString (required)
  ##              : The name of the private link service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574264 = path.getOrDefault("resourceGroupName")
  valid_574264 = validateParameter(valid_574264, JString, required = true,
                                 default = nil)
  if valid_574264 != nil:
    section.add "resourceGroupName", valid_574264
  var valid_574265 = path.getOrDefault("subscriptionId")
  valid_574265 = validateParameter(valid_574265, JString, required = true,
                                 default = nil)
  if valid_574265 != nil:
    section.add "subscriptionId", valid_574265
  var valid_574266 = path.getOrDefault("serviceName")
  valid_574266 = validateParameter(valid_574266, JString, required = true,
                                 default = nil)
  if valid_574266 != nil:
    section.add "serviceName", valid_574266
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574267 = query.getOrDefault("api-version")
  valid_574267 = validateParameter(valid_574267, JString, required = true,
                                 default = nil)
  if valid_574267 != nil:
    section.add "api-version", valid_574267
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the create or update private link service operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_574269: Call_PrivateLinkServicesCreateOrUpdate_574261;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates an private link service in the specified resource group.
  ## 
  let valid = call_574269.validator(path, query, header, formData, body)
  let scheme = call_574269.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574269.url(scheme.get, call_574269.host, call_574269.base,
                         call_574269.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574269, url, valid)

proc call*(call_574270: Call_PrivateLinkServicesCreateOrUpdate_574261;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          parameters: JsonNode; serviceName: string): Recallable =
  ## privateLinkServicesCreateOrUpdate
  ## Creates or updates an private link service in the specified resource group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the create or update private link service operation.
  ##   serviceName: string (required)
  ##              : The name of the private link service.
  var path_574271 = newJObject()
  var query_574272 = newJObject()
  var body_574273 = newJObject()
  add(path_574271, "resourceGroupName", newJString(resourceGroupName))
  add(query_574272, "api-version", newJString(apiVersion))
  add(path_574271, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_574273 = parameters
  add(path_574271, "serviceName", newJString(serviceName))
  result = call_574270.call(path_574271, query_574272, nil, nil, body_574273)

var privateLinkServicesCreateOrUpdate* = Call_PrivateLinkServicesCreateOrUpdate_574261(
    name: "privateLinkServicesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/privateLinkServices/{serviceName}",
    validator: validate_PrivateLinkServicesCreateOrUpdate_574262, base: "",
    url: url_PrivateLinkServicesCreateOrUpdate_574263, schemes: {Scheme.Https})
type
  Call_PrivateLinkServicesGet_574248 = ref object of OpenApiRestCall_573641
proc url_PrivateLinkServicesGet_574250(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/privateLinkServices/"),
               (kind: VariableSegment, value: "serviceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PrivateLinkServicesGet_574249(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the specified private link service by resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: JString (required)
  ##              : The name of the private link service.
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
  var valid_574254 = path.getOrDefault("serviceName")
  valid_574254 = validateParameter(valid_574254, JString, required = true,
                                 default = nil)
  if valid_574254 != nil:
    section.add "serviceName", valid_574254
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $expand: JString
  ##          : Expands referenced resources.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574255 = query.getOrDefault("api-version")
  valid_574255 = validateParameter(valid_574255, JString, required = true,
                                 default = nil)
  if valid_574255 != nil:
    section.add "api-version", valid_574255
  var valid_574256 = query.getOrDefault("$expand")
  valid_574256 = validateParameter(valid_574256, JString, required = false,
                                 default = nil)
  if valid_574256 != nil:
    section.add "$expand", valid_574256
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574257: Call_PrivateLinkServicesGet_574248; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the specified private link service by resource group.
  ## 
  let valid = call_574257.validator(path, query, header, formData, body)
  let scheme = call_574257.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574257.url(scheme.get, call_574257.host, call_574257.base,
                         call_574257.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574257, url, valid)

proc call*(call_574258: Call_PrivateLinkServicesGet_574248;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          serviceName: string; Expand: string = ""): Recallable =
  ## privateLinkServicesGet
  ## Gets the specified private link service by resource group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   Expand: string
  ##         : Expands referenced resources.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: string (required)
  ##              : The name of the private link service.
  var path_574259 = newJObject()
  var query_574260 = newJObject()
  add(path_574259, "resourceGroupName", newJString(resourceGroupName))
  add(query_574260, "api-version", newJString(apiVersion))
  add(query_574260, "$expand", newJString(Expand))
  add(path_574259, "subscriptionId", newJString(subscriptionId))
  add(path_574259, "serviceName", newJString(serviceName))
  result = call_574258.call(path_574259, query_574260, nil, nil, nil)

var privateLinkServicesGet* = Call_PrivateLinkServicesGet_574248(
    name: "privateLinkServicesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/privateLinkServices/{serviceName}",
    validator: validate_PrivateLinkServicesGet_574249, base: "",
    url: url_PrivateLinkServicesGet_574250, schemes: {Scheme.Https})
type
  Call_PrivateLinkServicesDelete_574274 = ref object of OpenApiRestCall_573641
proc url_PrivateLinkServicesDelete_574276(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/privateLinkServices/"),
               (kind: VariableSegment, value: "serviceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PrivateLinkServicesDelete_574275(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the specified private link service.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: JString (required)
  ##              : The name of the private link service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574277 = path.getOrDefault("resourceGroupName")
  valid_574277 = validateParameter(valid_574277, JString, required = true,
                                 default = nil)
  if valid_574277 != nil:
    section.add "resourceGroupName", valid_574277
  var valid_574278 = path.getOrDefault("subscriptionId")
  valid_574278 = validateParameter(valid_574278, JString, required = true,
                                 default = nil)
  if valid_574278 != nil:
    section.add "subscriptionId", valid_574278
  var valid_574279 = path.getOrDefault("serviceName")
  valid_574279 = validateParameter(valid_574279, JString, required = true,
                                 default = nil)
  if valid_574279 != nil:
    section.add "serviceName", valid_574279
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574280 = query.getOrDefault("api-version")
  valid_574280 = validateParameter(valid_574280, JString, required = true,
                                 default = nil)
  if valid_574280 != nil:
    section.add "api-version", valid_574280
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574281: Call_PrivateLinkServicesDelete_574274; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified private link service.
  ## 
  let valid = call_574281.validator(path, query, header, formData, body)
  let scheme = call_574281.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574281.url(scheme.get, call_574281.host, call_574281.base,
                         call_574281.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574281, url, valid)

proc call*(call_574282: Call_PrivateLinkServicesDelete_574274;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          serviceName: string): Recallable =
  ## privateLinkServicesDelete
  ## Deletes the specified private link service.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: string (required)
  ##              : The name of the private link service.
  var path_574283 = newJObject()
  var query_574284 = newJObject()
  add(path_574283, "resourceGroupName", newJString(resourceGroupName))
  add(query_574284, "api-version", newJString(apiVersion))
  add(path_574283, "subscriptionId", newJString(subscriptionId))
  add(path_574283, "serviceName", newJString(serviceName))
  result = call_574282.call(path_574283, query_574284, nil, nil, nil)

var privateLinkServicesDelete* = Call_PrivateLinkServicesDelete_574274(
    name: "privateLinkServicesDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/privateLinkServices/{serviceName}",
    validator: validate_PrivateLinkServicesDelete_574275, base: "",
    url: url_PrivateLinkServicesDelete_574276, schemes: {Scheme.Https})
type
  Call_PrivateLinkServicesUpdatePrivateEndpointConnection_574285 = ref object of OpenApiRestCall_573641
proc url_PrivateLinkServicesUpdatePrivateEndpointConnection_574287(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "peConnectionName" in path,
        "`peConnectionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/privateLinkServices/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/privateEndpointConnections/"),
               (kind: VariableSegment, value: "peConnectionName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PrivateLinkServicesUpdatePrivateEndpointConnection_574286(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Approve or reject private end point connection for a private link service in a subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   peConnectionName: JString (required)
  ##                   : The name of the private end point connection.
  ##   serviceName: JString (required)
  ##              : The name of the private link service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574288 = path.getOrDefault("resourceGroupName")
  valid_574288 = validateParameter(valid_574288, JString, required = true,
                                 default = nil)
  if valid_574288 != nil:
    section.add "resourceGroupName", valid_574288
  var valid_574289 = path.getOrDefault("subscriptionId")
  valid_574289 = validateParameter(valid_574289, JString, required = true,
                                 default = nil)
  if valid_574289 != nil:
    section.add "subscriptionId", valid_574289
  var valid_574290 = path.getOrDefault("peConnectionName")
  valid_574290 = validateParameter(valid_574290, JString, required = true,
                                 default = nil)
  if valid_574290 != nil:
    section.add "peConnectionName", valid_574290
  var valid_574291 = path.getOrDefault("serviceName")
  valid_574291 = validateParameter(valid_574291, JString, required = true,
                                 default = nil)
  if valid_574291 != nil:
    section.add "serviceName", valid_574291
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574292 = query.getOrDefault("api-version")
  valid_574292 = validateParameter(valid_574292, JString, required = true,
                                 default = nil)
  if valid_574292 != nil:
    section.add "api-version", valid_574292
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to approve or reject the private end point connection.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_574294: Call_PrivateLinkServicesUpdatePrivateEndpointConnection_574285;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Approve or reject private end point connection for a private link service in a subscription.
  ## 
  let valid = call_574294.validator(path, query, header, formData, body)
  let scheme = call_574294.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574294.url(scheme.get, call_574294.host, call_574294.base,
                         call_574294.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574294, url, valid)

proc call*(call_574295: Call_PrivateLinkServicesUpdatePrivateEndpointConnection_574285;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          peConnectionName: string; parameters: JsonNode; serviceName: string): Recallable =
  ## privateLinkServicesUpdatePrivateEndpointConnection
  ## Approve or reject private end point connection for a private link service in a subscription.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   peConnectionName: string (required)
  ##                   : The name of the private end point connection.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to approve or reject the private end point connection.
  ##   serviceName: string (required)
  ##              : The name of the private link service.
  var path_574296 = newJObject()
  var query_574297 = newJObject()
  var body_574298 = newJObject()
  add(path_574296, "resourceGroupName", newJString(resourceGroupName))
  add(query_574297, "api-version", newJString(apiVersion))
  add(path_574296, "subscriptionId", newJString(subscriptionId))
  add(path_574296, "peConnectionName", newJString(peConnectionName))
  if parameters != nil:
    body_574298 = parameters
  add(path_574296, "serviceName", newJString(serviceName))
  result = call_574295.call(path_574296, query_574297, nil, nil, body_574298)

var privateLinkServicesUpdatePrivateEndpointConnection* = Call_PrivateLinkServicesUpdatePrivateEndpointConnection_574285(
    name: "privateLinkServicesUpdatePrivateEndpointConnection",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/privateLinkServices/{serviceName}/privateEndpointConnections/{peConnectionName}",
    validator: validate_PrivateLinkServicesUpdatePrivateEndpointConnection_574286,
    base: "", url: url_PrivateLinkServicesUpdatePrivateEndpointConnection_574287,
    schemes: {Scheme.Https})
type
  Call_PrivateLinkServicesDeletePrivateEndpointConnection_574299 = ref object of OpenApiRestCall_573641
proc url_PrivateLinkServicesDeletePrivateEndpointConnection_574301(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "peConnectionName" in path,
        "`peConnectionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/privateLinkServices/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/privateEndpointConnections/"),
               (kind: VariableSegment, value: "peConnectionName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PrivateLinkServicesDeletePrivateEndpointConnection_574300(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Delete private end point connection for a private link service in a subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   peConnectionName: JString (required)
  ##                   : The name of the private end point connection.
  ##   serviceName: JString (required)
  ##              : The name of the private link service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574302 = path.getOrDefault("resourceGroupName")
  valid_574302 = validateParameter(valid_574302, JString, required = true,
                                 default = nil)
  if valid_574302 != nil:
    section.add "resourceGroupName", valid_574302
  var valid_574303 = path.getOrDefault("subscriptionId")
  valid_574303 = validateParameter(valid_574303, JString, required = true,
                                 default = nil)
  if valid_574303 != nil:
    section.add "subscriptionId", valid_574303
  var valid_574304 = path.getOrDefault("peConnectionName")
  valid_574304 = validateParameter(valid_574304, JString, required = true,
                                 default = nil)
  if valid_574304 != nil:
    section.add "peConnectionName", valid_574304
  var valid_574305 = path.getOrDefault("serviceName")
  valid_574305 = validateParameter(valid_574305, JString, required = true,
                                 default = nil)
  if valid_574305 != nil:
    section.add "serviceName", valid_574305
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574306 = query.getOrDefault("api-version")
  valid_574306 = validateParameter(valid_574306, JString, required = true,
                                 default = nil)
  if valid_574306 != nil:
    section.add "api-version", valid_574306
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574307: Call_PrivateLinkServicesDeletePrivateEndpointConnection_574299;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Delete private end point connection for a private link service in a subscription.
  ## 
  let valid = call_574307.validator(path, query, header, formData, body)
  let scheme = call_574307.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574307.url(scheme.get, call_574307.host, call_574307.base,
                         call_574307.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574307, url, valid)

proc call*(call_574308: Call_PrivateLinkServicesDeletePrivateEndpointConnection_574299;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          peConnectionName: string; serviceName: string): Recallable =
  ## privateLinkServicesDeletePrivateEndpointConnection
  ## Delete private end point connection for a private link service in a subscription.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   peConnectionName: string (required)
  ##                   : The name of the private end point connection.
  ##   serviceName: string (required)
  ##              : The name of the private link service.
  var path_574309 = newJObject()
  var query_574310 = newJObject()
  add(path_574309, "resourceGroupName", newJString(resourceGroupName))
  add(query_574310, "api-version", newJString(apiVersion))
  add(path_574309, "subscriptionId", newJString(subscriptionId))
  add(path_574309, "peConnectionName", newJString(peConnectionName))
  add(path_574309, "serviceName", newJString(serviceName))
  result = call_574308.call(path_574309, query_574310, nil, nil, nil)

var privateLinkServicesDeletePrivateEndpointConnection* = Call_PrivateLinkServicesDeletePrivateEndpointConnection_574299(
    name: "privateLinkServicesDeletePrivateEndpointConnection",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/privateLinkServices/{serviceName}/privateEndpointConnections/{peConnectionName}",
    validator: validate_PrivateLinkServicesDeletePrivateEndpointConnection_574300,
    base: "", url: url_PrivateLinkServicesDeletePrivateEndpointConnection_574301,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
