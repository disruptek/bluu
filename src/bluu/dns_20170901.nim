
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: DnsManagementClient
## version: 2017-09-01
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
  macServiceName = "dns"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_ZonesList_567879 = ref object of OpenApiRestCall_567657
proc url_ZonesList_567881(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_ZonesList_567880(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_568042 = path.getOrDefault("subscriptionId")
  valid_568042 = validateParameter(valid_568042, JString, required = true,
                                 default = nil)
  if valid_568042 != nil:
    section.add "subscriptionId", valid_568042
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  ##   $top: JInt
  ##       : The maximum number of DNS zones to return. If not specified, returns up to 100 zones.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568043 = query.getOrDefault("api-version")
  valid_568043 = validateParameter(valid_568043, JString, required = true,
                                 default = nil)
  if valid_568043 != nil:
    section.add "api-version", valid_568043
  var valid_568044 = query.getOrDefault("$top")
  valid_568044 = validateParameter(valid_568044, JInt, required = false, default = nil)
  if valid_568044 != nil:
    section.add "$top", valid_568044
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568071: Call_ZonesList_567879; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the DNS zones in all resource groups in a subscription.
  ## 
  let valid = call_568071.validator(path, query, header, formData, body)
  let scheme = call_568071.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568071.url(scheme.get, call_568071.host, call_568071.base,
                         call_568071.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568071, url, valid)

proc call*(call_568142: Call_ZonesList_567879; apiVersion: string;
          subscriptionId: string; Top: int = 0): Recallable =
  ## zonesList
  ## Lists the DNS zones in all resource groups in a subscription.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   Top: int
  ##      : The maximum number of DNS zones to return. If not specified, returns up to 100 zones.
  var path_568143 = newJObject()
  var query_568145 = newJObject()
  add(query_568145, "api-version", newJString(apiVersion))
  add(path_568143, "subscriptionId", newJString(subscriptionId))
  add(query_568145, "$top", newJInt(Top))
  result = call_568142.call(path_568143, query_568145, nil, nil, nil)

var zonesList* = Call_ZonesList_567879(name: "zonesList", meth: HttpMethod.HttpGet,
                                    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Network/dnszones",
                                    validator: validate_ZonesList_567880,
                                    base: "", url: url_ZonesList_567881,
                                    schemes: {Scheme.Https})
type
  Call_ZonesListByResourceGroup_568184 = ref object of OpenApiRestCall_567657
proc url_ZonesListByResourceGroup_568186(protocol: Scheme; host: string;
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

proc validate_ZonesListByResourceGroup_568185(path: JsonNode; query: JsonNode;
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
  var valid_568187 = path.getOrDefault("resourceGroupName")
  valid_568187 = validateParameter(valid_568187, JString, required = true,
                                 default = nil)
  if valid_568187 != nil:
    section.add "resourceGroupName", valid_568187
  var valid_568188 = path.getOrDefault("subscriptionId")
  valid_568188 = validateParameter(valid_568188, JString, required = true,
                                 default = nil)
  if valid_568188 != nil:
    section.add "subscriptionId", valid_568188
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  ##   $top: JInt
  ##       : The maximum number of record sets to return. If not specified, returns up to 100 record sets.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568189 = query.getOrDefault("api-version")
  valid_568189 = validateParameter(valid_568189, JString, required = true,
                                 default = nil)
  if valid_568189 != nil:
    section.add "api-version", valid_568189
  var valid_568190 = query.getOrDefault("$top")
  valid_568190 = validateParameter(valid_568190, JInt, required = false, default = nil)
  if valid_568190 != nil:
    section.add "$top", valid_568190
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568191: Call_ZonesListByResourceGroup_568184; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the DNS zones within a resource group.
  ## 
  let valid = call_568191.validator(path, query, header, formData, body)
  let scheme = call_568191.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568191.url(scheme.get, call_568191.host, call_568191.base,
                         call_568191.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568191, url, valid)

proc call*(call_568192: Call_ZonesListByResourceGroup_568184;
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
  var path_568193 = newJObject()
  var query_568194 = newJObject()
  add(path_568193, "resourceGroupName", newJString(resourceGroupName))
  add(query_568194, "api-version", newJString(apiVersion))
  add(path_568193, "subscriptionId", newJString(subscriptionId))
  add(query_568194, "$top", newJInt(Top))
  result = call_568192.call(path_568193, query_568194, nil, nil, nil)

var zonesListByResourceGroup* = Call_ZonesListByResourceGroup_568184(
    name: "zonesListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/dnsZones",
    validator: validate_ZonesListByResourceGroup_568185, base: "",
    url: url_ZonesListByResourceGroup_568186, schemes: {Scheme.Https})
type
  Call_ZonesCreateOrUpdate_568206 = ref object of OpenApiRestCall_567657
proc url_ZonesCreateOrUpdate_568208(protocol: Scheme; host: string; base: string;
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

proc validate_ZonesCreateOrUpdate_568207(path: JsonNode; query: JsonNode;
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
  var valid_568237 = path.getOrDefault("zoneName")
  valid_568237 = validateParameter(valid_568237, JString, required = true,
                                 default = nil)
  if valid_568237 != nil:
    section.add "zoneName", valid_568237
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
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
  ##           : The etag of the DNS zone. Omit this value to always overwrite the current zone. Specify the last-seen etag value to prevent accidentally overwriting any concurrent changes.
  ##   If-None-Match: JString
  ##                : Set to '*' to allow a new DNS zone to be created, but to prevent updating an existing zone. Other values will be ignored.
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

proc call*(call_568242: Call_ZonesCreateOrUpdate_568206; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates a DNS zone. Does not modify DNS records within the zone.
  ## 
  let valid = call_568242.validator(path, query, header, formData, body)
  let scheme = call_568242.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568242.url(scheme.get, call_568242.host, call_568242.base,
                         call_568242.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568242, url, valid)

proc call*(call_568243: Call_ZonesCreateOrUpdate_568206; resourceGroupName: string;
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
  var path_568244 = newJObject()
  var query_568245 = newJObject()
  var body_568246 = newJObject()
  add(path_568244, "resourceGroupName", newJString(resourceGroupName))
  add(query_568245, "api-version", newJString(apiVersion))
  add(path_568244, "subscriptionId", newJString(subscriptionId))
  add(path_568244, "zoneName", newJString(zoneName))
  if parameters != nil:
    body_568246 = parameters
  result = call_568243.call(path_568244, query_568245, nil, nil, body_568246)

var zonesCreateOrUpdate* = Call_ZonesCreateOrUpdate_568206(
    name: "zonesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/dnsZones/{zoneName}",
    validator: validate_ZonesCreateOrUpdate_568207, base: "",
    url: url_ZonesCreateOrUpdate_568208, schemes: {Scheme.Https})
type
  Call_ZonesGet_568195 = ref object of OpenApiRestCall_567657
proc url_ZonesGet_568197(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_ZonesGet_568196(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_568198 = path.getOrDefault("resourceGroupName")
  valid_568198 = validateParameter(valid_568198, JString, required = true,
                                 default = nil)
  if valid_568198 != nil:
    section.add "resourceGroupName", valid_568198
  var valid_568199 = path.getOrDefault("subscriptionId")
  valid_568199 = validateParameter(valid_568199, JString, required = true,
                                 default = nil)
  if valid_568199 != nil:
    section.add "subscriptionId", valid_568199
  var valid_568200 = path.getOrDefault("zoneName")
  valid_568200 = validateParameter(valid_568200, JString, required = true,
                                 default = nil)
  if valid_568200 != nil:
    section.add "zoneName", valid_568200
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568201 = query.getOrDefault("api-version")
  valid_568201 = validateParameter(valid_568201, JString, required = true,
                                 default = nil)
  if valid_568201 != nil:
    section.add "api-version", valid_568201
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568202: Call_ZonesGet_568195; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a DNS zone. Retrieves the zone properties, but not the record sets within the zone.
  ## 
  let valid = call_568202.validator(path, query, header, formData, body)
  let scheme = call_568202.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568202.url(scheme.get, call_568202.host, call_568202.base,
                         call_568202.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568202, url, valid)

proc call*(call_568203: Call_ZonesGet_568195; resourceGroupName: string;
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
  var path_568204 = newJObject()
  var query_568205 = newJObject()
  add(path_568204, "resourceGroupName", newJString(resourceGroupName))
  add(query_568205, "api-version", newJString(apiVersion))
  add(path_568204, "subscriptionId", newJString(subscriptionId))
  add(path_568204, "zoneName", newJString(zoneName))
  result = call_568203.call(path_568204, query_568205, nil, nil, nil)

var zonesGet* = Call_ZonesGet_568195(name: "zonesGet", meth: HttpMethod.HttpGet,
                                  host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/dnsZones/{zoneName}",
                                  validator: validate_ZonesGet_568196, base: "",
                                  url: url_ZonesGet_568197,
                                  schemes: {Scheme.Https})
type
  Call_ZonesDelete_568247 = ref object of OpenApiRestCall_567657
proc url_ZonesDelete_568249(protocol: Scheme; host: string; base: string;
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

proc validate_ZonesDelete_568248(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_568252 = path.getOrDefault("zoneName")
  valid_568252 = validateParameter(valid_568252, JString, required = true,
                                 default = nil)
  if valid_568252 != nil:
    section.add "zoneName", valid_568252
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
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
  ##           : The etag of the DNS zone. Omit this value to always delete the current zone. Specify the last-seen etag value to prevent accidentally deleting any concurrent changes.
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

proc call*(call_568255: Call_ZonesDelete_568247; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a DNS zone. WARNING: All DNS records in the zone will also be deleted. This operation cannot be undone.
  ## 
  let valid = call_568255.validator(path, query, header, formData, body)
  let scheme = call_568255.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568255.url(scheme.get, call_568255.host, call_568255.base,
                         call_568255.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568255, url, valid)

proc call*(call_568256: Call_ZonesDelete_568247; resourceGroupName: string;
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
  var path_568257 = newJObject()
  var query_568258 = newJObject()
  add(path_568257, "resourceGroupName", newJString(resourceGroupName))
  add(query_568258, "api-version", newJString(apiVersion))
  add(path_568257, "subscriptionId", newJString(subscriptionId))
  add(path_568257, "zoneName", newJString(zoneName))
  result = call_568256.call(path_568257, query_568258, nil, nil, nil)

var zonesDelete* = Call_ZonesDelete_568247(name: "zonesDelete",
                                        meth: HttpMethod.HttpDelete,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/dnsZones/{zoneName}",
                                        validator: validate_ZonesDelete_568248,
                                        base: "", url: url_ZonesDelete_568249,
                                        schemes: {Scheme.Https})
type
  Call_RecordSetsListByDnsZone_568259 = ref object of OpenApiRestCall_567657
proc url_RecordSetsListByDnsZone_568261(protocol: Scheme; host: string; base: string;
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

proc validate_RecordSetsListByDnsZone_568260(path: JsonNode; query: JsonNode;
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
  var valid_568264 = path.getOrDefault("zoneName")
  valid_568264 = validateParameter(valid_568264, JString, required = true,
                                 default = nil)
  if valid_568264 != nil:
    section.add "zoneName", valid_568264
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
  var valid_568265 = query.getOrDefault("api-version")
  valid_568265 = validateParameter(valid_568265, JString, required = true,
                                 default = nil)
  if valid_568265 != nil:
    section.add "api-version", valid_568265
  var valid_568266 = query.getOrDefault("$recordsetnamesuffix")
  valid_568266 = validateParameter(valid_568266, JString, required = false,
                                 default = nil)
  if valid_568266 != nil:
    section.add "$recordsetnamesuffix", valid_568266
  var valid_568267 = query.getOrDefault("$top")
  valid_568267 = validateParameter(valid_568267, JInt, required = false, default = nil)
  if valid_568267 != nil:
    section.add "$top", valid_568267
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568268: Call_RecordSetsListByDnsZone_568259; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all record sets in a DNS zone.
  ## 
  let valid = call_568268.validator(path, query, header, formData, body)
  let scheme = call_568268.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568268.url(scheme.get, call_568268.host, call_568268.base,
                         call_568268.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568268, url, valid)

proc call*(call_568269: Call_RecordSetsListByDnsZone_568259;
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
  var path_568270 = newJObject()
  var query_568271 = newJObject()
  add(path_568270, "resourceGroupName", newJString(resourceGroupName))
  add(query_568271, "api-version", newJString(apiVersion))
  add(path_568270, "subscriptionId", newJString(subscriptionId))
  add(query_568271, "$recordsetnamesuffix", newJString(Recordsetnamesuffix))
  add(query_568271, "$top", newJInt(Top))
  add(path_568270, "zoneName", newJString(zoneName))
  result = call_568269.call(path_568270, query_568271, nil, nil, nil)

var recordSetsListByDnsZone* = Call_RecordSetsListByDnsZone_568259(
    name: "recordSetsListByDnsZone", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/dnsZones/{zoneName}/recordsets",
    validator: validate_RecordSetsListByDnsZone_568260, base: "",
    url: url_RecordSetsListByDnsZone_568261, schemes: {Scheme.Https})
type
  Call_RecordSetsListByType_568272 = ref object of OpenApiRestCall_567657
proc url_RecordSetsListByType_568274(protocol: Scheme; host: string; base: string;
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

proc validate_RecordSetsListByType_568273(path: JsonNode; query: JsonNode;
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
  var valid_568275 = path.getOrDefault("resourceGroupName")
  valid_568275 = validateParameter(valid_568275, JString, required = true,
                                 default = nil)
  if valid_568275 != nil:
    section.add "resourceGroupName", valid_568275
  var valid_568289 = path.getOrDefault("recordType")
  valid_568289 = validateParameter(valid_568289, JString, required = true,
                                 default = newJString("A"))
  if valid_568289 != nil:
    section.add "recordType", valid_568289
  var valid_568290 = path.getOrDefault("subscriptionId")
  valid_568290 = validateParameter(valid_568290, JString, required = true,
                                 default = nil)
  if valid_568290 != nil:
    section.add "subscriptionId", valid_568290
  var valid_568291 = path.getOrDefault("zoneName")
  valid_568291 = validateParameter(valid_568291, JString, required = true,
                                 default = nil)
  if valid_568291 != nil:
    section.add "zoneName", valid_568291
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
  var valid_568292 = query.getOrDefault("api-version")
  valid_568292 = validateParameter(valid_568292, JString, required = true,
                                 default = nil)
  if valid_568292 != nil:
    section.add "api-version", valid_568292
  var valid_568293 = query.getOrDefault("$recordsetnamesuffix")
  valid_568293 = validateParameter(valid_568293, JString, required = false,
                                 default = nil)
  if valid_568293 != nil:
    section.add "$recordsetnamesuffix", valid_568293
  var valid_568294 = query.getOrDefault("$top")
  valid_568294 = validateParameter(valid_568294, JInt, required = false, default = nil)
  if valid_568294 != nil:
    section.add "$top", valid_568294
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568295: Call_RecordSetsListByType_568272; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the record sets of a specified type in a DNS zone.
  ## 
  let valid = call_568295.validator(path, query, header, formData, body)
  let scheme = call_568295.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568295.url(scheme.get, call_568295.host, call_568295.base,
                         call_568295.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568295, url, valid)

proc call*(call_568296: Call_RecordSetsListByType_568272;
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
  var path_568297 = newJObject()
  var query_568298 = newJObject()
  add(path_568297, "resourceGroupName", newJString(resourceGroupName))
  add(query_568298, "api-version", newJString(apiVersion))
  add(path_568297, "recordType", newJString(recordType))
  add(path_568297, "subscriptionId", newJString(subscriptionId))
  add(query_568298, "$recordsetnamesuffix", newJString(Recordsetnamesuffix))
  add(query_568298, "$top", newJInt(Top))
  add(path_568297, "zoneName", newJString(zoneName))
  result = call_568296.call(path_568297, query_568298, nil, nil, nil)

var recordSetsListByType* = Call_RecordSetsListByType_568272(
    name: "recordSetsListByType", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/dnsZones/{zoneName}/{recordType}",
    validator: validate_RecordSetsListByType_568273, base: "",
    url: url_RecordSetsListByType_568274, schemes: {Scheme.Https})
type
  Call_RecordSetsCreateOrUpdate_568312 = ref object of OpenApiRestCall_567657
proc url_RecordSetsCreateOrUpdate_568314(protocol: Scheme; host: string;
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

proc validate_RecordSetsCreateOrUpdate_568313(path: JsonNode; query: JsonNode;
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
  var valid_568315 = path.getOrDefault("resourceGroupName")
  valid_568315 = validateParameter(valid_568315, JString, required = true,
                                 default = nil)
  if valid_568315 != nil:
    section.add "resourceGroupName", valid_568315
  var valid_568316 = path.getOrDefault("recordType")
  valid_568316 = validateParameter(valid_568316, JString, required = true,
                                 default = newJString("A"))
  if valid_568316 != nil:
    section.add "recordType", valid_568316
  var valid_568317 = path.getOrDefault("subscriptionId")
  valid_568317 = validateParameter(valid_568317, JString, required = true,
                                 default = nil)
  if valid_568317 != nil:
    section.add "subscriptionId", valid_568317
  var valid_568318 = path.getOrDefault("zoneName")
  valid_568318 = validateParameter(valid_568318, JString, required = true,
                                 default = nil)
  if valid_568318 != nil:
    section.add "zoneName", valid_568318
  var valid_568319 = path.getOrDefault("relativeRecordSetName")
  valid_568319 = validateParameter(valid_568319, JString, required = true,
                                 default = nil)
  if valid_568319 != nil:
    section.add "relativeRecordSetName", valid_568319
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568320 = query.getOrDefault("api-version")
  valid_568320 = validateParameter(valid_568320, JString, required = true,
                                 default = nil)
  if valid_568320 != nil:
    section.add "api-version", valid_568320
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : The etag of the record set. Omit this value to always overwrite the current record set. Specify the last-seen etag value to prevent accidentally overwriting any concurrent changes.
  ##   If-None-Match: JString
  ##                : Set to '*' to allow a new record set to be created, but to prevent updating an existing record set. Other values will be ignored.
  section = newJObject()
  var valid_568321 = header.getOrDefault("If-Match")
  valid_568321 = validateParameter(valid_568321, JString, required = false,
                                 default = nil)
  if valid_568321 != nil:
    section.add "If-Match", valid_568321
  var valid_568322 = header.getOrDefault("If-None-Match")
  valid_568322 = validateParameter(valid_568322, JString, required = false,
                                 default = nil)
  if valid_568322 != nil:
    section.add "If-None-Match", valid_568322
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

proc call*(call_568324: Call_RecordSetsCreateOrUpdate_568312; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates a record set within a DNS zone.
  ## 
  let valid = call_568324.validator(path, query, header, formData, body)
  let scheme = call_568324.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568324.url(scheme.get, call_568324.host, call_568324.base,
                         call_568324.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568324, url, valid)

proc call*(call_568325: Call_RecordSetsCreateOrUpdate_568312;
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
  var path_568326 = newJObject()
  var query_568327 = newJObject()
  var body_568328 = newJObject()
  add(path_568326, "resourceGroupName", newJString(resourceGroupName))
  add(query_568327, "api-version", newJString(apiVersion))
  add(path_568326, "recordType", newJString(recordType))
  add(path_568326, "subscriptionId", newJString(subscriptionId))
  add(path_568326, "zoneName", newJString(zoneName))
  if parameters != nil:
    body_568328 = parameters
  add(path_568326, "relativeRecordSetName", newJString(relativeRecordSetName))
  result = call_568325.call(path_568326, query_568327, nil, nil, body_568328)

var recordSetsCreateOrUpdate* = Call_RecordSetsCreateOrUpdate_568312(
    name: "recordSetsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/dnsZones/{zoneName}/{recordType}/{relativeRecordSetName}",
    validator: validate_RecordSetsCreateOrUpdate_568313, base: "",
    url: url_RecordSetsCreateOrUpdate_568314, schemes: {Scheme.Https})
type
  Call_RecordSetsGet_568299 = ref object of OpenApiRestCall_567657
proc url_RecordSetsGet_568301(protocol: Scheme; host: string; base: string;
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

proc validate_RecordSetsGet_568300(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_568302 = path.getOrDefault("resourceGroupName")
  valid_568302 = validateParameter(valid_568302, JString, required = true,
                                 default = nil)
  if valid_568302 != nil:
    section.add "resourceGroupName", valid_568302
  var valid_568303 = path.getOrDefault("recordType")
  valid_568303 = validateParameter(valid_568303, JString, required = true,
                                 default = newJString("A"))
  if valid_568303 != nil:
    section.add "recordType", valid_568303
  var valid_568304 = path.getOrDefault("subscriptionId")
  valid_568304 = validateParameter(valid_568304, JString, required = true,
                                 default = nil)
  if valid_568304 != nil:
    section.add "subscriptionId", valid_568304
  var valid_568305 = path.getOrDefault("zoneName")
  valid_568305 = validateParameter(valid_568305, JString, required = true,
                                 default = nil)
  if valid_568305 != nil:
    section.add "zoneName", valid_568305
  var valid_568306 = path.getOrDefault("relativeRecordSetName")
  valid_568306 = validateParameter(valid_568306, JString, required = true,
                                 default = nil)
  if valid_568306 != nil:
    section.add "relativeRecordSetName", valid_568306
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568307 = query.getOrDefault("api-version")
  valid_568307 = validateParameter(valid_568307, JString, required = true,
                                 default = nil)
  if valid_568307 != nil:
    section.add "api-version", valid_568307
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568308: Call_RecordSetsGet_568299; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a record set.
  ## 
  let valid = call_568308.validator(path, query, header, formData, body)
  let scheme = call_568308.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568308.url(scheme.get, call_568308.host, call_568308.base,
                         call_568308.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568308, url, valid)

proc call*(call_568309: Call_RecordSetsGet_568299; resourceGroupName: string;
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
  var path_568310 = newJObject()
  var query_568311 = newJObject()
  add(path_568310, "resourceGroupName", newJString(resourceGroupName))
  add(query_568311, "api-version", newJString(apiVersion))
  add(path_568310, "recordType", newJString(recordType))
  add(path_568310, "subscriptionId", newJString(subscriptionId))
  add(path_568310, "zoneName", newJString(zoneName))
  add(path_568310, "relativeRecordSetName", newJString(relativeRecordSetName))
  result = call_568309.call(path_568310, query_568311, nil, nil, nil)

var recordSetsGet* = Call_RecordSetsGet_568299(name: "recordSetsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/dnsZones/{zoneName}/{recordType}/{relativeRecordSetName}",
    validator: validate_RecordSetsGet_568300, base: "", url: url_RecordSetsGet_568301,
    schemes: {Scheme.Https})
type
  Call_RecordSetsUpdate_568343 = ref object of OpenApiRestCall_567657
proc url_RecordSetsUpdate_568345(protocol: Scheme; host: string; base: string;
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

proc validate_RecordSetsUpdate_568344(path: JsonNode; query: JsonNode;
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
  var valid_568346 = path.getOrDefault("resourceGroupName")
  valid_568346 = validateParameter(valid_568346, JString, required = true,
                                 default = nil)
  if valid_568346 != nil:
    section.add "resourceGroupName", valid_568346
  var valid_568347 = path.getOrDefault("recordType")
  valid_568347 = validateParameter(valid_568347, JString, required = true,
                                 default = newJString("A"))
  if valid_568347 != nil:
    section.add "recordType", valid_568347
  var valid_568348 = path.getOrDefault("subscriptionId")
  valid_568348 = validateParameter(valid_568348, JString, required = true,
                                 default = nil)
  if valid_568348 != nil:
    section.add "subscriptionId", valid_568348
  var valid_568349 = path.getOrDefault("zoneName")
  valid_568349 = validateParameter(valid_568349, JString, required = true,
                                 default = nil)
  if valid_568349 != nil:
    section.add "zoneName", valid_568349
  var valid_568350 = path.getOrDefault("relativeRecordSetName")
  valid_568350 = validateParameter(valid_568350, JString, required = true,
                                 default = nil)
  if valid_568350 != nil:
    section.add "relativeRecordSetName", valid_568350
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568351 = query.getOrDefault("api-version")
  valid_568351 = validateParameter(valid_568351, JString, required = true,
                                 default = nil)
  if valid_568351 != nil:
    section.add "api-version", valid_568351
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : The etag of the record set. Omit this value to always overwrite the current record set. Specify the last-seen etag value to prevent accidentally overwriting concurrent changes.
  section = newJObject()
  var valid_568352 = header.getOrDefault("If-Match")
  valid_568352 = validateParameter(valid_568352, JString, required = false,
                                 default = nil)
  if valid_568352 != nil:
    section.add "If-Match", valid_568352
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

proc call*(call_568354: Call_RecordSetsUpdate_568343; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a record set within a DNS zone.
  ## 
  let valid = call_568354.validator(path, query, header, formData, body)
  let scheme = call_568354.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568354.url(scheme.get, call_568354.host, call_568354.base,
                         call_568354.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568354, url, valid)

proc call*(call_568355: Call_RecordSetsUpdate_568343; resourceGroupName: string;
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
  var path_568356 = newJObject()
  var query_568357 = newJObject()
  var body_568358 = newJObject()
  add(path_568356, "resourceGroupName", newJString(resourceGroupName))
  add(query_568357, "api-version", newJString(apiVersion))
  add(path_568356, "recordType", newJString(recordType))
  add(path_568356, "subscriptionId", newJString(subscriptionId))
  add(path_568356, "zoneName", newJString(zoneName))
  if parameters != nil:
    body_568358 = parameters
  add(path_568356, "relativeRecordSetName", newJString(relativeRecordSetName))
  result = call_568355.call(path_568356, query_568357, nil, nil, body_568358)

var recordSetsUpdate* = Call_RecordSetsUpdate_568343(name: "recordSetsUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/dnsZones/{zoneName}/{recordType}/{relativeRecordSetName}",
    validator: validate_RecordSetsUpdate_568344, base: "",
    url: url_RecordSetsUpdate_568345, schemes: {Scheme.Https})
type
  Call_RecordSetsDelete_568329 = ref object of OpenApiRestCall_567657
proc url_RecordSetsDelete_568331(protocol: Scheme; host: string; base: string;
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

proc validate_RecordSetsDelete_568330(path: JsonNode; query: JsonNode;
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
  var valid_568332 = path.getOrDefault("resourceGroupName")
  valid_568332 = validateParameter(valid_568332, JString, required = true,
                                 default = nil)
  if valid_568332 != nil:
    section.add "resourceGroupName", valid_568332
  var valid_568333 = path.getOrDefault("recordType")
  valid_568333 = validateParameter(valid_568333, JString, required = true,
                                 default = newJString("A"))
  if valid_568333 != nil:
    section.add "recordType", valid_568333
  var valid_568334 = path.getOrDefault("subscriptionId")
  valid_568334 = validateParameter(valid_568334, JString, required = true,
                                 default = nil)
  if valid_568334 != nil:
    section.add "subscriptionId", valid_568334
  var valid_568335 = path.getOrDefault("zoneName")
  valid_568335 = validateParameter(valid_568335, JString, required = true,
                                 default = nil)
  if valid_568335 != nil:
    section.add "zoneName", valid_568335
  var valid_568336 = path.getOrDefault("relativeRecordSetName")
  valid_568336 = validateParameter(valid_568336, JString, required = true,
                                 default = nil)
  if valid_568336 != nil:
    section.add "relativeRecordSetName", valid_568336
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568337 = query.getOrDefault("api-version")
  valid_568337 = validateParameter(valid_568337, JString, required = true,
                                 default = nil)
  if valid_568337 != nil:
    section.add "api-version", valid_568337
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : The etag of the record set. Omit this value to always delete the current record set. Specify the last-seen etag value to prevent accidentally deleting any concurrent changes.
  section = newJObject()
  var valid_568338 = header.getOrDefault("If-Match")
  valid_568338 = validateParameter(valid_568338, JString, required = false,
                                 default = nil)
  if valid_568338 != nil:
    section.add "If-Match", valid_568338
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568339: Call_RecordSetsDelete_568329; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a record set from a DNS zone. This operation cannot be undone.
  ## 
  let valid = call_568339.validator(path, query, header, formData, body)
  let scheme = call_568339.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568339.url(scheme.get, call_568339.host, call_568339.base,
                         call_568339.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568339, url, valid)

proc call*(call_568340: Call_RecordSetsDelete_568329; resourceGroupName: string;
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
  var path_568341 = newJObject()
  var query_568342 = newJObject()
  add(path_568341, "resourceGroupName", newJString(resourceGroupName))
  add(query_568342, "api-version", newJString(apiVersion))
  add(path_568341, "recordType", newJString(recordType))
  add(path_568341, "subscriptionId", newJString(subscriptionId))
  add(path_568341, "zoneName", newJString(zoneName))
  add(path_568341, "relativeRecordSetName", newJString(relativeRecordSetName))
  result = call_568340.call(path_568341, query_568342, nil, nil, nil)

var recordSetsDelete* = Call_RecordSetsDelete_568329(name: "recordSetsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/dnsZones/{zoneName}/{recordType}/{relativeRecordSetName}",
    validator: validate_RecordSetsDelete_568330, base: "",
    url: url_RecordSetsDelete_568331, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
