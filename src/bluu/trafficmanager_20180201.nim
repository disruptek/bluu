
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: TrafficManagerManagementClient
## version: 2018-02-01
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
  macServiceName = "trafficmanager"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_ProfilesCheckTrafficManagerRelativeDnsNameAvailability_593647 = ref object of OpenApiRestCall_593425
proc url_ProfilesCheckTrafficManagerRelativeDnsNameAvailability_593649(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_ProfilesCheckTrafficManagerRelativeDnsNameAvailability_593648(
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
  var valid_593825 = query.getOrDefault("api-version")
  valid_593825 = validateParameter(valid_593825, JString, required = true,
                                 default = nil)
  if valid_593825 != nil:
    section.add "api-version", valid_593825
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

proc call*(call_593849: Call_ProfilesCheckTrafficManagerRelativeDnsNameAvailability_593647;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Checks the availability of a Traffic Manager Relative DNS name.
  ## 
  let valid = call_593849.validator(path, query, header, formData, body)
  let scheme = call_593849.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593849.url(scheme.get, call_593849.host, call_593849.base,
                         call_593849.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593849, url, valid)

proc call*(call_593920: Call_ProfilesCheckTrafficManagerRelativeDnsNameAvailability_593647;
          apiVersion: string; parameters: JsonNode): Recallable =
  ## profilesCheckTrafficManagerRelativeDnsNameAvailability
  ## Checks the availability of a Traffic Manager Relative DNS name.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   parameters: JObject (required)
  ##             : The Traffic Manager name parameters supplied to the CheckTrafficManagerNameAvailability operation.
  var query_593921 = newJObject()
  var body_593923 = newJObject()
  add(query_593921, "api-version", newJString(apiVersion))
  if parameters != nil:
    body_593923 = parameters
  result = call_593920.call(nil, query_593921, nil, nil, body_593923)

var profilesCheckTrafficManagerRelativeDnsNameAvailability* = Call_ProfilesCheckTrafficManagerRelativeDnsNameAvailability_593647(
    name: "profilesCheckTrafficManagerRelativeDnsNameAvailability",
    meth: HttpMethod.HttpPost, host: "management.azure.com",
    route: "/providers/Microsoft.Network/checkTrafficManagerNameAvailability",
    validator: validate_ProfilesCheckTrafficManagerRelativeDnsNameAvailability_593648,
    base: "", url: url_ProfilesCheckTrafficManagerRelativeDnsNameAvailability_593649,
    schemes: {Scheme.Https})
type
  Call_GeographicHierarchiesGetDefault_593962 = ref object of OpenApiRestCall_593425
proc url_GeographicHierarchiesGetDefault_593964(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_GeographicHierarchiesGetDefault_593963(path: JsonNode;
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
  var valid_593965 = query.getOrDefault("api-version")
  valid_593965 = validateParameter(valid_593965, JString, required = true,
                                 default = nil)
  if valid_593965 != nil:
    section.add "api-version", valid_593965
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593966: Call_GeographicHierarchiesGetDefault_593962;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the default Geographic Hierarchy used by the Geographic traffic routing method.
  ## 
  let valid = call_593966.validator(path, query, header, formData, body)
  let scheme = call_593966.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593966.url(scheme.get, call_593966.host, call_593966.base,
                         call_593966.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593966, url, valid)

proc call*(call_593967: Call_GeographicHierarchiesGetDefault_593962;
          apiVersion: string): Recallable =
  ## geographicHierarchiesGetDefault
  ## Gets the default Geographic Hierarchy used by the Geographic traffic routing method.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  var query_593968 = newJObject()
  add(query_593968, "api-version", newJString(apiVersion))
  result = call_593967.call(nil, query_593968, nil, nil, nil)

var geographicHierarchiesGetDefault* = Call_GeographicHierarchiesGetDefault_593962(
    name: "geographicHierarchiesGetDefault", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Network/trafficManagerGeographicHierarchies/default",
    validator: validate_GeographicHierarchiesGetDefault_593963, base: "",
    url: url_GeographicHierarchiesGetDefault_593964, schemes: {Scheme.Https})
type
  Call_ProfilesListBySubscription_593969 = ref object of OpenApiRestCall_593425
proc url_ProfilesListBySubscription_593971(protocol: Scheme; host: string;
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

proc validate_ProfilesListBySubscription_593970(path: JsonNode; query: JsonNode;
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
  var valid_593986 = path.getOrDefault("subscriptionId")
  valid_593986 = validateParameter(valid_593986, JString, required = true,
                                 default = nil)
  if valid_593986 != nil:
    section.add "subscriptionId", valid_593986
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593987 = query.getOrDefault("api-version")
  valid_593987 = validateParameter(valid_593987, JString, required = true,
                                 default = nil)
  if valid_593987 != nil:
    section.add "api-version", valid_593987
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593988: Call_ProfilesListBySubscription_593969; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all Traffic Manager profiles within a subscription.
  ## 
  let valid = call_593988.validator(path, query, header, formData, body)
  let scheme = call_593988.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593988.url(scheme.get, call_593988.host, call_593988.base,
                         call_593988.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593988, url, valid)

proc call*(call_593989: Call_ProfilesListBySubscription_593969; apiVersion: string;
          subscriptionId: string): Recallable =
  ## profilesListBySubscription
  ## Lists all Traffic Manager profiles within a subscription.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_593990 = newJObject()
  var query_593991 = newJObject()
  add(query_593991, "api-version", newJString(apiVersion))
  add(path_593990, "subscriptionId", newJString(subscriptionId))
  result = call_593989.call(path_593990, query_593991, nil, nil, nil)

var profilesListBySubscription* = Call_ProfilesListBySubscription_593969(
    name: "profilesListBySubscription", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Network/trafficmanagerprofiles",
    validator: validate_ProfilesListBySubscription_593970, base: "",
    url: url_ProfilesListBySubscription_593971, schemes: {Scheme.Https})
type
  Call_ProfilesListByResourceGroup_593992 = ref object of OpenApiRestCall_593425
proc url_ProfilesListByResourceGroup_593994(protocol: Scheme; host: string;
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

proc validate_ProfilesListByResourceGroup_593993(path: JsonNode; query: JsonNode;
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
  var valid_593995 = path.getOrDefault("resourceGroupName")
  valid_593995 = validateParameter(valid_593995, JString, required = true,
                                 default = nil)
  if valid_593995 != nil:
    section.add "resourceGroupName", valid_593995
  var valid_593996 = path.getOrDefault("subscriptionId")
  valid_593996 = validateParameter(valid_593996, JString, required = true,
                                 default = nil)
  if valid_593996 != nil:
    section.add "subscriptionId", valid_593996
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593997 = query.getOrDefault("api-version")
  valid_593997 = validateParameter(valid_593997, JString, required = true,
                                 default = nil)
  if valid_593997 != nil:
    section.add "api-version", valid_593997
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593998: Call_ProfilesListByResourceGroup_593992; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all Traffic Manager profiles within a resource group.
  ## 
  let valid = call_593998.validator(path, query, header, formData, body)
  let scheme = call_593998.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593998.url(scheme.get, call_593998.host, call_593998.base,
                         call_593998.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593998, url, valid)

proc call*(call_593999: Call_ProfilesListByResourceGroup_593992;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## profilesListByResourceGroup
  ## Lists all Traffic Manager profiles within a resource group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group containing the Traffic Manager profiles to be listed.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_594000 = newJObject()
  var query_594001 = newJObject()
  add(path_594000, "resourceGroupName", newJString(resourceGroupName))
  add(query_594001, "api-version", newJString(apiVersion))
  add(path_594000, "subscriptionId", newJString(subscriptionId))
  result = call_593999.call(path_594000, query_594001, nil, nil, nil)

var profilesListByResourceGroup* = Call_ProfilesListByResourceGroup_593992(
    name: "profilesListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/trafficmanagerprofiles",
    validator: validate_ProfilesListByResourceGroup_593993, base: "",
    url: url_ProfilesListByResourceGroup_593994, schemes: {Scheme.Https})
type
  Call_ProfilesCreateOrUpdate_594013 = ref object of OpenApiRestCall_593425
proc url_ProfilesCreateOrUpdate_594015(protocol: Scheme; host: string; base: string;
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

proc validate_ProfilesCreateOrUpdate_594014(path: JsonNode; query: JsonNode;
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
  var valid_594016 = path.getOrDefault("resourceGroupName")
  valid_594016 = validateParameter(valid_594016, JString, required = true,
                                 default = nil)
  if valid_594016 != nil:
    section.add "resourceGroupName", valid_594016
  var valid_594017 = path.getOrDefault("subscriptionId")
  valid_594017 = validateParameter(valid_594017, JString, required = true,
                                 default = nil)
  if valid_594017 != nil:
    section.add "subscriptionId", valid_594017
  var valid_594018 = path.getOrDefault("profileName")
  valid_594018 = validateParameter(valid_594018, JString, required = true,
                                 default = nil)
  if valid_594018 != nil:
    section.add "profileName", valid_594018
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594019 = query.getOrDefault("api-version")
  valid_594019 = validateParameter(valid_594019, JString, required = true,
                                 default = nil)
  if valid_594019 != nil:
    section.add "api-version", valid_594019
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

proc call*(call_594021: Call_ProfilesCreateOrUpdate_594013; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or update a Traffic Manager profile.
  ## 
  let valid = call_594021.validator(path, query, header, formData, body)
  let scheme = call_594021.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594021.url(scheme.get, call_594021.host, call_594021.base,
                         call_594021.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594021, url, valid)

proc call*(call_594022: Call_ProfilesCreateOrUpdate_594013;
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
  var path_594023 = newJObject()
  var query_594024 = newJObject()
  var body_594025 = newJObject()
  add(path_594023, "resourceGroupName", newJString(resourceGroupName))
  add(query_594024, "api-version", newJString(apiVersion))
  add(path_594023, "subscriptionId", newJString(subscriptionId))
  add(path_594023, "profileName", newJString(profileName))
  if parameters != nil:
    body_594025 = parameters
  result = call_594022.call(path_594023, query_594024, nil, nil, body_594025)

var profilesCreateOrUpdate* = Call_ProfilesCreateOrUpdate_594013(
    name: "profilesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/trafficmanagerprofiles/{profileName}",
    validator: validate_ProfilesCreateOrUpdate_594014, base: "",
    url: url_ProfilesCreateOrUpdate_594015, schemes: {Scheme.Https})
type
  Call_ProfilesGet_594002 = ref object of OpenApiRestCall_593425
proc url_ProfilesGet_594004(protocol: Scheme; host: string; base: string;
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

proc validate_ProfilesGet_594003(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594005 = path.getOrDefault("resourceGroupName")
  valid_594005 = validateParameter(valid_594005, JString, required = true,
                                 default = nil)
  if valid_594005 != nil:
    section.add "resourceGroupName", valid_594005
  var valid_594006 = path.getOrDefault("subscriptionId")
  valid_594006 = validateParameter(valid_594006, JString, required = true,
                                 default = nil)
  if valid_594006 != nil:
    section.add "subscriptionId", valid_594006
  var valid_594007 = path.getOrDefault("profileName")
  valid_594007 = validateParameter(valid_594007, JString, required = true,
                                 default = nil)
  if valid_594007 != nil:
    section.add "profileName", valid_594007
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594008 = query.getOrDefault("api-version")
  valid_594008 = validateParameter(valid_594008, JString, required = true,
                                 default = nil)
  if valid_594008 != nil:
    section.add "api-version", valid_594008
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594009: Call_ProfilesGet_594002; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a Traffic Manager profile.
  ## 
  let valid = call_594009.validator(path, query, header, formData, body)
  let scheme = call_594009.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594009.url(scheme.get, call_594009.host, call_594009.base,
                         call_594009.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594009, url, valid)

proc call*(call_594010: Call_ProfilesGet_594002; resourceGroupName: string;
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
  var path_594011 = newJObject()
  var query_594012 = newJObject()
  add(path_594011, "resourceGroupName", newJString(resourceGroupName))
  add(query_594012, "api-version", newJString(apiVersion))
  add(path_594011, "subscriptionId", newJString(subscriptionId))
  add(path_594011, "profileName", newJString(profileName))
  result = call_594010.call(path_594011, query_594012, nil, nil, nil)

var profilesGet* = Call_ProfilesGet_594002(name: "profilesGet",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/trafficmanagerprofiles/{profileName}",
                                        validator: validate_ProfilesGet_594003,
                                        base: "", url: url_ProfilesGet_594004,
                                        schemes: {Scheme.Https})
type
  Call_ProfilesUpdate_594037 = ref object of OpenApiRestCall_593425
proc url_ProfilesUpdate_594039(protocol: Scheme; host: string; base: string;
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

proc validate_ProfilesUpdate_594038(path: JsonNode; query: JsonNode;
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
  var valid_594040 = path.getOrDefault("resourceGroupName")
  valid_594040 = validateParameter(valid_594040, JString, required = true,
                                 default = nil)
  if valid_594040 != nil:
    section.add "resourceGroupName", valid_594040
  var valid_594041 = path.getOrDefault("subscriptionId")
  valid_594041 = validateParameter(valid_594041, JString, required = true,
                                 default = nil)
  if valid_594041 != nil:
    section.add "subscriptionId", valid_594041
  var valid_594042 = path.getOrDefault("profileName")
  valid_594042 = validateParameter(valid_594042, JString, required = true,
                                 default = nil)
  if valid_594042 != nil:
    section.add "profileName", valid_594042
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594043 = query.getOrDefault("api-version")
  valid_594043 = validateParameter(valid_594043, JString, required = true,
                                 default = nil)
  if valid_594043 != nil:
    section.add "api-version", valid_594043
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

proc call*(call_594045: Call_ProfilesUpdate_594037; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update a Traffic Manager profile.
  ## 
  let valid = call_594045.validator(path, query, header, formData, body)
  let scheme = call_594045.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594045.url(scheme.get, call_594045.host, call_594045.base,
                         call_594045.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594045, url, valid)

proc call*(call_594046: Call_ProfilesUpdate_594037; resourceGroupName: string;
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
  var path_594047 = newJObject()
  var query_594048 = newJObject()
  var body_594049 = newJObject()
  add(path_594047, "resourceGroupName", newJString(resourceGroupName))
  add(query_594048, "api-version", newJString(apiVersion))
  add(path_594047, "subscriptionId", newJString(subscriptionId))
  add(path_594047, "profileName", newJString(profileName))
  if parameters != nil:
    body_594049 = parameters
  result = call_594046.call(path_594047, query_594048, nil, nil, body_594049)

var profilesUpdate* = Call_ProfilesUpdate_594037(name: "profilesUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/trafficmanagerprofiles/{profileName}",
    validator: validate_ProfilesUpdate_594038, base: "", url: url_ProfilesUpdate_594039,
    schemes: {Scheme.Https})
type
  Call_ProfilesDelete_594026 = ref object of OpenApiRestCall_593425
proc url_ProfilesDelete_594028(protocol: Scheme; host: string; base: string;
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

proc validate_ProfilesDelete_594027(path: JsonNode; query: JsonNode;
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
  var valid_594029 = path.getOrDefault("resourceGroupName")
  valid_594029 = validateParameter(valid_594029, JString, required = true,
                                 default = nil)
  if valid_594029 != nil:
    section.add "resourceGroupName", valid_594029
  var valid_594030 = path.getOrDefault("subscriptionId")
  valid_594030 = validateParameter(valid_594030, JString, required = true,
                                 default = nil)
  if valid_594030 != nil:
    section.add "subscriptionId", valid_594030
  var valid_594031 = path.getOrDefault("profileName")
  valid_594031 = validateParameter(valid_594031, JString, required = true,
                                 default = nil)
  if valid_594031 != nil:
    section.add "profileName", valid_594031
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594032 = query.getOrDefault("api-version")
  valid_594032 = validateParameter(valid_594032, JString, required = true,
                                 default = nil)
  if valid_594032 != nil:
    section.add "api-version", valid_594032
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594033: Call_ProfilesDelete_594026; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a Traffic Manager profile.
  ## 
  let valid = call_594033.validator(path, query, header, formData, body)
  let scheme = call_594033.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594033.url(scheme.get, call_594033.host, call_594033.base,
                         call_594033.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594033, url, valid)

proc call*(call_594034: Call_ProfilesDelete_594026; resourceGroupName: string;
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
  var path_594035 = newJObject()
  var query_594036 = newJObject()
  add(path_594035, "resourceGroupName", newJString(resourceGroupName))
  add(query_594036, "api-version", newJString(apiVersion))
  add(path_594035, "subscriptionId", newJString(subscriptionId))
  add(path_594035, "profileName", newJString(profileName))
  result = call_594034.call(path_594035, query_594036, nil, nil, nil)

var profilesDelete* = Call_ProfilesDelete_594026(name: "profilesDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/trafficmanagerprofiles/{profileName}",
    validator: validate_ProfilesDelete_594027, base: "", url: url_ProfilesDelete_594028,
    schemes: {Scheme.Https})
type
  Call_EndpointsCreateOrUpdate_594063 = ref object of OpenApiRestCall_593425
proc url_EndpointsCreateOrUpdate_594065(protocol: Scheme; host: string; base: string;
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

proc validate_EndpointsCreateOrUpdate_594064(path: JsonNode; query: JsonNode;
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
  var valid_594066 = path.getOrDefault("resourceGroupName")
  valid_594066 = validateParameter(valid_594066, JString, required = true,
                                 default = nil)
  if valid_594066 != nil:
    section.add "resourceGroupName", valid_594066
  var valid_594067 = path.getOrDefault("endpointType")
  valid_594067 = validateParameter(valid_594067, JString, required = true,
                                 default = nil)
  if valid_594067 != nil:
    section.add "endpointType", valid_594067
  var valid_594068 = path.getOrDefault("subscriptionId")
  valid_594068 = validateParameter(valid_594068, JString, required = true,
                                 default = nil)
  if valid_594068 != nil:
    section.add "subscriptionId", valid_594068
  var valid_594069 = path.getOrDefault("profileName")
  valid_594069 = validateParameter(valid_594069, JString, required = true,
                                 default = nil)
  if valid_594069 != nil:
    section.add "profileName", valid_594069
  var valid_594070 = path.getOrDefault("endpointName")
  valid_594070 = validateParameter(valid_594070, JString, required = true,
                                 default = nil)
  if valid_594070 != nil:
    section.add "endpointName", valid_594070
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
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
  ##   parameters: JObject (required)
  ##             : The Traffic Manager endpoint parameters supplied to the CreateOrUpdate operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594073: Call_EndpointsCreateOrUpdate_594063; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or update a Traffic Manager endpoint.
  ## 
  let valid = call_594073.validator(path, query, header, formData, body)
  let scheme = call_594073.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594073.url(scheme.get, call_594073.host, call_594073.base,
                         call_594073.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594073, url, valid)

proc call*(call_594074: Call_EndpointsCreateOrUpdate_594063;
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
  var path_594075 = newJObject()
  var query_594076 = newJObject()
  var body_594077 = newJObject()
  add(path_594075, "resourceGroupName", newJString(resourceGroupName))
  add(query_594076, "api-version", newJString(apiVersion))
  add(path_594075, "endpointType", newJString(endpointType))
  add(path_594075, "subscriptionId", newJString(subscriptionId))
  add(path_594075, "profileName", newJString(profileName))
  if parameters != nil:
    body_594077 = parameters
  add(path_594075, "endpointName", newJString(endpointName))
  result = call_594074.call(path_594075, query_594076, nil, nil, body_594077)

var endpointsCreateOrUpdate* = Call_EndpointsCreateOrUpdate_594063(
    name: "endpointsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/trafficmanagerprofiles/{profileName}/{endpointType}/{endpointName}",
    validator: validate_EndpointsCreateOrUpdate_594064, base: "",
    url: url_EndpointsCreateOrUpdate_594065, schemes: {Scheme.Https})
type
  Call_EndpointsGet_594050 = ref object of OpenApiRestCall_593425
proc url_EndpointsGet_594052(protocol: Scheme; host: string; base: string;
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

proc validate_EndpointsGet_594051(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594053 = path.getOrDefault("resourceGroupName")
  valid_594053 = validateParameter(valid_594053, JString, required = true,
                                 default = nil)
  if valid_594053 != nil:
    section.add "resourceGroupName", valid_594053
  var valid_594054 = path.getOrDefault("endpointType")
  valid_594054 = validateParameter(valid_594054, JString, required = true,
                                 default = nil)
  if valid_594054 != nil:
    section.add "endpointType", valid_594054
  var valid_594055 = path.getOrDefault("subscriptionId")
  valid_594055 = validateParameter(valid_594055, JString, required = true,
                                 default = nil)
  if valid_594055 != nil:
    section.add "subscriptionId", valid_594055
  var valid_594056 = path.getOrDefault("profileName")
  valid_594056 = validateParameter(valid_594056, JString, required = true,
                                 default = nil)
  if valid_594056 != nil:
    section.add "profileName", valid_594056
  var valid_594057 = path.getOrDefault("endpointName")
  valid_594057 = validateParameter(valid_594057, JString, required = true,
                                 default = nil)
  if valid_594057 != nil:
    section.add "endpointName", valid_594057
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594058 = query.getOrDefault("api-version")
  valid_594058 = validateParameter(valid_594058, JString, required = true,
                                 default = nil)
  if valid_594058 != nil:
    section.add "api-version", valid_594058
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594059: Call_EndpointsGet_594050; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a Traffic Manager endpoint.
  ## 
  let valid = call_594059.validator(path, query, header, formData, body)
  let scheme = call_594059.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594059.url(scheme.get, call_594059.host, call_594059.base,
                         call_594059.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594059, url, valid)

proc call*(call_594060: Call_EndpointsGet_594050; resourceGroupName: string;
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
  var path_594061 = newJObject()
  var query_594062 = newJObject()
  add(path_594061, "resourceGroupName", newJString(resourceGroupName))
  add(query_594062, "api-version", newJString(apiVersion))
  add(path_594061, "endpointType", newJString(endpointType))
  add(path_594061, "subscriptionId", newJString(subscriptionId))
  add(path_594061, "profileName", newJString(profileName))
  add(path_594061, "endpointName", newJString(endpointName))
  result = call_594060.call(path_594061, query_594062, nil, nil, nil)

var endpointsGet* = Call_EndpointsGet_594050(name: "endpointsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/trafficmanagerprofiles/{profileName}/{endpointType}/{endpointName}",
    validator: validate_EndpointsGet_594051, base: "", url: url_EndpointsGet_594052,
    schemes: {Scheme.Https})
type
  Call_EndpointsUpdate_594091 = ref object of OpenApiRestCall_593425
proc url_EndpointsUpdate_594093(protocol: Scheme; host: string; base: string;
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

proc validate_EndpointsUpdate_594092(path: JsonNode; query: JsonNode;
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
  var valid_594094 = path.getOrDefault("resourceGroupName")
  valid_594094 = validateParameter(valid_594094, JString, required = true,
                                 default = nil)
  if valid_594094 != nil:
    section.add "resourceGroupName", valid_594094
  var valid_594095 = path.getOrDefault("endpointType")
  valid_594095 = validateParameter(valid_594095, JString, required = true,
                                 default = nil)
  if valid_594095 != nil:
    section.add "endpointType", valid_594095
  var valid_594096 = path.getOrDefault("subscriptionId")
  valid_594096 = validateParameter(valid_594096, JString, required = true,
                                 default = nil)
  if valid_594096 != nil:
    section.add "subscriptionId", valid_594096
  var valid_594097 = path.getOrDefault("profileName")
  valid_594097 = validateParameter(valid_594097, JString, required = true,
                                 default = nil)
  if valid_594097 != nil:
    section.add "profileName", valid_594097
  var valid_594098 = path.getOrDefault("endpointName")
  valid_594098 = validateParameter(valid_594098, JString, required = true,
                                 default = nil)
  if valid_594098 != nil:
    section.add "endpointName", valid_594098
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594099 = query.getOrDefault("api-version")
  valid_594099 = validateParameter(valid_594099, JString, required = true,
                                 default = nil)
  if valid_594099 != nil:
    section.add "api-version", valid_594099
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

proc call*(call_594101: Call_EndpointsUpdate_594091; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update a Traffic Manager endpoint.
  ## 
  let valid = call_594101.validator(path, query, header, formData, body)
  let scheme = call_594101.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594101.url(scheme.get, call_594101.host, call_594101.base,
                         call_594101.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594101, url, valid)

proc call*(call_594102: Call_EndpointsUpdate_594091; resourceGroupName: string;
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
  var path_594103 = newJObject()
  var query_594104 = newJObject()
  var body_594105 = newJObject()
  add(path_594103, "resourceGroupName", newJString(resourceGroupName))
  add(query_594104, "api-version", newJString(apiVersion))
  add(path_594103, "endpointType", newJString(endpointType))
  add(path_594103, "subscriptionId", newJString(subscriptionId))
  add(path_594103, "profileName", newJString(profileName))
  if parameters != nil:
    body_594105 = parameters
  add(path_594103, "endpointName", newJString(endpointName))
  result = call_594102.call(path_594103, query_594104, nil, nil, body_594105)

var endpointsUpdate* = Call_EndpointsUpdate_594091(name: "endpointsUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/trafficmanagerprofiles/{profileName}/{endpointType}/{endpointName}",
    validator: validate_EndpointsUpdate_594092, base: "", url: url_EndpointsUpdate_594093,
    schemes: {Scheme.Https})
type
  Call_EndpointsDelete_594078 = ref object of OpenApiRestCall_593425
proc url_EndpointsDelete_594080(protocol: Scheme; host: string; base: string;
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

proc validate_EndpointsDelete_594079(path: JsonNode; query: JsonNode;
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
  var valid_594081 = path.getOrDefault("resourceGroupName")
  valid_594081 = validateParameter(valid_594081, JString, required = true,
                                 default = nil)
  if valid_594081 != nil:
    section.add "resourceGroupName", valid_594081
  var valid_594082 = path.getOrDefault("endpointType")
  valid_594082 = validateParameter(valid_594082, JString, required = true,
                                 default = nil)
  if valid_594082 != nil:
    section.add "endpointType", valid_594082
  var valid_594083 = path.getOrDefault("subscriptionId")
  valid_594083 = validateParameter(valid_594083, JString, required = true,
                                 default = nil)
  if valid_594083 != nil:
    section.add "subscriptionId", valid_594083
  var valid_594084 = path.getOrDefault("profileName")
  valid_594084 = validateParameter(valid_594084, JString, required = true,
                                 default = nil)
  if valid_594084 != nil:
    section.add "profileName", valid_594084
  var valid_594085 = path.getOrDefault("endpointName")
  valid_594085 = validateParameter(valid_594085, JString, required = true,
                                 default = nil)
  if valid_594085 != nil:
    section.add "endpointName", valid_594085
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594086 = query.getOrDefault("api-version")
  valid_594086 = validateParameter(valid_594086, JString, required = true,
                                 default = nil)
  if valid_594086 != nil:
    section.add "api-version", valid_594086
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594087: Call_EndpointsDelete_594078; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a Traffic Manager endpoint.
  ## 
  let valid = call_594087.validator(path, query, header, formData, body)
  let scheme = call_594087.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594087.url(scheme.get, call_594087.host, call_594087.base,
                         call_594087.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594087, url, valid)

proc call*(call_594088: Call_EndpointsDelete_594078; resourceGroupName: string;
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
  var path_594089 = newJObject()
  var query_594090 = newJObject()
  add(path_594089, "resourceGroupName", newJString(resourceGroupName))
  add(query_594090, "api-version", newJString(apiVersion))
  add(path_594089, "endpointType", newJString(endpointType))
  add(path_594089, "subscriptionId", newJString(subscriptionId))
  add(path_594089, "profileName", newJString(profileName))
  add(path_594089, "endpointName", newJString(endpointName))
  result = call_594088.call(path_594089, query_594090, nil, nil, nil)

var endpointsDelete* = Call_EndpointsDelete_594078(name: "endpointsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/trafficmanagerprofiles/{profileName}/{endpointType}/{endpointName}",
    validator: validate_EndpointsDelete_594079, base: "", url: url_EndpointsDelete_594080,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
