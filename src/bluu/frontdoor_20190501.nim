
import
  json, options, hashes, uri, rest, os, uri, httpcore

## auto-generated via openapi macro
## title: FrontDoorManagementClient
## version: 2019-05-01
## termsOfService: (not provided)
## license: (not provided)
## 
## Use these APIs to manage Azure Front Door resources through the Azure Resource Manager. You must make sure that requests made to these resources are secure.
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

  OpenApiRestCall_573658 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_573658](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_573658): Option[Scheme] {.used.} =
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
  macServiceName = "frontdoor"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_CheckFrontDoorNameAvailability_573880 = ref object of OpenApiRestCall_573658
proc url_CheckFrontDoorNameAvailability_573882(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_CheckFrontDoorNameAvailability_573881(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Check the availability of a Front Door resource name.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574041 = query.getOrDefault("api-version")
  valid_574041 = validateParameter(valid_574041, JString, required = true,
                                 default = nil)
  if valid_574041 != nil:
    section.add "api-version", valid_574041
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   checkFrontDoorNameAvailabilityInput: JObject (required)
  ##                                      : Input to check.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_574065: Call_CheckFrontDoorNameAvailability_573880; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Check the availability of a Front Door resource name.
  ## 
  let valid = call_574065.validator(path, query, header, formData, body)
  let scheme = call_574065.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574065.url(scheme.get, call_574065.host, call_574065.base,
                         call_574065.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574065, url, valid)

proc call*(call_574136: Call_CheckFrontDoorNameAvailability_573880;
          apiVersion: string; checkFrontDoorNameAvailabilityInput: JsonNode): Recallable =
  ## checkFrontDoorNameAvailability
  ## Check the availability of a Front Door resource name.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   checkFrontDoorNameAvailabilityInput: JObject (required)
  ##                                      : Input to check.
  var query_574137 = newJObject()
  var body_574139 = newJObject()
  add(query_574137, "api-version", newJString(apiVersion))
  if checkFrontDoorNameAvailabilityInput != nil:
    body_574139 = checkFrontDoorNameAvailabilityInput
  result = call_574136.call(nil, query_574137, nil, nil, body_574139)

var checkFrontDoorNameAvailability* = Call_CheckFrontDoorNameAvailability_573880(
    name: "checkFrontDoorNameAvailability", meth: HttpMethod.HttpPost,
    host: "management.azure.com",
    route: "/providers/Microsoft.Network/checkFrontDoorNameAvailability",
    validator: validate_CheckFrontDoorNameAvailability_573881, base: "",
    url: url_CheckFrontDoorNameAvailability_573882, schemes: {Scheme.Https})
type
  Call_CheckFrontDoorNameAvailabilityWithSubscription_574178 = ref object of OpenApiRestCall_573658
proc url_CheckFrontDoorNameAvailabilityWithSubscription_574180(protocol: Scheme;
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
        value: "/providers/Microsoft.Network/checkFrontDoorNameAvailability")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CheckFrontDoorNameAvailabilityWithSubscription_574179(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Check the availability of a Front Door subdomain.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_574195 = path.getOrDefault("subscriptionId")
  valid_574195 = validateParameter(valid_574195, JString, required = true,
                                 default = nil)
  if valid_574195 != nil:
    section.add "subscriptionId", valid_574195
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574196 = query.getOrDefault("api-version")
  valid_574196 = validateParameter(valid_574196, JString, required = true,
                                 default = nil)
  if valid_574196 != nil:
    section.add "api-version", valid_574196
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   checkFrontDoorNameAvailabilityInput: JObject (required)
  ##                                      : Input to check.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_574198: Call_CheckFrontDoorNameAvailabilityWithSubscription_574178;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Check the availability of a Front Door subdomain.
  ## 
  let valid = call_574198.validator(path, query, header, formData, body)
  let scheme = call_574198.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574198.url(scheme.get, call_574198.host, call_574198.base,
                         call_574198.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574198, url, valid)

proc call*(call_574199: Call_CheckFrontDoorNameAvailabilityWithSubscription_574178;
          apiVersion: string; subscriptionId: string;
          checkFrontDoorNameAvailabilityInput: JsonNode): Recallable =
  ## checkFrontDoorNameAvailabilityWithSubscription
  ## Check the availability of a Front Door subdomain.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   checkFrontDoorNameAvailabilityInput: JObject (required)
  ##                                      : Input to check.
  var path_574200 = newJObject()
  var query_574201 = newJObject()
  var body_574202 = newJObject()
  add(query_574201, "api-version", newJString(apiVersion))
  add(path_574200, "subscriptionId", newJString(subscriptionId))
  if checkFrontDoorNameAvailabilityInput != nil:
    body_574202 = checkFrontDoorNameAvailabilityInput
  result = call_574199.call(path_574200, query_574201, nil, nil, body_574202)

var checkFrontDoorNameAvailabilityWithSubscription* = Call_CheckFrontDoorNameAvailabilityWithSubscription_574178(
    name: "checkFrontDoorNameAvailabilityWithSubscription",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Network/checkFrontDoorNameAvailability",
    validator: validate_CheckFrontDoorNameAvailabilityWithSubscription_574179,
    base: "", url: url_CheckFrontDoorNameAvailabilityWithSubscription_574180,
    schemes: {Scheme.Https})
type
  Call_FrontDoorsList_574203 = ref object of OpenApiRestCall_573658
proc url_FrontDoorsList_574205(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Network/frontDoors")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FrontDoorsList_574204(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Lists all of the Front Doors within an Azure subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_574206 = path.getOrDefault("subscriptionId")
  valid_574206 = validateParameter(valid_574206, JString, required = true,
                                 default = nil)
  if valid_574206 != nil:
    section.add "subscriptionId", valid_574206
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574207 = query.getOrDefault("api-version")
  valid_574207 = validateParameter(valid_574207, JString, required = true,
                                 default = nil)
  if valid_574207 != nil:
    section.add "api-version", valid_574207
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574208: Call_FrontDoorsList_574203; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the Front Doors within an Azure subscription.
  ## 
  let valid = call_574208.validator(path, query, header, formData, body)
  let scheme = call_574208.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574208.url(scheme.get, call_574208.host, call_574208.base,
                         call_574208.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574208, url, valid)

proc call*(call_574209: Call_FrontDoorsList_574203; apiVersion: string;
          subscriptionId: string): Recallable =
  ## frontDoorsList
  ## Lists all of the Front Doors within an Azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_574210 = newJObject()
  var query_574211 = newJObject()
  add(query_574211, "api-version", newJString(apiVersion))
  add(path_574210, "subscriptionId", newJString(subscriptionId))
  result = call_574209.call(path_574210, query_574211, nil, nil, nil)

var frontDoorsList* = Call_FrontDoorsList_574203(name: "frontDoorsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Network/frontDoors",
    validator: validate_FrontDoorsList_574204, base: "", url: url_FrontDoorsList_574205,
    schemes: {Scheme.Https})
type
  Call_FrontDoorsListByResourceGroup_574212 = ref object of OpenApiRestCall_573658
proc url_FrontDoorsListByResourceGroup_574214(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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
        kind: ConstantSegment, value: "/providers/Microsoft.Network/frontDoors")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FrontDoorsListByResourceGroup_574213(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all of the Front Doors within a resource group under a subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574215 = path.getOrDefault("resourceGroupName")
  valid_574215 = validateParameter(valid_574215, JString, required = true,
                                 default = nil)
  if valid_574215 != nil:
    section.add "resourceGroupName", valid_574215
  var valid_574216 = path.getOrDefault("subscriptionId")
  valid_574216 = validateParameter(valid_574216, JString, required = true,
                                 default = nil)
  if valid_574216 != nil:
    section.add "subscriptionId", valid_574216
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574217 = query.getOrDefault("api-version")
  valid_574217 = validateParameter(valid_574217, JString, required = true,
                                 default = nil)
  if valid_574217 != nil:
    section.add "api-version", valid_574217
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574218: Call_FrontDoorsListByResourceGroup_574212; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the Front Doors within a resource group under a subscription.
  ## 
  let valid = call_574218.validator(path, query, header, formData, body)
  let scheme = call_574218.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574218.url(scheme.get, call_574218.host, call_574218.base,
                         call_574218.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574218, url, valid)

proc call*(call_574219: Call_FrontDoorsListByResourceGroup_574212;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## frontDoorsListByResourceGroup
  ## Lists all of the Front Doors within a resource group under a subscription.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_574220 = newJObject()
  var query_574221 = newJObject()
  add(path_574220, "resourceGroupName", newJString(resourceGroupName))
  add(query_574221, "api-version", newJString(apiVersion))
  add(path_574220, "subscriptionId", newJString(subscriptionId))
  result = call_574219.call(path_574220, query_574221, nil, nil, nil)

var frontDoorsListByResourceGroup* = Call_FrontDoorsListByResourceGroup_574212(
    name: "frontDoorsListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/frontDoors",
    validator: validate_FrontDoorsListByResourceGroup_574213, base: "",
    url: url_FrontDoorsListByResourceGroup_574214, schemes: {Scheme.Https})
type
  Call_FrontDoorsCreateOrUpdate_574233 = ref object of OpenApiRestCall_573658
proc url_FrontDoorsCreateOrUpdate_574235(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "frontDoorName" in path, "`frontDoorName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Network/frontDoors/"),
               (kind: VariableSegment, value: "frontDoorName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FrontDoorsCreateOrUpdate_574234(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a new Front Door with a Front Door name under the specified subscription and resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   frontDoorName: JString (required)
  ##                : Name of the Front Door which is globally unique.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574253 = path.getOrDefault("resourceGroupName")
  valid_574253 = validateParameter(valid_574253, JString, required = true,
                                 default = nil)
  if valid_574253 != nil:
    section.add "resourceGroupName", valid_574253
  var valid_574254 = path.getOrDefault("subscriptionId")
  valid_574254 = validateParameter(valid_574254, JString, required = true,
                                 default = nil)
  if valid_574254 != nil:
    section.add "subscriptionId", valid_574254
  var valid_574255 = path.getOrDefault("frontDoorName")
  valid_574255 = validateParameter(valid_574255, JString, required = true,
                                 default = nil)
  if valid_574255 != nil:
    section.add "frontDoorName", valid_574255
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574256 = query.getOrDefault("api-version")
  valid_574256 = validateParameter(valid_574256, JString, required = true,
                                 default = nil)
  if valid_574256 != nil:
    section.add "api-version", valid_574256
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   frontDoorParameters: JObject (required)
  ##                      : Front Door properties needed to create a new Front Door.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_574258: Call_FrontDoorsCreateOrUpdate_574233; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new Front Door with a Front Door name under the specified subscription and resource group.
  ## 
  let valid = call_574258.validator(path, query, header, formData, body)
  let scheme = call_574258.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574258.url(scheme.get, call_574258.host, call_574258.base,
                         call_574258.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574258, url, valid)

proc call*(call_574259: Call_FrontDoorsCreateOrUpdate_574233;
          resourceGroupName: string; apiVersion: string;
          frontDoorParameters: JsonNode; subscriptionId: string;
          frontDoorName: string): Recallable =
  ## frontDoorsCreateOrUpdate
  ## Creates a new Front Door with a Front Door name under the specified subscription and resource group.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   frontDoorParameters: JObject (required)
  ##                      : Front Door properties needed to create a new Front Door.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   frontDoorName: string (required)
  ##                : Name of the Front Door which is globally unique.
  var path_574260 = newJObject()
  var query_574261 = newJObject()
  var body_574262 = newJObject()
  add(path_574260, "resourceGroupName", newJString(resourceGroupName))
  add(query_574261, "api-version", newJString(apiVersion))
  if frontDoorParameters != nil:
    body_574262 = frontDoorParameters
  add(path_574260, "subscriptionId", newJString(subscriptionId))
  add(path_574260, "frontDoorName", newJString(frontDoorName))
  result = call_574259.call(path_574260, query_574261, nil, nil, body_574262)

var frontDoorsCreateOrUpdate* = Call_FrontDoorsCreateOrUpdate_574233(
    name: "frontDoorsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/frontDoors/{frontDoorName}",
    validator: validate_FrontDoorsCreateOrUpdate_574234, base: "",
    url: url_FrontDoorsCreateOrUpdate_574235, schemes: {Scheme.Https})
type
  Call_FrontDoorsGet_574222 = ref object of OpenApiRestCall_573658
proc url_FrontDoorsGet_574224(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "frontDoorName" in path, "`frontDoorName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Network/frontDoors/"),
               (kind: VariableSegment, value: "frontDoorName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FrontDoorsGet_574223(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a Front Door with the specified Front Door name under the specified subscription and resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   frontDoorName: JString (required)
  ##                : Name of the Front Door which is globally unique.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574225 = path.getOrDefault("resourceGroupName")
  valid_574225 = validateParameter(valid_574225, JString, required = true,
                                 default = nil)
  if valid_574225 != nil:
    section.add "resourceGroupName", valid_574225
  var valid_574226 = path.getOrDefault("subscriptionId")
  valid_574226 = validateParameter(valid_574226, JString, required = true,
                                 default = nil)
  if valid_574226 != nil:
    section.add "subscriptionId", valid_574226
  var valid_574227 = path.getOrDefault("frontDoorName")
  valid_574227 = validateParameter(valid_574227, JString, required = true,
                                 default = nil)
  if valid_574227 != nil:
    section.add "frontDoorName", valid_574227
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574228 = query.getOrDefault("api-version")
  valid_574228 = validateParameter(valid_574228, JString, required = true,
                                 default = nil)
  if valid_574228 != nil:
    section.add "api-version", valid_574228
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574229: Call_FrontDoorsGet_574222; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a Front Door with the specified Front Door name under the specified subscription and resource group.
  ## 
  let valid = call_574229.validator(path, query, header, formData, body)
  let scheme = call_574229.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574229.url(scheme.get, call_574229.host, call_574229.base,
                         call_574229.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574229, url, valid)

proc call*(call_574230: Call_FrontDoorsGet_574222; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; frontDoorName: string): Recallable =
  ## frontDoorsGet
  ## Gets a Front Door with the specified Front Door name under the specified subscription and resource group.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   frontDoorName: string (required)
  ##                : Name of the Front Door which is globally unique.
  var path_574231 = newJObject()
  var query_574232 = newJObject()
  add(path_574231, "resourceGroupName", newJString(resourceGroupName))
  add(query_574232, "api-version", newJString(apiVersion))
  add(path_574231, "subscriptionId", newJString(subscriptionId))
  add(path_574231, "frontDoorName", newJString(frontDoorName))
  result = call_574230.call(path_574231, query_574232, nil, nil, nil)

var frontDoorsGet* = Call_FrontDoorsGet_574222(name: "frontDoorsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/frontDoors/{frontDoorName}",
    validator: validate_FrontDoorsGet_574223, base: "", url: url_FrontDoorsGet_574224,
    schemes: {Scheme.Https})
type
  Call_FrontDoorsDelete_574263 = ref object of OpenApiRestCall_573658
proc url_FrontDoorsDelete_574265(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "frontDoorName" in path, "`frontDoorName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Network/frontDoors/"),
               (kind: VariableSegment, value: "frontDoorName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FrontDoorsDelete_574264(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Deletes an existing Front Door with the specified parameters.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   frontDoorName: JString (required)
  ##                : Name of the Front Door which is globally unique.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574266 = path.getOrDefault("resourceGroupName")
  valid_574266 = validateParameter(valid_574266, JString, required = true,
                                 default = nil)
  if valid_574266 != nil:
    section.add "resourceGroupName", valid_574266
  var valid_574267 = path.getOrDefault("subscriptionId")
  valid_574267 = validateParameter(valid_574267, JString, required = true,
                                 default = nil)
  if valid_574267 != nil:
    section.add "subscriptionId", valid_574267
  var valid_574268 = path.getOrDefault("frontDoorName")
  valid_574268 = validateParameter(valid_574268, JString, required = true,
                                 default = nil)
  if valid_574268 != nil:
    section.add "frontDoorName", valid_574268
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574269 = query.getOrDefault("api-version")
  valid_574269 = validateParameter(valid_574269, JString, required = true,
                                 default = nil)
  if valid_574269 != nil:
    section.add "api-version", valid_574269
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574270: Call_FrontDoorsDelete_574263; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an existing Front Door with the specified parameters.
  ## 
  let valid = call_574270.validator(path, query, header, formData, body)
  let scheme = call_574270.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574270.url(scheme.get, call_574270.host, call_574270.base,
                         call_574270.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574270, url, valid)

proc call*(call_574271: Call_FrontDoorsDelete_574263; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; frontDoorName: string): Recallable =
  ## frontDoorsDelete
  ## Deletes an existing Front Door with the specified parameters.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   frontDoorName: string (required)
  ##                : Name of the Front Door which is globally unique.
  var path_574272 = newJObject()
  var query_574273 = newJObject()
  add(path_574272, "resourceGroupName", newJString(resourceGroupName))
  add(query_574273, "api-version", newJString(apiVersion))
  add(path_574272, "subscriptionId", newJString(subscriptionId))
  add(path_574272, "frontDoorName", newJString(frontDoorName))
  result = call_574271.call(path_574272, query_574273, nil, nil, nil)

var frontDoorsDelete* = Call_FrontDoorsDelete_574263(name: "frontDoorsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/frontDoors/{frontDoorName}",
    validator: validate_FrontDoorsDelete_574264, base: "",
    url: url_FrontDoorsDelete_574265, schemes: {Scheme.Https})
type
  Call_FrontendEndpointsListByFrontDoor_574274 = ref object of OpenApiRestCall_573658
proc url_FrontendEndpointsListByFrontDoor_574276(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "frontDoorName" in path, "`frontDoorName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Network/frontDoors/"),
               (kind: VariableSegment, value: "frontDoorName"),
               (kind: ConstantSegment, value: "/frontendEndpoints")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FrontendEndpointsListByFrontDoor_574275(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all of the frontend endpoints within a Front Door.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   frontDoorName: JString (required)
  ##                : Name of the Front Door which is globally unique.
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
  var valid_574279 = path.getOrDefault("frontDoorName")
  valid_574279 = validateParameter(valid_574279, JString, required = true,
                                 default = nil)
  if valid_574279 != nil:
    section.add "frontDoorName", valid_574279
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

proc call*(call_574281: Call_FrontendEndpointsListByFrontDoor_574274;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all of the frontend endpoints within a Front Door.
  ## 
  let valid = call_574281.validator(path, query, header, formData, body)
  let scheme = call_574281.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574281.url(scheme.get, call_574281.host, call_574281.base,
                         call_574281.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574281, url, valid)

proc call*(call_574282: Call_FrontendEndpointsListByFrontDoor_574274;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          frontDoorName: string): Recallable =
  ## frontendEndpointsListByFrontDoor
  ## Lists all of the frontend endpoints within a Front Door.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   frontDoorName: string (required)
  ##                : Name of the Front Door which is globally unique.
  var path_574283 = newJObject()
  var query_574284 = newJObject()
  add(path_574283, "resourceGroupName", newJString(resourceGroupName))
  add(query_574284, "api-version", newJString(apiVersion))
  add(path_574283, "subscriptionId", newJString(subscriptionId))
  add(path_574283, "frontDoorName", newJString(frontDoorName))
  result = call_574282.call(path_574283, query_574284, nil, nil, nil)

var frontendEndpointsListByFrontDoor* = Call_FrontendEndpointsListByFrontDoor_574274(
    name: "frontendEndpointsListByFrontDoor", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/frontDoors/{frontDoorName}/frontendEndpoints",
    validator: validate_FrontendEndpointsListByFrontDoor_574275, base: "",
    url: url_FrontendEndpointsListByFrontDoor_574276, schemes: {Scheme.Https})
type
  Call_FrontendEndpointsGet_574285 = ref object of OpenApiRestCall_573658
proc url_FrontendEndpointsGet_574287(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "frontDoorName" in path, "`frontDoorName` is a required path parameter"
  assert "frontendEndpointName" in path,
        "`frontendEndpointName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Network/frontDoors/"),
               (kind: VariableSegment, value: "frontDoorName"),
               (kind: ConstantSegment, value: "/frontendEndpoints/"),
               (kind: VariableSegment, value: "frontendEndpointName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FrontendEndpointsGet_574286(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a Frontend endpoint with the specified name within the specified Front Door.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   frontendEndpointName: JString (required)
  ##                       : Name of the Frontend endpoint which is unique within the Front Door.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   frontDoorName: JString (required)
  ##                : Name of the Front Door which is globally unique.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574288 = path.getOrDefault("resourceGroupName")
  valid_574288 = validateParameter(valid_574288, JString, required = true,
                                 default = nil)
  if valid_574288 != nil:
    section.add "resourceGroupName", valid_574288
  var valid_574289 = path.getOrDefault("frontendEndpointName")
  valid_574289 = validateParameter(valid_574289, JString, required = true,
                                 default = nil)
  if valid_574289 != nil:
    section.add "frontendEndpointName", valid_574289
  var valid_574290 = path.getOrDefault("subscriptionId")
  valid_574290 = validateParameter(valid_574290, JString, required = true,
                                 default = nil)
  if valid_574290 != nil:
    section.add "subscriptionId", valid_574290
  var valid_574291 = path.getOrDefault("frontDoorName")
  valid_574291 = validateParameter(valid_574291, JString, required = true,
                                 default = nil)
  if valid_574291 != nil:
    section.add "frontDoorName", valid_574291
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
  if body != nil:
    result.add "body", body

proc call*(call_574293: Call_FrontendEndpointsGet_574285; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a Frontend endpoint with the specified name within the specified Front Door.
  ## 
  let valid = call_574293.validator(path, query, header, formData, body)
  let scheme = call_574293.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574293.url(scheme.get, call_574293.host, call_574293.base,
                         call_574293.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574293, url, valid)

proc call*(call_574294: Call_FrontendEndpointsGet_574285;
          resourceGroupName: string; frontendEndpointName: string;
          apiVersion: string; subscriptionId: string; frontDoorName: string): Recallable =
  ## frontendEndpointsGet
  ## Gets a Frontend endpoint with the specified name within the specified Front Door.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   frontendEndpointName: string (required)
  ##                       : Name of the Frontend endpoint which is unique within the Front Door.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   frontDoorName: string (required)
  ##                : Name of the Front Door which is globally unique.
  var path_574295 = newJObject()
  var query_574296 = newJObject()
  add(path_574295, "resourceGroupName", newJString(resourceGroupName))
  add(path_574295, "frontendEndpointName", newJString(frontendEndpointName))
  add(query_574296, "api-version", newJString(apiVersion))
  add(path_574295, "subscriptionId", newJString(subscriptionId))
  add(path_574295, "frontDoorName", newJString(frontDoorName))
  result = call_574294.call(path_574295, query_574296, nil, nil, nil)

var frontendEndpointsGet* = Call_FrontendEndpointsGet_574285(
    name: "frontendEndpointsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/frontDoors/{frontDoorName}/frontendEndpoints/{frontendEndpointName}",
    validator: validate_FrontendEndpointsGet_574286, base: "",
    url: url_FrontendEndpointsGet_574287, schemes: {Scheme.Https})
type
  Call_FrontendEndpointsDisableHttps_574297 = ref object of OpenApiRestCall_573658
proc url_FrontendEndpointsDisableHttps_574299(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "frontDoorName" in path, "`frontDoorName` is a required path parameter"
  assert "frontendEndpointName" in path,
        "`frontendEndpointName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Network/frontDoors/"),
               (kind: VariableSegment, value: "frontDoorName"),
               (kind: ConstantSegment, value: "/frontendEndpoints/"),
               (kind: VariableSegment, value: "frontendEndpointName"),
               (kind: ConstantSegment, value: "/disableHttps")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FrontendEndpointsDisableHttps_574298(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Disables a frontendEndpoint for HTTPS traffic
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   frontendEndpointName: JString (required)
  ##                       : Name of the Frontend endpoint which is unique within the Front Door.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   frontDoorName: JString (required)
  ##                : Name of the Front Door which is globally unique.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574300 = path.getOrDefault("resourceGroupName")
  valid_574300 = validateParameter(valid_574300, JString, required = true,
                                 default = nil)
  if valid_574300 != nil:
    section.add "resourceGroupName", valid_574300
  var valid_574301 = path.getOrDefault("frontendEndpointName")
  valid_574301 = validateParameter(valid_574301, JString, required = true,
                                 default = nil)
  if valid_574301 != nil:
    section.add "frontendEndpointName", valid_574301
  var valid_574302 = path.getOrDefault("subscriptionId")
  valid_574302 = validateParameter(valid_574302, JString, required = true,
                                 default = nil)
  if valid_574302 != nil:
    section.add "subscriptionId", valid_574302
  var valid_574303 = path.getOrDefault("frontDoorName")
  valid_574303 = validateParameter(valid_574303, JString, required = true,
                                 default = nil)
  if valid_574303 != nil:
    section.add "frontDoorName", valid_574303
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574304 = query.getOrDefault("api-version")
  valid_574304 = validateParameter(valid_574304, JString, required = true,
                                 default = nil)
  if valid_574304 != nil:
    section.add "api-version", valid_574304
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574305: Call_FrontendEndpointsDisableHttps_574297; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Disables a frontendEndpoint for HTTPS traffic
  ## 
  let valid = call_574305.validator(path, query, header, formData, body)
  let scheme = call_574305.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574305.url(scheme.get, call_574305.host, call_574305.base,
                         call_574305.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574305, url, valid)

proc call*(call_574306: Call_FrontendEndpointsDisableHttps_574297;
          resourceGroupName: string; frontendEndpointName: string;
          apiVersion: string; subscriptionId: string; frontDoorName: string): Recallable =
  ## frontendEndpointsDisableHttps
  ## Disables a frontendEndpoint for HTTPS traffic
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   frontendEndpointName: string (required)
  ##                       : Name of the Frontend endpoint which is unique within the Front Door.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   frontDoorName: string (required)
  ##                : Name of the Front Door which is globally unique.
  var path_574307 = newJObject()
  var query_574308 = newJObject()
  add(path_574307, "resourceGroupName", newJString(resourceGroupName))
  add(path_574307, "frontendEndpointName", newJString(frontendEndpointName))
  add(query_574308, "api-version", newJString(apiVersion))
  add(path_574307, "subscriptionId", newJString(subscriptionId))
  add(path_574307, "frontDoorName", newJString(frontDoorName))
  result = call_574306.call(path_574307, query_574308, nil, nil, nil)

var frontendEndpointsDisableHttps* = Call_FrontendEndpointsDisableHttps_574297(
    name: "frontendEndpointsDisableHttps", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/frontDoors/{frontDoorName}/frontendEndpoints/{frontendEndpointName}/disableHttps",
    validator: validate_FrontendEndpointsDisableHttps_574298, base: "",
    url: url_FrontendEndpointsDisableHttps_574299, schemes: {Scheme.Https})
type
  Call_FrontendEndpointsEnableHttps_574309 = ref object of OpenApiRestCall_573658
proc url_FrontendEndpointsEnableHttps_574311(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "frontDoorName" in path, "`frontDoorName` is a required path parameter"
  assert "frontendEndpointName" in path,
        "`frontendEndpointName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Network/frontDoors/"),
               (kind: VariableSegment, value: "frontDoorName"),
               (kind: ConstantSegment, value: "/frontendEndpoints/"),
               (kind: VariableSegment, value: "frontendEndpointName"),
               (kind: ConstantSegment, value: "/enableHttps")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FrontendEndpointsEnableHttps_574310(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Enables a frontendEndpoint for HTTPS traffic
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   frontendEndpointName: JString (required)
  ##                       : Name of the Frontend endpoint which is unique within the Front Door.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   frontDoorName: JString (required)
  ##                : Name of the Front Door which is globally unique.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574312 = path.getOrDefault("resourceGroupName")
  valid_574312 = validateParameter(valid_574312, JString, required = true,
                                 default = nil)
  if valid_574312 != nil:
    section.add "resourceGroupName", valid_574312
  var valid_574313 = path.getOrDefault("frontendEndpointName")
  valid_574313 = validateParameter(valid_574313, JString, required = true,
                                 default = nil)
  if valid_574313 != nil:
    section.add "frontendEndpointName", valid_574313
  var valid_574314 = path.getOrDefault("subscriptionId")
  valid_574314 = validateParameter(valid_574314, JString, required = true,
                                 default = nil)
  if valid_574314 != nil:
    section.add "subscriptionId", valid_574314
  var valid_574315 = path.getOrDefault("frontDoorName")
  valid_574315 = validateParameter(valid_574315, JString, required = true,
                                 default = nil)
  if valid_574315 != nil:
    section.add "frontDoorName", valid_574315
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574316 = query.getOrDefault("api-version")
  valid_574316 = validateParameter(valid_574316, JString, required = true,
                                 default = nil)
  if valid_574316 != nil:
    section.add "api-version", valid_574316
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   customHttpsConfiguration: JObject (required)
  ##                           : The configuration specifying how to enable HTTPS
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_574318: Call_FrontendEndpointsEnableHttps_574309; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Enables a frontendEndpoint for HTTPS traffic
  ## 
  let valid = call_574318.validator(path, query, header, formData, body)
  let scheme = call_574318.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574318.url(scheme.get, call_574318.host, call_574318.base,
                         call_574318.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574318, url, valid)

proc call*(call_574319: Call_FrontendEndpointsEnableHttps_574309;
          resourceGroupName: string; frontendEndpointName: string;
          apiVersion: string; subscriptionId: string;
          customHttpsConfiguration: JsonNode; frontDoorName: string): Recallable =
  ## frontendEndpointsEnableHttps
  ## Enables a frontendEndpoint for HTTPS traffic
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   frontendEndpointName: string (required)
  ##                       : Name of the Frontend endpoint which is unique within the Front Door.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   customHttpsConfiguration: JObject (required)
  ##                           : The configuration specifying how to enable HTTPS
  ##   frontDoorName: string (required)
  ##                : Name of the Front Door which is globally unique.
  var path_574320 = newJObject()
  var query_574321 = newJObject()
  var body_574322 = newJObject()
  add(path_574320, "resourceGroupName", newJString(resourceGroupName))
  add(path_574320, "frontendEndpointName", newJString(frontendEndpointName))
  add(query_574321, "api-version", newJString(apiVersion))
  add(path_574320, "subscriptionId", newJString(subscriptionId))
  if customHttpsConfiguration != nil:
    body_574322 = customHttpsConfiguration
  add(path_574320, "frontDoorName", newJString(frontDoorName))
  result = call_574319.call(path_574320, query_574321, nil, nil, body_574322)

var frontendEndpointsEnableHttps* = Call_FrontendEndpointsEnableHttps_574309(
    name: "frontendEndpointsEnableHttps", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/frontDoors/{frontDoorName}/frontendEndpoints/{frontendEndpointName}/enableHttps",
    validator: validate_FrontendEndpointsEnableHttps_574310, base: "",
    url: url_FrontendEndpointsEnableHttps_574311, schemes: {Scheme.Https})
type
  Call_EndpointsPurgeContent_574323 = ref object of OpenApiRestCall_573658
proc url_EndpointsPurgeContent_574325(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "frontDoorName" in path, "`frontDoorName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Network/frontDoors/"),
               (kind: VariableSegment, value: "frontDoorName"),
               (kind: ConstantSegment, value: "/purge")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_EndpointsPurgeContent_574324(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Removes a content from Front Door.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   frontDoorName: JString (required)
  ##                : Name of the Front Door which is globally unique.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574326 = path.getOrDefault("resourceGroupName")
  valid_574326 = validateParameter(valid_574326, JString, required = true,
                                 default = nil)
  if valid_574326 != nil:
    section.add "resourceGroupName", valid_574326
  var valid_574327 = path.getOrDefault("subscriptionId")
  valid_574327 = validateParameter(valid_574327, JString, required = true,
                                 default = nil)
  if valid_574327 != nil:
    section.add "subscriptionId", valid_574327
  var valid_574328 = path.getOrDefault("frontDoorName")
  valid_574328 = validateParameter(valid_574328, JString, required = true,
                                 default = nil)
  if valid_574328 != nil:
    section.add "frontDoorName", valid_574328
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574329 = query.getOrDefault("api-version")
  valid_574329 = validateParameter(valid_574329, JString, required = true,
                                 default = nil)
  if valid_574329 != nil:
    section.add "api-version", valid_574329
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   contentFilePaths: JObject (required)
  ##                   : The path to the content to be purged. Path can be a full URL, e.g. '/pictures/city.png' which removes a single file, or a directory with a wildcard, e.g. '/pictures/*' which removes all folders and files in the directory.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_574331: Call_EndpointsPurgeContent_574323; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Removes a content from Front Door.
  ## 
  let valid = call_574331.validator(path, query, header, formData, body)
  let scheme = call_574331.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574331.url(scheme.get, call_574331.host, call_574331.base,
                         call_574331.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574331, url, valid)

proc call*(call_574332: Call_EndpointsPurgeContent_574323;
          resourceGroupName: string; contentFilePaths: JsonNode; apiVersion: string;
          subscriptionId: string; frontDoorName: string): Recallable =
  ## endpointsPurgeContent
  ## Removes a content from Front Door.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   contentFilePaths: JObject (required)
  ##                   : The path to the content to be purged. Path can be a full URL, e.g. '/pictures/city.png' which removes a single file, or a directory with a wildcard, e.g. '/pictures/*' which removes all folders and files in the directory.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   frontDoorName: string (required)
  ##                : Name of the Front Door which is globally unique.
  var path_574333 = newJObject()
  var query_574334 = newJObject()
  var body_574335 = newJObject()
  add(path_574333, "resourceGroupName", newJString(resourceGroupName))
  if contentFilePaths != nil:
    body_574335 = contentFilePaths
  add(query_574334, "api-version", newJString(apiVersion))
  add(path_574333, "subscriptionId", newJString(subscriptionId))
  add(path_574333, "frontDoorName", newJString(frontDoorName))
  result = call_574332.call(path_574333, query_574334, nil, nil, body_574335)

var endpointsPurgeContent* = Call_EndpointsPurgeContent_574323(
    name: "endpointsPurgeContent", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/frontDoors/{frontDoorName}/purge",
    validator: validate_EndpointsPurgeContent_574324, base: "",
    url: url_EndpointsPurgeContent_574325, schemes: {Scheme.Https})
type
  Call_FrontDoorsValidateCustomDomain_574336 = ref object of OpenApiRestCall_573658
proc url_FrontDoorsValidateCustomDomain_574338(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "frontDoorName" in path, "`frontDoorName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Network/frontDoors/"),
               (kind: VariableSegment, value: "frontDoorName"),
               (kind: ConstantSegment, value: "/validateCustomDomain")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FrontDoorsValidateCustomDomain_574337(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Validates the custom domain mapping to ensure it maps to the correct Front Door endpoint in DNS.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   frontDoorName: JString (required)
  ##                : Name of the Front Door which is globally unique.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574339 = path.getOrDefault("resourceGroupName")
  valid_574339 = validateParameter(valid_574339, JString, required = true,
                                 default = nil)
  if valid_574339 != nil:
    section.add "resourceGroupName", valid_574339
  var valid_574340 = path.getOrDefault("subscriptionId")
  valid_574340 = validateParameter(valid_574340, JString, required = true,
                                 default = nil)
  if valid_574340 != nil:
    section.add "subscriptionId", valid_574340
  var valid_574341 = path.getOrDefault("frontDoorName")
  valid_574341 = validateParameter(valid_574341, JString, required = true,
                                 default = nil)
  if valid_574341 != nil:
    section.add "frontDoorName", valid_574341
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574342 = query.getOrDefault("api-version")
  valid_574342 = validateParameter(valid_574342, JString, required = true,
                                 default = nil)
  if valid_574342 != nil:
    section.add "api-version", valid_574342
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   customDomainProperties: JObject (required)
  ##                         : Custom domain to be validated.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_574344: Call_FrontDoorsValidateCustomDomain_574336; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Validates the custom domain mapping to ensure it maps to the correct Front Door endpoint in DNS.
  ## 
  let valid = call_574344.validator(path, query, header, formData, body)
  let scheme = call_574344.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574344.url(scheme.get, call_574344.host, call_574344.base,
                         call_574344.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574344, url, valid)

proc call*(call_574345: Call_FrontDoorsValidateCustomDomain_574336;
          resourceGroupName: string; apiVersion: string;
          customDomainProperties: JsonNode; subscriptionId: string;
          frontDoorName: string): Recallable =
  ## frontDoorsValidateCustomDomain
  ## Validates the custom domain mapping to ensure it maps to the correct Front Door endpoint in DNS.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   customDomainProperties: JObject (required)
  ##                         : Custom domain to be validated.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   frontDoorName: string (required)
  ##                : Name of the Front Door which is globally unique.
  var path_574346 = newJObject()
  var query_574347 = newJObject()
  var body_574348 = newJObject()
  add(path_574346, "resourceGroupName", newJString(resourceGroupName))
  add(query_574347, "api-version", newJString(apiVersion))
  if customDomainProperties != nil:
    body_574348 = customDomainProperties
  add(path_574346, "subscriptionId", newJString(subscriptionId))
  add(path_574346, "frontDoorName", newJString(frontDoorName))
  result = call_574345.call(path_574346, query_574347, nil, nil, body_574348)

var frontDoorsValidateCustomDomain* = Call_FrontDoorsValidateCustomDomain_574336(
    name: "frontDoorsValidateCustomDomain", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/frontDoors/{frontDoorName}/validateCustomDomain",
    validator: validate_FrontDoorsValidateCustomDomain_574337, base: "",
    url: url_FrontDoorsValidateCustomDomain_574338, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
