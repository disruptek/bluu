
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: DnsManagementClient
## version: 2017-10-01
## termsOfService: (not provided)
## license: (not provided)
## 
## The DNS Management Client.
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
  macServiceName = "dns"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_ZonesList_593646 = ref object of OpenApiRestCall_593424
proc url_ZonesList_593648(protocol: Scheme; host: string; base: string; route: string;
                         path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Network/dnszones")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ZonesList_593647(path: JsonNode; query: JsonNode; header: JsonNode;
                              formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the DNS zones in all resource groups in a subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_593809 = path.getOrDefault("subscriptionId")
  valid_593809 = validateParameter(valid_593809, JString, required = true,
                                 default = nil)
  if valid_593809 != nil:
    section.add "subscriptionId", valid_593809
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  ##   $top: JInt
  ##       : The maximum number of DNS zones to return. If not specified, returns up to 100 zones.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593810 = query.getOrDefault("api-version")
  valid_593810 = validateParameter(valid_593810, JString, required = true,
                                 default = nil)
  if valid_593810 != nil:
    section.add "api-version", valid_593810
  var valid_593811 = query.getOrDefault("$top")
  valid_593811 = validateParameter(valid_593811, JInt, required = false, default = nil)
  if valid_593811 != nil:
    section.add "$top", valid_593811
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593838: Call_ZonesList_593646; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the DNS zones in all resource groups in a subscription.
  ## 
  let valid = call_593838.validator(path, query, header, formData, body)
  let scheme = call_593838.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593838.url(scheme.get, call_593838.host, call_593838.base,
                         call_593838.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593838, url, valid)

proc call*(call_593909: Call_ZonesList_593646; apiVersion: string;
          subscriptionId: string; Top: int = 0): Recallable =
  ## zonesList
  ## Lists the DNS zones in all resource groups in a subscription.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   Top: int
  ##      : The maximum number of DNS zones to return. If not specified, returns up to 100 zones.
  var path_593910 = newJObject()
  var query_593912 = newJObject()
  add(query_593912, "api-version", newJString(apiVersion))
  add(path_593910, "subscriptionId", newJString(subscriptionId))
  add(query_593912, "$top", newJInt(Top))
  result = call_593909.call(path_593910, query_593912, nil, nil, nil)

var zonesList* = Call_ZonesList_593646(name: "zonesList", meth: HttpMethod.HttpGet,
                                    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Network/dnszones",
                                    validator: validate_ZonesList_593647,
                                    base: "", url: url_ZonesList_593648,
                                    schemes: {Scheme.Https})
type
  Call_ZonesListByResourceGroup_593951 = ref object of OpenApiRestCall_593424
proc url_ZonesListByResourceGroup_593953(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
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
        kind: ConstantSegment, value: "/providers/Microsoft.Network/dnsZones")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ZonesListByResourceGroup_593952(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the DNS zones within a resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_593954 = path.getOrDefault("resourceGroupName")
  valid_593954 = validateParameter(valid_593954, JString, required = true,
                                 default = nil)
  if valid_593954 != nil:
    section.add "resourceGroupName", valid_593954
  var valid_593955 = path.getOrDefault("subscriptionId")
  valid_593955 = validateParameter(valid_593955, JString, required = true,
                                 default = nil)
  if valid_593955 != nil:
    section.add "subscriptionId", valid_593955
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  ##   $top: JInt
  ##       : The maximum number of record sets to return. If not specified, returns up to 100 record sets.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593956 = query.getOrDefault("api-version")
  valid_593956 = validateParameter(valid_593956, JString, required = true,
                                 default = nil)
  if valid_593956 != nil:
    section.add "api-version", valid_593956
  var valid_593957 = query.getOrDefault("$top")
  valid_593957 = validateParameter(valid_593957, JInt, required = false, default = nil)
  if valid_593957 != nil:
    section.add "$top", valid_593957
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593958: Call_ZonesListByResourceGroup_593951; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the DNS zones within a resource group.
  ## 
  let valid = call_593958.validator(path, query, header, formData, body)
  let scheme = call_593958.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593958.url(scheme.get, call_593958.host, call_593958.base,
                         call_593958.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593958, url, valid)

proc call*(call_593959: Call_ZonesListByResourceGroup_593951;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          Top: int = 0): Recallable =
  ## zonesListByResourceGroup
  ## Lists the DNS zones within a resource group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   Top: int
  ##      : The maximum number of record sets to return. If not specified, returns up to 100 record sets.
  var path_593960 = newJObject()
  var query_593961 = newJObject()
  add(path_593960, "resourceGroupName", newJString(resourceGroupName))
  add(query_593961, "api-version", newJString(apiVersion))
  add(path_593960, "subscriptionId", newJString(subscriptionId))
  add(query_593961, "$top", newJInt(Top))
  result = call_593959.call(path_593960, query_593961, nil, nil, nil)

var zonesListByResourceGroup* = Call_ZonesListByResourceGroup_593951(
    name: "zonesListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/dnsZones",
    validator: validate_ZonesListByResourceGroup_593952, base: "",
    url: url_ZonesListByResourceGroup_593953, schemes: {Scheme.Https})
type
  Call_ZonesCreateOrUpdate_593973 = ref object of OpenApiRestCall_593424
proc url_ZonesCreateOrUpdate_593975(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "zoneName" in path, "`zoneName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Network/dnsZones/"),
               (kind: VariableSegment, value: "zoneName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ZonesCreateOrUpdate_593974(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Creates or updates a DNS zone. Does not modify DNS records within the zone.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   zoneName: JString (required)
  ##           : The name of the DNS zone (without a terminating dot).
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
  var valid_594004 = path.getOrDefault("zoneName")
  valid_594004 = validateParameter(valid_594004, JString, required = true,
                                 default = nil)
  if valid_594004 != nil:
    section.add "zoneName", valid_594004
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
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
  ##           : The etag of the DNS zone. Omit this value to always overwrite the current zone. Specify the last-seen etag value to prevent accidentally overwriting any concurrent changes.
  ##   If-None-Match: JString
  ##                : Set to '*' to allow a new DNS zone to be created, but to prevent updating an existing zone. Other values will be ignored.
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

proc call*(call_594009: Call_ZonesCreateOrUpdate_593973; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates a DNS zone. Does not modify DNS records within the zone.
  ## 
  let valid = call_594009.validator(path, query, header, formData, body)
  let scheme = call_594009.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594009.url(scheme.get, call_594009.host, call_594009.base,
                         call_594009.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594009, url, valid)

proc call*(call_594010: Call_ZonesCreateOrUpdate_593973; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; zoneName: string;
          parameters: JsonNode): Recallable =
  ## zonesCreateOrUpdate
  ## Creates or updates a DNS zone. Does not modify DNS records within the zone.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   zoneName: string (required)
  ##           : The name of the DNS zone (without a terminating dot).
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the CreateOrUpdate operation.
  var path_594011 = newJObject()
  var query_594012 = newJObject()
  var body_594013 = newJObject()
  add(path_594011, "resourceGroupName", newJString(resourceGroupName))
  add(query_594012, "api-version", newJString(apiVersion))
  add(path_594011, "subscriptionId", newJString(subscriptionId))
  add(path_594011, "zoneName", newJString(zoneName))
  if parameters != nil:
    body_594013 = parameters
  result = call_594010.call(path_594011, query_594012, nil, nil, body_594013)

var zonesCreateOrUpdate* = Call_ZonesCreateOrUpdate_593973(
    name: "zonesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/dnsZones/{zoneName}",
    validator: validate_ZonesCreateOrUpdate_593974, base: "",
    url: url_ZonesCreateOrUpdate_593975, schemes: {Scheme.Https})
type
  Call_ZonesGet_593962 = ref object of OpenApiRestCall_593424
proc url_ZonesGet_593964(protocol: Scheme; host: string; base: string; route: string;
                        path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "zoneName" in path, "`zoneName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Network/dnsZones/"),
               (kind: VariableSegment, value: "zoneName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ZonesGet_593963(path: JsonNode; query: JsonNode; header: JsonNode;
                             formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a DNS zone. Retrieves the zone properties, but not the record sets within the zone.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   zoneName: JString (required)
  ##           : The name of the DNS zone (without a terminating dot).
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_593965 = path.getOrDefault("resourceGroupName")
  valid_593965 = validateParameter(valid_593965, JString, required = true,
                                 default = nil)
  if valid_593965 != nil:
    section.add "resourceGroupName", valid_593965
  var valid_593966 = path.getOrDefault("subscriptionId")
  valid_593966 = validateParameter(valid_593966, JString, required = true,
                                 default = nil)
  if valid_593966 != nil:
    section.add "subscriptionId", valid_593966
  var valid_593967 = path.getOrDefault("zoneName")
  valid_593967 = validateParameter(valid_593967, JString, required = true,
                                 default = nil)
  if valid_593967 != nil:
    section.add "zoneName", valid_593967
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593968 = query.getOrDefault("api-version")
  valid_593968 = validateParameter(valid_593968, JString, required = true,
                                 default = nil)
  if valid_593968 != nil:
    section.add "api-version", valid_593968
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593969: Call_ZonesGet_593962; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a DNS zone. Retrieves the zone properties, but not the record sets within the zone.
  ## 
  let valid = call_593969.validator(path, query, header, formData, body)
  let scheme = call_593969.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593969.url(scheme.get, call_593969.host, call_593969.base,
                         call_593969.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593969, url, valid)

proc call*(call_593970: Call_ZonesGet_593962; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; zoneName: string): Recallable =
  ## zonesGet
  ## Gets a DNS zone. Retrieves the zone properties, but not the record sets within the zone.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   zoneName: string (required)
  ##           : The name of the DNS zone (without a terminating dot).
  var path_593971 = newJObject()
  var query_593972 = newJObject()
  add(path_593971, "resourceGroupName", newJString(resourceGroupName))
  add(query_593972, "api-version", newJString(apiVersion))
  add(path_593971, "subscriptionId", newJString(subscriptionId))
  add(path_593971, "zoneName", newJString(zoneName))
  result = call_593970.call(path_593971, query_593972, nil, nil, nil)

var zonesGet* = Call_ZonesGet_593962(name: "zonesGet", meth: HttpMethod.HttpGet,
                                  host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/dnsZones/{zoneName}",
                                  validator: validate_ZonesGet_593963, base: "",
                                  url: url_ZonesGet_593964,
                                  schemes: {Scheme.Https})
type
  Call_ZonesUpdate_594026 = ref object of OpenApiRestCall_593424
proc url_ZonesUpdate_594028(protocol: Scheme; host: string; base: string;
                           route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "zoneName" in path, "`zoneName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Network/dnsZones/"),
               (kind: VariableSegment, value: "zoneName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ZonesUpdate_594027(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates a DNS zone. Does not modify DNS records within the zone.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   zoneName: JString (required)
  ##           : The name of the DNS zone (without a terminating dot).
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
  var valid_594031 = path.getOrDefault("zoneName")
  valid_594031 = validateParameter(valid_594031, JString, required = true,
                                 default = nil)
  if valid_594031 != nil:
    section.add "zoneName", valid_594031
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
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
  ##           : The etag of the DNS zone. Omit this value to always overwrite the current zone. Specify the last-seen etag value to prevent accidentally overwriting any concurrent changes.
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

proc call*(call_594035: Call_ZonesUpdate_594026; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a DNS zone. Does not modify DNS records within the zone.
  ## 
  let valid = call_594035.validator(path, query, header, formData, body)
  let scheme = call_594035.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594035.url(scheme.get, call_594035.host, call_594035.base,
                         call_594035.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594035, url, valid)

proc call*(call_594036: Call_ZonesUpdate_594026; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; zoneName: string;
          parameters: JsonNode): Recallable =
  ## zonesUpdate
  ## Updates a DNS zone. Does not modify DNS records within the zone.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   zoneName: string (required)
  ##           : The name of the DNS zone (without a terminating dot).
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the Update operation.
  var path_594037 = newJObject()
  var query_594038 = newJObject()
  var body_594039 = newJObject()
  add(path_594037, "resourceGroupName", newJString(resourceGroupName))
  add(query_594038, "api-version", newJString(apiVersion))
  add(path_594037, "subscriptionId", newJString(subscriptionId))
  add(path_594037, "zoneName", newJString(zoneName))
  if parameters != nil:
    body_594039 = parameters
  result = call_594036.call(path_594037, query_594038, nil, nil, body_594039)

var zonesUpdate* = Call_ZonesUpdate_594026(name: "zonesUpdate",
                                        meth: HttpMethod.HttpPatch,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/dnsZones/{zoneName}",
                                        validator: validate_ZonesUpdate_594027,
                                        base: "", url: url_ZonesUpdate_594028,
                                        schemes: {Scheme.Https})
type
  Call_ZonesDelete_594014 = ref object of OpenApiRestCall_593424
proc url_ZonesDelete_594016(protocol: Scheme; host: string; base: string;
                           route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "zoneName" in path, "`zoneName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Network/dnsZones/"),
               (kind: VariableSegment, value: "zoneName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ZonesDelete_594015(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a DNS zone. WARNING: All DNS records in the zone will also be deleted. This operation cannot be undone.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   zoneName: JString (required)
  ##           : The name of the DNS zone (without a terminating dot).
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
  var valid_594019 = path.getOrDefault("zoneName")
  valid_594019 = validateParameter(valid_594019, JString, required = true,
                                 default = nil)
  if valid_594019 != nil:
    section.add "zoneName", valid_594019
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
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
  ##           : The etag of the DNS zone. Omit this value to always delete the current zone. Specify the last-seen etag value to prevent accidentally deleting any concurrent changes.
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

proc call*(call_594022: Call_ZonesDelete_594014; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a DNS zone. WARNING: All DNS records in the zone will also be deleted. This operation cannot be undone.
  ## 
  let valid = call_594022.validator(path, query, header, formData, body)
  let scheme = call_594022.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594022.url(scheme.get, call_594022.host, call_594022.base,
                         call_594022.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594022, url, valid)

proc call*(call_594023: Call_ZonesDelete_594014; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; zoneName: string): Recallable =
  ## zonesDelete
  ## Deletes a DNS zone. WARNING: All DNS records in the zone will also be deleted. This operation cannot be undone.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   zoneName: string (required)
  ##           : The name of the DNS zone (without a terminating dot).
  var path_594024 = newJObject()
  var query_594025 = newJObject()
  add(path_594024, "resourceGroupName", newJString(resourceGroupName))
  add(query_594025, "api-version", newJString(apiVersion))
  add(path_594024, "subscriptionId", newJString(subscriptionId))
  add(path_594024, "zoneName", newJString(zoneName))
  result = call_594023.call(path_594024, query_594025, nil, nil, nil)

var zonesDelete* = Call_ZonesDelete_594014(name: "zonesDelete",
                                        meth: HttpMethod.HttpDelete,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/dnsZones/{zoneName}",
                                        validator: validate_ZonesDelete_594015,
                                        base: "", url: url_ZonesDelete_594016,
                                        schemes: {Scheme.Https})
type
  Call_RecordSetsListAllByDnsZone_594040 = ref object of OpenApiRestCall_593424
proc url_RecordSetsListAllByDnsZone_594042(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "zoneName" in path, "`zoneName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Network/dnsZones/"),
               (kind: VariableSegment, value: "zoneName"),
               (kind: ConstantSegment, value: "/all")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RecordSetsListAllByDnsZone_594041(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all record sets in a DNS zone.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   zoneName: JString (required)
  ##           : The name of the DNS zone (without a terminating dot).
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
  var valid_594045 = path.getOrDefault("zoneName")
  valid_594045 = validateParameter(valid_594045, JString, required = true,
                                 default = nil)
  if valid_594045 != nil:
    section.add "zoneName", valid_594045
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  ##   $recordsetnamesuffix: JString
  ##                       : The suffix label of the record set name that has to be used to filter the record set enumerations. If this parameter is specified, Enumeration will return only records that end with .<recordSetNameSuffix>
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

proc call*(call_594049: Call_RecordSetsListAllByDnsZone_594040; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all record sets in a DNS zone.
  ## 
  let valid = call_594049.validator(path, query, header, formData, body)
  let scheme = call_594049.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594049.url(scheme.get, call_594049.host, call_594049.base,
                         call_594049.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594049, url, valid)

proc call*(call_594050: Call_RecordSetsListAllByDnsZone_594040;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          zoneName: string; Recordsetnamesuffix: string = ""; Top: int = 0): Recallable =
  ## recordSetsListAllByDnsZone
  ## Lists all record sets in a DNS zone.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   Recordsetnamesuffix: string
  ##                      : The suffix label of the record set name that has to be used to filter the record set enumerations. If this parameter is specified, Enumeration will return only records that end with .<recordSetNameSuffix>
  ##   Top: int
  ##      : The maximum number of record sets to return. If not specified, returns up to 100 record sets.
  ##   zoneName: string (required)
  ##           : The name of the DNS zone (without a terminating dot).
  var path_594051 = newJObject()
  var query_594052 = newJObject()
  add(path_594051, "resourceGroupName", newJString(resourceGroupName))
  add(query_594052, "api-version", newJString(apiVersion))
  add(path_594051, "subscriptionId", newJString(subscriptionId))
  add(query_594052, "$recordsetnamesuffix", newJString(Recordsetnamesuffix))
  add(query_594052, "$top", newJInt(Top))
  add(path_594051, "zoneName", newJString(zoneName))
  result = call_594050.call(path_594051, query_594052, nil, nil, nil)

var recordSetsListAllByDnsZone* = Call_RecordSetsListAllByDnsZone_594040(
    name: "recordSetsListAllByDnsZone", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/dnsZones/{zoneName}/all",
    validator: validate_RecordSetsListAllByDnsZone_594041, base: "",
    url: url_RecordSetsListAllByDnsZone_594042, schemes: {Scheme.Https})
type
  Call_RecordSetsListByDnsZone_594053 = ref object of OpenApiRestCall_593424
proc url_RecordSetsListByDnsZone_594055(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "zoneName" in path, "`zoneName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Network/dnsZones/"),
               (kind: VariableSegment, value: "zoneName"),
               (kind: ConstantSegment, value: "/recordsets")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RecordSetsListByDnsZone_594054(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all record sets in a DNS zone.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   zoneName: JString (required)
  ##           : The name of the DNS zone (without a terminating dot).
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
  var valid_594058 = path.getOrDefault("zoneName")
  valid_594058 = validateParameter(valid_594058, JString, required = true,
                                 default = nil)
  if valid_594058 != nil:
    section.add "zoneName", valid_594058
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  ##   $recordsetnamesuffix: JString
  ##                       : The suffix label of the record set name that has to be used to filter the record set enumerations. If this parameter is specified, Enumeration will return only records that end with .<recordSetNameSuffix>
  ##   $top: JInt
  ##       : The maximum number of record sets to return. If not specified, returns up to 100 record sets.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594059 = query.getOrDefault("api-version")
  valid_594059 = validateParameter(valid_594059, JString, required = true,
                                 default = nil)
  if valid_594059 != nil:
    section.add "api-version", valid_594059
  var valid_594060 = query.getOrDefault("$recordsetnamesuffix")
  valid_594060 = validateParameter(valid_594060, JString, required = false,
                                 default = nil)
  if valid_594060 != nil:
    section.add "$recordsetnamesuffix", valid_594060
  var valid_594061 = query.getOrDefault("$top")
  valid_594061 = validateParameter(valid_594061, JInt, required = false, default = nil)
  if valid_594061 != nil:
    section.add "$top", valid_594061
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594062: Call_RecordSetsListByDnsZone_594053; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all record sets in a DNS zone.
  ## 
  let valid = call_594062.validator(path, query, header, formData, body)
  let scheme = call_594062.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594062.url(scheme.get, call_594062.host, call_594062.base,
                         call_594062.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594062, url, valid)

proc call*(call_594063: Call_RecordSetsListByDnsZone_594053;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          zoneName: string; Recordsetnamesuffix: string = ""; Top: int = 0): Recallable =
  ## recordSetsListByDnsZone
  ## Lists all record sets in a DNS zone.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   Recordsetnamesuffix: string
  ##                      : The suffix label of the record set name that has to be used to filter the record set enumerations. If this parameter is specified, Enumeration will return only records that end with .<recordSetNameSuffix>
  ##   Top: int
  ##      : The maximum number of record sets to return. If not specified, returns up to 100 record sets.
  ##   zoneName: string (required)
  ##           : The name of the DNS zone (without a terminating dot).
  var path_594064 = newJObject()
  var query_594065 = newJObject()
  add(path_594064, "resourceGroupName", newJString(resourceGroupName))
  add(query_594065, "api-version", newJString(apiVersion))
  add(path_594064, "subscriptionId", newJString(subscriptionId))
  add(query_594065, "$recordsetnamesuffix", newJString(Recordsetnamesuffix))
  add(query_594065, "$top", newJInt(Top))
  add(path_594064, "zoneName", newJString(zoneName))
  result = call_594063.call(path_594064, query_594065, nil, nil, nil)

var recordSetsListByDnsZone* = Call_RecordSetsListByDnsZone_594053(
    name: "recordSetsListByDnsZone", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/dnsZones/{zoneName}/recordsets",
    validator: validate_RecordSetsListByDnsZone_594054, base: "",
    url: url_RecordSetsListByDnsZone_594055, schemes: {Scheme.Https})
type
  Call_RecordSetsListByType_594066 = ref object of OpenApiRestCall_593424
proc url_RecordSetsListByType_594068(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "zoneName" in path, "`zoneName` is a required path parameter"
  assert "recordType" in path, "`recordType` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Network/dnsZones/"),
               (kind: VariableSegment, value: "zoneName"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "recordType")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RecordSetsListByType_594067(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the record sets of a specified type in a DNS zone.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   recordType: JString (required)
  ##             : The type of record sets to enumerate.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   zoneName: JString (required)
  ##           : The name of the DNS zone (without a terminating dot).
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594069 = path.getOrDefault("resourceGroupName")
  valid_594069 = validateParameter(valid_594069, JString, required = true,
                                 default = nil)
  if valid_594069 != nil:
    section.add "resourceGroupName", valid_594069
  var valid_594083 = path.getOrDefault("recordType")
  valid_594083 = validateParameter(valid_594083, JString, required = true,
                                 default = newJString("A"))
  if valid_594083 != nil:
    section.add "recordType", valid_594083
  var valid_594084 = path.getOrDefault("subscriptionId")
  valid_594084 = validateParameter(valid_594084, JString, required = true,
                                 default = nil)
  if valid_594084 != nil:
    section.add "subscriptionId", valid_594084
  var valid_594085 = path.getOrDefault("zoneName")
  valid_594085 = validateParameter(valid_594085, JString, required = true,
                                 default = nil)
  if valid_594085 != nil:
    section.add "zoneName", valid_594085
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  ##   $recordsetnamesuffix: JString
  ##                       : The suffix label of the record set name that has to be used to filter the record set enumerations. If this parameter is specified, Enumeration will return only records that end with .<recordSetNameSuffix>
  ##   $top: JInt
  ##       : The maximum number of record sets to return. If not specified, returns up to 100 record sets.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594086 = query.getOrDefault("api-version")
  valid_594086 = validateParameter(valid_594086, JString, required = true,
                                 default = nil)
  if valid_594086 != nil:
    section.add "api-version", valid_594086
  var valid_594087 = query.getOrDefault("$recordsetnamesuffix")
  valid_594087 = validateParameter(valid_594087, JString, required = false,
                                 default = nil)
  if valid_594087 != nil:
    section.add "$recordsetnamesuffix", valid_594087
  var valid_594088 = query.getOrDefault("$top")
  valid_594088 = validateParameter(valid_594088, JInt, required = false, default = nil)
  if valid_594088 != nil:
    section.add "$top", valid_594088
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594089: Call_RecordSetsListByType_594066; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the record sets of a specified type in a DNS zone.
  ## 
  let valid = call_594089.validator(path, query, header, formData, body)
  let scheme = call_594089.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594089.url(scheme.get, call_594089.host, call_594089.base,
                         call_594089.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594089, url, valid)

proc call*(call_594090: Call_RecordSetsListByType_594066;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          zoneName: string; recordType: string = "A";
          Recordsetnamesuffix: string = ""; Top: int = 0): Recallable =
  ## recordSetsListByType
  ## Lists the record sets of a specified type in a DNS zone.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   recordType: string (required)
  ##             : The type of record sets to enumerate.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   Recordsetnamesuffix: string
  ##                      : The suffix label of the record set name that has to be used to filter the record set enumerations. If this parameter is specified, Enumeration will return only records that end with .<recordSetNameSuffix>
  ##   Top: int
  ##      : The maximum number of record sets to return. If not specified, returns up to 100 record sets.
  ##   zoneName: string (required)
  ##           : The name of the DNS zone (without a terminating dot).
  var path_594091 = newJObject()
  var query_594092 = newJObject()
  add(path_594091, "resourceGroupName", newJString(resourceGroupName))
  add(query_594092, "api-version", newJString(apiVersion))
  add(path_594091, "recordType", newJString(recordType))
  add(path_594091, "subscriptionId", newJString(subscriptionId))
  add(query_594092, "$recordsetnamesuffix", newJString(Recordsetnamesuffix))
  add(query_594092, "$top", newJInt(Top))
  add(path_594091, "zoneName", newJString(zoneName))
  result = call_594090.call(path_594091, query_594092, nil, nil, nil)

var recordSetsListByType* = Call_RecordSetsListByType_594066(
    name: "recordSetsListByType", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/dnsZones/{zoneName}/{recordType}",
    validator: validate_RecordSetsListByType_594067, base: "",
    url: url_RecordSetsListByType_594068, schemes: {Scheme.Https})
type
  Call_RecordSetsCreateOrUpdate_594106 = ref object of OpenApiRestCall_593424
proc url_RecordSetsCreateOrUpdate_594108(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "zoneName" in path, "`zoneName` is a required path parameter"
  assert "recordType" in path, "`recordType` is a required path parameter"
  assert "relativeRecordSetName" in path,
        "`relativeRecordSetName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Network/dnsZones/"),
               (kind: VariableSegment, value: "zoneName"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "recordType"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "relativeRecordSetName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RecordSetsCreateOrUpdate_594107(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates a record set within a DNS zone.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   recordType: JString (required)
  ##             : The type of DNS record in this record set. Record sets of type SOA can be updated but not created (they are created when the DNS zone is created).
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   zoneName: JString (required)
  ##           : The name of the DNS zone (without a terminating dot).
  ##   relativeRecordSetName: JString (required)
  ##                        : The name of the record set, relative to the name of the zone.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594109 = path.getOrDefault("resourceGroupName")
  valid_594109 = validateParameter(valid_594109, JString, required = true,
                                 default = nil)
  if valid_594109 != nil:
    section.add "resourceGroupName", valid_594109
  var valid_594110 = path.getOrDefault("recordType")
  valid_594110 = validateParameter(valid_594110, JString, required = true,
                                 default = newJString("A"))
  if valid_594110 != nil:
    section.add "recordType", valid_594110
  var valid_594111 = path.getOrDefault("subscriptionId")
  valid_594111 = validateParameter(valid_594111, JString, required = true,
                                 default = nil)
  if valid_594111 != nil:
    section.add "subscriptionId", valid_594111
  var valid_594112 = path.getOrDefault("zoneName")
  valid_594112 = validateParameter(valid_594112, JString, required = true,
                                 default = nil)
  if valid_594112 != nil:
    section.add "zoneName", valid_594112
  var valid_594113 = path.getOrDefault("relativeRecordSetName")
  valid_594113 = validateParameter(valid_594113, JString, required = true,
                                 default = nil)
  if valid_594113 != nil:
    section.add "relativeRecordSetName", valid_594113
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594114 = query.getOrDefault("api-version")
  valid_594114 = validateParameter(valid_594114, JString, required = true,
                                 default = nil)
  if valid_594114 != nil:
    section.add "api-version", valid_594114
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : The etag of the record set. Omit this value to always overwrite the current record set. Specify the last-seen etag value to prevent accidentally overwriting any concurrent changes.
  ##   If-None-Match: JString
  ##                : Set to '*' to allow a new record set to be created, but to prevent updating an existing record set. Other values will be ignored.
  section = newJObject()
  var valid_594115 = header.getOrDefault("If-Match")
  valid_594115 = validateParameter(valid_594115, JString, required = false,
                                 default = nil)
  if valid_594115 != nil:
    section.add "If-Match", valid_594115
  var valid_594116 = header.getOrDefault("If-None-Match")
  valid_594116 = validateParameter(valid_594116, JString, required = false,
                                 default = nil)
  if valid_594116 != nil:
    section.add "If-None-Match", valid_594116
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

proc call*(call_594118: Call_RecordSetsCreateOrUpdate_594106; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates a record set within a DNS zone.
  ## 
  let valid = call_594118.validator(path, query, header, formData, body)
  let scheme = call_594118.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594118.url(scheme.get, call_594118.host, call_594118.base,
                         call_594118.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594118, url, valid)

proc call*(call_594119: Call_RecordSetsCreateOrUpdate_594106;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          zoneName: string; parameters: JsonNode; relativeRecordSetName: string;
          recordType: string = "A"): Recallable =
  ## recordSetsCreateOrUpdate
  ## Creates or updates a record set within a DNS zone.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   recordType: string (required)
  ##             : The type of DNS record in this record set. Record sets of type SOA can be updated but not created (they are created when the DNS zone is created).
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   zoneName: string (required)
  ##           : The name of the DNS zone (without a terminating dot).
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the CreateOrUpdate operation.
  ##   relativeRecordSetName: string (required)
  ##                        : The name of the record set, relative to the name of the zone.
  var path_594120 = newJObject()
  var query_594121 = newJObject()
  var body_594122 = newJObject()
  add(path_594120, "resourceGroupName", newJString(resourceGroupName))
  add(query_594121, "api-version", newJString(apiVersion))
  add(path_594120, "recordType", newJString(recordType))
  add(path_594120, "subscriptionId", newJString(subscriptionId))
  add(path_594120, "zoneName", newJString(zoneName))
  if parameters != nil:
    body_594122 = parameters
  add(path_594120, "relativeRecordSetName", newJString(relativeRecordSetName))
  result = call_594119.call(path_594120, query_594121, nil, nil, body_594122)

var recordSetsCreateOrUpdate* = Call_RecordSetsCreateOrUpdate_594106(
    name: "recordSetsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/dnsZones/{zoneName}/{recordType}/{relativeRecordSetName}",
    validator: validate_RecordSetsCreateOrUpdate_594107, base: "",
    url: url_RecordSetsCreateOrUpdate_594108, schemes: {Scheme.Https})
type
  Call_RecordSetsGet_594093 = ref object of OpenApiRestCall_593424
proc url_RecordSetsGet_594095(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "zoneName" in path, "`zoneName` is a required path parameter"
  assert "recordType" in path, "`recordType` is a required path parameter"
  assert "relativeRecordSetName" in path,
        "`relativeRecordSetName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Network/dnsZones/"),
               (kind: VariableSegment, value: "zoneName"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "recordType"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "relativeRecordSetName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RecordSetsGet_594094(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a record set.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   recordType: JString (required)
  ##             : The type of DNS record in this record set.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   zoneName: JString (required)
  ##           : The name of the DNS zone (without a terminating dot).
  ##   relativeRecordSetName: JString (required)
  ##                        : The name of the record set, relative to the name of the zone.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594096 = path.getOrDefault("resourceGroupName")
  valid_594096 = validateParameter(valid_594096, JString, required = true,
                                 default = nil)
  if valid_594096 != nil:
    section.add "resourceGroupName", valid_594096
  var valid_594097 = path.getOrDefault("recordType")
  valid_594097 = validateParameter(valid_594097, JString, required = true,
                                 default = newJString("A"))
  if valid_594097 != nil:
    section.add "recordType", valid_594097
  var valid_594098 = path.getOrDefault("subscriptionId")
  valid_594098 = validateParameter(valid_594098, JString, required = true,
                                 default = nil)
  if valid_594098 != nil:
    section.add "subscriptionId", valid_594098
  var valid_594099 = path.getOrDefault("zoneName")
  valid_594099 = validateParameter(valid_594099, JString, required = true,
                                 default = nil)
  if valid_594099 != nil:
    section.add "zoneName", valid_594099
  var valid_594100 = path.getOrDefault("relativeRecordSetName")
  valid_594100 = validateParameter(valid_594100, JString, required = true,
                                 default = nil)
  if valid_594100 != nil:
    section.add "relativeRecordSetName", valid_594100
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594101 = query.getOrDefault("api-version")
  valid_594101 = validateParameter(valid_594101, JString, required = true,
                                 default = nil)
  if valid_594101 != nil:
    section.add "api-version", valid_594101
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594102: Call_RecordSetsGet_594093; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a record set.
  ## 
  let valid = call_594102.validator(path, query, header, formData, body)
  let scheme = call_594102.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594102.url(scheme.get, call_594102.host, call_594102.base,
                         call_594102.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594102, url, valid)

proc call*(call_594103: Call_RecordSetsGet_594093; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; zoneName: string;
          relativeRecordSetName: string; recordType: string = "A"): Recallable =
  ## recordSetsGet
  ## Gets a record set.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   recordType: string (required)
  ##             : The type of DNS record in this record set.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   zoneName: string (required)
  ##           : The name of the DNS zone (without a terminating dot).
  ##   relativeRecordSetName: string (required)
  ##                        : The name of the record set, relative to the name of the zone.
  var path_594104 = newJObject()
  var query_594105 = newJObject()
  add(path_594104, "resourceGroupName", newJString(resourceGroupName))
  add(query_594105, "api-version", newJString(apiVersion))
  add(path_594104, "recordType", newJString(recordType))
  add(path_594104, "subscriptionId", newJString(subscriptionId))
  add(path_594104, "zoneName", newJString(zoneName))
  add(path_594104, "relativeRecordSetName", newJString(relativeRecordSetName))
  result = call_594103.call(path_594104, query_594105, nil, nil, nil)

var recordSetsGet* = Call_RecordSetsGet_594093(name: "recordSetsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/dnsZones/{zoneName}/{recordType}/{relativeRecordSetName}",
    validator: validate_RecordSetsGet_594094, base: "", url: url_RecordSetsGet_594095,
    schemes: {Scheme.Https})
type
  Call_RecordSetsUpdate_594137 = ref object of OpenApiRestCall_593424
proc url_RecordSetsUpdate_594139(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "zoneName" in path, "`zoneName` is a required path parameter"
  assert "recordType" in path, "`recordType` is a required path parameter"
  assert "relativeRecordSetName" in path,
        "`relativeRecordSetName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Network/dnsZones/"),
               (kind: VariableSegment, value: "zoneName"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "recordType"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "relativeRecordSetName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RecordSetsUpdate_594138(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Updates a record set within a DNS zone.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   recordType: JString (required)
  ##             : The type of DNS record in this record set.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   zoneName: JString (required)
  ##           : The name of the DNS zone (without a terminating dot).
  ##   relativeRecordSetName: JString (required)
  ##                        : The name of the record set, relative to the name of the zone.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594140 = path.getOrDefault("resourceGroupName")
  valid_594140 = validateParameter(valid_594140, JString, required = true,
                                 default = nil)
  if valid_594140 != nil:
    section.add "resourceGroupName", valid_594140
  var valid_594141 = path.getOrDefault("recordType")
  valid_594141 = validateParameter(valid_594141, JString, required = true,
                                 default = newJString("A"))
  if valid_594141 != nil:
    section.add "recordType", valid_594141
  var valid_594142 = path.getOrDefault("subscriptionId")
  valid_594142 = validateParameter(valid_594142, JString, required = true,
                                 default = nil)
  if valid_594142 != nil:
    section.add "subscriptionId", valid_594142
  var valid_594143 = path.getOrDefault("zoneName")
  valid_594143 = validateParameter(valid_594143, JString, required = true,
                                 default = nil)
  if valid_594143 != nil:
    section.add "zoneName", valid_594143
  var valid_594144 = path.getOrDefault("relativeRecordSetName")
  valid_594144 = validateParameter(valid_594144, JString, required = true,
                                 default = nil)
  if valid_594144 != nil:
    section.add "relativeRecordSetName", valid_594144
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594145 = query.getOrDefault("api-version")
  valid_594145 = validateParameter(valid_594145, JString, required = true,
                                 default = nil)
  if valid_594145 != nil:
    section.add "api-version", valid_594145
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : The etag of the record set. Omit this value to always overwrite the current record set. Specify the last-seen etag value to prevent accidentally overwriting concurrent changes.
  section = newJObject()
  var valid_594146 = header.getOrDefault("If-Match")
  valid_594146 = validateParameter(valid_594146, JString, required = false,
                                 default = nil)
  if valid_594146 != nil:
    section.add "If-Match", valid_594146
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

proc call*(call_594148: Call_RecordSetsUpdate_594137; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a record set within a DNS zone.
  ## 
  let valid = call_594148.validator(path, query, header, formData, body)
  let scheme = call_594148.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594148.url(scheme.get, call_594148.host, call_594148.base,
                         call_594148.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594148, url, valid)

proc call*(call_594149: Call_RecordSetsUpdate_594137; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; zoneName: string;
          parameters: JsonNode; relativeRecordSetName: string;
          recordType: string = "A"): Recallable =
  ## recordSetsUpdate
  ## Updates a record set within a DNS zone.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   recordType: string (required)
  ##             : The type of DNS record in this record set.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   zoneName: string (required)
  ##           : The name of the DNS zone (without a terminating dot).
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the Update operation.
  ##   relativeRecordSetName: string (required)
  ##                        : The name of the record set, relative to the name of the zone.
  var path_594150 = newJObject()
  var query_594151 = newJObject()
  var body_594152 = newJObject()
  add(path_594150, "resourceGroupName", newJString(resourceGroupName))
  add(query_594151, "api-version", newJString(apiVersion))
  add(path_594150, "recordType", newJString(recordType))
  add(path_594150, "subscriptionId", newJString(subscriptionId))
  add(path_594150, "zoneName", newJString(zoneName))
  if parameters != nil:
    body_594152 = parameters
  add(path_594150, "relativeRecordSetName", newJString(relativeRecordSetName))
  result = call_594149.call(path_594150, query_594151, nil, nil, body_594152)

var recordSetsUpdate* = Call_RecordSetsUpdate_594137(name: "recordSetsUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/dnsZones/{zoneName}/{recordType}/{relativeRecordSetName}",
    validator: validate_RecordSetsUpdate_594138, base: "",
    url: url_RecordSetsUpdate_594139, schemes: {Scheme.Https})
type
  Call_RecordSetsDelete_594123 = ref object of OpenApiRestCall_593424
proc url_RecordSetsDelete_594125(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "zoneName" in path, "`zoneName` is a required path parameter"
  assert "recordType" in path, "`recordType` is a required path parameter"
  assert "relativeRecordSetName" in path,
        "`relativeRecordSetName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Network/dnsZones/"),
               (kind: VariableSegment, value: "zoneName"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "recordType"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "relativeRecordSetName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RecordSetsDelete_594124(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Deletes a record set from a DNS zone. This operation cannot be undone.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   recordType: JString (required)
  ##             : The type of DNS record in this record set. Record sets of type SOA cannot be deleted (they are deleted when the DNS zone is deleted).
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   zoneName: JString (required)
  ##           : The name of the DNS zone (without a terminating dot).
  ##   relativeRecordSetName: JString (required)
  ##                        : The name of the record set, relative to the name of the zone.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594126 = path.getOrDefault("resourceGroupName")
  valid_594126 = validateParameter(valid_594126, JString, required = true,
                                 default = nil)
  if valid_594126 != nil:
    section.add "resourceGroupName", valid_594126
  var valid_594127 = path.getOrDefault("recordType")
  valid_594127 = validateParameter(valid_594127, JString, required = true,
                                 default = newJString("A"))
  if valid_594127 != nil:
    section.add "recordType", valid_594127
  var valid_594128 = path.getOrDefault("subscriptionId")
  valid_594128 = validateParameter(valid_594128, JString, required = true,
                                 default = nil)
  if valid_594128 != nil:
    section.add "subscriptionId", valid_594128
  var valid_594129 = path.getOrDefault("zoneName")
  valid_594129 = validateParameter(valid_594129, JString, required = true,
                                 default = nil)
  if valid_594129 != nil:
    section.add "zoneName", valid_594129
  var valid_594130 = path.getOrDefault("relativeRecordSetName")
  valid_594130 = validateParameter(valid_594130, JString, required = true,
                                 default = nil)
  if valid_594130 != nil:
    section.add "relativeRecordSetName", valid_594130
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594131 = query.getOrDefault("api-version")
  valid_594131 = validateParameter(valid_594131, JString, required = true,
                                 default = nil)
  if valid_594131 != nil:
    section.add "api-version", valid_594131
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : The etag of the record set. Omit this value to always delete the current record set. Specify the last-seen etag value to prevent accidentally deleting any concurrent changes.
  section = newJObject()
  var valid_594132 = header.getOrDefault("If-Match")
  valid_594132 = validateParameter(valid_594132, JString, required = false,
                                 default = nil)
  if valid_594132 != nil:
    section.add "If-Match", valid_594132
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594133: Call_RecordSetsDelete_594123; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a record set from a DNS zone. This operation cannot be undone.
  ## 
  let valid = call_594133.validator(path, query, header, formData, body)
  let scheme = call_594133.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594133.url(scheme.get, call_594133.host, call_594133.base,
                         call_594133.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594133, url, valid)

proc call*(call_594134: Call_RecordSetsDelete_594123; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; zoneName: string;
          relativeRecordSetName: string; recordType: string = "A"): Recallable =
  ## recordSetsDelete
  ## Deletes a record set from a DNS zone. This operation cannot be undone.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   recordType: string (required)
  ##             : The type of DNS record in this record set. Record sets of type SOA cannot be deleted (they are deleted when the DNS zone is deleted).
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   zoneName: string (required)
  ##           : The name of the DNS zone (without a terminating dot).
  ##   relativeRecordSetName: string (required)
  ##                        : The name of the record set, relative to the name of the zone.
  var path_594135 = newJObject()
  var query_594136 = newJObject()
  add(path_594135, "resourceGroupName", newJString(resourceGroupName))
  add(query_594136, "api-version", newJString(apiVersion))
  add(path_594135, "recordType", newJString(recordType))
  add(path_594135, "subscriptionId", newJString(subscriptionId))
  add(path_594135, "zoneName", newJString(zoneName))
  add(path_594135, "relativeRecordSetName", newJString(relativeRecordSetName))
  result = call_594134.call(path_594135, query_594136, nil, nil, nil)

var recordSetsDelete* = Call_RecordSetsDelete_594123(name: "recordSetsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/dnsZones/{zoneName}/{recordType}/{relativeRecordSetName}",
    validator: validate_RecordSetsDelete_594124, base: "",
    url: url_RecordSetsDelete_594125, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
