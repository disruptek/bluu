
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: TrafficManagerManagementClient
## version: 2017-05-01
## termsOfService: (not provided)
## license: (not provided)
## 
## 
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

  OpenApiRestCall_567658 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_567658](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_567658): Option[Scheme] {.used.} =
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
  macServiceName = "trafficmanager"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_ProfilesCheckTrafficManagerRelativeDnsNameAvailability_567880 = ref object of OpenApiRestCall_567658
proc url_ProfilesCheckTrafficManagerRelativeDnsNameAvailability_567882(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_ProfilesCheckTrafficManagerRelativeDnsNameAvailability_567881(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Checks the availability of a Traffic Manager Relative DNS name.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568058 = query.getOrDefault("api-version")
  valid_568058 = validateParameter(valid_568058, JString, required = true,
                                 default = nil)
  if valid_568058 != nil:
    section.add "api-version", valid_568058
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The Traffic Manager name parameters supplied to the CheckTrafficManagerNameAvailability operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568082: Call_ProfilesCheckTrafficManagerRelativeDnsNameAvailability_567880;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Checks the availability of a Traffic Manager Relative DNS name.
  ## 
  let valid = call_568082.validator(path, query, header, formData, body)
  let scheme = call_568082.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568082.url(scheme.get, call_568082.host, call_568082.base,
                         call_568082.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568082, url, valid)

proc call*(call_568153: Call_ProfilesCheckTrafficManagerRelativeDnsNameAvailability_567880;
          apiVersion: string; parameters: JsonNode): Recallable =
  ## profilesCheckTrafficManagerRelativeDnsNameAvailability
  ## Checks the availability of a Traffic Manager Relative DNS name.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   parameters: JObject (required)
  ##             : The Traffic Manager name parameters supplied to the CheckTrafficManagerNameAvailability operation.
  var query_568154 = newJObject()
  var body_568156 = newJObject()
  add(query_568154, "api-version", newJString(apiVersion))
  if parameters != nil:
    body_568156 = parameters
  result = call_568153.call(nil, query_568154, nil, nil, body_568156)

var profilesCheckTrafficManagerRelativeDnsNameAvailability* = Call_ProfilesCheckTrafficManagerRelativeDnsNameAvailability_567880(
    name: "profilesCheckTrafficManagerRelativeDnsNameAvailability",
    meth: HttpMethod.HttpPost, host: "management.azure.com",
    route: "/providers/Microsoft.Network/checkTrafficManagerNameAvailability",
    validator: validate_ProfilesCheckTrafficManagerRelativeDnsNameAvailability_567881,
    base: "", url: url_ProfilesCheckTrafficManagerRelativeDnsNameAvailability_567882,
    schemes: {Scheme.Https})
type
  Call_GeographicHierarchiesGetDefault_568195 = ref object of OpenApiRestCall_567658
proc url_GeographicHierarchiesGetDefault_568197(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_GeographicHierarchiesGetDefault_568196(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the default Geographic Hierarchy used by the Geographic traffic routing method.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568198 = query.getOrDefault("api-version")
  valid_568198 = validateParameter(valid_568198, JString, required = true,
                                 default = nil)
  if valid_568198 != nil:
    section.add "api-version", valid_568198
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568199: Call_GeographicHierarchiesGetDefault_568195;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the default Geographic Hierarchy used by the Geographic traffic routing method.
  ## 
  let valid = call_568199.validator(path, query, header, formData, body)
  let scheme = call_568199.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568199.url(scheme.get, call_568199.host, call_568199.base,
                         call_568199.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568199, url, valid)

proc call*(call_568200: Call_GeographicHierarchiesGetDefault_568195;
          apiVersion: string): Recallable =
  ## geographicHierarchiesGetDefault
  ## Gets the default Geographic Hierarchy used by the Geographic traffic routing method.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  var query_568201 = newJObject()
  add(query_568201, "api-version", newJString(apiVersion))
  result = call_568200.call(nil, query_568201, nil, nil, nil)

var geographicHierarchiesGetDefault* = Call_GeographicHierarchiesGetDefault_568195(
    name: "geographicHierarchiesGetDefault", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Network/trafficManagerGeographicHierarchies/default",
    validator: validate_GeographicHierarchiesGetDefault_568196, base: "",
    url: url_GeographicHierarchiesGetDefault_568197, schemes: {Scheme.Https})
type
  Call_ProfilesListBySubscription_568202 = ref object of OpenApiRestCall_567658
proc url_ProfilesListBySubscription_568204(protocol: Scheme; host: string;
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
        value: "/providers/Microsoft.Network/trafficmanagerprofiles")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProfilesListBySubscription_568203(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all Traffic Manager profiles within a subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568219 = path.getOrDefault("subscriptionId")
  valid_568219 = validateParameter(valid_568219, JString, required = true,
                                 default = nil)
  if valid_568219 != nil:
    section.add "subscriptionId", valid_568219
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568220 = query.getOrDefault("api-version")
  valid_568220 = validateParameter(valid_568220, JString, required = true,
                                 default = nil)
  if valid_568220 != nil:
    section.add "api-version", valid_568220
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568221: Call_ProfilesListBySubscription_568202; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all Traffic Manager profiles within a subscription.
  ## 
  let valid = call_568221.validator(path, query, header, formData, body)
  let scheme = call_568221.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568221.url(scheme.get, call_568221.host, call_568221.base,
                         call_568221.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568221, url, valid)

proc call*(call_568222: Call_ProfilesListBySubscription_568202; apiVersion: string;
          subscriptionId: string): Recallable =
  ## profilesListBySubscription
  ## Lists all Traffic Manager profiles within a subscription.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568223 = newJObject()
  var query_568224 = newJObject()
  add(query_568224, "api-version", newJString(apiVersion))
  add(path_568223, "subscriptionId", newJString(subscriptionId))
  result = call_568222.call(path_568223, query_568224, nil, nil, nil)

var profilesListBySubscription* = Call_ProfilesListBySubscription_568202(
    name: "profilesListBySubscription", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Network/trafficmanagerprofiles",
    validator: validate_ProfilesListBySubscription_568203, base: "",
    url: url_ProfilesListBySubscription_568204, schemes: {Scheme.Https})
type
  Call_ProfilesListByResourceGroup_568225 = ref object of OpenApiRestCall_567658
proc url_ProfilesListByResourceGroup_568227(protocol: Scheme; host: string;
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
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/trafficmanagerprofiles")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProfilesListByResourceGroup_568226(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all Traffic Manager profiles within a resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group containing the Traffic Manager profiles to be listed.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568228 = path.getOrDefault("resourceGroupName")
  valid_568228 = validateParameter(valid_568228, JString, required = true,
                                 default = nil)
  if valid_568228 != nil:
    section.add "resourceGroupName", valid_568228
  var valid_568229 = path.getOrDefault("subscriptionId")
  valid_568229 = validateParameter(valid_568229, JString, required = true,
                                 default = nil)
  if valid_568229 != nil:
    section.add "subscriptionId", valid_568229
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568230 = query.getOrDefault("api-version")
  valid_568230 = validateParameter(valid_568230, JString, required = true,
                                 default = nil)
  if valid_568230 != nil:
    section.add "api-version", valid_568230
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568231: Call_ProfilesListByResourceGroup_568225; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all Traffic Manager profiles within a resource group.
  ## 
  let valid = call_568231.validator(path, query, header, formData, body)
  let scheme = call_568231.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568231.url(scheme.get, call_568231.host, call_568231.base,
                         call_568231.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568231, url, valid)

proc call*(call_568232: Call_ProfilesListByResourceGroup_568225;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## profilesListByResourceGroup
  ## Lists all Traffic Manager profiles within a resource group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group containing the Traffic Manager profiles to be listed.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568233 = newJObject()
  var query_568234 = newJObject()
  add(path_568233, "resourceGroupName", newJString(resourceGroupName))
  add(query_568234, "api-version", newJString(apiVersion))
  add(path_568233, "subscriptionId", newJString(subscriptionId))
  result = call_568232.call(path_568233, query_568234, nil, nil, nil)

var profilesListByResourceGroup* = Call_ProfilesListByResourceGroup_568225(
    name: "profilesListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/trafficmanagerprofiles",
    validator: validate_ProfilesListByResourceGroup_568226, base: "",
    url: url_ProfilesListByResourceGroup_568227, schemes: {Scheme.Https})
type
  Call_ProfilesCreateOrUpdate_568246 = ref object of OpenApiRestCall_567658
proc url_ProfilesCreateOrUpdate_568248(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "profileName" in path, "`profileName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/trafficmanagerprofiles/"),
               (kind: VariableSegment, value: "profileName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProfilesCreateOrUpdate_568247(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or update a Traffic Manager profile.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group containing the Traffic Manager profile.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   profileName: JString (required)
  ##              : The name of the Traffic Manager profile.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568249 = path.getOrDefault("resourceGroupName")
  valid_568249 = validateParameter(valid_568249, JString, required = true,
                                 default = nil)
  if valid_568249 != nil:
    section.add "resourceGroupName", valid_568249
  var valid_568250 = path.getOrDefault("subscriptionId")
  valid_568250 = validateParameter(valid_568250, JString, required = true,
                                 default = nil)
  if valid_568250 != nil:
    section.add "subscriptionId", valid_568250
  var valid_568251 = path.getOrDefault("profileName")
  valid_568251 = validateParameter(valid_568251, JString, required = true,
                                 default = nil)
  if valid_568251 != nil:
    section.add "profileName", valid_568251
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568252 = query.getOrDefault("api-version")
  valid_568252 = validateParameter(valid_568252, JString, required = true,
                                 default = nil)
  if valid_568252 != nil:
    section.add "api-version", valid_568252
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The Traffic Manager profile parameters supplied to the CreateOrUpdate operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568254: Call_ProfilesCreateOrUpdate_568246; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or update a Traffic Manager profile.
  ## 
  let valid = call_568254.validator(path, query, header, formData, body)
  let scheme = call_568254.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568254.url(scheme.get, call_568254.host, call_568254.base,
                         call_568254.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568254, url, valid)

proc call*(call_568255: Call_ProfilesCreateOrUpdate_568246;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          profileName: string; parameters: JsonNode): Recallable =
  ## profilesCreateOrUpdate
  ## Create or update a Traffic Manager profile.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group containing the Traffic Manager profile.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   profileName: string (required)
  ##              : The name of the Traffic Manager profile.
  ##   parameters: JObject (required)
  ##             : The Traffic Manager profile parameters supplied to the CreateOrUpdate operation.
  var path_568256 = newJObject()
  var query_568257 = newJObject()
  var body_568258 = newJObject()
  add(path_568256, "resourceGroupName", newJString(resourceGroupName))
  add(query_568257, "api-version", newJString(apiVersion))
  add(path_568256, "subscriptionId", newJString(subscriptionId))
  add(path_568256, "profileName", newJString(profileName))
  if parameters != nil:
    body_568258 = parameters
  result = call_568255.call(path_568256, query_568257, nil, nil, body_568258)

var profilesCreateOrUpdate* = Call_ProfilesCreateOrUpdate_568246(
    name: "profilesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/trafficmanagerprofiles/{profileName}",
    validator: validate_ProfilesCreateOrUpdate_568247, base: "",
    url: url_ProfilesCreateOrUpdate_568248, schemes: {Scheme.Https})
type
  Call_ProfilesGet_568235 = ref object of OpenApiRestCall_567658
proc url_ProfilesGet_568237(protocol: Scheme; host: string; base: string;
                           route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "profileName" in path, "`profileName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/trafficmanagerprofiles/"),
               (kind: VariableSegment, value: "profileName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProfilesGet_568236(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a Traffic Manager profile.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group containing the Traffic Manager profile.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   profileName: JString (required)
  ##              : The name of the Traffic Manager profile.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568238 = path.getOrDefault("resourceGroupName")
  valid_568238 = validateParameter(valid_568238, JString, required = true,
                                 default = nil)
  if valid_568238 != nil:
    section.add "resourceGroupName", valid_568238
  var valid_568239 = path.getOrDefault("subscriptionId")
  valid_568239 = validateParameter(valid_568239, JString, required = true,
                                 default = nil)
  if valid_568239 != nil:
    section.add "subscriptionId", valid_568239
  var valid_568240 = path.getOrDefault("profileName")
  valid_568240 = validateParameter(valid_568240, JString, required = true,
                                 default = nil)
  if valid_568240 != nil:
    section.add "profileName", valid_568240
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568241 = query.getOrDefault("api-version")
  valid_568241 = validateParameter(valid_568241, JString, required = true,
                                 default = nil)
  if valid_568241 != nil:
    section.add "api-version", valid_568241
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568242: Call_ProfilesGet_568235; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a Traffic Manager profile.
  ## 
  let valid = call_568242.validator(path, query, header, formData, body)
  let scheme = call_568242.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568242.url(scheme.get, call_568242.host, call_568242.base,
                         call_568242.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568242, url, valid)

proc call*(call_568243: Call_ProfilesGet_568235; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; profileName: string): Recallable =
  ## profilesGet
  ## Gets a Traffic Manager profile.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group containing the Traffic Manager profile.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   profileName: string (required)
  ##              : The name of the Traffic Manager profile.
  var path_568244 = newJObject()
  var query_568245 = newJObject()
  add(path_568244, "resourceGroupName", newJString(resourceGroupName))
  add(query_568245, "api-version", newJString(apiVersion))
  add(path_568244, "subscriptionId", newJString(subscriptionId))
  add(path_568244, "profileName", newJString(profileName))
  result = call_568243.call(path_568244, query_568245, nil, nil, nil)

var profilesGet* = Call_ProfilesGet_568235(name: "profilesGet",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/trafficmanagerprofiles/{profileName}",
                                        validator: validate_ProfilesGet_568236,
                                        base: "", url: url_ProfilesGet_568237,
                                        schemes: {Scheme.Https})
type
  Call_ProfilesUpdate_568270 = ref object of OpenApiRestCall_567658
proc url_ProfilesUpdate_568272(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "profileName" in path, "`profileName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/trafficmanagerprofiles/"),
               (kind: VariableSegment, value: "profileName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProfilesUpdate_568271(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Update a Traffic Manager profile.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group containing the Traffic Manager profile.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   profileName: JString (required)
  ##              : The name of the Traffic Manager profile.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568273 = path.getOrDefault("resourceGroupName")
  valid_568273 = validateParameter(valid_568273, JString, required = true,
                                 default = nil)
  if valid_568273 != nil:
    section.add "resourceGroupName", valid_568273
  var valid_568274 = path.getOrDefault("subscriptionId")
  valid_568274 = validateParameter(valid_568274, JString, required = true,
                                 default = nil)
  if valid_568274 != nil:
    section.add "subscriptionId", valid_568274
  var valid_568275 = path.getOrDefault("profileName")
  valid_568275 = validateParameter(valid_568275, JString, required = true,
                                 default = nil)
  if valid_568275 != nil:
    section.add "profileName", valid_568275
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568276 = query.getOrDefault("api-version")
  valid_568276 = validateParameter(valid_568276, JString, required = true,
                                 default = nil)
  if valid_568276 != nil:
    section.add "api-version", valid_568276
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The Traffic Manager profile parameters supplied to the Update operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568278: Call_ProfilesUpdate_568270; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update a Traffic Manager profile.
  ## 
  let valid = call_568278.validator(path, query, header, formData, body)
  let scheme = call_568278.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568278.url(scheme.get, call_568278.host, call_568278.base,
                         call_568278.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568278, url, valid)

proc call*(call_568279: Call_ProfilesUpdate_568270; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; profileName: string;
          parameters: JsonNode): Recallable =
  ## profilesUpdate
  ## Update a Traffic Manager profile.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group containing the Traffic Manager profile.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   profileName: string (required)
  ##              : The name of the Traffic Manager profile.
  ##   parameters: JObject (required)
  ##             : The Traffic Manager profile parameters supplied to the Update operation.
  var path_568280 = newJObject()
  var query_568281 = newJObject()
  var body_568282 = newJObject()
  add(path_568280, "resourceGroupName", newJString(resourceGroupName))
  add(query_568281, "api-version", newJString(apiVersion))
  add(path_568280, "subscriptionId", newJString(subscriptionId))
  add(path_568280, "profileName", newJString(profileName))
  if parameters != nil:
    body_568282 = parameters
  result = call_568279.call(path_568280, query_568281, nil, nil, body_568282)

var profilesUpdate* = Call_ProfilesUpdate_568270(name: "profilesUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/trafficmanagerprofiles/{profileName}",
    validator: validate_ProfilesUpdate_568271, base: "", url: url_ProfilesUpdate_568272,
    schemes: {Scheme.Https})
type
  Call_ProfilesDelete_568259 = ref object of OpenApiRestCall_567658
proc url_ProfilesDelete_568261(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "profileName" in path, "`profileName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/trafficmanagerprofiles/"),
               (kind: VariableSegment, value: "profileName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProfilesDelete_568260(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Deletes a Traffic Manager profile.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group containing the Traffic Manager profile to be deleted.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   profileName: JString (required)
  ##              : The name of the Traffic Manager profile to be deleted.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568262 = path.getOrDefault("resourceGroupName")
  valid_568262 = validateParameter(valid_568262, JString, required = true,
                                 default = nil)
  if valid_568262 != nil:
    section.add "resourceGroupName", valid_568262
  var valid_568263 = path.getOrDefault("subscriptionId")
  valid_568263 = validateParameter(valid_568263, JString, required = true,
                                 default = nil)
  if valid_568263 != nil:
    section.add "subscriptionId", valid_568263
  var valid_568264 = path.getOrDefault("profileName")
  valid_568264 = validateParameter(valid_568264, JString, required = true,
                                 default = nil)
  if valid_568264 != nil:
    section.add "profileName", valid_568264
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568265 = query.getOrDefault("api-version")
  valid_568265 = validateParameter(valid_568265, JString, required = true,
                                 default = nil)
  if valid_568265 != nil:
    section.add "api-version", valid_568265
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568266: Call_ProfilesDelete_568259; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a Traffic Manager profile.
  ## 
  let valid = call_568266.validator(path, query, header, formData, body)
  let scheme = call_568266.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568266.url(scheme.get, call_568266.host, call_568266.base,
                         call_568266.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568266, url, valid)

proc call*(call_568267: Call_ProfilesDelete_568259; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; profileName: string): Recallable =
  ## profilesDelete
  ## Deletes a Traffic Manager profile.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group containing the Traffic Manager profile to be deleted.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   profileName: string (required)
  ##              : The name of the Traffic Manager profile to be deleted.
  var path_568268 = newJObject()
  var query_568269 = newJObject()
  add(path_568268, "resourceGroupName", newJString(resourceGroupName))
  add(query_568269, "api-version", newJString(apiVersion))
  add(path_568268, "subscriptionId", newJString(subscriptionId))
  add(path_568268, "profileName", newJString(profileName))
  result = call_568267.call(path_568268, query_568269, nil, nil, nil)

var profilesDelete* = Call_ProfilesDelete_568259(name: "profilesDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/trafficmanagerprofiles/{profileName}",
    validator: validate_ProfilesDelete_568260, base: "", url: url_ProfilesDelete_568261,
    schemes: {Scheme.Https})
type
  Call_EndpointsCreateOrUpdate_568296 = ref object of OpenApiRestCall_567658
proc url_EndpointsCreateOrUpdate_568298(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "profileName" in path, "`profileName` is a required path parameter"
  assert "endpointType" in path, "`endpointType` is a required path parameter"
  assert "endpointName" in path, "`endpointName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/trafficmanagerprofiles/"),
               (kind: VariableSegment, value: "profileName"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "endpointType"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "endpointName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_EndpointsCreateOrUpdate_568297(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or update a Traffic Manager endpoint.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group containing the Traffic Manager endpoint to be created or updated.
  ##   endpointType: JString (required)
  ##               : The type of the Traffic Manager endpoint to be created or updated.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   profileName: JString (required)
  ##              : The name of the Traffic Manager profile.
  ##   endpointName: JString (required)
  ##               : The name of the Traffic Manager endpoint to be created or updated.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568299 = path.getOrDefault("resourceGroupName")
  valid_568299 = validateParameter(valid_568299, JString, required = true,
                                 default = nil)
  if valid_568299 != nil:
    section.add "resourceGroupName", valid_568299
  var valid_568300 = path.getOrDefault("endpointType")
  valid_568300 = validateParameter(valid_568300, JString, required = true,
                                 default = nil)
  if valid_568300 != nil:
    section.add "endpointType", valid_568300
  var valid_568301 = path.getOrDefault("subscriptionId")
  valid_568301 = validateParameter(valid_568301, JString, required = true,
                                 default = nil)
  if valid_568301 != nil:
    section.add "subscriptionId", valid_568301
  var valid_568302 = path.getOrDefault("profileName")
  valid_568302 = validateParameter(valid_568302, JString, required = true,
                                 default = nil)
  if valid_568302 != nil:
    section.add "profileName", valid_568302
  var valid_568303 = path.getOrDefault("endpointName")
  valid_568303 = validateParameter(valid_568303, JString, required = true,
                                 default = nil)
  if valid_568303 != nil:
    section.add "endpointName", valid_568303
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568304 = query.getOrDefault("api-version")
  valid_568304 = validateParameter(valid_568304, JString, required = true,
                                 default = nil)
  if valid_568304 != nil:
    section.add "api-version", valid_568304
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The Traffic Manager endpoint parameters supplied to the CreateOrUpdate operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568306: Call_EndpointsCreateOrUpdate_568296; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or update a Traffic Manager endpoint.
  ## 
  let valid = call_568306.validator(path, query, header, formData, body)
  let scheme = call_568306.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568306.url(scheme.get, call_568306.host, call_568306.base,
                         call_568306.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568306, url, valid)

proc call*(call_568307: Call_EndpointsCreateOrUpdate_568296;
          resourceGroupName: string; apiVersion: string; endpointType: string;
          subscriptionId: string; profileName: string; parameters: JsonNode;
          endpointName: string): Recallable =
  ## endpointsCreateOrUpdate
  ## Create or update a Traffic Manager endpoint.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group containing the Traffic Manager endpoint to be created or updated.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   endpointType: string (required)
  ##               : The type of the Traffic Manager endpoint to be created or updated.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   profileName: string (required)
  ##              : The name of the Traffic Manager profile.
  ##   parameters: JObject (required)
  ##             : The Traffic Manager endpoint parameters supplied to the CreateOrUpdate operation.
  ##   endpointName: string (required)
  ##               : The name of the Traffic Manager endpoint to be created or updated.
  var path_568308 = newJObject()
  var query_568309 = newJObject()
  var body_568310 = newJObject()
  add(path_568308, "resourceGroupName", newJString(resourceGroupName))
  add(query_568309, "api-version", newJString(apiVersion))
  add(path_568308, "endpointType", newJString(endpointType))
  add(path_568308, "subscriptionId", newJString(subscriptionId))
  add(path_568308, "profileName", newJString(profileName))
  if parameters != nil:
    body_568310 = parameters
  add(path_568308, "endpointName", newJString(endpointName))
  result = call_568307.call(path_568308, query_568309, nil, nil, body_568310)

var endpointsCreateOrUpdate* = Call_EndpointsCreateOrUpdate_568296(
    name: "endpointsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/trafficmanagerprofiles/{profileName}/{endpointType}/{endpointName}",
    validator: validate_EndpointsCreateOrUpdate_568297, base: "",
    url: url_EndpointsCreateOrUpdate_568298, schemes: {Scheme.Https})
type
  Call_EndpointsGet_568283 = ref object of OpenApiRestCall_567658
proc url_EndpointsGet_568285(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "profileName" in path, "`profileName` is a required path parameter"
  assert "endpointType" in path, "`endpointType` is a required path parameter"
  assert "endpointName" in path, "`endpointName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/trafficmanagerprofiles/"),
               (kind: VariableSegment, value: "profileName"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "endpointType"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "endpointName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_EndpointsGet_568284(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a Traffic Manager endpoint.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group containing the Traffic Manager endpoint.
  ##   endpointType: JString (required)
  ##               : The type of the Traffic Manager endpoint.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   profileName: JString (required)
  ##              : The name of the Traffic Manager profile.
  ##   endpointName: JString (required)
  ##               : The name of the Traffic Manager endpoint.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568286 = path.getOrDefault("resourceGroupName")
  valid_568286 = validateParameter(valid_568286, JString, required = true,
                                 default = nil)
  if valid_568286 != nil:
    section.add "resourceGroupName", valid_568286
  var valid_568287 = path.getOrDefault("endpointType")
  valid_568287 = validateParameter(valid_568287, JString, required = true,
                                 default = nil)
  if valid_568287 != nil:
    section.add "endpointType", valid_568287
  var valid_568288 = path.getOrDefault("subscriptionId")
  valid_568288 = validateParameter(valid_568288, JString, required = true,
                                 default = nil)
  if valid_568288 != nil:
    section.add "subscriptionId", valid_568288
  var valid_568289 = path.getOrDefault("profileName")
  valid_568289 = validateParameter(valid_568289, JString, required = true,
                                 default = nil)
  if valid_568289 != nil:
    section.add "profileName", valid_568289
  var valid_568290 = path.getOrDefault("endpointName")
  valid_568290 = validateParameter(valid_568290, JString, required = true,
                                 default = nil)
  if valid_568290 != nil:
    section.add "endpointName", valid_568290
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568291 = query.getOrDefault("api-version")
  valid_568291 = validateParameter(valid_568291, JString, required = true,
                                 default = nil)
  if valid_568291 != nil:
    section.add "api-version", valid_568291
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568292: Call_EndpointsGet_568283; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a Traffic Manager endpoint.
  ## 
  let valid = call_568292.validator(path, query, header, formData, body)
  let scheme = call_568292.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568292.url(scheme.get, call_568292.host, call_568292.base,
                         call_568292.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568292, url, valid)

proc call*(call_568293: Call_EndpointsGet_568283; resourceGroupName: string;
          apiVersion: string; endpointType: string; subscriptionId: string;
          profileName: string; endpointName: string): Recallable =
  ## endpointsGet
  ## Gets a Traffic Manager endpoint.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group containing the Traffic Manager endpoint.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   endpointType: string (required)
  ##               : The type of the Traffic Manager endpoint.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   profileName: string (required)
  ##              : The name of the Traffic Manager profile.
  ##   endpointName: string (required)
  ##               : The name of the Traffic Manager endpoint.
  var path_568294 = newJObject()
  var query_568295 = newJObject()
  add(path_568294, "resourceGroupName", newJString(resourceGroupName))
  add(query_568295, "api-version", newJString(apiVersion))
  add(path_568294, "endpointType", newJString(endpointType))
  add(path_568294, "subscriptionId", newJString(subscriptionId))
  add(path_568294, "profileName", newJString(profileName))
  add(path_568294, "endpointName", newJString(endpointName))
  result = call_568293.call(path_568294, query_568295, nil, nil, nil)

var endpointsGet* = Call_EndpointsGet_568283(name: "endpointsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/trafficmanagerprofiles/{profileName}/{endpointType}/{endpointName}",
    validator: validate_EndpointsGet_568284, base: "", url: url_EndpointsGet_568285,
    schemes: {Scheme.Https})
type
  Call_EndpointsUpdate_568324 = ref object of OpenApiRestCall_567658
proc url_EndpointsUpdate_568326(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "profileName" in path, "`profileName` is a required path parameter"
  assert "endpointType" in path, "`endpointType` is a required path parameter"
  assert "endpointName" in path, "`endpointName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/trafficmanagerprofiles/"),
               (kind: VariableSegment, value: "profileName"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "endpointType"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "endpointName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_EndpointsUpdate_568325(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Update a Traffic Manager endpoint.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group containing the Traffic Manager endpoint to be updated.
  ##   endpointType: JString (required)
  ##               : The type of the Traffic Manager endpoint to be updated.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   profileName: JString (required)
  ##              : The name of the Traffic Manager profile.
  ##   endpointName: JString (required)
  ##               : The name of the Traffic Manager endpoint to be updated.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568327 = path.getOrDefault("resourceGroupName")
  valid_568327 = validateParameter(valid_568327, JString, required = true,
                                 default = nil)
  if valid_568327 != nil:
    section.add "resourceGroupName", valid_568327
  var valid_568328 = path.getOrDefault("endpointType")
  valid_568328 = validateParameter(valid_568328, JString, required = true,
                                 default = nil)
  if valid_568328 != nil:
    section.add "endpointType", valid_568328
  var valid_568329 = path.getOrDefault("subscriptionId")
  valid_568329 = validateParameter(valid_568329, JString, required = true,
                                 default = nil)
  if valid_568329 != nil:
    section.add "subscriptionId", valid_568329
  var valid_568330 = path.getOrDefault("profileName")
  valid_568330 = validateParameter(valid_568330, JString, required = true,
                                 default = nil)
  if valid_568330 != nil:
    section.add "profileName", valid_568330
  var valid_568331 = path.getOrDefault("endpointName")
  valid_568331 = validateParameter(valid_568331, JString, required = true,
                                 default = nil)
  if valid_568331 != nil:
    section.add "endpointName", valid_568331
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568332 = query.getOrDefault("api-version")
  valid_568332 = validateParameter(valid_568332, JString, required = true,
                                 default = nil)
  if valid_568332 != nil:
    section.add "api-version", valid_568332
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The Traffic Manager endpoint parameters supplied to the Update operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568334: Call_EndpointsUpdate_568324; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update a Traffic Manager endpoint.
  ## 
  let valid = call_568334.validator(path, query, header, formData, body)
  let scheme = call_568334.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568334.url(scheme.get, call_568334.host, call_568334.base,
                         call_568334.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568334, url, valid)

proc call*(call_568335: Call_EndpointsUpdate_568324; resourceGroupName: string;
          apiVersion: string; endpointType: string; subscriptionId: string;
          profileName: string; parameters: JsonNode; endpointName: string): Recallable =
  ## endpointsUpdate
  ## Update a Traffic Manager endpoint.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group containing the Traffic Manager endpoint to be updated.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   endpointType: string (required)
  ##               : The type of the Traffic Manager endpoint to be updated.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   profileName: string (required)
  ##              : The name of the Traffic Manager profile.
  ##   parameters: JObject (required)
  ##             : The Traffic Manager endpoint parameters supplied to the Update operation.
  ##   endpointName: string (required)
  ##               : The name of the Traffic Manager endpoint to be updated.
  var path_568336 = newJObject()
  var query_568337 = newJObject()
  var body_568338 = newJObject()
  add(path_568336, "resourceGroupName", newJString(resourceGroupName))
  add(query_568337, "api-version", newJString(apiVersion))
  add(path_568336, "endpointType", newJString(endpointType))
  add(path_568336, "subscriptionId", newJString(subscriptionId))
  add(path_568336, "profileName", newJString(profileName))
  if parameters != nil:
    body_568338 = parameters
  add(path_568336, "endpointName", newJString(endpointName))
  result = call_568335.call(path_568336, query_568337, nil, nil, body_568338)

var endpointsUpdate* = Call_EndpointsUpdate_568324(name: "endpointsUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/trafficmanagerprofiles/{profileName}/{endpointType}/{endpointName}",
    validator: validate_EndpointsUpdate_568325, base: "", url: url_EndpointsUpdate_568326,
    schemes: {Scheme.Https})
type
  Call_EndpointsDelete_568311 = ref object of OpenApiRestCall_567658
proc url_EndpointsDelete_568313(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "profileName" in path, "`profileName` is a required path parameter"
  assert "endpointType" in path, "`endpointType` is a required path parameter"
  assert "endpointName" in path, "`endpointName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/trafficmanagerprofiles/"),
               (kind: VariableSegment, value: "profileName"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "endpointType"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "endpointName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_EndpointsDelete_568312(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Deletes a Traffic Manager endpoint.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group containing the Traffic Manager endpoint to be deleted.
  ##   endpointType: JString (required)
  ##               : The type of the Traffic Manager endpoint to be deleted.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   profileName: JString (required)
  ##              : The name of the Traffic Manager profile.
  ##   endpointName: JString (required)
  ##               : The name of the Traffic Manager endpoint to be deleted.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568314 = path.getOrDefault("resourceGroupName")
  valid_568314 = validateParameter(valid_568314, JString, required = true,
                                 default = nil)
  if valid_568314 != nil:
    section.add "resourceGroupName", valid_568314
  var valid_568315 = path.getOrDefault("endpointType")
  valid_568315 = validateParameter(valid_568315, JString, required = true,
                                 default = nil)
  if valid_568315 != nil:
    section.add "endpointType", valid_568315
  var valid_568316 = path.getOrDefault("subscriptionId")
  valid_568316 = validateParameter(valid_568316, JString, required = true,
                                 default = nil)
  if valid_568316 != nil:
    section.add "subscriptionId", valid_568316
  var valid_568317 = path.getOrDefault("profileName")
  valid_568317 = validateParameter(valid_568317, JString, required = true,
                                 default = nil)
  if valid_568317 != nil:
    section.add "profileName", valid_568317
  var valid_568318 = path.getOrDefault("endpointName")
  valid_568318 = validateParameter(valid_568318, JString, required = true,
                                 default = nil)
  if valid_568318 != nil:
    section.add "endpointName", valid_568318
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568319 = query.getOrDefault("api-version")
  valid_568319 = validateParameter(valid_568319, JString, required = true,
                                 default = nil)
  if valid_568319 != nil:
    section.add "api-version", valid_568319
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568320: Call_EndpointsDelete_568311; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a Traffic Manager endpoint.
  ## 
  let valid = call_568320.validator(path, query, header, formData, body)
  let scheme = call_568320.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568320.url(scheme.get, call_568320.host, call_568320.base,
                         call_568320.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568320, url, valid)

proc call*(call_568321: Call_EndpointsDelete_568311; resourceGroupName: string;
          apiVersion: string; endpointType: string; subscriptionId: string;
          profileName: string; endpointName: string): Recallable =
  ## endpointsDelete
  ## Deletes a Traffic Manager endpoint.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group containing the Traffic Manager endpoint to be deleted.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   endpointType: string (required)
  ##               : The type of the Traffic Manager endpoint to be deleted.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   profileName: string (required)
  ##              : The name of the Traffic Manager profile.
  ##   endpointName: string (required)
  ##               : The name of the Traffic Manager endpoint to be deleted.
  var path_568322 = newJObject()
  var query_568323 = newJObject()
  add(path_568322, "resourceGroupName", newJString(resourceGroupName))
  add(query_568323, "api-version", newJString(apiVersion))
  add(path_568322, "endpointType", newJString(endpointType))
  add(path_568322, "subscriptionId", newJString(subscriptionId))
  add(path_568322, "profileName", newJString(profileName))
  add(path_568322, "endpointName", newJString(endpointName))
  result = call_568321.call(path_568322, query_568323, nil, nil, nil)

var endpointsDelete* = Call_EndpointsDelete_568311(name: "endpointsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/trafficmanagerprofiles/{profileName}/{endpointType}/{endpointName}",
    validator: validate_EndpointsDelete_568312, base: "", url: url_EndpointsDelete_568313,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
