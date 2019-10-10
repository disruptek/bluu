
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
  macServiceName = "network-loadBalancer"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_LoadBalancersListAll_573879 = ref object of OpenApiRestCall_573657
proc url_LoadBalancersListAll_573881(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Network/loadBalancers")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LoadBalancersListAll_573880(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all the load balancers in a subscription.
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

proc call*(call_574069: Call_LoadBalancersListAll_573879; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all the load balancers in a subscription.
  ## 
  let valid = call_574069.validator(path, query, header, formData, body)
  let scheme = call_574069.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574069.url(scheme.get, call_574069.host, call_574069.base,
                         call_574069.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574069, url, valid)

proc call*(call_574140: Call_LoadBalancersListAll_573879; apiVersion: string;
          subscriptionId: string): Recallable =
  ## loadBalancersListAll
  ## Gets all the load balancers in a subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_574141 = newJObject()
  var query_574143 = newJObject()
  add(query_574143, "api-version", newJString(apiVersion))
  add(path_574141, "subscriptionId", newJString(subscriptionId))
  result = call_574140.call(path_574141, query_574143, nil, nil, nil)

var loadBalancersListAll* = Call_LoadBalancersListAll_573879(
    name: "loadBalancersListAll", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Network/loadBalancers",
    validator: validate_LoadBalancersListAll_573880, base: "",
    url: url_LoadBalancersListAll_573881, schemes: {Scheme.Https})
type
  Call_LoadBalancersList_574182 = ref object of OpenApiRestCall_573657
proc url_LoadBalancersList_574184(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
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
        kind: ConstantSegment, value: "/providers/Microsoft.Network/loadBalancers")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LoadBalancersList_574183(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Gets all the load balancers in a resource group.
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

proc call*(call_574188: Call_LoadBalancersList_574182; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all the load balancers in a resource group.
  ## 
  let valid = call_574188.validator(path, query, header, formData, body)
  let scheme = call_574188.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574188.url(scheme.get, call_574188.host, call_574188.base,
                         call_574188.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574188, url, valid)

proc call*(call_574189: Call_LoadBalancersList_574182; resourceGroupName: string;
          apiVersion: string; subscriptionId: string): Recallable =
  ## loadBalancersList
  ## Gets all the load balancers in a resource group.
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

var loadBalancersList* = Call_LoadBalancersList_574182(name: "loadBalancersList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/loadBalancers",
    validator: validate_LoadBalancersList_574183, base: "",
    url: url_LoadBalancersList_574184, schemes: {Scheme.Https})
type
  Call_LoadBalancersCreateOrUpdate_574205 = ref object of OpenApiRestCall_573657
proc url_LoadBalancersCreateOrUpdate_574207(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "loadBalancerName" in path,
        "`loadBalancerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/loadBalancers/"),
               (kind: VariableSegment, value: "loadBalancerName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LoadBalancersCreateOrUpdate_574206(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates a load balancer.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   loadBalancerName: JString (required)
  ##                   : The name of the load balancer.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574234 = path.getOrDefault("resourceGroupName")
  valid_574234 = validateParameter(valid_574234, JString, required = true,
                                 default = nil)
  if valid_574234 != nil:
    section.add "resourceGroupName", valid_574234
  var valid_574235 = path.getOrDefault("loadBalancerName")
  valid_574235 = validateParameter(valid_574235, JString, required = true,
                                 default = nil)
  if valid_574235 != nil:
    section.add "loadBalancerName", valid_574235
  var valid_574236 = path.getOrDefault("subscriptionId")
  valid_574236 = validateParameter(valid_574236, JString, required = true,
                                 default = nil)
  if valid_574236 != nil:
    section.add "subscriptionId", valid_574236
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
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the create or update load balancer operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_574239: Call_LoadBalancersCreateOrUpdate_574205; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates a load balancer.
  ## 
  let valid = call_574239.validator(path, query, header, formData, body)
  let scheme = call_574239.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574239.url(scheme.get, call_574239.host, call_574239.base,
                         call_574239.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574239, url, valid)

proc call*(call_574240: Call_LoadBalancersCreateOrUpdate_574205;
          resourceGroupName: string; apiVersion: string; loadBalancerName: string;
          subscriptionId: string; parameters: JsonNode): Recallable =
  ## loadBalancersCreateOrUpdate
  ## Creates or updates a load balancer.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   loadBalancerName: string (required)
  ##                   : The name of the load balancer.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the create or update load balancer operation.
  var path_574241 = newJObject()
  var query_574242 = newJObject()
  var body_574243 = newJObject()
  add(path_574241, "resourceGroupName", newJString(resourceGroupName))
  add(query_574242, "api-version", newJString(apiVersion))
  add(path_574241, "loadBalancerName", newJString(loadBalancerName))
  add(path_574241, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_574243 = parameters
  result = call_574240.call(path_574241, query_574242, nil, nil, body_574243)

var loadBalancersCreateOrUpdate* = Call_LoadBalancersCreateOrUpdate_574205(
    name: "loadBalancersCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/loadBalancers/{loadBalancerName}",
    validator: validate_LoadBalancersCreateOrUpdate_574206, base: "",
    url: url_LoadBalancersCreateOrUpdate_574207, schemes: {Scheme.Https})
type
  Call_LoadBalancersGet_574192 = ref object of OpenApiRestCall_573657
proc url_LoadBalancersGet_574194(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "loadBalancerName" in path,
        "`loadBalancerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/loadBalancers/"),
               (kind: VariableSegment, value: "loadBalancerName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LoadBalancersGet_574193(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Gets the specified load balancer.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   loadBalancerName: JString (required)
  ##                   : The name of the load balancer.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574196 = path.getOrDefault("resourceGroupName")
  valid_574196 = validateParameter(valid_574196, JString, required = true,
                                 default = nil)
  if valid_574196 != nil:
    section.add "resourceGroupName", valid_574196
  var valid_574197 = path.getOrDefault("loadBalancerName")
  valid_574197 = validateParameter(valid_574197, JString, required = true,
                                 default = nil)
  if valid_574197 != nil:
    section.add "loadBalancerName", valid_574197
  var valid_574198 = path.getOrDefault("subscriptionId")
  valid_574198 = validateParameter(valid_574198, JString, required = true,
                                 default = nil)
  if valid_574198 != nil:
    section.add "subscriptionId", valid_574198
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $expand: JString
  ##          : Expands referenced resources.
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

proc call*(call_574201: Call_LoadBalancersGet_574192; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the specified load balancer.
  ## 
  let valid = call_574201.validator(path, query, header, formData, body)
  let scheme = call_574201.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574201.url(scheme.get, call_574201.host, call_574201.base,
                         call_574201.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574201, url, valid)

proc call*(call_574202: Call_LoadBalancersGet_574192; resourceGroupName: string;
          apiVersion: string; loadBalancerName: string; subscriptionId: string;
          Expand: string = ""): Recallable =
  ## loadBalancersGet
  ## Gets the specified load balancer.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   Expand: string
  ##         : Expands referenced resources.
  ##   loadBalancerName: string (required)
  ##                   : The name of the load balancer.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_574203 = newJObject()
  var query_574204 = newJObject()
  add(path_574203, "resourceGroupName", newJString(resourceGroupName))
  add(query_574204, "api-version", newJString(apiVersion))
  add(query_574204, "$expand", newJString(Expand))
  add(path_574203, "loadBalancerName", newJString(loadBalancerName))
  add(path_574203, "subscriptionId", newJString(subscriptionId))
  result = call_574202.call(path_574203, query_574204, nil, nil, nil)

var loadBalancersGet* = Call_LoadBalancersGet_574192(name: "loadBalancersGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/loadBalancers/{loadBalancerName}",
    validator: validate_LoadBalancersGet_574193, base: "",
    url: url_LoadBalancersGet_574194, schemes: {Scheme.Https})
type
  Call_LoadBalancersUpdateTags_574255 = ref object of OpenApiRestCall_573657
proc url_LoadBalancersUpdateTags_574257(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "loadBalancerName" in path,
        "`loadBalancerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/loadBalancers/"),
               (kind: VariableSegment, value: "loadBalancerName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LoadBalancersUpdateTags_574256(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates a load balancer tags.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   loadBalancerName: JString (required)
  ##                   : The name of the load balancer.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574258 = path.getOrDefault("resourceGroupName")
  valid_574258 = validateParameter(valid_574258, JString, required = true,
                                 default = nil)
  if valid_574258 != nil:
    section.add "resourceGroupName", valid_574258
  var valid_574259 = path.getOrDefault("loadBalancerName")
  valid_574259 = validateParameter(valid_574259, JString, required = true,
                                 default = nil)
  if valid_574259 != nil:
    section.add "loadBalancerName", valid_574259
  var valid_574260 = path.getOrDefault("subscriptionId")
  valid_574260 = validateParameter(valid_574260, JString, required = true,
                                 default = nil)
  if valid_574260 != nil:
    section.add "subscriptionId", valid_574260
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
  ##   parameters: JObject (required)
  ##             : Parameters supplied to update load balancer tags.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_574263: Call_LoadBalancersUpdateTags_574255; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a load balancer tags.
  ## 
  let valid = call_574263.validator(path, query, header, formData, body)
  let scheme = call_574263.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574263.url(scheme.get, call_574263.host, call_574263.base,
                         call_574263.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574263, url, valid)

proc call*(call_574264: Call_LoadBalancersUpdateTags_574255;
          resourceGroupName: string; apiVersion: string; loadBalancerName: string;
          subscriptionId: string; parameters: JsonNode): Recallable =
  ## loadBalancersUpdateTags
  ## Updates a load balancer tags.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   loadBalancerName: string (required)
  ##                   : The name of the load balancer.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to update load balancer tags.
  var path_574265 = newJObject()
  var query_574266 = newJObject()
  var body_574267 = newJObject()
  add(path_574265, "resourceGroupName", newJString(resourceGroupName))
  add(query_574266, "api-version", newJString(apiVersion))
  add(path_574265, "loadBalancerName", newJString(loadBalancerName))
  add(path_574265, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_574267 = parameters
  result = call_574264.call(path_574265, query_574266, nil, nil, body_574267)

var loadBalancersUpdateTags* = Call_LoadBalancersUpdateTags_574255(
    name: "loadBalancersUpdateTags", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/loadBalancers/{loadBalancerName}",
    validator: validate_LoadBalancersUpdateTags_574256, base: "",
    url: url_LoadBalancersUpdateTags_574257, schemes: {Scheme.Https})
type
  Call_LoadBalancersDelete_574244 = ref object of OpenApiRestCall_573657
proc url_LoadBalancersDelete_574246(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "loadBalancerName" in path,
        "`loadBalancerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/loadBalancers/"),
               (kind: VariableSegment, value: "loadBalancerName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LoadBalancersDelete_574245(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Deletes the specified load balancer.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   loadBalancerName: JString (required)
  ##                   : The name of the load balancer.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574247 = path.getOrDefault("resourceGroupName")
  valid_574247 = validateParameter(valid_574247, JString, required = true,
                                 default = nil)
  if valid_574247 != nil:
    section.add "resourceGroupName", valid_574247
  var valid_574248 = path.getOrDefault("loadBalancerName")
  valid_574248 = validateParameter(valid_574248, JString, required = true,
                                 default = nil)
  if valid_574248 != nil:
    section.add "loadBalancerName", valid_574248
  var valid_574249 = path.getOrDefault("subscriptionId")
  valid_574249 = validateParameter(valid_574249, JString, required = true,
                                 default = nil)
  if valid_574249 != nil:
    section.add "subscriptionId", valid_574249
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

proc call*(call_574251: Call_LoadBalancersDelete_574244; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified load balancer.
  ## 
  let valid = call_574251.validator(path, query, header, formData, body)
  let scheme = call_574251.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574251.url(scheme.get, call_574251.host, call_574251.base,
                         call_574251.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574251, url, valid)

proc call*(call_574252: Call_LoadBalancersDelete_574244; resourceGroupName: string;
          apiVersion: string; loadBalancerName: string; subscriptionId: string): Recallable =
  ## loadBalancersDelete
  ## Deletes the specified load balancer.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   loadBalancerName: string (required)
  ##                   : The name of the load balancer.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_574253 = newJObject()
  var query_574254 = newJObject()
  add(path_574253, "resourceGroupName", newJString(resourceGroupName))
  add(query_574254, "api-version", newJString(apiVersion))
  add(path_574253, "loadBalancerName", newJString(loadBalancerName))
  add(path_574253, "subscriptionId", newJString(subscriptionId))
  result = call_574252.call(path_574253, query_574254, nil, nil, nil)

var loadBalancersDelete* = Call_LoadBalancersDelete_574244(
    name: "loadBalancersDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/loadBalancers/{loadBalancerName}",
    validator: validate_LoadBalancersDelete_574245, base: "",
    url: url_LoadBalancersDelete_574246, schemes: {Scheme.Https})
type
  Call_LoadBalancerBackendAddressPoolsList_574268 = ref object of OpenApiRestCall_573657
proc url_LoadBalancerBackendAddressPoolsList_574270(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "loadBalancerName" in path,
        "`loadBalancerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/loadBalancers/"),
               (kind: VariableSegment, value: "loadBalancerName"),
               (kind: ConstantSegment, value: "/backendAddressPools")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LoadBalancerBackendAddressPoolsList_574269(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all the load balancer backed address pools.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   loadBalancerName: JString (required)
  ##                   : The name of the load balancer.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574271 = path.getOrDefault("resourceGroupName")
  valid_574271 = validateParameter(valid_574271, JString, required = true,
                                 default = nil)
  if valid_574271 != nil:
    section.add "resourceGroupName", valid_574271
  var valid_574272 = path.getOrDefault("loadBalancerName")
  valid_574272 = validateParameter(valid_574272, JString, required = true,
                                 default = nil)
  if valid_574272 != nil:
    section.add "loadBalancerName", valid_574272
  var valid_574273 = path.getOrDefault("subscriptionId")
  valid_574273 = validateParameter(valid_574273, JString, required = true,
                                 default = nil)
  if valid_574273 != nil:
    section.add "subscriptionId", valid_574273
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

proc call*(call_574275: Call_LoadBalancerBackendAddressPoolsList_574268;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets all the load balancer backed address pools.
  ## 
  let valid = call_574275.validator(path, query, header, formData, body)
  let scheme = call_574275.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574275.url(scheme.get, call_574275.host, call_574275.base,
                         call_574275.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574275, url, valid)

proc call*(call_574276: Call_LoadBalancerBackendAddressPoolsList_574268;
          resourceGroupName: string; apiVersion: string; loadBalancerName: string;
          subscriptionId: string): Recallable =
  ## loadBalancerBackendAddressPoolsList
  ## Gets all the load balancer backed address pools.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   loadBalancerName: string (required)
  ##                   : The name of the load balancer.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_574277 = newJObject()
  var query_574278 = newJObject()
  add(path_574277, "resourceGroupName", newJString(resourceGroupName))
  add(query_574278, "api-version", newJString(apiVersion))
  add(path_574277, "loadBalancerName", newJString(loadBalancerName))
  add(path_574277, "subscriptionId", newJString(subscriptionId))
  result = call_574276.call(path_574277, query_574278, nil, nil, nil)

var loadBalancerBackendAddressPoolsList* = Call_LoadBalancerBackendAddressPoolsList_574268(
    name: "loadBalancerBackendAddressPoolsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/loadBalancers/{loadBalancerName}/backendAddressPools",
    validator: validate_LoadBalancerBackendAddressPoolsList_574269, base: "",
    url: url_LoadBalancerBackendAddressPoolsList_574270, schemes: {Scheme.Https})
type
  Call_LoadBalancerBackendAddressPoolsGet_574279 = ref object of OpenApiRestCall_573657
proc url_LoadBalancerBackendAddressPoolsGet_574281(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "loadBalancerName" in path,
        "`loadBalancerName` is a required path parameter"
  assert "backendAddressPoolName" in path,
        "`backendAddressPoolName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/loadBalancers/"),
               (kind: VariableSegment, value: "loadBalancerName"),
               (kind: ConstantSegment, value: "/backendAddressPools/"),
               (kind: VariableSegment, value: "backendAddressPoolName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LoadBalancerBackendAddressPoolsGet_574280(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets load balancer backend address pool.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   backendAddressPoolName: JString (required)
  ##                         : The name of the backend address pool.
  ##   loadBalancerName: JString (required)
  ##                   : The name of the load balancer.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574282 = path.getOrDefault("resourceGroupName")
  valid_574282 = validateParameter(valid_574282, JString, required = true,
                                 default = nil)
  if valid_574282 != nil:
    section.add "resourceGroupName", valid_574282
  var valid_574283 = path.getOrDefault("backendAddressPoolName")
  valid_574283 = validateParameter(valid_574283, JString, required = true,
                                 default = nil)
  if valid_574283 != nil:
    section.add "backendAddressPoolName", valid_574283
  var valid_574284 = path.getOrDefault("loadBalancerName")
  valid_574284 = validateParameter(valid_574284, JString, required = true,
                                 default = nil)
  if valid_574284 != nil:
    section.add "loadBalancerName", valid_574284
  var valid_574285 = path.getOrDefault("subscriptionId")
  valid_574285 = validateParameter(valid_574285, JString, required = true,
                                 default = nil)
  if valid_574285 != nil:
    section.add "subscriptionId", valid_574285
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

proc call*(call_574287: Call_LoadBalancerBackendAddressPoolsGet_574279;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets load balancer backend address pool.
  ## 
  let valid = call_574287.validator(path, query, header, formData, body)
  let scheme = call_574287.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574287.url(scheme.get, call_574287.host, call_574287.base,
                         call_574287.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574287, url, valid)

proc call*(call_574288: Call_LoadBalancerBackendAddressPoolsGet_574279;
          resourceGroupName: string; backendAddressPoolName: string;
          apiVersion: string; loadBalancerName: string; subscriptionId: string): Recallable =
  ## loadBalancerBackendAddressPoolsGet
  ## Gets load balancer backend address pool.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   backendAddressPoolName: string (required)
  ##                         : The name of the backend address pool.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   loadBalancerName: string (required)
  ##                   : The name of the load balancer.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_574289 = newJObject()
  var query_574290 = newJObject()
  add(path_574289, "resourceGroupName", newJString(resourceGroupName))
  add(path_574289, "backendAddressPoolName", newJString(backendAddressPoolName))
  add(query_574290, "api-version", newJString(apiVersion))
  add(path_574289, "loadBalancerName", newJString(loadBalancerName))
  add(path_574289, "subscriptionId", newJString(subscriptionId))
  result = call_574288.call(path_574289, query_574290, nil, nil, nil)

var loadBalancerBackendAddressPoolsGet* = Call_LoadBalancerBackendAddressPoolsGet_574279(
    name: "loadBalancerBackendAddressPoolsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/loadBalancers/{loadBalancerName}/backendAddressPools/{backendAddressPoolName}",
    validator: validate_LoadBalancerBackendAddressPoolsGet_574280, base: "",
    url: url_LoadBalancerBackendAddressPoolsGet_574281, schemes: {Scheme.Https})
type
  Call_LoadBalancerFrontendIPConfigurationsList_574291 = ref object of OpenApiRestCall_573657
proc url_LoadBalancerFrontendIPConfigurationsList_574293(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "loadBalancerName" in path,
        "`loadBalancerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/loadBalancers/"),
               (kind: VariableSegment, value: "loadBalancerName"),
               (kind: ConstantSegment, value: "/frontendIPConfigurations")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LoadBalancerFrontendIPConfigurationsList_574292(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all the load balancer frontend IP configurations.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   loadBalancerName: JString (required)
  ##                   : The name of the load balancer.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574294 = path.getOrDefault("resourceGroupName")
  valid_574294 = validateParameter(valid_574294, JString, required = true,
                                 default = nil)
  if valid_574294 != nil:
    section.add "resourceGroupName", valid_574294
  var valid_574295 = path.getOrDefault("loadBalancerName")
  valid_574295 = validateParameter(valid_574295, JString, required = true,
                                 default = nil)
  if valid_574295 != nil:
    section.add "loadBalancerName", valid_574295
  var valid_574296 = path.getOrDefault("subscriptionId")
  valid_574296 = validateParameter(valid_574296, JString, required = true,
                                 default = nil)
  if valid_574296 != nil:
    section.add "subscriptionId", valid_574296
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574297 = query.getOrDefault("api-version")
  valid_574297 = validateParameter(valid_574297, JString, required = true,
                                 default = nil)
  if valid_574297 != nil:
    section.add "api-version", valid_574297
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574298: Call_LoadBalancerFrontendIPConfigurationsList_574291;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets all the load balancer frontend IP configurations.
  ## 
  let valid = call_574298.validator(path, query, header, formData, body)
  let scheme = call_574298.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574298.url(scheme.get, call_574298.host, call_574298.base,
                         call_574298.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574298, url, valid)

proc call*(call_574299: Call_LoadBalancerFrontendIPConfigurationsList_574291;
          resourceGroupName: string; apiVersion: string; loadBalancerName: string;
          subscriptionId: string): Recallable =
  ## loadBalancerFrontendIPConfigurationsList
  ## Gets all the load balancer frontend IP configurations.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   loadBalancerName: string (required)
  ##                   : The name of the load balancer.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_574300 = newJObject()
  var query_574301 = newJObject()
  add(path_574300, "resourceGroupName", newJString(resourceGroupName))
  add(query_574301, "api-version", newJString(apiVersion))
  add(path_574300, "loadBalancerName", newJString(loadBalancerName))
  add(path_574300, "subscriptionId", newJString(subscriptionId))
  result = call_574299.call(path_574300, query_574301, nil, nil, nil)

var loadBalancerFrontendIPConfigurationsList* = Call_LoadBalancerFrontendIPConfigurationsList_574291(
    name: "loadBalancerFrontendIPConfigurationsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/loadBalancers/{loadBalancerName}/frontendIPConfigurations",
    validator: validate_LoadBalancerFrontendIPConfigurationsList_574292, base: "",
    url: url_LoadBalancerFrontendIPConfigurationsList_574293,
    schemes: {Scheme.Https})
type
  Call_LoadBalancerFrontendIPConfigurationsGet_574302 = ref object of OpenApiRestCall_573657
proc url_LoadBalancerFrontendIPConfigurationsGet_574304(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "loadBalancerName" in path,
        "`loadBalancerName` is a required path parameter"
  assert "frontendIPConfigurationName" in path,
        "`frontendIPConfigurationName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/loadBalancers/"),
               (kind: VariableSegment, value: "loadBalancerName"),
               (kind: ConstantSegment, value: "/frontendIPConfigurations/"),
               (kind: VariableSegment, value: "frontendIPConfigurationName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LoadBalancerFrontendIPConfigurationsGet_574303(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets load balancer frontend IP configuration.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   loadBalancerName: JString (required)
  ##                   : The name of the load balancer.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   frontendIPConfigurationName: JString (required)
  ##                              : The name of the frontend IP configuration.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574305 = path.getOrDefault("resourceGroupName")
  valid_574305 = validateParameter(valid_574305, JString, required = true,
                                 default = nil)
  if valid_574305 != nil:
    section.add "resourceGroupName", valid_574305
  var valid_574306 = path.getOrDefault("loadBalancerName")
  valid_574306 = validateParameter(valid_574306, JString, required = true,
                                 default = nil)
  if valid_574306 != nil:
    section.add "loadBalancerName", valid_574306
  var valid_574307 = path.getOrDefault("subscriptionId")
  valid_574307 = validateParameter(valid_574307, JString, required = true,
                                 default = nil)
  if valid_574307 != nil:
    section.add "subscriptionId", valid_574307
  var valid_574308 = path.getOrDefault("frontendIPConfigurationName")
  valid_574308 = validateParameter(valid_574308, JString, required = true,
                                 default = nil)
  if valid_574308 != nil:
    section.add "frontendIPConfigurationName", valid_574308
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574309 = query.getOrDefault("api-version")
  valid_574309 = validateParameter(valid_574309, JString, required = true,
                                 default = nil)
  if valid_574309 != nil:
    section.add "api-version", valid_574309
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574310: Call_LoadBalancerFrontendIPConfigurationsGet_574302;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets load balancer frontend IP configuration.
  ## 
  let valid = call_574310.validator(path, query, header, formData, body)
  let scheme = call_574310.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574310.url(scheme.get, call_574310.host, call_574310.base,
                         call_574310.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574310, url, valid)

proc call*(call_574311: Call_LoadBalancerFrontendIPConfigurationsGet_574302;
          resourceGroupName: string; apiVersion: string; loadBalancerName: string;
          subscriptionId: string; frontendIPConfigurationName: string): Recallable =
  ## loadBalancerFrontendIPConfigurationsGet
  ## Gets load balancer frontend IP configuration.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   loadBalancerName: string (required)
  ##                   : The name of the load balancer.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   frontendIPConfigurationName: string (required)
  ##                              : The name of the frontend IP configuration.
  var path_574312 = newJObject()
  var query_574313 = newJObject()
  add(path_574312, "resourceGroupName", newJString(resourceGroupName))
  add(query_574313, "api-version", newJString(apiVersion))
  add(path_574312, "loadBalancerName", newJString(loadBalancerName))
  add(path_574312, "subscriptionId", newJString(subscriptionId))
  add(path_574312, "frontendIPConfigurationName",
      newJString(frontendIPConfigurationName))
  result = call_574311.call(path_574312, query_574313, nil, nil, nil)

var loadBalancerFrontendIPConfigurationsGet* = Call_LoadBalancerFrontendIPConfigurationsGet_574302(
    name: "loadBalancerFrontendIPConfigurationsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/loadBalancers/{loadBalancerName}/frontendIPConfigurations/{frontendIPConfigurationName}",
    validator: validate_LoadBalancerFrontendIPConfigurationsGet_574303, base: "",
    url: url_LoadBalancerFrontendIPConfigurationsGet_574304,
    schemes: {Scheme.Https})
type
  Call_InboundNatRulesList_574314 = ref object of OpenApiRestCall_573657
proc url_InboundNatRulesList_574316(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "loadBalancerName" in path,
        "`loadBalancerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/loadBalancers/"),
               (kind: VariableSegment, value: "loadBalancerName"),
               (kind: ConstantSegment, value: "/inboundNatRules")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_InboundNatRulesList_574315(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Gets all the inbound nat rules in a load balancer.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   loadBalancerName: JString (required)
  ##                   : The name of the load balancer.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574317 = path.getOrDefault("resourceGroupName")
  valid_574317 = validateParameter(valid_574317, JString, required = true,
                                 default = nil)
  if valid_574317 != nil:
    section.add "resourceGroupName", valid_574317
  var valid_574318 = path.getOrDefault("loadBalancerName")
  valid_574318 = validateParameter(valid_574318, JString, required = true,
                                 default = nil)
  if valid_574318 != nil:
    section.add "loadBalancerName", valid_574318
  var valid_574319 = path.getOrDefault("subscriptionId")
  valid_574319 = validateParameter(valid_574319, JString, required = true,
                                 default = nil)
  if valid_574319 != nil:
    section.add "subscriptionId", valid_574319
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574320 = query.getOrDefault("api-version")
  valid_574320 = validateParameter(valid_574320, JString, required = true,
                                 default = nil)
  if valid_574320 != nil:
    section.add "api-version", valid_574320
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574321: Call_InboundNatRulesList_574314; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all the inbound nat rules in a load balancer.
  ## 
  let valid = call_574321.validator(path, query, header, formData, body)
  let scheme = call_574321.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574321.url(scheme.get, call_574321.host, call_574321.base,
                         call_574321.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574321, url, valid)

proc call*(call_574322: Call_InboundNatRulesList_574314; resourceGroupName: string;
          apiVersion: string; loadBalancerName: string; subscriptionId: string): Recallable =
  ## inboundNatRulesList
  ## Gets all the inbound nat rules in a load balancer.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   loadBalancerName: string (required)
  ##                   : The name of the load balancer.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_574323 = newJObject()
  var query_574324 = newJObject()
  add(path_574323, "resourceGroupName", newJString(resourceGroupName))
  add(query_574324, "api-version", newJString(apiVersion))
  add(path_574323, "loadBalancerName", newJString(loadBalancerName))
  add(path_574323, "subscriptionId", newJString(subscriptionId))
  result = call_574322.call(path_574323, query_574324, nil, nil, nil)

var inboundNatRulesList* = Call_InboundNatRulesList_574314(
    name: "inboundNatRulesList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/loadBalancers/{loadBalancerName}/inboundNatRules",
    validator: validate_InboundNatRulesList_574315, base: "",
    url: url_InboundNatRulesList_574316, schemes: {Scheme.Https})
type
  Call_InboundNatRulesCreateOrUpdate_574338 = ref object of OpenApiRestCall_573657
proc url_InboundNatRulesCreateOrUpdate_574340(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "loadBalancerName" in path,
        "`loadBalancerName` is a required path parameter"
  assert "inboundNatRuleName" in path,
        "`inboundNatRuleName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/loadBalancers/"),
               (kind: VariableSegment, value: "loadBalancerName"),
               (kind: ConstantSegment, value: "/inboundNatRules/"),
               (kind: VariableSegment, value: "inboundNatRuleName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_InboundNatRulesCreateOrUpdate_574339(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates a load balancer inbound nat rule.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   loadBalancerName: JString (required)
  ##                   : The name of the load balancer.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   inboundNatRuleName: JString (required)
  ##                     : The name of the inbound nat rule.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574341 = path.getOrDefault("resourceGroupName")
  valid_574341 = validateParameter(valid_574341, JString, required = true,
                                 default = nil)
  if valid_574341 != nil:
    section.add "resourceGroupName", valid_574341
  var valid_574342 = path.getOrDefault("loadBalancerName")
  valid_574342 = validateParameter(valid_574342, JString, required = true,
                                 default = nil)
  if valid_574342 != nil:
    section.add "loadBalancerName", valid_574342
  var valid_574343 = path.getOrDefault("subscriptionId")
  valid_574343 = validateParameter(valid_574343, JString, required = true,
                                 default = nil)
  if valid_574343 != nil:
    section.add "subscriptionId", valid_574343
  var valid_574344 = path.getOrDefault("inboundNatRuleName")
  valid_574344 = validateParameter(valid_574344, JString, required = true,
                                 default = nil)
  if valid_574344 != nil:
    section.add "inboundNatRuleName", valid_574344
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574345 = query.getOrDefault("api-version")
  valid_574345 = validateParameter(valid_574345, JString, required = true,
                                 default = nil)
  if valid_574345 != nil:
    section.add "api-version", valid_574345
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   inboundNatRuleParameters: JObject (required)
  ##                           : Parameters supplied to the create or update inbound nat rule operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_574347: Call_InboundNatRulesCreateOrUpdate_574338; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates a load balancer inbound nat rule.
  ## 
  let valid = call_574347.validator(path, query, header, formData, body)
  let scheme = call_574347.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574347.url(scheme.get, call_574347.host, call_574347.base,
                         call_574347.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574347, url, valid)

proc call*(call_574348: Call_InboundNatRulesCreateOrUpdate_574338;
          resourceGroupName: string; apiVersion: string; loadBalancerName: string;
          subscriptionId: string; inboundNatRuleParameters: JsonNode;
          inboundNatRuleName: string): Recallable =
  ## inboundNatRulesCreateOrUpdate
  ## Creates or updates a load balancer inbound nat rule.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   loadBalancerName: string (required)
  ##                   : The name of the load balancer.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   inboundNatRuleParameters: JObject (required)
  ##                           : Parameters supplied to the create or update inbound nat rule operation.
  ##   inboundNatRuleName: string (required)
  ##                     : The name of the inbound nat rule.
  var path_574349 = newJObject()
  var query_574350 = newJObject()
  var body_574351 = newJObject()
  add(path_574349, "resourceGroupName", newJString(resourceGroupName))
  add(query_574350, "api-version", newJString(apiVersion))
  add(path_574349, "loadBalancerName", newJString(loadBalancerName))
  add(path_574349, "subscriptionId", newJString(subscriptionId))
  if inboundNatRuleParameters != nil:
    body_574351 = inboundNatRuleParameters
  add(path_574349, "inboundNatRuleName", newJString(inboundNatRuleName))
  result = call_574348.call(path_574349, query_574350, nil, nil, body_574351)

var inboundNatRulesCreateOrUpdate* = Call_InboundNatRulesCreateOrUpdate_574338(
    name: "inboundNatRulesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/loadBalancers/{loadBalancerName}/inboundNatRules/{inboundNatRuleName}",
    validator: validate_InboundNatRulesCreateOrUpdate_574339, base: "",
    url: url_InboundNatRulesCreateOrUpdate_574340, schemes: {Scheme.Https})
type
  Call_InboundNatRulesGet_574325 = ref object of OpenApiRestCall_573657
proc url_InboundNatRulesGet_574327(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "loadBalancerName" in path,
        "`loadBalancerName` is a required path parameter"
  assert "inboundNatRuleName" in path,
        "`inboundNatRuleName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/loadBalancers/"),
               (kind: VariableSegment, value: "loadBalancerName"),
               (kind: ConstantSegment, value: "/inboundNatRules/"),
               (kind: VariableSegment, value: "inboundNatRuleName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_InboundNatRulesGet_574326(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Gets the specified load balancer inbound nat rule.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   loadBalancerName: JString (required)
  ##                   : The name of the load balancer.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   inboundNatRuleName: JString (required)
  ##                     : The name of the inbound nat rule.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574328 = path.getOrDefault("resourceGroupName")
  valid_574328 = validateParameter(valid_574328, JString, required = true,
                                 default = nil)
  if valid_574328 != nil:
    section.add "resourceGroupName", valid_574328
  var valid_574329 = path.getOrDefault("loadBalancerName")
  valid_574329 = validateParameter(valid_574329, JString, required = true,
                                 default = nil)
  if valid_574329 != nil:
    section.add "loadBalancerName", valid_574329
  var valid_574330 = path.getOrDefault("subscriptionId")
  valid_574330 = validateParameter(valid_574330, JString, required = true,
                                 default = nil)
  if valid_574330 != nil:
    section.add "subscriptionId", valid_574330
  var valid_574331 = path.getOrDefault("inboundNatRuleName")
  valid_574331 = validateParameter(valid_574331, JString, required = true,
                                 default = nil)
  if valid_574331 != nil:
    section.add "inboundNatRuleName", valid_574331
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $expand: JString
  ##          : Expands referenced resources.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574332 = query.getOrDefault("api-version")
  valid_574332 = validateParameter(valid_574332, JString, required = true,
                                 default = nil)
  if valid_574332 != nil:
    section.add "api-version", valid_574332
  var valid_574333 = query.getOrDefault("$expand")
  valid_574333 = validateParameter(valid_574333, JString, required = false,
                                 default = nil)
  if valid_574333 != nil:
    section.add "$expand", valid_574333
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574334: Call_InboundNatRulesGet_574325; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the specified load balancer inbound nat rule.
  ## 
  let valid = call_574334.validator(path, query, header, formData, body)
  let scheme = call_574334.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574334.url(scheme.get, call_574334.host, call_574334.base,
                         call_574334.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574334, url, valid)

proc call*(call_574335: Call_InboundNatRulesGet_574325; resourceGroupName: string;
          apiVersion: string; loadBalancerName: string; subscriptionId: string;
          inboundNatRuleName: string; Expand: string = ""): Recallable =
  ## inboundNatRulesGet
  ## Gets the specified load balancer inbound nat rule.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   Expand: string
  ##         : Expands referenced resources.
  ##   loadBalancerName: string (required)
  ##                   : The name of the load balancer.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   inboundNatRuleName: string (required)
  ##                     : The name of the inbound nat rule.
  var path_574336 = newJObject()
  var query_574337 = newJObject()
  add(path_574336, "resourceGroupName", newJString(resourceGroupName))
  add(query_574337, "api-version", newJString(apiVersion))
  add(query_574337, "$expand", newJString(Expand))
  add(path_574336, "loadBalancerName", newJString(loadBalancerName))
  add(path_574336, "subscriptionId", newJString(subscriptionId))
  add(path_574336, "inboundNatRuleName", newJString(inboundNatRuleName))
  result = call_574335.call(path_574336, query_574337, nil, nil, nil)

var inboundNatRulesGet* = Call_InboundNatRulesGet_574325(
    name: "inboundNatRulesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/loadBalancers/{loadBalancerName}/inboundNatRules/{inboundNatRuleName}",
    validator: validate_InboundNatRulesGet_574326, base: "",
    url: url_InboundNatRulesGet_574327, schemes: {Scheme.Https})
type
  Call_InboundNatRulesDelete_574352 = ref object of OpenApiRestCall_573657
proc url_InboundNatRulesDelete_574354(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "loadBalancerName" in path,
        "`loadBalancerName` is a required path parameter"
  assert "inboundNatRuleName" in path,
        "`inboundNatRuleName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/loadBalancers/"),
               (kind: VariableSegment, value: "loadBalancerName"),
               (kind: ConstantSegment, value: "/inboundNatRules/"),
               (kind: VariableSegment, value: "inboundNatRuleName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_InboundNatRulesDelete_574353(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the specified load balancer inbound nat rule.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   loadBalancerName: JString (required)
  ##                   : The name of the load balancer.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   inboundNatRuleName: JString (required)
  ##                     : The name of the inbound nat rule.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574355 = path.getOrDefault("resourceGroupName")
  valid_574355 = validateParameter(valid_574355, JString, required = true,
                                 default = nil)
  if valid_574355 != nil:
    section.add "resourceGroupName", valid_574355
  var valid_574356 = path.getOrDefault("loadBalancerName")
  valid_574356 = validateParameter(valid_574356, JString, required = true,
                                 default = nil)
  if valid_574356 != nil:
    section.add "loadBalancerName", valid_574356
  var valid_574357 = path.getOrDefault("subscriptionId")
  valid_574357 = validateParameter(valid_574357, JString, required = true,
                                 default = nil)
  if valid_574357 != nil:
    section.add "subscriptionId", valid_574357
  var valid_574358 = path.getOrDefault("inboundNatRuleName")
  valid_574358 = validateParameter(valid_574358, JString, required = true,
                                 default = nil)
  if valid_574358 != nil:
    section.add "inboundNatRuleName", valid_574358
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574359 = query.getOrDefault("api-version")
  valid_574359 = validateParameter(valid_574359, JString, required = true,
                                 default = nil)
  if valid_574359 != nil:
    section.add "api-version", valid_574359
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574360: Call_InboundNatRulesDelete_574352; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified load balancer inbound nat rule.
  ## 
  let valid = call_574360.validator(path, query, header, formData, body)
  let scheme = call_574360.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574360.url(scheme.get, call_574360.host, call_574360.base,
                         call_574360.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574360, url, valid)

proc call*(call_574361: Call_InboundNatRulesDelete_574352;
          resourceGroupName: string; apiVersion: string; loadBalancerName: string;
          subscriptionId: string; inboundNatRuleName: string): Recallable =
  ## inboundNatRulesDelete
  ## Deletes the specified load balancer inbound nat rule.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   loadBalancerName: string (required)
  ##                   : The name of the load balancer.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   inboundNatRuleName: string (required)
  ##                     : The name of the inbound nat rule.
  var path_574362 = newJObject()
  var query_574363 = newJObject()
  add(path_574362, "resourceGroupName", newJString(resourceGroupName))
  add(query_574363, "api-version", newJString(apiVersion))
  add(path_574362, "loadBalancerName", newJString(loadBalancerName))
  add(path_574362, "subscriptionId", newJString(subscriptionId))
  add(path_574362, "inboundNatRuleName", newJString(inboundNatRuleName))
  result = call_574361.call(path_574362, query_574363, nil, nil, nil)

var inboundNatRulesDelete* = Call_InboundNatRulesDelete_574352(
    name: "inboundNatRulesDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/loadBalancers/{loadBalancerName}/inboundNatRules/{inboundNatRuleName}",
    validator: validate_InboundNatRulesDelete_574353, base: "",
    url: url_InboundNatRulesDelete_574354, schemes: {Scheme.Https})
type
  Call_LoadBalancerLoadBalancingRulesList_574364 = ref object of OpenApiRestCall_573657
proc url_LoadBalancerLoadBalancingRulesList_574366(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "loadBalancerName" in path,
        "`loadBalancerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/loadBalancers/"),
               (kind: VariableSegment, value: "loadBalancerName"),
               (kind: ConstantSegment, value: "/loadBalancingRules")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LoadBalancerLoadBalancingRulesList_574365(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all the load balancing rules in a load balancer.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   loadBalancerName: JString (required)
  ##                   : The name of the load balancer.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574367 = path.getOrDefault("resourceGroupName")
  valid_574367 = validateParameter(valid_574367, JString, required = true,
                                 default = nil)
  if valid_574367 != nil:
    section.add "resourceGroupName", valid_574367
  var valid_574368 = path.getOrDefault("loadBalancerName")
  valid_574368 = validateParameter(valid_574368, JString, required = true,
                                 default = nil)
  if valid_574368 != nil:
    section.add "loadBalancerName", valid_574368
  var valid_574369 = path.getOrDefault("subscriptionId")
  valid_574369 = validateParameter(valid_574369, JString, required = true,
                                 default = nil)
  if valid_574369 != nil:
    section.add "subscriptionId", valid_574369
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574370 = query.getOrDefault("api-version")
  valid_574370 = validateParameter(valid_574370, JString, required = true,
                                 default = nil)
  if valid_574370 != nil:
    section.add "api-version", valid_574370
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574371: Call_LoadBalancerLoadBalancingRulesList_574364;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets all the load balancing rules in a load balancer.
  ## 
  let valid = call_574371.validator(path, query, header, formData, body)
  let scheme = call_574371.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574371.url(scheme.get, call_574371.host, call_574371.base,
                         call_574371.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574371, url, valid)

proc call*(call_574372: Call_LoadBalancerLoadBalancingRulesList_574364;
          resourceGroupName: string; apiVersion: string; loadBalancerName: string;
          subscriptionId: string): Recallable =
  ## loadBalancerLoadBalancingRulesList
  ## Gets all the load balancing rules in a load balancer.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   loadBalancerName: string (required)
  ##                   : The name of the load balancer.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_574373 = newJObject()
  var query_574374 = newJObject()
  add(path_574373, "resourceGroupName", newJString(resourceGroupName))
  add(query_574374, "api-version", newJString(apiVersion))
  add(path_574373, "loadBalancerName", newJString(loadBalancerName))
  add(path_574373, "subscriptionId", newJString(subscriptionId))
  result = call_574372.call(path_574373, query_574374, nil, nil, nil)

var loadBalancerLoadBalancingRulesList* = Call_LoadBalancerLoadBalancingRulesList_574364(
    name: "loadBalancerLoadBalancingRulesList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/loadBalancers/{loadBalancerName}/loadBalancingRules",
    validator: validate_LoadBalancerLoadBalancingRulesList_574365, base: "",
    url: url_LoadBalancerLoadBalancingRulesList_574366, schemes: {Scheme.Https})
type
  Call_LoadBalancerLoadBalancingRulesGet_574375 = ref object of OpenApiRestCall_573657
proc url_LoadBalancerLoadBalancingRulesGet_574377(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "loadBalancerName" in path,
        "`loadBalancerName` is a required path parameter"
  assert "loadBalancingRuleName" in path,
        "`loadBalancingRuleName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/loadBalancers/"),
               (kind: VariableSegment, value: "loadBalancerName"),
               (kind: ConstantSegment, value: "/loadBalancingRules/"),
               (kind: VariableSegment, value: "loadBalancingRuleName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LoadBalancerLoadBalancingRulesGet_574376(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the specified load balancer load balancing rule.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   loadBalancerName: JString (required)
  ##                   : The name of the load balancer.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   loadBalancingRuleName: JString (required)
  ##                        : The name of the load balancing rule.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574378 = path.getOrDefault("resourceGroupName")
  valid_574378 = validateParameter(valid_574378, JString, required = true,
                                 default = nil)
  if valid_574378 != nil:
    section.add "resourceGroupName", valid_574378
  var valid_574379 = path.getOrDefault("loadBalancerName")
  valid_574379 = validateParameter(valid_574379, JString, required = true,
                                 default = nil)
  if valid_574379 != nil:
    section.add "loadBalancerName", valid_574379
  var valid_574380 = path.getOrDefault("subscriptionId")
  valid_574380 = validateParameter(valid_574380, JString, required = true,
                                 default = nil)
  if valid_574380 != nil:
    section.add "subscriptionId", valid_574380
  var valid_574381 = path.getOrDefault("loadBalancingRuleName")
  valid_574381 = validateParameter(valid_574381, JString, required = true,
                                 default = nil)
  if valid_574381 != nil:
    section.add "loadBalancingRuleName", valid_574381
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574382 = query.getOrDefault("api-version")
  valid_574382 = validateParameter(valid_574382, JString, required = true,
                                 default = nil)
  if valid_574382 != nil:
    section.add "api-version", valid_574382
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574383: Call_LoadBalancerLoadBalancingRulesGet_574375;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the specified load balancer load balancing rule.
  ## 
  let valid = call_574383.validator(path, query, header, formData, body)
  let scheme = call_574383.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574383.url(scheme.get, call_574383.host, call_574383.base,
                         call_574383.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574383, url, valid)

proc call*(call_574384: Call_LoadBalancerLoadBalancingRulesGet_574375;
          resourceGroupName: string; apiVersion: string; loadBalancerName: string;
          subscriptionId: string; loadBalancingRuleName: string): Recallable =
  ## loadBalancerLoadBalancingRulesGet
  ## Gets the specified load balancer load balancing rule.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   loadBalancerName: string (required)
  ##                   : The name of the load balancer.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   loadBalancingRuleName: string (required)
  ##                        : The name of the load balancing rule.
  var path_574385 = newJObject()
  var query_574386 = newJObject()
  add(path_574385, "resourceGroupName", newJString(resourceGroupName))
  add(query_574386, "api-version", newJString(apiVersion))
  add(path_574385, "loadBalancerName", newJString(loadBalancerName))
  add(path_574385, "subscriptionId", newJString(subscriptionId))
  add(path_574385, "loadBalancingRuleName", newJString(loadBalancingRuleName))
  result = call_574384.call(path_574385, query_574386, nil, nil, nil)

var loadBalancerLoadBalancingRulesGet* = Call_LoadBalancerLoadBalancingRulesGet_574375(
    name: "loadBalancerLoadBalancingRulesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/loadBalancers/{loadBalancerName}/loadBalancingRules/{loadBalancingRuleName}",
    validator: validate_LoadBalancerLoadBalancingRulesGet_574376, base: "",
    url: url_LoadBalancerLoadBalancingRulesGet_574377, schemes: {Scheme.Https})
type
  Call_LoadBalancerNetworkInterfacesList_574387 = ref object of OpenApiRestCall_573657
proc url_LoadBalancerNetworkInterfacesList_574389(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "loadBalancerName" in path,
        "`loadBalancerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/loadBalancers/"),
               (kind: VariableSegment, value: "loadBalancerName"),
               (kind: ConstantSegment, value: "/networkInterfaces")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LoadBalancerNetworkInterfacesList_574388(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets associated load balancer network interfaces.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   loadBalancerName: JString (required)
  ##                   : The name of the load balancer.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574390 = path.getOrDefault("resourceGroupName")
  valid_574390 = validateParameter(valid_574390, JString, required = true,
                                 default = nil)
  if valid_574390 != nil:
    section.add "resourceGroupName", valid_574390
  var valid_574391 = path.getOrDefault("loadBalancerName")
  valid_574391 = validateParameter(valid_574391, JString, required = true,
                                 default = nil)
  if valid_574391 != nil:
    section.add "loadBalancerName", valid_574391
  var valid_574392 = path.getOrDefault("subscriptionId")
  valid_574392 = validateParameter(valid_574392, JString, required = true,
                                 default = nil)
  if valid_574392 != nil:
    section.add "subscriptionId", valid_574392
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574393 = query.getOrDefault("api-version")
  valid_574393 = validateParameter(valid_574393, JString, required = true,
                                 default = nil)
  if valid_574393 != nil:
    section.add "api-version", valid_574393
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574394: Call_LoadBalancerNetworkInterfacesList_574387;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets associated load balancer network interfaces.
  ## 
  let valid = call_574394.validator(path, query, header, formData, body)
  let scheme = call_574394.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574394.url(scheme.get, call_574394.host, call_574394.base,
                         call_574394.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574394, url, valid)

proc call*(call_574395: Call_LoadBalancerNetworkInterfacesList_574387;
          resourceGroupName: string; apiVersion: string; loadBalancerName: string;
          subscriptionId: string): Recallable =
  ## loadBalancerNetworkInterfacesList
  ## Gets associated load balancer network interfaces.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   loadBalancerName: string (required)
  ##                   : The name of the load balancer.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_574396 = newJObject()
  var query_574397 = newJObject()
  add(path_574396, "resourceGroupName", newJString(resourceGroupName))
  add(query_574397, "api-version", newJString(apiVersion))
  add(path_574396, "loadBalancerName", newJString(loadBalancerName))
  add(path_574396, "subscriptionId", newJString(subscriptionId))
  result = call_574395.call(path_574396, query_574397, nil, nil, nil)

var loadBalancerNetworkInterfacesList* = Call_LoadBalancerNetworkInterfacesList_574387(
    name: "loadBalancerNetworkInterfacesList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/loadBalancers/{loadBalancerName}/networkInterfaces",
    validator: validate_LoadBalancerNetworkInterfacesList_574388, base: "",
    url: url_LoadBalancerNetworkInterfacesList_574389, schemes: {Scheme.Https})
type
  Call_LoadBalancerOutboundRulesList_574398 = ref object of OpenApiRestCall_573657
proc url_LoadBalancerOutboundRulesList_574400(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "loadBalancerName" in path,
        "`loadBalancerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/loadBalancers/"),
               (kind: VariableSegment, value: "loadBalancerName"),
               (kind: ConstantSegment, value: "/outboundRules")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LoadBalancerOutboundRulesList_574399(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all the outbound rules in a load balancer.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   loadBalancerName: JString (required)
  ##                   : The name of the load balancer.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574401 = path.getOrDefault("resourceGroupName")
  valid_574401 = validateParameter(valid_574401, JString, required = true,
                                 default = nil)
  if valid_574401 != nil:
    section.add "resourceGroupName", valid_574401
  var valid_574402 = path.getOrDefault("loadBalancerName")
  valid_574402 = validateParameter(valid_574402, JString, required = true,
                                 default = nil)
  if valid_574402 != nil:
    section.add "loadBalancerName", valid_574402
  var valid_574403 = path.getOrDefault("subscriptionId")
  valid_574403 = validateParameter(valid_574403, JString, required = true,
                                 default = nil)
  if valid_574403 != nil:
    section.add "subscriptionId", valid_574403
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574404 = query.getOrDefault("api-version")
  valid_574404 = validateParameter(valid_574404, JString, required = true,
                                 default = nil)
  if valid_574404 != nil:
    section.add "api-version", valid_574404
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574405: Call_LoadBalancerOutboundRulesList_574398; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all the outbound rules in a load balancer.
  ## 
  let valid = call_574405.validator(path, query, header, formData, body)
  let scheme = call_574405.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574405.url(scheme.get, call_574405.host, call_574405.base,
                         call_574405.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574405, url, valid)

proc call*(call_574406: Call_LoadBalancerOutboundRulesList_574398;
          resourceGroupName: string; apiVersion: string; loadBalancerName: string;
          subscriptionId: string): Recallable =
  ## loadBalancerOutboundRulesList
  ## Gets all the outbound rules in a load balancer.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   loadBalancerName: string (required)
  ##                   : The name of the load balancer.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_574407 = newJObject()
  var query_574408 = newJObject()
  add(path_574407, "resourceGroupName", newJString(resourceGroupName))
  add(query_574408, "api-version", newJString(apiVersion))
  add(path_574407, "loadBalancerName", newJString(loadBalancerName))
  add(path_574407, "subscriptionId", newJString(subscriptionId))
  result = call_574406.call(path_574407, query_574408, nil, nil, nil)

var loadBalancerOutboundRulesList* = Call_LoadBalancerOutboundRulesList_574398(
    name: "loadBalancerOutboundRulesList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/loadBalancers/{loadBalancerName}/outboundRules",
    validator: validate_LoadBalancerOutboundRulesList_574399, base: "",
    url: url_LoadBalancerOutboundRulesList_574400, schemes: {Scheme.Https})
type
  Call_LoadBalancerOutboundRulesGet_574409 = ref object of OpenApiRestCall_573657
proc url_LoadBalancerOutboundRulesGet_574411(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "loadBalancerName" in path,
        "`loadBalancerName` is a required path parameter"
  assert "outboundRuleName" in path,
        "`outboundRuleName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/loadBalancers/"),
               (kind: VariableSegment, value: "loadBalancerName"),
               (kind: ConstantSegment, value: "/outboundRules/"),
               (kind: VariableSegment, value: "outboundRuleName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LoadBalancerOutboundRulesGet_574410(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the specified load balancer outbound rule.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   loadBalancerName: JString (required)
  ##                   : The name of the load balancer.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   outboundRuleName: JString (required)
  ##                   : The name of the outbound rule.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574412 = path.getOrDefault("resourceGroupName")
  valid_574412 = validateParameter(valid_574412, JString, required = true,
                                 default = nil)
  if valid_574412 != nil:
    section.add "resourceGroupName", valid_574412
  var valid_574413 = path.getOrDefault("loadBalancerName")
  valid_574413 = validateParameter(valid_574413, JString, required = true,
                                 default = nil)
  if valid_574413 != nil:
    section.add "loadBalancerName", valid_574413
  var valid_574414 = path.getOrDefault("subscriptionId")
  valid_574414 = validateParameter(valid_574414, JString, required = true,
                                 default = nil)
  if valid_574414 != nil:
    section.add "subscriptionId", valid_574414
  var valid_574415 = path.getOrDefault("outboundRuleName")
  valid_574415 = validateParameter(valid_574415, JString, required = true,
                                 default = nil)
  if valid_574415 != nil:
    section.add "outboundRuleName", valid_574415
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574416 = query.getOrDefault("api-version")
  valid_574416 = validateParameter(valid_574416, JString, required = true,
                                 default = nil)
  if valid_574416 != nil:
    section.add "api-version", valid_574416
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574417: Call_LoadBalancerOutboundRulesGet_574409; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the specified load balancer outbound rule.
  ## 
  let valid = call_574417.validator(path, query, header, formData, body)
  let scheme = call_574417.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574417.url(scheme.get, call_574417.host, call_574417.base,
                         call_574417.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574417, url, valid)

proc call*(call_574418: Call_LoadBalancerOutboundRulesGet_574409;
          resourceGroupName: string; apiVersion: string; loadBalancerName: string;
          subscriptionId: string; outboundRuleName: string): Recallable =
  ## loadBalancerOutboundRulesGet
  ## Gets the specified load balancer outbound rule.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   loadBalancerName: string (required)
  ##                   : The name of the load balancer.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   outboundRuleName: string (required)
  ##                   : The name of the outbound rule.
  var path_574419 = newJObject()
  var query_574420 = newJObject()
  add(path_574419, "resourceGroupName", newJString(resourceGroupName))
  add(query_574420, "api-version", newJString(apiVersion))
  add(path_574419, "loadBalancerName", newJString(loadBalancerName))
  add(path_574419, "subscriptionId", newJString(subscriptionId))
  add(path_574419, "outboundRuleName", newJString(outboundRuleName))
  result = call_574418.call(path_574419, query_574420, nil, nil, nil)

var loadBalancerOutboundRulesGet* = Call_LoadBalancerOutboundRulesGet_574409(
    name: "loadBalancerOutboundRulesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/loadBalancers/{loadBalancerName}/outboundRules/{outboundRuleName}",
    validator: validate_LoadBalancerOutboundRulesGet_574410, base: "",
    url: url_LoadBalancerOutboundRulesGet_574411, schemes: {Scheme.Https})
type
  Call_LoadBalancerProbesList_574421 = ref object of OpenApiRestCall_573657
proc url_LoadBalancerProbesList_574423(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "loadBalancerName" in path,
        "`loadBalancerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/loadBalancers/"),
               (kind: VariableSegment, value: "loadBalancerName"),
               (kind: ConstantSegment, value: "/probes")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LoadBalancerProbesList_574422(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all the load balancer probes.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   loadBalancerName: JString (required)
  ##                   : The name of the load balancer.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574424 = path.getOrDefault("resourceGroupName")
  valid_574424 = validateParameter(valid_574424, JString, required = true,
                                 default = nil)
  if valid_574424 != nil:
    section.add "resourceGroupName", valid_574424
  var valid_574425 = path.getOrDefault("loadBalancerName")
  valid_574425 = validateParameter(valid_574425, JString, required = true,
                                 default = nil)
  if valid_574425 != nil:
    section.add "loadBalancerName", valid_574425
  var valid_574426 = path.getOrDefault("subscriptionId")
  valid_574426 = validateParameter(valid_574426, JString, required = true,
                                 default = nil)
  if valid_574426 != nil:
    section.add "subscriptionId", valid_574426
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574427 = query.getOrDefault("api-version")
  valid_574427 = validateParameter(valid_574427, JString, required = true,
                                 default = nil)
  if valid_574427 != nil:
    section.add "api-version", valid_574427
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574428: Call_LoadBalancerProbesList_574421; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all the load balancer probes.
  ## 
  let valid = call_574428.validator(path, query, header, formData, body)
  let scheme = call_574428.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574428.url(scheme.get, call_574428.host, call_574428.base,
                         call_574428.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574428, url, valid)

proc call*(call_574429: Call_LoadBalancerProbesList_574421;
          resourceGroupName: string; apiVersion: string; loadBalancerName: string;
          subscriptionId: string): Recallable =
  ## loadBalancerProbesList
  ## Gets all the load balancer probes.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   loadBalancerName: string (required)
  ##                   : The name of the load balancer.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_574430 = newJObject()
  var query_574431 = newJObject()
  add(path_574430, "resourceGroupName", newJString(resourceGroupName))
  add(query_574431, "api-version", newJString(apiVersion))
  add(path_574430, "loadBalancerName", newJString(loadBalancerName))
  add(path_574430, "subscriptionId", newJString(subscriptionId))
  result = call_574429.call(path_574430, query_574431, nil, nil, nil)

var loadBalancerProbesList* = Call_LoadBalancerProbesList_574421(
    name: "loadBalancerProbesList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/loadBalancers/{loadBalancerName}/probes",
    validator: validate_LoadBalancerProbesList_574422, base: "",
    url: url_LoadBalancerProbesList_574423, schemes: {Scheme.Https})
type
  Call_LoadBalancerProbesGet_574432 = ref object of OpenApiRestCall_573657
proc url_LoadBalancerProbesGet_574434(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "loadBalancerName" in path,
        "`loadBalancerName` is a required path parameter"
  assert "probeName" in path, "`probeName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/loadBalancers/"),
               (kind: VariableSegment, value: "loadBalancerName"),
               (kind: ConstantSegment, value: "/probes/"),
               (kind: VariableSegment, value: "probeName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LoadBalancerProbesGet_574433(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets load balancer probe.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   probeName: JString (required)
  ##            : The name of the probe.
  ##   loadBalancerName: JString (required)
  ##                   : The name of the load balancer.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574435 = path.getOrDefault("resourceGroupName")
  valid_574435 = validateParameter(valid_574435, JString, required = true,
                                 default = nil)
  if valid_574435 != nil:
    section.add "resourceGroupName", valid_574435
  var valid_574436 = path.getOrDefault("probeName")
  valid_574436 = validateParameter(valid_574436, JString, required = true,
                                 default = nil)
  if valid_574436 != nil:
    section.add "probeName", valid_574436
  var valid_574437 = path.getOrDefault("loadBalancerName")
  valid_574437 = validateParameter(valid_574437, JString, required = true,
                                 default = nil)
  if valid_574437 != nil:
    section.add "loadBalancerName", valid_574437
  var valid_574438 = path.getOrDefault("subscriptionId")
  valid_574438 = validateParameter(valid_574438, JString, required = true,
                                 default = nil)
  if valid_574438 != nil:
    section.add "subscriptionId", valid_574438
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574439 = query.getOrDefault("api-version")
  valid_574439 = validateParameter(valid_574439, JString, required = true,
                                 default = nil)
  if valid_574439 != nil:
    section.add "api-version", valid_574439
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574440: Call_LoadBalancerProbesGet_574432; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets load balancer probe.
  ## 
  let valid = call_574440.validator(path, query, header, formData, body)
  let scheme = call_574440.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574440.url(scheme.get, call_574440.host, call_574440.base,
                         call_574440.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574440, url, valid)

proc call*(call_574441: Call_LoadBalancerProbesGet_574432;
          resourceGroupName: string; apiVersion: string; probeName: string;
          loadBalancerName: string; subscriptionId: string): Recallable =
  ## loadBalancerProbesGet
  ## Gets load balancer probe.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   probeName: string (required)
  ##            : The name of the probe.
  ##   loadBalancerName: string (required)
  ##                   : The name of the load balancer.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_574442 = newJObject()
  var query_574443 = newJObject()
  add(path_574442, "resourceGroupName", newJString(resourceGroupName))
  add(query_574443, "api-version", newJString(apiVersion))
  add(path_574442, "probeName", newJString(probeName))
  add(path_574442, "loadBalancerName", newJString(loadBalancerName))
  add(path_574442, "subscriptionId", newJString(subscriptionId))
  result = call_574441.call(path_574442, query_574443, nil, nil, nil)

var loadBalancerProbesGet* = Call_LoadBalancerProbesGet_574432(
    name: "loadBalancerProbesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/loadBalancers/{loadBalancerName}/probes/{probeName}",
    validator: validate_LoadBalancerProbesGet_574433, base: "",
    url: url_LoadBalancerProbesGet_574434, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
