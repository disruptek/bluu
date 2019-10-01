
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: PrivateDnsManagementClient
## version: 2018-09-01
## termsOfService: (not provided)
## license: (not provided)
## 
## The Private DNS Management Client.
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

  OpenApiRestCall_567657 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_567657](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_567657): Option[Scheme] {.used.} =
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
  macServiceName = "privatedns"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_PrivateZonesList_567879 = ref object of OpenApiRestCall_567657
proc url_PrivateZonesList_567881(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/privateDnsZones")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PrivateZonesList_567880(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Lists the Private DNS zones in all resource groups in a subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568055 = path.getOrDefault("subscriptionId")
  valid_568055 = validateParameter(valid_568055, JString, required = true,
                                 default = nil)
  if valid_568055 != nil:
    section.add "subscriptionId", valid_568055
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $top: JInt
  ##       : The maximum number of Private DNS zones to return. If not specified, returns up to 100 zones.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568056 = query.getOrDefault("api-version")
  valid_568056 = validateParameter(valid_568056, JString, required = true,
                                 default = nil)
  if valid_568056 != nil:
    section.add "api-version", valid_568056
  var valid_568057 = query.getOrDefault("$top")
  valid_568057 = validateParameter(valid_568057, JInt, required = false, default = nil)
  if valid_568057 != nil:
    section.add "$top", valid_568057
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568080: Call_PrivateZonesList_567879; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the Private DNS zones in all resource groups in a subscription.
  ## 
  let valid = call_568080.validator(path, query, header, formData, body)
  let scheme = call_568080.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568080.url(scheme.get, call_568080.host, call_568080.base,
                         call_568080.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568080, url, valid)

proc call*(call_568151: Call_PrivateZonesList_567879; apiVersion: string;
          subscriptionId: string; Top: int = 0): Recallable =
  ## privateZonesList
  ## Lists the Private DNS zones in all resource groups in a subscription.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   Top: int
  ##      : The maximum number of Private DNS zones to return. If not specified, returns up to 100 zones.
  var path_568152 = newJObject()
  var query_568154 = newJObject()
  add(query_568154, "api-version", newJString(apiVersion))
  add(path_568152, "subscriptionId", newJString(subscriptionId))
  add(query_568154, "$top", newJInt(Top))
  result = call_568151.call(path_568152, query_568154, nil, nil, nil)

var privateZonesList* = Call_PrivateZonesList_567879(name: "privateZonesList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Network/privateDnsZones",
    validator: validate_PrivateZonesList_567880, base: "",
    url: url_PrivateZonesList_567881, schemes: {Scheme.Https})
type
  Call_PrivateZonesListByResourceGroup_568193 = ref object of OpenApiRestCall_567657
proc url_PrivateZonesListByResourceGroup_568195(protocol: Scheme; host: string;
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
        value: "/providers/Microsoft.Network/privateDnsZones")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PrivateZonesListByResourceGroup_568194(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the Private DNS zones within a resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568196 = path.getOrDefault("resourceGroupName")
  valid_568196 = validateParameter(valid_568196, JString, required = true,
                                 default = nil)
  if valid_568196 != nil:
    section.add "resourceGroupName", valid_568196
  var valid_568197 = path.getOrDefault("subscriptionId")
  valid_568197 = validateParameter(valid_568197, JString, required = true,
                                 default = nil)
  if valid_568197 != nil:
    section.add "subscriptionId", valid_568197
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $top: JInt
  ##       : The maximum number of record sets to return. If not specified, returns up to 100 record sets.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568198 = query.getOrDefault("api-version")
  valid_568198 = validateParameter(valid_568198, JString, required = true,
                                 default = nil)
  if valid_568198 != nil:
    section.add "api-version", valid_568198
  var valid_568199 = query.getOrDefault("$top")
  valid_568199 = validateParameter(valid_568199, JInt, required = false, default = nil)
  if valid_568199 != nil:
    section.add "$top", valid_568199
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568200: Call_PrivateZonesListByResourceGroup_568193;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the Private DNS zones within a resource group.
  ## 
  let valid = call_568200.validator(path, query, header, formData, body)
  let scheme = call_568200.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568200.url(scheme.get, call_568200.host, call_568200.base,
                         call_568200.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568200, url, valid)

proc call*(call_568201: Call_PrivateZonesListByResourceGroup_568193;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          Top: int = 0): Recallable =
  ## privateZonesListByResourceGroup
  ## Lists the Private DNS zones within a resource group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   Top: int
  ##      : The maximum number of record sets to return. If not specified, returns up to 100 record sets.
  var path_568202 = newJObject()
  var query_568203 = newJObject()
  add(path_568202, "resourceGroupName", newJString(resourceGroupName))
  add(query_568203, "api-version", newJString(apiVersion))
  add(path_568202, "subscriptionId", newJString(subscriptionId))
  add(query_568203, "$top", newJInt(Top))
  result = call_568201.call(path_568202, query_568203, nil, nil, nil)

var privateZonesListByResourceGroup* = Call_PrivateZonesListByResourceGroup_568193(
    name: "privateZonesListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/privateDnsZones",
    validator: validate_PrivateZonesListByResourceGroup_568194, base: "",
    url: url_PrivateZonesListByResourceGroup_568195, schemes: {Scheme.Https})
type
  Call_PrivateZonesCreateOrUpdate_568215 = ref object of OpenApiRestCall_567657
proc url_PrivateZonesCreateOrUpdate_568217(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "privateZoneName" in path, "`privateZoneName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/privateDnsZones/"),
               (kind: VariableSegment, value: "privateZoneName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PrivateZonesCreateOrUpdate_568216(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates a Private DNS zone. Does not modify Links to virtual networks or DNS records within the zone.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   privateZoneName: JString (required)
  ##                  : The name of the Private DNS zone (without a terminating dot).
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568235 = path.getOrDefault("resourceGroupName")
  valid_568235 = validateParameter(valid_568235, JString, required = true,
                                 default = nil)
  if valid_568235 != nil:
    section.add "resourceGroupName", valid_568235
  var valid_568236 = path.getOrDefault("subscriptionId")
  valid_568236 = validateParameter(valid_568236, JString, required = true,
                                 default = nil)
  if valid_568236 != nil:
    section.add "subscriptionId", valid_568236
  var valid_568237 = path.getOrDefault("privateZoneName")
  valid_568237 = validateParameter(valid_568237, JString, required = true,
                                 default = nil)
  if valid_568237 != nil:
    section.add "privateZoneName", valid_568237
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568238 = query.getOrDefault("api-version")
  valid_568238 = validateParameter(valid_568238, JString, required = true,
                                 default = nil)
  if valid_568238 != nil:
    section.add "api-version", valid_568238
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : The ETag of the Private DNS zone. Omit this value to always overwrite the current zone. Specify the last-seen ETag value to prevent accidentally overwriting any concurrent changes.
  ##   If-None-Match: JString
  ##                : Set to '*' to allow a new Private DNS zone to be created, but to prevent updating an existing zone. Other values will be ignored.
  section = newJObject()
  var valid_568239 = header.getOrDefault("If-Match")
  valid_568239 = validateParameter(valid_568239, JString, required = false,
                                 default = nil)
  if valid_568239 != nil:
    section.add "If-Match", valid_568239
  var valid_568240 = header.getOrDefault("If-None-Match")
  valid_568240 = validateParameter(valid_568240, JString, required = false,
                                 default = nil)
  if valid_568240 != nil:
    section.add "If-None-Match", valid_568240
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the CreateOrUpdate operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568242: Call_PrivateZonesCreateOrUpdate_568215; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates a Private DNS zone. Does not modify Links to virtual networks or DNS records within the zone.
  ## 
  let valid = call_568242.validator(path, query, header, formData, body)
  let scheme = call_568242.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568242.url(scheme.get, call_568242.host, call_568242.base,
                         call_568242.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568242, url, valid)

proc call*(call_568243: Call_PrivateZonesCreateOrUpdate_568215;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          privateZoneName: string; parameters: JsonNode): Recallable =
  ## privateZonesCreateOrUpdate
  ## Creates or updates a Private DNS zone. Does not modify Links to virtual networks or DNS records within the zone.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   privateZoneName: string (required)
  ##                  : The name of the Private DNS zone (without a terminating dot).
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the CreateOrUpdate operation.
  var path_568244 = newJObject()
  var query_568245 = newJObject()
  var body_568246 = newJObject()
  add(path_568244, "resourceGroupName", newJString(resourceGroupName))
  add(query_568245, "api-version", newJString(apiVersion))
  add(path_568244, "subscriptionId", newJString(subscriptionId))
  add(path_568244, "privateZoneName", newJString(privateZoneName))
  if parameters != nil:
    body_568246 = parameters
  result = call_568243.call(path_568244, query_568245, nil, nil, body_568246)

var privateZonesCreateOrUpdate* = Call_PrivateZonesCreateOrUpdate_568215(
    name: "privateZonesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/privateDnsZones/{privateZoneName}",
    validator: validate_PrivateZonesCreateOrUpdate_568216, base: "",
    url: url_PrivateZonesCreateOrUpdate_568217, schemes: {Scheme.Https})
type
  Call_PrivateZonesGet_568204 = ref object of OpenApiRestCall_567657
proc url_PrivateZonesGet_568206(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "privateZoneName" in path, "`privateZoneName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/privateDnsZones/"),
               (kind: VariableSegment, value: "privateZoneName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PrivateZonesGet_568205(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Gets a Private DNS zone. Retrieves the zone properties, but not the virtual networks links or the record sets within the zone.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   privateZoneName: JString (required)
  ##                  : The name of the Private DNS zone (without a terminating dot).
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568207 = path.getOrDefault("resourceGroupName")
  valid_568207 = validateParameter(valid_568207, JString, required = true,
                                 default = nil)
  if valid_568207 != nil:
    section.add "resourceGroupName", valid_568207
  var valid_568208 = path.getOrDefault("subscriptionId")
  valid_568208 = validateParameter(valid_568208, JString, required = true,
                                 default = nil)
  if valid_568208 != nil:
    section.add "subscriptionId", valid_568208
  var valid_568209 = path.getOrDefault("privateZoneName")
  valid_568209 = validateParameter(valid_568209, JString, required = true,
                                 default = nil)
  if valid_568209 != nil:
    section.add "privateZoneName", valid_568209
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568210 = query.getOrDefault("api-version")
  valid_568210 = validateParameter(valid_568210, JString, required = true,
                                 default = nil)
  if valid_568210 != nil:
    section.add "api-version", valid_568210
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568211: Call_PrivateZonesGet_568204; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a Private DNS zone. Retrieves the zone properties, but not the virtual networks links or the record sets within the zone.
  ## 
  let valid = call_568211.validator(path, query, header, formData, body)
  let scheme = call_568211.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568211.url(scheme.get, call_568211.host, call_568211.base,
                         call_568211.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568211, url, valid)

proc call*(call_568212: Call_PrivateZonesGet_568204; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; privateZoneName: string): Recallable =
  ## privateZonesGet
  ## Gets a Private DNS zone. Retrieves the zone properties, but not the virtual networks links or the record sets within the zone.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   privateZoneName: string (required)
  ##                  : The name of the Private DNS zone (without a terminating dot).
  var path_568213 = newJObject()
  var query_568214 = newJObject()
  add(path_568213, "resourceGroupName", newJString(resourceGroupName))
  add(query_568214, "api-version", newJString(apiVersion))
  add(path_568213, "subscriptionId", newJString(subscriptionId))
  add(path_568213, "privateZoneName", newJString(privateZoneName))
  result = call_568212.call(path_568213, query_568214, nil, nil, nil)

var privateZonesGet* = Call_PrivateZonesGet_568204(name: "privateZonesGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/privateDnsZones/{privateZoneName}",
    validator: validate_PrivateZonesGet_568205, base: "", url: url_PrivateZonesGet_568206,
    schemes: {Scheme.Https})
type
  Call_PrivateZonesUpdate_568259 = ref object of OpenApiRestCall_567657
proc url_PrivateZonesUpdate_568261(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "privateZoneName" in path, "`privateZoneName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/privateDnsZones/"),
               (kind: VariableSegment, value: "privateZoneName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PrivateZonesUpdate_568260(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Updates a Private DNS zone. Does not modify virtual network links or DNS records within the zone.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   privateZoneName: JString (required)
  ##                  : The name of the Private DNS zone (without a terminating dot).
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
  var valid_568264 = path.getOrDefault("privateZoneName")
  valid_568264 = validateParameter(valid_568264, JString, required = true,
                                 default = nil)
  if valid_568264 != nil:
    section.add "privateZoneName", valid_568264
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
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : The ETag of the Private DNS zone. Omit this value to always overwrite the current zone. Specify the last-seen ETag value to prevent accidentally overwriting any concurrent changes.
  section = newJObject()
  var valid_568266 = header.getOrDefault("If-Match")
  valid_568266 = validateParameter(valid_568266, JString, required = false,
                                 default = nil)
  if valid_568266 != nil:
    section.add "If-Match", valid_568266
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the Update operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568268: Call_PrivateZonesUpdate_568259; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a Private DNS zone. Does not modify virtual network links or DNS records within the zone.
  ## 
  let valid = call_568268.validator(path, query, header, formData, body)
  let scheme = call_568268.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568268.url(scheme.get, call_568268.host, call_568268.base,
                         call_568268.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568268, url, valid)

proc call*(call_568269: Call_PrivateZonesUpdate_568259; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; privateZoneName: string;
          parameters: JsonNode): Recallable =
  ## privateZonesUpdate
  ## Updates a Private DNS zone. Does not modify virtual network links or DNS records within the zone.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   privateZoneName: string (required)
  ##                  : The name of the Private DNS zone (without a terminating dot).
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the Update operation.
  var path_568270 = newJObject()
  var query_568271 = newJObject()
  var body_568272 = newJObject()
  add(path_568270, "resourceGroupName", newJString(resourceGroupName))
  add(query_568271, "api-version", newJString(apiVersion))
  add(path_568270, "subscriptionId", newJString(subscriptionId))
  add(path_568270, "privateZoneName", newJString(privateZoneName))
  if parameters != nil:
    body_568272 = parameters
  result = call_568269.call(path_568270, query_568271, nil, nil, body_568272)

var privateZonesUpdate* = Call_PrivateZonesUpdate_568259(
    name: "privateZonesUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/privateDnsZones/{privateZoneName}",
    validator: validate_PrivateZonesUpdate_568260, base: "",
    url: url_PrivateZonesUpdate_568261, schemes: {Scheme.Https})
type
  Call_PrivateZonesDelete_568247 = ref object of OpenApiRestCall_567657
proc url_PrivateZonesDelete_568249(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "privateZoneName" in path, "`privateZoneName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/privateDnsZones/"),
               (kind: VariableSegment, value: "privateZoneName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PrivateZonesDelete_568248(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Deletes a Private DNS zone. WARNING: All DNS records in the zone will also be deleted. This operation cannot be undone. Private DNS zone cannot be deleted unless all virtual network links to it are removed.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   privateZoneName: JString (required)
  ##                  : The name of the Private DNS zone (without a terminating dot).
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568250 = path.getOrDefault("resourceGroupName")
  valid_568250 = validateParameter(valid_568250, JString, required = true,
                                 default = nil)
  if valid_568250 != nil:
    section.add "resourceGroupName", valid_568250
  var valid_568251 = path.getOrDefault("subscriptionId")
  valid_568251 = validateParameter(valid_568251, JString, required = true,
                                 default = nil)
  if valid_568251 != nil:
    section.add "subscriptionId", valid_568251
  var valid_568252 = path.getOrDefault("privateZoneName")
  valid_568252 = validateParameter(valid_568252, JString, required = true,
                                 default = nil)
  if valid_568252 != nil:
    section.add "privateZoneName", valid_568252
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568253 = query.getOrDefault("api-version")
  valid_568253 = validateParameter(valid_568253, JString, required = true,
                                 default = nil)
  if valid_568253 != nil:
    section.add "api-version", valid_568253
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : The ETag of the Private DNS zone. Omit this value to always delete the current zone. Specify the last-seen ETag value to prevent accidentally deleting any concurrent changes.
  section = newJObject()
  var valid_568254 = header.getOrDefault("If-Match")
  valid_568254 = validateParameter(valid_568254, JString, required = false,
                                 default = nil)
  if valid_568254 != nil:
    section.add "If-Match", valid_568254
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568255: Call_PrivateZonesDelete_568247; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a Private DNS zone. WARNING: All DNS records in the zone will also be deleted. This operation cannot be undone. Private DNS zone cannot be deleted unless all virtual network links to it are removed.
  ## 
  let valid = call_568255.validator(path, query, header, formData, body)
  let scheme = call_568255.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568255.url(scheme.get, call_568255.host, call_568255.base,
                         call_568255.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568255, url, valid)

proc call*(call_568256: Call_PrivateZonesDelete_568247; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; privateZoneName: string): Recallable =
  ## privateZonesDelete
  ## Deletes a Private DNS zone. WARNING: All DNS records in the zone will also be deleted. This operation cannot be undone. Private DNS zone cannot be deleted unless all virtual network links to it are removed.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   privateZoneName: string (required)
  ##                  : The name of the Private DNS zone (without a terminating dot).
  var path_568257 = newJObject()
  var query_568258 = newJObject()
  add(path_568257, "resourceGroupName", newJString(resourceGroupName))
  add(query_568258, "api-version", newJString(apiVersion))
  add(path_568257, "subscriptionId", newJString(subscriptionId))
  add(path_568257, "privateZoneName", newJString(privateZoneName))
  result = call_568256.call(path_568257, query_568258, nil, nil, nil)

var privateZonesDelete* = Call_PrivateZonesDelete_568247(
    name: "privateZonesDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/privateDnsZones/{privateZoneName}",
    validator: validate_PrivateZonesDelete_568248, base: "",
    url: url_PrivateZonesDelete_568249, schemes: {Scheme.Https})
type
  Call_RecordSetsList_568273 = ref object of OpenApiRestCall_567657
proc url_RecordSetsList_568275(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "privateZoneName" in path, "`privateZoneName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/privateDnsZones/"),
               (kind: VariableSegment, value: "privateZoneName"),
               (kind: ConstantSegment, value: "/ALL")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RecordSetsList_568274(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Lists all record sets in a Private DNS zone.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   privateZoneName: JString (required)
  ##                  : The name of the Private DNS zone (without a terminating dot).
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568276 = path.getOrDefault("resourceGroupName")
  valid_568276 = validateParameter(valid_568276, JString, required = true,
                                 default = nil)
  if valid_568276 != nil:
    section.add "resourceGroupName", valid_568276
  var valid_568277 = path.getOrDefault("subscriptionId")
  valid_568277 = validateParameter(valid_568277, JString, required = true,
                                 default = nil)
  if valid_568277 != nil:
    section.add "subscriptionId", valid_568277
  var valid_568278 = path.getOrDefault("privateZoneName")
  valid_568278 = validateParameter(valid_568278, JString, required = true,
                                 default = nil)
  if valid_568278 != nil:
    section.add "privateZoneName", valid_568278
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $recordsetnamesuffix: JString
  ##                       : The suffix label of the record set name to be used to filter the record set enumeration. If this parameter is specified, the returned enumeration will only contain records that end with ".<recordsetnamesuffix>".
  ##   $top: JInt
  ##       : The maximum number of record sets to return. If not specified, returns up to 100 record sets.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568279 = query.getOrDefault("api-version")
  valid_568279 = validateParameter(valid_568279, JString, required = true,
                                 default = nil)
  if valid_568279 != nil:
    section.add "api-version", valid_568279
  var valid_568280 = query.getOrDefault("$recordsetnamesuffix")
  valid_568280 = validateParameter(valid_568280, JString, required = false,
                                 default = nil)
  if valid_568280 != nil:
    section.add "$recordsetnamesuffix", valid_568280
  var valid_568281 = query.getOrDefault("$top")
  valid_568281 = validateParameter(valid_568281, JInt, required = false, default = nil)
  if valid_568281 != nil:
    section.add "$top", valid_568281
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568282: Call_RecordSetsList_568273; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all record sets in a Private DNS zone.
  ## 
  let valid = call_568282.validator(path, query, header, formData, body)
  let scheme = call_568282.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568282.url(scheme.get, call_568282.host, call_568282.base,
                         call_568282.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568282, url, valid)

proc call*(call_568283: Call_RecordSetsList_568273; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; privateZoneName: string;
          Recordsetnamesuffix: string = ""; Top: int = 0): Recallable =
  ## recordSetsList
  ## Lists all record sets in a Private DNS zone.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   Recordsetnamesuffix: string
  ##                      : The suffix label of the record set name to be used to filter the record set enumeration. If this parameter is specified, the returned enumeration will only contain records that end with ".<recordsetnamesuffix>".
  ##   Top: int
  ##      : The maximum number of record sets to return. If not specified, returns up to 100 record sets.
  ##   privateZoneName: string (required)
  ##                  : The name of the Private DNS zone (without a terminating dot).
  var path_568284 = newJObject()
  var query_568285 = newJObject()
  add(path_568284, "resourceGroupName", newJString(resourceGroupName))
  add(query_568285, "api-version", newJString(apiVersion))
  add(path_568284, "subscriptionId", newJString(subscriptionId))
  add(query_568285, "$recordsetnamesuffix", newJString(Recordsetnamesuffix))
  add(query_568285, "$top", newJInt(Top))
  add(path_568284, "privateZoneName", newJString(privateZoneName))
  result = call_568283.call(path_568284, query_568285, nil, nil, nil)

var recordSetsList* = Call_RecordSetsList_568273(name: "recordSetsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/privateDnsZones/{privateZoneName}/ALL",
    validator: validate_RecordSetsList_568274, base: "", url: url_RecordSetsList_568275,
    schemes: {Scheme.Https})
type
  Call_VirtualNetworkLinksList_568286 = ref object of OpenApiRestCall_567657
proc url_VirtualNetworkLinksList_568288(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "privateZoneName" in path, "`privateZoneName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/privateDnsZones/"),
               (kind: VariableSegment, value: "privateZoneName"),
               (kind: ConstantSegment, value: "/virtualNetworkLinks")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualNetworkLinksList_568287(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the virtual network links to the specified Private DNS zone.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   privateZoneName: JString (required)
  ##                  : The name of the Private DNS zone (without a terminating dot).
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568289 = path.getOrDefault("resourceGroupName")
  valid_568289 = validateParameter(valid_568289, JString, required = true,
                                 default = nil)
  if valid_568289 != nil:
    section.add "resourceGroupName", valid_568289
  var valid_568290 = path.getOrDefault("subscriptionId")
  valid_568290 = validateParameter(valid_568290, JString, required = true,
                                 default = nil)
  if valid_568290 != nil:
    section.add "subscriptionId", valid_568290
  var valid_568291 = path.getOrDefault("privateZoneName")
  valid_568291 = validateParameter(valid_568291, JString, required = true,
                                 default = nil)
  if valid_568291 != nil:
    section.add "privateZoneName", valid_568291
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $top: JInt
  ##       : The maximum number of virtual network links to return. If not specified, returns up to 100 virtual network links.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568292 = query.getOrDefault("api-version")
  valid_568292 = validateParameter(valid_568292, JString, required = true,
                                 default = nil)
  if valid_568292 != nil:
    section.add "api-version", valid_568292
  var valid_568293 = query.getOrDefault("$top")
  valid_568293 = validateParameter(valid_568293, JInt, required = false, default = nil)
  if valid_568293 != nil:
    section.add "$top", valid_568293
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568294: Call_VirtualNetworkLinksList_568286; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the virtual network links to the specified Private DNS zone.
  ## 
  let valid = call_568294.validator(path, query, header, formData, body)
  let scheme = call_568294.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568294.url(scheme.get, call_568294.host, call_568294.base,
                         call_568294.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568294, url, valid)

proc call*(call_568295: Call_VirtualNetworkLinksList_568286;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          privateZoneName: string; Top: int = 0): Recallable =
  ## virtualNetworkLinksList
  ## Lists the virtual network links to the specified Private DNS zone.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   Top: int
  ##      : The maximum number of virtual network links to return. If not specified, returns up to 100 virtual network links.
  ##   privateZoneName: string (required)
  ##                  : The name of the Private DNS zone (without a terminating dot).
  var path_568296 = newJObject()
  var query_568297 = newJObject()
  add(path_568296, "resourceGroupName", newJString(resourceGroupName))
  add(query_568297, "api-version", newJString(apiVersion))
  add(path_568296, "subscriptionId", newJString(subscriptionId))
  add(query_568297, "$top", newJInt(Top))
  add(path_568296, "privateZoneName", newJString(privateZoneName))
  result = call_568295.call(path_568296, query_568297, nil, nil, nil)

var virtualNetworkLinksList* = Call_VirtualNetworkLinksList_568286(
    name: "virtualNetworkLinksList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/privateDnsZones/{privateZoneName}/virtualNetworkLinks",
    validator: validate_VirtualNetworkLinksList_568287, base: "",
    url: url_VirtualNetworkLinksList_568288, schemes: {Scheme.Https})
type
  Call_VirtualNetworkLinksCreateOrUpdate_568310 = ref object of OpenApiRestCall_567657
proc url_VirtualNetworkLinksCreateOrUpdate_568312(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "privateZoneName" in path, "`privateZoneName` is a required path parameter"
  assert "virtualNetworkLinkName" in path,
        "`virtualNetworkLinkName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/privateDnsZones/"),
               (kind: VariableSegment, value: "privateZoneName"),
               (kind: ConstantSegment, value: "/virtualNetworkLinks/"),
               (kind: VariableSegment, value: "virtualNetworkLinkName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualNetworkLinksCreateOrUpdate_568311(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates a virtual network link to the specified Private DNS zone.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   virtualNetworkLinkName: JString (required)
  ##                         : The name of the virtual network link.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   privateZoneName: JString (required)
  ##                  : The name of the Private DNS zone (without a terminating dot).
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568313 = path.getOrDefault("resourceGroupName")
  valid_568313 = validateParameter(valid_568313, JString, required = true,
                                 default = nil)
  if valid_568313 != nil:
    section.add "resourceGroupName", valid_568313
  var valid_568314 = path.getOrDefault("virtualNetworkLinkName")
  valid_568314 = validateParameter(valid_568314, JString, required = true,
                                 default = nil)
  if valid_568314 != nil:
    section.add "virtualNetworkLinkName", valid_568314
  var valid_568315 = path.getOrDefault("subscriptionId")
  valid_568315 = validateParameter(valid_568315, JString, required = true,
                                 default = nil)
  if valid_568315 != nil:
    section.add "subscriptionId", valid_568315
  var valid_568316 = path.getOrDefault("privateZoneName")
  valid_568316 = validateParameter(valid_568316, JString, required = true,
                                 default = nil)
  if valid_568316 != nil:
    section.add "privateZoneName", valid_568316
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568317 = query.getOrDefault("api-version")
  valid_568317 = validateParameter(valid_568317, JString, required = true,
                                 default = nil)
  if valid_568317 != nil:
    section.add "api-version", valid_568317
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : The ETag of the virtual network link to the Private DNS zone. Omit this value to always overwrite the current virtual network link. Specify the last-seen ETag value to prevent accidentally overwriting any concurrent changes.
  ##   If-None-Match: JString
  ##                : Set to '*' to allow a new virtual network link to the Private DNS zone to be created, but to prevent updating an existing link. Other values will be ignored.
  section = newJObject()
  var valid_568318 = header.getOrDefault("If-Match")
  valid_568318 = validateParameter(valid_568318, JString, required = false,
                                 default = nil)
  if valid_568318 != nil:
    section.add "If-Match", valid_568318
  var valid_568319 = header.getOrDefault("If-None-Match")
  valid_568319 = validateParameter(valid_568319, JString, required = false,
                                 default = nil)
  if valid_568319 != nil:
    section.add "If-None-Match", valid_568319
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the CreateOrUpdate operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568321: Call_VirtualNetworkLinksCreateOrUpdate_568310;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates a virtual network link to the specified Private DNS zone.
  ## 
  let valid = call_568321.validator(path, query, header, formData, body)
  let scheme = call_568321.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568321.url(scheme.get, call_568321.host, call_568321.base,
                         call_568321.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568321, url, valid)

proc call*(call_568322: Call_VirtualNetworkLinksCreateOrUpdate_568310;
          resourceGroupName: string; apiVersion: string;
          virtualNetworkLinkName: string; subscriptionId: string;
          privateZoneName: string; parameters: JsonNode): Recallable =
  ## virtualNetworkLinksCreateOrUpdate
  ## Creates or updates a virtual network link to the specified Private DNS zone.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   virtualNetworkLinkName: string (required)
  ##                         : The name of the virtual network link.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   privateZoneName: string (required)
  ##                  : The name of the Private DNS zone (without a terminating dot).
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the CreateOrUpdate operation.
  var path_568323 = newJObject()
  var query_568324 = newJObject()
  var body_568325 = newJObject()
  add(path_568323, "resourceGroupName", newJString(resourceGroupName))
  add(query_568324, "api-version", newJString(apiVersion))
  add(path_568323, "virtualNetworkLinkName", newJString(virtualNetworkLinkName))
  add(path_568323, "subscriptionId", newJString(subscriptionId))
  add(path_568323, "privateZoneName", newJString(privateZoneName))
  if parameters != nil:
    body_568325 = parameters
  result = call_568322.call(path_568323, query_568324, nil, nil, body_568325)

var virtualNetworkLinksCreateOrUpdate* = Call_VirtualNetworkLinksCreateOrUpdate_568310(
    name: "virtualNetworkLinksCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/privateDnsZones/{privateZoneName}/virtualNetworkLinks/{virtualNetworkLinkName}",
    validator: validate_VirtualNetworkLinksCreateOrUpdate_568311, base: "",
    url: url_VirtualNetworkLinksCreateOrUpdate_568312, schemes: {Scheme.Https})
type
  Call_VirtualNetworkLinksGet_568298 = ref object of OpenApiRestCall_567657
proc url_VirtualNetworkLinksGet_568300(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "privateZoneName" in path, "`privateZoneName` is a required path parameter"
  assert "virtualNetworkLinkName" in path,
        "`virtualNetworkLinkName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/privateDnsZones/"),
               (kind: VariableSegment, value: "privateZoneName"),
               (kind: ConstantSegment, value: "/virtualNetworkLinks/"),
               (kind: VariableSegment, value: "virtualNetworkLinkName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualNetworkLinksGet_568299(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a virtual network link to the specified Private DNS zone.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   virtualNetworkLinkName: JString (required)
  ##                         : The name of the virtual network link.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   privateZoneName: JString (required)
  ##                  : The name of the Private DNS zone (without a terminating dot).
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568301 = path.getOrDefault("resourceGroupName")
  valid_568301 = validateParameter(valid_568301, JString, required = true,
                                 default = nil)
  if valid_568301 != nil:
    section.add "resourceGroupName", valid_568301
  var valid_568302 = path.getOrDefault("virtualNetworkLinkName")
  valid_568302 = validateParameter(valid_568302, JString, required = true,
                                 default = nil)
  if valid_568302 != nil:
    section.add "virtualNetworkLinkName", valid_568302
  var valid_568303 = path.getOrDefault("subscriptionId")
  valid_568303 = validateParameter(valid_568303, JString, required = true,
                                 default = nil)
  if valid_568303 != nil:
    section.add "subscriptionId", valid_568303
  var valid_568304 = path.getOrDefault("privateZoneName")
  valid_568304 = validateParameter(valid_568304, JString, required = true,
                                 default = nil)
  if valid_568304 != nil:
    section.add "privateZoneName", valid_568304
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568305 = query.getOrDefault("api-version")
  valid_568305 = validateParameter(valid_568305, JString, required = true,
                                 default = nil)
  if valid_568305 != nil:
    section.add "api-version", valid_568305
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568306: Call_VirtualNetworkLinksGet_568298; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a virtual network link to the specified Private DNS zone.
  ## 
  let valid = call_568306.validator(path, query, header, formData, body)
  let scheme = call_568306.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568306.url(scheme.get, call_568306.host, call_568306.base,
                         call_568306.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568306, url, valid)

proc call*(call_568307: Call_VirtualNetworkLinksGet_568298;
          resourceGroupName: string; apiVersion: string;
          virtualNetworkLinkName: string; subscriptionId: string;
          privateZoneName: string): Recallable =
  ## virtualNetworkLinksGet
  ## Gets a virtual network link to the specified Private DNS zone.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   virtualNetworkLinkName: string (required)
  ##                         : The name of the virtual network link.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   privateZoneName: string (required)
  ##                  : The name of the Private DNS zone (without a terminating dot).
  var path_568308 = newJObject()
  var query_568309 = newJObject()
  add(path_568308, "resourceGroupName", newJString(resourceGroupName))
  add(query_568309, "api-version", newJString(apiVersion))
  add(path_568308, "virtualNetworkLinkName", newJString(virtualNetworkLinkName))
  add(path_568308, "subscriptionId", newJString(subscriptionId))
  add(path_568308, "privateZoneName", newJString(privateZoneName))
  result = call_568307.call(path_568308, query_568309, nil, nil, nil)

var virtualNetworkLinksGet* = Call_VirtualNetworkLinksGet_568298(
    name: "virtualNetworkLinksGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/privateDnsZones/{privateZoneName}/virtualNetworkLinks/{virtualNetworkLinkName}",
    validator: validate_VirtualNetworkLinksGet_568299, base: "",
    url: url_VirtualNetworkLinksGet_568300, schemes: {Scheme.Https})
type
  Call_VirtualNetworkLinksUpdate_568339 = ref object of OpenApiRestCall_567657
proc url_VirtualNetworkLinksUpdate_568341(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "privateZoneName" in path, "`privateZoneName` is a required path parameter"
  assert "virtualNetworkLinkName" in path,
        "`virtualNetworkLinkName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/privateDnsZones/"),
               (kind: VariableSegment, value: "privateZoneName"),
               (kind: ConstantSegment, value: "/virtualNetworkLinks/"),
               (kind: VariableSegment, value: "virtualNetworkLinkName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualNetworkLinksUpdate_568340(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates a virtual network link to the specified Private DNS zone.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   virtualNetworkLinkName: JString (required)
  ##                         : The name of the virtual network link.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   privateZoneName: JString (required)
  ##                  : The name of the Private DNS zone (without a terminating dot).
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568342 = path.getOrDefault("resourceGroupName")
  valid_568342 = validateParameter(valid_568342, JString, required = true,
                                 default = nil)
  if valid_568342 != nil:
    section.add "resourceGroupName", valid_568342
  var valid_568343 = path.getOrDefault("virtualNetworkLinkName")
  valid_568343 = validateParameter(valid_568343, JString, required = true,
                                 default = nil)
  if valid_568343 != nil:
    section.add "virtualNetworkLinkName", valid_568343
  var valid_568344 = path.getOrDefault("subscriptionId")
  valid_568344 = validateParameter(valid_568344, JString, required = true,
                                 default = nil)
  if valid_568344 != nil:
    section.add "subscriptionId", valid_568344
  var valid_568345 = path.getOrDefault("privateZoneName")
  valid_568345 = validateParameter(valid_568345, JString, required = true,
                                 default = nil)
  if valid_568345 != nil:
    section.add "privateZoneName", valid_568345
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568346 = query.getOrDefault("api-version")
  valid_568346 = validateParameter(valid_568346, JString, required = true,
                                 default = nil)
  if valid_568346 != nil:
    section.add "api-version", valid_568346
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : The ETag of the virtual network link to the Private DNS zone. Omit this value to always overwrite the current virtual network link. Specify the last-seen ETag value to prevent accidentally overwriting any concurrent changes.
  section = newJObject()
  var valid_568347 = header.getOrDefault("If-Match")
  valid_568347 = validateParameter(valid_568347, JString, required = false,
                                 default = nil)
  if valid_568347 != nil:
    section.add "If-Match", valid_568347
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the Update operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568349: Call_VirtualNetworkLinksUpdate_568339; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a virtual network link to the specified Private DNS zone.
  ## 
  let valid = call_568349.validator(path, query, header, formData, body)
  let scheme = call_568349.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568349.url(scheme.get, call_568349.host, call_568349.base,
                         call_568349.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568349, url, valid)

proc call*(call_568350: Call_VirtualNetworkLinksUpdate_568339;
          resourceGroupName: string; apiVersion: string;
          virtualNetworkLinkName: string; subscriptionId: string;
          privateZoneName: string; parameters: JsonNode): Recallable =
  ## virtualNetworkLinksUpdate
  ## Updates a virtual network link to the specified Private DNS zone.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   virtualNetworkLinkName: string (required)
  ##                         : The name of the virtual network link.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   privateZoneName: string (required)
  ##                  : The name of the Private DNS zone (without a terminating dot).
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the Update operation.
  var path_568351 = newJObject()
  var query_568352 = newJObject()
  var body_568353 = newJObject()
  add(path_568351, "resourceGroupName", newJString(resourceGroupName))
  add(query_568352, "api-version", newJString(apiVersion))
  add(path_568351, "virtualNetworkLinkName", newJString(virtualNetworkLinkName))
  add(path_568351, "subscriptionId", newJString(subscriptionId))
  add(path_568351, "privateZoneName", newJString(privateZoneName))
  if parameters != nil:
    body_568353 = parameters
  result = call_568350.call(path_568351, query_568352, nil, nil, body_568353)

var virtualNetworkLinksUpdate* = Call_VirtualNetworkLinksUpdate_568339(
    name: "virtualNetworkLinksUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/privateDnsZones/{privateZoneName}/virtualNetworkLinks/{virtualNetworkLinkName}",
    validator: validate_VirtualNetworkLinksUpdate_568340, base: "",
    url: url_VirtualNetworkLinksUpdate_568341, schemes: {Scheme.Https})
type
  Call_VirtualNetworkLinksDelete_568326 = ref object of OpenApiRestCall_567657
proc url_VirtualNetworkLinksDelete_568328(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "privateZoneName" in path, "`privateZoneName` is a required path parameter"
  assert "virtualNetworkLinkName" in path,
        "`virtualNetworkLinkName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/privateDnsZones/"),
               (kind: VariableSegment, value: "privateZoneName"),
               (kind: ConstantSegment, value: "/virtualNetworkLinks/"),
               (kind: VariableSegment, value: "virtualNetworkLinkName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualNetworkLinksDelete_568327(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a virtual network link to the specified Private DNS zone. WARNING: In case of a registration virtual network, all auto-registered DNS records in the zone for the virtual network will also be deleted. This operation cannot be undone.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   virtualNetworkLinkName: JString (required)
  ##                         : The name of the virtual network link.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   privateZoneName: JString (required)
  ##                  : The name of the Private DNS zone (without a terminating dot).
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568329 = path.getOrDefault("resourceGroupName")
  valid_568329 = validateParameter(valid_568329, JString, required = true,
                                 default = nil)
  if valid_568329 != nil:
    section.add "resourceGroupName", valid_568329
  var valid_568330 = path.getOrDefault("virtualNetworkLinkName")
  valid_568330 = validateParameter(valid_568330, JString, required = true,
                                 default = nil)
  if valid_568330 != nil:
    section.add "virtualNetworkLinkName", valid_568330
  var valid_568331 = path.getOrDefault("subscriptionId")
  valid_568331 = validateParameter(valid_568331, JString, required = true,
                                 default = nil)
  if valid_568331 != nil:
    section.add "subscriptionId", valid_568331
  var valid_568332 = path.getOrDefault("privateZoneName")
  valid_568332 = validateParameter(valid_568332, JString, required = true,
                                 default = nil)
  if valid_568332 != nil:
    section.add "privateZoneName", valid_568332
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568333 = query.getOrDefault("api-version")
  valid_568333 = validateParameter(valid_568333, JString, required = true,
                                 default = nil)
  if valid_568333 != nil:
    section.add "api-version", valid_568333
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : The ETag of the virtual network link to the Private DNS zone. Omit this value to always delete the current zone. Specify the last-seen ETag value to prevent accidentally deleting any concurrent changes.
  section = newJObject()
  var valid_568334 = header.getOrDefault("If-Match")
  valid_568334 = validateParameter(valid_568334, JString, required = false,
                                 default = nil)
  if valid_568334 != nil:
    section.add "If-Match", valid_568334
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568335: Call_VirtualNetworkLinksDelete_568326; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a virtual network link to the specified Private DNS zone. WARNING: In case of a registration virtual network, all auto-registered DNS records in the zone for the virtual network will also be deleted. This operation cannot be undone.
  ## 
  let valid = call_568335.validator(path, query, header, formData, body)
  let scheme = call_568335.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568335.url(scheme.get, call_568335.host, call_568335.base,
                         call_568335.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568335, url, valid)

proc call*(call_568336: Call_VirtualNetworkLinksDelete_568326;
          resourceGroupName: string; apiVersion: string;
          virtualNetworkLinkName: string; subscriptionId: string;
          privateZoneName: string): Recallable =
  ## virtualNetworkLinksDelete
  ## Deletes a virtual network link to the specified Private DNS zone. WARNING: In case of a registration virtual network, all auto-registered DNS records in the zone for the virtual network will also be deleted. This operation cannot be undone.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   virtualNetworkLinkName: string (required)
  ##                         : The name of the virtual network link.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   privateZoneName: string (required)
  ##                  : The name of the Private DNS zone (without a terminating dot).
  var path_568337 = newJObject()
  var query_568338 = newJObject()
  add(path_568337, "resourceGroupName", newJString(resourceGroupName))
  add(query_568338, "api-version", newJString(apiVersion))
  add(path_568337, "virtualNetworkLinkName", newJString(virtualNetworkLinkName))
  add(path_568337, "subscriptionId", newJString(subscriptionId))
  add(path_568337, "privateZoneName", newJString(privateZoneName))
  result = call_568336.call(path_568337, query_568338, nil, nil, nil)

var virtualNetworkLinksDelete* = Call_VirtualNetworkLinksDelete_568326(
    name: "virtualNetworkLinksDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/privateDnsZones/{privateZoneName}/virtualNetworkLinks/{virtualNetworkLinkName}",
    validator: validate_VirtualNetworkLinksDelete_568327, base: "",
    url: url_VirtualNetworkLinksDelete_568328, schemes: {Scheme.Https})
type
  Call_RecordSetsListByType_568354 = ref object of OpenApiRestCall_567657
proc url_RecordSetsListByType_568356(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "privateZoneName" in path, "`privateZoneName` is a required path parameter"
  assert "recordType" in path, "`recordType` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/privateDnsZones/"),
               (kind: VariableSegment, value: "privateZoneName"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "recordType")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RecordSetsListByType_568355(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the record sets of a specified type in a Private DNS zone.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   recordType: JString (required)
  ##             : The type of record sets to enumerate.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   privateZoneName: JString (required)
  ##                  : The name of the Private DNS zone (without a terminating dot).
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568357 = path.getOrDefault("resourceGroupName")
  valid_568357 = validateParameter(valid_568357, JString, required = true,
                                 default = nil)
  if valid_568357 != nil:
    section.add "resourceGroupName", valid_568357
  var valid_568371 = path.getOrDefault("recordType")
  valid_568371 = validateParameter(valid_568371, JString, required = true,
                                 default = newJString("A"))
  if valid_568371 != nil:
    section.add "recordType", valid_568371
  var valid_568372 = path.getOrDefault("subscriptionId")
  valid_568372 = validateParameter(valid_568372, JString, required = true,
                                 default = nil)
  if valid_568372 != nil:
    section.add "subscriptionId", valid_568372
  var valid_568373 = path.getOrDefault("privateZoneName")
  valid_568373 = validateParameter(valid_568373, JString, required = true,
                                 default = nil)
  if valid_568373 != nil:
    section.add "privateZoneName", valid_568373
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $recordsetnamesuffix: JString
  ##                       : The suffix label of the record set name to be used to filter the record set enumeration. If this parameter is specified, the returned enumeration will only contain records that end with ".<recordsetnamesuffix>".
  ##   $top: JInt
  ##       : The maximum number of record sets to return. If not specified, returns up to 100 record sets.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568374 = query.getOrDefault("api-version")
  valid_568374 = validateParameter(valid_568374, JString, required = true,
                                 default = nil)
  if valid_568374 != nil:
    section.add "api-version", valid_568374
  var valid_568375 = query.getOrDefault("$recordsetnamesuffix")
  valid_568375 = validateParameter(valid_568375, JString, required = false,
                                 default = nil)
  if valid_568375 != nil:
    section.add "$recordsetnamesuffix", valid_568375
  var valid_568376 = query.getOrDefault("$top")
  valid_568376 = validateParameter(valid_568376, JInt, required = false, default = nil)
  if valid_568376 != nil:
    section.add "$top", valid_568376
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568377: Call_RecordSetsListByType_568354; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the record sets of a specified type in a Private DNS zone.
  ## 
  let valid = call_568377.validator(path, query, header, formData, body)
  let scheme = call_568377.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568377.url(scheme.get, call_568377.host, call_568377.base,
                         call_568377.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568377, url, valid)

proc call*(call_568378: Call_RecordSetsListByType_568354;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          privateZoneName: string; recordType: string = "A";
          Recordsetnamesuffix: string = ""; Top: int = 0): Recallable =
  ## recordSetsListByType
  ## Lists the record sets of a specified type in a Private DNS zone.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   recordType: string (required)
  ##             : The type of record sets to enumerate.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   Recordsetnamesuffix: string
  ##                      : The suffix label of the record set name to be used to filter the record set enumeration. If this parameter is specified, the returned enumeration will only contain records that end with ".<recordsetnamesuffix>".
  ##   Top: int
  ##      : The maximum number of record sets to return. If not specified, returns up to 100 record sets.
  ##   privateZoneName: string (required)
  ##                  : The name of the Private DNS zone (without a terminating dot).
  var path_568379 = newJObject()
  var query_568380 = newJObject()
  add(path_568379, "resourceGroupName", newJString(resourceGroupName))
  add(query_568380, "api-version", newJString(apiVersion))
  add(path_568379, "recordType", newJString(recordType))
  add(path_568379, "subscriptionId", newJString(subscriptionId))
  add(query_568380, "$recordsetnamesuffix", newJString(Recordsetnamesuffix))
  add(query_568380, "$top", newJInt(Top))
  add(path_568379, "privateZoneName", newJString(privateZoneName))
  result = call_568378.call(path_568379, query_568380, nil, nil, nil)

var recordSetsListByType* = Call_RecordSetsListByType_568354(
    name: "recordSetsListByType", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/privateDnsZones/{privateZoneName}/{recordType}",
    validator: validate_RecordSetsListByType_568355, base: "",
    url: url_RecordSetsListByType_568356, schemes: {Scheme.Https})
type
  Call_RecordSetsCreateOrUpdate_568394 = ref object of OpenApiRestCall_567657
proc url_RecordSetsCreateOrUpdate_568396(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "privateZoneName" in path, "`privateZoneName` is a required path parameter"
  assert "recordType" in path, "`recordType` is a required path parameter"
  assert "relativeRecordSetName" in path,
        "`relativeRecordSetName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/privateDnsZones/"),
               (kind: VariableSegment, value: "privateZoneName"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "recordType"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "relativeRecordSetName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RecordSetsCreateOrUpdate_568395(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates a record set within a Private DNS zone.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   recordType: JString (required)
  ##             : The type of DNS record in this record set. Record sets of type SOA can be updated but not created (they are created when the Private DNS zone is created).
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   privateZoneName: JString (required)
  ##                  : The name of the Private DNS zone (without a terminating dot).
  ##   relativeRecordSetName: JString (required)
  ##                        : The name of the record set, relative to the name of the zone.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568397 = path.getOrDefault("resourceGroupName")
  valid_568397 = validateParameter(valid_568397, JString, required = true,
                                 default = nil)
  if valid_568397 != nil:
    section.add "resourceGroupName", valid_568397
  var valid_568398 = path.getOrDefault("recordType")
  valid_568398 = validateParameter(valid_568398, JString, required = true,
                                 default = newJString("A"))
  if valid_568398 != nil:
    section.add "recordType", valid_568398
  var valid_568399 = path.getOrDefault("subscriptionId")
  valid_568399 = validateParameter(valid_568399, JString, required = true,
                                 default = nil)
  if valid_568399 != nil:
    section.add "subscriptionId", valid_568399
  var valid_568400 = path.getOrDefault("privateZoneName")
  valid_568400 = validateParameter(valid_568400, JString, required = true,
                                 default = nil)
  if valid_568400 != nil:
    section.add "privateZoneName", valid_568400
  var valid_568401 = path.getOrDefault("relativeRecordSetName")
  valid_568401 = validateParameter(valid_568401, JString, required = true,
                                 default = nil)
  if valid_568401 != nil:
    section.add "relativeRecordSetName", valid_568401
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568402 = query.getOrDefault("api-version")
  valid_568402 = validateParameter(valid_568402, JString, required = true,
                                 default = nil)
  if valid_568402 != nil:
    section.add "api-version", valid_568402
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : The ETag of the record set. Omit this value to always overwrite the current record set. Specify the last-seen ETag value to prevent accidentally overwriting any concurrent changes.
  ##   If-None-Match: JString
  ##                : Set to '*' to allow a new record set to be created, but to prevent updating an existing record set. Other values will be ignored.
  section = newJObject()
  var valid_568403 = header.getOrDefault("If-Match")
  valid_568403 = validateParameter(valid_568403, JString, required = false,
                                 default = nil)
  if valid_568403 != nil:
    section.add "If-Match", valid_568403
  var valid_568404 = header.getOrDefault("If-None-Match")
  valid_568404 = validateParameter(valid_568404, JString, required = false,
                                 default = nil)
  if valid_568404 != nil:
    section.add "If-None-Match", valid_568404
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the CreateOrUpdate operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568406: Call_RecordSetsCreateOrUpdate_568394; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates a record set within a Private DNS zone.
  ## 
  let valid = call_568406.validator(path, query, header, formData, body)
  let scheme = call_568406.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568406.url(scheme.get, call_568406.host, call_568406.base,
                         call_568406.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568406, url, valid)

proc call*(call_568407: Call_RecordSetsCreateOrUpdate_568394;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          privateZoneName: string; parameters: JsonNode;
          relativeRecordSetName: string; recordType: string = "A"): Recallable =
  ## recordSetsCreateOrUpdate
  ## Creates or updates a record set within a Private DNS zone.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   recordType: string (required)
  ##             : The type of DNS record in this record set. Record sets of type SOA can be updated but not created (they are created when the Private DNS zone is created).
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   privateZoneName: string (required)
  ##                  : The name of the Private DNS zone (without a terminating dot).
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the CreateOrUpdate operation.
  ##   relativeRecordSetName: string (required)
  ##                        : The name of the record set, relative to the name of the zone.
  var path_568408 = newJObject()
  var query_568409 = newJObject()
  var body_568410 = newJObject()
  add(path_568408, "resourceGroupName", newJString(resourceGroupName))
  add(query_568409, "api-version", newJString(apiVersion))
  add(path_568408, "recordType", newJString(recordType))
  add(path_568408, "subscriptionId", newJString(subscriptionId))
  add(path_568408, "privateZoneName", newJString(privateZoneName))
  if parameters != nil:
    body_568410 = parameters
  add(path_568408, "relativeRecordSetName", newJString(relativeRecordSetName))
  result = call_568407.call(path_568408, query_568409, nil, nil, body_568410)

var recordSetsCreateOrUpdate* = Call_RecordSetsCreateOrUpdate_568394(
    name: "recordSetsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/privateDnsZones/{privateZoneName}/{recordType}/{relativeRecordSetName}",
    validator: validate_RecordSetsCreateOrUpdate_568395, base: "",
    url: url_RecordSetsCreateOrUpdate_568396, schemes: {Scheme.Https})
type
  Call_RecordSetsGet_568381 = ref object of OpenApiRestCall_567657
proc url_RecordSetsGet_568383(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "privateZoneName" in path, "`privateZoneName` is a required path parameter"
  assert "recordType" in path, "`recordType` is a required path parameter"
  assert "relativeRecordSetName" in path,
        "`relativeRecordSetName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/privateDnsZones/"),
               (kind: VariableSegment, value: "privateZoneName"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "recordType"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "relativeRecordSetName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RecordSetsGet_568382(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a record set.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   recordType: JString (required)
  ##             : The type of DNS record in this record set.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   privateZoneName: JString (required)
  ##                  : The name of the Private DNS zone (without a terminating dot).
  ##   relativeRecordSetName: JString (required)
  ##                        : The name of the record set, relative to the name of the zone.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568384 = path.getOrDefault("resourceGroupName")
  valid_568384 = validateParameter(valid_568384, JString, required = true,
                                 default = nil)
  if valid_568384 != nil:
    section.add "resourceGroupName", valid_568384
  var valid_568385 = path.getOrDefault("recordType")
  valid_568385 = validateParameter(valid_568385, JString, required = true,
                                 default = newJString("A"))
  if valid_568385 != nil:
    section.add "recordType", valid_568385
  var valid_568386 = path.getOrDefault("subscriptionId")
  valid_568386 = validateParameter(valid_568386, JString, required = true,
                                 default = nil)
  if valid_568386 != nil:
    section.add "subscriptionId", valid_568386
  var valid_568387 = path.getOrDefault("privateZoneName")
  valid_568387 = validateParameter(valid_568387, JString, required = true,
                                 default = nil)
  if valid_568387 != nil:
    section.add "privateZoneName", valid_568387
  var valid_568388 = path.getOrDefault("relativeRecordSetName")
  valid_568388 = validateParameter(valid_568388, JString, required = true,
                                 default = nil)
  if valid_568388 != nil:
    section.add "relativeRecordSetName", valid_568388
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568389 = query.getOrDefault("api-version")
  valid_568389 = validateParameter(valid_568389, JString, required = true,
                                 default = nil)
  if valid_568389 != nil:
    section.add "api-version", valid_568389
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568390: Call_RecordSetsGet_568381; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a record set.
  ## 
  let valid = call_568390.validator(path, query, header, formData, body)
  let scheme = call_568390.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568390.url(scheme.get, call_568390.host, call_568390.base,
                         call_568390.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568390, url, valid)

proc call*(call_568391: Call_RecordSetsGet_568381; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; privateZoneName: string;
          relativeRecordSetName: string; recordType: string = "A"): Recallable =
  ## recordSetsGet
  ## Gets a record set.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   recordType: string (required)
  ##             : The type of DNS record in this record set.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   privateZoneName: string (required)
  ##                  : The name of the Private DNS zone (without a terminating dot).
  ##   relativeRecordSetName: string (required)
  ##                        : The name of the record set, relative to the name of the zone.
  var path_568392 = newJObject()
  var query_568393 = newJObject()
  add(path_568392, "resourceGroupName", newJString(resourceGroupName))
  add(query_568393, "api-version", newJString(apiVersion))
  add(path_568392, "recordType", newJString(recordType))
  add(path_568392, "subscriptionId", newJString(subscriptionId))
  add(path_568392, "privateZoneName", newJString(privateZoneName))
  add(path_568392, "relativeRecordSetName", newJString(relativeRecordSetName))
  result = call_568391.call(path_568392, query_568393, nil, nil, nil)

var recordSetsGet* = Call_RecordSetsGet_568381(name: "recordSetsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/privateDnsZones/{privateZoneName}/{recordType}/{relativeRecordSetName}",
    validator: validate_RecordSetsGet_568382, base: "", url: url_RecordSetsGet_568383,
    schemes: {Scheme.Https})
type
  Call_RecordSetsUpdate_568425 = ref object of OpenApiRestCall_567657
proc url_RecordSetsUpdate_568427(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "privateZoneName" in path, "`privateZoneName` is a required path parameter"
  assert "recordType" in path, "`recordType` is a required path parameter"
  assert "relativeRecordSetName" in path,
        "`relativeRecordSetName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/privateDnsZones/"),
               (kind: VariableSegment, value: "privateZoneName"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "recordType"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "relativeRecordSetName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RecordSetsUpdate_568426(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Updates a record set within a Private DNS zone.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   recordType: JString (required)
  ##             : The type of DNS record in this record set.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   privateZoneName: JString (required)
  ##                  : The name of the Private DNS zone (without a terminating dot).
  ##   relativeRecordSetName: JString (required)
  ##                        : The name of the record set, relative to the name of the zone.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568428 = path.getOrDefault("resourceGroupName")
  valid_568428 = validateParameter(valid_568428, JString, required = true,
                                 default = nil)
  if valid_568428 != nil:
    section.add "resourceGroupName", valid_568428
  var valid_568429 = path.getOrDefault("recordType")
  valid_568429 = validateParameter(valid_568429, JString, required = true,
                                 default = newJString("A"))
  if valid_568429 != nil:
    section.add "recordType", valid_568429
  var valid_568430 = path.getOrDefault("subscriptionId")
  valid_568430 = validateParameter(valid_568430, JString, required = true,
                                 default = nil)
  if valid_568430 != nil:
    section.add "subscriptionId", valid_568430
  var valid_568431 = path.getOrDefault("privateZoneName")
  valid_568431 = validateParameter(valid_568431, JString, required = true,
                                 default = nil)
  if valid_568431 != nil:
    section.add "privateZoneName", valid_568431
  var valid_568432 = path.getOrDefault("relativeRecordSetName")
  valid_568432 = validateParameter(valid_568432, JString, required = true,
                                 default = nil)
  if valid_568432 != nil:
    section.add "relativeRecordSetName", valid_568432
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568433 = query.getOrDefault("api-version")
  valid_568433 = validateParameter(valid_568433, JString, required = true,
                                 default = nil)
  if valid_568433 != nil:
    section.add "api-version", valid_568433
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : The ETag of the record set. Omit this value to always overwrite the current record set. Specify the last-seen ETag value to prevent accidentally overwriting concurrent changes.
  section = newJObject()
  var valid_568434 = header.getOrDefault("If-Match")
  valid_568434 = validateParameter(valid_568434, JString, required = false,
                                 default = nil)
  if valid_568434 != nil:
    section.add "If-Match", valid_568434
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the Update operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568436: Call_RecordSetsUpdate_568425; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a record set within a Private DNS zone.
  ## 
  let valid = call_568436.validator(path, query, header, formData, body)
  let scheme = call_568436.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568436.url(scheme.get, call_568436.host, call_568436.base,
                         call_568436.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568436, url, valid)

proc call*(call_568437: Call_RecordSetsUpdate_568425; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; privateZoneName: string;
          parameters: JsonNode; relativeRecordSetName: string;
          recordType: string = "A"): Recallable =
  ## recordSetsUpdate
  ## Updates a record set within a Private DNS zone.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   recordType: string (required)
  ##             : The type of DNS record in this record set.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   privateZoneName: string (required)
  ##                  : The name of the Private DNS zone (without a terminating dot).
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the Update operation.
  ##   relativeRecordSetName: string (required)
  ##                        : The name of the record set, relative to the name of the zone.
  var path_568438 = newJObject()
  var query_568439 = newJObject()
  var body_568440 = newJObject()
  add(path_568438, "resourceGroupName", newJString(resourceGroupName))
  add(query_568439, "api-version", newJString(apiVersion))
  add(path_568438, "recordType", newJString(recordType))
  add(path_568438, "subscriptionId", newJString(subscriptionId))
  add(path_568438, "privateZoneName", newJString(privateZoneName))
  if parameters != nil:
    body_568440 = parameters
  add(path_568438, "relativeRecordSetName", newJString(relativeRecordSetName))
  result = call_568437.call(path_568438, query_568439, nil, nil, body_568440)

var recordSetsUpdate* = Call_RecordSetsUpdate_568425(name: "recordSetsUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/privateDnsZones/{privateZoneName}/{recordType}/{relativeRecordSetName}",
    validator: validate_RecordSetsUpdate_568426, base: "",
    url: url_RecordSetsUpdate_568427, schemes: {Scheme.Https})
type
  Call_RecordSetsDelete_568411 = ref object of OpenApiRestCall_567657
proc url_RecordSetsDelete_568413(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "privateZoneName" in path, "`privateZoneName` is a required path parameter"
  assert "recordType" in path, "`recordType` is a required path parameter"
  assert "relativeRecordSetName" in path,
        "`relativeRecordSetName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/privateDnsZones/"),
               (kind: VariableSegment, value: "privateZoneName"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "recordType"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "relativeRecordSetName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RecordSetsDelete_568412(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Deletes a record set from a Private DNS zone. This operation cannot be undone.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   recordType: JString (required)
  ##             : The type of DNS record in this record set. Record sets of type SOA cannot be deleted (they are deleted when the Private DNS zone is deleted).
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   privateZoneName: JString (required)
  ##                  : The name of the Private DNS zone (without a terminating dot).
  ##   relativeRecordSetName: JString (required)
  ##                        : The name of the record set, relative to the name of the zone.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568414 = path.getOrDefault("resourceGroupName")
  valid_568414 = validateParameter(valid_568414, JString, required = true,
                                 default = nil)
  if valid_568414 != nil:
    section.add "resourceGroupName", valid_568414
  var valid_568415 = path.getOrDefault("recordType")
  valid_568415 = validateParameter(valid_568415, JString, required = true,
                                 default = newJString("A"))
  if valid_568415 != nil:
    section.add "recordType", valid_568415
  var valid_568416 = path.getOrDefault("subscriptionId")
  valid_568416 = validateParameter(valid_568416, JString, required = true,
                                 default = nil)
  if valid_568416 != nil:
    section.add "subscriptionId", valid_568416
  var valid_568417 = path.getOrDefault("privateZoneName")
  valid_568417 = validateParameter(valid_568417, JString, required = true,
                                 default = nil)
  if valid_568417 != nil:
    section.add "privateZoneName", valid_568417
  var valid_568418 = path.getOrDefault("relativeRecordSetName")
  valid_568418 = validateParameter(valid_568418, JString, required = true,
                                 default = nil)
  if valid_568418 != nil:
    section.add "relativeRecordSetName", valid_568418
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568419 = query.getOrDefault("api-version")
  valid_568419 = validateParameter(valid_568419, JString, required = true,
                                 default = nil)
  if valid_568419 != nil:
    section.add "api-version", valid_568419
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : The ETag of the record set. Omit this value to always delete the current record set. Specify the last-seen ETag value to prevent accidentally deleting any concurrent changes.
  section = newJObject()
  var valid_568420 = header.getOrDefault("If-Match")
  valid_568420 = validateParameter(valid_568420, JString, required = false,
                                 default = nil)
  if valid_568420 != nil:
    section.add "If-Match", valid_568420
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568421: Call_RecordSetsDelete_568411; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a record set from a Private DNS zone. This operation cannot be undone.
  ## 
  let valid = call_568421.validator(path, query, header, formData, body)
  let scheme = call_568421.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568421.url(scheme.get, call_568421.host, call_568421.base,
                         call_568421.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568421, url, valid)

proc call*(call_568422: Call_RecordSetsDelete_568411; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; privateZoneName: string;
          relativeRecordSetName: string; recordType: string = "A"): Recallable =
  ## recordSetsDelete
  ## Deletes a record set from a Private DNS zone. This operation cannot be undone.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   recordType: string (required)
  ##             : The type of DNS record in this record set. Record sets of type SOA cannot be deleted (they are deleted when the Private DNS zone is deleted).
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   privateZoneName: string (required)
  ##                  : The name of the Private DNS zone (without a terminating dot).
  ##   relativeRecordSetName: string (required)
  ##                        : The name of the record set, relative to the name of the zone.
  var path_568423 = newJObject()
  var query_568424 = newJObject()
  add(path_568423, "resourceGroupName", newJString(resourceGroupName))
  add(query_568424, "api-version", newJString(apiVersion))
  add(path_568423, "recordType", newJString(recordType))
  add(path_568423, "subscriptionId", newJString(subscriptionId))
  add(path_568423, "privateZoneName", newJString(privateZoneName))
  add(path_568423, "relativeRecordSetName", newJString(relativeRecordSetName))
  result = call_568422.call(path_568423, query_568424, nil, nil, nil)

var recordSetsDelete* = Call_RecordSetsDelete_568411(name: "recordSetsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/privateDnsZones/{privateZoneName}/{recordType}/{relativeRecordSetName}",
    validator: validate_RecordSetsDelete_568412, base: "",
    url: url_RecordSetsDelete_568413, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
