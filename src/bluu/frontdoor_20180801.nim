
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

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

  OpenApiRestCall_593425 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_593425](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_593425): Option[Scheme] {.used.} =
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
  macServiceName = "frontdoor"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_CheckFrontDoorNameAvailability_593647 = ref object of OpenApiRestCall_593425
proc url_CheckFrontDoorNameAvailability_593649(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_CheckFrontDoorNameAvailability_593648(path: JsonNode;
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
  var valid_593808 = query.getOrDefault("api-version")
  valid_593808 = validateParameter(valid_593808, JString, required = true,
                                 default = nil)
  if valid_593808 != nil:
    section.add "api-version", valid_593808
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

proc call*(call_593832: Call_CheckFrontDoorNameAvailability_593647; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Check the availability of a Front Door resource name.
  ## 
  let valid = call_593832.validator(path, query, header, formData, body)
  let scheme = call_593832.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593832.url(scheme.get, call_593832.host, call_593832.base,
                         call_593832.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593832, url, valid)

proc call*(call_593903: Call_CheckFrontDoorNameAvailability_593647;
          apiVersion: string; checkFrontDoorNameAvailabilityInput: JsonNode): Recallable =
  ## checkFrontDoorNameAvailability
  ## Check the availability of a Front Door resource name.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   checkFrontDoorNameAvailabilityInput: JObject (required)
  ##                                      : Input to check.
  var query_593904 = newJObject()
  var body_593906 = newJObject()
  add(query_593904, "api-version", newJString(apiVersion))
  if checkFrontDoorNameAvailabilityInput != nil:
    body_593906 = checkFrontDoorNameAvailabilityInput
  result = call_593903.call(nil, query_593904, nil, nil, body_593906)

var checkFrontDoorNameAvailability* = Call_CheckFrontDoorNameAvailability_593647(
    name: "checkFrontDoorNameAvailability", meth: HttpMethod.HttpPost,
    host: "management.azure.com",
    route: "/providers/Microsoft.Network/checkFrontDoorNameAvailability",
    validator: validate_CheckFrontDoorNameAvailability_593648, base: "",
    url: url_CheckFrontDoorNameAvailability_593649, schemes: {Scheme.Https})
type
  Call_CheckFrontDoorNameAvailabilityWithSubscription_593945 = ref object of OpenApiRestCall_593425
proc url_CheckFrontDoorNameAvailabilityWithSubscription_593947(protocol: Scheme;
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

proc validate_CheckFrontDoorNameAvailabilityWithSubscription_593946(
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
  var valid_593962 = path.getOrDefault("subscriptionId")
  valid_593962 = validateParameter(valid_593962, JString, required = true,
                                 default = nil)
  if valid_593962 != nil:
    section.add "subscriptionId", valid_593962
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593963 = query.getOrDefault("api-version")
  valid_593963 = validateParameter(valid_593963, JString, required = true,
                                 default = nil)
  if valid_593963 != nil:
    section.add "api-version", valid_593963
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

proc call*(call_593965: Call_CheckFrontDoorNameAvailabilityWithSubscription_593945;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Check the availability of a Front Door subdomain.
  ## 
  let valid = call_593965.validator(path, query, header, formData, body)
  let scheme = call_593965.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593965.url(scheme.get, call_593965.host, call_593965.base,
                         call_593965.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593965, url, valid)

proc call*(call_593966: Call_CheckFrontDoorNameAvailabilityWithSubscription_593945;
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
  var path_593967 = newJObject()
  var query_593968 = newJObject()
  var body_593969 = newJObject()
  add(query_593968, "api-version", newJString(apiVersion))
  add(path_593967, "subscriptionId", newJString(subscriptionId))
  if checkFrontDoorNameAvailabilityInput != nil:
    body_593969 = checkFrontDoorNameAvailabilityInput
  result = call_593966.call(path_593967, query_593968, nil, nil, body_593969)

var checkFrontDoorNameAvailabilityWithSubscription* = Call_CheckFrontDoorNameAvailabilityWithSubscription_593945(
    name: "checkFrontDoorNameAvailabilityWithSubscription",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Network/checkFrontDoorNameAvailability",
    validator: validate_CheckFrontDoorNameAvailabilityWithSubscription_593946,
    base: "", url: url_CheckFrontDoorNameAvailabilityWithSubscription_593947,
    schemes: {Scheme.Https})
type
  Call_FrontDoorsList_593970 = ref object of OpenApiRestCall_593425
proc url_FrontDoorsList_593972(protocol: Scheme; host: string; base: string;
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

proc validate_FrontDoorsList_593971(path: JsonNode; query: JsonNode;
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
  var valid_593973 = path.getOrDefault("subscriptionId")
  valid_593973 = validateParameter(valid_593973, JString, required = true,
                                 default = nil)
  if valid_593973 != nil:
    section.add "subscriptionId", valid_593973
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593974 = query.getOrDefault("api-version")
  valid_593974 = validateParameter(valid_593974, JString, required = true,
                                 default = nil)
  if valid_593974 != nil:
    section.add "api-version", valid_593974
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593975: Call_FrontDoorsList_593970; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the Front Doors within an Azure subscription.
  ## 
  let valid = call_593975.validator(path, query, header, formData, body)
  let scheme = call_593975.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593975.url(scheme.get, call_593975.host, call_593975.base,
                         call_593975.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593975, url, valid)

proc call*(call_593976: Call_FrontDoorsList_593970; apiVersion: string;
          subscriptionId: string): Recallable =
  ## frontDoorsList
  ## Lists all of the Front Doors within an Azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_593977 = newJObject()
  var query_593978 = newJObject()
  add(query_593978, "api-version", newJString(apiVersion))
  add(path_593977, "subscriptionId", newJString(subscriptionId))
  result = call_593976.call(path_593977, query_593978, nil, nil, nil)

var frontDoorsList* = Call_FrontDoorsList_593970(name: "frontDoorsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Network/frontDoors",
    validator: validate_FrontDoorsList_593971, base: "", url: url_FrontDoorsList_593972,
    schemes: {Scheme.Https})
type
  Call_FrontDoorsListByResourceGroup_593979 = ref object of OpenApiRestCall_593425
proc url_FrontDoorsListByResourceGroup_593981(protocol: Scheme; host: string;
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

proc validate_FrontDoorsListByResourceGroup_593980(path: JsonNode; query: JsonNode;
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
  var valid_593982 = path.getOrDefault("resourceGroupName")
  valid_593982 = validateParameter(valid_593982, JString, required = true,
                                 default = nil)
  if valid_593982 != nil:
    section.add "resourceGroupName", valid_593982
  var valid_593983 = path.getOrDefault("subscriptionId")
  valid_593983 = validateParameter(valid_593983, JString, required = true,
                                 default = nil)
  if valid_593983 != nil:
    section.add "subscriptionId", valid_593983
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593984 = query.getOrDefault("api-version")
  valid_593984 = validateParameter(valid_593984, JString, required = true,
                                 default = nil)
  if valid_593984 != nil:
    section.add "api-version", valid_593984
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593985: Call_FrontDoorsListByResourceGroup_593979; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the Front Doors within a resource group under a subscription.
  ## 
  let valid = call_593985.validator(path, query, header, formData, body)
  let scheme = call_593985.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593985.url(scheme.get, call_593985.host, call_593985.base,
                         call_593985.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593985, url, valid)

proc call*(call_593986: Call_FrontDoorsListByResourceGroup_593979;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## frontDoorsListByResourceGroup
  ## Lists all of the Front Doors within a resource group under a subscription.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_593987 = newJObject()
  var query_593988 = newJObject()
  add(path_593987, "resourceGroupName", newJString(resourceGroupName))
  add(query_593988, "api-version", newJString(apiVersion))
  add(path_593987, "subscriptionId", newJString(subscriptionId))
  result = call_593986.call(path_593987, query_593988, nil, nil, nil)

var frontDoorsListByResourceGroup* = Call_FrontDoorsListByResourceGroup_593979(
    name: "frontDoorsListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/frontDoors",
    validator: validate_FrontDoorsListByResourceGroup_593980, base: "",
    url: url_FrontDoorsListByResourceGroup_593981, schemes: {Scheme.Https})
type
  Call_FrontDoorsCreateOrUpdate_594000 = ref object of OpenApiRestCall_593425
proc url_FrontDoorsCreateOrUpdate_594002(protocol: Scheme; host: string;
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

proc validate_FrontDoorsCreateOrUpdate_594001(path: JsonNode; query: JsonNode;
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
  var valid_594020 = path.getOrDefault("resourceGroupName")
  valid_594020 = validateParameter(valid_594020, JString, required = true,
                                 default = nil)
  if valid_594020 != nil:
    section.add "resourceGroupName", valid_594020
  var valid_594021 = path.getOrDefault("subscriptionId")
  valid_594021 = validateParameter(valid_594021, JString, required = true,
                                 default = nil)
  if valid_594021 != nil:
    section.add "subscriptionId", valid_594021
  var valid_594022 = path.getOrDefault("frontDoorName")
  valid_594022 = validateParameter(valid_594022, JString, required = true,
                                 default = nil)
  if valid_594022 != nil:
    section.add "frontDoorName", valid_594022
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594023 = query.getOrDefault("api-version")
  valid_594023 = validateParameter(valid_594023, JString, required = true,
                                 default = nil)
  if valid_594023 != nil:
    section.add "api-version", valid_594023
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

proc call*(call_594025: Call_FrontDoorsCreateOrUpdate_594000; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new Front Door with a Front Door name under the specified subscription and resource group.
  ## 
  let valid = call_594025.validator(path, query, header, formData, body)
  let scheme = call_594025.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594025.url(scheme.get, call_594025.host, call_594025.base,
                         call_594025.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594025, url, valid)

proc call*(call_594026: Call_FrontDoorsCreateOrUpdate_594000;
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
  var path_594027 = newJObject()
  var query_594028 = newJObject()
  var body_594029 = newJObject()
  add(path_594027, "resourceGroupName", newJString(resourceGroupName))
  add(query_594028, "api-version", newJString(apiVersion))
  if frontDoorParameters != nil:
    body_594029 = frontDoorParameters
  add(path_594027, "subscriptionId", newJString(subscriptionId))
  add(path_594027, "frontDoorName", newJString(frontDoorName))
  result = call_594026.call(path_594027, query_594028, nil, nil, body_594029)

var frontDoorsCreateOrUpdate* = Call_FrontDoorsCreateOrUpdate_594000(
    name: "frontDoorsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/frontDoors/{frontDoorName}",
    validator: validate_FrontDoorsCreateOrUpdate_594001, base: "",
    url: url_FrontDoorsCreateOrUpdate_594002, schemes: {Scheme.Https})
type
  Call_FrontDoorsGet_593989 = ref object of OpenApiRestCall_593425
proc url_FrontDoorsGet_593991(protocol: Scheme; host: string; base: string;
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

proc validate_FrontDoorsGet_593990(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_593992 = path.getOrDefault("resourceGroupName")
  valid_593992 = validateParameter(valid_593992, JString, required = true,
                                 default = nil)
  if valid_593992 != nil:
    section.add "resourceGroupName", valid_593992
  var valid_593993 = path.getOrDefault("subscriptionId")
  valid_593993 = validateParameter(valid_593993, JString, required = true,
                                 default = nil)
  if valid_593993 != nil:
    section.add "subscriptionId", valid_593993
  var valid_593994 = path.getOrDefault("frontDoorName")
  valid_593994 = validateParameter(valid_593994, JString, required = true,
                                 default = nil)
  if valid_593994 != nil:
    section.add "frontDoorName", valid_593994
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593995 = query.getOrDefault("api-version")
  valid_593995 = validateParameter(valid_593995, JString, required = true,
                                 default = nil)
  if valid_593995 != nil:
    section.add "api-version", valid_593995
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593996: Call_FrontDoorsGet_593989; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a Front Door with the specified Front Door name under the specified subscription and resource group.
  ## 
  let valid = call_593996.validator(path, query, header, formData, body)
  let scheme = call_593996.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593996.url(scheme.get, call_593996.host, call_593996.base,
                         call_593996.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593996, url, valid)

proc call*(call_593997: Call_FrontDoorsGet_593989; resourceGroupName: string;
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
  var path_593998 = newJObject()
  var query_593999 = newJObject()
  add(path_593998, "resourceGroupName", newJString(resourceGroupName))
  add(query_593999, "api-version", newJString(apiVersion))
  add(path_593998, "subscriptionId", newJString(subscriptionId))
  add(path_593998, "frontDoorName", newJString(frontDoorName))
  result = call_593997.call(path_593998, query_593999, nil, nil, nil)

var frontDoorsGet* = Call_FrontDoorsGet_593989(name: "frontDoorsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/frontDoors/{frontDoorName}",
    validator: validate_FrontDoorsGet_593990, base: "", url: url_FrontDoorsGet_593991,
    schemes: {Scheme.Https})
type
  Call_FrontDoorsDelete_594030 = ref object of OpenApiRestCall_593425
proc url_FrontDoorsDelete_594032(protocol: Scheme; host: string; base: string;
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

proc validate_FrontDoorsDelete_594031(path: JsonNode; query: JsonNode;
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
  var valid_594033 = path.getOrDefault("resourceGroupName")
  valid_594033 = validateParameter(valid_594033, JString, required = true,
                                 default = nil)
  if valid_594033 != nil:
    section.add "resourceGroupName", valid_594033
  var valid_594034 = path.getOrDefault("subscriptionId")
  valid_594034 = validateParameter(valid_594034, JString, required = true,
                                 default = nil)
  if valid_594034 != nil:
    section.add "subscriptionId", valid_594034
  var valid_594035 = path.getOrDefault("frontDoorName")
  valid_594035 = validateParameter(valid_594035, JString, required = true,
                                 default = nil)
  if valid_594035 != nil:
    section.add "frontDoorName", valid_594035
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594036 = query.getOrDefault("api-version")
  valid_594036 = validateParameter(valid_594036, JString, required = true,
                                 default = nil)
  if valid_594036 != nil:
    section.add "api-version", valid_594036
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594037: Call_FrontDoorsDelete_594030; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an existing Front Door with the specified parameters.
  ## 
  let valid = call_594037.validator(path, query, header, formData, body)
  let scheme = call_594037.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594037.url(scheme.get, call_594037.host, call_594037.base,
                         call_594037.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594037, url, valid)

proc call*(call_594038: Call_FrontDoorsDelete_594030; resourceGroupName: string;
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
  var path_594039 = newJObject()
  var query_594040 = newJObject()
  add(path_594039, "resourceGroupName", newJString(resourceGroupName))
  add(query_594040, "api-version", newJString(apiVersion))
  add(path_594039, "subscriptionId", newJString(subscriptionId))
  add(path_594039, "frontDoorName", newJString(frontDoorName))
  result = call_594038.call(path_594039, query_594040, nil, nil, nil)

var frontDoorsDelete* = Call_FrontDoorsDelete_594030(name: "frontDoorsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/frontDoors/{frontDoorName}",
    validator: validate_FrontDoorsDelete_594031, base: "",
    url: url_FrontDoorsDelete_594032, schemes: {Scheme.Https})
type
  Call_BackendPoolsListByFrontDoor_594041 = ref object of OpenApiRestCall_593425
proc url_BackendPoolsListByFrontDoor_594043(protocol: Scheme; host: string;
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
               (kind: ConstantSegment, value: "/backendPools")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BackendPoolsListByFrontDoor_594042(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all of the Backend Pools within a Front Door.
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
  var valid_594044 = path.getOrDefault("resourceGroupName")
  valid_594044 = validateParameter(valid_594044, JString, required = true,
                                 default = nil)
  if valid_594044 != nil:
    section.add "resourceGroupName", valid_594044
  var valid_594045 = path.getOrDefault("subscriptionId")
  valid_594045 = validateParameter(valid_594045, JString, required = true,
                                 default = nil)
  if valid_594045 != nil:
    section.add "subscriptionId", valid_594045
  var valid_594046 = path.getOrDefault("frontDoorName")
  valid_594046 = validateParameter(valid_594046, JString, required = true,
                                 default = nil)
  if valid_594046 != nil:
    section.add "frontDoorName", valid_594046
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594047 = query.getOrDefault("api-version")
  valid_594047 = validateParameter(valid_594047, JString, required = true,
                                 default = nil)
  if valid_594047 != nil:
    section.add "api-version", valid_594047
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594048: Call_BackendPoolsListByFrontDoor_594041; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the Backend Pools within a Front Door.
  ## 
  let valid = call_594048.validator(path, query, header, formData, body)
  let scheme = call_594048.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594048.url(scheme.get, call_594048.host, call_594048.base,
                         call_594048.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594048, url, valid)

proc call*(call_594049: Call_BackendPoolsListByFrontDoor_594041;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          frontDoorName: string): Recallable =
  ## backendPoolsListByFrontDoor
  ## Lists all of the Backend Pools within a Front Door.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   frontDoorName: string (required)
  ##                : Name of the Front Door which is globally unique.
  var path_594050 = newJObject()
  var query_594051 = newJObject()
  add(path_594050, "resourceGroupName", newJString(resourceGroupName))
  add(query_594051, "api-version", newJString(apiVersion))
  add(path_594050, "subscriptionId", newJString(subscriptionId))
  add(path_594050, "frontDoorName", newJString(frontDoorName))
  result = call_594049.call(path_594050, query_594051, nil, nil, nil)

var backendPoolsListByFrontDoor* = Call_BackendPoolsListByFrontDoor_594041(
    name: "backendPoolsListByFrontDoor", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/frontDoors/{frontDoorName}/backendPools",
    validator: validate_BackendPoolsListByFrontDoor_594042, base: "",
    url: url_BackendPoolsListByFrontDoor_594043, schemes: {Scheme.Https})
type
  Call_BackendPoolsCreateOrUpdate_594064 = ref object of OpenApiRestCall_593425
proc url_BackendPoolsCreateOrUpdate_594066(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "frontDoorName" in path, "`frontDoorName` is a required path parameter"
  assert "backendPoolName" in path, "`backendPoolName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Network/frontDoors/"),
               (kind: VariableSegment, value: "frontDoorName"),
               (kind: ConstantSegment, value: "/backendPools/"),
               (kind: VariableSegment, value: "backendPoolName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BackendPoolsCreateOrUpdate_594065(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a new Backend Pool with the specified Pool name within the specified Front Door.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   backendPoolName: JString (required)
  ##                  : Name of the Backend Pool which is unique within the Front Door.
  ##   frontDoorName: JString (required)
  ##                : Name of the Front Door which is globally unique.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594067 = path.getOrDefault("resourceGroupName")
  valid_594067 = validateParameter(valid_594067, JString, required = true,
                                 default = nil)
  if valid_594067 != nil:
    section.add "resourceGroupName", valid_594067
  var valid_594068 = path.getOrDefault("subscriptionId")
  valid_594068 = validateParameter(valid_594068, JString, required = true,
                                 default = nil)
  if valid_594068 != nil:
    section.add "subscriptionId", valid_594068
  var valid_594069 = path.getOrDefault("backendPoolName")
  valid_594069 = validateParameter(valid_594069, JString, required = true,
                                 default = nil)
  if valid_594069 != nil:
    section.add "backendPoolName", valid_594069
  var valid_594070 = path.getOrDefault("frontDoorName")
  valid_594070 = validateParameter(valid_594070, JString, required = true,
                                 default = nil)
  if valid_594070 != nil:
    section.add "frontDoorName", valid_594070
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594071 = query.getOrDefault("api-version")
  valid_594071 = validateParameter(valid_594071, JString, required = true,
                                 default = nil)
  if valid_594071 != nil:
    section.add "api-version", valid_594071
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   backendPoolParameters: JObject (required)
  ##                        : Backend Pool properties needed to create a new Pool.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594073: Call_BackendPoolsCreateOrUpdate_594064; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new Backend Pool with the specified Pool name within the specified Front Door.
  ## 
  let valid = call_594073.validator(path, query, header, formData, body)
  let scheme = call_594073.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594073.url(scheme.get, call_594073.host, call_594073.base,
                         call_594073.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594073, url, valid)

proc call*(call_594074: Call_BackendPoolsCreateOrUpdate_594064;
          resourceGroupName: string; apiVersion: string;
          backendPoolParameters: JsonNode; subscriptionId: string;
          backendPoolName: string; frontDoorName: string): Recallable =
  ## backendPoolsCreateOrUpdate
  ## Creates a new Backend Pool with the specified Pool name within the specified Front Door.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   backendPoolParameters: JObject (required)
  ##                        : Backend Pool properties needed to create a new Pool.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   backendPoolName: string (required)
  ##                  : Name of the Backend Pool which is unique within the Front Door.
  ##   frontDoorName: string (required)
  ##                : Name of the Front Door which is globally unique.
  var path_594075 = newJObject()
  var query_594076 = newJObject()
  var body_594077 = newJObject()
  add(path_594075, "resourceGroupName", newJString(resourceGroupName))
  add(query_594076, "api-version", newJString(apiVersion))
  if backendPoolParameters != nil:
    body_594077 = backendPoolParameters
  add(path_594075, "subscriptionId", newJString(subscriptionId))
  add(path_594075, "backendPoolName", newJString(backendPoolName))
  add(path_594075, "frontDoorName", newJString(frontDoorName))
  result = call_594074.call(path_594075, query_594076, nil, nil, body_594077)

var backendPoolsCreateOrUpdate* = Call_BackendPoolsCreateOrUpdate_594064(
    name: "backendPoolsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/frontDoors/{frontDoorName}/backendPools/{backendPoolName}",
    validator: validate_BackendPoolsCreateOrUpdate_594065, base: "",
    url: url_BackendPoolsCreateOrUpdate_594066, schemes: {Scheme.Https})
type
  Call_BackendPoolsGet_594052 = ref object of OpenApiRestCall_593425
proc url_BackendPoolsGet_594054(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "frontDoorName" in path, "`frontDoorName` is a required path parameter"
  assert "backendPoolName" in path, "`backendPoolName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Network/frontDoors/"),
               (kind: VariableSegment, value: "frontDoorName"),
               (kind: ConstantSegment, value: "/backendPools/"),
               (kind: VariableSegment, value: "backendPoolName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BackendPoolsGet_594053(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Gets a Backend Pool with the specified Pool name within the specified Front Door.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   backendPoolName: JString (required)
  ##                  : Name of the Backend Pool which is unique within the Front Door.
  ##   frontDoorName: JString (required)
  ##                : Name of the Front Door which is globally unique.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594055 = path.getOrDefault("resourceGroupName")
  valid_594055 = validateParameter(valid_594055, JString, required = true,
                                 default = nil)
  if valid_594055 != nil:
    section.add "resourceGroupName", valid_594055
  var valid_594056 = path.getOrDefault("subscriptionId")
  valid_594056 = validateParameter(valid_594056, JString, required = true,
                                 default = nil)
  if valid_594056 != nil:
    section.add "subscriptionId", valid_594056
  var valid_594057 = path.getOrDefault("backendPoolName")
  valid_594057 = validateParameter(valid_594057, JString, required = true,
                                 default = nil)
  if valid_594057 != nil:
    section.add "backendPoolName", valid_594057
  var valid_594058 = path.getOrDefault("frontDoorName")
  valid_594058 = validateParameter(valid_594058, JString, required = true,
                                 default = nil)
  if valid_594058 != nil:
    section.add "frontDoorName", valid_594058
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594059 = query.getOrDefault("api-version")
  valid_594059 = validateParameter(valid_594059, JString, required = true,
                                 default = nil)
  if valid_594059 != nil:
    section.add "api-version", valid_594059
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594060: Call_BackendPoolsGet_594052; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a Backend Pool with the specified Pool name within the specified Front Door.
  ## 
  let valid = call_594060.validator(path, query, header, formData, body)
  let scheme = call_594060.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594060.url(scheme.get, call_594060.host, call_594060.base,
                         call_594060.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594060, url, valid)

proc call*(call_594061: Call_BackendPoolsGet_594052; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; backendPoolName: string;
          frontDoorName: string): Recallable =
  ## backendPoolsGet
  ## Gets a Backend Pool with the specified Pool name within the specified Front Door.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   backendPoolName: string (required)
  ##                  : Name of the Backend Pool which is unique within the Front Door.
  ##   frontDoorName: string (required)
  ##                : Name of the Front Door which is globally unique.
  var path_594062 = newJObject()
  var query_594063 = newJObject()
  add(path_594062, "resourceGroupName", newJString(resourceGroupName))
  add(query_594063, "api-version", newJString(apiVersion))
  add(path_594062, "subscriptionId", newJString(subscriptionId))
  add(path_594062, "backendPoolName", newJString(backendPoolName))
  add(path_594062, "frontDoorName", newJString(frontDoorName))
  result = call_594061.call(path_594062, query_594063, nil, nil, nil)

var backendPoolsGet* = Call_BackendPoolsGet_594052(name: "backendPoolsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/frontDoors/{frontDoorName}/backendPools/{backendPoolName}",
    validator: validate_BackendPoolsGet_594053, base: "", url: url_BackendPoolsGet_594054,
    schemes: {Scheme.Https})
type
  Call_BackendPoolsDelete_594078 = ref object of OpenApiRestCall_593425
proc url_BackendPoolsDelete_594080(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "frontDoorName" in path, "`frontDoorName` is a required path parameter"
  assert "backendPoolName" in path, "`backendPoolName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Network/frontDoors/"),
               (kind: VariableSegment, value: "frontDoorName"),
               (kind: ConstantSegment, value: "/backendPools/"),
               (kind: VariableSegment, value: "backendPoolName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BackendPoolsDelete_594079(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Deletes an existing Backend Pool with the specified parameters.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   backendPoolName: JString (required)
  ##                  : Name of the Backend Pool which is unique within the Front Door.
  ##   frontDoorName: JString (required)
  ##                : Name of the Front Door which is globally unique.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594081 = path.getOrDefault("resourceGroupName")
  valid_594081 = validateParameter(valid_594081, JString, required = true,
                                 default = nil)
  if valid_594081 != nil:
    section.add "resourceGroupName", valid_594081
  var valid_594082 = path.getOrDefault("subscriptionId")
  valid_594082 = validateParameter(valid_594082, JString, required = true,
                                 default = nil)
  if valid_594082 != nil:
    section.add "subscriptionId", valid_594082
  var valid_594083 = path.getOrDefault("backendPoolName")
  valid_594083 = validateParameter(valid_594083, JString, required = true,
                                 default = nil)
  if valid_594083 != nil:
    section.add "backendPoolName", valid_594083
  var valid_594084 = path.getOrDefault("frontDoorName")
  valid_594084 = validateParameter(valid_594084, JString, required = true,
                                 default = nil)
  if valid_594084 != nil:
    section.add "frontDoorName", valid_594084
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594085 = query.getOrDefault("api-version")
  valid_594085 = validateParameter(valid_594085, JString, required = true,
                                 default = nil)
  if valid_594085 != nil:
    section.add "api-version", valid_594085
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594086: Call_BackendPoolsDelete_594078; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an existing Backend Pool with the specified parameters.
  ## 
  let valid = call_594086.validator(path, query, header, formData, body)
  let scheme = call_594086.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594086.url(scheme.get, call_594086.host, call_594086.base,
                         call_594086.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594086, url, valid)

proc call*(call_594087: Call_BackendPoolsDelete_594078; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; backendPoolName: string;
          frontDoorName: string): Recallable =
  ## backendPoolsDelete
  ## Deletes an existing Backend Pool with the specified parameters.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   backendPoolName: string (required)
  ##                  : Name of the Backend Pool which is unique within the Front Door.
  ##   frontDoorName: string (required)
  ##                : Name of the Front Door which is globally unique.
  var path_594088 = newJObject()
  var query_594089 = newJObject()
  add(path_594088, "resourceGroupName", newJString(resourceGroupName))
  add(query_594089, "api-version", newJString(apiVersion))
  add(path_594088, "subscriptionId", newJString(subscriptionId))
  add(path_594088, "backendPoolName", newJString(backendPoolName))
  add(path_594088, "frontDoorName", newJString(frontDoorName))
  result = call_594087.call(path_594088, query_594089, nil, nil, nil)

var backendPoolsDelete* = Call_BackendPoolsDelete_594078(
    name: "backendPoolsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/frontDoors/{frontDoorName}/backendPools/{backendPoolName}",
    validator: validate_BackendPoolsDelete_594079, base: "",
    url: url_BackendPoolsDelete_594080, schemes: {Scheme.Https})
type
  Call_FrontendEndpointsListByFrontDoor_594090 = ref object of OpenApiRestCall_593425
proc url_FrontendEndpointsListByFrontDoor_594092(protocol: Scheme; host: string;
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

proc validate_FrontendEndpointsListByFrontDoor_594091(path: JsonNode;
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
  var valid_594093 = path.getOrDefault("resourceGroupName")
  valid_594093 = validateParameter(valid_594093, JString, required = true,
                                 default = nil)
  if valid_594093 != nil:
    section.add "resourceGroupName", valid_594093
  var valid_594094 = path.getOrDefault("subscriptionId")
  valid_594094 = validateParameter(valid_594094, JString, required = true,
                                 default = nil)
  if valid_594094 != nil:
    section.add "subscriptionId", valid_594094
  var valid_594095 = path.getOrDefault("frontDoorName")
  valid_594095 = validateParameter(valid_594095, JString, required = true,
                                 default = nil)
  if valid_594095 != nil:
    section.add "frontDoorName", valid_594095
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594096 = query.getOrDefault("api-version")
  valid_594096 = validateParameter(valid_594096, JString, required = true,
                                 default = nil)
  if valid_594096 != nil:
    section.add "api-version", valid_594096
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594097: Call_FrontendEndpointsListByFrontDoor_594090;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all of the frontend endpoints within a Front Door.
  ## 
  let valid = call_594097.validator(path, query, header, formData, body)
  let scheme = call_594097.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594097.url(scheme.get, call_594097.host, call_594097.base,
                         call_594097.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594097, url, valid)

proc call*(call_594098: Call_FrontendEndpointsListByFrontDoor_594090;
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
  var path_594099 = newJObject()
  var query_594100 = newJObject()
  add(path_594099, "resourceGroupName", newJString(resourceGroupName))
  add(query_594100, "api-version", newJString(apiVersion))
  add(path_594099, "subscriptionId", newJString(subscriptionId))
  add(path_594099, "frontDoorName", newJString(frontDoorName))
  result = call_594098.call(path_594099, query_594100, nil, nil, nil)

var frontendEndpointsListByFrontDoor* = Call_FrontendEndpointsListByFrontDoor_594090(
    name: "frontendEndpointsListByFrontDoor", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/frontDoors/{frontDoorName}/frontendEndpoints",
    validator: validate_FrontendEndpointsListByFrontDoor_594091, base: "",
    url: url_FrontendEndpointsListByFrontDoor_594092, schemes: {Scheme.Https})
type
  Call_FrontendEndpointsCreateOrUpdate_594113 = ref object of OpenApiRestCall_593425
proc url_FrontendEndpointsCreateOrUpdate_594115(protocol: Scheme; host: string;
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
               (kind: VariableSegment, value: "frontendEndpointName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FrontendEndpointsCreateOrUpdate_594114(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a new frontend endpoint with the specified host name within the specified Front Door.
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
  var valid_594116 = path.getOrDefault("resourceGroupName")
  valid_594116 = validateParameter(valid_594116, JString, required = true,
                                 default = nil)
  if valid_594116 != nil:
    section.add "resourceGroupName", valid_594116
  var valid_594117 = path.getOrDefault("frontendEndpointName")
  valid_594117 = validateParameter(valid_594117, JString, required = true,
                                 default = nil)
  if valid_594117 != nil:
    section.add "frontendEndpointName", valid_594117
  var valid_594118 = path.getOrDefault("subscriptionId")
  valid_594118 = validateParameter(valid_594118, JString, required = true,
                                 default = nil)
  if valid_594118 != nil:
    section.add "subscriptionId", valid_594118
  var valid_594119 = path.getOrDefault("frontDoorName")
  valid_594119 = validateParameter(valid_594119, JString, required = true,
                                 default = nil)
  if valid_594119 != nil:
    section.add "frontDoorName", valid_594119
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594120 = query.getOrDefault("api-version")
  valid_594120 = validateParameter(valid_594120, JString, required = true,
                                 default = nil)
  if valid_594120 != nil:
    section.add "api-version", valid_594120
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   frontendEndpointParameters: JObject (required)
  ##                             : Frontend endpoint properties needed to create a new endpoint.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594122: Call_FrontendEndpointsCreateOrUpdate_594113;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a new frontend endpoint with the specified host name within the specified Front Door.
  ## 
  let valid = call_594122.validator(path, query, header, formData, body)
  let scheme = call_594122.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594122.url(scheme.get, call_594122.host, call_594122.base,
                         call_594122.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594122, url, valid)

proc call*(call_594123: Call_FrontendEndpointsCreateOrUpdate_594113;
          resourceGroupName: string; frontendEndpointName: string;
          apiVersion: string; frontendEndpointParameters: JsonNode;
          subscriptionId: string; frontDoorName: string): Recallable =
  ## frontendEndpointsCreateOrUpdate
  ## Creates a new frontend endpoint with the specified host name within the specified Front Door.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   frontendEndpointName: string (required)
  ##                       : Name of the Frontend endpoint which is unique within the Front Door.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   frontendEndpointParameters: JObject (required)
  ##                             : Frontend endpoint properties needed to create a new endpoint.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   frontDoorName: string (required)
  ##                : Name of the Front Door which is globally unique.
  var path_594124 = newJObject()
  var query_594125 = newJObject()
  var body_594126 = newJObject()
  add(path_594124, "resourceGroupName", newJString(resourceGroupName))
  add(path_594124, "frontendEndpointName", newJString(frontendEndpointName))
  add(query_594125, "api-version", newJString(apiVersion))
  if frontendEndpointParameters != nil:
    body_594126 = frontendEndpointParameters
  add(path_594124, "subscriptionId", newJString(subscriptionId))
  add(path_594124, "frontDoorName", newJString(frontDoorName))
  result = call_594123.call(path_594124, query_594125, nil, nil, body_594126)

var frontendEndpointsCreateOrUpdate* = Call_FrontendEndpointsCreateOrUpdate_594113(
    name: "frontendEndpointsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/frontDoors/{frontDoorName}/frontendEndpoints/{frontendEndpointName}",
    validator: validate_FrontendEndpointsCreateOrUpdate_594114, base: "",
    url: url_FrontendEndpointsCreateOrUpdate_594115, schemes: {Scheme.Https})
type
  Call_FrontendEndpointsGet_594101 = ref object of OpenApiRestCall_593425
proc url_FrontendEndpointsGet_594103(protocol: Scheme; host: string; base: string;
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

proc validate_FrontendEndpointsGet_594102(path: JsonNode; query: JsonNode;
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
  var valid_594104 = path.getOrDefault("resourceGroupName")
  valid_594104 = validateParameter(valid_594104, JString, required = true,
                                 default = nil)
  if valid_594104 != nil:
    section.add "resourceGroupName", valid_594104
  var valid_594105 = path.getOrDefault("frontendEndpointName")
  valid_594105 = validateParameter(valid_594105, JString, required = true,
                                 default = nil)
  if valid_594105 != nil:
    section.add "frontendEndpointName", valid_594105
  var valid_594106 = path.getOrDefault("subscriptionId")
  valid_594106 = validateParameter(valid_594106, JString, required = true,
                                 default = nil)
  if valid_594106 != nil:
    section.add "subscriptionId", valid_594106
  var valid_594107 = path.getOrDefault("frontDoorName")
  valid_594107 = validateParameter(valid_594107, JString, required = true,
                                 default = nil)
  if valid_594107 != nil:
    section.add "frontDoorName", valid_594107
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594108 = query.getOrDefault("api-version")
  valid_594108 = validateParameter(valid_594108, JString, required = true,
                                 default = nil)
  if valid_594108 != nil:
    section.add "api-version", valid_594108
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594109: Call_FrontendEndpointsGet_594101; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a Frontend endpoint with the specified name within the specified Front Door.
  ## 
  let valid = call_594109.validator(path, query, header, formData, body)
  let scheme = call_594109.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594109.url(scheme.get, call_594109.host, call_594109.base,
                         call_594109.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594109, url, valid)

proc call*(call_594110: Call_FrontendEndpointsGet_594101;
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
  var path_594111 = newJObject()
  var query_594112 = newJObject()
  add(path_594111, "resourceGroupName", newJString(resourceGroupName))
  add(path_594111, "frontendEndpointName", newJString(frontendEndpointName))
  add(query_594112, "api-version", newJString(apiVersion))
  add(path_594111, "subscriptionId", newJString(subscriptionId))
  add(path_594111, "frontDoorName", newJString(frontDoorName))
  result = call_594110.call(path_594111, query_594112, nil, nil, nil)

var frontendEndpointsGet* = Call_FrontendEndpointsGet_594101(
    name: "frontendEndpointsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/frontDoors/{frontDoorName}/frontendEndpoints/{frontendEndpointName}",
    validator: validate_FrontendEndpointsGet_594102, base: "",
    url: url_FrontendEndpointsGet_594103, schemes: {Scheme.Https})
type
  Call_FrontendEndpointsDelete_594127 = ref object of OpenApiRestCall_593425
proc url_FrontendEndpointsDelete_594129(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
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

proc validate_FrontendEndpointsDelete_594128(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes an existing frontend endpoint with the specified parameters.
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
  var valid_594130 = path.getOrDefault("resourceGroupName")
  valid_594130 = validateParameter(valid_594130, JString, required = true,
                                 default = nil)
  if valid_594130 != nil:
    section.add "resourceGroupName", valid_594130
  var valid_594131 = path.getOrDefault("frontendEndpointName")
  valid_594131 = validateParameter(valid_594131, JString, required = true,
                                 default = nil)
  if valid_594131 != nil:
    section.add "frontendEndpointName", valid_594131
  var valid_594132 = path.getOrDefault("subscriptionId")
  valid_594132 = validateParameter(valid_594132, JString, required = true,
                                 default = nil)
  if valid_594132 != nil:
    section.add "subscriptionId", valid_594132
  var valid_594133 = path.getOrDefault("frontDoorName")
  valid_594133 = validateParameter(valid_594133, JString, required = true,
                                 default = nil)
  if valid_594133 != nil:
    section.add "frontDoorName", valid_594133
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594134 = query.getOrDefault("api-version")
  valid_594134 = validateParameter(valid_594134, JString, required = true,
                                 default = nil)
  if valid_594134 != nil:
    section.add "api-version", valid_594134
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594135: Call_FrontendEndpointsDelete_594127; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an existing frontend endpoint with the specified parameters.
  ## 
  let valid = call_594135.validator(path, query, header, formData, body)
  let scheme = call_594135.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594135.url(scheme.get, call_594135.host, call_594135.base,
                         call_594135.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594135, url, valid)

proc call*(call_594136: Call_FrontendEndpointsDelete_594127;
          resourceGroupName: string; frontendEndpointName: string;
          apiVersion: string; subscriptionId: string; frontDoorName: string): Recallable =
  ## frontendEndpointsDelete
  ## Deletes an existing frontend endpoint with the specified parameters.
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
  var path_594137 = newJObject()
  var query_594138 = newJObject()
  add(path_594137, "resourceGroupName", newJString(resourceGroupName))
  add(path_594137, "frontendEndpointName", newJString(frontendEndpointName))
  add(query_594138, "api-version", newJString(apiVersion))
  add(path_594137, "subscriptionId", newJString(subscriptionId))
  add(path_594137, "frontDoorName", newJString(frontDoorName))
  result = call_594136.call(path_594137, query_594138, nil, nil, nil)

var frontendEndpointsDelete* = Call_FrontendEndpointsDelete_594127(
    name: "frontendEndpointsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/frontDoors/{frontDoorName}/frontendEndpoints/{frontendEndpointName}",
    validator: validate_FrontendEndpointsDelete_594128, base: "",
    url: url_FrontendEndpointsDelete_594129, schemes: {Scheme.Https})
type
  Call_FrontendEndpointsDisableHttps_594139 = ref object of OpenApiRestCall_593425
proc url_FrontendEndpointsDisableHttps_594141(protocol: Scheme; host: string;
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

proc validate_FrontendEndpointsDisableHttps_594140(path: JsonNode; query: JsonNode;
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
  var valid_594142 = path.getOrDefault("resourceGroupName")
  valid_594142 = validateParameter(valid_594142, JString, required = true,
                                 default = nil)
  if valid_594142 != nil:
    section.add "resourceGroupName", valid_594142
  var valid_594143 = path.getOrDefault("frontendEndpointName")
  valid_594143 = validateParameter(valid_594143, JString, required = true,
                                 default = nil)
  if valid_594143 != nil:
    section.add "frontendEndpointName", valid_594143
  var valid_594144 = path.getOrDefault("subscriptionId")
  valid_594144 = validateParameter(valid_594144, JString, required = true,
                                 default = nil)
  if valid_594144 != nil:
    section.add "subscriptionId", valid_594144
  var valid_594145 = path.getOrDefault("frontDoorName")
  valid_594145 = validateParameter(valid_594145, JString, required = true,
                                 default = nil)
  if valid_594145 != nil:
    section.add "frontDoorName", valid_594145
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594146 = query.getOrDefault("api-version")
  valid_594146 = validateParameter(valid_594146, JString, required = true,
                                 default = nil)
  if valid_594146 != nil:
    section.add "api-version", valid_594146
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594147: Call_FrontendEndpointsDisableHttps_594139; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Disables a frontendEndpoint for HTTPS traffic
  ## 
  let valid = call_594147.validator(path, query, header, formData, body)
  let scheme = call_594147.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594147.url(scheme.get, call_594147.host, call_594147.base,
                         call_594147.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594147, url, valid)

proc call*(call_594148: Call_FrontendEndpointsDisableHttps_594139;
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
  var path_594149 = newJObject()
  var query_594150 = newJObject()
  add(path_594149, "resourceGroupName", newJString(resourceGroupName))
  add(path_594149, "frontendEndpointName", newJString(frontendEndpointName))
  add(query_594150, "api-version", newJString(apiVersion))
  add(path_594149, "subscriptionId", newJString(subscriptionId))
  add(path_594149, "frontDoorName", newJString(frontDoorName))
  result = call_594148.call(path_594149, query_594150, nil, nil, nil)

var frontendEndpointsDisableHttps* = Call_FrontendEndpointsDisableHttps_594139(
    name: "frontendEndpointsDisableHttps", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/frontDoors/{frontDoorName}/frontendEndpoints/{frontendEndpointName}/disableHttps",
    validator: validate_FrontendEndpointsDisableHttps_594140, base: "",
    url: url_FrontendEndpointsDisableHttps_594141, schemes: {Scheme.Https})
type
  Call_FrontendEndpointsEnableHttps_594151 = ref object of OpenApiRestCall_593425
proc url_FrontendEndpointsEnableHttps_594153(protocol: Scheme; host: string;
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

proc validate_FrontendEndpointsEnableHttps_594152(path: JsonNode; query: JsonNode;
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
  var valid_594154 = path.getOrDefault("resourceGroupName")
  valid_594154 = validateParameter(valid_594154, JString, required = true,
                                 default = nil)
  if valid_594154 != nil:
    section.add "resourceGroupName", valid_594154
  var valid_594155 = path.getOrDefault("frontendEndpointName")
  valid_594155 = validateParameter(valid_594155, JString, required = true,
                                 default = nil)
  if valid_594155 != nil:
    section.add "frontendEndpointName", valid_594155
  var valid_594156 = path.getOrDefault("subscriptionId")
  valid_594156 = validateParameter(valid_594156, JString, required = true,
                                 default = nil)
  if valid_594156 != nil:
    section.add "subscriptionId", valid_594156
  var valid_594157 = path.getOrDefault("frontDoorName")
  valid_594157 = validateParameter(valid_594157, JString, required = true,
                                 default = nil)
  if valid_594157 != nil:
    section.add "frontDoorName", valid_594157
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594158 = query.getOrDefault("api-version")
  valid_594158 = validateParameter(valid_594158, JString, required = true,
                                 default = nil)
  if valid_594158 != nil:
    section.add "api-version", valid_594158
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

proc call*(call_594160: Call_FrontendEndpointsEnableHttps_594151; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Enables a frontendEndpoint for HTTPS traffic
  ## 
  let valid = call_594160.validator(path, query, header, formData, body)
  let scheme = call_594160.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594160.url(scheme.get, call_594160.host, call_594160.base,
                         call_594160.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594160, url, valid)

proc call*(call_594161: Call_FrontendEndpointsEnableHttps_594151;
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
  var path_594162 = newJObject()
  var query_594163 = newJObject()
  var body_594164 = newJObject()
  add(path_594162, "resourceGroupName", newJString(resourceGroupName))
  add(path_594162, "frontendEndpointName", newJString(frontendEndpointName))
  add(query_594163, "api-version", newJString(apiVersion))
  add(path_594162, "subscriptionId", newJString(subscriptionId))
  if customHttpsConfiguration != nil:
    body_594164 = customHttpsConfiguration
  add(path_594162, "frontDoorName", newJString(frontDoorName))
  result = call_594161.call(path_594162, query_594163, nil, nil, body_594164)

var frontendEndpointsEnableHttps* = Call_FrontendEndpointsEnableHttps_594151(
    name: "frontendEndpointsEnableHttps", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/frontDoors/{frontDoorName}/frontendEndpoints/{frontendEndpointName}/enableHttps",
    validator: validate_FrontendEndpointsEnableHttps_594152, base: "",
    url: url_FrontendEndpointsEnableHttps_594153, schemes: {Scheme.Https})
type
  Call_HealthProbeSettingsListByFrontDoor_594165 = ref object of OpenApiRestCall_593425
proc url_HealthProbeSettingsListByFrontDoor_594167(protocol: Scheme; host: string;
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
               (kind: ConstantSegment, value: "/healthProbeSettings")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_HealthProbeSettingsListByFrontDoor_594166(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all of the HealthProbeSettings within a Front Door.
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
  var valid_594168 = path.getOrDefault("resourceGroupName")
  valid_594168 = validateParameter(valid_594168, JString, required = true,
                                 default = nil)
  if valid_594168 != nil:
    section.add "resourceGroupName", valid_594168
  var valid_594169 = path.getOrDefault("subscriptionId")
  valid_594169 = validateParameter(valid_594169, JString, required = true,
                                 default = nil)
  if valid_594169 != nil:
    section.add "subscriptionId", valid_594169
  var valid_594170 = path.getOrDefault("frontDoorName")
  valid_594170 = validateParameter(valid_594170, JString, required = true,
                                 default = nil)
  if valid_594170 != nil:
    section.add "frontDoorName", valid_594170
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594171 = query.getOrDefault("api-version")
  valid_594171 = validateParameter(valid_594171, JString, required = true,
                                 default = nil)
  if valid_594171 != nil:
    section.add "api-version", valid_594171
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594172: Call_HealthProbeSettingsListByFrontDoor_594165;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all of the HealthProbeSettings within a Front Door.
  ## 
  let valid = call_594172.validator(path, query, header, formData, body)
  let scheme = call_594172.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594172.url(scheme.get, call_594172.host, call_594172.base,
                         call_594172.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594172, url, valid)

proc call*(call_594173: Call_HealthProbeSettingsListByFrontDoor_594165;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          frontDoorName: string): Recallable =
  ## healthProbeSettingsListByFrontDoor
  ## Lists all of the HealthProbeSettings within a Front Door.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   frontDoorName: string (required)
  ##                : Name of the Front Door which is globally unique.
  var path_594174 = newJObject()
  var query_594175 = newJObject()
  add(path_594174, "resourceGroupName", newJString(resourceGroupName))
  add(query_594175, "api-version", newJString(apiVersion))
  add(path_594174, "subscriptionId", newJString(subscriptionId))
  add(path_594174, "frontDoorName", newJString(frontDoorName))
  result = call_594173.call(path_594174, query_594175, nil, nil, nil)

var healthProbeSettingsListByFrontDoor* = Call_HealthProbeSettingsListByFrontDoor_594165(
    name: "healthProbeSettingsListByFrontDoor", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/frontDoors/{frontDoorName}/healthProbeSettings",
    validator: validate_HealthProbeSettingsListByFrontDoor_594166, base: "",
    url: url_HealthProbeSettingsListByFrontDoor_594167, schemes: {Scheme.Https})
type
  Call_HealthProbeSettingsCreateOrUpdate_594188 = ref object of OpenApiRestCall_593425
proc url_HealthProbeSettingsCreateOrUpdate_594190(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "frontDoorName" in path, "`frontDoorName` is a required path parameter"
  assert "healthProbeSettingsName" in path,
        "`healthProbeSettingsName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Network/frontDoors/"),
               (kind: VariableSegment, value: "frontDoorName"),
               (kind: ConstantSegment, value: "/healthProbeSettings/"),
               (kind: VariableSegment, value: "healthProbeSettingsName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_HealthProbeSettingsCreateOrUpdate_594189(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a new HealthProbeSettings with the specified Rule name within the specified Front Door.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   healthProbeSettingsName: JString (required)
  ##                          : Name of the health probe settings which is unique within the Front Door.
  ##   frontDoorName: JString (required)
  ##                : Name of the Front Door which is globally unique.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594191 = path.getOrDefault("resourceGroupName")
  valid_594191 = validateParameter(valid_594191, JString, required = true,
                                 default = nil)
  if valid_594191 != nil:
    section.add "resourceGroupName", valid_594191
  var valid_594192 = path.getOrDefault("subscriptionId")
  valid_594192 = validateParameter(valid_594192, JString, required = true,
                                 default = nil)
  if valid_594192 != nil:
    section.add "subscriptionId", valid_594192
  var valid_594193 = path.getOrDefault("healthProbeSettingsName")
  valid_594193 = validateParameter(valid_594193, JString, required = true,
                                 default = nil)
  if valid_594193 != nil:
    section.add "healthProbeSettingsName", valid_594193
  var valid_594194 = path.getOrDefault("frontDoorName")
  valid_594194 = validateParameter(valid_594194, JString, required = true,
                                 default = nil)
  if valid_594194 != nil:
    section.add "frontDoorName", valid_594194
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594195 = query.getOrDefault("api-version")
  valid_594195 = validateParameter(valid_594195, JString, required = true,
                                 default = nil)
  if valid_594195 != nil:
    section.add "api-version", valid_594195
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   healthProbeSettingsParameters: JObject (required)
  ##                                : HealthProbeSettings properties needed to create a new Front Door.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594197: Call_HealthProbeSettingsCreateOrUpdate_594188;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a new HealthProbeSettings with the specified Rule name within the specified Front Door.
  ## 
  let valid = call_594197.validator(path, query, header, formData, body)
  let scheme = call_594197.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594197.url(scheme.get, call_594197.host, call_594197.base,
                         call_594197.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594197, url, valid)

proc call*(call_594198: Call_HealthProbeSettingsCreateOrUpdate_594188;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          healthProbeSettingsParameters: JsonNode;
          healthProbeSettingsName: string; frontDoorName: string): Recallable =
  ## healthProbeSettingsCreateOrUpdate
  ## Creates a new HealthProbeSettings with the specified Rule name within the specified Front Door.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   healthProbeSettingsParameters: JObject (required)
  ##                                : HealthProbeSettings properties needed to create a new Front Door.
  ##   healthProbeSettingsName: string (required)
  ##                          : Name of the health probe settings which is unique within the Front Door.
  ##   frontDoorName: string (required)
  ##                : Name of the Front Door which is globally unique.
  var path_594199 = newJObject()
  var query_594200 = newJObject()
  var body_594201 = newJObject()
  add(path_594199, "resourceGroupName", newJString(resourceGroupName))
  add(query_594200, "api-version", newJString(apiVersion))
  add(path_594199, "subscriptionId", newJString(subscriptionId))
  if healthProbeSettingsParameters != nil:
    body_594201 = healthProbeSettingsParameters
  add(path_594199, "healthProbeSettingsName", newJString(healthProbeSettingsName))
  add(path_594199, "frontDoorName", newJString(frontDoorName))
  result = call_594198.call(path_594199, query_594200, nil, nil, body_594201)

var healthProbeSettingsCreateOrUpdate* = Call_HealthProbeSettingsCreateOrUpdate_594188(
    name: "healthProbeSettingsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/frontDoors/{frontDoorName}/healthProbeSettings/{healthProbeSettingsName}",
    validator: validate_HealthProbeSettingsCreateOrUpdate_594189, base: "",
    url: url_HealthProbeSettingsCreateOrUpdate_594190, schemes: {Scheme.Https})
type
  Call_HealthProbeSettingsGet_594176 = ref object of OpenApiRestCall_593425
proc url_HealthProbeSettingsGet_594178(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "frontDoorName" in path, "`frontDoorName` is a required path parameter"
  assert "healthProbeSettingsName" in path,
        "`healthProbeSettingsName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Network/frontDoors/"),
               (kind: VariableSegment, value: "frontDoorName"),
               (kind: ConstantSegment, value: "/healthProbeSettings/"),
               (kind: VariableSegment, value: "healthProbeSettingsName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_HealthProbeSettingsGet_594177(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a HealthProbeSettings with the specified Rule name within the specified Front Door.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   healthProbeSettingsName: JString (required)
  ##                          : Name of the health probe settings which is unique within the Front Door.
  ##   frontDoorName: JString (required)
  ##                : Name of the Front Door which is globally unique.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594179 = path.getOrDefault("resourceGroupName")
  valid_594179 = validateParameter(valid_594179, JString, required = true,
                                 default = nil)
  if valid_594179 != nil:
    section.add "resourceGroupName", valid_594179
  var valid_594180 = path.getOrDefault("subscriptionId")
  valid_594180 = validateParameter(valid_594180, JString, required = true,
                                 default = nil)
  if valid_594180 != nil:
    section.add "subscriptionId", valid_594180
  var valid_594181 = path.getOrDefault("healthProbeSettingsName")
  valid_594181 = validateParameter(valid_594181, JString, required = true,
                                 default = nil)
  if valid_594181 != nil:
    section.add "healthProbeSettingsName", valid_594181
  var valid_594182 = path.getOrDefault("frontDoorName")
  valid_594182 = validateParameter(valid_594182, JString, required = true,
                                 default = nil)
  if valid_594182 != nil:
    section.add "frontDoorName", valid_594182
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594183 = query.getOrDefault("api-version")
  valid_594183 = validateParameter(valid_594183, JString, required = true,
                                 default = nil)
  if valid_594183 != nil:
    section.add "api-version", valid_594183
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594184: Call_HealthProbeSettingsGet_594176; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a HealthProbeSettings with the specified Rule name within the specified Front Door.
  ## 
  let valid = call_594184.validator(path, query, header, formData, body)
  let scheme = call_594184.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594184.url(scheme.get, call_594184.host, call_594184.base,
                         call_594184.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594184, url, valid)

proc call*(call_594185: Call_HealthProbeSettingsGet_594176;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          healthProbeSettingsName: string; frontDoorName: string): Recallable =
  ## healthProbeSettingsGet
  ## Gets a HealthProbeSettings with the specified Rule name within the specified Front Door.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   healthProbeSettingsName: string (required)
  ##                          : Name of the health probe settings which is unique within the Front Door.
  ##   frontDoorName: string (required)
  ##                : Name of the Front Door which is globally unique.
  var path_594186 = newJObject()
  var query_594187 = newJObject()
  add(path_594186, "resourceGroupName", newJString(resourceGroupName))
  add(query_594187, "api-version", newJString(apiVersion))
  add(path_594186, "subscriptionId", newJString(subscriptionId))
  add(path_594186, "healthProbeSettingsName", newJString(healthProbeSettingsName))
  add(path_594186, "frontDoorName", newJString(frontDoorName))
  result = call_594185.call(path_594186, query_594187, nil, nil, nil)

var healthProbeSettingsGet* = Call_HealthProbeSettingsGet_594176(
    name: "healthProbeSettingsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/frontDoors/{frontDoorName}/healthProbeSettings/{healthProbeSettingsName}",
    validator: validate_HealthProbeSettingsGet_594177, base: "",
    url: url_HealthProbeSettingsGet_594178, schemes: {Scheme.Https})
type
  Call_HealthProbeSettingsDelete_594202 = ref object of OpenApiRestCall_593425
proc url_HealthProbeSettingsDelete_594204(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "frontDoorName" in path, "`frontDoorName` is a required path parameter"
  assert "healthProbeSettingsName" in path,
        "`healthProbeSettingsName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Network/frontDoors/"),
               (kind: VariableSegment, value: "frontDoorName"),
               (kind: ConstantSegment, value: "/healthProbeSettings/"),
               (kind: VariableSegment, value: "healthProbeSettingsName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_HealthProbeSettingsDelete_594203(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes an existing HealthProbeSettings with the specified parameters.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   healthProbeSettingsName: JString (required)
  ##                          : Name of the health probe settings which is unique within the Front Door.
  ##   frontDoorName: JString (required)
  ##                : Name of the Front Door which is globally unique.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594205 = path.getOrDefault("resourceGroupName")
  valid_594205 = validateParameter(valid_594205, JString, required = true,
                                 default = nil)
  if valid_594205 != nil:
    section.add "resourceGroupName", valid_594205
  var valid_594206 = path.getOrDefault("subscriptionId")
  valid_594206 = validateParameter(valid_594206, JString, required = true,
                                 default = nil)
  if valid_594206 != nil:
    section.add "subscriptionId", valid_594206
  var valid_594207 = path.getOrDefault("healthProbeSettingsName")
  valid_594207 = validateParameter(valid_594207, JString, required = true,
                                 default = nil)
  if valid_594207 != nil:
    section.add "healthProbeSettingsName", valid_594207
  var valid_594208 = path.getOrDefault("frontDoorName")
  valid_594208 = validateParameter(valid_594208, JString, required = true,
                                 default = nil)
  if valid_594208 != nil:
    section.add "frontDoorName", valid_594208
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594209 = query.getOrDefault("api-version")
  valid_594209 = validateParameter(valid_594209, JString, required = true,
                                 default = nil)
  if valid_594209 != nil:
    section.add "api-version", valid_594209
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594210: Call_HealthProbeSettingsDelete_594202; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an existing HealthProbeSettings with the specified parameters.
  ## 
  let valid = call_594210.validator(path, query, header, formData, body)
  let scheme = call_594210.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594210.url(scheme.get, call_594210.host, call_594210.base,
                         call_594210.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594210, url, valid)

proc call*(call_594211: Call_HealthProbeSettingsDelete_594202;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          healthProbeSettingsName: string; frontDoorName: string): Recallable =
  ## healthProbeSettingsDelete
  ## Deletes an existing HealthProbeSettings with the specified parameters.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   healthProbeSettingsName: string (required)
  ##                          : Name of the health probe settings which is unique within the Front Door.
  ##   frontDoorName: string (required)
  ##                : Name of the Front Door which is globally unique.
  var path_594212 = newJObject()
  var query_594213 = newJObject()
  add(path_594212, "resourceGroupName", newJString(resourceGroupName))
  add(query_594213, "api-version", newJString(apiVersion))
  add(path_594212, "subscriptionId", newJString(subscriptionId))
  add(path_594212, "healthProbeSettingsName", newJString(healthProbeSettingsName))
  add(path_594212, "frontDoorName", newJString(frontDoorName))
  result = call_594211.call(path_594212, query_594213, nil, nil, nil)

var healthProbeSettingsDelete* = Call_HealthProbeSettingsDelete_594202(
    name: "healthProbeSettingsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/frontDoors/{frontDoorName}/healthProbeSettings/{healthProbeSettingsName}",
    validator: validate_HealthProbeSettingsDelete_594203, base: "",
    url: url_HealthProbeSettingsDelete_594204, schemes: {Scheme.Https})
type
  Call_LoadBalancingSettingsListByFrontDoor_594214 = ref object of OpenApiRestCall_593425
proc url_LoadBalancingSettingsListByFrontDoor_594216(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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
               (kind: ConstantSegment, value: "/loadBalancingSettings")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LoadBalancingSettingsListByFrontDoor_594215(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all of the LoadBalancingSettings within a Front Door.
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
  var valid_594217 = path.getOrDefault("resourceGroupName")
  valid_594217 = validateParameter(valid_594217, JString, required = true,
                                 default = nil)
  if valid_594217 != nil:
    section.add "resourceGroupName", valid_594217
  var valid_594218 = path.getOrDefault("subscriptionId")
  valid_594218 = validateParameter(valid_594218, JString, required = true,
                                 default = nil)
  if valid_594218 != nil:
    section.add "subscriptionId", valid_594218
  var valid_594219 = path.getOrDefault("frontDoorName")
  valid_594219 = validateParameter(valid_594219, JString, required = true,
                                 default = nil)
  if valid_594219 != nil:
    section.add "frontDoorName", valid_594219
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594220 = query.getOrDefault("api-version")
  valid_594220 = validateParameter(valid_594220, JString, required = true,
                                 default = nil)
  if valid_594220 != nil:
    section.add "api-version", valid_594220
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594221: Call_LoadBalancingSettingsListByFrontDoor_594214;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all of the LoadBalancingSettings within a Front Door.
  ## 
  let valid = call_594221.validator(path, query, header, formData, body)
  let scheme = call_594221.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594221.url(scheme.get, call_594221.host, call_594221.base,
                         call_594221.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594221, url, valid)

proc call*(call_594222: Call_LoadBalancingSettingsListByFrontDoor_594214;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          frontDoorName: string): Recallable =
  ## loadBalancingSettingsListByFrontDoor
  ## Lists all of the LoadBalancingSettings within a Front Door.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   frontDoorName: string (required)
  ##                : Name of the Front Door which is globally unique.
  var path_594223 = newJObject()
  var query_594224 = newJObject()
  add(path_594223, "resourceGroupName", newJString(resourceGroupName))
  add(query_594224, "api-version", newJString(apiVersion))
  add(path_594223, "subscriptionId", newJString(subscriptionId))
  add(path_594223, "frontDoorName", newJString(frontDoorName))
  result = call_594222.call(path_594223, query_594224, nil, nil, nil)

var loadBalancingSettingsListByFrontDoor* = Call_LoadBalancingSettingsListByFrontDoor_594214(
    name: "loadBalancingSettingsListByFrontDoor", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/frontDoors/{frontDoorName}/loadBalancingSettings",
    validator: validate_LoadBalancingSettingsListByFrontDoor_594215, base: "",
    url: url_LoadBalancingSettingsListByFrontDoor_594216, schemes: {Scheme.Https})
type
  Call_LoadBalancingSettingsCreateOrUpdate_594237 = ref object of OpenApiRestCall_593425
proc url_LoadBalancingSettingsCreateOrUpdate_594239(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "frontDoorName" in path, "`frontDoorName` is a required path parameter"
  assert "loadBalancingSettingsName" in path,
        "`loadBalancingSettingsName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Network/frontDoors/"),
               (kind: VariableSegment, value: "frontDoorName"),
               (kind: ConstantSegment, value: "/loadBalancingSettings/"),
               (kind: VariableSegment, value: "loadBalancingSettingsName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LoadBalancingSettingsCreateOrUpdate_594238(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a new LoadBalancingSettings with the specified Rule name within the specified Front Door.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   loadBalancingSettingsName: JString (required)
  ##                            : Name of the load balancing settings which is unique within the Front Door.
  ##   frontDoorName: JString (required)
  ##                : Name of the Front Door which is globally unique.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594240 = path.getOrDefault("resourceGroupName")
  valid_594240 = validateParameter(valid_594240, JString, required = true,
                                 default = nil)
  if valid_594240 != nil:
    section.add "resourceGroupName", valid_594240
  var valid_594241 = path.getOrDefault("subscriptionId")
  valid_594241 = validateParameter(valid_594241, JString, required = true,
                                 default = nil)
  if valid_594241 != nil:
    section.add "subscriptionId", valid_594241
  var valid_594242 = path.getOrDefault("loadBalancingSettingsName")
  valid_594242 = validateParameter(valid_594242, JString, required = true,
                                 default = nil)
  if valid_594242 != nil:
    section.add "loadBalancingSettingsName", valid_594242
  var valid_594243 = path.getOrDefault("frontDoorName")
  valid_594243 = validateParameter(valid_594243, JString, required = true,
                                 default = nil)
  if valid_594243 != nil:
    section.add "frontDoorName", valid_594243
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594244 = query.getOrDefault("api-version")
  valid_594244 = validateParameter(valid_594244, JString, required = true,
                                 default = nil)
  if valid_594244 != nil:
    section.add "api-version", valid_594244
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   loadBalancingSettingsParameters: JObject (required)
  ##                                  : LoadBalancingSettings properties needed to create a new Front Door.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594246: Call_LoadBalancingSettingsCreateOrUpdate_594237;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a new LoadBalancingSettings with the specified Rule name within the specified Front Door.
  ## 
  let valid = call_594246.validator(path, query, header, formData, body)
  let scheme = call_594246.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594246.url(scheme.get, call_594246.host, call_594246.base,
                         call_594246.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594246, url, valid)

proc call*(call_594247: Call_LoadBalancingSettingsCreateOrUpdate_594237;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          loadBalancingSettingsName: string;
          loadBalancingSettingsParameters: JsonNode; frontDoorName: string): Recallable =
  ## loadBalancingSettingsCreateOrUpdate
  ## Creates a new LoadBalancingSettings with the specified Rule name within the specified Front Door.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   loadBalancingSettingsName: string (required)
  ##                            : Name of the load balancing settings which is unique within the Front Door.
  ##   loadBalancingSettingsParameters: JObject (required)
  ##                                  : LoadBalancingSettings properties needed to create a new Front Door.
  ##   frontDoorName: string (required)
  ##                : Name of the Front Door which is globally unique.
  var path_594248 = newJObject()
  var query_594249 = newJObject()
  var body_594250 = newJObject()
  add(path_594248, "resourceGroupName", newJString(resourceGroupName))
  add(query_594249, "api-version", newJString(apiVersion))
  add(path_594248, "subscriptionId", newJString(subscriptionId))
  add(path_594248, "loadBalancingSettingsName",
      newJString(loadBalancingSettingsName))
  if loadBalancingSettingsParameters != nil:
    body_594250 = loadBalancingSettingsParameters
  add(path_594248, "frontDoorName", newJString(frontDoorName))
  result = call_594247.call(path_594248, query_594249, nil, nil, body_594250)

var loadBalancingSettingsCreateOrUpdate* = Call_LoadBalancingSettingsCreateOrUpdate_594237(
    name: "loadBalancingSettingsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/frontDoors/{frontDoorName}/loadBalancingSettings/{loadBalancingSettingsName}",
    validator: validate_LoadBalancingSettingsCreateOrUpdate_594238, base: "",
    url: url_LoadBalancingSettingsCreateOrUpdate_594239, schemes: {Scheme.Https})
type
  Call_LoadBalancingSettingsGet_594225 = ref object of OpenApiRestCall_593425
proc url_LoadBalancingSettingsGet_594227(protocol: Scheme; host: string;
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
  assert "loadBalancingSettingsName" in path,
        "`loadBalancingSettingsName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Network/frontDoors/"),
               (kind: VariableSegment, value: "frontDoorName"),
               (kind: ConstantSegment, value: "/loadBalancingSettings/"),
               (kind: VariableSegment, value: "loadBalancingSettingsName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LoadBalancingSettingsGet_594226(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a LoadBalancingSettings with the specified Rule name within the specified Front Door.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   loadBalancingSettingsName: JString (required)
  ##                            : Name of the load balancing settings which is unique within the Front Door.
  ##   frontDoorName: JString (required)
  ##                : Name of the Front Door which is globally unique.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594228 = path.getOrDefault("resourceGroupName")
  valid_594228 = validateParameter(valid_594228, JString, required = true,
                                 default = nil)
  if valid_594228 != nil:
    section.add "resourceGroupName", valid_594228
  var valid_594229 = path.getOrDefault("subscriptionId")
  valid_594229 = validateParameter(valid_594229, JString, required = true,
                                 default = nil)
  if valid_594229 != nil:
    section.add "subscriptionId", valid_594229
  var valid_594230 = path.getOrDefault("loadBalancingSettingsName")
  valid_594230 = validateParameter(valid_594230, JString, required = true,
                                 default = nil)
  if valid_594230 != nil:
    section.add "loadBalancingSettingsName", valid_594230
  var valid_594231 = path.getOrDefault("frontDoorName")
  valid_594231 = validateParameter(valid_594231, JString, required = true,
                                 default = nil)
  if valid_594231 != nil:
    section.add "frontDoorName", valid_594231
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594232 = query.getOrDefault("api-version")
  valid_594232 = validateParameter(valid_594232, JString, required = true,
                                 default = nil)
  if valid_594232 != nil:
    section.add "api-version", valid_594232
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594233: Call_LoadBalancingSettingsGet_594225; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a LoadBalancingSettings with the specified Rule name within the specified Front Door.
  ## 
  let valid = call_594233.validator(path, query, header, formData, body)
  let scheme = call_594233.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594233.url(scheme.get, call_594233.host, call_594233.base,
                         call_594233.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594233, url, valid)

proc call*(call_594234: Call_LoadBalancingSettingsGet_594225;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          loadBalancingSettingsName: string; frontDoorName: string): Recallable =
  ## loadBalancingSettingsGet
  ## Gets a LoadBalancingSettings with the specified Rule name within the specified Front Door.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   loadBalancingSettingsName: string (required)
  ##                            : Name of the load balancing settings which is unique within the Front Door.
  ##   frontDoorName: string (required)
  ##                : Name of the Front Door which is globally unique.
  var path_594235 = newJObject()
  var query_594236 = newJObject()
  add(path_594235, "resourceGroupName", newJString(resourceGroupName))
  add(query_594236, "api-version", newJString(apiVersion))
  add(path_594235, "subscriptionId", newJString(subscriptionId))
  add(path_594235, "loadBalancingSettingsName",
      newJString(loadBalancingSettingsName))
  add(path_594235, "frontDoorName", newJString(frontDoorName))
  result = call_594234.call(path_594235, query_594236, nil, nil, nil)

var loadBalancingSettingsGet* = Call_LoadBalancingSettingsGet_594225(
    name: "loadBalancingSettingsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/frontDoors/{frontDoorName}/loadBalancingSettings/{loadBalancingSettingsName}",
    validator: validate_LoadBalancingSettingsGet_594226, base: "",
    url: url_LoadBalancingSettingsGet_594227, schemes: {Scheme.Https})
type
  Call_LoadBalancingSettingsDelete_594251 = ref object of OpenApiRestCall_593425
proc url_LoadBalancingSettingsDelete_594253(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "frontDoorName" in path, "`frontDoorName` is a required path parameter"
  assert "loadBalancingSettingsName" in path,
        "`loadBalancingSettingsName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Network/frontDoors/"),
               (kind: VariableSegment, value: "frontDoorName"),
               (kind: ConstantSegment, value: "/loadBalancingSettings/"),
               (kind: VariableSegment, value: "loadBalancingSettingsName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LoadBalancingSettingsDelete_594252(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes an existing LoadBalancingSettings with the specified parameters.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   loadBalancingSettingsName: JString (required)
  ##                            : Name of the load balancing settings which is unique within the Front Door.
  ##   frontDoorName: JString (required)
  ##                : Name of the Front Door which is globally unique.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594254 = path.getOrDefault("resourceGroupName")
  valid_594254 = validateParameter(valid_594254, JString, required = true,
                                 default = nil)
  if valid_594254 != nil:
    section.add "resourceGroupName", valid_594254
  var valid_594255 = path.getOrDefault("subscriptionId")
  valid_594255 = validateParameter(valid_594255, JString, required = true,
                                 default = nil)
  if valid_594255 != nil:
    section.add "subscriptionId", valid_594255
  var valid_594256 = path.getOrDefault("loadBalancingSettingsName")
  valid_594256 = validateParameter(valid_594256, JString, required = true,
                                 default = nil)
  if valid_594256 != nil:
    section.add "loadBalancingSettingsName", valid_594256
  var valid_594257 = path.getOrDefault("frontDoorName")
  valid_594257 = validateParameter(valid_594257, JString, required = true,
                                 default = nil)
  if valid_594257 != nil:
    section.add "frontDoorName", valid_594257
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594258 = query.getOrDefault("api-version")
  valid_594258 = validateParameter(valid_594258, JString, required = true,
                                 default = nil)
  if valid_594258 != nil:
    section.add "api-version", valid_594258
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594259: Call_LoadBalancingSettingsDelete_594251; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an existing LoadBalancingSettings with the specified parameters.
  ## 
  let valid = call_594259.validator(path, query, header, formData, body)
  let scheme = call_594259.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594259.url(scheme.get, call_594259.host, call_594259.base,
                         call_594259.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594259, url, valid)

proc call*(call_594260: Call_LoadBalancingSettingsDelete_594251;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          loadBalancingSettingsName: string; frontDoorName: string): Recallable =
  ## loadBalancingSettingsDelete
  ## Deletes an existing LoadBalancingSettings with the specified parameters.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   loadBalancingSettingsName: string (required)
  ##                            : Name of the load balancing settings which is unique within the Front Door.
  ##   frontDoorName: string (required)
  ##                : Name of the Front Door which is globally unique.
  var path_594261 = newJObject()
  var query_594262 = newJObject()
  add(path_594261, "resourceGroupName", newJString(resourceGroupName))
  add(query_594262, "api-version", newJString(apiVersion))
  add(path_594261, "subscriptionId", newJString(subscriptionId))
  add(path_594261, "loadBalancingSettingsName",
      newJString(loadBalancingSettingsName))
  add(path_594261, "frontDoorName", newJString(frontDoorName))
  result = call_594260.call(path_594261, query_594262, nil, nil, nil)

var loadBalancingSettingsDelete* = Call_LoadBalancingSettingsDelete_594251(
    name: "loadBalancingSettingsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/frontDoors/{frontDoorName}/loadBalancingSettings/{loadBalancingSettingsName}",
    validator: validate_LoadBalancingSettingsDelete_594252, base: "",
    url: url_LoadBalancingSettingsDelete_594253, schemes: {Scheme.Https})
type
  Call_EndpointsPurgeContent_594263 = ref object of OpenApiRestCall_593425
proc url_EndpointsPurgeContent_594265(protocol: Scheme; host: string; base: string;
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

proc validate_EndpointsPurgeContent_594264(path: JsonNode; query: JsonNode;
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
  var valid_594266 = path.getOrDefault("resourceGroupName")
  valid_594266 = validateParameter(valid_594266, JString, required = true,
                                 default = nil)
  if valid_594266 != nil:
    section.add "resourceGroupName", valid_594266
  var valid_594267 = path.getOrDefault("subscriptionId")
  valid_594267 = validateParameter(valid_594267, JString, required = true,
                                 default = nil)
  if valid_594267 != nil:
    section.add "subscriptionId", valid_594267
  var valid_594268 = path.getOrDefault("frontDoorName")
  valid_594268 = validateParameter(valid_594268, JString, required = true,
                                 default = nil)
  if valid_594268 != nil:
    section.add "frontDoorName", valid_594268
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594269 = query.getOrDefault("api-version")
  valid_594269 = validateParameter(valid_594269, JString, required = true,
                                 default = nil)
  if valid_594269 != nil:
    section.add "api-version", valid_594269
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

proc call*(call_594271: Call_EndpointsPurgeContent_594263; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Removes a content from Front Door.
  ## 
  let valid = call_594271.validator(path, query, header, formData, body)
  let scheme = call_594271.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594271.url(scheme.get, call_594271.host, call_594271.base,
                         call_594271.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594271, url, valid)

proc call*(call_594272: Call_EndpointsPurgeContent_594263;
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
  var path_594273 = newJObject()
  var query_594274 = newJObject()
  var body_594275 = newJObject()
  add(path_594273, "resourceGroupName", newJString(resourceGroupName))
  if contentFilePaths != nil:
    body_594275 = contentFilePaths
  add(query_594274, "api-version", newJString(apiVersion))
  add(path_594273, "subscriptionId", newJString(subscriptionId))
  add(path_594273, "frontDoorName", newJString(frontDoorName))
  result = call_594272.call(path_594273, query_594274, nil, nil, body_594275)

var endpointsPurgeContent* = Call_EndpointsPurgeContent_594263(
    name: "endpointsPurgeContent", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/frontDoors/{frontDoorName}/purge",
    validator: validate_EndpointsPurgeContent_594264, base: "",
    url: url_EndpointsPurgeContent_594265, schemes: {Scheme.Https})
type
  Call_RoutingRulesListByFrontDoor_594276 = ref object of OpenApiRestCall_593425
proc url_RoutingRulesListByFrontDoor_594278(protocol: Scheme; host: string;
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
               (kind: ConstantSegment, value: "/routingRules")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RoutingRulesListByFrontDoor_594277(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all of the Routing Rules within a Front Door.
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
  var valid_594279 = path.getOrDefault("resourceGroupName")
  valid_594279 = validateParameter(valid_594279, JString, required = true,
                                 default = nil)
  if valid_594279 != nil:
    section.add "resourceGroupName", valid_594279
  var valid_594280 = path.getOrDefault("subscriptionId")
  valid_594280 = validateParameter(valid_594280, JString, required = true,
                                 default = nil)
  if valid_594280 != nil:
    section.add "subscriptionId", valid_594280
  var valid_594281 = path.getOrDefault("frontDoorName")
  valid_594281 = validateParameter(valid_594281, JString, required = true,
                                 default = nil)
  if valid_594281 != nil:
    section.add "frontDoorName", valid_594281
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594282 = query.getOrDefault("api-version")
  valid_594282 = validateParameter(valid_594282, JString, required = true,
                                 default = nil)
  if valid_594282 != nil:
    section.add "api-version", valid_594282
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594283: Call_RoutingRulesListByFrontDoor_594276; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the Routing Rules within a Front Door.
  ## 
  let valid = call_594283.validator(path, query, header, formData, body)
  let scheme = call_594283.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594283.url(scheme.get, call_594283.host, call_594283.base,
                         call_594283.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594283, url, valid)

proc call*(call_594284: Call_RoutingRulesListByFrontDoor_594276;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          frontDoorName: string): Recallable =
  ## routingRulesListByFrontDoor
  ## Lists all of the Routing Rules within a Front Door.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   frontDoorName: string (required)
  ##                : Name of the Front Door which is globally unique.
  var path_594285 = newJObject()
  var query_594286 = newJObject()
  add(path_594285, "resourceGroupName", newJString(resourceGroupName))
  add(query_594286, "api-version", newJString(apiVersion))
  add(path_594285, "subscriptionId", newJString(subscriptionId))
  add(path_594285, "frontDoorName", newJString(frontDoorName))
  result = call_594284.call(path_594285, query_594286, nil, nil, nil)

var routingRulesListByFrontDoor* = Call_RoutingRulesListByFrontDoor_594276(
    name: "routingRulesListByFrontDoor", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/frontDoors/{frontDoorName}/routingRules",
    validator: validate_RoutingRulesListByFrontDoor_594277, base: "",
    url: url_RoutingRulesListByFrontDoor_594278, schemes: {Scheme.Https})
type
  Call_RoutingRulesCreateOrUpdate_594299 = ref object of OpenApiRestCall_593425
proc url_RoutingRulesCreateOrUpdate_594301(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "frontDoorName" in path, "`frontDoorName` is a required path parameter"
  assert "routingRuleName" in path, "`routingRuleName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Network/frontDoors/"),
               (kind: VariableSegment, value: "frontDoorName"),
               (kind: ConstantSegment, value: "/routingRules/"),
               (kind: VariableSegment, value: "routingRuleName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RoutingRulesCreateOrUpdate_594300(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a new Routing Rule with the specified Rule name within the specified Front Door.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   routingRuleName: JString (required)
  ##                  : Name of the Routing Rule which is unique within the Front Door.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   frontDoorName: JString (required)
  ##                : Name of the Front Door which is globally unique.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594302 = path.getOrDefault("resourceGroupName")
  valid_594302 = validateParameter(valid_594302, JString, required = true,
                                 default = nil)
  if valid_594302 != nil:
    section.add "resourceGroupName", valid_594302
  var valid_594303 = path.getOrDefault("routingRuleName")
  valid_594303 = validateParameter(valid_594303, JString, required = true,
                                 default = nil)
  if valid_594303 != nil:
    section.add "routingRuleName", valid_594303
  var valid_594304 = path.getOrDefault("subscriptionId")
  valid_594304 = validateParameter(valid_594304, JString, required = true,
                                 default = nil)
  if valid_594304 != nil:
    section.add "subscriptionId", valid_594304
  var valid_594305 = path.getOrDefault("frontDoorName")
  valid_594305 = validateParameter(valid_594305, JString, required = true,
                                 default = nil)
  if valid_594305 != nil:
    section.add "frontDoorName", valid_594305
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594306 = query.getOrDefault("api-version")
  valid_594306 = validateParameter(valid_594306, JString, required = true,
                                 default = nil)
  if valid_594306 != nil:
    section.add "api-version", valid_594306
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   routingRuleParameters: JObject (required)
  ##                        : Routing Rule properties needed to create a new Front Door.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594308: Call_RoutingRulesCreateOrUpdate_594299; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new Routing Rule with the specified Rule name within the specified Front Door.
  ## 
  let valid = call_594308.validator(path, query, header, formData, body)
  let scheme = call_594308.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594308.url(scheme.get, call_594308.host, call_594308.base,
                         call_594308.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594308, url, valid)

proc call*(call_594309: Call_RoutingRulesCreateOrUpdate_594299;
          routingRuleParameters: JsonNode; resourceGroupName: string;
          apiVersion: string; routingRuleName: string; subscriptionId: string;
          frontDoorName: string): Recallable =
  ## routingRulesCreateOrUpdate
  ## Creates a new Routing Rule with the specified Rule name within the specified Front Door.
  ##   routingRuleParameters: JObject (required)
  ##                        : Routing Rule properties needed to create a new Front Door.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   routingRuleName: string (required)
  ##                  : Name of the Routing Rule which is unique within the Front Door.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   frontDoorName: string (required)
  ##                : Name of the Front Door which is globally unique.
  var path_594310 = newJObject()
  var query_594311 = newJObject()
  var body_594312 = newJObject()
  if routingRuleParameters != nil:
    body_594312 = routingRuleParameters
  add(path_594310, "resourceGroupName", newJString(resourceGroupName))
  add(query_594311, "api-version", newJString(apiVersion))
  add(path_594310, "routingRuleName", newJString(routingRuleName))
  add(path_594310, "subscriptionId", newJString(subscriptionId))
  add(path_594310, "frontDoorName", newJString(frontDoorName))
  result = call_594309.call(path_594310, query_594311, nil, nil, body_594312)

var routingRulesCreateOrUpdate* = Call_RoutingRulesCreateOrUpdate_594299(
    name: "routingRulesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/frontDoors/{frontDoorName}/routingRules/{routingRuleName}",
    validator: validate_RoutingRulesCreateOrUpdate_594300, base: "",
    url: url_RoutingRulesCreateOrUpdate_594301, schemes: {Scheme.Https})
type
  Call_RoutingRulesGet_594287 = ref object of OpenApiRestCall_593425
proc url_RoutingRulesGet_594289(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "frontDoorName" in path, "`frontDoorName` is a required path parameter"
  assert "routingRuleName" in path, "`routingRuleName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Network/frontDoors/"),
               (kind: VariableSegment, value: "frontDoorName"),
               (kind: ConstantSegment, value: "/routingRules/"),
               (kind: VariableSegment, value: "routingRuleName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RoutingRulesGet_594288(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Gets a Routing Rule with the specified Rule name within the specified Front Door.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   routingRuleName: JString (required)
  ##                  : Name of the Routing Rule which is unique within the Front Door.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   frontDoorName: JString (required)
  ##                : Name of the Front Door which is globally unique.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594290 = path.getOrDefault("resourceGroupName")
  valid_594290 = validateParameter(valid_594290, JString, required = true,
                                 default = nil)
  if valid_594290 != nil:
    section.add "resourceGroupName", valid_594290
  var valid_594291 = path.getOrDefault("routingRuleName")
  valid_594291 = validateParameter(valid_594291, JString, required = true,
                                 default = nil)
  if valid_594291 != nil:
    section.add "routingRuleName", valid_594291
  var valid_594292 = path.getOrDefault("subscriptionId")
  valid_594292 = validateParameter(valid_594292, JString, required = true,
                                 default = nil)
  if valid_594292 != nil:
    section.add "subscriptionId", valid_594292
  var valid_594293 = path.getOrDefault("frontDoorName")
  valid_594293 = validateParameter(valid_594293, JString, required = true,
                                 default = nil)
  if valid_594293 != nil:
    section.add "frontDoorName", valid_594293
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594294 = query.getOrDefault("api-version")
  valid_594294 = validateParameter(valid_594294, JString, required = true,
                                 default = nil)
  if valid_594294 != nil:
    section.add "api-version", valid_594294
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594295: Call_RoutingRulesGet_594287; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a Routing Rule with the specified Rule name within the specified Front Door.
  ## 
  let valid = call_594295.validator(path, query, header, formData, body)
  let scheme = call_594295.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594295.url(scheme.get, call_594295.host, call_594295.base,
                         call_594295.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594295, url, valid)

proc call*(call_594296: Call_RoutingRulesGet_594287; resourceGroupName: string;
          apiVersion: string; routingRuleName: string; subscriptionId: string;
          frontDoorName: string): Recallable =
  ## routingRulesGet
  ## Gets a Routing Rule with the specified Rule name within the specified Front Door.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   routingRuleName: string (required)
  ##                  : Name of the Routing Rule which is unique within the Front Door.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   frontDoorName: string (required)
  ##                : Name of the Front Door which is globally unique.
  var path_594297 = newJObject()
  var query_594298 = newJObject()
  add(path_594297, "resourceGroupName", newJString(resourceGroupName))
  add(query_594298, "api-version", newJString(apiVersion))
  add(path_594297, "routingRuleName", newJString(routingRuleName))
  add(path_594297, "subscriptionId", newJString(subscriptionId))
  add(path_594297, "frontDoorName", newJString(frontDoorName))
  result = call_594296.call(path_594297, query_594298, nil, nil, nil)

var routingRulesGet* = Call_RoutingRulesGet_594287(name: "routingRulesGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/frontDoors/{frontDoorName}/routingRules/{routingRuleName}",
    validator: validate_RoutingRulesGet_594288, base: "", url: url_RoutingRulesGet_594289,
    schemes: {Scheme.Https})
type
  Call_RoutingRulesDelete_594313 = ref object of OpenApiRestCall_593425
proc url_RoutingRulesDelete_594315(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "frontDoorName" in path, "`frontDoorName` is a required path parameter"
  assert "routingRuleName" in path, "`routingRuleName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Network/frontDoors/"),
               (kind: VariableSegment, value: "frontDoorName"),
               (kind: ConstantSegment, value: "/routingRules/"),
               (kind: VariableSegment, value: "routingRuleName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RoutingRulesDelete_594314(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Deletes an existing Routing Rule with the specified parameters.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   routingRuleName: JString (required)
  ##                  : Name of the Routing Rule which is unique within the Front Door.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   frontDoorName: JString (required)
  ##                : Name of the Front Door which is globally unique.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594316 = path.getOrDefault("resourceGroupName")
  valid_594316 = validateParameter(valid_594316, JString, required = true,
                                 default = nil)
  if valid_594316 != nil:
    section.add "resourceGroupName", valid_594316
  var valid_594317 = path.getOrDefault("routingRuleName")
  valid_594317 = validateParameter(valid_594317, JString, required = true,
                                 default = nil)
  if valid_594317 != nil:
    section.add "routingRuleName", valid_594317
  var valid_594318 = path.getOrDefault("subscriptionId")
  valid_594318 = validateParameter(valid_594318, JString, required = true,
                                 default = nil)
  if valid_594318 != nil:
    section.add "subscriptionId", valid_594318
  var valid_594319 = path.getOrDefault("frontDoorName")
  valid_594319 = validateParameter(valid_594319, JString, required = true,
                                 default = nil)
  if valid_594319 != nil:
    section.add "frontDoorName", valid_594319
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594320 = query.getOrDefault("api-version")
  valid_594320 = validateParameter(valid_594320, JString, required = true,
                                 default = nil)
  if valid_594320 != nil:
    section.add "api-version", valid_594320
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594321: Call_RoutingRulesDelete_594313; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an existing Routing Rule with the specified parameters.
  ## 
  let valid = call_594321.validator(path, query, header, formData, body)
  let scheme = call_594321.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594321.url(scheme.get, call_594321.host, call_594321.base,
                         call_594321.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594321, url, valid)

proc call*(call_594322: Call_RoutingRulesDelete_594313; resourceGroupName: string;
          apiVersion: string; routingRuleName: string; subscriptionId: string;
          frontDoorName: string): Recallable =
  ## routingRulesDelete
  ## Deletes an existing Routing Rule with the specified parameters.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   routingRuleName: string (required)
  ##                  : Name of the Routing Rule which is unique within the Front Door.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   frontDoorName: string (required)
  ##                : Name of the Front Door which is globally unique.
  var path_594323 = newJObject()
  var query_594324 = newJObject()
  add(path_594323, "resourceGroupName", newJString(resourceGroupName))
  add(query_594324, "api-version", newJString(apiVersion))
  add(path_594323, "routingRuleName", newJString(routingRuleName))
  add(path_594323, "subscriptionId", newJString(subscriptionId))
  add(path_594323, "frontDoorName", newJString(frontDoorName))
  result = call_594322.call(path_594323, query_594324, nil, nil, nil)

var routingRulesDelete* = Call_RoutingRulesDelete_594313(
    name: "routingRulesDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/frontDoors/{frontDoorName}/routingRules/{routingRuleName}",
    validator: validate_RoutingRulesDelete_594314, base: "",
    url: url_RoutingRulesDelete_594315, schemes: {Scheme.Https})
type
  Call_FrontDoorsValidateCustomDomain_594325 = ref object of OpenApiRestCall_593425
proc url_FrontDoorsValidateCustomDomain_594327(protocol: Scheme; host: string;
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

proc validate_FrontDoorsValidateCustomDomain_594326(path: JsonNode;
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
  var valid_594328 = path.getOrDefault("resourceGroupName")
  valid_594328 = validateParameter(valid_594328, JString, required = true,
                                 default = nil)
  if valid_594328 != nil:
    section.add "resourceGroupName", valid_594328
  var valid_594329 = path.getOrDefault("subscriptionId")
  valid_594329 = validateParameter(valid_594329, JString, required = true,
                                 default = nil)
  if valid_594329 != nil:
    section.add "subscriptionId", valid_594329
  var valid_594330 = path.getOrDefault("frontDoorName")
  valid_594330 = validateParameter(valid_594330, JString, required = true,
                                 default = nil)
  if valid_594330 != nil:
    section.add "frontDoorName", valid_594330
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594331 = query.getOrDefault("api-version")
  valid_594331 = validateParameter(valid_594331, JString, required = true,
                                 default = nil)
  if valid_594331 != nil:
    section.add "api-version", valid_594331
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

proc call*(call_594333: Call_FrontDoorsValidateCustomDomain_594325; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Validates the custom domain mapping to ensure it maps to the correct Front Door endpoint in DNS.
  ## 
  let valid = call_594333.validator(path, query, header, formData, body)
  let scheme = call_594333.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594333.url(scheme.get, call_594333.host, call_594333.base,
                         call_594333.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594333, url, valid)

proc call*(call_594334: Call_FrontDoorsValidateCustomDomain_594325;
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
  var path_594335 = newJObject()
  var query_594336 = newJObject()
  var body_594337 = newJObject()
  add(path_594335, "resourceGroupName", newJString(resourceGroupName))
  add(query_594336, "api-version", newJString(apiVersion))
  if customDomainProperties != nil:
    body_594337 = customDomainProperties
  add(path_594335, "subscriptionId", newJString(subscriptionId))
  add(path_594335, "frontDoorName", newJString(frontDoorName))
  result = call_594334.call(path_594335, query_594336, nil, nil, body_594337)

var frontDoorsValidateCustomDomain* = Call_FrontDoorsValidateCustomDomain_594325(
    name: "frontDoorsValidateCustomDomain", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/frontDoors/{frontDoorName}/validateCustomDomain",
    validator: validate_FrontDoorsValidateCustomDomain_594326, base: "",
    url: url_FrontDoorsValidateCustomDomain_594327, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
