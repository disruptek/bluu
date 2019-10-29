
import
  json, options, hashes, uri, rest, os, uri, httpcore

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

  OpenApiRestCall_563555 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_563555](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_563555): Option[Scheme] {.used.} =
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
  macServiceName = "privatedns"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_PrivateZonesList_563777 = ref object of OpenApiRestCall_563555
proc url_PrivateZonesList_563779(protocol: Scheme; host: string; base: string;
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

proc validate_PrivateZonesList_563778(path: JsonNode; query: JsonNode;
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
  var valid_563955 = path.getOrDefault("subscriptionId")
  valid_563955 = validateParameter(valid_563955, JString, required = true,
                                 default = nil)
  if valid_563955 != nil:
    section.add "subscriptionId", valid_563955
  result.add "path", section
  ## parameters in `query` object:
  ##   $top: JInt
  ##       : The maximum number of Private DNS zones to return. If not specified, returns up to 100 zones.
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  var valid_563956 = query.getOrDefault("$top")
  valid_563956 = validateParameter(valid_563956, JInt, required = false, default = nil)
  if valid_563956 != nil:
    section.add "$top", valid_563956
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_563957 = query.getOrDefault("api-version")
  valid_563957 = validateParameter(valid_563957, JString, required = true,
                                 default = nil)
  if valid_563957 != nil:
    section.add "api-version", valid_563957
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_563980: Call_PrivateZonesList_563777; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the Private DNS zones in all resource groups in a subscription.
  ## 
  let valid = call_563980.validator(path, query, header, formData, body)
  let scheme = call_563980.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_563980.url(scheme.get, call_563980.host, call_563980.base,
                         call_563980.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_563980, url, valid)

proc call*(call_564051: Call_PrivateZonesList_563777; apiVersion: string;
          subscriptionId: string; Top: int = 0): Recallable =
  ## privateZonesList
  ## Lists the Private DNS zones in all resource groups in a subscription.
  ##   Top: int
  ##      : The maximum number of Private DNS zones to return. If not specified, returns up to 100 zones.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_564052 = newJObject()
  var query_564054 = newJObject()
  add(query_564054, "$top", newJInt(Top))
  add(query_564054, "api-version", newJString(apiVersion))
  add(path_564052, "subscriptionId", newJString(subscriptionId))
  result = call_564051.call(path_564052, query_564054, nil, nil, nil)

var privateZonesList* = Call_PrivateZonesList_563777(name: "privateZonesList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Network/privateDnsZones",
    validator: validate_PrivateZonesList_563778, base: "",
    url: url_PrivateZonesList_563779, schemes: {Scheme.Https})
type
  Call_PrivateZonesListByResourceGroup_564093 = ref object of OpenApiRestCall_563555
proc url_PrivateZonesListByResourceGroup_564095(protocol: Scheme; host: string;
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

proc validate_PrivateZonesListByResourceGroup_564094(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the Private DNS zones within a resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564096 = path.getOrDefault("subscriptionId")
  valid_564096 = validateParameter(valid_564096, JString, required = true,
                                 default = nil)
  if valid_564096 != nil:
    section.add "subscriptionId", valid_564096
  var valid_564097 = path.getOrDefault("resourceGroupName")
  valid_564097 = validateParameter(valid_564097, JString, required = true,
                                 default = nil)
  if valid_564097 != nil:
    section.add "resourceGroupName", valid_564097
  result.add "path", section
  ## parameters in `query` object:
  ##   $top: JInt
  ##       : The maximum number of record sets to return. If not specified, returns up to 100 record sets.
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  var valid_564098 = query.getOrDefault("$top")
  valid_564098 = validateParameter(valid_564098, JInt, required = false, default = nil)
  if valid_564098 != nil:
    section.add "$top", valid_564098
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564099 = query.getOrDefault("api-version")
  valid_564099 = validateParameter(valid_564099, JString, required = true,
                                 default = nil)
  if valid_564099 != nil:
    section.add "api-version", valid_564099
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564100: Call_PrivateZonesListByResourceGroup_564093;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the Private DNS zones within a resource group.
  ## 
  let valid = call_564100.validator(path, query, header, formData, body)
  let scheme = call_564100.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564100.url(scheme.get, call_564100.host, call_564100.base,
                         call_564100.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564100, url, valid)

proc call*(call_564101: Call_PrivateZonesListByResourceGroup_564093;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          Top: int = 0): Recallable =
  ## privateZonesListByResourceGroup
  ## Lists the Private DNS zones within a resource group.
  ##   Top: int
  ##      : The maximum number of record sets to return. If not specified, returns up to 100 record sets.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564102 = newJObject()
  var query_564103 = newJObject()
  add(query_564103, "$top", newJInt(Top))
  add(query_564103, "api-version", newJString(apiVersion))
  add(path_564102, "subscriptionId", newJString(subscriptionId))
  add(path_564102, "resourceGroupName", newJString(resourceGroupName))
  result = call_564101.call(path_564102, query_564103, nil, nil, nil)

var privateZonesListByResourceGroup* = Call_PrivateZonesListByResourceGroup_564093(
    name: "privateZonesListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/privateDnsZones",
    validator: validate_PrivateZonesListByResourceGroup_564094, base: "",
    url: url_PrivateZonesListByResourceGroup_564095, schemes: {Scheme.Https})
type
  Call_PrivateZonesCreateOrUpdate_564115 = ref object of OpenApiRestCall_563555
proc url_PrivateZonesCreateOrUpdate_564117(protocol: Scheme; host: string;
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

proc validate_PrivateZonesCreateOrUpdate_564116(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates a Private DNS zone. Does not modify Links to virtual networks or DNS records within the zone.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   privateZoneName: JString (required)
  ##                  : The name of the Private DNS zone (without a terminating dot).
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `privateZoneName` field"
  var valid_564135 = path.getOrDefault("privateZoneName")
  valid_564135 = validateParameter(valid_564135, JString, required = true,
                                 default = nil)
  if valid_564135 != nil:
    section.add "privateZoneName", valid_564135
  var valid_564136 = path.getOrDefault("subscriptionId")
  valid_564136 = validateParameter(valid_564136, JString, required = true,
                                 default = nil)
  if valid_564136 != nil:
    section.add "subscriptionId", valid_564136
  var valid_564137 = path.getOrDefault("resourceGroupName")
  valid_564137 = validateParameter(valid_564137, JString, required = true,
                                 default = nil)
  if valid_564137 != nil:
    section.add "resourceGroupName", valid_564137
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564138 = query.getOrDefault("api-version")
  valid_564138 = validateParameter(valid_564138, JString, required = true,
                                 default = nil)
  if valid_564138 != nil:
    section.add "api-version", valid_564138
  result.add "query", section
  ## parameters in `header` object:
  ##   If-None-Match: JString
  ##                : Set to '*' to allow a new Private DNS zone to be created, but to prevent updating an existing zone. Other values will be ignored.
  ##   If-Match: JString
  ##           : The ETag of the Private DNS zone. Omit this value to always overwrite the current zone. Specify the last-seen ETag value to prevent accidentally overwriting any concurrent changes.
  section = newJObject()
  var valid_564139 = header.getOrDefault("If-None-Match")
  valid_564139 = validateParameter(valid_564139, JString, required = false,
                                 default = nil)
  if valid_564139 != nil:
    section.add "If-None-Match", valid_564139
  var valid_564140 = header.getOrDefault("If-Match")
  valid_564140 = validateParameter(valid_564140, JString, required = false,
                                 default = nil)
  if valid_564140 != nil:
    section.add "If-Match", valid_564140
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

proc call*(call_564142: Call_PrivateZonesCreateOrUpdate_564115; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates a Private DNS zone. Does not modify Links to virtual networks or DNS records within the zone.
  ## 
  let valid = call_564142.validator(path, query, header, formData, body)
  let scheme = call_564142.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564142.url(scheme.get, call_564142.host, call_564142.base,
                         call_564142.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564142, url, valid)

proc call*(call_564143: Call_PrivateZonesCreateOrUpdate_564115; apiVersion: string;
          privateZoneName: string; subscriptionId: string;
          resourceGroupName: string; parameters: JsonNode): Recallable =
  ## privateZonesCreateOrUpdate
  ## Creates or updates a Private DNS zone. Does not modify Links to virtual networks or DNS records within the zone.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   privateZoneName: string (required)
  ##                  : The name of the Private DNS zone (without a terminating dot).
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the CreateOrUpdate operation.
  var path_564144 = newJObject()
  var query_564145 = newJObject()
  var body_564146 = newJObject()
  add(query_564145, "api-version", newJString(apiVersion))
  add(path_564144, "privateZoneName", newJString(privateZoneName))
  add(path_564144, "subscriptionId", newJString(subscriptionId))
  add(path_564144, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564146 = parameters
  result = call_564143.call(path_564144, query_564145, nil, nil, body_564146)

var privateZonesCreateOrUpdate* = Call_PrivateZonesCreateOrUpdate_564115(
    name: "privateZonesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/privateDnsZones/{privateZoneName}",
    validator: validate_PrivateZonesCreateOrUpdate_564116, base: "",
    url: url_PrivateZonesCreateOrUpdate_564117, schemes: {Scheme.Https})
type
  Call_PrivateZonesGet_564104 = ref object of OpenApiRestCall_563555
proc url_PrivateZonesGet_564106(protocol: Scheme; host: string; base: string;
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

proc validate_PrivateZonesGet_564105(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Gets a Private DNS zone. Retrieves the zone properties, but not the virtual networks links or the record sets within the zone.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   privateZoneName: JString (required)
  ##                  : The name of the Private DNS zone (without a terminating dot).
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `privateZoneName` field"
  var valid_564107 = path.getOrDefault("privateZoneName")
  valid_564107 = validateParameter(valid_564107, JString, required = true,
                                 default = nil)
  if valid_564107 != nil:
    section.add "privateZoneName", valid_564107
  var valid_564108 = path.getOrDefault("subscriptionId")
  valid_564108 = validateParameter(valid_564108, JString, required = true,
                                 default = nil)
  if valid_564108 != nil:
    section.add "subscriptionId", valid_564108
  var valid_564109 = path.getOrDefault("resourceGroupName")
  valid_564109 = validateParameter(valid_564109, JString, required = true,
                                 default = nil)
  if valid_564109 != nil:
    section.add "resourceGroupName", valid_564109
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564110 = query.getOrDefault("api-version")
  valid_564110 = validateParameter(valid_564110, JString, required = true,
                                 default = nil)
  if valid_564110 != nil:
    section.add "api-version", valid_564110
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564111: Call_PrivateZonesGet_564104; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a Private DNS zone. Retrieves the zone properties, but not the virtual networks links or the record sets within the zone.
  ## 
  let valid = call_564111.validator(path, query, header, formData, body)
  let scheme = call_564111.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564111.url(scheme.get, call_564111.host, call_564111.base,
                         call_564111.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564111, url, valid)

proc call*(call_564112: Call_PrivateZonesGet_564104; apiVersion: string;
          privateZoneName: string; subscriptionId: string; resourceGroupName: string): Recallable =
  ## privateZonesGet
  ## Gets a Private DNS zone. Retrieves the zone properties, but not the virtual networks links or the record sets within the zone.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   privateZoneName: string (required)
  ##                  : The name of the Private DNS zone (without a terminating dot).
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564113 = newJObject()
  var query_564114 = newJObject()
  add(query_564114, "api-version", newJString(apiVersion))
  add(path_564113, "privateZoneName", newJString(privateZoneName))
  add(path_564113, "subscriptionId", newJString(subscriptionId))
  add(path_564113, "resourceGroupName", newJString(resourceGroupName))
  result = call_564112.call(path_564113, query_564114, nil, nil, nil)

var privateZonesGet* = Call_PrivateZonesGet_564104(name: "privateZonesGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/privateDnsZones/{privateZoneName}",
    validator: validate_PrivateZonesGet_564105, base: "", url: url_PrivateZonesGet_564106,
    schemes: {Scheme.Https})
type
  Call_PrivateZonesUpdate_564159 = ref object of OpenApiRestCall_563555
proc url_PrivateZonesUpdate_564161(protocol: Scheme; host: string; base: string;
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

proc validate_PrivateZonesUpdate_564160(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Updates a Private DNS zone. Does not modify virtual network links or DNS records within the zone.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   privateZoneName: JString (required)
  ##                  : The name of the Private DNS zone (without a terminating dot).
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `privateZoneName` field"
  var valid_564162 = path.getOrDefault("privateZoneName")
  valid_564162 = validateParameter(valid_564162, JString, required = true,
                                 default = nil)
  if valid_564162 != nil:
    section.add "privateZoneName", valid_564162
  var valid_564163 = path.getOrDefault("subscriptionId")
  valid_564163 = validateParameter(valid_564163, JString, required = true,
                                 default = nil)
  if valid_564163 != nil:
    section.add "subscriptionId", valid_564163
  var valid_564164 = path.getOrDefault("resourceGroupName")
  valid_564164 = validateParameter(valid_564164, JString, required = true,
                                 default = nil)
  if valid_564164 != nil:
    section.add "resourceGroupName", valid_564164
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564165 = query.getOrDefault("api-version")
  valid_564165 = validateParameter(valid_564165, JString, required = true,
                                 default = nil)
  if valid_564165 != nil:
    section.add "api-version", valid_564165
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : The ETag of the Private DNS zone. Omit this value to always overwrite the current zone. Specify the last-seen ETag value to prevent accidentally overwriting any concurrent changes.
  section = newJObject()
  var valid_564166 = header.getOrDefault("If-Match")
  valid_564166 = validateParameter(valid_564166, JString, required = false,
                                 default = nil)
  if valid_564166 != nil:
    section.add "If-Match", valid_564166
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

proc call*(call_564168: Call_PrivateZonesUpdate_564159; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a Private DNS zone. Does not modify virtual network links or DNS records within the zone.
  ## 
  let valid = call_564168.validator(path, query, header, formData, body)
  let scheme = call_564168.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564168.url(scheme.get, call_564168.host, call_564168.base,
                         call_564168.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564168, url, valid)

proc call*(call_564169: Call_PrivateZonesUpdate_564159; apiVersion: string;
          privateZoneName: string; subscriptionId: string;
          resourceGroupName: string; parameters: JsonNode): Recallable =
  ## privateZonesUpdate
  ## Updates a Private DNS zone. Does not modify virtual network links or DNS records within the zone.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   privateZoneName: string (required)
  ##                  : The name of the Private DNS zone (without a terminating dot).
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the Update operation.
  var path_564170 = newJObject()
  var query_564171 = newJObject()
  var body_564172 = newJObject()
  add(query_564171, "api-version", newJString(apiVersion))
  add(path_564170, "privateZoneName", newJString(privateZoneName))
  add(path_564170, "subscriptionId", newJString(subscriptionId))
  add(path_564170, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564172 = parameters
  result = call_564169.call(path_564170, query_564171, nil, nil, body_564172)

var privateZonesUpdate* = Call_PrivateZonesUpdate_564159(
    name: "privateZonesUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/privateDnsZones/{privateZoneName}",
    validator: validate_PrivateZonesUpdate_564160, base: "",
    url: url_PrivateZonesUpdate_564161, schemes: {Scheme.Https})
type
  Call_PrivateZonesDelete_564147 = ref object of OpenApiRestCall_563555
proc url_PrivateZonesDelete_564149(protocol: Scheme; host: string; base: string;
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

proc validate_PrivateZonesDelete_564148(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Deletes a Private DNS zone. WARNING: All DNS records in the zone will also be deleted. This operation cannot be undone. Private DNS zone cannot be deleted unless all virtual network links to it are removed.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   privateZoneName: JString (required)
  ##                  : The name of the Private DNS zone (without a terminating dot).
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `privateZoneName` field"
  var valid_564150 = path.getOrDefault("privateZoneName")
  valid_564150 = validateParameter(valid_564150, JString, required = true,
                                 default = nil)
  if valid_564150 != nil:
    section.add "privateZoneName", valid_564150
  var valid_564151 = path.getOrDefault("subscriptionId")
  valid_564151 = validateParameter(valid_564151, JString, required = true,
                                 default = nil)
  if valid_564151 != nil:
    section.add "subscriptionId", valid_564151
  var valid_564152 = path.getOrDefault("resourceGroupName")
  valid_564152 = validateParameter(valid_564152, JString, required = true,
                                 default = nil)
  if valid_564152 != nil:
    section.add "resourceGroupName", valid_564152
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564153 = query.getOrDefault("api-version")
  valid_564153 = validateParameter(valid_564153, JString, required = true,
                                 default = nil)
  if valid_564153 != nil:
    section.add "api-version", valid_564153
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : The ETag of the Private DNS zone. Omit this value to always delete the current zone. Specify the last-seen ETag value to prevent accidentally deleting any concurrent changes.
  section = newJObject()
  var valid_564154 = header.getOrDefault("If-Match")
  valid_564154 = validateParameter(valid_564154, JString, required = false,
                                 default = nil)
  if valid_564154 != nil:
    section.add "If-Match", valid_564154
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564155: Call_PrivateZonesDelete_564147; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a Private DNS zone. WARNING: All DNS records in the zone will also be deleted. This operation cannot be undone. Private DNS zone cannot be deleted unless all virtual network links to it are removed.
  ## 
  let valid = call_564155.validator(path, query, header, formData, body)
  let scheme = call_564155.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564155.url(scheme.get, call_564155.host, call_564155.base,
                         call_564155.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564155, url, valid)

proc call*(call_564156: Call_PrivateZonesDelete_564147; apiVersion: string;
          privateZoneName: string; subscriptionId: string; resourceGroupName: string): Recallable =
  ## privateZonesDelete
  ## Deletes a Private DNS zone. WARNING: All DNS records in the zone will also be deleted. This operation cannot be undone. Private DNS zone cannot be deleted unless all virtual network links to it are removed.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   privateZoneName: string (required)
  ##                  : The name of the Private DNS zone (without a terminating dot).
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564157 = newJObject()
  var query_564158 = newJObject()
  add(query_564158, "api-version", newJString(apiVersion))
  add(path_564157, "privateZoneName", newJString(privateZoneName))
  add(path_564157, "subscriptionId", newJString(subscriptionId))
  add(path_564157, "resourceGroupName", newJString(resourceGroupName))
  result = call_564156.call(path_564157, query_564158, nil, nil, nil)

var privateZonesDelete* = Call_PrivateZonesDelete_564147(
    name: "privateZonesDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/privateDnsZones/{privateZoneName}",
    validator: validate_PrivateZonesDelete_564148, base: "",
    url: url_PrivateZonesDelete_564149, schemes: {Scheme.Https})
type
  Call_RecordSetsList_564173 = ref object of OpenApiRestCall_563555
proc url_RecordSetsList_564175(protocol: Scheme; host: string; base: string;
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

proc validate_RecordSetsList_564174(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Lists all record sets in a Private DNS zone.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   privateZoneName: JString (required)
  ##                  : The name of the Private DNS zone (without a terminating dot).
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `privateZoneName` field"
  var valid_564176 = path.getOrDefault("privateZoneName")
  valid_564176 = validateParameter(valid_564176, JString, required = true,
                                 default = nil)
  if valid_564176 != nil:
    section.add "privateZoneName", valid_564176
  var valid_564177 = path.getOrDefault("subscriptionId")
  valid_564177 = validateParameter(valid_564177, JString, required = true,
                                 default = nil)
  if valid_564177 != nil:
    section.add "subscriptionId", valid_564177
  var valid_564178 = path.getOrDefault("resourceGroupName")
  valid_564178 = validateParameter(valid_564178, JString, required = true,
                                 default = nil)
  if valid_564178 != nil:
    section.add "resourceGroupName", valid_564178
  result.add "path", section
  ## parameters in `query` object:
  ##   $top: JInt
  ##       : The maximum number of record sets to return. If not specified, returns up to 100 record sets.
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $recordsetnamesuffix: JString
  ##                       : The suffix label of the record set name to be used to filter the record set enumeration. If this parameter is specified, the returned enumeration will only contain records that end with ".<recordsetnamesuffix>".
  section = newJObject()
  var valid_564179 = query.getOrDefault("$top")
  valid_564179 = validateParameter(valid_564179, JInt, required = false, default = nil)
  if valid_564179 != nil:
    section.add "$top", valid_564179
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564180 = query.getOrDefault("api-version")
  valid_564180 = validateParameter(valid_564180, JString, required = true,
                                 default = nil)
  if valid_564180 != nil:
    section.add "api-version", valid_564180
  var valid_564181 = query.getOrDefault("$recordsetnamesuffix")
  valid_564181 = validateParameter(valid_564181, JString, required = false,
                                 default = nil)
  if valid_564181 != nil:
    section.add "$recordsetnamesuffix", valid_564181
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564182: Call_RecordSetsList_564173; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all record sets in a Private DNS zone.
  ## 
  let valid = call_564182.validator(path, query, header, formData, body)
  let scheme = call_564182.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564182.url(scheme.get, call_564182.host, call_564182.base,
                         call_564182.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564182, url, valid)

proc call*(call_564183: Call_RecordSetsList_564173; apiVersion: string;
          privateZoneName: string; subscriptionId: string;
          resourceGroupName: string; Top: int = 0; Recordsetnamesuffix: string = ""): Recallable =
  ## recordSetsList
  ## Lists all record sets in a Private DNS zone.
  ##   Top: int
  ##      : The maximum number of record sets to return. If not specified, returns up to 100 record sets.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   privateZoneName: string (required)
  ##                  : The name of the Private DNS zone (without a terminating dot).
  ##   Recordsetnamesuffix: string
  ##                      : The suffix label of the record set name to be used to filter the record set enumeration. If this parameter is specified, the returned enumeration will only contain records that end with ".<recordsetnamesuffix>".
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564184 = newJObject()
  var query_564185 = newJObject()
  add(query_564185, "$top", newJInt(Top))
  add(query_564185, "api-version", newJString(apiVersion))
  add(path_564184, "privateZoneName", newJString(privateZoneName))
  add(query_564185, "$recordsetnamesuffix", newJString(Recordsetnamesuffix))
  add(path_564184, "subscriptionId", newJString(subscriptionId))
  add(path_564184, "resourceGroupName", newJString(resourceGroupName))
  result = call_564183.call(path_564184, query_564185, nil, nil, nil)

var recordSetsList* = Call_RecordSetsList_564173(name: "recordSetsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/privateDnsZones/{privateZoneName}/ALL",
    validator: validate_RecordSetsList_564174, base: "", url: url_RecordSetsList_564175,
    schemes: {Scheme.Https})
type
  Call_VirtualNetworkLinksList_564186 = ref object of OpenApiRestCall_563555
proc url_VirtualNetworkLinksList_564188(protocol: Scheme; host: string; base: string;
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

proc validate_VirtualNetworkLinksList_564187(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the virtual network links to the specified Private DNS zone.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   privateZoneName: JString (required)
  ##                  : The name of the Private DNS zone (without a terminating dot).
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `privateZoneName` field"
  var valid_564189 = path.getOrDefault("privateZoneName")
  valid_564189 = validateParameter(valid_564189, JString, required = true,
                                 default = nil)
  if valid_564189 != nil:
    section.add "privateZoneName", valid_564189
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
  ##   $top: JInt
  ##       : The maximum number of virtual network links to return. If not specified, returns up to 100 virtual network links.
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  var valid_564192 = query.getOrDefault("$top")
  valid_564192 = validateParameter(valid_564192, JInt, required = false, default = nil)
  if valid_564192 != nil:
    section.add "$top", valid_564192
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564193 = query.getOrDefault("api-version")
  valid_564193 = validateParameter(valid_564193, JString, required = true,
                                 default = nil)
  if valid_564193 != nil:
    section.add "api-version", valid_564193
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564194: Call_VirtualNetworkLinksList_564186; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the virtual network links to the specified Private DNS zone.
  ## 
  let valid = call_564194.validator(path, query, header, formData, body)
  let scheme = call_564194.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564194.url(scheme.get, call_564194.host, call_564194.base,
                         call_564194.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564194, url, valid)

proc call*(call_564195: Call_VirtualNetworkLinksList_564186; apiVersion: string;
          privateZoneName: string; subscriptionId: string;
          resourceGroupName: string; Top: int = 0): Recallable =
  ## virtualNetworkLinksList
  ## Lists the virtual network links to the specified Private DNS zone.
  ##   Top: int
  ##      : The maximum number of virtual network links to return. If not specified, returns up to 100 virtual network links.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   privateZoneName: string (required)
  ##                  : The name of the Private DNS zone (without a terminating dot).
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564196 = newJObject()
  var query_564197 = newJObject()
  add(query_564197, "$top", newJInt(Top))
  add(query_564197, "api-version", newJString(apiVersion))
  add(path_564196, "privateZoneName", newJString(privateZoneName))
  add(path_564196, "subscriptionId", newJString(subscriptionId))
  add(path_564196, "resourceGroupName", newJString(resourceGroupName))
  result = call_564195.call(path_564196, query_564197, nil, nil, nil)

var virtualNetworkLinksList* = Call_VirtualNetworkLinksList_564186(
    name: "virtualNetworkLinksList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/privateDnsZones/{privateZoneName}/virtualNetworkLinks",
    validator: validate_VirtualNetworkLinksList_564187, base: "",
    url: url_VirtualNetworkLinksList_564188, schemes: {Scheme.Https})
type
  Call_VirtualNetworkLinksCreateOrUpdate_564210 = ref object of OpenApiRestCall_563555
proc url_VirtualNetworkLinksCreateOrUpdate_564212(protocol: Scheme; host: string;
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

proc validate_VirtualNetworkLinksCreateOrUpdate_564211(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates a virtual network link to the specified Private DNS zone.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   privateZoneName: JString (required)
  ##                  : The name of the Private DNS zone (without a terminating dot).
  ##   virtualNetworkLinkName: JString (required)
  ##                         : The name of the virtual network link.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `privateZoneName` field"
  var valid_564213 = path.getOrDefault("privateZoneName")
  valid_564213 = validateParameter(valid_564213, JString, required = true,
                                 default = nil)
  if valid_564213 != nil:
    section.add "privateZoneName", valid_564213
  var valid_564214 = path.getOrDefault("virtualNetworkLinkName")
  valid_564214 = validateParameter(valid_564214, JString, required = true,
                                 default = nil)
  if valid_564214 != nil:
    section.add "virtualNetworkLinkName", valid_564214
  var valid_564215 = path.getOrDefault("subscriptionId")
  valid_564215 = validateParameter(valid_564215, JString, required = true,
                                 default = nil)
  if valid_564215 != nil:
    section.add "subscriptionId", valid_564215
  var valid_564216 = path.getOrDefault("resourceGroupName")
  valid_564216 = validateParameter(valid_564216, JString, required = true,
                                 default = nil)
  if valid_564216 != nil:
    section.add "resourceGroupName", valid_564216
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564217 = query.getOrDefault("api-version")
  valid_564217 = validateParameter(valid_564217, JString, required = true,
                                 default = nil)
  if valid_564217 != nil:
    section.add "api-version", valid_564217
  result.add "query", section
  ## parameters in `header` object:
  ##   If-None-Match: JString
  ##                : Set to '*' to allow a new virtual network link to the Private DNS zone to be created, but to prevent updating an existing link. Other values will be ignored.
  ##   If-Match: JString
  ##           : The ETag of the virtual network link to the Private DNS zone. Omit this value to always overwrite the current virtual network link. Specify the last-seen ETag value to prevent accidentally overwriting any concurrent changes.
  section = newJObject()
  var valid_564218 = header.getOrDefault("If-None-Match")
  valid_564218 = validateParameter(valid_564218, JString, required = false,
                                 default = nil)
  if valid_564218 != nil:
    section.add "If-None-Match", valid_564218
  var valid_564219 = header.getOrDefault("If-Match")
  valid_564219 = validateParameter(valid_564219, JString, required = false,
                                 default = nil)
  if valid_564219 != nil:
    section.add "If-Match", valid_564219
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

proc call*(call_564221: Call_VirtualNetworkLinksCreateOrUpdate_564210;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates a virtual network link to the specified Private DNS zone.
  ## 
  let valid = call_564221.validator(path, query, header, formData, body)
  let scheme = call_564221.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564221.url(scheme.get, call_564221.host, call_564221.base,
                         call_564221.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564221, url, valid)

proc call*(call_564222: Call_VirtualNetworkLinksCreateOrUpdate_564210;
          apiVersion: string; privateZoneName: string;
          virtualNetworkLinkName: string; subscriptionId: string;
          resourceGroupName: string; parameters: JsonNode): Recallable =
  ## virtualNetworkLinksCreateOrUpdate
  ## Creates or updates a virtual network link to the specified Private DNS zone.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   privateZoneName: string (required)
  ##                  : The name of the Private DNS zone (without a terminating dot).
  ##   virtualNetworkLinkName: string (required)
  ##                         : The name of the virtual network link.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the CreateOrUpdate operation.
  var path_564223 = newJObject()
  var query_564224 = newJObject()
  var body_564225 = newJObject()
  add(query_564224, "api-version", newJString(apiVersion))
  add(path_564223, "privateZoneName", newJString(privateZoneName))
  add(path_564223, "virtualNetworkLinkName", newJString(virtualNetworkLinkName))
  add(path_564223, "subscriptionId", newJString(subscriptionId))
  add(path_564223, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564225 = parameters
  result = call_564222.call(path_564223, query_564224, nil, nil, body_564225)

var virtualNetworkLinksCreateOrUpdate* = Call_VirtualNetworkLinksCreateOrUpdate_564210(
    name: "virtualNetworkLinksCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/privateDnsZones/{privateZoneName}/virtualNetworkLinks/{virtualNetworkLinkName}",
    validator: validate_VirtualNetworkLinksCreateOrUpdate_564211, base: "",
    url: url_VirtualNetworkLinksCreateOrUpdate_564212, schemes: {Scheme.Https})
type
  Call_VirtualNetworkLinksGet_564198 = ref object of OpenApiRestCall_563555
proc url_VirtualNetworkLinksGet_564200(protocol: Scheme; host: string; base: string;
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

proc validate_VirtualNetworkLinksGet_564199(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a virtual network link to the specified Private DNS zone.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   privateZoneName: JString (required)
  ##                  : The name of the Private DNS zone (without a terminating dot).
  ##   virtualNetworkLinkName: JString (required)
  ##                         : The name of the virtual network link.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `privateZoneName` field"
  var valid_564201 = path.getOrDefault("privateZoneName")
  valid_564201 = validateParameter(valid_564201, JString, required = true,
                                 default = nil)
  if valid_564201 != nil:
    section.add "privateZoneName", valid_564201
  var valid_564202 = path.getOrDefault("virtualNetworkLinkName")
  valid_564202 = validateParameter(valid_564202, JString, required = true,
                                 default = nil)
  if valid_564202 != nil:
    section.add "virtualNetworkLinkName", valid_564202
  var valid_564203 = path.getOrDefault("subscriptionId")
  valid_564203 = validateParameter(valid_564203, JString, required = true,
                                 default = nil)
  if valid_564203 != nil:
    section.add "subscriptionId", valid_564203
  var valid_564204 = path.getOrDefault("resourceGroupName")
  valid_564204 = validateParameter(valid_564204, JString, required = true,
                                 default = nil)
  if valid_564204 != nil:
    section.add "resourceGroupName", valid_564204
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564205 = query.getOrDefault("api-version")
  valid_564205 = validateParameter(valid_564205, JString, required = true,
                                 default = nil)
  if valid_564205 != nil:
    section.add "api-version", valid_564205
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564206: Call_VirtualNetworkLinksGet_564198; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a virtual network link to the specified Private DNS zone.
  ## 
  let valid = call_564206.validator(path, query, header, formData, body)
  let scheme = call_564206.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564206.url(scheme.get, call_564206.host, call_564206.base,
                         call_564206.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564206, url, valid)

proc call*(call_564207: Call_VirtualNetworkLinksGet_564198; apiVersion: string;
          privateZoneName: string; virtualNetworkLinkName: string;
          subscriptionId: string; resourceGroupName: string): Recallable =
  ## virtualNetworkLinksGet
  ## Gets a virtual network link to the specified Private DNS zone.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   privateZoneName: string (required)
  ##                  : The name of the Private DNS zone (without a terminating dot).
  ##   virtualNetworkLinkName: string (required)
  ##                         : The name of the virtual network link.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564208 = newJObject()
  var query_564209 = newJObject()
  add(query_564209, "api-version", newJString(apiVersion))
  add(path_564208, "privateZoneName", newJString(privateZoneName))
  add(path_564208, "virtualNetworkLinkName", newJString(virtualNetworkLinkName))
  add(path_564208, "subscriptionId", newJString(subscriptionId))
  add(path_564208, "resourceGroupName", newJString(resourceGroupName))
  result = call_564207.call(path_564208, query_564209, nil, nil, nil)

var virtualNetworkLinksGet* = Call_VirtualNetworkLinksGet_564198(
    name: "virtualNetworkLinksGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/privateDnsZones/{privateZoneName}/virtualNetworkLinks/{virtualNetworkLinkName}",
    validator: validate_VirtualNetworkLinksGet_564199, base: "",
    url: url_VirtualNetworkLinksGet_564200, schemes: {Scheme.Https})
type
  Call_VirtualNetworkLinksUpdate_564239 = ref object of OpenApiRestCall_563555
proc url_VirtualNetworkLinksUpdate_564241(protocol: Scheme; host: string;
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

proc validate_VirtualNetworkLinksUpdate_564240(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates a virtual network link to the specified Private DNS zone.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   privateZoneName: JString (required)
  ##                  : The name of the Private DNS zone (without a terminating dot).
  ##   virtualNetworkLinkName: JString (required)
  ##                         : The name of the virtual network link.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `privateZoneName` field"
  var valid_564242 = path.getOrDefault("privateZoneName")
  valid_564242 = validateParameter(valid_564242, JString, required = true,
                                 default = nil)
  if valid_564242 != nil:
    section.add "privateZoneName", valid_564242
  var valid_564243 = path.getOrDefault("virtualNetworkLinkName")
  valid_564243 = validateParameter(valid_564243, JString, required = true,
                                 default = nil)
  if valid_564243 != nil:
    section.add "virtualNetworkLinkName", valid_564243
  var valid_564244 = path.getOrDefault("subscriptionId")
  valid_564244 = validateParameter(valid_564244, JString, required = true,
                                 default = nil)
  if valid_564244 != nil:
    section.add "subscriptionId", valid_564244
  var valid_564245 = path.getOrDefault("resourceGroupName")
  valid_564245 = validateParameter(valid_564245, JString, required = true,
                                 default = nil)
  if valid_564245 != nil:
    section.add "resourceGroupName", valid_564245
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564246 = query.getOrDefault("api-version")
  valid_564246 = validateParameter(valid_564246, JString, required = true,
                                 default = nil)
  if valid_564246 != nil:
    section.add "api-version", valid_564246
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : The ETag of the virtual network link to the Private DNS zone. Omit this value to always overwrite the current virtual network link. Specify the last-seen ETag value to prevent accidentally overwriting any concurrent changes.
  section = newJObject()
  var valid_564247 = header.getOrDefault("If-Match")
  valid_564247 = validateParameter(valid_564247, JString, required = false,
                                 default = nil)
  if valid_564247 != nil:
    section.add "If-Match", valid_564247
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

proc call*(call_564249: Call_VirtualNetworkLinksUpdate_564239; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a virtual network link to the specified Private DNS zone.
  ## 
  let valid = call_564249.validator(path, query, header, formData, body)
  let scheme = call_564249.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564249.url(scheme.get, call_564249.host, call_564249.base,
                         call_564249.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564249, url, valid)

proc call*(call_564250: Call_VirtualNetworkLinksUpdate_564239; apiVersion: string;
          privateZoneName: string; virtualNetworkLinkName: string;
          subscriptionId: string; resourceGroupName: string; parameters: JsonNode): Recallable =
  ## virtualNetworkLinksUpdate
  ## Updates a virtual network link to the specified Private DNS zone.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   privateZoneName: string (required)
  ##                  : The name of the Private DNS zone (without a terminating dot).
  ##   virtualNetworkLinkName: string (required)
  ##                         : The name of the virtual network link.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the Update operation.
  var path_564251 = newJObject()
  var query_564252 = newJObject()
  var body_564253 = newJObject()
  add(query_564252, "api-version", newJString(apiVersion))
  add(path_564251, "privateZoneName", newJString(privateZoneName))
  add(path_564251, "virtualNetworkLinkName", newJString(virtualNetworkLinkName))
  add(path_564251, "subscriptionId", newJString(subscriptionId))
  add(path_564251, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564253 = parameters
  result = call_564250.call(path_564251, query_564252, nil, nil, body_564253)

var virtualNetworkLinksUpdate* = Call_VirtualNetworkLinksUpdate_564239(
    name: "virtualNetworkLinksUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/privateDnsZones/{privateZoneName}/virtualNetworkLinks/{virtualNetworkLinkName}",
    validator: validate_VirtualNetworkLinksUpdate_564240, base: "",
    url: url_VirtualNetworkLinksUpdate_564241, schemes: {Scheme.Https})
type
  Call_VirtualNetworkLinksDelete_564226 = ref object of OpenApiRestCall_563555
proc url_VirtualNetworkLinksDelete_564228(protocol: Scheme; host: string;
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

proc validate_VirtualNetworkLinksDelete_564227(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a virtual network link to the specified Private DNS zone. WARNING: In case of a registration virtual network, all auto-registered DNS records in the zone for the virtual network will also be deleted. This operation cannot be undone.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   privateZoneName: JString (required)
  ##                  : The name of the Private DNS zone (without a terminating dot).
  ##   virtualNetworkLinkName: JString (required)
  ##                         : The name of the virtual network link.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `privateZoneName` field"
  var valid_564229 = path.getOrDefault("privateZoneName")
  valid_564229 = validateParameter(valid_564229, JString, required = true,
                                 default = nil)
  if valid_564229 != nil:
    section.add "privateZoneName", valid_564229
  var valid_564230 = path.getOrDefault("virtualNetworkLinkName")
  valid_564230 = validateParameter(valid_564230, JString, required = true,
                                 default = nil)
  if valid_564230 != nil:
    section.add "virtualNetworkLinkName", valid_564230
  var valid_564231 = path.getOrDefault("subscriptionId")
  valid_564231 = validateParameter(valid_564231, JString, required = true,
                                 default = nil)
  if valid_564231 != nil:
    section.add "subscriptionId", valid_564231
  var valid_564232 = path.getOrDefault("resourceGroupName")
  valid_564232 = validateParameter(valid_564232, JString, required = true,
                                 default = nil)
  if valid_564232 != nil:
    section.add "resourceGroupName", valid_564232
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564233 = query.getOrDefault("api-version")
  valid_564233 = validateParameter(valid_564233, JString, required = true,
                                 default = nil)
  if valid_564233 != nil:
    section.add "api-version", valid_564233
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : The ETag of the virtual network link to the Private DNS zone. Omit this value to always delete the current zone. Specify the last-seen ETag value to prevent accidentally deleting any concurrent changes.
  section = newJObject()
  var valid_564234 = header.getOrDefault("If-Match")
  valid_564234 = validateParameter(valid_564234, JString, required = false,
                                 default = nil)
  if valid_564234 != nil:
    section.add "If-Match", valid_564234
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564235: Call_VirtualNetworkLinksDelete_564226; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a virtual network link to the specified Private DNS zone. WARNING: In case of a registration virtual network, all auto-registered DNS records in the zone for the virtual network will also be deleted. This operation cannot be undone.
  ## 
  let valid = call_564235.validator(path, query, header, formData, body)
  let scheme = call_564235.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564235.url(scheme.get, call_564235.host, call_564235.base,
                         call_564235.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564235, url, valid)

proc call*(call_564236: Call_VirtualNetworkLinksDelete_564226; apiVersion: string;
          privateZoneName: string; virtualNetworkLinkName: string;
          subscriptionId: string; resourceGroupName: string): Recallable =
  ## virtualNetworkLinksDelete
  ## Deletes a virtual network link to the specified Private DNS zone. WARNING: In case of a registration virtual network, all auto-registered DNS records in the zone for the virtual network will also be deleted. This operation cannot be undone.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   privateZoneName: string (required)
  ##                  : The name of the Private DNS zone (without a terminating dot).
  ##   virtualNetworkLinkName: string (required)
  ##                         : The name of the virtual network link.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564237 = newJObject()
  var query_564238 = newJObject()
  add(query_564238, "api-version", newJString(apiVersion))
  add(path_564237, "privateZoneName", newJString(privateZoneName))
  add(path_564237, "virtualNetworkLinkName", newJString(virtualNetworkLinkName))
  add(path_564237, "subscriptionId", newJString(subscriptionId))
  add(path_564237, "resourceGroupName", newJString(resourceGroupName))
  result = call_564236.call(path_564237, query_564238, nil, nil, nil)

var virtualNetworkLinksDelete* = Call_VirtualNetworkLinksDelete_564226(
    name: "virtualNetworkLinksDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/privateDnsZones/{privateZoneName}/virtualNetworkLinks/{virtualNetworkLinkName}",
    validator: validate_VirtualNetworkLinksDelete_564227, base: "",
    url: url_VirtualNetworkLinksDelete_564228, schemes: {Scheme.Https})
type
  Call_RecordSetsListByType_564254 = ref object of OpenApiRestCall_563555
proc url_RecordSetsListByType_564256(protocol: Scheme; host: string; base: string;
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

proc validate_RecordSetsListByType_564255(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the record sets of a specified type in a Private DNS zone.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   privateZoneName: JString (required)
  ##                  : The name of the Private DNS zone (without a terminating dot).
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   recordType: JString (required)
  ##             : The type of record sets to enumerate.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `privateZoneName` field"
  var valid_564257 = path.getOrDefault("privateZoneName")
  valid_564257 = validateParameter(valid_564257, JString, required = true,
                                 default = nil)
  if valid_564257 != nil:
    section.add "privateZoneName", valid_564257
  var valid_564258 = path.getOrDefault("subscriptionId")
  valid_564258 = validateParameter(valid_564258, JString, required = true,
                                 default = nil)
  if valid_564258 != nil:
    section.add "subscriptionId", valid_564258
  var valid_564272 = path.getOrDefault("recordType")
  valid_564272 = validateParameter(valid_564272, JString, required = true,
                                 default = newJString("A"))
  if valid_564272 != nil:
    section.add "recordType", valid_564272
  var valid_564273 = path.getOrDefault("resourceGroupName")
  valid_564273 = validateParameter(valid_564273, JString, required = true,
                                 default = nil)
  if valid_564273 != nil:
    section.add "resourceGroupName", valid_564273
  result.add "path", section
  ## parameters in `query` object:
  ##   $top: JInt
  ##       : The maximum number of record sets to return. If not specified, returns up to 100 record sets.
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $recordsetnamesuffix: JString
  ##                       : The suffix label of the record set name to be used to filter the record set enumeration. If this parameter is specified, the returned enumeration will only contain records that end with ".<recordsetnamesuffix>".
  section = newJObject()
  var valid_564274 = query.getOrDefault("$top")
  valid_564274 = validateParameter(valid_564274, JInt, required = false, default = nil)
  if valid_564274 != nil:
    section.add "$top", valid_564274
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564275 = query.getOrDefault("api-version")
  valid_564275 = validateParameter(valid_564275, JString, required = true,
                                 default = nil)
  if valid_564275 != nil:
    section.add "api-version", valid_564275
  var valid_564276 = query.getOrDefault("$recordsetnamesuffix")
  valid_564276 = validateParameter(valid_564276, JString, required = false,
                                 default = nil)
  if valid_564276 != nil:
    section.add "$recordsetnamesuffix", valid_564276
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564277: Call_RecordSetsListByType_564254; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the record sets of a specified type in a Private DNS zone.
  ## 
  let valid = call_564277.validator(path, query, header, formData, body)
  let scheme = call_564277.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564277.url(scheme.get, call_564277.host, call_564277.base,
                         call_564277.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564277, url, valid)

proc call*(call_564278: Call_RecordSetsListByType_564254; apiVersion: string;
          privateZoneName: string; subscriptionId: string;
          resourceGroupName: string; Top: int = 0; Recordsetnamesuffix: string = "";
          recordType: string = "A"): Recallable =
  ## recordSetsListByType
  ## Lists the record sets of a specified type in a Private DNS zone.
  ##   Top: int
  ##      : The maximum number of record sets to return. If not specified, returns up to 100 record sets.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   privateZoneName: string (required)
  ##                  : The name of the Private DNS zone (without a terminating dot).
  ##   Recordsetnamesuffix: string
  ##                      : The suffix label of the record set name to be used to filter the record set enumeration. If this parameter is specified, the returned enumeration will only contain records that end with ".<recordsetnamesuffix>".
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   recordType: string (required)
  ##             : The type of record sets to enumerate.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564279 = newJObject()
  var query_564280 = newJObject()
  add(query_564280, "$top", newJInt(Top))
  add(query_564280, "api-version", newJString(apiVersion))
  add(path_564279, "privateZoneName", newJString(privateZoneName))
  add(query_564280, "$recordsetnamesuffix", newJString(Recordsetnamesuffix))
  add(path_564279, "subscriptionId", newJString(subscriptionId))
  add(path_564279, "recordType", newJString(recordType))
  add(path_564279, "resourceGroupName", newJString(resourceGroupName))
  result = call_564278.call(path_564279, query_564280, nil, nil, nil)

var recordSetsListByType* = Call_RecordSetsListByType_564254(
    name: "recordSetsListByType", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/privateDnsZones/{privateZoneName}/{recordType}",
    validator: validate_RecordSetsListByType_564255, base: "",
    url: url_RecordSetsListByType_564256, schemes: {Scheme.Https})
type
  Call_RecordSetsCreateOrUpdate_564294 = ref object of OpenApiRestCall_563555
proc url_RecordSetsCreateOrUpdate_564296(protocol: Scheme; host: string;
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

proc validate_RecordSetsCreateOrUpdate_564295(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates a record set within a Private DNS zone.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   relativeRecordSetName: JString (required)
  ##                        : The name of the record set, relative to the name of the zone.
  ##   privateZoneName: JString (required)
  ##                  : The name of the Private DNS zone (without a terminating dot).
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   recordType: JString (required)
  ##             : The type of DNS record in this record set. Record sets of type SOA can be updated but not created (they are created when the Private DNS zone is created).
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `relativeRecordSetName` field"
  var valid_564297 = path.getOrDefault("relativeRecordSetName")
  valid_564297 = validateParameter(valid_564297, JString, required = true,
                                 default = nil)
  if valid_564297 != nil:
    section.add "relativeRecordSetName", valid_564297
  var valid_564298 = path.getOrDefault("privateZoneName")
  valid_564298 = validateParameter(valid_564298, JString, required = true,
                                 default = nil)
  if valid_564298 != nil:
    section.add "privateZoneName", valid_564298
  var valid_564299 = path.getOrDefault("subscriptionId")
  valid_564299 = validateParameter(valid_564299, JString, required = true,
                                 default = nil)
  if valid_564299 != nil:
    section.add "subscriptionId", valid_564299
  var valid_564300 = path.getOrDefault("recordType")
  valid_564300 = validateParameter(valid_564300, JString, required = true,
                                 default = newJString("A"))
  if valid_564300 != nil:
    section.add "recordType", valid_564300
  var valid_564301 = path.getOrDefault("resourceGroupName")
  valid_564301 = validateParameter(valid_564301, JString, required = true,
                                 default = nil)
  if valid_564301 != nil:
    section.add "resourceGroupName", valid_564301
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564302 = query.getOrDefault("api-version")
  valid_564302 = validateParameter(valid_564302, JString, required = true,
                                 default = nil)
  if valid_564302 != nil:
    section.add "api-version", valid_564302
  result.add "query", section
  ## parameters in `header` object:
  ##   If-None-Match: JString
  ##                : Set to '*' to allow a new record set to be created, but to prevent updating an existing record set. Other values will be ignored.
  ##   If-Match: JString
  ##           : The ETag of the record set. Omit this value to always overwrite the current record set. Specify the last-seen ETag value to prevent accidentally overwriting any concurrent changes.
  section = newJObject()
  var valid_564303 = header.getOrDefault("If-None-Match")
  valid_564303 = validateParameter(valid_564303, JString, required = false,
                                 default = nil)
  if valid_564303 != nil:
    section.add "If-None-Match", valid_564303
  var valid_564304 = header.getOrDefault("If-Match")
  valid_564304 = validateParameter(valid_564304, JString, required = false,
                                 default = nil)
  if valid_564304 != nil:
    section.add "If-Match", valid_564304
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

proc call*(call_564306: Call_RecordSetsCreateOrUpdate_564294; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates a record set within a Private DNS zone.
  ## 
  let valid = call_564306.validator(path, query, header, formData, body)
  let scheme = call_564306.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564306.url(scheme.get, call_564306.host, call_564306.base,
                         call_564306.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564306, url, valid)

proc call*(call_564307: Call_RecordSetsCreateOrUpdate_564294;
          relativeRecordSetName: string; apiVersion: string;
          privateZoneName: string; subscriptionId: string;
          resourceGroupName: string; parameters: JsonNode; recordType: string = "A"): Recallable =
  ## recordSetsCreateOrUpdate
  ## Creates or updates a record set within a Private DNS zone.
  ##   relativeRecordSetName: string (required)
  ##                        : The name of the record set, relative to the name of the zone.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   privateZoneName: string (required)
  ##                  : The name of the Private DNS zone (without a terminating dot).
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   recordType: string (required)
  ##             : The type of DNS record in this record set. Record sets of type SOA can be updated but not created (they are created when the Private DNS zone is created).
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the CreateOrUpdate operation.
  var path_564308 = newJObject()
  var query_564309 = newJObject()
  var body_564310 = newJObject()
  add(path_564308, "relativeRecordSetName", newJString(relativeRecordSetName))
  add(query_564309, "api-version", newJString(apiVersion))
  add(path_564308, "privateZoneName", newJString(privateZoneName))
  add(path_564308, "subscriptionId", newJString(subscriptionId))
  add(path_564308, "recordType", newJString(recordType))
  add(path_564308, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564310 = parameters
  result = call_564307.call(path_564308, query_564309, nil, nil, body_564310)

var recordSetsCreateOrUpdate* = Call_RecordSetsCreateOrUpdate_564294(
    name: "recordSetsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/privateDnsZones/{privateZoneName}/{recordType}/{relativeRecordSetName}",
    validator: validate_RecordSetsCreateOrUpdate_564295, base: "",
    url: url_RecordSetsCreateOrUpdate_564296, schemes: {Scheme.Https})
type
  Call_RecordSetsGet_564281 = ref object of OpenApiRestCall_563555
proc url_RecordSetsGet_564283(protocol: Scheme; host: string; base: string;
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

proc validate_RecordSetsGet_564282(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a record set.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   relativeRecordSetName: JString (required)
  ##                        : The name of the record set, relative to the name of the zone.
  ##   privateZoneName: JString (required)
  ##                  : The name of the Private DNS zone (without a terminating dot).
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   recordType: JString (required)
  ##             : The type of DNS record in this record set.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `relativeRecordSetName` field"
  var valid_564284 = path.getOrDefault("relativeRecordSetName")
  valid_564284 = validateParameter(valid_564284, JString, required = true,
                                 default = nil)
  if valid_564284 != nil:
    section.add "relativeRecordSetName", valid_564284
  var valid_564285 = path.getOrDefault("privateZoneName")
  valid_564285 = validateParameter(valid_564285, JString, required = true,
                                 default = nil)
  if valid_564285 != nil:
    section.add "privateZoneName", valid_564285
  var valid_564286 = path.getOrDefault("subscriptionId")
  valid_564286 = validateParameter(valid_564286, JString, required = true,
                                 default = nil)
  if valid_564286 != nil:
    section.add "subscriptionId", valid_564286
  var valid_564287 = path.getOrDefault("recordType")
  valid_564287 = validateParameter(valid_564287, JString, required = true,
                                 default = newJString("A"))
  if valid_564287 != nil:
    section.add "recordType", valid_564287
  var valid_564288 = path.getOrDefault("resourceGroupName")
  valid_564288 = validateParameter(valid_564288, JString, required = true,
                                 default = nil)
  if valid_564288 != nil:
    section.add "resourceGroupName", valid_564288
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564289 = query.getOrDefault("api-version")
  valid_564289 = validateParameter(valid_564289, JString, required = true,
                                 default = nil)
  if valid_564289 != nil:
    section.add "api-version", valid_564289
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564290: Call_RecordSetsGet_564281; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a record set.
  ## 
  let valid = call_564290.validator(path, query, header, formData, body)
  let scheme = call_564290.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564290.url(scheme.get, call_564290.host, call_564290.base,
                         call_564290.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564290, url, valid)

proc call*(call_564291: Call_RecordSetsGet_564281; relativeRecordSetName: string;
          apiVersion: string; privateZoneName: string; subscriptionId: string;
          resourceGroupName: string; recordType: string = "A"): Recallable =
  ## recordSetsGet
  ## Gets a record set.
  ##   relativeRecordSetName: string (required)
  ##                        : The name of the record set, relative to the name of the zone.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   privateZoneName: string (required)
  ##                  : The name of the Private DNS zone (without a terminating dot).
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   recordType: string (required)
  ##             : The type of DNS record in this record set.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564292 = newJObject()
  var query_564293 = newJObject()
  add(path_564292, "relativeRecordSetName", newJString(relativeRecordSetName))
  add(query_564293, "api-version", newJString(apiVersion))
  add(path_564292, "privateZoneName", newJString(privateZoneName))
  add(path_564292, "subscriptionId", newJString(subscriptionId))
  add(path_564292, "recordType", newJString(recordType))
  add(path_564292, "resourceGroupName", newJString(resourceGroupName))
  result = call_564291.call(path_564292, query_564293, nil, nil, nil)

var recordSetsGet* = Call_RecordSetsGet_564281(name: "recordSetsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/privateDnsZones/{privateZoneName}/{recordType}/{relativeRecordSetName}",
    validator: validate_RecordSetsGet_564282, base: "", url: url_RecordSetsGet_564283,
    schemes: {Scheme.Https})
type
  Call_RecordSetsUpdate_564325 = ref object of OpenApiRestCall_563555
proc url_RecordSetsUpdate_564327(protocol: Scheme; host: string; base: string;
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

proc validate_RecordSetsUpdate_564326(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Updates a record set within a Private DNS zone.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   relativeRecordSetName: JString (required)
  ##                        : The name of the record set, relative to the name of the zone.
  ##   privateZoneName: JString (required)
  ##                  : The name of the Private DNS zone (without a terminating dot).
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   recordType: JString (required)
  ##             : The type of DNS record in this record set.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `relativeRecordSetName` field"
  var valid_564328 = path.getOrDefault("relativeRecordSetName")
  valid_564328 = validateParameter(valid_564328, JString, required = true,
                                 default = nil)
  if valid_564328 != nil:
    section.add "relativeRecordSetName", valid_564328
  var valid_564329 = path.getOrDefault("privateZoneName")
  valid_564329 = validateParameter(valid_564329, JString, required = true,
                                 default = nil)
  if valid_564329 != nil:
    section.add "privateZoneName", valid_564329
  var valid_564330 = path.getOrDefault("subscriptionId")
  valid_564330 = validateParameter(valid_564330, JString, required = true,
                                 default = nil)
  if valid_564330 != nil:
    section.add "subscriptionId", valid_564330
  var valid_564331 = path.getOrDefault("recordType")
  valid_564331 = validateParameter(valid_564331, JString, required = true,
                                 default = newJString("A"))
  if valid_564331 != nil:
    section.add "recordType", valid_564331
  var valid_564332 = path.getOrDefault("resourceGroupName")
  valid_564332 = validateParameter(valid_564332, JString, required = true,
                                 default = nil)
  if valid_564332 != nil:
    section.add "resourceGroupName", valid_564332
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564333 = query.getOrDefault("api-version")
  valid_564333 = validateParameter(valid_564333, JString, required = true,
                                 default = nil)
  if valid_564333 != nil:
    section.add "api-version", valid_564333
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : The ETag of the record set. Omit this value to always overwrite the current record set. Specify the last-seen ETag value to prevent accidentally overwriting concurrent changes.
  section = newJObject()
  var valid_564334 = header.getOrDefault("If-Match")
  valid_564334 = validateParameter(valid_564334, JString, required = false,
                                 default = nil)
  if valid_564334 != nil:
    section.add "If-Match", valid_564334
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

proc call*(call_564336: Call_RecordSetsUpdate_564325; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a record set within a Private DNS zone.
  ## 
  let valid = call_564336.validator(path, query, header, formData, body)
  let scheme = call_564336.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564336.url(scheme.get, call_564336.host, call_564336.base,
                         call_564336.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564336, url, valid)

proc call*(call_564337: Call_RecordSetsUpdate_564325;
          relativeRecordSetName: string; apiVersion: string;
          privateZoneName: string; subscriptionId: string;
          resourceGroupName: string; parameters: JsonNode; recordType: string = "A"): Recallable =
  ## recordSetsUpdate
  ## Updates a record set within a Private DNS zone.
  ##   relativeRecordSetName: string (required)
  ##                        : The name of the record set, relative to the name of the zone.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   privateZoneName: string (required)
  ##                  : The name of the Private DNS zone (without a terminating dot).
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   recordType: string (required)
  ##             : The type of DNS record in this record set.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the Update operation.
  var path_564338 = newJObject()
  var query_564339 = newJObject()
  var body_564340 = newJObject()
  add(path_564338, "relativeRecordSetName", newJString(relativeRecordSetName))
  add(query_564339, "api-version", newJString(apiVersion))
  add(path_564338, "privateZoneName", newJString(privateZoneName))
  add(path_564338, "subscriptionId", newJString(subscriptionId))
  add(path_564338, "recordType", newJString(recordType))
  add(path_564338, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564340 = parameters
  result = call_564337.call(path_564338, query_564339, nil, nil, body_564340)

var recordSetsUpdate* = Call_RecordSetsUpdate_564325(name: "recordSetsUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/privateDnsZones/{privateZoneName}/{recordType}/{relativeRecordSetName}",
    validator: validate_RecordSetsUpdate_564326, base: "",
    url: url_RecordSetsUpdate_564327, schemes: {Scheme.Https})
type
  Call_RecordSetsDelete_564311 = ref object of OpenApiRestCall_563555
proc url_RecordSetsDelete_564313(protocol: Scheme; host: string; base: string;
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

proc validate_RecordSetsDelete_564312(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Deletes a record set from a Private DNS zone. This operation cannot be undone.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   relativeRecordSetName: JString (required)
  ##                        : The name of the record set, relative to the name of the zone.
  ##   privateZoneName: JString (required)
  ##                  : The name of the Private DNS zone (without a terminating dot).
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   recordType: JString (required)
  ##             : The type of DNS record in this record set. Record sets of type SOA cannot be deleted (they are deleted when the Private DNS zone is deleted).
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `relativeRecordSetName` field"
  var valid_564314 = path.getOrDefault("relativeRecordSetName")
  valid_564314 = validateParameter(valid_564314, JString, required = true,
                                 default = nil)
  if valid_564314 != nil:
    section.add "relativeRecordSetName", valid_564314
  var valid_564315 = path.getOrDefault("privateZoneName")
  valid_564315 = validateParameter(valid_564315, JString, required = true,
                                 default = nil)
  if valid_564315 != nil:
    section.add "privateZoneName", valid_564315
  var valid_564316 = path.getOrDefault("subscriptionId")
  valid_564316 = validateParameter(valid_564316, JString, required = true,
                                 default = nil)
  if valid_564316 != nil:
    section.add "subscriptionId", valid_564316
  var valid_564317 = path.getOrDefault("recordType")
  valid_564317 = validateParameter(valid_564317, JString, required = true,
                                 default = newJString("A"))
  if valid_564317 != nil:
    section.add "recordType", valid_564317
  var valid_564318 = path.getOrDefault("resourceGroupName")
  valid_564318 = validateParameter(valid_564318, JString, required = true,
                                 default = nil)
  if valid_564318 != nil:
    section.add "resourceGroupName", valid_564318
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564319 = query.getOrDefault("api-version")
  valid_564319 = validateParameter(valid_564319, JString, required = true,
                                 default = nil)
  if valid_564319 != nil:
    section.add "api-version", valid_564319
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : The ETag of the record set. Omit this value to always delete the current record set. Specify the last-seen ETag value to prevent accidentally deleting any concurrent changes.
  section = newJObject()
  var valid_564320 = header.getOrDefault("If-Match")
  valid_564320 = validateParameter(valid_564320, JString, required = false,
                                 default = nil)
  if valid_564320 != nil:
    section.add "If-Match", valid_564320
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564321: Call_RecordSetsDelete_564311; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a record set from a Private DNS zone. This operation cannot be undone.
  ## 
  let valid = call_564321.validator(path, query, header, formData, body)
  let scheme = call_564321.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564321.url(scheme.get, call_564321.host, call_564321.base,
                         call_564321.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564321, url, valid)

proc call*(call_564322: Call_RecordSetsDelete_564311;
          relativeRecordSetName: string; apiVersion: string;
          privateZoneName: string; subscriptionId: string;
          resourceGroupName: string; recordType: string = "A"): Recallable =
  ## recordSetsDelete
  ## Deletes a record set from a Private DNS zone. This operation cannot be undone.
  ##   relativeRecordSetName: string (required)
  ##                        : The name of the record set, relative to the name of the zone.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   privateZoneName: string (required)
  ##                  : The name of the Private DNS zone (without a terminating dot).
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   recordType: string (required)
  ##             : The type of DNS record in this record set. Record sets of type SOA cannot be deleted (they are deleted when the Private DNS zone is deleted).
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564323 = newJObject()
  var query_564324 = newJObject()
  add(path_564323, "relativeRecordSetName", newJString(relativeRecordSetName))
  add(query_564324, "api-version", newJString(apiVersion))
  add(path_564323, "privateZoneName", newJString(privateZoneName))
  add(path_564323, "subscriptionId", newJString(subscriptionId))
  add(path_564323, "recordType", newJString(recordType))
  add(path_564323, "resourceGroupName", newJString(resourceGroupName))
  result = call_564322.call(path_564323, query_564324, nil, nil, nil)

var recordSetsDelete* = Call_RecordSetsDelete_564311(name: "recordSetsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/privateDnsZones/{privateZoneName}/{recordType}/{relativeRecordSetName}",
    validator: validate_RecordSetsDelete_564312, base: "",
    url: url_RecordSetsDelete_564313, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
