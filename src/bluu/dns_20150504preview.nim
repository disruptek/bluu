
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: DnsManagementClient
## version: 2015-05-04-preview
## termsOfService: (not provided)
## license: (not provided)
## 
## Client for managing DNS zones and record.
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
  Call_ZonesListZonesInSubscription_567879 = ref object of OpenApiRestCall_567657
proc url_ZonesListZonesInSubscription_567881(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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

proc validate_ZonesListZonesInSubscription_567880(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the DNS zones within a resource group.
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
  ##   $top: JString
  ##       : Query parameters. If null is passed returns the default number of zones.
  ##   $filter: JString
  ##          : The filter to apply on the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568043 = query.getOrDefault("api-version")
  valid_568043 = validateParameter(valid_568043, JString, required = true,
                                 default = nil)
  if valid_568043 != nil:
    section.add "api-version", valid_568043
  var valid_568044 = query.getOrDefault("$top")
  valid_568044 = validateParameter(valid_568044, JString, required = false,
                                 default = nil)
  if valid_568044 != nil:
    section.add "$top", valid_568044
  var valid_568045 = query.getOrDefault("$filter")
  valid_568045 = validateParameter(valid_568045, JString, required = false,
                                 default = nil)
  if valid_568045 != nil:
    section.add "$filter", valid_568045
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568072: Call_ZonesListZonesInSubscription_567879; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the DNS zones within a resource group.
  ## 
  let valid = call_568072.validator(path, query, header, formData, body)
  let scheme = call_568072.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568072.url(scheme.get, call_568072.host, call_568072.base,
                         call_568072.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568072, url, valid)

proc call*(call_568143: Call_ZonesListZonesInSubscription_567879;
          apiVersion: string; subscriptionId: string; Top: string = "";
          Filter: string = ""): Recallable =
  ## zonesListZonesInSubscription
  ## Lists the DNS zones within a resource group.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   Top: string
  ##      : Query parameters. If null is passed returns the default number of zones.
  ##   Filter: string
  ##         : The filter to apply on the operation.
  var path_568144 = newJObject()
  var query_568146 = newJObject()
  add(query_568146, "api-version", newJString(apiVersion))
  add(path_568144, "subscriptionId", newJString(subscriptionId))
  add(query_568146, "$top", newJString(Top))
  add(query_568146, "$filter", newJString(Filter))
  result = call_568143.call(path_568144, query_568146, nil, nil, nil)

var zonesListZonesInSubscription* = Call_ZonesListZonesInSubscription_567879(
    name: "zonesListZonesInSubscription", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Network/dnszones",
    validator: validate_ZonesListZonesInSubscription_567880, base: "",
    url: url_ZonesListZonesInSubscription_567881, schemes: {Scheme.Https})
type
  Call_ZonesListZonesInResourceGroup_568185 = ref object of OpenApiRestCall_567657
proc url_ZonesListZonesInResourceGroup_568187(protocol: Scheme; host: string;
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
        kind: ConstantSegment, value: "/providers/Microsoft.Network/dnszones")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ZonesListZonesInResourceGroup_568186(path: JsonNode; query: JsonNode;
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
  var valid_568188 = path.getOrDefault("resourceGroupName")
  valid_568188 = validateParameter(valid_568188, JString, required = true,
                                 default = nil)
  if valid_568188 != nil:
    section.add "resourceGroupName", valid_568188
  var valid_568189 = path.getOrDefault("subscriptionId")
  valid_568189 = validateParameter(valid_568189, JString, required = true,
                                 default = nil)
  if valid_568189 != nil:
    section.add "subscriptionId", valid_568189
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  ##   $top: JString
  ##       : Query parameters. If null is passed returns the default number of zones.
  ##   $filter: JString
  ##          : The filter to apply on the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568190 = query.getOrDefault("api-version")
  valid_568190 = validateParameter(valid_568190, JString, required = true,
                                 default = nil)
  if valid_568190 != nil:
    section.add "api-version", valid_568190
  var valid_568191 = query.getOrDefault("$top")
  valid_568191 = validateParameter(valid_568191, JString, required = false,
                                 default = nil)
  if valid_568191 != nil:
    section.add "$top", valid_568191
  var valid_568192 = query.getOrDefault("$filter")
  valid_568192 = validateParameter(valid_568192, JString, required = false,
                                 default = nil)
  if valid_568192 != nil:
    section.add "$filter", valid_568192
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568193: Call_ZonesListZonesInResourceGroup_568185; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the DNS zones within a resource group.
  ## 
  let valid = call_568193.validator(path, query, header, formData, body)
  let scheme = call_568193.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568193.url(scheme.get, call_568193.host, call_568193.base,
                         call_568193.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568193, url, valid)

proc call*(call_568194: Call_ZonesListZonesInResourceGroup_568185;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          Top: string = ""; Filter: string = ""): Recallable =
  ## zonesListZonesInResourceGroup
  ## Lists the DNS zones within a resource group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   Top: string
  ##      : Query parameters. If null is passed returns the default number of zones.
  ##   Filter: string
  ##         : The filter to apply on the operation.
  var path_568195 = newJObject()
  var query_568196 = newJObject()
  add(path_568195, "resourceGroupName", newJString(resourceGroupName))
  add(query_568196, "api-version", newJString(apiVersion))
  add(path_568195, "subscriptionId", newJString(subscriptionId))
  add(query_568196, "$top", newJString(Top))
  add(query_568196, "$filter", newJString(Filter))
  result = call_568194.call(path_568195, query_568196, nil, nil, nil)

var zonesListZonesInResourceGroup* = Call_ZonesListZonesInResourceGroup_568185(
    name: "zonesListZonesInResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/dnszones",
    validator: validate_ZonesListZonesInResourceGroup_568186, base: "",
    url: url_ZonesListZonesInResourceGroup_568187, schemes: {Scheme.Https})
type
  Call_ZonesCreateOrUpdate_568208 = ref object of OpenApiRestCall_567657
proc url_ZonesCreateOrUpdate_568210(protocol: Scheme; host: string; base: string;
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
        kind: ConstantSegment, value: "/providers/Microsoft.Network/dnszones/"),
               (kind: VariableSegment, value: "zoneName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ZonesCreateOrUpdate_568209(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Creates a DNS zone within a resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   zoneName: JString (required)
  ##           : The name of the zone without a terminating dot.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568237 = path.getOrDefault("resourceGroupName")
  valid_568237 = validateParameter(valid_568237, JString, required = true,
                                 default = nil)
  if valid_568237 != nil:
    section.add "resourceGroupName", valid_568237
  var valid_568238 = path.getOrDefault("subscriptionId")
  valid_568238 = validateParameter(valid_568238, JString, required = true,
                                 default = nil)
  if valid_568238 != nil:
    section.add "subscriptionId", valid_568238
  var valid_568239 = path.getOrDefault("zoneName")
  valid_568239 = validateParameter(valid_568239, JString, required = true,
                                 default = nil)
  if valid_568239 != nil:
    section.add "zoneName", valid_568239
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568240 = query.getOrDefault("api-version")
  valid_568240 = validateParameter(valid_568240, JString, required = true,
                                 default = nil)
  if valid_568240 != nil:
    section.add "api-version", valid_568240
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : The etag of Zone.
  ##   If-None-Match: JString
  ##                : Defines the If-None-Match condition. Set to '*' to force Create-If-Not-Exist. Other values will be ignored.
  section = newJObject()
  var valid_568241 = header.getOrDefault("If-Match")
  valid_568241 = validateParameter(valid_568241, JString, required = false,
                                 default = nil)
  if valid_568241 != nil:
    section.add "If-Match", valid_568241
  var valid_568242 = header.getOrDefault("If-None-Match")
  valid_568242 = validateParameter(valid_568242, JString, required = false,
                                 default = nil)
  if valid_568242 != nil:
    section.add "If-None-Match", valid_568242
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

proc call*(call_568244: Call_ZonesCreateOrUpdate_568208; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a DNS zone within a resource group.
  ## 
  let valid = call_568244.validator(path, query, header, formData, body)
  let scheme = call_568244.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568244.url(scheme.get, call_568244.host, call_568244.base,
                         call_568244.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568244, url, valid)

proc call*(call_568245: Call_ZonesCreateOrUpdate_568208; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; zoneName: string;
          parameters: JsonNode): Recallable =
  ## zonesCreateOrUpdate
  ## Creates a DNS zone within a resource group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   zoneName: string (required)
  ##           : The name of the zone without a terminating dot.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the CreateOrUpdate operation.
  var path_568246 = newJObject()
  var query_568247 = newJObject()
  var body_568248 = newJObject()
  add(path_568246, "resourceGroupName", newJString(resourceGroupName))
  add(query_568247, "api-version", newJString(apiVersion))
  add(path_568246, "subscriptionId", newJString(subscriptionId))
  add(path_568246, "zoneName", newJString(zoneName))
  if parameters != nil:
    body_568248 = parameters
  result = call_568245.call(path_568246, query_568247, nil, nil, body_568248)

var zonesCreateOrUpdate* = Call_ZonesCreateOrUpdate_568208(
    name: "zonesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/dnszones/{zoneName}",
    validator: validate_ZonesCreateOrUpdate_568209, base: "",
    url: url_ZonesCreateOrUpdate_568210, schemes: {Scheme.Https})
type
  Call_ZonesGet_568197 = ref object of OpenApiRestCall_567657
proc url_ZonesGet_568199(protocol: Scheme; host: string; base: string; route: string;
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
        kind: ConstantSegment, value: "/providers/Microsoft.Network/dnszones/"),
               (kind: VariableSegment, value: "zoneName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ZonesGet_568198(path: JsonNode; query: JsonNode; header: JsonNode;
                             formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a DNS zone.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   zoneName: JString (required)
  ##           : The name of the zone without a terminating dot.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568200 = path.getOrDefault("resourceGroupName")
  valid_568200 = validateParameter(valid_568200, JString, required = true,
                                 default = nil)
  if valid_568200 != nil:
    section.add "resourceGroupName", valid_568200
  var valid_568201 = path.getOrDefault("subscriptionId")
  valid_568201 = validateParameter(valid_568201, JString, required = true,
                                 default = nil)
  if valid_568201 != nil:
    section.add "subscriptionId", valid_568201
  var valid_568202 = path.getOrDefault("zoneName")
  valid_568202 = validateParameter(valid_568202, JString, required = true,
                                 default = nil)
  if valid_568202 != nil:
    section.add "zoneName", valid_568202
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568203 = query.getOrDefault("api-version")
  valid_568203 = validateParameter(valid_568203, JString, required = true,
                                 default = nil)
  if valid_568203 != nil:
    section.add "api-version", valid_568203
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568204: Call_ZonesGet_568197; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a DNS zone.
  ## 
  let valid = call_568204.validator(path, query, header, formData, body)
  let scheme = call_568204.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568204.url(scheme.get, call_568204.host, call_568204.base,
                         call_568204.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568204, url, valid)

proc call*(call_568205: Call_ZonesGet_568197; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; zoneName: string): Recallable =
  ## zonesGet
  ## Gets a DNS zone.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   zoneName: string (required)
  ##           : The name of the zone without a terminating dot.
  var path_568206 = newJObject()
  var query_568207 = newJObject()
  add(path_568206, "resourceGroupName", newJString(resourceGroupName))
  add(query_568207, "api-version", newJString(apiVersion))
  add(path_568206, "subscriptionId", newJString(subscriptionId))
  add(path_568206, "zoneName", newJString(zoneName))
  result = call_568205.call(path_568206, query_568207, nil, nil, nil)

var zonesGet* = Call_ZonesGet_568197(name: "zonesGet", meth: HttpMethod.HttpGet,
                                  host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/dnszones/{zoneName}",
                                  validator: validate_ZonesGet_568198, base: "",
                                  url: url_ZonesGet_568199,
                                  schemes: {Scheme.Https})
type
  Call_ZonesDelete_568249 = ref object of OpenApiRestCall_567657
proc url_ZonesDelete_568251(protocol: Scheme; host: string; base: string;
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
        kind: ConstantSegment, value: "/providers/Microsoft.Network/dnszones/"),
               (kind: VariableSegment, value: "zoneName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ZonesDelete_568250(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Removes a DNS zone from a resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   zoneName: JString (required)
  ##           : The name of the zone without a terminating dot.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568252 = path.getOrDefault("resourceGroupName")
  valid_568252 = validateParameter(valid_568252, JString, required = true,
                                 default = nil)
  if valid_568252 != nil:
    section.add "resourceGroupName", valid_568252
  var valid_568253 = path.getOrDefault("subscriptionId")
  valid_568253 = validateParameter(valid_568253, JString, required = true,
                                 default = nil)
  if valid_568253 != nil:
    section.add "subscriptionId", valid_568253
  var valid_568254 = path.getOrDefault("zoneName")
  valid_568254 = validateParameter(valid_568254, JString, required = true,
                                 default = nil)
  if valid_568254 != nil:
    section.add "zoneName", valid_568254
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568255 = query.getOrDefault("api-version")
  valid_568255 = validateParameter(valid_568255, JString, required = true,
                                 default = nil)
  if valid_568255 != nil:
    section.add "api-version", valid_568255
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : Defines the If-Match condition. The delete operation will be performed only if the ETag of the zone on the server matches this value.
  section = newJObject()
  var valid_568256 = header.getOrDefault("If-Match")
  valid_568256 = validateParameter(valid_568256, JString, required = false,
                                 default = nil)
  if valid_568256 != nil:
    section.add "If-Match", valid_568256
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568257: Call_ZonesDelete_568249; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Removes a DNS zone from a resource group.
  ## 
  let valid = call_568257.validator(path, query, header, formData, body)
  let scheme = call_568257.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568257.url(scheme.get, call_568257.host, call_568257.base,
                         call_568257.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568257, url, valid)

proc call*(call_568258: Call_ZonesDelete_568249; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; zoneName: string): Recallable =
  ## zonesDelete
  ## Removes a DNS zone from a resource group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   zoneName: string (required)
  ##           : The name of the zone without a terminating dot.
  var path_568259 = newJObject()
  var query_568260 = newJObject()
  add(path_568259, "resourceGroupName", newJString(resourceGroupName))
  add(query_568260, "api-version", newJString(apiVersion))
  add(path_568259, "subscriptionId", newJString(subscriptionId))
  add(path_568259, "zoneName", newJString(zoneName))
  result = call_568258.call(path_568259, query_568260, nil, nil, nil)

var zonesDelete* = Call_ZonesDelete_568249(name: "zonesDelete",
                                        meth: HttpMethod.HttpDelete,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/dnszones/{zoneName}",
                                        validator: validate_ZonesDelete_568250,
                                        base: "", url: url_ZonesDelete_568251,
                                        schemes: {Scheme.Https})
type
  Call_RecordSetsListAll_568261 = ref object of OpenApiRestCall_567657
proc url_RecordSetsListAll_568263(protocol: Scheme; host: string; base: string;
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
        kind: ConstantSegment, value: "/providers/Microsoft.Network/dnszones/"),
               (kind: VariableSegment, value: "zoneName"),
               (kind: ConstantSegment, value: "/recordsets")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RecordSetsListAll_568262(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Lists all RecordSets in a DNS zone.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   zoneName: JString (required)
  ##           : The name of the zone from which to enumerate RecordSets.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568264 = path.getOrDefault("resourceGroupName")
  valid_568264 = validateParameter(valid_568264, JString, required = true,
                                 default = nil)
  if valid_568264 != nil:
    section.add "resourceGroupName", valid_568264
  var valid_568265 = path.getOrDefault("subscriptionId")
  valid_568265 = validateParameter(valid_568265, JString, required = true,
                                 default = nil)
  if valid_568265 != nil:
    section.add "subscriptionId", valid_568265
  var valid_568266 = path.getOrDefault("zoneName")
  valid_568266 = validateParameter(valid_568266, JString, required = true,
                                 default = nil)
  if valid_568266 != nil:
    section.add "zoneName", valid_568266
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  ##   $top: JString
  ##       : Query parameters. If null is passed returns the default number of zones.
  ##   $filter: JString
  ##          : The filter to apply on the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568267 = query.getOrDefault("api-version")
  valid_568267 = validateParameter(valid_568267, JString, required = true,
                                 default = nil)
  if valid_568267 != nil:
    section.add "api-version", valid_568267
  var valid_568268 = query.getOrDefault("$top")
  valid_568268 = validateParameter(valid_568268, JString, required = false,
                                 default = nil)
  if valid_568268 != nil:
    section.add "$top", valid_568268
  var valid_568269 = query.getOrDefault("$filter")
  valid_568269 = validateParameter(valid_568269, JString, required = false,
                                 default = nil)
  if valid_568269 != nil:
    section.add "$filter", valid_568269
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568270: Call_RecordSetsListAll_568261; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all RecordSets in a DNS zone.
  ## 
  let valid = call_568270.validator(path, query, header, formData, body)
  let scheme = call_568270.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568270.url(scheme.get, call_568270.host, call_568270.base,
                         call_568270.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568270, url, valid)

proc call*(call_568271: Call_RecordSetsListAll_568261; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; zoneName: string;
          Top: string = ""; Filter: string = ""): Recallable =
  ## recordSetsListAll
  ## Lists all RecordSets in a DNS zone.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   Top: string
  ##      : Query parameters. If null is passed returns the default number of zones.
  ##   zoneName: string (required)
  ##           : The name of the zone from which to enumerate RecordSets.
  ##   Filter: string
  ##         : The filter to apply on the operation.
  var path_568272 = newJObject()
  var query_568273 = newJObject()
  add(path_568272, "resourceGroupName", newJString(resourceGroupName))
  add(query_568273, "api-version", newJString(apiVersion))
  add(path_568272, "subscriptionId", newJString(subscriptionId))
  add(query_568273, "$top", newJString(Top))
  add(path_568272, "zoneName", newJString(zoneName))
  add(query_568273, "$filter", newJString(Filter))
  result = call_568271.call(path_568272, query_568273, nil, nil, nil)

var recordSetsListAll* = Call_RecordSetsListAll_568261(name: "recordSetsListAll",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/dnszones/{zoneName}/recordsets",
    validator: validate_RecordSetsListAll_568262, base: "",
    url: url_RecordSetsListAll_568263, schemes: {Scheme.Https})
type
  Call_RecordSetsList_568274 = ref object of OpenApiRestCall_567657
proc url_RecordSetsList_568276(protocol: Scheme; host: string; base: string;
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
        kind: ConstantSegment, value: "/providers/Microsoft.Network/dnszones/"),
               (kind: VariableSegment, value: "zoneName"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "recordType")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RecordSetsList_568275(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Lists the RecordSets of a specified type in a DNS zone.
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
  ##           : The name of the zone from which to enumerate RecordsSets.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568277 = path.getOrDefault("resourceGroupName")
  valid_568277 = validateParameter(valid_568277, JString, required = true,
                                 default = nil)
  if valid_568277 != nil:
    section.add "resourceGroupName", valid_568277
  var valid_568291 = path.getOrDefault("recordType")
  valid_568291 = validateParameter(valid_568291, JString, required = true,
                                 default = newJString("A"))
  if valid_568291 != nil:
    section.add "recordType", valid_568291
  var valid_568292 = path.getOrDefault("subscriptionId")
  valid_568292 = validateParameter(valid_568292, JString, required = true,
                                 default = nil)
  if valid_568292 != nil:
    section.add "subscriptionId", valid_568292
  var valid_568293 = path.getOrDefault("zoneName")
  valid_568293 = validateParameter(valid_568293, JString, required = true,
                                 default = nil)
  if valid_568293 != nil:
    section.add "zoneName", valid_568293
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  ##   $top: JString
  ##       : Query parameters. If null is passed returns the default number of zones.
  ##   $filter: JString
  ##          : The filter to apply on the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568294 = query.getOrDefault("api-version")
  valid_568294 = validateParameter(valid_568294, JString, required = true,
                                 default = nil)
  if valid_568294 != nil:
    section.add "api-version", valid_568294
  var valid_568295 = query.getOrDefault("$top")
  valid_568295 = validateParameter(valid_568295, JString, required = false,
                                 default = nil)
  if valid_568295 != nil:
    section.add "$top", valid_568295
  var valid_568296 = query.getOrDefault("$filter")
  valid_568296 = validateParameter(valid_568296, JString, required = false,
                                 default = nil)
  if valid_568296 != nil:
    section.add "$filter", valid_568296
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568297: Call_RecordSetsList_568274; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the RecordSets of a specified type in a DNS zone.
  ## 
  let valid = call_568297.validator(path, query, header, formData, body)
  let scheme = call_568297.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568297.url(scheme.get, call_568297.host, call_568297.base,
                         call_568297.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568297, url, valid)

proc call*(call_568298: Call_RecordSetsList_568274; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; zoneName: string;
          recordType: string = "A"; Top: string = ""; Filter: string = ""): Recallable =
  ## recordSetsList
  ## Lists the RecordSets of a specified type in a DNS zone.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   recordType: string (required)
  ##             : The type of record sets to enumerate.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   Top: string
  ##      : Query parameters. If null is passed returns the default number of zones.
  ##   zoneName: string (required)
  ##           : The name of the zone from which to enumerate RecordsSets.
  ##   Filter: string
  ##         : The filter to apply on the operation.
  var path_568299 = newJObject()
  var query_568300 = newJObject()
  add(path_568299, "resourceGroupName", newJString(resourceGroupName))
  add(query_568300, "api-version", newJString(apiVersion))
  add(path_568299, "recordType", newJString(recordType))
  add(path_568299, "subscriptionId", newJString(subscriptionId))
  add(query_568300, "$top", newJString(Top))
  add(path_568299, "zoneName", newJString(zoneName))
  add(query_568300, "$filter", newJString(Filter))
  result = call_568298.call(path_568299, query_568300, nil, nil, nil)

var recordSetsList* = Call_RecordSetsList_568274(name: "recordSetsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/dnszones/{zoneName}/{recordType}",
    validator: validate_RecordSetsList_568275, base: "", url: url_RecordSetsList_568276,
    schemes: {Scheme.Https})
type
  Call_RecordSetsCreateOrUpdate_568314 = ref object of OpenApiRestCall_567657
proc url_RecordSetsCreateOrUpdate_568316(protocol: Scheme; host: string;
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
        kind: ConstantSegment, value: "/providers/Microsoft.Network/dnszones/"),
               (kind: VariableSegment, value: "zoneName"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "recordType"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "relativeRecordSetName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RecordSetsCreateOrUpdate_568315(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a RecordSet within a DNS zone.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   recordType: JString (required)
  ##             : The type of DNS record.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   zoneName: JString (required)
  ##           : The name of the zone without a terminating dot.
  ##   relativeRecordSetName: JString (required)
  ##                        : The name of the RecordSet, relative to the name of the zone.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568317 = path.getOrDefault("resourceGroupName")
  valid_568317 = validateParameter(valid_568317, JString, required = true,
                                 default = nil)
  if valid_568317 != nil:
    section.add "resourceGroupName", valid_568317
  var valid_568318 = path.getOrDefault("recordType")
  valid_568318 = validateParameter(valid_568318, JString, required = true,
                                 default = newJString("A"))
  if valid_568318 != nil:
    section.add "recordType", valid_568318
  var valid_568319 = path.getOrDefault("subscriptionId")
  valid_568319 = validateParameter(valid_568319, JString, required = true,
                                 default = nil)
  if valid_568319 != nil:
    section.add "subscriptionId", valid_568319
  var valid_568320 = path.getOrDefault("zoneName")
  valid_568320 = validateParameter(valid_568320, JString, required = true,
                                 default = nil)
  if valid_568320 != nil:
    section.add "zoneName", valid_568320
  var valid_568321 = path.getOrDefault("relativeRecordSetName")
  valid_568321 = validateParameter(valid_568321, JString, required = true,
                                 default = nil)
  if valid_568321 != nil:
    section.add "relativeRecordSetName", valid_568321
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568322 = query.getOrDefault("api-version")
  valid_568322 = validateParameter(valid_568322, JString, required = true,
                                 default = nil)
  if valid_568322 != nil:
    section.add "api-version", valid_568322
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : The etag of RecordSet.
  ##   If-None-Match: JString
  ##                : Defines the If-None-Match condition. Set to '*' to force Create-If-Not-Exist. Other values will be ignored.
  section = newJObject()
  var valid_568323 = header.getOrDefault("If-Match")
  valid_568323 = validateParameter(valid_568323, JString, required = false,
                                 default = nil)
  if valid_568323 != nil:
    section.add "If-Match", valid_568323
  var valid_568324 = header.getOrDefault("If-None-Match")
  valid_568324 = validateParameter(valid_568324, JString, required = false,
                                 default = nil)
  if valid_568324 != nil:
    section.add "If-None-Match", valid_568324
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

proc call*(call_568326: Call_RecordSetsCreateOrUpdate_568314; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a RecordSet within a DNS zone.
  ## 
  let valid = call_568326.validator(path, query, header, formData, body)
  let scheme = call_568326.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568326.url(scheme.get, call_568326.host, call_568326.base,
                         call_568326.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568326, url, valid)

proc call*(call_568327: Call_RecordSetsCreateOrUpdate_568314;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          zoneName: string; parameters: JsonNode; relativeRecordSetName: string;
          recordType: string = "A"): Recallable =
  ## recordSetsCreateOrUpdate
  ## Creates a RecordSet within a DNS zone.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   recordType: string (required)
  ##             : The type of DNS record.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   zoneName: string (required)
  ##           : The name of the zone without a terminating dot.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the CreateOrUpdate operation.
  ##   relativeRecordSetName: string (required)
  ##                        : The name of the RecordSet, relative to the name of the zone.
  var path_568328 = newJObject()
  var query_568329 = newJObject()
  var body_568330 = newJObject()
  add(path_568328, "resourceGroupName", newJString(resourceGroupName))
  add(query_568329, "api-version", newJString(apiVersion))
  add(path_568328, "recordType", newJString(recordType))
  add(path_568328, "subscriptionId", newJString(subscriptionId))
  add(path_568328, "zoneName", newJString(zoneName))
  if parameters != nil:
    body_568330 = parameters
  add(path_568328, "relativeRecordSetName", newJString(relativeRecordSetName))
  result = call_568327.call(path_568328, query_568329, nil, nil, body_568330)

var recordSetsCreateOrUpdate* = Call_RecordSetsCreateOrUpdate_568314(
    name: "recordSetsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/dnszones/{zoneName}/{recordType}/{relativeRecordSetName}",
    validator: validate_RecordSetsCreateOrUpdate_568315, base: "",
    url: url_RecordSetsCreateOrUpdate_568316, schemes: {Scheme.Https})
type
  Call_RecordSetsGet_568301 = ref object of OpenApiRestCall_567657
proc url_RecordSetsGet_568303(protocol: Scheme; host: string; base: string;
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
        kind: ConstantSegment, value: "/providers/Microsoft.Network/dnszones/"),
               (kind: VariableSegment, value: "zoneName"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "recordType"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "relativeRecordSetName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RecordSetsGet_568302(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a RecordSet.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   recordType: JString (required)
  ##             : The type of DNS record.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   zoneName: JString (required)
  ##           : The name of the zone without a terminating dot.
  ##   relativeRecordSetName: JString (required)
  ##                        : The name of the RecordSet, relative to the name of the zone.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568304 = path.getOrDefault("resourceGroupName")
  valid_568304 = validateParameter(valid_568304, JString, required = true,
                                 default = nil)
  if valid_568304 != nil:
    section.add "resourceGroupName", valid_568304
  var valid_568305 = path.getOrDefault("recordType")
  valid_568305 = validateParameter(valid_568305, JString, required = true,
                                 default = newJString("A"))
  if valid_568305 != nil:
    section.add "recordType", valid_568305
  var valid_568306 = path.getOrDefault("subscriptionId")
  valid_568306 = validateParameter(valid_568306, JString, required = true,
                                 default = nil)
  if valid_568306 != nil:
    section.add "subscriptionId", valid_568306
  var valid_568307 = path.getOrDefault("zoneName")
  valid_568307 = validateParameter(valid_568307, JString, required = true,
                                 default = nil)
  if valid_568307 != nil:
    section.add "zoneName", valid_568307
  var valid_568308 = path.getOrDefault("relativeRecordSetName")
  valid_568308 = validateParameter(valid_568308, JString, required = true,
                                 default = nil)
  if valid_568308 != nil:
    section.add "relativeRecordSetName", valid_568308
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568309 = query.getOrDefault("api-version")
  valid_568309 = validateParameter(valid_568309, JString, required = true,
                                 default = nil)
  if valid_568309 != nil:
    section.add "api-version", valid_568309
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568310: Call_RecordSetsGet_568301; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a RecordSet.
  ## 
  let valid = call_568310.validator(path, query, header, formData, body)
  let scheme = call_568310.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568310.url(scheme.get, call_568310.host, call_568310.base,
                         call_568310.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568310, url, valid)

proc call*(call_568311: Call_RecordSetsGet_568301; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; zoneName: string;
          relativeRecordSetName: string; recordType: string = "A"): Recallable =
  ## recordSetsGet
  ## Gets a RecordSet.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   recordType: string (required)
  ##             : The type of DNS record.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   zoneName: string (required)
  ##           : The name of the zone without a terminating dot.
  ##   relativeRecordSetName: string (required)
  ##                        : The name of the RecordSet, relative to the name of the zone.
  var path_568312 = newJObject()
  var query_568313 = newJObject()
  add(path_568312, "resourceGroupName", newJString(resourceGroupName))
  add(query_568313, "api-version", newJString(apiVersion))
  add(path_568312, "recordType", newJString(recordType))
  add(path_568312, "subscriptionId", newJString(subscriptionId))
  add(path_568312, "zoneName", newJString(zoneName))
  add(path_568312, "relativeRecordSetName", newJString(relativeRecordSetName))
  result = call_568311.call(path_568312, query_568313, nil, nil, nil)

var recordSetsGet* = Call_RecordSetsGet_568301(name: "recordSetsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/dnszones/{zoneName}/{recordType}/{relativeRecordSetName}",
    validator: validate_RecordSetsGet_568302, base: "", url: url_RecordSetsGet_568303,
    schemes: {Scheme.Https})
type
  Call_RecordSetsDelete_568331 = ref object of OpenApiRestCall_567657
proc url_RecordSetsDelete_568333(protocol: Scheme; host: string; base: string;
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
        kind: ConstantSegment, value: "/providers/Microsoft.Network/dnszones/"),
               (kind: VariableSegment, value: "zoneName"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "recordType"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "relativeRecordSetName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RecordSetsDelete_568332(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Removes a RecordSet from a DNS zone.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   recordType: JString (required)
  ##             : The type of DNS record.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   zoneName: JString (required)
  ##           : The name of the zone without a terminating dot.
  ##   relativeRecordSetName: JString (required)
  ##                        : The name of the RecordSet, relative to the name of the zone.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568334 = path.getOrDefault("resourceGroupName")
  valid_568334 = validateParameter(valid_568334, JString, required = true,
                                 default = nil)
  if valid_568334 != nil:
    section.add "resourceGroupName", valid_568334
  var valid_568335 = path.getOrDefault("recordType")
  valid_568335 = validateParameter(valid_568335, JString, required = true,
                                 default = newJString("A"))
  if valid_568335 != nil:
    section.add "recordType", valid_568335
  var valid_568336 = path.getOrDefault("subscriptionId")
  valid_568336 = validateParameter(valid_568336, JString, required = true,
                                 default = nil)
  if valid_568336 != nil:
    section.add "subscriptionId", valid_568336
  var valid_568337 = path.getOrDefault("zoneName")
  valid_568337 = validateParameter(valid_568337, JString, required = true,
                                 default = nil)
  if valid_568337 != nil:
    section.add "zoneName", valid_568337
  var valid_568338 = path.getOrDefault("relativeRecordSetName")
  valid_568338 = validateParameter(valid_568338, JString, required = true,
                                 default = nil)
  if valid_568338 != nil:
    section.add "relativeRecordSetName", valid_568338
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568339 = query.getOrDefault("api-version")
  valid_568339 = validateParameter(valid_568339, JString, required = true,
                                 default = nil)
  if valid_568339 != nil:
    section.add "api-version", valid_568339
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : Defines the If-Match condition. The delete operation will be performed only if the ETag of the zone on the server matches this value.
  section = newJObject()
  var valid_568340 = header.getOrDefault("If-Match")
  valid_568340 = validateParameter(valid_568340, JString, required = false,
                                 default = nil)
  if valid_568340 != nil:
    section.add "If-Match", valid_568340
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568341: Call_RecordSetsDelete_568331; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Removes a RecordSet from a DNS zone.
  ## 
  let valid = call_568341.validator(path, query, header, formData, body)
  let scheme = call_568341.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568341.url(scheme.get, call_568341.host, call_568341.base,
                         call_568341.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568341, url, valid)

proc call*(call_568342: Call_RecordSetsDelete_568331; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; zoneName: string;
          relativeRecordSetName: string; recordType: string = "A"): Recallable =
  ## recordSetsDelete
  ## Removes a RecordSet from a DNS zone.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   recordType: string (required)
  ##             : The type of DNS record.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   zoneName: string (required)
  ##           : The name of the zone without a terminating dot.
  ##   relativeRecordSetName: string (required)
  ##                        : The name of the RecordSet, relative to the name of the zone.
  var path_568343 = newJObject()
  var query_568344 = newJObject()
  add(path_568343, "resourceGroupName", newJString(resourceGroupName))
  add(query_568344, "api-version", newJString(apiVersion))
  add(path_568343, "recordType", newJString(recordType))
  add(path_568343, "subscriptionId", newJString(subscriptionId))
  add(path_568343, "zoneName", newJString(zoneName))
  add(path_568343, "relativeRecordSetName", newJString(relativeRecordSetName))
  result = call_568342.call(path_568343, query_568344, nil, nil, nil)

var recordSetsDelete* = Call_RecordSetsDelete_568331(name: "recordSetsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/dnszones/{zoneName}/{recordType}/{relativeRecordSetName}",
    validator: validate_RecordSetsDelete_568332, base: "",
    url: url_RecordSetsDelete_568333, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
