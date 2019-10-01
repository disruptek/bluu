
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: NetworkManagementClient
## version: 2017-08-01
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
  macServiceName = "network-loadBalancer"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_LoadBalancersListAll_567879 = ref object of OpenApiRestCall_567657
proc url_LoadBalancersListAll_567881(protocol: Scheme; host: string; base: string;
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

proc validate_LoadBalancersListAll_567880(path: JsonNode; query: JsonNode;
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
  var valid_568054 = path.getOrDefault("subscriptionId")
  valid_568054 = validateParameter(valid_568054, JString, required = true,
                                 default = nil)
  if valid_568054 != nil:
    section.add "subscriptionId", valid_568054
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568055 = query.getOrDefault("api-version")
  valid_568055 = validateParameter(valid_568055, JString, required = true,
                                 default = nil)
  if valid_568055 != nil:
    section.add "api-version", valid_568055
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568078: Call_LoadBalancersListAll_567879; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all the load balancers in a subscription.
  ## 
  let valid = call_568078.validator(path, query, header, formData, body)
  let scheme = call_568078.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568078.url(scheme.get, call_568078.host, call_568078.base,
                         call_568078.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568078, url, valid)

proc call*(call_568149: Call_LoadBalancersListAll_567879; apiVersion: string;
          subscriptionId: string): Recallable =
  ## loadBalancersListAll
  ## Gets all the load balancers in a subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568150 = newJObject()
  var query_568152 = newJObject()
  add(query_568152, "api-version", newJString(apiVersion))
  add(path_568150, "subscriptionId", newJString(subscriptionId))
  result = call_568149.call(path_568150, query_568152, nil, nil, nil)

var loadBalancersListAll* = Call_LoadBalancersListAll_567879(
    name: "loadBalancersListAll", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Network/loadBalancers",
    validator: validate_LoadBalancersListAll_567880, base: "",
    url: url_LoadBalancersListAll_567881, schemes: {Scheme.Https})
type
  Call_LoadBalancersList_568191 = ref object of OpenApiRestCall_567657
proc url_LoadBalancersList_568193(protocol: Scheme; host: string; base: string;
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

proc validate_LoadBalancersList_568192(path: JsonNode; query: JsonNode;
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
  var valid_568194 = path.getOrDefault("resourceGroupName")
  valid_568194 = validateParameter(valid_568194, JString, required = true,
                                 default = nil)
  if valid_568194 != nil:
    section.add "resourceGroupName", valid_568194
  var valid_568195 = path.getOrDefault("subscriptionId")
  valid_568195 = validateParameter(valid_568195, JString, required = true,
                                 default = nil)
  if valid_568195 != nil:
    section.add "subscriptionId", valid_568195
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568196 = query.getOrDefault("api-version")
  valid_568196 = validateParameter(valid_568196, JString, required = true,
                                 default = nil)
  if valid_568196 != nil:
    section.add "api-version", valid_568196
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568197: Call_LoadBalancersList_568191; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all the load balancers in a resource group.
  ## 
  let valid = call_568197.validator(path, query, header, formData, body)
  let scheme = call_568197.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568197.url(scheme.get, call_568197.host, call_568197.base,
                         call_568197.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568197, url, valid)

proc call*(call_568198: Call_LoadBalancersList_568191; resourceGroupName: string;
          apiVersion: string; subscriptionId: string): Recallable =
  ## loadBalancersList
  ## Gets all the load balancers in a resource group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568199 = newJObject()
  var query_568200 = newJObject()
  add(path_568199, "resourceGroupName", newJString(resourceGroupName))
  add(query_568200, "api-version", newJString(apiVersion))
  add(path_568199, "subscriptionId", newJString(subscriptionId))
  result = call_568198.call(path_568199, query_568200, nil, nil, nil)

var loadBalancersList* = Call_LoadBalancersList_568191(name: "loadBalancersList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/loadBalancers",
    validator: validate_LoadBalancersList_568192, base: "",
    url: url_LoadBalancersList_568193, schemes: {Scheme.Https})
type
  Call_LoadBalancersCreateOrUpdate_568214 = ref object of OpenApiRestCall_567657
proc url_LoadBalancersCreateOrUpdate_568216(protocol: Scheme; host: string;
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

proc validate_LoadBalancersCreateOrUpdate_568215(path: JsonNode; query: JsonNode;
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
  var valid_568234 = path.getOrDefault("resourceGroupName")
  valid_568234 = validateParameter(valid_568234, JString, required = true,
                                 default = nil)
  if valid_568234 != nil:
    section.add "resourceGroupName", valid_568234
  var valid_568235 = path.getOrDefault("loadBalancerName")
  valid_568235 = validateParameter(valid_568235, JString, required = true,
                                 default = nil)
  if valid_568235 != nil:
    section.add "loadBalancerName", valid_568235
  var valid_568236 = path.getOrDefault("subscriptionId")
  valid_568236 = validateParameter(valid_568236, JString, required = true,
                                 default = nil)
  if valid_568236 != nil:
    section.add "subscriptionId", valid_568236
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568237 = query.getOrDefault("api-version")
  valid_568237 = validateParameter(valid_568237, JString, required = true,
                                 default = nil)
  if valid_568237 != nil:
    section.add "api-version", valid_568237
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

proc call*(call_568239: Call_LoadBalancersCreateOrUpdate_568214; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates a load balancer.
  ## 
  let valid = call_568239.validator(path, query, header, formData, body)
  let scheme = call_568239.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568239.url(scheme.get, call_568239.host, call_568239.base,
                         call_568239.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568239, url, valid)

proc call*(call_568240: Call_LoadBalancersCreateOrUpdate_568214;
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
  var path_568241 = newJObject()
  var query_568242 = newJObject()
  var body_568243 = newJObject()
  add(path_568241, "resourceGroupName", newJString(resourceGroupName))
  add(query_568242, "api-version", newJString(apiVersion))
  add(path_568241, "loadBalancerName", newJString(loadBalancerName))
  add(path_568241, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568243 = parameters
  result = call_568240.call(path_568241, query_568242, nil, nil, body_568243)

var loadBalancersCreateOrUpdate* = Call_LoadBalancersCreateOrUpdate_568214(
    name: "loadBalancersCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/loadBalancers/{loadBalancerName}",
    validator: validate_LoadBalancersCreateOrUpdate_568215, base: "",
    url: url_LoadBalancersCreateOrUpdate_568216, schemes: {Scheme.Https})
type
  Call_LoadBalancersGet_568201 = ref object of OpenApiRestCall_567657
proc url_LoadBalancersGet_568203(protocol: Scheme; host: string; base: string;
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

proc validate_LoadBalancersGet_568202(path: JsonNode; query: JsonNode;
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
  var valid_568205 = path.getOrDefault("resourceGroupName")
  valid_568205 = validateParameter(valid_568205, JString, required = true,
                                 default = nil)
  if valid_568205 != nil:
    section.add "resourceGroupName", valid_568205
  var valid_568206 = path.getOrDefault("loadBalancerName")
  valid_568206 = validateParameter(valid_568206, JString, required = true,
                                 default = nil)
  if valid_568206 != nil:
    section.add "loadBalancerName", valid_568206
  var valid_568207 = path.getOrDefault("subscriptionId")
  valid_568207 = validateParameter(valid_568207, JString, required = true,
                                 default = nil)
  if valid_568207 != nil:
    section.add "subscriptionId", valid_568207
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $expand: JString
  ##          : Expands referenced resources.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568208 = query.getOrDefault("api-version")
  valid_568208 = validateParameter(valid_568208, JString, required = true,
                                 default = nil)
  if valid_568208 != nil:
    section.add "api-version", valid_568208
  var valid_568209 = query.getOrDefault("$expand")
  valid_568209 = validateParameter(valid_568209, JString, required = false,
                                 default = nil)
  if valid_568209 != nil:
    section.add "$expand", valid_568209
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568210: Call_LoadBalancersGet_568201; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the specified load balancer.
  ## 
  let valid = call_568210.validator(path, query, header, formData, body)
  let scheme = call_568210.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568210.url(scheme.get, call_568210.host, call_568210.base,
                         call_568210.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568210, url, valid)

proc call*(call_568211: Call_LoadBalancersGet_568201; resourceGroupName: string;
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
  var path_568212 = newJObject()
  var query_568213 = newJObject()
  add(path_568212, "resourceGroupName", newJString(resourceGroupName))
  add(query_568213, "api-version", newJString(apiVersion))
  add(query_568213, "$expand", newJString(Expand))
  add(path_568212, "loadBalancerName", newJString(loadBalancerName))
  add(path_568212, "subscriptionId", newJString(subscriptionId))
  result = call_568211.call(path_568212, query_568213, nil, nil, nil)

var loadBalancersGet* = Call_LoadBalancersGet_568201(name: "loadBalancersGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/loadBalancers/{loadBalancerName}",
    validator: validate_LoadBalancersGet_568202, base: "",
    url: url_LoadBalancersGet_568203, schemes: {Scheme.Https})
type
  Call_LoadBalancersDelete_568244 = ref object of OpenApiRestCall_567657
proc url_LoadBalancersDelete_568246(protocol: Scheme; host: string; base: string;
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

proc validate_LoadBalancersDelete_568245(path: JsonNode; query: JsonNode;
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
  var valid_568247 = path.getOrDefault("resourceGroupName")
  valid_568247 = validateParameter(valid_568247, JString, required = true,
                                 default = nil)
  if valid_568247 != nil:
    section.add "resourceGroupName", valid_568247
  var valid_568248 = path.getOrDefault("loadBalancerName")
  valid_568248 = validateParameter(valid_568248, JString, required = true,
                                 default = nil)
  if valid_568248 != nil:
    section.add "loadBalancerName", valid_568248
  var valid_568249 = path.getOrDefault("subscriptionId")
  valid_568249 = validateParameter(valid_568249, JString, required = true,
                                 default = nil)
  if valid_568249 != nil:
    section.add "subscriptionId", valid_568249
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568250 = query.getOrDefault("api-version")
  valid_568250 = validateParameter(valid_568250, JString, required = true,
                                 default = nil)
  if valid_568250 != nil:
    section.add "api-version", valid_568250
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568251: Call_LoadBalancersDelete_568244; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified load balancer.
  ## 
  let valid = call_568251.validator(path, query, header, formData, body)
  let scheme = call_568251.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568251.url(scheme.get, call_568251.host, call_568251.base,
                         call_568251.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568251, url, valid)

proc call*(call_568252: Call_LoadBalancersDelete_568244; resourceGroupName: string;
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
  var path_568253 = newJObject()
  var query_568254 = newJObject()
  add(path_568253, "resourceGroupName", newJString(resourceGroupName))
  add(query_568254, "api-version", newJString(apiVersion))
  add(path_568253, "loadBalancerName", newJString(loadBalancerName))
  add(path_568253, "subscriptionId", newJString(subscriptionId))
  result = call_568252.call(path_568253, query_568254, nil, nil, nil)

var loadBalancersDelete* = Call_LoadBalancersDelete_568244(
    name: "loadBalancersDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/loadBalancers/{loadBalancerName}",
    validator: validate_LoadBalancersDelete_568245, base: "",
    url: url_LoadBalancersDelete_568246, schemes: {Scheme.Https})
type
  Call_LoadBalancerBackendAddressPoolsList_568255 = ref object of OpenApiRestCall_567657
proc url_LoadBalancerBackendAddressPoolsList_568257(protocol: Scheme; host: string;
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

proc validate_LoadBalancerBackendAddressPoolsList_568256(path: JsonNode;
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
  var valid_568258 = path.getOrDefault("resourceGroupName")
  valid_568258 = validateParameter(valid_568258, JString, required = true,
                                 default = nil)
  if valid_568258 != nil:
    section.add "resourceGroupName", valid_568258
  var valid_568259 = path.getOrDefault("loadBalancerName")
  valid_568259 = validateParameter(valid_568259, JString, required = true,
                                 default = nil)
  if valid_568259 != nil:
    section.add "loadBalancerName", valid_568259
  var valid_568260 = path.getOrDefault("subscriptionId")
  valid_568260 = validateParameter(valid_568260, JString, required = true,
                                 default = nil)
  if valid_568260 != nil:
    section.add "subscriptionId", valid_568260
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568261 = query.getOrDefault("api-version")
  valid_568261 = validateParameter(valid_568261, JString, required = true,
                                 default = nil)
  if valid_568261 != nil:
    section.add "api-version", valid_568261
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568262: Call_LoadBalancerBackendAddressPoolsList_568255;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets all the load balancer backed address pools.
  ## 
  let valid = call_568262.validator(path, query, header, formData, body)
  let scheme = call_568262.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568262.url(scheme.get, call_568262.host, call_568262.base,
                         call_568262.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568262, url, valid)

proc call*(call_568263: Call_LoadBalancerBackendAddressPoolsList_568255;
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
  var path_568264 = newJObject()
  var query_568265 = newJObject()
  add(path_568264, "resourceGroupName", newJString(resourceGroupName))
  add(query_568265, "api-version", newJString(apiVersion))
  add(path_568264, "loadBalancerName", newJString(loadBalancerName))
  add(path_568264, "subscriptionId", newJString(subscriptionId))
  result = call_568263.call(path_568264, query_568265, nil, nil, nil)

var loadBalancerBackendAddressPoolsList* = Call_LoadBalancerBackendAddressPoolsList_568255(
    name: "loadBalancerBackendAddressPoolsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/loadBalancers/{loadBalancerName}/backendAddressPools",
    validator: validate_LoadBalancerBackendAddressPoolsList_568256, base: "",
    url: url_LoadBalancerBackendAddressPoolsList_568257, schemes: {Scheme.Https})
type
  Call_LoadBalancerBackendAddressPoolsGet_568266 = ref object of OpenApiRestCall_567657
proc url_LoadBalancerBackendAddressPoolsGet_568268(protocol: Scheme; host: string;
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

proc validate_LoadBalancerBackendAddressPoolsGet_568267(path: JsonNode;
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
  var valid_568269 = path.getOrDefault("resourceGroupName")
  valid_568269 = validateParameter(valid_568269, JString, required = true,
                                 default = nil)
  if valid_568269 != nil:
    section.add "resourceGroupName", valid_568269
  var valid_568270 = path.getOrDefault("backendAddressPoolName")
  valid_568270 = validateParameter(valid_568270, JString, required = true,
                                 default = nil)
  if valid_568270 != nil:
    section.add "backendAddressPoolName", valid_568270
  var valid_568271 = path.getOrDefault("loadBalancerName")
  valid_568271 = validateParameter(valid_568271, JString, required = true,
                                 default = nil)
  if valid_568271 != nil:
    section.add "loadBalancerName", valid_568271
  var valid_568272 = path.getOrDefault("subscriptionId")
  valid_568272 = validateParameter(valid_568272, JString, required = true,
                                 default = nil)
  if valid_568272 != nil:
    section.add "subscriptionId", valid_568272
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568273 = query.getOrDefault("api-version")
  valid_568273 = validateParameter(valid_568273, JString, required = true,
                                 default = nil)
  if valid_568273 != nil:
    section.add "api-version", valid_568273
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568274: Call_LoadBalancerBackendAddressPoolsGet_568266;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets load balancer backend address pool.
  ## 
  let valid = call_568274.validator(path, query, header, formData, body)
  let scheme = call_568274.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568274.url(scheme.get, call_568274.host, call_568274.base,
                         call_568274.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568274, url, valid)

proc call*(call_568275: Call_LoadBalancerBackendAddressPoolsGet_568266;
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
  var path_568276 = newJObject()
  var query_568277 = newJObject()
  add(path_568276, "resourceGroupName", newJString(resourceGroupName))
  add(path_568276, "backendAddressPoolName", newJString(backendAddressPoolName))
  add(query_568277, "api-version", newJString(apiVersion))
  add(path_568276, "loadBalancerName", newJString(loadBalancerName))
  add(path_568276, "subscriptionId", newJString(subscriptionId))
  result = call_568275.call(path_568276, query_568277, nil, nil, nil)

var loadBalancerBackendAddressPoolsGet* = Call_LoadBalancerBackendAddressPoolsGet_568266(
    name: "loadBalancerBackendAddressPoolsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/loadBalancers/{loadBalancerName}/backendAddressPools/{backendAddressPoolName}",
    validator: validate_LoadBalancerBackendAddressPoolsGet_568267, base: "",
    url: url_LoadBalancerBackendAddressPoolsGet_568268, schemes: {Scheme.Https})
type
  Call_LoadBalancerFrontendIPConfigurationsList_568278 = ref object of OpenApiRestCall_567657
proc url_LoadBalancerFrontendIPConfigurationsList_568280(protocol: Scheme;
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

proc validate_LoadBalancerFrontendIPConfigurationsList_568279(path: JsonNode;
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
  var valid_568281 = path.getOrDefault("resourceGroupName")
  valid_568281 = validateParameter(valid_568281, JString, required = true,
                                 default = nil)
  if valid_568281 != nil:
    section.add "resourceGroupName", valid_568281
  var valid_568282 = path.getOrDefault("loadBalancerName")
  valid_568282 = validateParameter(valid_568282, JString, required = true,
                                 default = nil)
  if valid_568282 != nil:
    section.add "loadBalancerName", valid_568282
  var valid_568283 = path.getOrDefault("subscriptionId")
  valid_568283 = validateParameter(valid_568283, JString, required = true,
                                 default = nil)
  if valid_568283 != nil:
    section.add "subscriptionId", valid_568283
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568284 = query.getOrDefault("api-version")
  valid_568284 = validateParameter(valid_568284, JString, required = true,
                                 default = nil)
  if valid_568284 != nil:
    section.add "api-version", valid_568284
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568285: Call_LoadBalancerFrontendIPConfigurationsList_568278;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets all the load balancer frontend IP configurations.
  ## 
  let valid = call_568285.validator(path, query, header, formData, body)
  let scheme = call_568285.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568285.url(scheme.get, call_568285.host, call_568285.base,
                         call_568285.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568285, url, valid)

proc call*(call_568286: Call_LoadBalancerFrontendIPConfigurationsList_568278;
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
  var path_568287 = newJObject()
  var query_568288 = newJObject()
  add(path_568287, "resourceGroupName", newJString(resourceGroupName))
  add(query_568288, "api-version", newJString(apiVersion))
  add(path_568287, "loadBalancerName", newJString(loadBalancerName))
  add(path_568287, "subscriptionId", newJString(subscriptionId))
  result = call_568286.call(path_568287, query_568288, nil, nil, nil)

var loadBalancerFrontendIPConfigurationsList* = Call_LoadBalancerFrontendIPConfigurationsList_568278(
    name: "loadBalancerFrontendIPConfigurationsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/loadBalancers/{loadBalancerName}/frontendIPConfigurations",
    validator: validate_LoadBalancerFrontendIPConfigurationsList_568279, base: "",
    url: url_LoadBalancerFrontendIPConfigurationsList_568280,
    schemes: {Scheme.Https})
type
  Call_LoadBalancerFrontendIPConfigurationsGet_568289 = ref object of OpenApiRestCall_567657
proc url_LoadBalancerFrontendIPConfigurationsGet_568291(protocol: Scheme;
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

proc validate_LoadBalancerFrontendIPConfigurationsGet_568290(path: JsonNode;
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
  var valid_568292 = path.getOrDefault("resourceGroupName")
  valid_568292 = validateParameter(valid_568292, JString, required = true,
                                 default = nil)
  if valid_568292 != nil:
    section.add "resourceGroupName", valid_568292
  var valid_568293 = path.getOrDefault("loadBalancerName")
  valid_568293 = validateParameter(valid_568293, JString, required = true,
                                 default = nil)
  if valid_568293 != nil:
    section.add "loadBalancerName", valid_568293
  var valid_568294 = path.getOrDefault("subscriptionId")
  valid_568294 = validateParameter(valid_568294, JString, required = true,
                                 default = nil)
  if valid_568294 != nil:
    section.add "subscriptionId", valid_568294
  var valid_568295 = path.getOrDefault("frontendIPConfigurationName")
  valid_568295 = validateParameter(valid_568295, JString, required = true,
                                 default = nil)
  if valid_568295 != nil:
    section.add "frontendIPConfigurationName", valid_568295
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568296 = query.getOrDefault("api-version")
  valid_568296 = validateParameter(valid_568296, JString, required = true,
                                 default = nil)
  if valid_568296 != nil:
    section.add "api-version", valid_568296
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568297: Call_LoadBalancerFrontendIPConfigurationsGet_568289;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets load balancer frontend IP configuration.
  ## 
  let valid = call_568297.validator(path, query, header, formData, body)
  let scheme = call_568297.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568297.url(scheme.get, call_568297.host, call_568297.base,
                         call_568297.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568297, url, valid)

proc call*(call_568298: Call_LoadBalancerFrontendIPConfigurationsGet_568289;
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
  var path_568299 = newJObject()
  var query_568300 = newJObject()
  add(path_568299, "resourceGroupName", newJString(resourceGroupName))
  add(query_568300, "api-version", newJString(apiVersion))
  add(path_568299, "loadBalancerName", newJString(loadBalancerName))
  add(path_568299, "subscriptionId", newJString(subscriptionId))
  add(path_568299, "frontendIPConfigurationName",
      newJString(frontendIPConfigurationName))
  result = call_568298.call(path_568299, query_568300, nil, nil, nil)

var loadBalancerFrontendIPConfigurationsGet* = Call_LoadBalancerFrontendIPConfigurationsGet_568289(
    name: "loadBalancerFrontendIPConfigurationsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/loadBalancers/{loadBalancerName}/frontendIPConfigurations/{frontendIPConfigurationName}",
    validator: validate_LoadBalancerFrontendIPConfigurationsGet_568290, base: "",
    url: url_LoadBalancerFrontendIPConfigurationsGet_568291,
    schemes: {Scheme.Https})
type
  Call_InboundNatRulesList_568301 = ref object of OpenApiRestCall_567657
proc url_InboundNatRulesList_568303(protocol: Scheme; host: string; base: string;
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

proc validate_InboundNatRulesList_568302(path: JsonNode; query: JsonNode;
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
  var valid_568304 = path.getOrDefault("resourceGroupName")
  valid_568304 = validateParameter(valid_568304, JString, required = true,
                                 default = nil)
  if valid_568304 != nil:
    section.add "resourceGroupName", valid_568304
  var valid_568305 = path.getOrDefault("loadBalancerName")
  valid_568305 = validateParameter(valid_568305, JString, required = true,
                                 default = nil)
  if valid_568305 != nil:
    section.add "loadBalancerName", valid_568305
  var valid_568306 = path.getOrDefault("subscriptionId")
  valid_568306 = validateParameter(valid_568306, JString, required = true,
                                 default = nil)
  if valid_568306 != nil:
    section.add "subscriptionId", valid_568306
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
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

proc call*(call_568308: Call_InboundNatRulesList_568301; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all the inbound nat rules in a load balancer.
  ## 
  let valid = call_568308.validator(path, query, header, formData, body)
  let scheme = call_568308.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568308.url(scheme.get, call_568308.host, call_568308.base,
                         call_568308.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568308, url, valid)

proc call*(call_568309: Call_InboundNatRulesList_568301; resourceGroupName: string;
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
  var path_568310 = newJObject()
  var query_568311 = newJObject()
  add(path_568310, "resourceGroupName", newJString(resourceGroupName))
  add(query_568311, "api-version", newJString(apiVersion))
  add(path_568310, "loadBalancerName", newJString(loadBalancerName))
  add(path_568310, "subscriptionId", newJString(subscriptionId))
  result = call_568309.call(path_568310, query_568311, nil, nil, nil)

var inboundNatRulesList* = Call_InboundNatRulesList_568301(
    name: "inboundNatRulesList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/loadBalancers/{loadBalancerName}/inboundNatRules",
    validator: validate_InboundNatRulesList_568302, base: "",
    url: url_InboundNatRulesList_568303, schemes: {Scheme.Https})
type
  Call_InboundNatRulesCreateOrUpdate_568325 = ref object of OpenApiRestCall_567657
proc url_InboundNatRulesCreateOrUpdate_568327(protocol: Scheme; host: string;
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

proc validate_InboundNatRulesCreateOrUpdate_568326(path: JsonNode; query: JsonNode;
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
  var valid_568328 = path.getOrDefault("resourceGroupName")
  valid_568328 = validateParameter(valid_568328, JString, required = true,
                                 default = nil)
  if valid_568328 != nil:
    section.add "resourceGroupName", valid_568328
  var valid_568329 = path.getOrDefault("loadBalancerName")
  valid_568329 = validateParameter(valid_568329, JString, required = true,
                                 default = nil)
  if valid_568329 != nil:
    section.add "loadBalancerName", valid_568329
  var valid_568330 = path.getOrDefault("subscriptionId")
  valid_568330 = validateParameter(valid_568330, JString, required = true,
                                 default = nil)
  if valid_568330 != nil:
    section.add "subscriptionId", valid_568330
  var valid_568331 = path.getOrDefault("inboundNatRuleName")
  valid_568331 = validateParameter(valid_568331, JString, required = true,
                                 default = nil)
  if valid_568331 != nil:
    section.add "inboundNatRuleName", valid_568331
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568332 = query.getOrDefault("api-version")
  valid_568332 = validateParameter(valid_568332, JString, required = true,
                                 default = nil)
  if valid_568332 != nil:
    section.add "api-version", valid_568332
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

proc call*(call_568334: Call_InboundNatRulesCreateOrUpdate_568325; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates a load balancer inbound nat rule.
  ## 
  let valid = call_568334.validator(path, query, header, formData, body)
  let scheme = call_568334.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568334.url(scheme.get, call_568334.host, call_568334.base,
                         call_568334.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568334, url, valid)

proc call*(call_568335: Call_InboundNatRulesCreateOrUpdate_568325;
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
  var path_568336 = newJObject()
  var query_568337 = newJObject()
  var body_568338 = newJObject()
  add(path_568336, "resourceGroupName", newJString(resourceGroupName))
  add(query_568337, "api-version", newJString(apiVersion))
  add(path_568336, "loadBalancerName", newJString(loadBalancerName))
  add(path_568336, "subscriptionId", newJString(subscriptionId))
  if inboundNatRuleParameters != nil:
    body_568338 = inboundNatRuleParameters
  add(path_568336, "inboundNatRuleName", newJString(inboundNatRuleName))
  result = call_568335.call(path_568336, query_568337, nil, nil, body_568338)

var inboundNatRulesCreateOrUpdate* = Call_InboundNatRulesCreateOrUpdate_568325(
    name: "inboundNatRulesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/loadBalancers/{loadBalancerName}/inboundNatRules/{inboundNatRuleName}",
    validator: validate_InboundNatRulesCreateOrUpdate_568326, base: "",
    url: url_InboundNatRulesCreateOrUpdate_568327, schemes: {Scheme.Https})
type
  Call_InboundNatRulesGet_568312 = ref object of OpenApiRestCall_567657
proc url_InboundNatRulesGet_568314(protocol: Scheme; host: string; base: string;
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

proc validate_InboundNatRulesGet_568313(path: JsonNode; query: JsonNode;
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
  var valid_568315 = path.getOrDefault("resourceGroupName")
  valid_568315 = validateParameter(valid_568315, JString, required = true,
                                 default = nil)
  if valid_568315 != nil:
    section.add "resourceGroupName", valid_568315
  var valid_568316 = path.getOrDefault("loadBalancerName")
  valid_568316 = validateParameter(valid_568316, JString, required = true,
                                 default = nil)
  if valid_568316 != nil:
    section.add "loadBalancerName", valid_568316
  var valid_568317 = path.getOrDefault("subscriptionId")
  valid_568317 = validateParameter(valid_568317, JString, required = true,
                                 default = nil)
  if valid_568317 != nil:
    section.add "subscriptionId", valid_568317
  var valid_568318 = path.getOrDefault("inboundNatRuleName")
  valid_568318 = validateParameter(valid_568318, JString, required = true,
                                 default = nil)
  if valid_568318 != nil:
    section.add "inboundNatRuleName", valid_568318
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $expand: JString
  ##          : Expands referenced resources.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568319 = query.getOrDefault("api-version")
  valid_568319 = validateParameter(valid_568319, JString, required = true,
                                 default = nil)
  if valid_568319 != nil:
    section.add "api-version", valid_568319
  var valid_568320 = query.getOrDefault("$expand")
  valid_568320 = validateParameter(valid_568320, JString, required = false,
                                 default = nil)
  if valid_568320 != nil:
    section.add "$expand", valid_568320
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568321: Call_InboundNatRulesGet_568312; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the specified load balancer inbound nat rule.
  ## 
  let valid = call_568321.validator(path, query, header, formData, body)
  let scheme = call_568321.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568321.url(scheme.get, call_568321.host, call_568321.base,
                         call_568321.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568321, url, valid)

proc call*(call_568322: Call_InboundNatRulesGet_568312; resourceGroupName: string;
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
  var path_568323 = newJObject()
  var query_568324 = newJObject()
  add(path_568323, "resourceGroupName", newJString(resourceGroupName))
  add(query_568324, "api-version", newJString(apiVersion))
  add(query_568324, "$expand", newJString(Expand))
  add(path_568323, "loadBalancerName", newJString(loadBalancerName))
  add(path_568323, "subscriptionId", newJString(subscriptionId))
  add(path_568323, "inboundNatRuleName", newJString(inboundNatRuleName))
  result = call_568322.call(path_568323, query_568324, nil, nil, nil)

var inboundNatRulesGet* = Call_InboundNatRulesGet_568312(
    name: "inboundNatRulesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/loadBalancers/{loadBalancerName}/inboundNatRules/{inboundNatRuleName}",
    validator: validate_InboundNatRulesGet_568313, base: "",
    url: url_InboundNatRulesGet_568314, schemes: {Scheme.Https})
type
  Call_InboundNatRulesDelete_568339 = ref object of OpenApiRestCall_567657
proc url_InboundNatRulesDelete_568341(protocol: Scheme; host: string; base: string;
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

proc validate_InboundNatRulesDelete_568340(path: JsonNode; query: JsonNode;
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
  var valid_568342 = path.getOrDefault("resourceGroupName")
  valid_568342 = validateParameter(valid_568342, JString, required = true,
                                 default = nil)
  if valid_568342 != nil:
    section.add "resourceGroupName", valid_568342
  var valid_568343 = path.getOrDefault("loadBalancerName")
  valid_568343 = validateParameter(valid_568343, JString, required = true,
                                 default = nil)
  if valid_568343 != nil:
    section.add "loadBalancerName", valid_568343
  var valid_568344 = path.getOrDefault("subscriptionId")
  valid_568344 = validateParameter(valid_568344, JString, required = true,
                                 default = nil)
  if valid_568344 != nil:
    section.add "subscriptionId", valid_568344
  var valid_568345 = path.getOrDefault("inboundNatRuleName")
  valid_568345 = validateParameter(valid_568345, JString, required = true,
                                 default = nil)
  if valid_568345 != nil:
    section.add "inboundNatRuleName", valid_568345
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568346 = query.getOrDefault("api-version")
  valid_568346 = validateParameter(valid_568346, JString, required = true,
                                 default = nil)
  if valid_568346 != nil:
    section.add "api-version", valid_568346
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568347: Call_InboundNatRulesDelete_568339; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified load balancer inbound nat rule.
  ## 
  let valid = call_568347.validator(path, query, header, formData, body)
  let scheme = call_568347.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568347.url(scheme.get, call_568347.host, call_568347.base,
                         call_568347.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568347, url, valid)

proc call*(call_568348: Call_InboundNatRulesDelete_568339;
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
  var path_568349 = newJObject()
  var query_568350 = newJObject()
  add(path_568349, "resourceGroupName", newJString(resourceGroupName))
  add(query_568350, "api-version", newJString(apiVersion))
  add(path_568349, "loadBalancerName", newJString(loadBalancerName))
  add(path_568349, "subscriptionId", newJString(subscriptionId))
  add(path_568349, "inboundNatRuleName", newJString(inboundNatRuleName))
  result = call_568348.call(path_568349, query_568350, nil, nil, nil)

var inboundNatRulesDelete* = Call_InboundNatRulesDelete_568339(
    name: "inboundNatRulesDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/loadBalancers/{loadBalancerName}/inboundNatRules/{inboundNatRuleName}",
    validator: validate_InboundNatRulesDelete_568340, base: "",
    url: url_InboundNatRulesDelete_568341, schemes: {Scheme.Https})
type
  Call_LoadBalancerLoadBalancingRulesList_568351 = ref object of OpenApiRestCall_567657
proc url_LoadBalancerLoadBalancingRulesList_568353(protocol: Scheme; host: string;
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

proc validate_LoadBalancerLoadBalancingRulesList_568352(path: JsonNode;
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
  var valid_568354 = path.getOrDefault("resourceGroupName")
  valid_568354 = validateParameter(valid_568354, JString, required = true,
                                 default = nil)
  if valid_568354 != nil:
    section.add "resourceGroupName", valid_568354
  var valid_568355 = path.getOrDefault("loadBalancerName")
  valid_568355 = validateParameter(valid_568355, JString, required = true,
                                 default = nil)
  if valid_568355 != nil:
    section.add "loadBalancerName", valid_568355
  var valid_568356 = path.getOrDefault("subscriptionId")
  valid_568356 = validateParameter(valid_568356, JString, required = true,
                                 default = nil)
  if valid_568356 != nil:
    section.add "subscriptionId", valid_568356
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568357 = query.getOrDefault("api-version")
  valid_568357 = validateParameter(valid_568357, JString, required = true,
                                 default = nil)
  if valid_568357 != nil:
    section.add "api-version", valid_568357
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568358: Call_LoadBalancerLoadBalancingRulesList_568351;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets all the load balancing rules in a load balancer.
  ## 
  let valid = call_568358.validator(path, query, header, formData, body)
  let scheme = call_568358.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568358.url(scheme.get, call_568358.host, call_568358.base,
                         call_568358.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568358, url, valid)

proc call*(call_568359: Call_LoadBalancerLoadBalancingRulesList_568351;
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
  var path_568360 = newJObject()
  var query_568361 = newJObject()
  add(path_568360, "resourceGroupName", newJString(resourceGroupName))
  add(query_568361, "api-version", newJString(apiVersion))
  add(path_568360, "loadBalancerName", newJString(loadBalancerName))
  add(path_568360, "subscriptionId", newJString(subscriptionId))
  result = call_568359.call(path_568360, query_568361, nil, nil, nil)

var loadBalancerLoadBalancingRulesList* = Call_LoadBalancerLoadBalancingRulesList_568351(
    name: "loadBalancerLoadBalancingRulesList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/loadBalancers/{loadBalancerName}/loadBalancingRules",
    validator: validate_LoadBalancerLoadBalancingRulesList_568352, base: "",
    url: url_LoadBalancerLoadBalancingRulesList_568353, schemes: {Scheme.Https})
type
  Call_LoadBalancerLoadBalancingRulesGet_568362 = ref object of OpenApiRestCall_567657
proc url_LoadBalancerLoadBalancingRulesGet_568364(protocol: Scheme; host: string;
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

proc validate_LoadBalancerLoadBalancingRulesGet_568363(path: JsonNode;
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
  var valid_568365 = path.getOrDefault("resourceGroupName")
  valid_568365 = validateParameter(valid_568365, JString, required = true,
                                 default = nil)
  if valid_568365 != nil:
    section.add "resourceGroupName", valid_568365
  var valid_568366 = path.getOrDefault("loadBalancerName")
  valid_568366 = validateParameter(valid_568366, JString, required = true,
                                 default = nil)
  if valid_568366 != nil:
    section.add "loadBalancerName", valid_568366
  var valid_568367 = path.getOrDefault("subscriptionId")
  valid_568367 = validateParameter(valid_568367, JString, required = true,
                                 default = nil)
  if valid_568367 != nil:
    section.add "subscriptionId", valid_568367
  var valid_568368 = path.getOrDefault("loadBalancingRuleName")
  valid_568368 = validateParameter(valid_568368, JString, required = true,
                                 default = nil)
  if valid_568368 != nil:
    section.add "loadBalancingRuleName", valid_568368
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568369 = query.getOrDefault("api-version")
  valid_568369 = validateParameter(valid_568369, JString, required = true,
                                 default = nil)
  if valid_568369 != nil:
    section.add "api-version", valid_568369
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568370: Call_LoadBalancerLoadBalancingRulesGet_568362;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the specified load balancer load balancing rule.
  ## 
  let valid = call_568370.validator(path, query, header, formData, body)
  let scheme = call_568370.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568370.url(scheme.get, call_568370.host, call_568370.base,
                         call_568370.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568370, url, valid)

proc call*(call_568371: Call_LoadBalancerLoadBalancingRulesGet_568362;
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
  var path_568372 = newJObject()
  var query_568373 = newJObject()
  add(path_568372, "resourceGroupName", newJString(resourceGroupName))
  add(query_568373, "api-version", newJString(apiVersion))
  add(path_568372, "loadBalancerName", newJString(loadBalancerName))
  add(path_568372, "subscriptionId", newJString(subscriptionId))
  add(path_568372, "loadBalancingRuleName", newJString(loadBalancingRuleName))
  result = call_568371.call(path_568372, query_568373, nil, nil, nil)

var loadBalancerLoadBalancingRulesGet* = Call_LoadBalancerLoadBalancingRulesGet_568362(
    name: "loadBalancerLoadBalancingRulesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/loadBalancers/{loadBalancerName}/loadBalancingRules/{loadBalancingRuleName}",
    validator: validate_LoadBalancerLoadBalancingRulesGet_568363, base: "",
    url: url_LoadBalancerLoadBalancingRulesGet_568364, schemes: {Scheme.Https})
type
  Call_LoadBalancerNetworkInterfacesList_568374 = ref object of OpenApiRestCall_567657
proc url_LoadBalancerNetworkInterfacesList_568376(protocol: Scheme; host: string;
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

proc validate_LoadBalancerNetworkInterfacesList_568375(path: JsonNode;
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
  var valid_568377 = path.getOrDefault("resourceGroupName")
  valid_568377 = validateParameter(valid_568377, JString, required = true,
                                 default = nil)
  if valid_568377 != nil:
    section.add "resourceGroupName", valid_568377
  var valid_568378 = path.getOrDefault("loadBalancerName")
  valid_568378 = validateParameter(valid_568378, JString, required = true,
                                 default = nil)
  if valid_568378 != nil:
    section.add "loadBalancerName", valid_568378
  var valid_568379 = path.getOrDefault("subscriptionId")
  valid_568379 = validateParameter(valid_568379, JString, required = true,
                                 default = nil)
  if valid_568379 != nil:
    section.add "subscriptionId", valid_568379
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568380 = query.getOrDefault("api-version")
  valid_568380 = validateParameter(valid_568380, JString, required = true,
                                 default = nil)
  if valid_568380 != nil:
    section.add "api-version", valid_568380
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568381: Call_LoadBalancerNetworkInterfacesList_568374;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets associated load balancer network interfaces.
  ## 
  let valid = call_568381.validator(path, query, header, formData, body)
  let scheme = call_568381.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568381.url(scheme.get, call_568381.host, call_568381.base,
                         call_568381.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568381, url, valid)

proc call*(call_568382: Call_LoadBalancerNetworkInterfacesList_568374;
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
  var path_568383 = newJObject()
  var query_568384 = newJObject()
  add(path_568383, "resourceGroupName", newJString(resourceGroupName))
  add(query_568384, "api-version", newJString(apiVersion))
  add(path_568383, "loadBalancerName", newJString(loadBalancerName))
  add(path_568383, "subscriptionId", newJString(subscriptionId))
  result = call_568382.call(path_568383, query_568384, nil, nil, nil)

var loadBalancerNetworkInterfacesList* = Call_LoadBalancerNetworkInterfacesList_568374(
    name: "loadBalancerNetworkInterfacesList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/loadBalancers/{loadBalancerName}/networkInterfaces",
    validator: validate_LoadBalancerNetworkInterfacesList_568375, base: "",
    url: url_LoadBalancerNetworkInterfacesList_568376, schemes: {Scheme.Https})
type
  Call_LoadBalancerProbesList_568385 = ref object of OpenApiRestCall_567657
proc url_LoadBalancerProbesList_568387(protocol: Scheme; host: string; base: string;
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

proc validate_LoadBalancerProbesList_568386(path: JsonNode; query: JsonNode;
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
  var valid_568388 = path.getOrDefault("resourceGroupName")
  valid_568388 = validateParameter(valid_568388, JString, required = true,
                                 default = nil)
  if valid_568388 != nil:
    section.add "resourceGroupName", valid_568388
  var valid_568389 = path.getOrDefault("loadBalancerName")
  valid_568389 = validateParameter(valid_568389, JString, required = true,
                                 default = nil)
  if valid_568389 != nil:
    section.add "loadBalancerName", valid_568389
  var valid_568390 = path.getOrDefault("subscriptionId")
  valid_568390 = validateParameter(valid_568390, JString, required = true,
                                 default = nil)
  if valid_568390 != nil:
    section.add "subscriptionId", valid_568390
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568391 = query.getOrDefault("api-version")
  valid_568391 = validateParameter(valid_568391, JString, required = true,
                                 default = nil)
  if valid_568391 != nil:
    section.add "api-version", valid_568391
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568392: Call_LoadBalancerProbesList_568385; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all the load balancer probes.
  ## 
  let valid = call_568392.validator(path, query, header, formData, body)
  let scheme = call_568392.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568392.url(scheme.get, call_568392.host, call_568392.base,
                         call_568392.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568392, url, valid)

proc call*(call_568393: Call_LoadBalancerProbesList_568385;
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
  var path_568394 = newJObject()
  var query_568395 = newJObject()
  add(path_568394, "resourceGroupName", newJString(resourceGroupName))
  add(query_568395, "api-version", newJString(apiVersion))
  add(path_568394, "loadBalancerName", newJString(loadBalancerName))
  add(path_568394, "subscriptionId", newJString(subscriptionId))
  result = call_568393.call(path_568394, query_568395, nil, nil, nil)

var loadBalancerProbesList* = Call_LoadBalancerProbesList_568385(
    name: "loadBalancerProbesList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/loadBalancers/{loadBalancerName}/probes",
    validator: validate_LoadBalancerProbesList_568386, base: "",
    url: url_LoadBalancerProbesList_568387, schemes: {Scheme.Https})
type
  Call_LoadBalancerProbesGet_568396 = ref object of OpenApiRestCall_567657
proc url_LoadBalancerProbesGet_568398(protocol: Scheme; host: string; base: string;
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

proc validate_LoadBalancerProbesGet_568397(path: JsonNode; query: JsonNode;
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
  var valid_568399 = path.getOrDefault("resourceGroupName")
  valid_568399 = validateParameter(valid_568399, JString, required = true,
                                 default = nil)
  if valid_568399 != nil:
    section.add "resourceGroupName", valid_568399
  var valid_568400 = path.getOrDefault("probeName")
  valid_568400 = validateParameter(valid_568400, JString, required = true,
                                 default = nil)
  if valid_568400 != nil:
    section.add "probeName", valid_568400
  var valid_568401 = path.getOrDefault("loadBalancerName")
  valid_568401 = validateParameter(valid_568401, JString, required = true,
                                 default = nil)
  if valid_568401 != nil:
    section.add "loadBalancerName", valid_568401
  var valid_568402 = path.getOrDefault("subscriptionId")
  valid_568402 = validateParameter(valid_568402, JString, required = true,
                                 default = nil)
  if valid_568402 != nil:
    section.add "subscriptionId", valid_568402
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568403 = query.getOrDefault("api-version")
  valid_568403 = validateParameter(valid_568403, JString, required = true,
                                 default = nil)
  if valid_568403 != nil:
    section.add "api-version", valid_568403
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568404: Call_LoadBalancerProbesGet_568396; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets load balancer probe.
  ## 
  let valid = call_568404.validator(path, query, header, formData, body)
  let scheme = call_568404.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568404.url(scheme.get, call_568404.host, call_568404.base,
                         call_568404.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568404, url, valid)

proc call*(call_568405: Call_LoadBalancerProbesGet_568396;
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
  var path_568406 = newJObject()
  var query_568407 = newJObject()
  add(path_568406, "resourceGroupName", newJString(resourceGroupName))
  add(query_568407, "api-version", newJString(apiVersion))
  add(path_568406, "probeName", newJString(probeName))
  add(path_568406, "loadBalancerName", newJString(loadBalancerName))
  add(path_568406, "subscriptionId", newJString(subscriptionId))
  result = call_568405.call(path_568406, query_568407, nil, nil, nil)

var loadBalancerProbesGet* = Call_LoadBalancerProbesGet_568396(
    name: "loadBalancerProbesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/loadBalancers/{loadBalancerName}/probes/{probeName}",
    validator: validate_LoadBalancerProbesGet_568397, base: "",
    url: url_LoadBalancerProbesGet_568398, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
