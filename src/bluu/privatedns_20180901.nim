
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

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

  OpenApiRestCall_593424 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_593424](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_593424): Option[Scheme] {.used.} =
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
  macServiceName = "privatedns"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_PrivateZonesList_593646 = ref object of OpenApiRestCall_593424
proc url_PrivateZonesList_593648(protocol: Scheme; host: string; base: string;
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

proc validate_PrivateZonesList_593647(path: JsonNode; query: JsonNode;
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
  var valid_593822 = path.getOrDefault("subscriptionId")
  valid_593822 = validateParameter(valid_593822, JString, required = true,
                                 default = nil)
  if valid_593822 != nil:
    section.add "subscriptionId", valid_593822
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $top: JInt
  ##       : The maximum number of Private DNS zones to return. If not specified, returns up to 100 zones.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593823 = query.getOrDefault("api-version")
  valid_593823 = validateParameter(valid_593823, JString, required = true,
                                 default = nil)
  if valid_593823 != nil:
    section.add "api-version", valid_593823
  var valid_593824 = query.getOrDefault("$top")
  valid_593824 = validateParameter(valid_593824, JInt, required = false, default = nil)
  if valid_593824 != nil:
    section.add "$top", valid_593824
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593847: Call_PrivateZonesList_593646; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the Private DNS zones in all resource groups in a subscription.
  ## 
  let valid = call_593847.validator(path, query, header, formData, body)
  let scheme = call_593847.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593847.url(scheme.get, call_593847.host, call_593847.base,
                         call_593847.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593847, url, valid)

proc call*(call_593918: Call_PrivateZonesList_593646; apiVersion: string;
          subscriptionId: string; Top: int = 0): Recallable =
  ## privateZonesList
  ## Lists the Private DNS zones in all resource groups in a subscription.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   Top: int
  ##      : The maximum number of Private DNS zones to return. If not specified, returns up to 100 zones.
  var path_593919 = newJObject()
  var query_593921 = newJObject()
  add(query_593921, "api-version", newJString(apiVersion))
  add(path_593919, "subscriptionId", newJString(subscriptionId))
  add(query_593921, "$top", newJInt(Top))
  result = call_593918.call(path_593919, query_593921, nil, nil, nil)

var privateZonesList* = Call_PrivateZonesList_593646(name: "privateZonesList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Network/privateDnsZones",
    validator: validate_PrivateZonesList_593647, base: "",
    url: url_PrivateZonesList_593648, schemes: {Scheme.Https})
type
  Call_PrivateZonesListByResourceGroup_593960 = ref object of OpenApiRestCall_593424
proc url_PrivateZonesListByResourceGroup_593962(protocol: Scheme; host: string;
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

proc validate_PrivateZonesListByResourceGroup_593961(path: JsonNode;
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
  var valid_593963 = path.getOrDefault("resourceGroupName")
  valid_593963 = validateParameter(valid_593963, JString, required = true,
                                 default = nil)
  if valid_593963 != nil:
    section.add "resourceGroupName", valid_593963
  var valid_593964 = path.getOrDefault("subscriptionId")
  valid_593964 = validateParameter(valid_593964, JString, required = true,
                                 default = nil)
  if valid_593964 != nil:
    section.add "subscriptionId", valid_593964
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $top: JInt
  ##       : The maximum number of record sets to return. If not specified, returns up to 100 record sets.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593965 = query.getOrDefault("api-version")
  valid_593965 = validateParameter(valid_593965, JString, required = true,
                                 default = nil)
  if valid_593965 != nil:
    section.add "api-version", valid_593965
  var valid_593966 = query.getOrDefault("$top")
  valid_593966 = validateParameter(valid_593966, JInt, required = false, default = nil)
  if valid_593966 != nil:
    section.add "$top", valid_593966
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593967: Call_PrivateZonesListByResourceGroup_593960;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the Private DNS zones within a resource group.
  ## 
  let valid = call_593967.validator(path, query, header, formData, body)
  let scheme = call_593967.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593967.url(scheme.get, call_593967.host, call_593967.base,
                         call_593967.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593967, url, valid)

proc call*(call_593968: Call_PrivateZonesListByResourceGroup_593960;
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
  var path_593969 = newJObject()
  var query_593970 = newJObject()
  add(path_593969, "resourceGroupName", newJString(resourceGroupName))
  add(query_593970, "api-version", newJString(apiVersion))
  add(path_593969, "subscriptionId", newJString(subscriptionId))
  add(query_593970, "$top", newJInt(Top))
  result = call_593968.call(path_593969, query_593970, nil, nil, nil)

var privateZonesListByResourceGroup* = Call_PrivateZonesListByResourceGroup_593960(
    name: "privateZonesListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/privateDnsZones",
    validator: validate_PrivateZonesListByResourceGroup_593961, base: "",
    url: url_PrivateZonesListByResourceGroup_593962, schemes: {Scheme.Https})
type
  Call_PrivateZonesCreateOrUpdate_593982 = ref object of OpenApiRestCall_593424
proc url_PrivateZonesCreateOrUpdate_593984(protocol: Scheme; host: string;
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

proc validate_PrivateZonesCreateOrUpdate_593983(path: JsonNode; query: JsonNode;
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
  var valid_594002 = path.getOrDefault("resourceGroupName")
  valid_594002 = validateParameter(valid_594002, JString, required = true,
                                 default = nil)
  if valid_594002 != nil:
    section.add "resourceGroupName", valid_594002
  var valid_594003 = path.getOrDefault("subscriptionId")
  valid_594003 = validateParameter(valid_594003, JString, required = true,
                                 default = nil)
  if valid_594003 != nil:
    section.add "subscriptionId", valid_594003
  var valid_594004 = path.getOrDefault("privateZoneName")
  valid_594004 = validateParameter(valid_594004, JString, required = true,
                                 default = nil)
  if valid_594004 != nil:
    section.add "privateZoneName", valid_594004
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594005 = query.getOrDefault("api-version")
  valid_594005 = validateParameter(valid_594005, JString, required = true,
                                 default = nil)
  if valid_594005 != nil:
    section.add "api-version", valid_594005
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : The ETag of the Private DNS zone. Omit this value to always overwrite the current zone. Specify the last-seen ETag value to prevent accidentally overwriting any concurrent changes.
  ##   If-None-Match: JString
  ##                : Set to '*' to allow a new Private DNS zone to be created, but to prevent updating an existing zone. Other values will be ignored.
  section = newJObject()
  var valid_594006 = header.getOrDefault("If-Match")
  valid_594006 = validateParameter(valid_594006, JString, required = false,
                                 default = nil)
  if valid_594006 != nil:
    section.add "If-Match", valid_594006
  var valid_594007 = header.getOrDefault("If-None-Match")
  valid_594007 = validateParameter(valid_594007, JString, required = false,
                                 default = nil)
  if valid_594007 != nil:
    section.add "If-None-Match", valid_594007
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

proc call*(call_594009: Call_PrivateZonesCreateOrUpdate_593982; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates a Private DNS zone. Does not modify Links to virtual networks or DNS records within the zone.
  ## 
  let valid = call_594009.validator(path, query, header, formData, body)
  let scheme = call_594009.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594009.url(scheme.get, call_594009.host, call_594009.base,
                         call_594009.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594009, url, valid)

proc call*(call_594010: Call_PrivateZonesCreateOrUpdate_593982;
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
  var path_594011 = newJObject()
  var query_594012 = newJObject()
  var body_594013 = newJObject()
  add(path_594011, "resourceGroupName", newJString(resourceGroupName))
  add(query_594012, "api-version", newJString(apiVersion))
  add(path_594011, "subscriptionId", newJString(subscriptionId))
  add(path_594011, "privateZoneName", newJString(privateZoneName))
  if parameters != nil:
    body_594013 = parameters
  result = call_594010.call(path_594011, query_594012, nil, nil, body_594013)

var privateZonesCreateOrUpdate* = Call_PrivateZonesCreateOrUpdate_593982(
    name: "privateZonesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/privateDnsZones/{privateZoneName}",
    validator: validate_PrivateZonesCreateOrUpdate_593983, base: "",
    url: url_PrivateZonesCreateOrUpdate_593984, schemes: {Scheme.Https})
type
  Call_PrivateZonesGet_593971 = ref object of OpenApiRestCall_593424
proc url_PrivateZonesGet_593973(protocol: Scheme; host: string; base: string;
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

proc validate_PrivateZonesGet_593972(path: JsonNode; query: JsonNode;
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
  var valid_593974 = path.getOrDefault("resourceGroupName")
  valid_593974 = validateParameter(valid_593974, JString, required = true,
                                 default = nil)
  if valid_593974 != nil:
    section.add "resourceGroupName", valid_593974
  var valid_593975 = path.getOrDefault("subscriptionId")
  valid_593975 = validateParameter(valid_593975, JString, required = true,
                                 default = nil)
  if valid_593975 != nil:
    section.add "subscriptionId", valid_593975
  var valid_593976 = path.getOrDefault("privateZoneName")
  valid_593976 = validateParameter(valid_593976, JString, required = true,
                                 default = nil)
  if valid_593976 != nil:
    section.add "privateZoneName", valid_593976
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593977 = query.getOrDefault("api-version")
  valid_593977 = validateParameter(valid_593977, JString, required = true,
                                 default = nil)
  if valid_593977 != nil:
    section.add "api-version", valid_593977
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593978: Call_PrivateZonesGet_593971; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a Private DNS zone. Retrieves the zone properties, but not the virtual networks links or the record sets within the zone.
  ## 
  let valid = call_593978.validator(path, query, header, formData, body)
  let scheme = call_593978.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593978.url(scheme.get, call_593978.host, call_593978.base,
                         call_593978.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593978, url, valid)

proc call*(call_593979: Call_PrivateZonesGet_593971; resourceGroupName: string;
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
  var path_593980 = newJObject()
  var query_593981 = newJObject()
  add(path_593980, "resourceGroupName", newJString(resourceGroupName))
  add(query_593981, "api-version", newJString(apiVersion))
  add(path_593980, "subscriptionId", newJString(subscriptionId))
  add(path_593980, "privateZoneName", newJString(privateZoneName))
  result = call_593979.call(path_593980, query_593981, nil, nil, nil)

var privateZonesGet* = Call_PrivateZonesGet_593971(name: "privateZonesGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/privateDnsZones/{privateZoneName}",
    validator: validate_PrivateZonesGet_593972, base: "", url: url_PrivateZonesGet_593973,
    schemes: {Scheme.Https})
type
  Call_PrivateZonesUpdate_594026 = ref object of OpenApiRestCall_593424
proc url_PrivateZonesUpdate_594028(protocol: Scheme; host: string; base: string;
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

proc validate_PrivateZonesUpdate_594027(path: JsonNode; query: JsonNode;
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
  var valid_594031 = path.getOrDefault("privateZoneName")
  valid_594031 = validateParameter(valid_594031, JString, required = true,
                                 default = nil)
  if valid_594031 != nil:
    section.add "privateZoneName", valid_594031
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
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : The ETag of the Private DNS zone. Omit this value to always overwrite the current zone. Specify the last-seen ETag value to prevent accidentally overwriting any concurrent changes.
  section = newJObject()
  var valid_594033 = header.getOrDefault("If-Match")
  valid_594033 = validateParameter(valid_594033, JString, required = false,
                                 default = nil)
  if valid_594033 != nil:
    section.add "If-Match", valid_594033
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

proc call*(call_594035: Call_PrivateZonesUpdate_594026; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a Private DNS zone. Does not modify virtual network links or DNS records within the zone.
  ## 
  let valid = call_594035.validator(path, query, header, formData, body)
  let scheme = call_594035.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594035.url(scheme.get, call_594035.host, call_594035.base,
                         call_594035.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594035, url, valid)

proc call*(call_594036: Call_PrivateZonesUpdate_594026; resourceGroupName: string;
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
  var path_594037 = newJObject()
  var query_594038 = newJObject()
  var body_594039 = newJObject()
  add(path_594037, "resourceGroupName", newJString(resourceGroupName))
  add(query_594038, "api-version", newJString(apiVersion))
  add(path_594037, "subscriptionId", newJString(subscriptionId))
  add(path_594037, "privateZoneName", newJString(privateZoneName))
  if parameters != nil:
    body_594039 = parameters
  result = call_594036.call(path_594037, query_594038, nil, nil, body_594039)

var privateZonesUpdate* = Call_PrivateZonesUpdate_594026(
    name: "privateZonesUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/privateDnsZones/{privateZoneName}",
    validator: validate_PrivateZonesUpdate_594027, base: "",
    url: url_PrivateZonesUpdate_594028, schemes: {Scheme.Https})
type
  Call_PrivateZonesDelete_594014 = ref object of OpenApiRestCall_593424
proc url_PrivateZonesDelete_594016(protocol: Scheme; host: string; base: string;
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

proc validate_PrivateZonesDelete_594015(path: JsonNode; query: JsonNode;
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
  var valid_594017 = path.getOrDefault("resourceGroupName")
  valid_594017 = validateParameter(valid_594017, JString, required = true,
                                 default = nil)
  if valid_594017 != nil:
    section.add "resourceGroupName", valid_594017
  var valid_594018 = path.getOrDefault("subscriptionId")
  valid_594018 = validateParameter(valid_594018, JString, required = true,
                                 default = nil)
  if valid_594018 != nil:
    section.add "subscriptionId", valid_594018
  var valid_594019 = path.getOrDefault("privateZoneName")
  valid_594019 = validateParameter(valid_594019, JString, required = true,
                                 default = nil)
  if valid_594019 != nil:
    section.add "privateZoneName", valid_594019
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594020 = query.getOrDefault("api-version")
  valid_594020 = validateParameter(valid_594020, JString, required = true,
                                 default = nil)
  if valid_594020 != nil:
    section.add "api-version", valid_594020
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : The ETag of the Private DNS zone. Omit this value to always delete the current zone. Specify the last-seen ETag value to prevent accidentally deleting any concurrent changes.
  section = newJObject()
  var valid_594021 = header.getOrDefault("If-Match")
  valid_594021 = validateParameter(valid_594021, JString, required = false,
                                 default = nil)
  if valid_594021 != nil:
    section.add "If-Match", valid_594021
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594022: Call_PrivateZonesDelete_594014; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a Private DNS zone. WARNING: All DNS records in the zone will also be deleted. This operation cannot be undone. Private DNS zone cannot be deleted unless all virtual network links to it are removed.
  ## 
  let valid = call_594022.validator(path, query, header, formData, body)
  let scheme = call_594022.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594022.url(scheme.get, call_594022.host, call_594022.base,
                         call_594022.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594022, url, valid)

proc call*(call_594023: Call_PrivateZonesDelete_594014; resourceGroupName: string;
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
  var path_594024 = newJObject()
  var query_594025 = newJObject()
  add(path_594024, "resourceGroupName", newJString(resourceGroupName))
  add(query_594025, "api-version", newJString(apiVersion))
  add(path_594024, "subscriptionId", newJString(subscriptionId))
  add(path_594024, "privateZoneName", newJString(privateZoneName))
  result = call_594023.call(path_594024, query_594025, nil, nil, nil)

var privateZonesDelete* = Call_PrivateZonesDelete_594014(
    name: "privateZonesDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/privateDnsZones/{privateZoneName}",
    validator: validate_PrivateZonesDelete_594015, base: "",
    url: url_PrivateZonesDelete_594016, schemes: {Scheme.Https})
type
  Call_RecordSetsList_594040 = ref object of OpenApiRestCall_593424
proc url_RecordSetsList_594042(protocol: Scheme; host: string; base: string;
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

proc validate_RecordSetsList_594041(path: JsonNode; query: JsonNode;
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
  var valid_594043 = path.getOrDefault("resourceGroupName")
  valid_594043 = validateParameter(valid_594043, JString, required = true,
                                 default = nil)
  if valid_594043 != nil:
    section.add "resourceGroupName", valid_594043
  var valid_594044 = path.getOrDefault("subscriptionId")
  valid_594044 = validateParameter(valid_594044, JString, required = true,
                                 default = nil)
  if valid_594044 != nil:
    section.add "subscriptionId", valid_594044
  var valid_594045 = path.getOrDefault("privateZoneName")
  valid_594045 = validateParameter(valid_594045, JString, required = true,
                                 default = nil)
  if valid_594045 != nil:
    section.add "privateZoneName", valid_594045
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
  var valid_594046 = query.getOrDefault("api-version")
  valid_594046 = validateParameter(valid_594046, JString, required = true,
                                 default = nil)
  if valid_594046 != nil:
    section.add "api-version", valid_594046
  var valid_594047 = query.getOrDefault("$recordsetnamesuffix")
  valid_594047 = validateParameter(valid_594047, JString, required = false,
                                 default = nil)
  if valid_594047 != nil:
    section.add "$recordsetnamesuffix", valid_594047
  var valid_594048 = query.getOrDefault("$top")
  valid_594048 = validateParameter(valid_594048, JInt, required = false, default = nil)
  if valid_594048 != nil:
    section.add "$top", valid_594048
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594049: Call_RecordSetsList_594040; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all record sets in a Private DNS zone.
  ## 
  let valid = call_594049.validator(path, query, header, formData, body)
  let scheme = call_594049.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594049.url(scheme.get, call_594049.host, call_594049.base,
                         call_594049.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594049, url, valid)

proc call*(call_594050: Call_RecordSetsList_594040; resourceGroupName: string;
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
  var path_594051 = newJObject()
  var query_594052 = newJObject()
  add(path_594051, "resourceGroupName", newJString(resourceGroupName))
  add(query_594052, "api-version", newJString(apiVersion))
  add(path_594051, "subscriptionId", newJString(subscriptionId))
  add(query_594052, "$recordsetnamesuffix", newJString(Recordsetnamesuffix))
  add(query_594052, "$top", newJInt(Top))
  add(path_594051, "privateZoneName", newJString(privateZoneName))
  result = call_594050.call(path_594051, query_594052, nil, nil, nil)

var recordSetsList* = Call_RecordSetsList_594040(name: "recordSetsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/privateDnsZones/{privateZoneName}/ALL",
    validator: validate_RecordSetsList_594041, base: "", url: url_RecordSetsList_594042,
    schemes: {Scheme.Https})
type
  Call_VirtualNetworkLinksList_594053 = ref object of OpenApiRestCall_593424
proc url_VirtualNetworkLinksList_594055(protocol: Scheme; host: string; base: string;
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

proc validate_VirtualNetworkLinksList_594054(path: JsonNode; query: JsonNode;
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
  var valid_594056 = path.getOrDefault("resourceGroupName")
  valid_594056 = validateParameter(valid_594056, JString, required = true,
                                 default = nil)
  if valid_594056 != nil:
    section.add "resourceGroupName", valid_594056
  var valid_594057 = path.getOrDefault("subscriptionId")
  valid_594057 = validateParameter(valid_594057, JString, required = true,
                                 default = nil)
  if valid_594057 != nil:
    section.add "subscriptionId", valid_594057
  var valid_594058 = path.getOrDefault("privateZoneName")
  valid_594058 = validateParameter(valid_594058, JString, required = true,
                                 default = nil)
  if valid_594058 != nil:
    section.add "privateZoneName", valid_594058
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $top: JInt
  ##       : The maximum number of virtual network links to return. If not specified, returns up to 100 virtual network links.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594059 = query.getOrDefault("api-version")
  valid_594059 = validateParameter(valid_594059, JString, required = true,
                                 default = nil)
  if valid_594059 != nil:
    section.add "api-version", valid_594059
  var valid_594060 = query.getOrDefault("$top")
  valid_594060 = validateParameter(valid_594060, JInt, required = false, default = nil)
  if valid_594060 != nil:
    section.add "$top", valid_594060
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594061: Call_VirtualNetworkLinksList_594053; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the virtual network links to the specified Private DNS zone.
  ## 
  let valid = call_594061.validator(path, query, header, formData, body)
  let scheme = call_594061.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594061.url(scheme.get, call_594061.host, call_594061.base,
                         call_594061.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594061, url, valid)

proc call*(call_594062: Call_VirtualNetworkLinksList_594053;
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
  var path_594063 = newJObject()
  var query_594064 = newJObject()
  add(path_594063, "resourceGroupName", newJString(resourceGroupName))
  add(query_594064, "api-version", newJString(apiVersion))
  add(path_594063, "subscriptionId", newJString(subscriptionId))
  add(query_594064, "$top", newJInt(Top))
  add(path_594063, "privateZoneName", newJString(privateZoneName))
  result = call_594062.call(path_594063, query_594064, nil, nil, nil)

var virtualNetworkLinksList* = Call_VirtualNetworkLinksList_594053(
    name: "virtualNetworkLinksList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/privateDnsZones/{privateZoneName}/virtualNetworkLinks",
    validator: validate_VirtualNetworkLinksList_594054, base: "",
    url: url_VirtualNetworkLinksList_594055, schemes: {Scheme.Https})
type
  Call_VirtualNetworkLinksCreateOrUpdate_594077 = ref object of OpenApiRestCall_593424
proc url_VirtualNetworkLinksCreateOrUpdate_594079(protocol: Scheme; host: string;
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

proc validate_VirtualNetworkLinksCreateOrUpdate_594078(path: JsonNode;
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
  var valid_594080 = path.getOrDefault("resourceGroupName")
  valid_594080 = validateParameter(valid_594080, JString, required = true,
                                 default = nil)
  if valid_594080 != nil:
    section.add "resourceGroupName", valid_594080
  var valid_594081 = path.getOrDefault("virtualNetworkLinkName")
  valid_594081 = validateParameter(valid_594081, JString, required = true,
                                 default = nil)
  if valid_594081 != nil:
    section.add "virtualNetworkLinkName", valid_594081
  var valid_594082 = path.getOrDefault("subscriptionId")
  valid_594082 = validateParameter(valid_594082, JString, required = true,
                                 default = nil)
  if valid_594082 != nil:
    section.add "subscriptionId", valid_594082
  var valid_594083 = path.getOrDefault("privateZoneName")
  valid_594083 = validateParameter(valid_594083, JString, required = true,
                                 default = nil)
  if valid_594083 != nil:
    section.add "privateZoneName", valid_594083
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594084 = query.getOrDefault("api-version")
  valid_594084 = validateParameter(valid_594084, JString, required = true,
                                 default = nil)
  if valid_594084 != nil:
    section.add "api-version", valid_594084
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : The ETag of the virtual network link to the Private DNS zone. Omit this value to always overwrite the current virtual network link. Specify the last-seen ETag value to prevent accidentally overwriting any concurrent changes.
  ##   If-None-Match: JString
  ##                : Set to '*' to allow a new virtual network link to the Private DNS zone to be created, but to prevent updating an existing link. Other values will be ignored.
  section = newJObject()
  var valid_594085 = header.getOrDefault("If-Match")
  valid_594085 = validateParameter(valid_594085, JString, required = false,
                                 default = nil)
  if valid_594085 != nil:
    section.add "If-Match", valid_594085
  var valid_594086 = header.getOrDefault("If-None-Match")
  valid_594086 = validateParameter(valid_594086, JString, required = false,
                                 default = nil)
  if valid_594086 != nil:
    section.add "If-None-Match", valid_594086
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

proc call*(call_594088: Call_VirtualNetworkLinksCreateOrUpdate_594077;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates a virtual network link to the specified Private DNS zone.
  ## 
  let valid = call_594088.validator(path, query, header, formData, body)
  let scheme = call_594088.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594088.url(scheme.get, call_594088.host, call_594088.base,
                         call_594088.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594088, url, valid)

proc call*(call_594089: Call_VirtualNetworkLinksCreateOrUpdate_594077;
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
  var path_594090 = newJObject()
  var query_594091 = newJObject()
  var body_594092 = newJObject()
  add(path_594090, "resourceGroupName", newJString(resourceGroupName))
  add(query_594091, "api-version", newJString(apiVersion))
  add(path_594090, "virtualNetworkLinkName", newJString(virtualNetworkLinkName))
  add(path_594090, "subscriptionId", newJString(subscriptionId))
  add(path_594090, "privateZoneName", newJString(privateZoneName))
  if parameters != nil:
    body_594092 = parameters
  result = call_594089.call(path_594090, query_594091, nil, nil, body_594092)

var virtualNetworkLinksCreateOrUpdate* = Call_VirtualNetworkLinksCreateOrUpdate_594077(
    name: "virtualNetworkLinksCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/privateDnsZones/{privateZoneName}/virtualNetworkLinks/{virtualNetworkLinkName}",
    validator: validate_VirtualNetworkLinksCreateOrUpdate_594078, base: "",
    url: url_VirtualNetworkLinksCreateOrUpdate_594079, schemes: {Scheme.Https})
type
  Call_VirtualNetworkLinksGet_594065 = ref object of OpenApiRestCall_593424
proc url_VirtualNetworkLinksGet_594067(protocol: Scheme; host: string; base: string;
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

proc validate_VirtualNetworkLinksGet_594066(path: JsonNode; query: JsonNode;
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
  var valid_594068 = path.getOrDefault("resourceGroupName")
  valid_594068 = validateParameter(valid_594068, JString, required = true,
                                 default = nil)
  if valid_594068 != nil:
    section.add "resourceGroupName", valid_594068
  var valid_594069 = path.getOrDefault("virtualNetworkLinkName")
  valid_594069 = validateParameter(valid_594069, JString, required = true,
                                 default = nil)
  if valid_594069 != nil:
    section.add "virtualNetworkLinkName", valid_594069
  var valid_594070 = path.getOrDefault("subscriptionId")
  valid_594070 = validateParameter(valid_594070, JString, required = true,
                                 default = nil)
  if valid_594070 != nil:
    section.add "subscriptionId", valid_594070
  var valid_594071 = path.getOrDefault("privateZoneName")
  valid_594071 = validateParameter(valid_594071, JString, required = true,
                                 default = nil)
  if valid_594071 != nil:
    section.add "privateZoneName", valid_594071
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594072 = query.getOrDefault("api-version")
  valid_594072 = validateParameter(valid_594072, JString, required = true,
                                 default = nil)
  if valid_594072 != nil:
    section.add "api-version", valid_594072
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594073: Call_VirtualNetworkLinksGet_594065; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a virtual network link to the specified Private DNS zone.
  ## 
  let valid = call_594073.validator(path, query, header, formData, body)
  let scheme = call_594073.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594073.url(scheme.get, call_594073.host, call_594073.base,
                         call_594073.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594073, url, valid)

proc call*(call_594074: Call_VirtualNetworkLinksGet_594065;
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
  var path_594075 = newJObject()
  var query_594076 = newJObject()
  add(path_594075, "resourceGroupName", newJString(resourceGroupName))
  add(query_594076, "api-version", newJString(apiVersion))
  add(path_594075, "virtualNetworkLinkName", newJString(virtualNetworkLinkName))
  add(path_594075, "subscriptionId", newJString(subscriptionId))
  add(path_594075, "privateZoneName", newJString(privateZoneName))
  result = call_594074.call(path_594075, query_594076, nil, nil, nil)

var virtualNetworkLinksGet* = Call_VirtualNetworkLinksGet_594065(
    name: "virtualNetworkLinksGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/privateDnsZones/{privateZoneName}/virtualNetworkLinks/{virtualNetworkLinkName}",
    validator: validate_VirtualNetworkLinksGet_594066, base: "",
    url: url_VirtualNetworkLinksGet_594067, schemes: {Scheme.Https})
type
  Call_VirtualNetworkLinksUpdate_594106 = ref object of OpenApiRestCall_593424
proc url_VirtualNetworkLinksUpdate_594108(protocol: Scheme; host: string;
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

proc validate_VirtualNetworkLinksUpdate_594107(path: JsonNode; query: JsonNode;
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
  var valid_594109 = path.getOrDefault("resourceGroupName")
  valid_594109 = validateParameter(valid_594109, JString, required = true,
                                 default = nil)
  if valid_594109 != nil:
    section.add "resourceGroupName", valid_594109
  var valid_594110 = path.getOrDefault("virtualNetworkLinkName")
  valid_594110 = validateParameter(valid_594110, JString, required = true,
                                 default = nil)
  if valid_594110 != nil:
    section.add "virtualNetworkLinkName", valid_594110
  var valid_594111 = path.getOrDefault("subscriptionId")
  valid_594111 = validateParameter(valid_594111, JString, required = true,
                                 default = nil)
  if valid_594111 != nil:
    section.add "subscriptionId", valid_594111
  var valid_594112 = path.getOrDefault("privateZoneName")
  valid_594112 = validateParameter(valid_594112, JString, required = true,
                                 default = nil)
  if valid_594112 != nil:
    section.add "privateZoneName", valid_594112
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594113 = query.getOrDefault("api-version")
  valid_594113 = validateParameter(valid_594113, JString, required = true,
                                 default = nil)
  if valid_594113 != nil:
    section.add "api-version", valid_594113
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : The ETag of the virtual network link to the Private DNS zone. Omit this value to always overwrite the current virtual network link. Specify the last-seen ETag value to prevent accidentally overwriting any concurrent changes.
  section = newJObject()
  var valid_594114 = header.getOrDefault("If-Match")
  valid_594114 = validateParameter(valid_594114, JString, required = false,
                                 default = nil)
  if valid_594114 != nil:
    section.add "If-Match", valid_594114
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

proc call*(call_594116: Call_VirtualNetworkLinksUpdate_594106; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a virtual network link to the specified Private DNS zone.
  ## 
  let valid = call_594116.validator(path, query, header, formData, body)
  let scheme = call_594116.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594116.url(scheme.get, call_594116.host, call_594116.base,
                         call_594116.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594116, url, valid)

proc call*(call_594117: Call_VirtualNetworkLinksUpdate_594106;
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
  var path_594118 = newJObject()
  var query_594119 = newJObject()
  var body_594120 = newJObject()
  add(path_594118, "resourceGroupName", newJString(resourceGroupName))
  add(query_594119, "api-version", newJString(apiVersion))
  add(path_594118, "virtualNetworkLinkName", newJString(virtualNetworkLinkName))
  add(path_594118, "subscriptionId", newJString(subscriptionId))
  add(path_594118, "privateZoneName", newJString(privateZoneName))
  if parameters != nil:
    body_594120 = parameters
  result = call_594117.call(path_594118, query_594119, nil, nil, body_594120)

var virtualNetworkLinksUpdate* = Call_VirtualNetworkLinksUpdate_594106(
    name: "virtualNetworkLinksUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/privateDnsZones/{privateZoneName}/virtualNetworkLinks/{virtualNetworkLinkName}",
    validator: validate_VirtualNetworkLinksUpdate_594107, base: "",
    url: url_VirtualNetworkLinksUpdate_594108, schemes: {Scheme.Https})
type
  Call_VirtualNetworkLinksDelete_594093 = ref object of OpenApiRestCall_593424
proc url_VirtualNetworkLinksDelete_594095(protocol: Scheme; host: string;
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

proc validate_VirtualNetworkLinksDelete_594094(path: JsonNode; query: JsonNode;
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
  var valid_594096 = path.getOrDefault("resourceGroupName")
  valid_594096 = validateParameter(valid_594096, JString, required = true,
                                 default = nil)
  if valid_594096 != nil:
    section.add "resourceGroupName", valid_594096
  var valid_594097 = path.getOrDefault("virtualNetworkLinkName")
  valid_594097 = validateParameter(valid_594097, JString, required = true,
                                 default = nil)
  if valid_594097 != nil:
    section.add "virtualNetworkLinkName", valid_594097
  var valid_594098 = path.getOrDefault("subscriptionId")
  valid_594098 = validateParameter(valid_594098, JString, required = true,
                                 default = nil)
  if valid_594098 != nil:
    section.add "subscriptionId", valid_594098
  var valid_594099 = path.getOrDefault("privateZoneName")
  valid_594099 = validateParameter(valid_594099, JString, required = true,
                                 default = nil)
  if valid_594099 != nil:
    section.add "privateZoneName", valid_594099
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594100 = query.getOrDefault("api-version")
  valid_594100 = validateParameter(valid_594100, JString, required = true,
                                 default = nil)
  if valid_594100 != nil:
    section.add "api-version", valid_594100
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : The ETag of the virtual network link to the Private DNS zone. Omit this value to always delete the current zone. Specify the last-seen ETag value to prevent accidentally deleting any concurrent changes.
  section = newJObject()
  var valid_594101 = header.getOrDefault("If-Match")
  valid_594101 = validateParameter(valid_594101, JString, required = false,
                                 default = nil)
  if valid_594101 != nil:
    section.add "If-Match", valid_594101
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594102: Call_VirtualNetworkLinksDelete_594093; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a virtual network link to the specified Private DNS zone. WARNING: In case of a registration virtual network, all auto-registered DNS records in the zone for the virtual network will also be deleted. This operation cannot be undone.
  ## 
  let valid = call_594102.validator(path, query, header, formData, body)
  let scheme = call_594102.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594102.url(scheme.get, call_594102.host, call_594102.base,
                         call_594102.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594102, url, valid)

proc call*(call_594103: Call_VirtualNetworkLinksDelete_594093;
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
  var path_594104 = newJObject()
  var query_594105 = newJObject()
  add(path_594104, "resourceGroupName", newJString(resourceGroupName))
  add(query_594105, "api-version", newJString(apiVersion))
  add(path_594104, "virtualNetworkLinkName", newJString(virtualNetworkLinkName))
  add(path_594104, "subscriptionId", newJString(subscriptionId))
  add(path_594104, "privateZoneName", newJString(privateZoneName))
  result = call_594103.call(path_594104, query_594105, nil, nil, nil)

var virtualNetworkLinksDelete* = Call_VirtualNetworkLinksDelete_594093(
    name: "virtualNetworkLinksDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/privateDnsZones/{privateZoneName}/virtualNetworkLinks/{virtualNetworkLinkName}",
    validator: validate_VirtualNetworkLinksDelete_594094, base: "",
    url: url_VirtualNetworkLinksDelete_594095, schemes: {Scheme.Https})
type
  Call_RecordSetsListByType_594121 = ref object of OpenApiRestCall_593424
proc url_RecordSetsListByType_594123(protocol: Scheme; host: string; base: string;
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

proc validate_RecordSetsListByType_594122(path: JsonNode; query: JsonNode;
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
  var valid_594124 = path.getOrDefault("resourceGroupName")
  valid_594124 = validateParameter(valid_594124, JString, required = true,
                                 default = nil)
  if valid_594124 != nil:
    section.add "resourceGroupName", valid_594124
  var valid_594138 = path.getOrDefault("recordType")
  valid_594138 = validateParameter(valid_594138, JString, required = true,
                                 default = newJString("A"))
  if valid_594138 != nil:
    section.add "recordType", valid_594138
  var valid_594139 = path.getOrDefault("subscriptionId")
  valid_594139 = validateParameter(valid_594139, JString, required = true,
                                 default = nil)
  if valid_594139 != nil:
    section.add "subscriptionId", valid_594139
  var valid_594140 = path.getOrDefault("privateZoneName")
  valid_594140 = validateParameter(valid_594140, JString, required = true,
                                 default = nil)
  if valid_594140 != nil:
    section.add "privateZoneName", valid_594140
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
  var valid_594141 = query.getOrDefault("api-version")
  valid_594141 = validateParameter(valid_594141, JString, required = true,
                                 default = nil)
  if valid_594141 != nil:
    section.add "api-version", valid_594141
  var valid_594142 = query.getOrDefault("$recordsetnamesuffix")
  valid_594142 = validateParameter(valid_594142, JString, required = false,
                                 default = nil)
  if valid_594142 != nil:
    section.add "$recordsetnamesuffix", valid_594142
  var valid_594143 = query.getOrDefault("$top")
  valid_594143 = validateParameter(valid_594143, JInt, required = false, default = nil)
  if valid_594143 != nil:
    section.add "$top", valid_594143
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594144: Call_RecordSetsListByType_594121; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the record sets of a specified type in a Private DNS zone.
  ## 
  let valid = call_594144.validator(path, query, header, formData, body)
  let scheme = call_594144.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594144.url(scheme.get, call_594144.host, call_594144.base,
                         call_594144.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594144, url, valid)

proc call*(call_594145: Call_RecordSetsListByType_594121;
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
  var path_594146 = newJObject()
  var query_594147 = newJObject()
  add(path_594146, "resourceGroupName", newJString(resourceGroupName))
  add(query_594147, "api-version", newJString(apiVersion))
  add(path_594146, "recordType", newJString(recordType))
  add(path_594146, "subscriptionId", newJString(subscriptionId))
  add(query_594147, "$recordsetnamesuffix", newJString(Recordsetnamesuffix))
  add(query_594147, "$top", newJInt(Top))
  add(path_594146, "privateZoneName", newJString(privateZoneName))
  result = call_594145.call(path_594146, query_594147, nil, nil, nil)

var recordSetsListByType* = Call_RecordSetsListByType_594121(
    name: "recordSetsListByType", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/privateDnsZones/{privateZoneName}/{recordType}",
    validator: validate_RecordSetsListByType_594122, base: "",
    url: url_RecordSetsListByType_594123, schemes: {Scheme.Https})
type
  Call_RecordSetsCreateOrUpdate_594161 = ref object of OpenApiRestCall_593424
proc url_RecordSetsCreateOrUpdate_594163(protocol: Scheme; host: string;
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

proc validate_RecordSetsCreateOrUpdate_594162(path: JsonNode; query: JsonNode;
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
  var valid_594164 = path.getOrDefault("resourceGroupName")
  valid_594164 = validateParameter(valid_594164, JString, required = true,
                                 default = nil)
  if valid_594164 != nil:
    section.add "resourceGroupName", valid_594164
  var valid_594165 = path.getOrDefault("recordType")
  valid_594165 = validateParameter(valid_594165, JString, required = true,
                                 default = newJString("A"))
  if valid_594165 != nil:
    section.add "recordType", valid_594165
  var valid_594166 = path.getOrDefault("subscriptionId")
  valid_594166 = validateParameter(valid_594166, JString, required = true,
                                 default = nil)
  if valid_594166 != nil:
    section.add "subscriptionId", valid_594166
  var valid_594167 = path.getOrDefault("privateZoneName")
  valid_594167 = validateParameter(valid_594167, JString, required = true,
                                 default = nil)
  if valid_594167 != nil:
    section.add "privateZoneName", valid_594167
  var valid_594168 = path.getOrDefault("relativeRecordSetName")
  valid_594168 = validateParameter(valid_594168, JString, required = true,
                                 default = nil)
  if valid_594168 != nil:
    section.add "relativeRecordSetName", valid_594168
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594169 = query.getOrDefault("api-version")
  valid_594169 = validateParameter(valid_594169, JString, required = true,
                                 default = nil)
  if valid_594169 != nil:
    section.add "api-version", valid_594169
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : The ETag of the record set. Omit this value to always overwrite the current record set. Specify the last-seen ETag value to prevent accidentally overwriting any concurrent changes.
  ##   If-None-Match: JString
  ##                : Set to '*' to allow a new record set to be created, but to prevent updating an existing record set. Other values will be ignored.
  section = newJObject()
  var valid_594170 = header.getOrDefault("If-Match")
  valid_594170 = validateParameter(valid_594170, JString, required = false,
                                 default = nil)
  if valid_594170 != nil:
    section.add "If-Match", valid_594170
  var valid_594171 = header.getOrDefault("If-None-Match")
  valid_594171 = validateParameter(valid_594171, JString, required = false,
                                 default = nil)
  if valid_594171 != nil:
    section.add "If-None-Match", valid_594171
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

proc call*(call_594173: Call_RecordSetsCreateOrUpdate_594161; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates a record set within a Private DNS zone.
  ## 
  let valid = call_594173.validator(path, query, header, formData, body)
  let scheme = call_594173.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594173.url(scheme.get, call_594173.host, call_594173.base,
                         call_594173.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594173, url, valid)

proc call*(call_594174: Call_RecordSetsCreateOrUpdate_594161;
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
  var path_594175 = newJObject()
  var query_594176 = newJObject()
  var body_594177 = newJObject()
  add(path_594175, "resourceGroupName", newJString(resourceGroupName))
  add(query_594176, "api-version", newJString(apiVersion))
  add(path_594175, "recordType", newJString(recordType))
  add(path_594175, "subscriptionId", newJString(subscriptionId))
  add(path_594175, "privateZoneName", newJString(privateZoneName))
  if parameters != nil:
    body_594177 = parameters
  add(path_594175, "relativeRecordSetName", newJString(relativeRecordSetName))
  result = call_594174.call(path_594175, query_594176, nil, nil, body_594177)

var recordSetsCreateOrUpdate* = Call_RecordSetsCreateOrUpdate_594161(
    name: "recordSetsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/privateDnsZones/{privateZoneName}/{recordType}/{relativeRecordSetName}",
    validator: validate_RecordSetsCreateOrUpdate_594162, base: "",
    url: url_RecordSetsCreateOrUpdate_594163, schemes: {Scheme.Https})
type
  Call_RecordSetsGet_594148 = ref object of OpenApiRestCall_593424
proc url_RecordSetsGet_594150(protocol: Scheme; host: string; base: string;
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

proc validate_RecordSetsGet_594149(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594151 = path.getOrDefault("resourceGroupName")
  valid_594151 = validateParameter(valid_594151, JString, required = true,
                                 default = nil)
  if valid_594151 != nil:
    section.add "resourceGroupName", valid_594151
  var valid_594152 = path.getOrDefault("recordType")
  valid_594152 = validateParameter(valid_594152, JString, required = true,
                                 default = newJString("A"))
  if valid_594152 != nil:
    section.add "recordType", valid_594152
  var valid_594153 = path.getOrDefault("subscriptionId")
  valid_594153 = validateParameter(valid_594153, JString, required = true,
                                 default = nil)
  if valid_594153 != nil:
    section.add "subscriptionId", valid_594153
  var valid_594154 = path.getOrDefault("privateZoneName")
  valid_594154 = validateParameter(valid_594154, JString, required = true,
                                 default = nil)
  if valid_594154 != nil:
    section.add "privateZoneName", valid_594154
  var valid_594155 = path.getOrDefault("relativeRecordSetName")
  valid_594155 = validateParameter(valid_594155, JString, required = true,
                                 default = nil)
  if valid_594155 != nil:
    section.add "relativeRecordSetName", valid_594155
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594156 = query.getOrDefault("api-version")
  valid_594156 = validateParameter(valid_594156, JString, required = true,
                                 default = nil)
  if valid_594156 != nil:
    section.add "api-version", valid_594156
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594157: Call_RecordSetsGet_594148; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a record set.
  ## 
  let valid = call_594157.validator(path, query, header, formData, body)
  let scheme = call_594157.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594157.url(scheme.get, call_594157.host, call_594157.base,
                         call_594157.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594157, url, valid)

proc call*(call_594158: Call_RecordSetsGet_594148; resourceGroupName: string;
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
  var path_594159 = newJObject()
  var query_594160 = newJObject()
  add(path_594159, "resourceGroupName", newJString(resourceGroupName))
  add(query_594160, "api-version", newJString(apiVersion))
  add(path_594159, "recordType", newJString(recordType))
  add(path_594159, "subscriptionId", newJString(subscriptionId))
  add(path_594159, "privateZoneName", newJString(privateZoneName))
  add(path_594159, "relativeRecordSetName", newJString(relativeRecordSetName))
  result = call_594158.call(path_594159, query_594160, nil, nil, nil)

var recordSetsGet* = Call_RecordSetsGet_594148(name: "recordSetsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/privateDnsZones/{privateZoneName}/{recordType}/{relativeRecordSetName}",
    validator: validate_RecordSetsGet_594149, base: "", url: url_RecordSetsGet_594150,
    schemes: {Scheme.Https})
type
  Call_RecordSetsUpdate_594192 = ref object of OpenApiRestCall_593424
proc url_RecordSetsUpdate_594194(protocol: Scheme; host: string; base: string;
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

proc validate_RecordSetsUpdate_594193(path: JsonNode; query: JsonNode;
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
  var valid_594195 = path.getOrDefault("resourceGroupName")
  valid_594195 = validateParameter(valid_594195, JString, required = true,
                                 default = nil)
  if valid_594195 != nil:
    section.add "resourceGroupName", valid_594195
  var valid_594196 = path.getOrDefault("recordType")
  valid_594196 = validateParameter(valid_594196, JString, required = true,
                                 default = newJString("A"))
  if valid_594196 != nil:
    section.add "recordType", valid_594196
  var valid_594197 = path.getOrDefault("subscriptionId")
  valid_594197 = validateParameter(valid_594197, JString, required = true,
                                 default = nil)
  if valid_594197 != nil:
    section.add "subscriptionId", valid_594197
  var valid_594198 = path.getOrDefault("privateZoneName")
  valid_594198 = validateParameter(valid_594198, JString, required = true,
                                 default = nil)
  if valid_594198 != nil:
    section.add "privateZoneName", valid_594198
  var valid_594199 = path.getOrDefault("relativeRecordSetName")
  valid_594199 = validateParameter(valid_594199, JString, required = true,
                                 default = nil)
  if valid_594199 != nil:
    section.add "relativeRecordSetName", valid_594199
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594200 = query.getOrDefault("api-version")
  valid_594200 = validateParameter(valid_594200, JString, required = true,
                                 default = nil)
  if valid_594200 != nil:
    section.add "api-version", valid_594200
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : The ETag of the record set. Omit this value to always overwrite the current record set. Specify the last-seen ETag value to prevent accidentally overwriting concurrent changes.
  section = newJObject()
  var valid_594201 = header.getOrDefault("If-Match")
  valid_594201 = validateParameter(valid_594201, JString, required = false,
                                 default = nil)
  if valid_594201 != nil:
    section.add "If-Match", valid_594201
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

proc call*(call_594203: Call_RecordSetsUpdate_594192; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a record set within a Private DNS zone.
  ## 
  let valid = call_594203.validator(path, query, header, formData, body)
  let scheme = call_594203.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594203.url(scheme.get, call_594203.host, call_594203.base,
                         call_594203.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594203, url, valid)

proc call*(call_594204: Call_RecordSetsUpdate_594192; resourceGroupName: string;
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
  var path_594205 = newJObject()
  var query_594206 = newJObject()
  var body_594207 = newJObject()
  add(path_594205, "resourceGroupName", newJString(resourceGroupName))
  add(query_594206, "api-version", newJString(apiVersion))
  add(path_594205, "recordType", newJString(recordType))
  add(path_594205, "subscriptionId", newJString(subscriptionId))
  add(path_594205, "privateZoneName", newJString(privateZoneName))
  if parameters != nil:
    body_594207 = parameters
  add(path_594205, "relativeRecordSetName", newJString(relativeRecordSetName))
  result = call_594204.call(path_594205, query_594206, nil, nil, body_594207)

var recordSetsUpdate* = Call_RecordSetsUpdate_594192(name: "recordSetsUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/privateDnsZones/{privateZoneName}/{recordType}/{relativeRecordSetName}",
    validator: validate_RecordSetsUpdate_594193, base: "",
    url: url_RecordSetsUpdate_594194, schemes: {Scheme.Https})
type
  Call_RecordSetsDelete_594178 = ref object of OpenApiRestCall_593424
proc url_RecordSetsDelete_594180(protocol: Scheme; host: string; base: string;
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

proc validate_RecordSetsDelete_594179(path: JsonNode; query: JsonNode;
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
  var valid_594181 = path.getOrDefault("resourceGroupName")
  valid_594181 = validateParameter(valid_594181, JString, required = true,
                                 default = nil)
  if valid_594181 != nil:
    section.add "resourceGroupName", valid_594181
  var valid_594182 = path.getOrDefault("recordType")
  valid_594182 = validateParameter(valid_594182, JString, required = true,
                                 default = newJString("A"))
  if valid_594182 != nil:
    section.add "recordType", valid_594182
  var valid_594183 = path.getOrDefault("subscriptionId")
  valid_594183 = validateParameter(valid_594183, JString, required = true,
                                 default = nil)
  if valid_594183 != nil:
    section.add "subscriptionId", valid_594183
  var valid_594184 = path.getOrDefault("privateZoneName")
  valid_594184 = validateParameter(valid_594184, JString, required = true,
                                 default = nil)
  if valid_594184 != nil:
    section.add "privateZoneName", valid_594184
  var valid_594185 = path.getOrDefault("relativeRecordSetName")
  valid_594185 = validateParameter(valid_594185, JString, required = true,
                                 default = nil)
  if valid_594185 != nil:
    section.add "relativeRecordSetName", valid_594185
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594186 = query.getOrDefault("api-version")
  valid_594186 = validateParameter(valid_594186, JString, required = true,
                                 default = nil)
  if valid_594186 != nil:
    section.add "api-version", valid_594186
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : The ETag of the record set. Omit this value to always delete the current record set. Specify the last-seen ETag value to prevent accidentally deleting any concurrent changes.
  section = newJObject()
  var valid_594187 = header.getOrDefault("If-Match")
  valid_594187 = validateParameter(valid_594187, JString, required = false,
                                 default = nil)
  if valid_594187 != nil:
    section.add "If-Match", valid_594187
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594188: Call_RecordSetsDelete_594178; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a record set from a Private DNS zone. This operation cannot be undone.
  ## 
  let valid = call_594188.validator(path, query, header, formData, body)
  let scheme = call_594188.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594188.url(scheme.get, call_594188.host, call_594188.base,
                         call_594188.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594188, url, valid)

proc call*(call_594189: Call_RecordSetsDelete_594178; resourceGroupName: string;
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
  var path_594190 = newJObject()
  var query_594191 = newJObject()
  add(path_594190, "resourceGroupName", newJString(resourceGroupName))
  add(query_594191, "api-version", newJString(apiVersion))
  add(path_594190, "recordType", newJString(recordType))
  add(path_594190, "subscriptionId", newJString(subscriptionId))
  add(path_594190, "privateZoneName", newJString(privateZoneName))
  add(path_594190, "relativeRecordSetName", newJString(relativeRecordSetName))
  result = call_594189.call(path_594190, query_594191, nil, nil, nil)

var recordSetsDelete* = Call_RecordSetsDelete_594178(name: "recordSetsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/privateDnsZones/{privateZoneName}/{recordType}/{relativeRecordSetName}",
    validator: validate_RecordSetsDelete_594179, base: "",
    url: url_RecordSetsDelete_594180, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
