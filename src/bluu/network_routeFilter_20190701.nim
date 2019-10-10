
import
  json, options, hashes, uri, rest, os, uri, httpcore

## auto-generated via openapi macro
## title: NetworkManagementClient
## version: 2019-07-01
## termsOfService: (not provided)
## license: (not provided)
## 
## The Microsoft Azure Network management API provides a RESTful set of web services that interact with Microsoft Azure Networks service to manage your network resources. The API has entities that capture the relationship between an end user and the Microsoft Azure Networks service.
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

  OpenApiRestCall_573657 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_573657](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_573657): Option[Scheme] {.used.} =
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
  macServiceName = "network-routeFilter"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_RouteFiltersList_573879 = ref object of OpenApiRestCall_573657
proc url_RouteFiltersList_573881(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Network/routeFilters")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RouteFiltersList_573880(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Gets all route filters in a subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_574041 = path.getOrDefault("subscriptionId")
  valid_574041 = validateParameter(valid_574041, JString, required = true,
                                 default = nil)
  if valid_574041 != nil:
    section.add "subscriptionId", valid_574041
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574042 = query.getOrDefault("api-version")
  valid_574042 = validateParameter(valid_574042, JString, required = true,
                                 default = nil)
  if valid_574042 != nil:
    section.add "api-version", valid_574042
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574069: Call_RouteFiltersList_573879; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all route filters in a subscription.
  ## 
  let valid = call_574069.validator(path, query, header, formData, body)
  let scheme = call_574069.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574069.url(scheme.get, call_574069.host, call_574069.base,
                         call_574069.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574069, url, valid)

proc call*(call_574140: Call_RouteFiltersList_573879; apiVersion: string;
          subscriptionId: string): Recallable =
  ## routeFiltersList
  ## Gets all route filters in a subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_574141 = newJObject()
  var query_574143 = newJObject()
  add(query_574143, "api-version", newJString(apiVersion))
  add(path_574141, "subscriptionId", newJString(subscriptionId))
  result = call_574140.call(path_574141, query_574143, nil, nil, nil)

var routeFiltersList* = Call_RouteFiltersList_573879(name: "routeFiltersList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Network/routeFilters",
    validator: validate_RouteFiltersList_573880, base: "",
    url: url_RouteFiltersList_573881, schemes: {Scheme.Https})
type
  Call_RouteFiltersListByResourceGroup_574182 = ref object of OpenApiRestCall_573657
proc url_RouteFiltersListByResourceGroup_574184(protocol: Scheme; host: string;
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
        kind: ConstantSegment, value: "/providers/Microsoft.Network/routeFilters")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RouteFiltersListByResourceGroup_574183(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all route filters in a resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574185 = path.getOrDefault("resourceGroupName")
  valid_574185 = validateParameter(valid_574185, JString, required = true,
                                 default = nil)
  if valid_574185 != nil:
    section.add "resourceGroupName", valid_574185
  var valid_574186 = path.getOrDefault("subscriptionId")
  valid_574186 = validateParameter(valid_574186, JString, required = true,
                                 default = nil)
  if valid_574186 != nil:
    section.add "subscriptionId", valid_574186
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574187 = query.getOrDefault("api-version")
  valid_574187 = validateParameter(valid_574187, JString, required = true,
                                 default = nil)
  if valid_574187 != nil:
    section.add "api-version", valid_574187
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574188: Call_RouteFiltersListByResourceGroup_574182;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets all route filters in a resource group.
  ## 
  let valid = call_574188.validator(path, query, header, formData, body)
  let scheme = call_574188.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574188.url(scheme.get, call_574188.host, call_574188.base,
                         call_574188.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574188, url, valid)

proc call*(call_574189: Call_RouteFiltersListByResourceGroup_574182;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## routeFiltersListByResourceGroup
  ## Gets all route filters in a resource group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_574190 = newJObject()
  var query_574191 = newJObject()
  add(path_574190, "resourceGroupName", newJString(resourceGroupName))
  add(query_574191, "api-version", newJString(apiVersion))
  add(path_574190, "subscriptionId", newJString(subscriptionId))
  result = call_574189.call(path_574190, query_574191, nil, nil, nil)

var routeFiltersListByResourceGroup* = Call_RouteFiltersListByResourceGroup_574182(
    name: "routeFiltersListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/routeFilters",
    validator: validate_RouteFiltersListByResourceGroup_574183, base: "",
    url: url_RouteFiltersListByResourceGroup_574184, schemes: {Scheme.Https})
type
  Call_RouteFiltersCreateOrUpdate_574205 = ref object of OpenApiRestCall_573657
proc url_RouteFiltersCreateOrUpdate_574207(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "routeFilterName" in path, "`routeFilterName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Network/routeFilters/"),
               (kind: VariableSegment, value: "routeFilterName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RouteFiltersCreateOrUpdate_574206(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates a route filter in a specified resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   routeFilterName: JString (required)
  ##                  : The name of the route filter.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574234 = path.getOrDefault("resourceGroupName")
  valid_574234 = validateParameter(valid_574234, JString, required = true,
                                 default = nil)
  if valid_574234 != nil:
    section.add "resourceGroupName", valid_574234
  var valid_574235 = path.getOrDefault("subscriptionId")
  valid_574235 = validateParameter(valid_574235, JString, required = true,
                                 default = nil)
  if valid_574235 != nil:
    section.add "subscriptionId", valid_574235
  var valid_574236 = path.getOrDefault("routeFilterName")
  valid_574236 = validateParameter(valid_574236, JString, required = true,
                                 default = nil)
  if valid_574236 != nil:
    section.add "routeFilterName", valid_574236
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574237 = query.getOrDefault("api-version")
  valid_574237 = validateParameter(valid_574237, JString, required = true,
                                 default = nil)
  if valid_574237 != nil:
    section.add "api-version", valid_574237
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   routeFilterParameters: JObject (required)
  ##                        : Parameters supplied to the create or update route filter operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_574239: Call_RouteFiltersCreateOrUpdate_574205; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates a route filter in a specified resource group.
  ## 
  let valid = call_574239.validator(path, query, header, formData, body)
  let scheme = call_574239.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574239.url(scheme.get, call_574239.host, call_574239.base,
                         call_574239.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574239, url, valid)

proc call*(call_574240: Call_RouteFiltersCreateOrUpdate_574205;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          routeFilterParameters: JsonNode; routeFilterName: string): Recallable =
  ## routeFiltersCreateOrUpdate
  ## Creates or updates a route filter in a specified resource group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   routeFilterParameters: JObject (required)
  ##                        : Parameters supplied to the create or update route filter operation.
  ##   routeFilterName: string (required)
  ##                  : The name of the route filter.
  var path_574241 = newJObject()
  var query_574242 = newJObject()
  var body_574243 = newJObject()
  add(path_574241, "resourceGroupName", newJString(resourceGroupName))
  add(query_574242, "api-version", newJString(apiVersion))
  add(path_574241, "subscriptionId", newJString(subscriptionId))
  if routeFilterParameters != nil:
    body_574243 = routeFilterParameters
  add(path_574241, "routeFilterName", newJString(routeFilterName))
  result = call_574240.call(path_574241, query_574242, nil, nil, body_574243)

var routeFiltersCreateOrUpdate* = Call_RouteFiltersCreateOrUpdate_574205(
    name: "routeFiltersCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/routeFilters/{routeFilterName}",
    validator: validate_RouteFiltersCreateOrUpdate_574206, base: "",
    url: url_RouteFiltersCreateOrUpdate_574207, schemes: {Scheme.Https})
type
  Call_RouteFiltersGet_574192 = ref object of OpenApiRestCall_573657
proc url_RouteFiltersGet_574194(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "routeFilterName" in path, "`routeFilterName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Network/routeFilters/"),
               (kind: VariableSegment, value: "routeFilterName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RouteFiltersGet_574193(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Gets the specified route filter.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   routeFilterName: JString (required)
  ##                  : The name of the route filter.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574196 = path.getOrDefault("resourceGroupName")
  valid_574196 = validateParameter(valid_574196, JString, required = true,
                                 default = nil)
  if valid_574196 != nil:
    section.add "resourceGroupName", valid_574196
  var valid_574197 = path.getOrDefault("subscriptionId")
  valid_574197 = validateParameter(valid_574197, JString, required = true,
                                 default = nil)
  if valid_574197 != nil:
    section.add "subscriptionId", valid_574197
  var valid_574198 = path.getOrDefault("routeFilterName")
  valid_574198 = validateParameter(valid_574198, JString, required = true,
                                 default = nil)
  if valid_574198 != nil:
    section.add "routeFilterName", valid_574198
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $expand: JString
  ##          : Expands referenced express route bgp peering resources.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574199 = query.getOrDefault("api-version")
  valid_574199 = validateParameter(valid_574199, JString, required = true,
                                 default = nil)
  if valid_574199 != nil:
    section.add "api-version", valid_574199
  var valid_574200 = query.getOrDefault("$expand")
  valid_574200 = validateParameter(valid_574200, JString, required = false,
                                 default = nil)
  if valid_574200 != nil:
    section.add "$expand", valid_574200
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574201: Call_RouteFiltersGet_574192; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the specified route filter.
  ## 
  let valid = call_574201.validator(path, query, header, formData, body)
  let scheme = call_574201.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574201.url(scheme.get, call_574201.host, call_574201.base,
                         call_574201.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574201, url, valid)

proc call*(call_574202: Call_RouteFiltersGet_574192; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; routeFilterName: string;
          Expand: string = ""): Recallable =
  ## routeFiltersGet
  ## Gets the specified route filter.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   Expand: string
  ##         : Expands referenced express route bgp peering resources.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   routeFilterName: string (required)
  ##                  : The name of the route filter.
  var path_574203 = newJObject()
  var query_574204 = newJObject()
  add(path_574203, "resourceGroupName", newJString(resourceGroupName))
  add(query_574204, "api-version", newJString(apiVersion))
  add(query_574204, "$expand", newJString(Expand))
  add(path_574203, "subscriptionId", newJString(subscriptionId))
  add(path_574203, "routeFilterName", newJString(routeFilterName))
  result = call_574202.call(path_574203, query_574204, nil, nil, nil)

var routeFiltersGet* = Call_RouteFiltersGet_574192(name: "routeFiltersGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/routeFilters/{routeFilterName}",
    validator: validate_RouteFiltersGet_574193, base: "", url: url_RouteFiltersGet_574194,
    schemes: {Scheme.Https})
type
  Call_RouteFiltersUpdate_574255 = ref object of OpenApiRestCall_573657
proc url_RouteFiltersUpdate_574257(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "routeFilterName" in path, "`routeFilterName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Network/routeFilters/"),
               (kind: VariableSegment, value: "routeFilterName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RouteFiltersUpdate_574256(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Updates a route filter in a specified resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   routeFilterName: JString (required)
  ##                  : The name of the route filter.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574258 = path.getOrDefault("resourceGroupName")
  valid_574258 = validateParameter(valid_574258, JString, required = true,
                                 default = nil)
  if valid_574258 != nil:
    section.add "resourceGroupName", valid_574258
  var valid_574259 = path.getOrDefault("subscriptionId")
  valid_574259 = validateParameter(valid_574259, JString, required = true,
                                 default = nil)
  if valid_574259 != nil:
    section.add "subscriptionId", valid_574259
  var valid_574260 = path.getOrDefault("routeFilterName")
  valid_574260 = validateParameter(valid_574260, JString, required = true,
                                 default = nil)
  if valid_574260 != nil:
    section.add "routeFilterName", valid_574260
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574261 = query.getOrDefault("api-version")
  valid_574261 = validateParameter(valid_574261, JString, required = true,
                                 default = nil)
  if valid_574261 != nil:
    section.add "api-version", valid_574261
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   routeFilterParameters: JObject (required)
  ##                        : Parameters supplied to the update route filter operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_574263: Call_RouteFiltersUpdate_574255; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a route filter in a specified resource group.
  ## 
  let valid = call_574263.validator(path, query, header, formData, body)
  let scheme = call_574263.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574263.url(scheme.get, call_574263.host, call_574263.base,
                         call_574263.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574263, url, valid)

proc call*(call_574264: Call_RouteFiltersUpdate_574255; resourceGroupName: string;
          apiVersion: string; subscriptionId: string;
          routeFilterParameters: JsonNode; routeFilterName: string): Recallable =
  ## routeFiltersUpdate
  ## Updates a route filter in a specified resource group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   routeFilterParameters: JObject (required)
  ##                        : Parameters supplied to the update route filter operation.
  ##   routeFilterName: string (required)
  ##                  : The name of the route filter.
  var path_574265 = newJObject()
  var query_574266 = newJObject()
  var body_574267 = newJObject()
  add(path_574265, "resourceGroupName", newJString(resourceGroupName))
  add(query_574266, "api-version", newJString(apiVersion))
  add(path_574265, "subscriptionId", newJString(subscriptionId))
  if routeFilterParameters != nil:
    body_574267 = routeFilterParameters
  add(path_574265, "routeFilterName", newJString(routeFilterName))
  result = call_574264.call(path_574265, query_574266, nil, nil, body_574267)

var routeFiltersUpdate* = Call_RouteFiltersUpdate_574255(
    name: "routeFiltersUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/routeFilters/{routeFilterName}",
    validator: validate_RouteFiltersUpdate_574256, base: "",
    url: url_RouteFiltersUpdate_574257, schemes: {Scheme.Https})
type
  Call_RouteFiltersDelete_574244 = ref object of OpenApiRestCall_573657
proc url_RouteFiltersDelete_574246(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "routeFilterName" in path, "`routeFilterName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Network/routeFilters/"),
               (kind: VariableSegment, value: "routeFilterName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RouteFiltersDelete_574245(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Deletes the specified route filter.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   routeFilterName: JString (required)
  ##                  : The name of the route filter.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574247 = path.getOrDefault("resourceGroupName")
  valid_574247 = validateParameter(valid_574247, JString, required = true,
                                 default = nil)
  if valid_574247 != nil:
    section.add "resourceGroupName", valid_574247
  var valid_574248 = path.getOrDefault("subscriptionId")
  valid_574248 = validateParameter(valid_574248, JString, required = true,
                                 default = nil)
  if valid_574248 != nil:
    section.add "subscriptionId", valid_574248
  var valid_574249 = path.getOrDefault("routeFilterName")
  valid_574249 = validateParameter(valid_574249, JString, required = true,
                                 default = nil)
  if valid_574249 != nil:
    section.add "routeFilterName", valid_574249
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574250 = query.getOrDefault("api-version")
  valid_574250 = validateParameter(valid_574250, JString, required = true,
                                 default = nil)
  if valid_574250 != nil:
    section.add "api-version", valid_574250
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574251: Call_RouteFiltersDelete_574244; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified route filter.
  ## 
  let valid = call_574251.validator(path, query, header, formData, body)
  let scheme = call_574251.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574251.url(scheme.get, call_574251.host, call_574251.base,
                         call_574251.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574251, url, valid)

proc call*(call_574252: Call_RouteFiltersDelete_574244; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; routeFilterName: string): Recallable =
  ## routeFiltersDelete
  ## Deletes the specified route filter.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   routeFilterName: string (required)
  ##                  : The name of the route filter.
  var path_574253 = newJObject()
  var query_574254 = newJObject()
  add(path_574253, "resourceGroupName", newJString(resourceGroupName))
  add(query_574254, "api-version", newJString(apiVersion))
  add(path_574253, "subscriptionId", newJString(subscriptionId))
  add(path_574253, "routeFilterName", newJString(routeFilterName))
  result = call_574252.call(path_574253, query_574254, nil, nil, nil)

var routeFiltersDelete* = Call_RouteFiltersDelete_574244(
    name: "routeFiltersDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/routeFilters/{routeFilterName}",
    validator: validate_RouteFiltersDelete_574245, base: "",
    url: url_RouteFiltersDelete_574246, schemes: {Scheme.Https})
type
  Call_RouteFilterRulesListByRouteFilter_574268 = ref object of OpenApiRestCall_573657
proc url_RouteFilterRulesListByRouteFilter_574270(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "routeFilterName" in path, "`routeFilterName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Network/routeFilters/"),
               (kind: VariableSegment, value: "routeFilterName"),
               (kind: ConstantSegment, value: "/routeFilterRules")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RouteFilterRulesListByRouteFilter_574269(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all RouteFilterRules in a route filter.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   routeFilterName: JString (required)
  ##                  : The name of the route filter.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574271 = path.getOrDefault("resourceGroupName")
  valid_574271 = validateParameter(valid_574271, JString, required = true,
                                 default = nil)
  if valid_574271 != nil:
    section.add "resourceGroupName", valid_574271
  var valid_574272 = path.getOrDefault("subscriptionId")
  valid_574272 = validateParameter(valid_574272, JString, required = true,
                                 default = nil)
  if valid_574272 != nil:
    section.add "subscriptionId", valid_574272
  var valid_574273 = path.getOrDefault("routeFilterName")
  valid_574273 = validateParameter(valid_574273, JString, required = true,
                                 default = nil)
  if valid_574273 != nil:
    section.add "routeFilterName", valid_574273
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574274 = query.getOrDefault("api-version")
  valid_574274 = validateParameter(valid_574274, JString, required = true,
                                 default = nil)
  if valid_574274 != nil:
    section.add "api-version", valid_574274
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574275: Call_RouteFilterRulesListByRouteFilter_574268;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets all RouteFilterRules in a route filter.
  ## 
  let valid = call_574275.validator(path, query, header, formData, body)
  let scheme = call_574275.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574275.url(scheme.get, call_574275.host, call_574275.base,
                         call_574275.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574275, url, valid)

proc call*(call_574276: Call_RouteFilterRulesListByRouteFilter_574268;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          routeFilterName: string): Recallable =
  ## routeFilterRulesListByRouteFilter
  ## Gets all RouteFilterRules in a route filter.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   routeFilterName: string (required)
  ##                  : The name of the route filter.
  var path_574277 = newJObject()
  var query_574278 = newJObject()
  add(path_574277, "resourceGroupName", newJString(resourceGroupName))
  add(query_574278, "api-version", newJString(apiVersion))
  add(path_574277, "subscriptionId", newJString(subscriptionId))
  add(path_574277, "routeFilterName", newJString(routeFilterName))
  result = call_574276.call(path_574277, query_574278, nil, nil, nil)

var routeFilterRulesListByRouteFilter* = Call_RouteFilterRulesListByRouteFilter_574268(
    name: "routeFilterRulesListByRouteFilter", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/routeFilters/{routeFilterName}/routeFilterRules",
    validator: validate_RouteFilterRulesListByRouteFilter_574269, base: "",
    url: url_RouteFilterRulesListByRouteFilter_574270, schemes: {Scheme.Https})
type
  Call_RouteFilterRulesCreateOrUpdate_574291 = ref object of OpenApiRestCall_573657
proc url_RouteFilterRulesCreateOrUpdate_574293(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "routeFilterName" in path, "`routeFilterName` is a required path parameter"
  assert "ruleName" in path, "`ruleName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Network/routeFilters/"),
               (kind: VariableSegment, value: "routeFilterName"),
               (kind: ConstantSegment, value: "/routeFilterRules/"),
               (kind: VariableSegment, value: "ruleName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RouteFilterRulesCreateOrUpdate_574292(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates a route in the specified route filter.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   ruleName: JString (required)
  ##           : The name of the route filter rule.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   routeFilterName: JString (required)
  ##                  : The name of the route filter.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574294 = path.getOrDefault("resourceGroupName")
  valid_574294 = validateParameter(valid_574294, JString, required = true,
                                 default = nil)
  if valid_574294 != nil:
    section.add "resourceGroupName", valid_574294
  var valid_574295 = path.getOrDefault("ruleName")
  valid_574295 = validateParameter(valid_574295, JString, required = true,
                                 default = nil)
  if valid_574295 != nil:
    section.add "ruleName", valid_574295
  var valid_574296 = path.getOrDefault("subscriptionId")
  valid_574296 = validateParameter(valid_574296, JString, required = true,
                                 default = nil)
  if valid_574296 != nil:
    section.add "subscriptionId", valid_574296
  var valid_574297 = path.getOrDefault("routeFilterName")
  valid_574297 = validateParameter(valid_574297, JString, required = true,
                                 default = nil)
  if valid_574297 != nil:
    section.add "routeFilterName", valid_574297
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574298 = query.getOrDefault("api-version")
  valid_574298 = validateParameter(valid_574298, JString, required = true,
                                 default = nil)
  if valid_574298 != nil:
    section.add "api-version", valid_574298
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   routeFilterRuleParameters: JObject (required)
  ##                            : Parameters supplied to the create or update route filter rule operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_574300: Call_RouteFilterRulesCreateOrUpdate_574291; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates a route in the specified route filter.
  ## 
  let valid = call_574300.validator(path, query, header, formData, body)
  let scheme = call_574300.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574300.url(scheme.get, call_574300.host, call_574300.base,
                         call_574300.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574300, url, valid)

proc call*(call_574301: Call_RouteFilterRulesCreateOrUpdate_574291;
          routeFilterRuleParameters: JsonNode; resourceGroupName: string;
          apiVersion: string; ruleName: string; subscriptionId: string;
          routeFilterName: string): Recallable =
  ## routeFilterRulesCreateOrUpdate
  ## Creates or updates a route in the specified route filter.
  ##   routeFilterRuleParameters: JObject (required)
  ##                            : Parameters supplied to the create or update route filter rule operation.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   ruleName: string (required)
  ##           : The name of the route filter rule.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   routeFilterName: string (required)
  ##                  : The name of the route filter.
  var path_574302 = newJObject()
  var query_574303 = newJObject()
  var body_574304 = newJObject()
  if routeFilterRuleParameters != nil:
    body_574304 = routeFilterRuleParameters
  add(path_574302, "resourceGroupName", newJString(resourceGroupName))
  add(query_574303, "api-version", newJString(apiVersion))
  add(path_574302, "ruleName", newJString(ruleName))
  add(path_574302, "subscriptionId", newJString(subscriptionId))
  add(path_574302, "routeFilterName", newJString(routeFilterName))
  result = call_574301.call(path_574302, query_574303, nil, nil, body_574304)

var routeFilterRulesCreateOrUpdate* = Call_RouteFilterRulesCreateOrUpdate_574291(
    name: "routeFilterRulesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/routeFilters/{routeFilterName}/routeFilterRules/{ruleName}",
    validator: validate_RouteFilterRulesCreateOrUpdate_574292, base: "",
    url: url_RouteFilterRulesCreateOrUpdate_574293, schemes: {Scheme.Https})
type
  Call_RouteFilterRulesGet_574279 = ref object of OpenApiRestCall_573657
proc url_RouteFilterRulesGet_574281(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "routeFilterName" in path, "`routeFilterName` is a required path parameter"
  assert "ruleName" in path, "`ruleName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Network/routeFilters/"),
               (kind: VariableSegment, value: "routeFilterName"),
               (kind: ConstantSegment, value: "/routeFilterRules/"),
               (kind: VariableSegment, value: "ruleName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RouteFilterRulesGet_574280(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Gets the specified rule from a route filter.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   ruleName: JString (required)
  ##           : The name of the rule.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   routeFilterName: JString (required)
  ##                  : The name of the route filter.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574282 = path.getOrDefault("resourceGroupName")
  valid_574282 = validateParameter(valid_574282, JString, required = true,
                                 default = nil)
  if valid_574282 != nil:
    section.add "resourceGroupName", valid_574282
  var valid_574283 = path.getOrDefault("ruleName")
  valid_574283 = validateParameter(valid_574283, JString, required = true,
                                 default = nil)
  if valid_574283 != nil:
    section.add "ruleName", valid_574283
  var valid_574284 = path.getOrDefault("subscriptionId")
  valid_574284 = validateParameter(valid_574284, JString, required = true,
                                 default = nil)
  if valid_574284 != nil:
    section.add "subscriptionId", valid_574284
  var valid_574285 = path.getOrDefault("routeFilterName")
  valid_574285 = validateParameter(valid_574285, JString, required = true,
                                 default = nil)
  if valid_574285 != nil:
    section.add "routeFilterName", valid_574285
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574286 = query.getOrDefault("api-version")
  valid_574286 = validateParameter(valid_574286, JString, required = true,
                                 default = nil)
  if valid_574286 != nil:
    section.add "api-version", valid_574286
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574287: Call_RouteFilterRulesGet_574279; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the specified rule from a route filter.
  ## 
  let valid = call_574287.validator(path, query, header, formData, body)
  let scheme = call_574287.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574287.url(scheme.get, call_574287.host, call_574287.base,
                         call_574287.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574287, url, valid)

proc call*(call_574288: Call_RouteFilterRulesGet_574279; resourceGroupName: string;
          apiVersion: string; ruleName: string; subscriptionId: string;
          routeFilterName: string): Recallable =
  ## routeFilterRulesGet
  ## Gets the specified rule from a route filter.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   ruleName: string (required)
  ##           : The name of the rule.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   routeFilterName: string (required)
  ##                  : The name of the route filter.
  var path_574289 = newJObject()
  var query_574290 = newJObject()
  add(path_574289, "resourceGroupName", newJString(resourceGroupName))
  add(query_574290, "api-version", newJString(apiVersion))
  add(path_574289, "ruleName", newJString(ruleName))
  add(path_574289, "subscriptionId", newJString(subscriptionId))
  add(path_574289, "routeFilterName", newJString(routeFilterName))
  result = call_574288.call(path_574289, query_574290, nil, nil, nil)

var routeFilterRulesGet* = Call_RouteFilterRulesGet_574279(
    name: "routeFilterRulesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/routeFilters/{routeFilterName}/routeFilterRules/{ruleName}",
    validator: validate_RouteFilterRulesGet_574280, base: "",
    url: url_RouteFilterRulesGet_574281, schemes: {Scheme.Https})
type
  Call_RouteFilterRulesUpdate_574317 = ref object of OpenApiRestCall_573657
proc url_RouteFilterRulesUpdate_574319(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "routeFilterName" in path, "`routeFilterName` is a required path parameter"
  assert "ruleName" in path, "`ruleName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Network/routeFilters/"),
               (kind: VariableSegment, value: "routeFilterName"),
               (kind: ConstantSegment, value: "/routeFilterRules/"),
               (kind: VariableSegment, value: "ruleName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RouteFilterRulesUpdate_574318(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates a route in the specified route filter.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   ruleName: JString (required)
  ##           : The name of the route filter rule.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   routeFilterName: JString (required)
  ##                  : The name of the route filter.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574320 = path.getOrDefault("resourceGroupName")
  valid_574320 = validateParameter(valid_574320, JString, required = true,
                                 default = nil)
  if valid_574320 != nil:
    section.add "resourceGroupName", valid_574320
  var valid_574321 = path.getOrDefault("ruleName")
  valid_574321 = validateParameter(valid_574321, JString, required = true,
                                 default = nil)
  if valid_574321 != nil:
    section.add "ruleName", valid_574321
  var valid_574322 = path.getOrDefault("subscriptionId")
  valid_574322 = validateParameter(valid_574322, JString, required = true,
                                 default = nil)
  if valid_574322 != nil:
    section.add "subscriptionId", valid_574322
  var valid_574323 = path.getOrDefault("routeFilterName")
  valid_574323 = validateParameter(valid_574323, JString, required = true,
                                 default = nil)
  if valid_574323 != nil:
    section.add "routeFilterName", valid_574323
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574324 = query.getOrDefault("api-version")
  valid_574324 = validateParameter(valid_574324, JString, required = true,
                                 default = nil)
  if valid_574324 != nil:
    section.add "api-version", valid_574324
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   routeFilterRuleParameters: JObject (required)
  ##                            : Parameters supplied to the update route filter rule operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_574326: Call_RouteFilterRulesUpdate_574317; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a route in the specified route filter.
  ## 
  let valid = call_574326.validator(path, query, header, formData, body)
  let scheme = call_574326.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574326.url(scheme.get, call_574326.host, call_574326.base,
                         call_574326.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574326, url, valid)

proc call*(call_574327: Call_RouteFilterRulesUpdate_574317;
          routeFilterRuleParameters: JsonNode; resourceGroupName: string;
          apiVersion: string; ruleName: string; subscriptionId: string;
          routeFilterName: string): Recallable =
  ## routeFilterRulesUpdate
  ## Updates a route in the specified route filter.
  ##   routeFilterRuleParameters: JObject (required)
  ##                            : Parameters supplied to the update route filter rule operation.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   ruleName: string (required)
  ##           : The name of the route filter rule.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   routeFilterName: string (required)
  ##                  : The name of the route filter.
  var path_574328 = newJObject()
  var query_574329 = newJObject()
  var body_574330 = newJObject()
  if routeFilterRuleParameters != nil:
    body_574330 = routeFilterRuleParameters
  add(path_574328, "resourceGroupName", newJString(resourceGroupName))
  add(query_574329, "api-version", newJString(apiVersion))
  add(path_574328, "ruleName", newJString(ruleName))
  add(path_574328, "subscriptionId", newJString(subscriptionId))
  add(path_574328, "routeFilterName", newJString(routeFilterName))
  result = call_574327.call(path_574328, query_574329, nil, nil, body_574330)

var routeFilterRulesUpdate* = Call_RouteFilterRulesUpdate_574317(
    name: "routeFilterRulesUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/routeFilters/{routeFilterName}/routeFilterRules/{ruleName}",
    validator: validate_RouteFilterRulesUpdate_574318, base: "",
    url: url_RouteFilterRulesUpdate_574319, schemes: {Scheme.Https})
type
  Call_RouteFilterRulesDelete_574305 = ref object of OpenApiRestCall_573657
proc url_RouteFilterRulesDelete_574307(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "routeFilterName" in path, "`routeFilterName` is a required path parameter"
  assert "ruleName" in path, "`ruleName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Network/routeFilters/"),
               (kind: VariableSegment, value: "routeFilterName"),
               (kind: ConstantSegment, value: "/routeFilterRules/"),
               (kind: VariableSegment, value: "ruleName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RouteFilterRulesDelete_574306(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the specified rule from a route filter.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   ruleName: JString (required)
  ##           : The name of the rule.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   routeFilterName: JString (required)
  ##                  : The name of the route filter.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574308 = path.getOrDefault("resourceGroupName")
  valid_574308 = validateParameter(valid_574308, JString, required = true,
                                 default = nil)
  if valid_574308 != nil:
    section.add "resourceGroupName", valid_574308
  var valid_574309 = path.getOrDefault("ruleName")
  valid_574309 = validateParameter(valid_574309, JString, required = true,
                                 default = nil)
  if valid_574309 != nil:
    section.add "ruleName", valid_574309
  var valid_574310 = path.getOrDefault("subscriptionId")
  valid_574310 = validateParameter(valid_574310, JString, required = true,
                                 default = nil)
  if valid_574310 != nil:
    section.add "subscriptionId", valid_574310
  var valid_574311 = path.getOrDefault("routeFilterName")
  valid_574311 = validateParameter(valid_574311, JString, required = true,
                                 default = nil)
  if valid_574311 != nil:
    section.add "routeFilterName", valid_574311
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574312 = query.getOrDefault("api-version")
  valid_574312 = validateParameter(valid_574312, JString, required = true,
                                 default = nil)
  if valid_574312 != nil:
    section.add "api-version", valid_574312
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574313: Call_RouteFilterRulesDelete_574305; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified rule from a route filter.
  ## 
  let valid = call_574313.validator(path, query, header, formData, body)
  let scheme = call_574313.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574313.url(scheme.get, call_574313.host, call_574313.base,
                         call_574313.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574313, url, valid)

proc call*(call_574314: Call_RouteFilterRulesDelete_574305;
          resourceGroupName: string; apiVersion: string; ruleName: string;
          subscriptionId: string; routeFilterName: string): Recallable =
  ## routeFilterRulesDelete
  ## Deletes the specified rule from a route filter.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   ruleName: string (required)
  ##           : The name of the rule.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   routeFilterName: string (required)
  ##                  : The name of the route filter.
  var path_574315 = newJObject()
  var query_574316 = newJObject()
  add(path_574315, "resourceGroupName", newJString(resourceGroupName))
  add(query_574316, "api-version", newJString(apiVersion))
  add(path_574315, "ruleName", newJString(ruleName))
  add(path_574315, "subscriptionId", newJString(subscriptionId))
  add(path_574315, "routeFilterName", newJString(routeFilterName))
  result = call_574314.call(path_574315, query_574316, nil, nil, nil)

var routeFilterRulesDelete* = Call_RouteFilterRulesDelete_574305(
    name: "routeFilterRulesDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/routeFilters/{routeFilterName}/routeFilterRules/{ruleName}",
    validator: validate_RouteFilterRulesDelete_574306, base: "",
    url: url_RouteFilterRulesDelete_574307, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
