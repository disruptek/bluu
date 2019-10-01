
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: DnsManagementClient
## version: 2018-05-01
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
  ##                 : Specifies the Azure subscription ID, which uniquely identifies the Microsoft Azure subscription.
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
  ##              : Specifies the API version.
  ##   $top: JInt
  ##       : The maximum number of DNS zones to return. If not specified, returns up to 100 zones.
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

proc call*(call_568080: Call_ZonesList_567879; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the DNS zones in all resource groups in a subscription.
  ## 
  let valid = call_568080.validator(path, query, header, formData, body)
  let scheme = call_568080.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568080.url(scheme.get, call_568080.host, call_568080.base,
                         call_568080.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568080, url, valid)

proc call*(call_568151: Call_ZonesList_567879; apiVersion: string;
          subscriptionId: string; Top: int = 0): Recallable =
  ## zonesList
  ## Lists the DNS zones in all resource groups in a subscription.
  ##   apiVersion: string (required)
  ##             : Specifies the API version.
  ##   subscriptionId: string (required)
  ##                 : Specifies the Azure subscription ID, which uniquely identifies the Microsoft Azure subscription.
  ##   Top: int
  ##      : The maximum number of DNS zones to return. If not specified, returns up to 100 zones.
  var path_568152 = newJObject()
  var query_568154 = newJObject()
  add(query_568154, "api-version", newJString(apiVersion))
  add(path_568152, "subscriptionId", newJString(subscriptionId))
  add(query_568154, "$top", newJInt(Top))
  result = call_568151.call(path_568152, query_568154, nil, nil, nil)

var zonesList* = Call_ZonesList_567879(name: "zonesList", meth: HttpMethod.HttpGet,
                                    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Network/dnszones",
                                    validator: validate_ZonesList_567880,
                                    base: "", url: url_ZonesList_567881,
                                    schemes: {Scheme.Https})
type
  Call_DnsResourceReferenceGetByTargetResources_568193 = ref object of OpenApiRestCall_567657
proc url_DnsResourceReferenceGetByTargetResources_568195(protocol: Scheme;
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
        value: "/providers/Microsoft.Network/getDnsResourceReference")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DnsResourceReferenceGetByTargetResources_568194(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns the DNS records specified by the referencing targetResourceIds.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Specifies the Azure subscription ID, which uniquely identifies the Microsoft Azure subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568213 = path.getOrDefault("subscriptionId")
  valid_568213 = validateParameter(valid_568213, JString, required = true,
                                 default = nil)
  if valid_568213 != nil:
    section.add "subscriptionId", valid_568213
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Specifies the API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568214 = query.getOrDefault("api-version")
  valid_568214 = validateParameter(valid_568214, JString, required = true,
                                 default = nil)
  if valid_568214 != nil:
    section.add "api-version", valid_568214
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Properties for dns resource reference request.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568216: Call_DnsResourceReferenceGetByTargetResources_568193;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns the DNS records specified by the referencing targetResourceIds.
  ## 
  let valid = call_568216.validator(path, query, header, formData, body)
  let scheme = call_568216.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568216.url(scheme.get, call_568216.host, call_568216.base,
                         call_568216.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568216, url, valid)

proc call*(call_568217: Call_DnsResourceReferenceGetByTargetResources_568193;
          apiVersion: string; subscriptionId: string; parameters: JsonNode): Recallable =
  ## dnsResourceReferenceGetByTargetResources
  ## Returns the DNS records specified by the referencing targetResourceIds.
  ##   apiVersion: string (required)
  ##             : Specifies the API version.
  ##   subscriptionId: string (required)
  ##                 : Specifies the Azure subscription ID, which uniquely identifies the Microsoft Azure subscription.
  ##   parameters: JObject (required)
  ##             : Properties for dns resource reference request.
  var path_568218 = newJObject()
  var query_568219 = newJObject()
  var body_568220 = newJObject()
  add(query_568219, "api-version", newJString(apiVersion))
  add(path_568218, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568220 = parameters
  result = call_568217.call(path_568218, query_568219, nil, nil, body_568220)

var dnsResourceReferenceGetByTargetResources* = Call_DnsResourceReferenceGetByTargetResources_568193(
    name: "dnsResourceReferenceGetByTargetResources", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Network/getDnsResourceReference",
    validator: validate_DnsResourceReferenceGetByTargetResources_568194, base: "",
    url: url_DnsResourceReferenceGetByTargetResources_568195,
    schemes: {Scheme.Https})
type
  Call_ZonesListByResourceGroup_568221 = ref object of OpenApiRestCall_567657
proc url_ZonesListByResourceGroup_568223(protocol: Scheme; host: string;
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

proc validate_ZonesListByResourceGroup_568222(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the DNS zones within a resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Specifies the Azure subscription ID, which uniquely identifies the Microsoft Azure subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568224 = path.getOrDefault("resourceGroupName")
  valid_568224 = validateParameter(valid_568224, JString, required = true,
                                 default = nil)
  if valid_568224 != nil:
    section.add "resourceGroupName", valid_568224
  var valid_568225 = path.getOrDefault("subscriptionId")
  valid_568225 = validateParameter(valid_568225, JString, required = true,
                                 default = nil)
  if valid_568225 != nil:
    section.add "subscriptionId", valid_568225
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Specifies the API version.
  ##   $top: JInt
  ##       : The maximum number of record sets to return. If not specified, returns up to 100 record sets.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568226 = query.getOrDefault("api-version")
  valid_568226 = validateParameter(valid_568226, JString, required = true,
                                 default = nil)
  if valid_568226 != nil:
    section.add "api-version", valid_568226
  var valid_568227 = query.getOrDefault("$top")
  valid_568227 = validateParameter(valid_568227, JInt, required = false, default = nil)
  if valid_568227 != nil:
    section.add "$top", valid_568227
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568228: Call_ZonesListByResourceGroup_568221; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the DNS zones within a resource group.
  ## 
  let valid = call_568228.validator(path, query, header, formData, body)
  let scheme = call_568228.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568228.url(scheme.get, call_568228.host, call_568228.base,
                         call_568228.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568228, url, valid)

proc call*(call_568229: Call_ZonesListByResourceGroup_568221;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          Top: int = 0): Recallable =
  ## zonesListByResourceGroup
  ## Lists the DNS zones within a resource group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Specifies the API version.
  ##   subscriptionId: string (required)
  ##                 : Specifies the Azure subscription ID, which uniquely identifies the Microsoft Azure subscription.
  ##   Top: int
  ##      : The maximum number of record sets to return. If not specified, returns up to 100 record sets.
  var path_568230 = newJObject()
  var query_568231 = newJObject()
  add(path_568230, "resourceGroupName", newJString(resourceGroupName))
  add(query_568231, "api-version", newJString(apiVersion))
  add(path_568230, "subscriptionId", newJString(subscriptionId))
  add(query_568231, "$top", newJInt(Top))
  result = call_568229.call(path_568230, query_568231, nil, nil, nil)

var zonesListByResourceGroup* = Call_ZonesListByResourceGroup_568221(
    name: "zonesListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/dnsZones",
    validator: validate_ZonesListByResourceGroup_568222, base: "",
    url: url_ZonesListByResourceGroup_568223, schemes: {Scheme.Https})
type
  Call_ZonesCreateOrUpdate_568243 = ref object of OpenApiRestCall_567657
proc url_ZonesCreateOrUpdate_568245(protocol: Scheme; host: string; base: string;
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

proc validate_ZonesCreateOrUpdate_568244(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Creates or updates a DNS zone. Does not modify DNS records within the zone.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Specifies the Azure subscription ID, which uniquely identifies the Microsoft Azure subscription.
  ##   zoneName: JString (required)
  ##           : The name of the DNS zone (without a terminating dot).
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568246 = path.getOrDefault("resourceGroupName")
  valid_568246 = validateParameter(valid_568246, JString, required = true,
                                 default = nil)
  if valid_568246 != nil:
    section.add "resourceGroupName", valid_568246
  var valid_568247 = path.getOrDefault("subscriptionId")
  valid_568247 = validateParameter(valid_568247, JString, required = true,
                                 default = nil)
  if valid_568247 != nil:
    section.add "subscriptionId", valid_568247
  var valid_568248 = path.getOrDefault("zoneName")
  valid_568248 = validateParameter(valid_568248, JString, required = true,
                                 default = nil)
  if valid_568248 != nil:
    section.add "zoneName", valid_568248
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Specifies the API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568249 = query.getOrDefault("api-version")
  valid_568249 = validateParameter(valid_568249, JString, required = true,
                                 default = nil)
  if valid_568249 != nil:
    section.add "api-version", valid_568249
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : The etag of the DNS zone. Omit this value to always overwrite the current zone. Specify the last-seen etag value to prevent accidentally overwriting any concurrent changes.
  ##   If-None-Match: JString
  ##                : Set to '*' to allow a new DNS zone to be created, but to prevent updating an existing zone. Other values will be ignored.
  section = newJObject()
  var valid_568250 = header.getOrDefault("If-Match")
  valid_568250 = validateParameter(valid_568250, JString, required = false,
                                 default = nil)
  if valid_568250 != nil:
    section.add "If-Match", valid_568250
  var valid_568251 = header.getOrDefault("If-None-Match")
  valid_568251 = validateParameter(valid_568251, JString, required = false,
                                 default = nil)
  if valid_568251 != nil:
    section.add "If-None-Match", valid_568251
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

proc call*(call_568253: Call_ZonesCreateOrUpdate_568243; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates a DNS zone. Does not modify DNS records within the zone.
  ## 
  let valid = call_568253.validator(path, query, header, formData, body)
  let scheme = call_568253.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568253.url(scheme.get, call_568253.host, call_568253.base,
                         call_568253.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568253, url, valid)

proc call*(call_568254: Call_ZonesCreateOrUpdate_568243; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; zoneName: string;
          parameters: JsonNode): Recallable =
  ## zonesCreateOrUpdate
  ## Creates or updates a DNS zone. Does not modify DNS records within the zone.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Specifies the API version.
  ##   subscriptionId: string (required)
  ##                 : Specifies the Azure subscription ID, which uniquely identifies the Microsoft Azure subscription.
  ##   zoneName: string (required)
  ##           : The name of the DNS zone (without a terminating dot).
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the CreateOrUpdate operation.
  var path_568255 = newJObject()
  var query_568256 = newJObject()
  var body_568257 = newJObject()
  add(path_568255, "resourceGroupName", newJString(resourceGroupName))
  add(query_568256, "api-version", newJString(apiVersion))
  add(path_568255, "subscriptionId", newJString(subscriptionId))
  add(path_568255, "zoneName", newJString(zoneName))
  if parameters != nil:
    body_568257 = parameters
  result = call_568254.call(path_568255, query_568256, nil, nil, body_568257)

var zonesCreateOrUpdate* = Call_ZonesCreateOrUpdate_568243(
    name: "zonesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/dnsZones/{zoneName}",
    validator: validate_ZonesCreateOrUpdate_568244, base: "",
    url: url_ZonesCreateOrUpdate_568245, schemes: {Scheme.Https})
type
  Call_ZonesGet_568232 = ref object of OpenApiRestCall_567657
proc url_ZonesGet_568234(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_ZonesGet_568233(path: JsonNode; query: JsonNode; header: JsonNode;
                             formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a DNS zone. Retrieves the zone properties, but not the record sets within the zone.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Specifies the Azure subscription ID, which uniquely identifies the Microsoft Azure subscription.
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
  ##              : Specifies the API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568238 = query.getOrDefault("api-version")
  valid_568238 = validateParameter(valid_568238, JString, required = true,
                                 default = nil)
  if valid_568238 != nil:
    section.add "api-version", valid_568238
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568239: Call_ZonesGet_568232; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a DNS zone. Retrieves the zone properties, but not the record sets within the zone.
  ## 
  let valid = call_568239.validator(path, query, header, formData, body)
  let scheme = call_568239.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568239.url(scheme.get, call_568239.host, call_568239.base,
                         call_568239.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568239, url, valid)

proc call*(call_568240: Call_ZonesGet_568232; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; zoneName: string): Recallable =
  ## zonesGet
  ## Gets a DNS zone. Retrieves the zone properties, but not the record sets within the zone.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Specifies the API version.
  ##   subscriptionId: string (required)
  ##                 : Specifies the Azure subscription ID, which uniquely identifies the Microsoft Azure subscription.
  ##   zoneName: string (required)
  ##           : The name of the DNS zone (without a terminating dot).
  var path_568241 = newJObject()
  var query_568242 = newJObject()
  add(path_568241, "resourceGroupName", newJString(resourceGroupName))
  add(query_568242, "api-version", newJString(apiVersion))
  add(path_568241, "subscriptionId", newJString(subscriptionId))
  add(path_568241, "zoneName", newJString(zoneName))
  result = call_568240.call(path_568241, query_568242, nil, nil, nil)

var zonesGet* = Call_ZonesGet_568232(name: "zonesGet", meth: HttpMethod.HttpGet,
                                  host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/dnsZones/{zoneName}",
                                  validator: validate_ZonesGet_568233, base: "",
                                  url: url_ZonesGet_568234,
                                  schemes: {Scheme.Https})
type
  Call_ZonesUpdate_568270 = ref object of OpenApiRestCall_567657
proc url_ZonesUpdate_568272(protocol: Scheme; host: string; base: string;
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

proc validate_ZonesUpdate_568271(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates a DNS zone. Does not modify DNS records within the zone.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Specifies the Azure subscription ID, which uniquely identifies the Microsoft Azure subscription.
  ##   zoneName: JString (required)
  ##           : The name of the DNS zone (without a terminating dot).
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
  var valid_568275 = path.getOrDefault("zoneName")
  valid_568275 = validateParameter(valid_568275, JString, required = true,
                                 default = nil)
  if valid_568275 != nil:
    section.add "zoneName", valid_568275
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Specifies the API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568276 = query.getOrDefault("api-version")
  valid_568276 = validateParameter(valid_568276, JString, required = true,
                                 default = nil)
  if valid_568276 != nil:
    section.add "api-version", valid_568276
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : The etag of the DNS zone. Omit this value to always overwrite the current zone. Specify the last-seen etag value to prevent accidentally overwriting any concurrent changes.
  section = newJObject()
  var valid_568277 = header.getOrDefault("If-Match")
  valid_568277 = validateParameter(valid_568277, JString, required = false,
                                 default = nil)
  if valid_568277 != nil:
    section.add "If-Match", valid_568277
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

proc call*(call_568279: Call_ZonesUpdate_568270; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a DNS zone. Does not modify DNS records within the zone.
  ## 
  let valid = call_568279.validator(path, query, header, formData, body)
  let scheme = call_568279.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568279.url(scheme.get, call_568279.host, call_568279.base,
                         call_568279.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568279, url, valid)

proc call*(call_568280: Call_ZonesUpdate_568270; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; zoneName: string;
          parameters: JsonNode): Recallable =
  ## zonesUpdate
  ## Updates a DNS zone. Does not modify DNS records within the zone.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Specifies the API version.
  ##   subscriptionId: string (required)
  ##                 : Specifies the Azure subscription ID, which uniquely identifies the Microsoft Azure subscription.
  ##   zoneName: string (required)
  ##           : The name of the DNS zone (without a terminating dot).
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the Update operation.
  var path_568281 = newJObject()
  var query_568282 = newJObject()
  var body_568283 = newJObject()
  add(path_568281, "resourceGroupName", newJString(resourceGroupName))
  add(query_568282, "api-version", newJString(apiVersion))
  add(path_568281, "subscriptionId", newJString(subscriptionId))
  add(path_568281, "zoneName", newJString(zoneName))
  if parameters != nil:
    body_568283 = parameters
  result = call_568280.call(path_568281, query_568282, nil, nil, body_568283)

var zonesUpdate* = Call_ZonesUpdate_568270(name: "zonesUpdate",
                                        meth: HttpMethod.HttpPatch,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/dnsZones/{zoneName}",
                                        validator: validate_ZonesUpdate_568271,
                                        base: "", url: url_ZonesUpdate_568272,
                                        schemes: {Scheme.Https})
type
  Call_ZonesDelete_568258 = ref object of OpenApiRestCall_567657
proc url_ZonesDelete_568260(protocol: Scheme; host: string; base: string;
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

proc validate_ZonesDelete_568259(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a DNS zone. WARNING: All DNS records in the zone will also be deleted. This operation cannot be undone.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Specifies the Azure subscription ID, which uniquely identifies the Microsoft Azure subscription.
  ##   zoneName: JString (required)
  ##           : The name of the DNS zone (without a terminating dot).
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568261 = path.getOrDefault("resourceGroupName")
  valid_568261 = validateParameter(valid_568261, JString, required = true,
                                 default = nil)
  if valid_568261 != nil:
    section.add "resourceGroupName", valid_568261
  var valid_568262 = path.getOrDefault("subscriptionId")
  valid_568262 = validateParameter(valid_568262, JString, required = true,
                                 default = nil)
  if valid_568262 != nil:
    section.add "subscriptionId", valid_568262
  var valid_568263 = path.getOrDefault("zoneName")
  valid_568263 = validateParameter(valid_568263, JString, required = true,
                                 default = nil)
  if valid_568263 != nil:
    section.add "zoneName", valid_568263
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Specifies the API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568264 = query.getOrDefault("api-version")
  valid_568264 = validateParameter(valid_568264, JString, required = true,
                                 default = nil)
  if valid_568264 != nil:
    section.add "api-version", valid_568264
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : The etag of the DNS zone. Omit this value to always delete the current zone. Specify the last-seen etag value to prevent accidentally deleting any concurrent changes.
  section = newJObject()
  var valid_568265 = header.getOrDefault("If-Match")
  valid_568265 = validateParameter(valid_568265, JString, required = false,
                                 default = nil)
  if valid_568265 != nil:
    section.add "If-Match", valid_568265
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568266: Call_ZonesDelete_568258; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a DNS zone. WARNING: All DNS records in the zone will also be deleted. This operation cannot be undone.
  ## 
  let valid = call_568266.validator(path, query, header, formData, body)
  let scheme = call_568266.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568266.url(scheme.get, call_568266.host, call_568266.base,
                         call_568266.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568266, url, valid)

proc call*(call_568267: Call_ZonesDelete_568258; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; zoneName: string): Recallable =
  ## zonesDelete
  ## Deletes a DNS zone. WARNING: All DNS records in the zone will also be deleted. This operation cannot be undone.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Specifies the API version.
  ##   subscriptionId: string (required)
  ##                 : Specifies the Azure subscription ID, which uniquely identifies the Microsoft Azure subscription.
  ##   zoneName: string (required)
  ##           : The name of the DNS zone (without a terminating dot).
  var path_568268 = newJObject()
  var query_568269 = newJObject()
  add(path_568268, "resourceGroupName", newJString(resourceGroupName))
  add(query_568269, "api-version", newJString(apiVersion))
  add(path_568268, "subscriptionId", newJString(subscriptionId))
  add(path_568268, "zoneName", newJString(zoneName))
  result = call_568267.call(path_568268, query_568269, nil, nil, nil)

var zonesDelete* = Call_ZonesDelete_568258(name: "zonesDelete",
                                        meth: HttpMethod.HttpDelete,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/dnsZones/{zoneName}",
                                        validator: validate_ZonesDelete_568259,
                                        base: "", url: url_ZonesDelete_568260,
                                        schemes: {Scheme.Https})
type
  Call_RecordSetsListAllByDnsZone_568284 = ref object of OpenApiRestCall_567657
proc url_RecordSetsListAllByDnsZone_568286(protocol: Scheme; host: string;
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

proc validate_RecordSetsListAllByDnsZone_568285(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all record sets in a DNS zone.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Specifies the Azure subscription ID, which uniquely identifies the Microsoft Azure subscription.
  ##   zoneName: JString (required)
  ##           : The name of the DNS zone (without a terminating dot).
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568287 = path.getOrDefault("resourceGroupName")
  valid_568287 = validateParameter(valid_568287, JString, required = true,
                                 default = nil)
  if valid_568287 != nil:
    section.add "resourceGroupName", valid_568287
  var valid_568288 = path.getOrDefault("subscriptionId")
  valid_568288 = validateParameter(valid_568288, JString, required = true,
                                 default = nil)
  if valid_568288 != nil:
    section.add "subscriptionId", valid_568288
  var valid_568289 = path.getOrDefault("zoneName")
  valid_568289 = validateParameter(valid_568289, JString, required = true,
                                 default = nil)
  if valid_568289 != nil:
    section.add "zoneName", valid_568289
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Specifies the API version.
  ##   $recordsetnamesuffix: JString
  ##                       : The suffix label of the record set name that has to be used to filter the record set enumerations. If this parameter is specified, Enumeration will return only records that end with .<recordSetNameSuffix>
  ##   $top: JInt
  ##       : The maximum number of record sets to return. If not specified, returns up to 100 record sets.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568290 = query.getOrDefault("api-version")
  valid_568290 = validateParameter(valid_568290, JString, required = true,
                                 default = nil)
  if valid_568290 != nil:
    section.add "api-version", valid_568290
  var valid_568291 = query.getOrDefault("$recordsetnamesuffix")
  valid_568291 = validateParameter(valid_568291, JString, required = false,
                                 default = nil)
  if valid_568291 != nil:
    section.add "$recordsetnamesuffix", valid_568291
  var valid_568292 = query.getOrDefault("$top")
  valid_568292 = validateParameter(valid_568292, JInt, required = false, default = nil)
  if valid_568292 != nil:
    section.add "$top", valid_568292
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568293: Call_RecordSetsListAllByDnsZone_568284; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all record sets in a DNS zone.
  ## 
  let valid = call_568293.validator(path, query, header, formData, body)
  let scheme = call_568293.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568293.url(scheme.get, call_568293.host, call_568293.base,
                         call_568293.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568293, url, valid)

proc call*(call_568294: Call_RecordSetsListAllByDnsZone_568284;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          zoneName: string; Recordsetnamesuffix: string = ""; Top: int = 0): Recallable =
  ## recordSetsListAllByDnsZone
  ## Lists all record sets in a DNS zone.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Specifies the API version.
  ##   subscriptionId: string (required)
  ##                 : Specifies the Azure subscription ID, which uniquely identifies the Microsoft Azure subscription.
  ##   Recordsetnamesuffix: string
  ##                      : The suffix label of the record set name that has to be used to filter the record set enumerations. If this parameter is specified, Enumeration will return only records that end with .<recordSetNameSuffix>
  ##   Top: int
  ##      : The maximum number of record sets to return. If not specified, returns up to 100 record sets.
  ##   zoneName: string (required)
  ##           : The name of the DNS zone (without a terminating dot).
  var path_568295 = newJObject()
  var query_568296 = newJObject()
  add(path_568295, "resourceGroupName", newJString(resourceGroupName))
  add(query_568296, "api-version", newJString(apiVersion))
  add(path_568295, "subscriptionId", newJString(subscriptionId))
  add(query_568296, "$recordsetnamesuffix", newJString(Recordsetnamesuffix))
  add(query_568296, "$top", newJInt(Top))
  add(path_568295, "zoneName", newJString(zoneName))
  result = call_568294.call(path_568295, query_568296, nil, nil, nil)

var recordSetsListAllByDnsZone* = Call_RecordSetsListAllByDnsZone_568284(
    name: "recordSetsListAllByDnsZone", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/dnsZones/{zoneName}/all",
    validator: validate_RecordSetsListAllByDnsZone_568285, base: "",
    url: url_RecordSetsListAllByDnsZone_568286, schemes: {Scheme.Https})
type
  Call_RecordSetsListByDnsZone_568297 = ref object of OpenApiRestCall_567657
proc url_RecordSetsListByDnsZone_568299(protocol: Scheme; host: string; base: string;
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

proc validate_RecordSetsListByDnsZone_568298(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all record sets in a DNS zone.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Specifies the Azure subscription ID, which uniquely identifies the Microsoft Azure subscription.
  ##   zoneName: JString (required)
  ##           : The name of the DNS zone (without a terminating dot).
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568300 = path.getOrDefault("resourceGroupName")
  valid_568300 = validateParameter(valid_568300, JString, required = true,
                                 default = nil)
  if valid_568300 != nil:
    section.add "resourceGroupName", valid_568300
  var valid_568301 = path.getOrDefault("subscriptionId")
  valid_568301 = validateParameter(valid_568301, JString, required = true,
                                 default = nil)
  if valid_568301 != nil:
    section.add "subscriptionId", valid_568301
  var valid_568302 = path.getOrDefault("zoneName")
  valid_568302 = validateParameter(valid_568302, JString, required = true,
                                 default = nil)
  if valid_568302 != nil:
    section.add "zoneName", valid_568302
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Specifies the API version.
  ##   $recordsetnamesuffix: JString
  ##                       : The suffix label of the record set name that has to be used to filter the record set enumerations. If this parameter is specified, Enumeration will return only records that end with .<recordSetNameSuffix>
  ##   $top: JInt
  ##       : The maximum number of record sets to return. If not specified, returns up to 100 record sets.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568303 = query.getOrDefault("api-version")
  valid_568303 = validateParameter(valid_568303, JString, required = true,
                                 default = nil)
  if valid_568303 != nil:
    section.add "api-version", valid_568303
  var valid_568304 = query.getOrDefault("$recordsetnamesuffix")
  valid_568304 = validateParameter(valid_568304, JString, required = false,
                                 default = nil)
  if valid_568304 != nil:
    section.add "$recordsetnamesuffix", valid_568304
  var valid_568305 = query.getOrDefault("$top")
  valid_568305 = validateParameter(valid_568305, JInt, required = false, default = nil)
  if valid_568305 != nil:
    section.add "$top", valid_568305
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568306: Call_RecordSetsListByDnsZone_568297; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all record sets in a DNS zone.
  ## 
  let valid = call_568306.validator(path, query, header, formData, body)
  let scheme = call_568306.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568306.url(scheme.get, call_568306.host, call_568306.base,
                         call_568306.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568306, url, valid)

proc call*(call_568307: Call_RecordSetsListByDnsZone_568297;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          zoneName: string; Recordsetnamesuffix: string = ""; Top: int = 0): Recallable =
  ## recordSetsListByDnsZone
  ## Lists all record sets in a DNS zone.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Specifies the API version.
  ##   subscriptionId: string (required)
  ##                 : Specifies the Azure subscription ID, which uniquely identifies the Microsoft Azure subscription.
  ##   Recordsetnamesuffix: string
  ##                      : The suffix label of the record set name that has to be used to filter the record set enumerations. If this parameter is specified, Enumeration will return only records that end with .<recordSetNameSuffix>
  ##   Top: int
  ##      : The maximum number of record sets to return. If not specified, returns up to 100 record sets.
  ##   zoneName: string (required)
  ##           : The name of the DNS zone (without a terminating dot).
  var path_568308 = newJObject()
  var query_568309 = newJObject()
  add(path_568308, "resourceGroupName", newJString(resourceGroupName))
  add(query_568309, "api-version", newJString(apiVersion))
  add(path_568308, "subscriptionId", newJString(subscriptionId))
  add(query_568309, "$recordsetnamesuffix", newJString(Recordsetnamesuffix))
  add(query_568309, "$top", newJInt(Top))
  add(path_568308, "zoneName", newJString(zoneName))
  result = call_568307.call(path_568308, query_568309, nil, nil, nil)

var recordSetsListByDnsZone* = Call_RecordSetsListByDnsZone_568297(
    name: "recordSetsListByDnsZone", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/dnsZones/{zoneName}/recordsets",
    validator: validate_RecordSetsListByDnsZone_568298, base: "",
    url: url_RecordSetsListByDnsZone_568299, schemes: {Scheme.Https})
type
  Call_RecordSetsListByType_568310 = ref object of OpenApiRestCall_567657
proc url_RecordSetsListByType_568312(protocol: Scheme; host: string; base: string;
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

proc validate_RecordSetsListByType_568311(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the record sets of a specified type in a DNS zone.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   recordType: JString (required)
  ##             : The type of record sets to enumerate.
  ##   subscriptionId: JString (required)
  ##                 : Specifies the Azure subscription ID, which uniquely identifies the Microsoft Azure subscription.
  ##   zoneName: JString (required)
  ##           : The name of the DNS zone (without a terminating dot).
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568313 = path.getOrDefault("resourceGroupName")
  valid_568313 = validateParameter(valid_568313, JString, required = true,
                                 default = nil)
  if valid_568313 != nil:
    section.add "resourceGroupName", valid_568313
  var valid_568327 = path.getOrDefault("recordType")
  valid_568327 = validateParameter(valid_568327, JString, required = true,
                                 default = newJString("A"))
  if valid_568327 != nil:
    section.add "recordType", valid_568327
  var valid_568328 = path.getOrDefault("subscriptionId")
  valid_568328 = validateParameter(valid_568328, JString, required = true,
                                 default = nil)
  if valid_568328 != nil:
    section.add "subscriptionId", valid_568328
  var valid_568329 = path.getOrDefault("zoneName")
  valid_568329 = validateParameter(valid_568329, JString, required = true,
                                 default = nil)
  if valid_568329 != nil:
    section.add "zoneName", valid_568329
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Specifies the API version.
  ##   $recordsetnamesuffix: JString
  ##                       : The suffix label of the record set name that has to be used to filter the record set enumerations. If this parameter is specified, Enumeration will return only records that end with .<recordSetNameSuffix>
  ##   $top: JInt
  ##       : The maximum number of record sets to return. If not specified, returns up to 100 record sets.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568330 = query.getOrDefault("api-version")
  valid_568330 = validateParameter(valid_568330, JString, required = true,
                                 default = nil)
  if valid_568330 != nil:
    section.add "api-version", valid_568330
  var valid_568331 = query.getOrDefault("$recordsetnamesuffix")
  valid_568331 = validateParameter(valid_568331, JString, required = false,
                                 default = nil)
  if valid_568331 != nil:
    section.add "$recordsetnamesuffix", valid_568331
  var valid_568332 = query.getOrDefault("$top")
  valid_568332 = validateParameter(valid_568332, JInt, required = false, default = nil)
  if valid_568332 != nil:
    section.add "$top", valid_568332
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568333: Call_RecordSetsListByType_568310; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the record sets of a specified type in a DNS zone.
  ## 
  let valid = call_568333.validator(path, query, header, formData, body)
  let scheme = call_568333.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568333.url(scheme.get, call_568333.host, call_568333.base,
                         call_568333.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568333, url, valid)

proc call*(call_568334: Call_RecordSetsListByType_568310;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          zoneName: string; recordType: string = "A";
          Recordsetnamesuffix: string = ""; Top: int = 0): Recallable =
  ## recordSetsListByType
  ## Lists the record sets of a specified type in a DNS zone.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Specifies the API version.
  ##   recordType: string (required)
  ##             : The type of record sets to enumerate.
  ##   subscriptionId: string (required)
  ##                 : Specifies the Azure subscription ID, which uniquely identifies the Microsoft Azure subscription.
  ##   Recordsetnamesuffix: string
  ##                      : The suffix label of the record set name that has to be used to filter the record set enumerations. If this parameter is specified, Enumeration will return only records that end with .<recordSetNameSuffix>
  ##   Top: int
  ##      : The maximum number of record sets to return. If not specified, returns up to 100 record sets.
  ##   zoneName: string (required)
  ##           : The name of the DNS zone (without a terminating dot).
  var path_568335 = newJObject()
  var query_568336 = newJObject()
  add(path_568335, "resourceGroupName", newJString(resourceGroupName))
  add(query_568336, "api-version", newJString(apiVersion))
  add(path_568335, "recordType", newJString(recordType))
  add(path_568335, "subscriptionId", newJString(subscriptionId))
  add(query_568336, "$recordsetnamesuffix", newJString(Recordsetnamesuffix))
  add(query_568336, "$top", newJInt(Top))
  add(path_568335, "zoneName", newJString(zoneName))
  result = call_568334.call(path_568335, query_568336, nil, nil, nil)

var recordSetsListByType* = Call_RecordSetsListByType_568310(
    name: "recordSetsListByType", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/dnsZones/{zoneName}/{recordType}",
    validator: validate_RecordSetsListByType_568311, base: "",
    url: url_RecordSetsListByType_568312, schemes: {Scheme.Https})
type
  Call_RecordSetsCreateOrUpdate_568350 = ref object of OpenApiRestCall_567657
proc url_RecordSetsCreateOrUpdate_568352(protocol: Scheme; host: string;
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

proc validate_RecordSetsCreateOrUpdate_568351(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates a record set within a DNS zone.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   recordType: JString (required)
  ##             : The type of DNS record in this record set. Record sets of type SOA can be updated but not created (they are created when the DNS zone is created).
  ##   subscriptionId: JString (required)
  ##                 : Specifies the Azure subscription ID, which uniquely identifies the Microsoft Azure subscription.
  ##   zoneName: JString (required)
  ##           : The name of the DNS zone (without a terminating dot).
  ##   relativeRecordSetName: JString (required)
  ##                        : The name of the record set, relative to the name of the zone.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568353 = path.getOrDefault("resourceGroupName")
  valid_568353 = validateParameter(valid_568353, JString, required = true,
                                 default = nil)
  if valid_568353 != nil:
    section.add "resourceGroupName", valid_568353
  var valid_568354 = path.getOrDefault("recordType")
  valid_568354 = validateParameter(valid_568354, JString, required = true,
                                 default = newJString("A"))
  if valid_568354 != nil:
    section.add "recordType", valid_568354
  var valid_568355 = path.getOrDefault("subscriptionId")
  valid_568355 = validateParameter(valid_568355, JString, required = true,
                                 default = nil)
  if valid_568355 != nil:
    section.add "subscriptionId", valid_568355
  var valid_568356 = path.getOrDefault("zoneName")
  valid_568356 = validateParameter(valid_568356, JString, required = true,
                                 default = nil)
  if valid_568356 != nil:
    section.add "zoneName", valid_568356
  var valid_568357 = path.getOrDefault("relativeRecordSetName")
  valid_568357 = validateParameter(valid_568357, JString, required = true,
                                 default = nil)
  if valid_568357 != nil:
    section.add "relativeRecordSetName", valid_568357
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Specifies the API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568358 = query.getOrDefault("api-version")
  valid_568358 = validateParameter(valid_568358, JString, required = true,
                                 default = nil)
  if valid_568358 != nil:
    section.add "api-version", valid_568358
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : The etag of the record set. Omit this value to always overwrite the current record set. Specify the last-seen etag value to prevent accidentally overwriting any concurrent changes.
  ##   If-None-Match: JString
  ##                : Set to '*' to allow a new record set to be created, but to prevent updating an existing record set. Other values will be ignored.
  section = newJObject()
  var valid_568359 = header.getOrDefault("If-Match")
  valid_568359 = validateParameter(valid_568359, JString, required = false,
                                 default = nil)
  if valid_568359 != nil:
    section.add "If-Match", valid_568359
  var valid_568360 = header.getOrDefault("If-None-Match")
  valid_568360 = validateParameter(valid_568360, JString, required = false,
                                 default = nil)
  if valid_568360 != nil:
    section.add "If-None-Match", valid_568360
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

proc call*(call_568362: Call_RecordSetsCreateOrUpdate_568350; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates a record set within a DNS zone.
  ## 
  let valid = call_568362.validator(path, query, header, formData, body)
  let scheme = call_568362.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568362.url(scheme.get, call_568362.host, call_568362.base,
                         call_568362.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568362, url, valid)

proc call*(call_568363: Call_RecordSetsCreateOrUpdate_568350;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          zoneName: string; parameters: JsonNode; relativeRecordSetName: string;
          recordType: string = "A"): Recallable =
  ## recordSetsCreateOrUpdate
  ## Creates or updates a record set within a DNS zone.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Specifies the API version.
  ##   recordType: string (required)
  ##             : The type of DNS record in this record set. Record sets of type SOA can be updated but not created (they are created when the DNS zone is created).
  ##   subscriptionId: string (required)
  ##                 : Specifies the Azure subscription ID, which uniquely identifies the Microsoft Azure subscription.
  ##   zoneName: string (required)
  ##           : The name of the DNS zone (without a terminating dot).
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the CreateOrUpdate operation.
  ##   relativeRecordSetName: string (required)
  ##                        : The name of the record set, relative to the name of the zone.
  var path_568364 = newJObject()
  var query_568365 = newJObject()
  var body_568366 = newJObject()
  add(path_568364, "resourceGroupName", newJString(resourceGroupName))
  add(query_568365, "api-version", newJString(apiVersion))
  add(path_568364, "recordType", newJString(recordType))
  add(path_568364, "subscriptionId", newJString(subscriptionId))
  add(path_568364, "zoneName", newJString(zoneName))
  if parameters != nil:
    body_568366 = parameters
  add(path_568364, "relativeRecordSetName", newJString(relativeRecordSetName))
  result = call_568363.call(path_568364, query_568365, nil, nil, body_568366)

var recordSetsCreateOrUpdate* = Call_RecordSetsCreateOrUpdate_568350(
    name: "recordSetsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/dnsZones/{zoneName}/{recordType}/{relativeRecordSetName}",
    validator: validate_RecordSetsCreateOrUpdate_568351, base: "",
    url: url_RecordSetsCreateOrUpdate_568352, schemes: {Scheme.Https})
type
  Call_RecordSetsGet_568337 = ref object of OpenApiRestCall_567657
proc url_RecordSetsGet_568339(protocol: Scheme; host: string; base: string;
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

proc validate_RecordSetsGet_568338(path: JsonNode; query: JsonNode; header: JsonNode;
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
  ##                 : Specifies the Azure subscription ID, which uniquely identifies the Microsoft Azure subscription.
  ##   zoneName: JString (required)
  ##           : The name of the DNS zone (without a terminating dot).
  ##   relativeRecordSetName: JString (required)
  ##                        : The name of the record set, relative to the name of the zone.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568340 = path.getOrDefault("resourceGroupName")
  valid_568340 = validateParameter(valid_568340, JString, required = true,
                                 default = nil)
  if valid_568340 != nil:
    section.add "resourceGroupName", valid_568340
  var valid_568341 = path.getOrDefault("recordType")
  valid_568341 = validateParameter(valid_568341, JString, required = true,
                                 default = newJString("A"))
  if valid_568341 != nil:
    section.add "recordType", valid_568341
  var valid_568342 = path.getOrDefault("subscriptionId")
  valid_568342 = validateParameter(valid_568342, JString, required = true,
                                 default = nil)
  if valid_568342 != nil:
    section.add "subscriptionId", valid_568342
  var valid_568343 = path.getOrDefault("zoneName")
  valid_568343 = validateParameter(valid_568343, JString, required = true,
                                 default = nil)
  if valid_568343 != nil:
    section.add "zoneName", valid_568343
  var valid_568344 = path.getOrDefault("relativeRecordSetName")
  valid_568344 = validateParameter(valid_568344, JString, required = true,
                                 default = nil)
  if valid_568344 != nil:
    section.add "relativeRecordSetName", valid_568344
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Specifies the API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568345 = query.getOrDefault("api-version")
  valid_568345 = validateParameter(valid_568345, JString, required = true,
                                 default = nil)
  if valid_568345 != nil:
    section.add "api-version", valid_568345
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568346: Call_RecordSetsGet_568337; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a record set.
  ## 
  let valid = call_568346.validator(path, query, header, formData, body)
  let scheme = call_568346.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568346.url(scheme.get, call_568346.host, call_568346.base,
                         call_568346.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568346, url, valid)

proc call*(call_568347: Call_RecordSetsGet_568337; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; zoneName: string;
          relativeRecordSetName: string; recordType: string = "A"): Recallable =
  ## recordSetsGet
  ## Gets a record set.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Specifies the API version.
  ##   recordType: string (required)
  ##             : The type of DNS record in this record set.
  ##   subscriptionId: string (required)
  ##                 : Specifies the Azure subscription ID, which uniquely identifies the Microsoft Azure subscription.
  ##   zoneName: string (required)
  ##           : The name of the DNS zone (without a terminating dot).
  ##   relativeRecordSetName: string (required)
  ##                        : The name of the record set, relative to the name of the zone.
  var path_568348 = newJObject()
  var query_568349 = newJObject()
  add(path_568348, "resourceGroupName", newJString(resourceGroupName))
  add(query_568349, "api-version", newJString(apiVersion))
  add(path_568348, "recordType", newJString(recordType))
  add(path_568348, "subscriptionId", newJString(subscriptionId))
  add(path_568348, "zoneName", newJString(zoneName))
  add(path_568348, "relativeRecordSetName", newJString(relativeRecordSetName))
  result = call_568347.call(path_568348, query_568349, nil, nil, nil)

var recordSetsGet* = Call_RecordSetsGet_568337(name: "recordSetsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/dnsZones/{zoneName}/{recordType}/{relativeRecordSetName}",
    validator: validate_RecordSetsGet_568338, base: "", url: url_RecordSetsGet_568339,
    schemes: {Scheme.Https})
type
  Call_RecordSetsUpdate_568381 = ref object of OpenApiRestCall_567657
proc url_RecordSetsUpdate_568383(protocol: Scheme; host: string; base: string;
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

proc validate_RecordSetsUpdate_568382(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Updates a record set within a DNS zone.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   recordType: JString (required)
  ##             : The type of DNS record in this record set.
  ##   subscriptionId: JString (required)
  ##                 : Specifies the Azure subscription ID, which uniquely identifies the Microsoft Azure subscription.
  ##   zoneName: JString (required)
  ##           : The name of the DNS zone (without a terminating dot).
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
  var valid_568387 = path.getOrDefault("zoneName")
  valid_568387 = validateParameter(valid_568387, JString, required = true,
                                 default = nil)
  if valid_568387 != nil:
    section.add "zoneName", valid_568387
  var valid_568388 = path.getOrDefault("relativeRecordSetName")
  valid_568388 = validateParameter(valid_568388, JString, required = true,
                                 default = nil)
  if valid_568388 != nil:
    section.add "relativeRecordSetName", valid_568388
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Specifies the API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568389 = query.getOrDefault("api-version")
  valid_568389 = validateParameter(valid_568389, JString, required = true,
                                 default = nil)
  if valid_568389 != nil:
    section.add "api-version", valid_568389
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : The etag of the record set. Omit this value to always overwrite the current record set. Specify the last-seen etag value to prevent accidentally overwriting concurrent changes.
  section = newJObject()
  var valid_568390 = header.getOrDefault("If-Match")
  valid_568390 = validateParameter(valid_568390, JString, required = false,
                                 default = nil)
  if valid_568390 != nil:
    section.add "If-Match", valid_568390
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

proc call*(call_568392: Call_RecordSetsUpdate_568381; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a record set within a DNS zone.
  ## 
  let valid = call_568392.validator(path, query, header, formData, body)
  let scheme = call_568392.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568392.url(scheme.get, call_568392.host, call_568392.base,
                         call_568392.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568392, url, valid)

proc call*(call_568393: Call_RecordSetsUpdate_568381; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; zoneName: string;
          parameters: JsonNode; relativeRecordSetName: string;
          recordType: string = "A"): Recallable =
  ## recordSetsUpdate
  ## Updates a record set within a DNS zone.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Specifies the API version.
  ##   recordType: string (required)
  ##             : The type of DNS record in this record set.
  ##   subscriptionId: string (required)
  ##                 : Specifies the Azure subscription ID, which uniquely identifies the Microsoft Azure subscription.
  ##   zoneName: string (required)
  ##           : The name of the DNS zone (without a terminating dot).
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the Update operation.
  ##   relativeRecordSetName: string (required)
  ##                        : The name of the record set, relative to the name of the zone.
  var path_568394 = newJObject()
  var query_568395 = newJObject()
  var body_568396 = newJObject()
  add(path_568394, "resourceGroupName", newJString(resourceGroupName))
  add(query_568395, "api-version", newJString(apiVersion))
  add(path_568394, "recordType", newJString(recordType))
  add(path_568394, "subscriptionId", newJString(subscriptionId))
  add(path_568394, "zoneName", newJString(zoneName))
  if parameters != nil:
    body_568396 = parameters
  add(path_568394, "relativeRecordSetName", newJString(relativeRecordSetName))
  result = call_568393.call(path_568394, query_568395, nil, nil, body_568396)

var recordSetsUpdate* = Call_RecordSetsUpdate_568381(name: "recordSetsUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/dnsZones/{zoneName}/{recordType}/{relativeRecordSetName}",
    validator: validate_RecordSetsUpdate_568382, base: "",
    url: url_RecordSetsUpdate_568383, schemes: {Scheme.Https})
type
  Call_RecordSetsDelete_568367 = ref object of OpenApiRestCall_567657
proc url_RecordSetsDelete_568369(protocol: Scheme; host: string; base: string;
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

proc validate_RecordSetsDelete_568368(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Deletes a record set from a DNS zone. This operation cannot be undone.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   recordType: JString (required)
  ##             : The type of DNS record in this record set. Record sets of type SOA cannot be deleted (they are deleted when the DNS zone is deleted).
  ##   subscriptionId: JString (required)
  ##                 : Specifies the Azure subscription ID, which uniquely identifies the Microsoft Azure subscription.
  ##   zoneName: JString (required)
  ##           : The name of the DNS zone (without a terminating dot).
  ##   relativeRecordSetName: JString (required)
  ##                        : The name of the record set, relative to the name of the zone.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568370 = path.getOrDefault("resourceGroupName")
  valid_568370 = validateParameter(valid_568370, JString, required = true,
                                 default = nil)
  if valid_568370 != nil:
    section.add "resourceGroupName", valid_568370
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
  var valid_568373 = path.getOrDefault("zoneName")
  valid_568373 = validateParameter(valid_568373, JString, required = true,
                                 default = nil)
  if valid_568373 != nil:
    section.add "zoneName", valid_568373
  var valid_568374 = path.getOrDefault("relativeRecordSetName")
  valid_568374 = validateParameter(valid_568374, JString, required = true,
                                 default = nil)
  if valid_568374 != nil:
    section.add "relativeRecordSetName", valid_568374
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Specifies the API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568375 = query.getOrDefault("api-version")
  valid_568375 = validateParameter(valid_568375, JString, required = true,
                                 default = nil)
  if valid_568375 != nil:
    section.add "api-version", valid_568375
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : The etag of the record set. Omit this value to always delete the current record set. Specify the last-seen etag value to prevent accidentally deleting any concurrent changes.
  section = newJObject()
  var valid_568376 = header.getOrDefault("If-Match")
  valid_568376 = validateParameter(valid_568376, JString, required = false,
                                 default = nil)
  if valid_568376 != nil:
    section.add "If-Match", valid_568376
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568377: Call_RecordSetsDelete_568367; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a record set from a DNS zone. This operation cannot be undone.
  ## 
  let valid = call_568377.validator(path, query, header, formData, body)
  let scheme = call_568377.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568377.url(scheme.get, call_568377.host, call_568377.base,
                         call_568377.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568377, url, valid)

proc call*(call_568378: Call_RecordSetsDelete_568367; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; zoneName: string;
          relativeRecordSetName: string; recordType: string = "A"): Recallable =
  ## recordSetsDelete
  ## Deletes a record set from a DNS zone. This operation cannot be undone.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Specifies the API version.
  ##   recordType: string (required)
  ##             : The type of DNS record in this record set. Record sets of type SOA cannot be deleted (they are deleted when the DNS zone is deleted).
  ##   subscriptionId: string (required)
  ##                 : Specifies the Azure subscription ID, which uniquely identifies the Microsoft Azure subscription.
  ##   zoneName: string (required)
  ##           : The name of the DNS zone (without a terminating dot).
  ##   relativeRecordSetName: string (required)
  ##                        : The name of the record set, relative to the name of the zone.
  var path_568379 = newJObject()
  var query_568380 = newJObject()
  add(path_568379, "resourceGroupName", newJString(resourceGroupName))
  add(query_568380, "api-version", newJString(apiVersion))
  add(path_568379, "recordType", newJString(recordType))
  add(path_568379, "subscriptionId", newJString(subscriptionId))
  add(path_568379, "zoneName", newJString(zoneName))
  add(path_568379, "relativeRecordSetName", newJString(relativeRecordSetName))
  result = call_568378.call(path_568379, query_568380, nil, nil, nil)

var recordSetsDelete* = Call_RecordSetsDelete_568367(name: "recordSetsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/dnsZones/{zoneName}/{recordType}/{relativeRecordSetName}",
    validator: validate_RecordSetsDelete_568368, base: "",
    url: url_RecordSetsDelete_568369, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
