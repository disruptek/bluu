
import
  json, options, hashes, uri, rest, os, uri, httpcore

## auto-generated via openapi macro
## title: FrontDoorManagementClient
## version: 2018-08-01
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

  OpenApiRestCall_563556 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_563556](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_563556): Option[Scheme] {.used.} =
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
  macServiceName = "frontdoor"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_CheckFrontDoorNameAvailability_563778 = ref object of OpenApiRestCall_563556
proc url_CheckFrontDoorNameAvailability_563780(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_CheckFrontDoorNameAvailability_563779(path: JsonNode;
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
  var valid_563941 = query.getOrDefault("api-version")
  valid_563941 = validateParameter(valid_563941, JString, required = true,
                                 default = nil)
  if valid_563941 != nil:
    section.add "api-version", valid_563941
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

proc call*(call_563965: Call_CheckFrontDoorNameAvailability_563778; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Check the availability of a Front Door resource name.
  ## 
  let valid = call_563965.validator(path, query, header, formData, body)
  let scheme = call_563965.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_563965.url(scheme.get, call_563965.host, call_563965.base,
                         call_563965.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_563965, url, valid)

proc call*(call_564036: Call_CheckFrontDoorNameAvailability_563778;
          apiVersion: string; checkFrontDoorNameAvailabilityInput: JsonNode): Recallable =
  ## checkFrontDoorNameAvailability
  ## Check the availability of a Front Door resource name.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   checkFrontDoorNameAvailabilityInput: JObject (required)
  ##                                      : Input to check.
  var query_564037 = newJObject()
  var body_564039 = newJObject()
  add(query_564037, "api-version", newJString(apiVersion))
  if checkFrontDoorNameAvailabilityInput != nil:
    body_564039 = checkFrontDoorNameAvailabilityInput
  result = call_564036.call(nil, query_564037, nil, nil, body_564039)

var checkFrontDoorNameAvailability* = Call_CheckFrontDoorNameAvailability_563778(
    name: "checkFrontDoorNameAvailability", meth: HttpMethod.HttpPost,
    host: "management.azure.com",
    route: "/providers/Microsoft.Network/checkFrontDoorNameAvailability",
    validator: validate_CheckFrontDoorNameAvailability_563779, base: "",
    url: url_CheckFrontDoorNameAvailability_563780, schemes: {Scheme.Https})
type
  Call_CheckFrontDoorNameAvailabilityWithSubscription_564078 = ref object of OpenApiRestCall_563556
proc url_CheckFrontDoorNameAvailabilityWithSubscription_564080(protocol: Scheme;
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

proc validate_CheckFrontDoorNameAvailabilityWithSubscription_564079(
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
  var valid_564095 = path.getOrDefault("subscriptionId")
  valid_564095 = validateParameter(valid_564095, JString, required = true,
                                 default = nil)
  if valid_564095 != nil:
    section.add "subscriptionId", valid_564095
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564096 = query.getOrDefault("api-version")
  valid_564096 = validateParameter(valid_564096, JString, required = true,
                                 default = nil)
  if valid_564096 != nil:
    section.add "api-version", valid_564096
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

proc call*(call_564098: Call_CheckFrontDoorNameAvailabilityWithSubscription_564078;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Check the availability of a Front Door subdomain.
  ## 
  let valid = call_564098.validator(path, query, header, formData, body)
  let scheme = call_564098.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564098.url(scheme.get, call_564098.host, call_564098.base,
                         call_564098.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564098, url, valid)

proc call*(call_564099: Call_CheckFrontDoorNameAvailabilityWithSubscription_564078;
          apiVersion: string; checkFrontDoorNameAvailabilityInput: JsonNode;
          subscriptionId: string): Recallable =
  ## checkFrontDoorNameAvailabilityWithSubscription
  ## Check the availability of a Front Door subdomain.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   checkFrontDoorNameAvailabilityInput: JObject (required)
  ##                                      : Input to check.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_564100 = newJObject()
  var query_564101 = newJObject()
  var body_564102 = newJObject()
  add(query_564101, "api-version", newJString(apiVersion))
  if checkFrontDoorNameAvailabilityInput != nil:
    body_564102 = checkFrontDoorNameAvailabilityInput
  add(path_564100, "subscriptionId", newJString(subscriptionId))
  result = call_564099.call(path_564100, query_564101, nil, nil, body_564102)

var checkFrontDoorNameAvailabilityWithSubscription* = Call_CheckFrontDoorNameAvailabilityWithSubscription_564078(
    name: "checkFrontDoorNameAvailabilityWithSubscription",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Network/checkFrontDoorNameAvailability",
    validator: validate_CheckFrontDoorNameAvailabilityWithSubscription_564079,
    base: "", url: url_CheckFrontDoorNameAvailabilityWithSubscription_564080,
    schemes: {Scheme.Https})
type
  Call_FrontDoorsList_564103 = ref object of OpenApiRestCall_563556
proc url_FrontDoorsList_564105(protocol: Scheme; host: string; base: string;
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

proc validate_FrontDoorsList_564104(path: JsonNode; query: JsonNode;
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
  var valid_564106 = path.getOrDefault("subscriptionId")
  valid_564106 = validateParameter(valid_564106, JString, required = true,
                                 default = nil)
  if valid_564106 != nil:
    section.add "subscriptionId", valid_564106
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564107 = query.getOrDefault("api-version")
  valid_564107 = validateParameter(valid_564107, JString, required = true,
                                 default = nil)
  if valid_564107 != nil:
    section.add "api-version", valid_564107
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564108: Call_FrontDoorsList_564103; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the Front Doors within an Azure subscription.
  ## 
  let valid = call_564108.validator(path, query, header, formData, body)
  let scheme = call_564108.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564108.url(scheme.get, call_564108.host, call_564108.base,
                         call_564108.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564108, url, valid)

proc call*(call_564109: Call_FrontDoorsList_564103; apiVersion: string;
          subscriptionId: string): Recallable =
  ## frontDoorsList
  ## Lists all of the Front Doors within an Azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_564110 = newJObject()
  var query_564111 = newJObject()
  add(query_564111, "api-version", newJString(apiVersion))
  add(path_564110, "subscriptionId", newJString(subscriptionId))
  result = call_564109.call(path_564110, query_564111, nil, nil, nil)

var frontDoorsList* = Call_FrontDoorsList_564103(name: "frontDoorsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Network/frontDoors",
    validator: validate_FrontDoorsList_564104, base: "", url: url_FrontDoorsList_564105,
    schemes: {Scheme.Https})
type
  Call_FrontDoorsListByResourceGroup_564112 = ref object of OpenApiRestCall_563556
proc url_FrontDoorsListByResourceGroup_564114(protocol: Scheme; host: string;
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

proc validate_FrontDoorsListByResourceGroup_564113(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all of the Front Doors within a resource group under a subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564115 = path.getOrDefault("subscriptionId")
  valid_564115 = validateParameter(valid_564115, JString, required = true,
                                 default = nil)
  if valid_564115 != nil:
    section.add "subscriptionId", valid_564115
  var valid_564116 = path.getOrDefault("resourceGroupName")
  valid_564116 = validateParameter(valid_564116, JString, required = true,
                                 default = nil)
  if valid_564116 != nil:
    section.add "resourceGroupName", valid_564116
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564117 = query.getOrDefault("api-version")
  valid_564117 = validateParameter(valid_564117, JString, required = true,
                                 default = nil)
  if valid_564117 != nil:
    section.add "api-version", valid_564117
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564118: Call_FrontDoorsListByResourceGroup_564112; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the Front Doors within a resource group under a subscription.
  ## 
  let valid = call_564118.validator(path, query, header, formData, body)
  let scheme = call_564118.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564118.url(scheme.get, call_564118.host, call_564118.base,
                         call_564118.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564118, url, valid)

proc call*(call_564119: Call_FrontDoorsListByResourceGroup_564112;
          apiVersion: string; subscriptionId: string; resourceGroupName: string): Recallable =
  ## frontDoorsListByResourceGroup
  ## Lists all of the Front Doors within a resource group under a subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  var path_564120 = newJObject()
  var query_564121 = newJObject()
  add(query_564121, "api-version", newJString(apiVersion))
  add(path_564120, "subscriptionId", newJString(subscriptionId))
  add(path_564120, "resourceGroupName", newJString(resourceGroupName))
  result = call_564119.call(path_564120, query_564121, nil, nil, nil)

var frontDoorsListByResourceGroup* = Call_FrontDoorsListByResourceGroup_564112(
    name: "frontDoorsListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/frontDoors",
    validator: validate_FrontDoorsListByResourceGroup_564113, base: "",
    url: url_FrontDoorsListByResourceGroup_564114, schemes: {Scheme.Https})
type
  Call_FrontDoorsCreateOrUpdate_564133 = ref object of OpenApiRestCall_563556
proc url_FrontDoorsCreateOrUpdate_564135(protocol: Scheme; host: string;
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

proc validate_FrontDoorsCreateOrUpdate_564134(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a new Front Door with a Front Door name under the specified subscription and resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   frontDoorName: JString (required)
  ##                : Name of the Front Door which is globally unique.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `frontDoorName` field"
  var valid_564153 = path.getOrDefault("frontDoorName")
  valid_564153 = validateParameter(valid_564153, JString, required = true,
                                 default = nil)
  if valid_564153 != nil:
    section.add "frontDoorName", valid_564153
  var valid_564154 = path.getOrDefault("subscriptionId")
  valid_564154 = validateParameter(valid_564154, JString, required = true,
                                 default = nil)
  if valid_564154 != nil:
    section.add "subscriptionId", valid_564154
  var valid_564155 = path.getOrDefault("resourceGroupName")
  valid_564155 = validateParameter(valid_564155, JString, required = true,
                                 default = nil)
  if valid_564155 != nil:
    section.add "resourceGroupName", valid_564155
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564156 = query.getOrDefault("api-version")
  valid_564156 = validateParameter(valid_564156, JString, required = true,
                                 default = nil)
  if valid_564156 != nil:
    section.add "api-version", valid_564156
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

proc call*(call_564158: Call_FrontDoorsCreateOrUpdate_564133; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new Front Door with a Front Door name under the specified subscription and resource group.
  ## 
  let valid = call_564158.validator(path, query, header, formData, body)
  let scheme = call_564158.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564158.url(scheme.get, call_564158.host, call_564158.base,
                         call_564158.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564158, url, valid)

proc call*(call_564159: Call_FrontDoorsCreateOrUpdate_564133; apiVersion: string;
          frontDoorName: string; subscriptionId: string; resourceGroupName: string;
          frontDoorParameters: JsonNode): Recallable =
  ## frontDoorsCreateOrUpdate
  ## Creates a new Front Door with a Front Door name under the specified subscription and resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   frontDoorName: string (required)
  ##                : Name of the Front Door which is globally unique.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   frontDoorParameters: JObject (required)
  ##                      : Front Door properties needed to create a new Front Door.
  var path_564160 = newJObject()
  var query_564161 = newJObject()
  var body_564162 = newJObject()
  add(query_564161, "api-version", newJString(apiVersion))
  add(path_564160, "frontDoorName", newJString(frontDoorName))
  add(path_564160, "subscriptionId", newJString(subscriptionId))
  add(path_564160, "resourceGroupName", newJString(resourceGroupName))
  if frontDoorParameters != nil:
    body_564162 = frontDoorParameters
  result = call_564159.call(path_564160, query_564161, nil, nil, body_564162)

var frontDoorsCreateOrUpdate* = Call_FrontDoorsCreateOrUpdate_564133(
    name: "frontDoorsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/frontDoors/{frontDoorName}",
    validator: validate_FrontDoorsCreateOrUpdate_564134, base: "",
    url: url_FrontDoorsCreateOrUpdate_564135, schemes: {Scheme.Https})
type
  Call_FrontDoorsGet_564122 = ref object of OpenApiRestCall_563556
proc url_FrontDoorsGet_564124(protocol: Scheme; host: string; base: string;
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

proc validate_FrontDoorsGet_564123(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a Front Door with the specified Front Door name under the specified subscription and resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   frontDoorName: JString (required)
  ##                : Name of the Front Door which is globally unique.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `frontDoorName` field"
  var valid_564125 = path.getOrDefault("frontDoorName")
  valid_564125 = validateParameter(valid_564125, JString, required = true,
                                 default = nil)
  if valid_564125 != nil:
    section.add "frontDoorName", valid_564125
  var valid_564126 = path.getOrDefault("subscriptionId")
  valid_564126 = validateParameter(valid_564126, JString, required = true,
                                 default = nil)
  if valid_564126 != nil:
    section.add "subscriptionId", valid_564126
  var valid_564127 = path.getOrDefault("resourceGroupName")
  valid_564127 = validateParameter(valid_564127, JString, required = true,
                                 default = nil)
  if valid_564127 != nil:
    section.add "resourceGroupName", valid_564127
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564128 = query.getOrDefault("api-version")
  valid_564128 = validateParameter(valid_564128, JString, required = true,
                                 default = nil)
  if valid_564128 != nil:
    section.add "api-version", valid_564128
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564129: Call_FrontDoorsGet_564122; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a Front Door with the specified Front Door name under the specified subscription and resource group.
  ## 
  let valid = call_564129.validator(path, query, header, formData, body)
  let scheme = call_564129.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564129.url(scheme.get, call_564129.host, call_564129.base,
                         call_564129.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564129, url, valid)

proc call*(call_564130: Call_FrontDoorsGet_564122; apiVersion: string;
          frontDoorName: string; subscriptionId: string; resourceGroupName: string): Recallable =
  ## frontDoorsGet
  ## Gets a Front Door with the specified Front Door name under the specified subscription and resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   frontDoorName: string (required)
  ##                : Name of the Front Door which is globally unique.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  var path_564131 = newJObject()
  var query_564132 = newJObject()
  add(query_564132, "api-version", newJString(apiVersion))
  add(path_564131, "frontDoorName", newJString(frontDoorName))
  add(path_564131, "subscriptionId", newJString(subscriptionId))
  add(path_564131, "resourceGroupName", newJString(resourceGroupName))
  result = call_564130.call(path_564131, query_564132, nil, nil, nil)

var frontDoorsGet* = Call_FrontDoorsGet_564122(name: "frontDoorsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/frontDoors/{frontDoorName}",
    validator: validate_FrontDoorsGet_564123, base: "", url: url_FrontDoorsGet_564124,
    schemes: {Scheme.Https})
type
  Call_FrontDoorsDelete_564163 = ref object of OpenApiRestCall_563556
proc url_FrontDoorsDelete_564165(protocol: Scheme; host: string; base: string;
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

proc validate_FrontDoorsDelete_564164(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Deletes an existing Front Door with the specified parameters.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   frontDoorName: JString (required)
  ##                : Name of the Front Door which is globally unique.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `frontDoorName` field"
  var valid_564166 = path.getOrDefault("frontDoorName")
  valid_564166 = validateParameter(valid_564166, JString, required = true,
                                 default = nil)
  if valid_564166 != nil:
    section.add "frontDoorName", valid_564166
  var valid_564167 = path.getOrDefault("subscriptionId")
  valid_564167 = validateParameter(valid_564167, JString, required = true,
                                 default = nil)
  if valid_564167 != nil:
    section.add "subscriptionId", valid_564167
  var valid_564168 = path.getOrDefault("resourceGroupName")
  valid_564168 = validateParameter(valid_564168, JString, required = true,
                                 default = nil)
  if valid_564168 != nil:
    section.add "resourceGroupName", valid_564168
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564169 = query.getOrDefault("api-version")
  valid_564169 = validateParameter(valid_564169, JString, required = true,
                                 default = nil)
  if valid_564169 != nil:
    section.add "api-version", valid_564169
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564170: Call_FrontDoorsDelete_564163; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an existing Front Door with the specified parameters.
  ## 
  let valid = call_564170.validator(path, query, header, formData, body)
  let scheme = call_564170.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564170.url(scheme.get, call_564170.host, call_564170.base,
                         call_564170.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564170, url, valid)

proc call*(call_564171: Call_FrontDoorsDelete_564163; apiVersion: string;
          frontDoorName: string; subscriptionId: string; resourceGroupName: string): Recallable =
  ## frontDoorsDelete
  ## Deletes an existing Front Door with the specified parameters.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   frontDoorName: string (required)
  ##                : Name of the Front Door which is globally unique.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  var path_564172 = newJObject()
  var query_564173 = newJObject()
  add(query_564173, "api-version", newJString(apiVersion))
  add(path_564172, "frontDoorName", newJString(frontDoorName))
  add(path_564172, "subscriptionId", newJString(subscriptionId))
  add(path_564172, "resourceGroupName", newJString(resourceGroupName))
  result = call_564171.call(path_564172, query_564173, nil, nil, nil)

var frontDoorsDelete* = Call_FrontDoorsDelete_564163(name: "frontDoorsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/frontDoors/{frontDoorName}",
    validator: validate_FrontDoorsDelete_564164, base: "",
    url: url_FrontDoorsDelete_564165, schemes: {Scheme.Https})
type
  Call_FrontendEndpointsListByFrontDoor_564174 = ref object of OpenApiRestCall_563556
proc url_FrontendEndpointsListByFrontDoor_564176(protocol: Scheme; host: string;
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

proc validate_FrontendEndpointsListByFrontDoor_564175(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all of the frontend endpoints within a Front Door.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   frontDoorName: JString (required)
  ##                : Name of the Front Door which is globally unique.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `frontDoorName` field"
  var valid_564177 = path.getOrDefault("frontDoorName")
  valid_564177 = validateParameter(valid_564177, JString, required = true,
                                 default = nil)
  if valid_564177 != nil:
    section.add "frontDoorName", valid_564177
  var valid_564178 = path.getOrDefault("subscriptionId")
  valid_564178 = validateParameter(valid_564178, JString, required = true,
                                 default = nil)
  if valid_564178 != nil:
    section.add "subscriptionId", valid_564178
  var valid_564179 = path.getOrDefault("resourceGroupName")
  valid_564179 = validateParameter(valid_564179, JString, required = true,
                                 default = nil)
  if valid_564179 != nil:
    section.add "resourceGroupName", valid_564179
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564180 = query.getOrDefault("api-version")
  valid_564180 = validateParameter(valid_564180, JString, required = true,
                                 default = nil)
  if valid_564180 != nil:
    section.add "api-version", valid_564180
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564181: Call_FrontendEndpointsListByFrontDoor_564174;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all of the frontend endpoints within a Front Door.
  ## 
  let valid = call_564181.validator(path, query, header, formData, body)
  let scheme = call_564181.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564181.url(scheme.get, call_564181.host, call_564181.base,
                         call_564181.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564181, url, valid)

proc call*(call_564182: Call_FrontendEndpointsListByFrontDoor_564174;
          apiVersion: string; frontDoorName: string; subscriptionId: string;
          resourceGroupName: string): Recallable =
  ## frontendEndpointsListByFrontDoor
  ## Lists all of the frontend endpoints within a Front Door.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   frontDoorName: string (required)
  ##                : Name of the Front Door which is globally unique.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  var path_564183 = newJObject()
  var query_564184 = newJObject()
  add(query_564184, "api-version", newJString(apiVersion))
  add(path_564183, "frontDoorName", newJString(frontDoorName))
  add(path_564183, "subscriptionId", newJString(subscriptionId))
  add(path_564183, "resourceGroupName", newJString(resourceGroupName))
  result = call_564182.call(path_564183, query_564184, nil, nil, nil)

var frontendEndpointsListByFrontDoor* = Call_FrontendEndpointsListByFrontDoor_564174(
    name: "frontendEndpointsListByFrontDoor", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/frontDoors/{frontDoorName}/frontendEndpoints",
    validator: validate_FrontendEndpointsListByFrontDoor_564175, base: "",
    url: url_FrontendEndpointsListByFrontDoor_564176, schemes: {Scheme.Https})
type
  Call_FrontendEndpointsGet_564185 = ref object of OpenApiRestCall_563556
proc url_FrontendEndpointsGet_564187(protocol: Scheme; host: string; base: string;
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

proc validate_FrontendEndpointsGet_564186(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a Frontend endpoint with the specified name within the specified Front Door.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   frontendEndpointName: JString (required)
  ##                       : Name of the Frontend endpoint which is unique within the Front Door.
  ##   frontDoorName: JString (required)
  ##                : Name of the Front Door which is globally unique.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `frontendEndpointName` field"
  var valid_564188 = path.getOrDefault("frontendEndpointName")
  valid_564188 = validateParameter(valid_564188, JString, required = true,
                                 default = nil)
  if valid_564188 != nil:
    section.add "frontendEndpointName", valid_564188
  var valid_564189 = path.getOrDefault("frontDoorName")
  valid_564189 = validateParameter(valid_564189, JString, required = true,
                                 default = nil)
  if valid_564189 != nil:
    section.add "frontDoorName", valid_564189
  var valid_564190 = path.getOrDefault("subscriptionId")
  valid_564190 = validateParameter(valid_564190, JString, required = true,
                                 default = nil)
  if valid_564190 != nil:
    section.add "subscriptionId", valid_564190
  var valid_564191 = path.getOrDefault("resourceGroupName")
  valid_564191 = validateParameter(valid_564191, JString, required = true,
                                 default = nil)
  if valid_564191 != nil:
    section.add "resourceGroupName", valid_564191
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564192 = query.getOrDefault("api-version")
  valid_564192 = validateParameter(valid_564192, JString, required = true,
                                 default = nil)
  if valid_564192 != nil:
    section.add "api-version", valid_564192
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564193: Call_FrontendEndpointsGet_564185; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a Frontend endpoint with the specified name within the specified Front Door.
  ## 
  let valid = call_564193.validator(path, query, header, formData, body)
  let scheme = call_564193.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564193.url(scheme.get, call_564193.host, call_564193.base,
                         call_564193.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564193, url, valid)

proc call*(call_564194: Call_FrontendEndpointsGet_564185;
          frontendEndpointName: string; apiVersion: string; frontDoorName: string;
          subscriptionId: string; resourceGroupName: string): Recallable =
  ## frontendEndpointsGet
  ## Gets a Frontend endpoint with the specified name within the specified Front Door.
  ##   frontendEndpointName: string (required)
  ##                       : Name of the Frontend endpoint which is unique within the Front Door.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   frontDoorName: string (required)
  ##                : Name of the Front Door which is globally unique.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  var path_564195 = newJObject()
  var query_564196 = newJObject()
  add(path_564195, "frontendEndpointName", newJString(frontendEndpointName))
  add(query_564196, "api-version", newJString(apiVersion))
  add(path_564195, "frontDoorName", newJString(frontDoorName))
  add(path_564195, "subscriptionId", newJString(subscriptionId))
  add(path_564195, "resourceGroupName", newJString(resourceGroupName))
  result = call_564194.call(path_564195, query_564196, nil, nil, nil)

var frontendEndpointsGet* = Call_FrontendEndpointsGet_564185(
    name: "frontendEndpointsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/frontDoors/{frontDoorName}/frontendEndpoints/{frontendEndpointName}",
    validator: validate_FrontendEndpointsGet_564186, base: "",
    url: url_FrontendEndpointsGet_564187, schemes: {Scheme.Https})
type
  Call_FrontendEndpointsDisableHttps_564197 = ref object of OpenApiRestCall_563556
proc url_FrontendEndpointsDisableHttps_564199(protocol: Scheme; host: string;
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

proc validate_FrontendEndpointsDisableHttps_564198(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Disables a frontendEndpoint for HTTPS traffic
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   frontendEndpointName: JString (required)
  ##                       : Name of the Frontend endpoint which is unique within the Front Door.
  ##   frontDoorName: JString (required)
  ##                : Name of the Front Door which is globally unique.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `frontendEndpointName` field"
  var valid_564200 = path.getOrDefault("frontendEndpointName")
  valid_564200 = validateParameter(valid_564200, JString, required = true,
                                 default = nil)
  if valid_564200 != nil:
    section.add "frontendEndpointName", valid_564200
  var valid_564201 = path.getOrDefault("frontDoorName")
  valid_564201 = validateParameter(valid_564201, JString, required = true,
                                 default = nil)
  if valid_564201 != nil:
    section.add "frontDoorName", valid_564201
  var valid_564202 = path.getOrDefault("subscriptionId")
  valid_564202 = validateParameter(valid_564202, JString, required = true,
                                 default = nil)
  if valid_564202 != nil:
    section.add "subscriptionId", valid_564202
  var valid_564203 = path.getOrDefault("resourceGroupName")
  valid_564203 = validateParameter(valid_564203, JString, required = true,
                                 default = nil)
  if valid_564203 != nil:
    section.add "resourceGroupName", valid_564203
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564204 = query.getOrDefault("api-version")
  valid_564204 = validateParameter(valid_564204, JString, required = true,
                                 default = nil)
  if valid_564204 != nil:
    section.add "api-version", valid_564204
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564205: Call_FrontendEndpointsDisableHttps_564197; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Disables a frontendEndpoint for HTTPS traffic
  ## 
  let valid = call_564205.validator(path, query, header, formData, body)
  let scheme = call_564205.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564205.url(scheme.get, call_564205.host, call_564205.base,
                         call_564205.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564205, url, valid)

proc call*(call_564206: Call_FrontendEndpointsDisableHttps_564197;
          frontendEndpointName: string; apiVersion: string; frontDoorName: string;
          subscriptionId: string; resourceGroupName: string): Recallable =
  ## frontendEndpointsDisableHttps
  ## Disables a frontendEndpoint for HTTPS traffic
  ##   frontendEndpointName: string (required)
  ##                       : Name of the Frontend endpoint which is unique within the Front Door.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   frontDoorName: string (required)
  ##                : Name of the Front Door which is globally unique.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  var path_564207 = newJObject()
  var query_564208 = newJObject()
  add(path_564207, "frontendEndpointName", newJString(frontendEndpointName))
  add(query_564208, "api-version", newJString(apiVersion))
  add(path_564207, "frontDoorName", newJString(frontDoorName))
  add(path_564207, "subscriptionId", newJString(subscriptionId))
  add(path_564207, "resourceGroupName", newJString(resourceGroupName))
  result = call_564206.call(path_564207, query_564208, nil, nil, nil)

var frontendEndpointsDisableHttps* = Call_FrontendEndpointsDisableHttps_564197(
    name: "frontendEndpointsDisableHttps", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/frontDoors/{frontDoorName}/frontendEndpoints/{frontendEndpointName}/disableHttps",
    validator: validate_FrontendEndpointsDisableHttps_564198, base: "",
    url: url_FrontendEndpointsDisableHttps_564199, schemes: {Scheme.Https})
type
  Call_FrontendEndpointsEnableHttps_564209 = ref object of OpenApiRestCall_563556
proc url_FrontendEndpointsEnableHttps_564211(protocol: Scheme; host: string;
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

proc validate_FrontendEndpointsEnableHttps_564210(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Enables a frontendEndpoint for HTTPS traffic
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   frontendEndpointName: JString (required)
  ##                       : Name of the Frontend endpoint which is unique within the Front Door.
  ##   frontDoorName: JString (required)
  ##                : Name of the Front Door which is globally unique.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `frontendEndpointName` field"
  var valid_564212 = path.getOrDefault("frontendEndpointName")
  valid_564212 = validateParameter(valid_564212, JString, required = true,
                                 default = nil)
  if valid_564212 != nil:
    section.add "frontendEndpointName", valid_564212
  var valid_564213 = path.getOrDefault("frontDoorName")
  valid_564213 = validateParameter(valid_564213, JString, required = true,
                                 default = nil)
  if valid_564213 != nil:
    section.add "frontDoorName", valid_564213
  var valid_564214 = path.getOrDefault("subscriptionId")
  valid_564214 = validateParameter(valid_564214, JString, required = true,
                                 default = nil)
  if valid_564214 != nil:
    section.add "subscriptionId", valid_564214
  var valid_564215 = path.getOrDefault("resourceGroupName")
  valid_564215 = validateParameter(valid_564215, JString, required = true,
                                 default = nil)
  if valid_564215 != nil:
    section.add "resourceGroupName", valid_564215
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564216 = query.getOrDefault("api-version")
  valid_564216 = validateParameter(valid_564216, JString, required = true,
                                 default = nil)
  if valid_564216 != nil:
    section.add "api-version", valid_564216
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

proc call*(call_564218: Call_FrontendEndpointsEnableHttps_564209; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Enables a frontendEndpoint for HTTPS traffic
  ## 
  let valid = call_564218.validator(path, query, header, formData, body)
  let scheme = call_564218.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564218.url(scheme.get, call_564218.host, call_564218.base,
                         call_564218.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564218, url, valid)

proc call*(call_564219: Call_FrontendEndpointsEnableHttps_564209;
          frontendEndpointName: string; apiVersion: string;
          customHttpsConfiguration: JsonNode; frontDoorName: string;
          subscriptionId: string; resourceGroupName: string): Recallable =
  ## frontendEndpointsEnableHttps
  ## Enables a frontendEndpoint for HTTPS traffic
  ##   frontendEndpointName: string (required)
  ##                       : Name of the Frontend endpoint which is unique within the Front Door.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   customHttpsConfiguration: JObject (required)
  ##                           : The configuration specifying how to enable HTTPS
  ##   frontDoorName: string (required)
  ##                : Name of the Front Door which is globally unique.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  var path_564220 = newJObject()
  var query_564221 = newJObject()
  var body_564222 = newJObject()
  add(path_564220, "frontendEndpointName", newJString(frontendEndpointName))
  add(query_564221, "api-version", newJString(apiVersion))
  if customHttpsConfiguration != nil:
    body_564222 = customHttpsConfiguration
  add(path_564220, "frontDoorName", newJString(frontDoorName))
  add(path_564220, "subscriptionId", newJString(subscriptionId))
  add(path_564220, "resourceGroupName", newJString(resourceGroupName))
  result = call_564219.call(path_564220, query_564221, nil, nil, body_564222)

var frontendEndpointsEnableHttps* = Call_FrontendEndpointsEnableHttps_564209(
    name: "frontendEndpointsEnableHttps", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/frontDoors/{frontDoorName}/frontendEndpoints/{frontendEndpointName}/enableHttps",
    validator: validate_FrontendEndpointsEnableHttps_564210, base: "",
    url: url_FrontendEndpointsEnableHttps_564211, schemes: {Scheme.Https})
type
  Call_EndpointsPurgeContent_564223 = ref object of OpenApiRestCall_563556
proc url_EndpointsPurgeContent_564225(protocol: Scheme; host: string; base: string;
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

proc validate_EndpointsPurgeContent_564224(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Removes a content from Front Door.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   frontDoorName: JString (required)
  ##                : Name of the Front Door which is globally unique.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `frontDoorName` field"
  var valid_564226 = path.getOrDefault("frontDoorName")
  valid_564226 = validateParameter(valid_564226, JString, required = true,
                                 default = nil)
  if valid_564226 != nil:
    section.add "frontDoorName", valid_564226
  var valid_564227 = path.getOrDefault("subscriptionId")
  valid_564227 = validateParameter(valid_564227, JString, required = true,
                                 default = nil)
  if valid_564227 != nil:
    section.add "subscriptionId", valid_564227
  var valid_564228 = path.getOrDefault("resourceGroupName")
  valid_564228 = validateParameter(valid_564228, JString, required = true,
                                 default = nil)
  if valid_564228 != nil:
    section.add "resourceGroupName", valid_564228
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564229 = query.getOrDefault("api-version")
  valid_564229 = validateParameter(valid_564229, JString, required = true,
                                 default = nil)
  if valid_564229 != nil:
    section.add "api-version", valid_564229
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

proc call*(call_564231: Call_EndpointsPurgeContent_564223; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Removes a content from Front Door.
  ## 
  let valid = call_564231.validator(path, query, header, formData, body)
  let scheme = call_564231.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564231.url(scheme.get, call_564231.host, call_564231.base,
                         call_564231.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564231, url, valid)

proc call*(call_564232: Call_EndpointsPurgeContent_564223;
          contentFilePaths: JsonNode; apiVersion: string; frontDoorName: string;
          subscriptionId: string; resourceGroupName: string): Recallable =
  ## endpointsPurgeContent
  ## Removes a content from Front Door.
  ##   contentFilePaths: JObject (required)
  ##                   : The path to the content to be purged. Path can be a full URL, e.g. '/pictures/city.png' which removes a single file, or a directory with a wildcard, e.g. '/pictures/*' which removes all folders and files in the directory.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   frontDoorName: string (required)
  ##                : Name of the Front Door which is globally unique.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  var path_564233 = newJObject()
  var query_564234 = newJObject()
  var body_564235 = newJObject()
  if contentFilePaths != nil:
    body_564235 = contentFilePaths
  add(query_564234, "api-version", newJString(apiVersion))
  add(path_564233, "frontDoorName", newJString(frontDoorName))
  add(path_564233, "subscriptionId", newJString(subscriptionId))
  add(path_564233, "resourceGroupName", newJString(resourceGroupName))
  result = call_564232.call(path_564233, query_564234, nil, nil, body_564235)

var endpointsPurgeContent* = Call_EndpointsPurgeContent_564223(
    name: "endpointsPurgeContent", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/frontDoors/{frontDoorName}/purge",
    validator: validate_EndpointsPurgeContent_564224, base: "",
    url: url_EndpointsPurgeContent_564225, schemes: {Scheme.Https})
type
  Call_FrontDoorsValidateCustomDomain_564236 = ref object of OpenApiRestCall_563556
proc url_FrontDoorsValidateCustomDomain_564238(protocol: Scheme; host: string;
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

proc validate_FrontDoorsValidateCustomDomain_564237(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Validates the custom domain mapping to ensure it maps to the correct Front Door endpoint in DNS.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   frontDoorName: JString (required)
  ##                : Name of the Front Door which is globally unique.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `frontDoorName` field"
  var valid_564239 = path.getOrDefault("frontDoorName")
  valid_564239 = validateParameter(valid_564239, JString, required = true,
                                 default = nil)
  if valid_564239 != nil:
    section.add "frontDoorName", valid_564239
  var valid_564240 = path.getOrDefault("subscriptionId")
  valid_564240 = validateParameter(valid_564240, JString, required = true,
                                 default = nil)
  if valid_564240 != nil:
    section.add "subscriptionId", valid_564240
  var valid_564241 = path.getOrDefault("resourceGroupName")
  valid_564241 = validateParameter(valid_564241, JString, required = true,
                                 default = nil)
  if valid_564241 != nil:
    section.add "resourceGroupName", valid_564241
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564242 = query.getOrDefault("api-version")
  valid_564242 = validateParameter(valid_564242, JString, required = true,
                                 default = nil)
  if valid_564242 != nil:
    section.add "api-version", valid_564242
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

proc call*(call_564244: Call_FrontDoorsValidateCustomDomain_564236; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Validates the custom domain mapping to ensure it maps to the correct Front Door endpoint in DNS.
  ## 
  let valid = call_564244.validator(path, query, header, formData, body)
  let scheme = call_564244.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564244.url(scheme.get, call_564244.host, call_564244.base,
                         call_564244.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564244, url, valid)

proc call*(call_564245: Call_FrontDoorsValidateCustomDomain_564236;
          apiVersion: string; frontDoorName: string;
          customDomainProperties: JsonNode; subscriptionId: string;
          resourceGroupName: string): Recallable =
  ## frontDoorsValidateCustomDomain
  ## Validates the custom domain mapping to ensure it maps to the correct Front Door endpoint in DNS.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   frontDoorName: string (required)
  ##                : Name of the Front Door which is globally unique.
  ##   customDomainProperties: JObject (required)
  ##                         : Custom domain to be validated.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  var path_564246 = newJObject()
  var query_564247 = newJObject()
  var body_564248 = newJObject()
  add(query_564247, "api-version", newJString(apiVersion))
  add(path_564246, "frontDoorName", newJString(frontDoorName))
  if customDomainProperties != nil:
    body_564248 = customDomainProperties
  add(path_564246, "subscriptionId", newJString(subscriptionId))
  add(path_564246, "resourceGroupName", newJString(resourceGroupName))
  result = call_564245.call(path_564246, query_564247, nil, nil, body_564248)

var frontDoorsValidateCustomDomain* = Call_FrontDoorsValidateCustomDomain_564236(
    name: "frontDoorsValidateCustomDomain", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/frontDoors/{frontDoorName}/validateCustomDomain",
    validator: validate_FrontDoorsValidateCustomDomain_564237, base: "",
    url: url_FrontDoorsValidateCustomDomain_564238, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
