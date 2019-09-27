
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: NetworkManagementClient
## version: 2017-06-01
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
  macServiceName = "network-loadBalancer"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_LoadBalancersListAll_593646 = ref object of OpenApiRestCall_593424
proc url_LoadBalancersListAll_593648(protocol: Scheme; host: string; base: string;
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

proc validate_LoadBalancersListAll_593647(path: JsonNode; query: JsonNode;
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
  var valid_593821 = path.getOrDefault("subscriptionId")
  valid_593821 = validateParameter(valid_593821, JString, required = true,
                                 default = nil)
  if valid_593821 != nil:
    section.add "subscriptionId", valid_593821
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593822 = query.getOrDefault("api-version")
  valid_593822 = validateParameter(valid_593822, JString, required = true,
                                 default = nil)
  if valid_593822 != nil:
    section.add "api-version", valid_593822
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593845: Call_LoadBalancersListAll_593646; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all the load balancers in a subscription.
  ## 
  let valid = call_593845.validator(path, query, header, formData, body)
  let scheme = call_593845.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593845.url(scheme.get, call_593845.host, call_593845.base,
                         call_593845.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593845, url, valid)

proc call*(call_593916: Call_LoadBalancersListAll_593646; apiVersion: string;
          subscriptionId: string): Recallable =
  ## loadBalancersListAll
  ## Gets all the load balancers in a subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_593917 = newJObject()
  var query_593919 = newJObject()
  add(query_593919, "api-version", newJString(apiVersion))
  add(path_593917, "subscriptionId", newJString(subscriptionId))
  result = call_593916.call(path_593917, query_593919, nil, nil, nil)

var loadBalancersListAll* = Call_LoadBalancersListAll_593646(
    name: "loadBalancersListAll", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Network/loadBalancers",
    validator: validate_LoadBalancersListAll_593647, base: "",
    url: url_LoadBalancersListAll_593648, schemes: {Scheme.Https})
type
  Call_LoadBalancersList_593958 = ref object of OpenApiRestCall_593424
proc url_LoadBalancersList_593960(protocol: Scheme; host: string; base: string;
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

proc validate_LoadBalancersList_593959(path: JsonNode; query: JsonNode;
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
  var valid_593961 = path.getOrDefault("resourceGroupName")
  valid_593961 = validateParameter(valid_593961, JString, required = true,
                                 default = nil)
  if valid_593961 != nil:
    section.add "resourceGroupName", valid_593961
  var valid_593962 = path.getOrDefault("subscriptionId")
  valid_593962 = validateParameter(valid_593962, JString, required = true,
                                 default = nil)
  if valid_593962 != nil:
    section.add "subscriptionId", valid_593962
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593963 = query.getOrDefault("api-version")
  valid_593963 = validateParameter(valid_593963, JString, required = true,
                                 default = nil)
  if valid_593963 != nil:
    section.add "api-version", valid_593963
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593964: Call_LoadBalancersList_593958; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all the load balancers in a resource group.
  ## 
  let valid = call_593964.validator(path, query, header, formData, body)
  let scheme = call_593964.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593964.url(scheme.get, call_593964.host, call_593964.base,
                         call_593964.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593964, url, valid)

proc call*(call_593965: Call_LoadBalancersList_593958; resourceGroupName: string;
          apiVersion: string; subscriptionId: string): Recallable =
  ## loadBalancersList
  ## Gets all the load balancers in a resource group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_593966 = newJObject()
  var query_593967 = newJObject()
  add(path_593966, "resourceGroupName", newJString(resourceGroupName))
  add(query_593967, "api-version", newJString(apiVersion))
  add(path_593966, "subscriptionId", newJString(subscriptionId))
  result = call_593965.call(path_593966, query_593967, nil, nil, nil)

var loadBalancersList* = Call_LoadBalancersList_593958(name: "loadBalancersList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/loadBalancers",
    validator: validate_LoadBalancersList_593959, base: "",
    url: url_LoadBalancersList_593960, schemes: {Scheme.Https})
type
  Call_LoadBalancersCreateOrUpdate_593981 = ref object of OpenApiRestCall_593424
proc url_LoadBalancersCreateOrUpdate_593983(protocol: Scheme; host: string;
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

proc validate_LoadBalancersCreateOrUpdate_593982(path: JsonNode; query: JsonNode;
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
  var valid_594001 = path.getOrDefault("resourceGroupName")
  valid_594001 = validateParameter(valid_594001, JString, required = true,
                                 default = nil)
  if valid_594001 != nil:
    section.add "resourceGroupName", valid_594001
  var valid_594002 = path.getOrDefault("loadBalancerName")
  valid_594002 = validateParameter(valid_594002, JString, required = true,
                                 default = nil)
  if valid_594002 != nil:
    section.add "loadBalancerName", valid_594002
  var valid_594003 = path.getOrDefault("subscriptionId")
  valid_594003 = validateParameter(valid_594003, JString, required = true,
                                 default = nil)
  if valid_594003 != nil:
    section.add "subscriptionId", valid_594003
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594004 = query.getOrDefault("api-version")
  valid_594004 = validateParameter(valid_594004, JString, required = true,
                                 default = nil)
  if valid_594004 != nil:
    section.add "api-version", valid_594004
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

proc call*(call_594006: Call_LoadBalancersCreateOrUpdate_593981; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates a load balancer.
  ## 
  let valid = call_594006.validator(path, query, header, formData, body)
  let scheme = call_594006.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594006.url(scheme.get, call_594006.host, call_594006.base,
                         call_594006.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594006, url, valid)

proc call*(call_594007: Call_LoadBalancersCreateOrUpdate_593981;
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
  var path_594008 = newJObject()
  var query_594009 = newJObject()
  var body_594010 = newJObject()
  add(path_594008, "resourceGroupName", newJString(resourceGroupName))
  add(query_594009, "api-version", newJString(apiVersion))
  add(path_594008, "loadBalancerName", newJString(loadBalancerName))
  add(path_594008, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_594010 = parameters
  result = call_594007.call(path_594008, query_594009, nil, nil, body_594010)

var loadBalancersCreateOrUpdate* = Call_LoadBalancersCreateOrUpdate_593981(
    name: "loadBalancersCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/loadBalancers/{loadBalancerName}",
    validator: validate_LoadBalancersCreateOrUpdate_593982, base: "",
    url: url_LoadBalancersCreateOrUpdate_593983, schemes: {Scheme.Https})
type
  Call_LoadBalancersGet_593968 = ref object of OpenApiRestCall_593424
proc url_LoadBalancersGet_593970(protocol: Scheme; host: string; base: string;
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

proc validate_LoadBalancersGet_593969(path: JsonNode; query: JsonNode;
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
  var valid_593972 = path.getOrDefault("resourceGroupName")
  valid_593972 = validateParameter(valid_593972, JString, required = true,
                                 default = nil)
  if valid_593972 != nil:
    section.add "resourceGroupName", valid_593972
  var valid_593973 = path.getOrDefault("loadBalancerName")
  valid_593973 = validateParameter(valid_593973, JString, required = true,
                                 default = nil)
  if valid_593973 != nil:
    section.add "loadBalancerName", valid_593973
  var valid_593974 = path.getOrDefault("subscriptionId")
  valid_593974 = validateParameter(valid_593974, JString, required = true,
                                 default = nil)
  if valid_593974 != nil:
    section.add "subscriptionId", valid_593974
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $expand: JString
  ##          : Expands referenced resources.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593975 = query.getOrDefault("api-version")
  valid_593975 = validateParameter(valid_593975, JString, required = true,
                                 default = nil)
  if valid_593975 != nil:
    section.add "api-version", valid_593975
  var valid_593976 = query.getOrDefault("$expand")
  valid_593976 = validateParameter(valid_593976, JString, required = false,
                                 default = nil)
  if valid_593976 != nil:
    section.add "$expand", valid_593976
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593977: Call_LoadBalancersGet_593968; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the specified load balancer.
  ## 
  let valid = call_593977.validator(path, query, header, formData, body)
  let scheme = call_593977.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593977.url(scheme.get, call_593977.host, call_593977.base,
                         call_593977.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593977, url, valid)

proc call*(call_593978: Call_LoadBalancersGet_593968; resourceGroupName: string;
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
  var path_593979 = newJObject()
  var query_593980 = newJObject()
  add(path_593979, "resourceGroupName", newJString(resourceGroupName))
  add(query_593980, "api-version", newJString(apiVersion))
  add(query_593980, "$expand", newJString(Expand))
  add(path_593979, "loadBalancerName", newJString(loadBalancerName))
  add(path_593979, "subscriptionId", newJString(subscriptionId))
  result = call_593978.call(path_593979, query_593980, nil, nil, nil)

var loadBalancersGet* = Call_LoadBalancersGet_593968(name: "loadBalancersGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/loadBalancers/{loadBalancerName}",
    validator: validate_LoadBalancersGet_593969, base: "",
    url: url_LoadBalancersGet_593970, schemes: {Scheme.Https})
type
  Call_LoadBalancersDelete_594011 = ref object of OpenApiRestCall_593424
proc url_LoadBalancersDelete_594013(protocol: Scheme; host: string; base: string;
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

proc validate_LoadBalancersDelete_594012(path: JsonNode; query: JsonNode;
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
  var valid_594014 = path.getOrDefault("resourceGroupName")
  valid_594014 = validateParameter(valid_594014, JString, required = true,
                                 default = nil)
  if valid_594014 != nil:
    section.add "resourceGroupName", valid_594014
  var valid_594015 = path.getOrDefault("loadBalancerName")
  valid_594015 = validateParameter(valid_594015, JString, required = true,
                                 default = nil)
  if valid_594015 != nil:
    section.add "loadBalancerName", valid_594015
  var valid_594016 = path.getOrDefault("subscriptionId")
  valid_594016 = validateParameter(valid_594016, JString, required = true,
                                 default = nil)
  if valid_594016 != nil:
    section.add "subscriptionId", valid_594016
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594017 = query.getOrDefault("api-version")
  valid_594017 = validateParameter(valid_594017, JString, required = true,
                                 default = nil)
  if valid_594017 != nil:
    section.add "api-version", valid_594017
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594018: Call_LoadBalancersDelete_594011; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified load balancer.
  ## 
  let valid = call_594018.validator(path, query, header, formData, body)
  let scheme = call_594018.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594018.url(scheme.get, call_594018.host, call_594018.base,
                         call_594018.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594018, url, valid)

proc call*(call_594019: Call_LoadBalancersDelete_594011; resourceGroupName: string;
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
  var path_594020 = newJObject()
  var query_594021 = newJObject()
  add(path_594020, "resourceGroupName", newJString(resourceGroupName))
  add(query_594021, "api-version", newJString(apiVersion))
  add(path_594020, "loadBalancerName", newJString(loadBalancerName))
  add(path_594020, "subscriptionId", newJString(subscriptionId))
  result = call_594019.call(path_594020, query_594021, nil, nil, nil)

var loadBalancersDelete* = Call_LoadBalancersDelete_594011(
    name: "loadBalancersDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/loadBalancers/{loadBalancerName}",
    validator: validate_LoadBalancersDelete_594012, base: "",
    url: url_LoadBalancersDelete_594013, schemes: {Scheme.Https})
type
  Call_LoadBalancerBackendAddressPoolsList_594022 = ref object of OpenApiRestCall_593424
proc url_LoadBalancerBackendAddressPoolsList_594024(protocol: Scheme; host: string;
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

proc validate_LoadBalancerBackendAddressPoolsList_594023(path: JsonNode;
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
  var valid_594025 = path.getOrDefault("resourceGroupName")
  valid_594025 = validateParameter(valid_594025, JString, required = true,
                                 default = nil)
  if valid_594025 != nil:
    section.add "resourceGroupName", valid_594025
  var valid_594026 = path.getOrDefault("loadBalancerName")
  valid_594026 = validateParameter(valid_594026, JString, required = true,
                                 default = nil)
  if valid_594026 != nil:
    section.add "loadBalancerName", valid_594026
  var valid_594027 = path.getOrDefault("subscriptionId")
  valid_594027 = validateParameter(valid_594027, JString, required = true,
                                 default = nil)
  if valid_594027 != nil:
    section.add "subscriptionId", valid_594027
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594028 = query.getOrDefault("api-version")
  valid_594028 = validateParameter(valid_594028, JString, required = true,
                                 default = nil)
  if valid_594028 != nil:
    section.add "api-version", valid_594028
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594029: Call_LoadBalancerBackendAddressPoolsList_594022;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets all the load balancer backed address pools.
  ## 
  let valid = call_594029.validator(path, query, header, formData, body)
  let scheme = call_594029.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594029.url(scheme.get, call_594029.host, call_594029.base,
                         call_594029.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594029, url, valid)

proc call*(call_594030: Call_LoadBalancerBackendAddressPoolsList_594022;
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
  var path_594031 = newJObject()
  var query_594032 = newJObject()
  add(path_594031, "resourceGroupName", newJString(resourceGroupName))
  add(query_594032, "api-version", newJString(apiVersion))
  add(path_594031, "loadBalancerName", newJString(loadBalancerName))
  add(path_594031, "subscriptionId", newJString(subscriptionId))
  result = call_594030.call(path_594031, query_594032, nil, nil, nil)

var loadBalancerBackendAddressPoolsList* = Call_LoadBalancerBackendAddressPoolsList_594022(
    name: "loadBalancerBackendAddressPoolsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/loadBalancers/{loadBalancerName}/backendAddressPools",
    validator: validate_LoadBalancerBackendAddressPoolsList_594023, base: "",
    url: url_LoadBalancerBackendAddressPoolsList_594024, schemes: {Scheme.Https})
type
  Call_LoadBalancerBackendAddressPoolsGet_594033 = ref object of OpenApiRestCall_593424
proc url_LoadBalancerBackendAddressPoolsGet_594035(protocol: Scheme; host: string;
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

proc validate_LoadBalancerBackendAddressPoolsGet_594034(path: JsonNode;
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
  var valid_594036 = path.getOrDefault("resourceGroupName")
  valid_594036 = validateParameter(valid_594036, JString, required = true,
                                 default = nil)
  if valid_594036 != nil:
    section.add "resourceGroupName", valid_594036
  var valid_594037 = path.getOrDefault("backendAddressPoolName")
  valid_594037 = validateParameter(valid_594037, JString, required = true,
                                 default = nil)
  if valid_594037 != nil:
    section.add "backendAddressPoolName", valid_594037
  var valid_594038 = path.getOrDefault("loadBalancerName")
  valid_594038 = validateParameter(valid_594038, JString, required = true,
                                 default = nil)
  if valid_594038 != nil:
    section.add "loadBalancerName", valid_594038
  var valid_594039 = path.getOrDefault("subscriptionId")
  valid_594039 = validateParameter(valid_594039, JString, required = true,
                                 default = nil)
  if valid_594039 != nil:
    section.add "subscriptionId", valid_594039
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594040 = query.getOrDefault("api-version")
  valid_594040 = validateParameter(valid_594040, JString, required = true,
                                 default = nil)
  if valid_594040 != nil:
    section.add "api-version", valid_594040
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594041: Call_LoadBalancerBackendAddressPoolsGet_594033;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets load balancer backend address pool.
  ## 
  let valid = call_594041.validator(path, query, header, formData, body)
  let scheme = call_594041.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594041.url(scheme.get, call_594041.host, call_594041.base,
                         call_594041.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594041, url, valid)

proc call*(call_594042: Call_LoadBalancerBackendAddressPoolsGet_594033;
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
  var path_594043 = newJObject()
  var query_594044 = newJObject()
  add(path_594043, "resourceGroupName", newJString(resourceGroupName))
  add(path_594043, "backendAddressPoolName", newJString(backendAddressPoolName))
  add(query_594044, "api-version", newJString(apiVersion))
  add(path_594043, "loadBalancerName", newJString(loadBalancerName))
  add(path_594043, "subscriptionId", newJString(subscriptionId))
  result = call_594042.call(path_594043, query_594044, nil, nil, nil)

var loadBalancerBackendAddressPoolsGet* = Call_LoadBalancerBackendAddressPoolsGet_594033(
    name: "loadBalancerBackendAddressPoolsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/loadBalancers/{loadBalancerName}/backendAddressPools/{backendAddressPoolName}",
    validator: validate_LoadBalancerBackendAddressPoolsGet_594034, base: "",
    url: url_LoadBalancerBackendAddressPoolsGet_594035, schemes: {Scheme.Https})
type
  Call_LoadBalancerFrontendIPConfigurationsList_594045 = ref object of OpenApiRestCall_593424
proc url_LoadBalancerFrontendIPConfigurationsList_594047(protocol: Scheme;
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

proc validate_LoadBalancerFrontendIPConfigurationsList_594046(path: JsonNode;
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
  var valid_594048 = path.getOrDefault("resourceGroupName")
  valid_594048 = validateParameter(valid_594048, JString, required = true,
                                 default = nil)
  if valid_594048 != nil:
    section.add "resourceGroupName", valid_594048
  var valid_594049 = path.getOrDefault("loadBalancerName")
  valid_594049 = validateParameter(valid_594049, JString, required = true,
                                 default = nil)
  if valid_594049 != nil:
    section.add "loadBalancerName", valid_594049
  var valid_594050 = path.getOrDefault("subscriptionId")
  valid_594050 = validateParameter(valid_594050, JString, required = true,
                                 default = nil)
  if valid_594050 != nil:
    section.add "subscriptionId", valid_594050
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594051 = query.getOrDefault("api-version")
  valid_594051 = validateParameter(valid_594051, JString, required = true,
                                 default = nil)
  if valid_594051 != nil:
    section.add "api-version", valid_594051
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594052: Call_LoadBalancerFrontendIPConfigurationsList_594045;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets all the load balancer frontend IP configurations.
  ## 
  let valid = call_594052.validator(path, query, header, formData, body)
  let scheme = call_594052.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594052.url(scheme.get, call_594052.host, call_594052.base,
                         call_594052.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594052, url, valid)

proc call*(call_594053: Call_LoadBalancerFrontendIPConfigurationsList_594045;
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
  var path_594054 = newJObject()
  var query_594055 = newJObject()
  add(path_594054, "resourceGroupName", newJString(resourceGroupName))
  add(query_594055, "api-version", newJString(apiVersion))
  add(path_594054, "loadBalancerName", newJString(loadBalancerName))
  add(path_594054, "subscriptionId", newJString(subscriptionId))
  result = call_594053.call(path_594054, query_594055, nil, nil, nil)

var loadBalancerFrontendIPConfigurationsList* = Call_LoadBalancerFrontendIPConfigurationsList_594045(
    name: "loadBalancerFrontendIPConfigurationsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/loadBalancers/{loadBalancerName}/frontendIPConfigurations",
    validator: validate_LoadBalancerFrontendIPConfigurationsList_594046, base: "",
    url: url_LoadBalancerFrontendIPConfigurationsList_594047,
    schemes: {Scheme.Https})
type
  Call_LoadBalancerFrontendIPConfigurationsGet_594056 = ref object of OpenApiRestCall_593424
proc url_LoadBalancerFrontendIPConfigurationsGet_594058(protocol: Scheme;
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

proc validate_LoadBalancerFrontendIPConfigurationsGet_594057(path: JsonNode;
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
  var valid_594059 = path.getOrDefault("resourceGroupName")
  valid_594059 = validateParameter(valid_594059, JString, required = true,
                                 default = nil)
  if valid_594059 != nil:
    section.add "resourceGroupName", valid_594059
  var valid_594060 = path.getOrDefault("loadBalancerName")
  valid_594060 = validateParameter(valid_594060, JString, required = true,
                                 default = nil)
  if valid_594060 != nil:
    section.add "loadBalancerName", valid_594060
  var valid_594061 = path.getOrDefault("subscriptionId")
  valid_594061 = validateParameter(valid_594061, JString, required = true,
                                 default = nil)
  if valid_594061 != nil:
    section.add "subscriptionId", valid_594061
  var valid_594062 = path.getOrDefault("frontendIPConfigurationName")
  valid_594062 = validateParameter(valid_594062, JString, required = true,
                                 default = nil)
  if valid_594062 != nil:
    section.add "frontendIPConfigurationName", valid_594062
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594063 = query.getOrDefault("api-version")
  valid_594063 = validateParameter(valid_594063, JString, required = true,
                                 default = nil)
  if valid_594063 != nil:
    section.add "api-version", valid_594063
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594064: Call_LoadBalancerFrontendIPConfigurationsGet_594056;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets load balancer frontend IP configuration.
  ## 
  let valid = call_594064.validator(path, query, header, formData, body)
  let scheme = call_594064.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594064.url(scheme.get, call_594064.host, call_594064.base,
                         call_594064.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594064, url, valid)

proc call*(call_594065: Call_LoadBalancerFrontendIPConfigurationsGet_594056;
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
  var path_594066 = newJObject()
  var query_594067 = newJObject()
  add(path_594066, "resourceGroupName", newJString(resourceGroupName))
  add(query_594067, "api-version", newJString(apiVersion))
  add(path_594066, "loadBalancerName", newJString(loadBalancerName))
  add(path_594066, "subscriptionId", newJString(subscriptionId))
  add(path_594066, "frontendIPConfigurationName",
      newJString(frontendIPConfigurationName))
  result = call_594065.call(path_594066, query_594067, nil, nil, nil)

var loadBalancerFrontendIPConfigurationsGet* = Call_LoadBalancerFrontendIPConfigurationsGet_594056(
    name: "loadBalancerFrontendIPConfigurationsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/loadBalancers/{loadBalancerName}/frontendIPConfigurations/{frontendIPConfigurationName}",
    validator: validate_LoadBalancerFrontendIPConfigurationsGet_594057, base: "",
    url: url_LoadBalancerFrontendIPConfigurationsGet_594058,
    schemes: {Scheme.Https})
type
  Call_InboundNatRulesList_594068 = ref object of OpenApiRestCall_593424
proc url_InboundNatRulesList_594070(protocol: Scheme; host: string; base: string;
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

proc validate_InboundNatRulesList_594069(path: JsonNode; query: JsonNode;
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
  var valid_594071 = path.getOrDefault("resourceGroupName")
  valid_594071 = validateParameter(valid_594071, JString, required = true,
                                 default = nil)
  if valid_594071 != nil:
    section.add "resourceGroupName", valid_594071
  var valid_594072 = path.getOrDefault("loadBalancerName")
  valid_594072 = validateParameter(valid_594072, JString, required = true,
                                 default = nil)
  if valid_594072 != nil:
    section.add "loadBalancerName", valid_594072
  var valid_594073 = path.getOrDefault("subscriptionId")
  valid_594073 = validateParameter(valid_594073, JString, required = true,
                                 default = nil)
  if valid_594073 != nil:
    section.add "subscriptionId", valid_594073
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594074 = query.getOrDefault("api-version")
  valid_594074 = validateParameter(valid_594074, JString, required = true,
                                 default = nil)
  if valid_594074 != nil:
    section.add "api-version", valid_594074
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594075: Call_InboundNatRulesList_594068; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all the inbound nat rules in a load balancer.
  ## 
  let valid = call_594075.validator(path, query, header, formData, body)
  let scheme = call_594075.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594075.url(scheme.get, call_594075.host, call_594075.base,
                         call_594075.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594075, url, valid)

proc call*(call_594076: Call_InboundNatRulesList_594068; resourceGroupName: string;
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
  var path_594077 = newJObject()
  var query_594078 = newJObject()
  add(path_594077, "resourceGroupName", newJString(resourceGroupName))
  add(query_594078, "api-version", newJString(apiVersion))
  add(path_594077, "loadBalancerName", newJString(loadBalancerName))
  add(path_594077, "subscriptionId", newJString(subscriptionId))
  result = call_594076.call(path_594077, query_594078, nil, nil, nil)

var inboundNatRulesList* = Call_InboundNatRulesList_594068(
    name: "inboundNatRulesList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/loadBalancers/{loadBalancerName}/inboundNatRules",
    validator: validate_InboundNatRulesList_594069, base: "",
    url: url_InboundNatRulesList_594070, schemes: {Scheme.Https})
type
  Call_InboundNatRulesCreateOrUpdate_594092 = ref object of OpenApiRestCall_593424
proc url_InboundNatRulesCreateOrUpdate_594094(protocol: Scheme; host: string;
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

proc validate_InboundNatRulesCreateOrUpdate_594093(path: JsonNode; query: JsonNode;
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
  var valid_594095 = path.getOrDefault("resourceGroupName")
  valid_594095 = validateParameter(valid_594095, JString, required = true,
                                 default = nil)
  if valid_594095 != nil:
    section.add "resourceGroupName", valid_594095
  var valid_594096 = path.getOrDefault("loadBalancerName")
  valid_594096 = validateParameter(valid_594096, JString, required = true,
                                 default = nil)
  if valid_594096 != nil:
    section.add "loadBalancerName", valid_594096
  var valid_594097 = path.getOrDefault("subscriptionId")
  valid_594097 = validateParameter(valid_594097, JString, required = true,
                                 default = nil)
  if valid_594097 != nil:
    section.add "subscriptionId", valid_594097
  var valid_594098 = path.getOrDefault("inboundNatRuleName")
  valid_594098 = validateParameter(valid_594098, JString, required = true,
                                 default = nil)
  if valid_594098 != nil:
    section.add "inboundNatRuleName", valid_594098
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594099 = query.getOrDefault("api-version")
  valid_594099 = validateParameter(valid_594099, JString, required = true,
                                 default = nil)
  if valid_594099 != nil:
    section.add "api-version", valid_594099
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

proc call*(call_594101: Call_InboundNatRulesCreateOrUpdate_594092; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates a load balancer inbound nat rule.
  ## 
  let valid = call_594101.validator(path, query, header, formData, body)
  let scheme = call_594101.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594101.url(scheme.get, call_594101.host, call_594101.base,
                         call_594101.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594101, url, valid)

proc call*(call_594102: Call_InboundNatRulesCreateOrUpdate_594092;
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
  var path_594103 = newJObject()
  var query_594104 = newJObject()
  var body_594105 = newJObject()
  add(path_594103, "resourceGroupName", newJString(resourceGroupName))
  add(query_594104, "api-version", newJString(apiVersion))
  add(path_594103, "loadBalancerName", newJString(loadBalancerName))
  add(path_594103, "subscriptionId", newJString(subscriptionId))
  if inboundNatRuleParameters != nil:
    body_594105 = inboundNatRuleParameters
  add(path_594103, "inboundNatRuleName", newJString(inboundNatRuleName))
  result = call_594102.call(path_594103, query_594104, nil, nil, body_594105)

var inboundNatRulesCreateOrUpdate* = Call_InboundNatRulesCreateOrUpdate_594092(
    name: "inboundNatRulesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/loadBalancers/{loadBalancerName}/inboundNatRules/{inboundNatRuleName}",
    validator: validate_InboundNatRulesCreateOrUpdate_594093, base: "",
    url: url_InboundNatRulesCreateOrUpdate_594094, schemes: {Scheme.Https})
type
  Call_InboundNatRulesGet_594079 = ref object of OpenApiRestCall_593424
proc url_InboundNatRulesGet_594081(protocol: Scheme; host: string; base: string;
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

proc validate_InboundNatRulesGet_594080(path: JsonNode; query: JsonNode;
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
  var valid_594082 = path.getOrDefault("resourceGroupName")
  valid_594082 = validateParameter(valid_594082, JString, required = true,
                                 default = nil)
  if valid_594082 != nil:
    section.add "resourceGroupName", valid_594082
  var valid_594083 = path.getOrDefault("loadBalancerName")
  valid_594083 = validateParameter(valid_594083, JString, required = true,
                                 default = nil)
  if valid_594083 != nil:
    section.add "loadBalancerName", valid_594083
  var valid_594084 = path.getOrDefault("subscriptionId")
  valid_594084 = validateParameter(valid_594084, JString, required = true,
                                 default = nil)
  if valid_594084 != nil:
    section.add "subscriptionId", valid_594084
  var valid_594085 = path.getOrDefault("inboundNatRuleName")
  valid_594085 = validateParameter(valid_594085, JString, required = true,
                                 default = nil)
  if valid_594085 != nil:
    section.add "inboundNatRuleName", valid_594085
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $expand: JString
  ##          : Expands referenced resources.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594086 = query.getOrDefault("api-version")
  valid_594086 = validateParameter(valid_594086, JString, required = true,
                                 default = nil)
  if valid_594086 != nil:
    section.add "api-version", valid_594086
  var valid_594087 = query.getOrDefault("$expand")
  valid_594087 = validateParameter(valid_594087, JString, required = false,
                                 default = nil)
  if valid_594087 != nil:
    section.add "$expand", valid_594087
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594088: Call_InboundNatRulesGet_594079; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the specified load balancer inbound nat rule.
  ## 
  let valid = call_594088.validator(path, query, header, formData, body)
  let scheme = call_594088.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594088.url(scheme.get, call_594088.host, call_594088.base,
                         call_594088.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594088, url, valid)

proc call*(call_594089: Call_InboundNatRulesGet_594079; resourceGroupName: string;
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
  var path_594090 = newJObject()
  var query_594091 = newJObject()
  add(path_594090, "resourceGroupName", newJString(resourceGroupName))
  add(query_594091, "api-version", newJString(apiVersion))
  add(query_594091, "$expand", newJString(Expand))
  add(path_594090, "loadBalancerName", newJString(loadBalancerName))
  add(path_594090, "subscriptionId", newJString(subscriptionId))
  add(path_594090, "inboundNatRuleName", newJString(inboundNatRuleName))
  result = call_594089.call(path_594090, query_594091, nil, nil, nil)

var inboundNatRulesGet* = Call_InboundNatRulesGet_594079(
    name: "inboundNatRulesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/loadBalancers/{loadBalancerName}/inboundNatRules/{inboundNatRuleName}",
    validator: validate_InboundNatRulesGet_594080, base: "",
    url: url_InboundNatRulesGet_594081, schemes: {Scheme.Https})
type
  Call_InboundNatRulesDelete_594106 = ref object of OpenApiRestCall_593424
proc url_InboundNatRulesDelete_594108(protocol: Scheme; host: string; base: string;
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

proc validate_InboundNatRulesDelete_594107(path: JsonNode; query: JsonNode;
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
  var valid_594109 = path.getOrDefault("resourceGroupName")
  valid_594109 = validateParameter(valid_594109, JString, required = true,
                                 default = nil)
  if valid_594109 != nil:
    section.add "resourceGroupName", valid_594109
  var valid_594110 = path.getOrDefault("loadBalancerName")
  valid_594110 = validateParameter(valid_594110, JString, required = true,
                                 default = nil)
  if valid_594110 != nil:
    section.add "loadBalancerName", valid_594110
  var valid_594111 = path.getOrDefault("subscriptionId")
  valid_594111 = validateParameter(valid_594111, JString, required = true,
                                 default = nil)
  if valid_594111 != nil:
    section.add "subscriptionId", valid_594111
  var valid_594112 = path.getOrDefault("inboundNatRuleName")
  valid_594112 = validateParameter(valid_594112, JString, required = true,
                                 default = nil)
  if valid_594112 != nil:
    section.add "inboundNatRuleName", valid_594112
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594113 = query.getOrDefault("api-version")
  valid_594113 = validateParameter(valid_594113, JString, required = true,
                                 default = nil)
  if valid_594113 != nil:
    section.add "api-version", valid_594113
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594114: Call_InboundNatRulesDelete_594106; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified load balancer inbound nat rule.
  ## 
  let valid = call_594114.validator(path, query, header, formData, body)
  let scheme = call_594114.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594114.url(scheme.get, call_594114.host, call_594114.base,
                         call_594114.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594114, url, valid)

proc call*(call_594115: Call_InboundNatRulesDelete_594106;
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
  var path_594116 = newJObject()
  var query_594117 = newJObject()
  add(path_594116, "resourceGroupName", newJString(resourceGroupName))
  add(query_594117, "api-version", newJString(apiVersion))
  add(path_594116, "loadBalancerName", newJString(loadBalancerName))
  add(path_594116, "subscriptionId", newJString(subscriptionId))
  add(path_594116, "inboundNatRuleName", newJString(inboundNatRuleName))
  result = call_594115.call(path_594116, query_594117, nil, nil, nil)

var inboundNatRulesDelete* = Call_InboundNatRulesDelete_594106(
    name: "inboundNatRulesDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/loadBalancers/{loadBalancerName}/inboundNatRules/{inboundNatRuleName}",
    validator: validate_InboundNatRulesDelete_594107, base: "",
    url: url_InboundNatRulesDelete_594108, schemes: {Scheme.Https})
type
  Call_LoadBalancerLoadBalancingRulesList_594118 = ref object of OpenApiRestCall_593424
proc url_LoadBalancerLoadBalancingRulesList_594120(protocol: Scheme; host: string;
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

proc validate_LoadBalancerLoadBalancingRulesList_594119(path: JsonNode;
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
  var valid_594121 = path.getOrDefault("resourceGroupName")
  valid_594121 = validateParameter(valid_594121, JString, required = true,
                                 default = nil)
  if valid_594121 != nil:
    section.add "resourceGroupName", valid_594121
  var valid_594122 = path.getOrDefault("loadBalancerName")
  valid_594122 = validateParameter(valid_594122, JString, required = true,
                                 default = nil)
  if valid_594122 != nil:
    section.add "loadBalancerName", valid_594122
  var valid_594123 = path.getOrDefault("subscriptionId")
  valid_594123 = validateParameter(valid_594123, JString, required = true,
                                 default = nil)
  if valid_594123 != nil:
    section.add "subscriptionId", valid_594123
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594124 = query.getOrDefault("api-version")
  valid_594124 = validateParameter(valid_594124, JString, required = true,
                                 default = nil)
  if valid_594124 != nil:
    section.add "api-version", valid_594124
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594125: Call_LoadBalancerLoadBalancingRulesList_594118;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets all the load balancing rules in a load balancer.
  ## 
  let valid = call_594125.validator(path, query, header, formData, body)
  let scheme = call_594125.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594125.url(scheme.get, call_594125.host, call_594125.base,
                         call_594125.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594125, url, valid)

proc call*(call_594126: Call_LoadBalancerLoadBalancingRulesList_594118;
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
  var path_594127 = newJObject()
  var query_594128 = newJObject()
  add(path_594127, "resourceGroupName", newJString(resourceGroupName))
  add(query_594128, "api-version", newJString(apiVersion))
  add(path_594127, "loadBalancerName", newJString(loadBalancerName))
  add(path_594127, "subscriptionId", newJString(subscriptionId))
  result = call_594126.call(path_594127, query_594128, nil, nil, nil)

var loadBalancerLoadBalancingRulesList* = Call_LoadBalancerLoadBalancingRulesList_594118(
    name: "loadBalancerLoadBalancingRulesList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/loadBalancers/{loadBalancerName}/loadBalancingRules",
    validator: validate_LoadBalancerLoadBalancingRulesList_594119, base: "",
    url: url_LoadBalancerLoadBalancingRulesList_594120, schemes: {Scheme.Https})
type
  Call_LoadBalancerLoadBalancingRulesGet_594129 = ref object of OpenApiRestCall_593424
proc url_LoadBalancerLoadBalancingRulesGet_594131(protocol: Scheme; host: string;
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

proc validate_LoadBalancerLoadBalancingRulesGet_594130(path: JsonNode;
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
  var valid_594132 = path.getOrDefault("resourceGroupName")
  valid_594132 = validateParameter(valid_594132, JString, required = true,
                                 default = nil)
  if valid_594132 != nil:
    section.add "resourceGroupName", valid_594132
  var valid_594133 = path.getOrDefault("loadBalancerName")
  valid_594133 = validateParameter(valid_594133, JString, required = true,
                                 default = nil)
  if valid_594133 != nil:
    section.add "loadBalancerName", valid_594133
  var valid_594134 = path.getOrDefault("subscriptionId")
  valid_594134 = validateParameter(valid_594134, JString, required = true,
                                 default = nil)
  if valid_594134 != nil:
    section.add "subscriptionId", valid_594134
  var valid_594135 = path.getOrDefault("loadBalancingRuleName")
  valid_594135 = validateParameter(valid_594135, JString, required = true,
                                 default = nil)
  if valid_594135 != nil:
    section.add "loadBalancingRuleName", valid_594135
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594136 = query.getOrDefault("api-version")
  valid_594136 = validateParameter(valid_594136, JString, required = true,
                                 default = nil)
  if valid_594136 != nil:
    section.add "api-version", valid_594136
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594137: Call_LoadBalancerLoadBalancingRulesGet_594129;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the specified load balancer load balancing rule.
  ## 
  let valid = call_594137.validator(path, query, header, formData, body)
  let scheme = call_594137.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594137.url(scheme.get, call_594137.host, call_594137.base,
                         call_594137.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594137, url, valid)

proc call*(call_594138: Call_LoadBalancerLoadBalancingRulesGet_594129;
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
  var path_594139 = newJObject()
  var query_594140 = newJObject()
  add(path_594139, "resourceGroupName", newJString(resourceGroupName))
  add(query_594140, "api-version", newJString(apiVersion))
  add(path_594139, "loadBalancerName", newJString(loadBalancerName))
  add(path_594139, "subscriptionId", newJString(subscriptionId))
  add(path_594139, "loadBalancingRuleName", newJString(loadBalancingRuleName))
  result = call_594138.call(path_594139, query_594140, nil, nil, nil)

var loadBalancerLoadBalancingRulesGet* = Call_LoadBalancerLoadBalancingRulesGet_594129(
    name: "loadBalancerLoadBalancingRulesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/loadBalancers/{loadBalancerName}/loadBalancingRules/{loadBalancingRuleName}",
    validator: validate_LoadBalancerLoadBalancingRulesGet_594130, base: "",
    url: url_LoadBalancerLoadBalancingRulesGet_594131, schemes: {Scheme.Https})
type
  Call_LoadBalancerNetworkInterfacesList_594141 = ref object of OpenApiRestCall_593424
proc url_LoadBalancerNetworkInterfacesList_594143(protocol: Scheme; host: string;
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

proc validate_LoadBalancerNetworkInterfacesList_594142(path: JsonNode;
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
  var valid_594144 = path.getOrDefault("resourceGroupName")
  valid_594144 = validateParameter(valid_594144, JString, required = true,
                                 default = nil)
  if valid_594144 != nil:
    section.add "resourceGroupName", valid_594144
  var valid_594145 = path.getOrDefault("loadBalancerName")
  valid_594145 = validateParameter(valid_594145, JString, required = true,
                                 default = nil)
  if valid_594145 != nil:
    section.add "loadBalancerName", valid_594145
  var valid_594146 = path.getOrDefault("subscriptionId")
  valid_594146 = validateParameter(valid_594146, JString, required = true,
                                 default = nil)
  if valid_594146 != nil:
    section.add "subscriptionId", valid_594146
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594147 = query.getOrDefault("api-version")
  valid_594147 = validateParameter(valid_594147, JString, required = true,
                                 default = nil)
  if valid_594147 != nil:
    section.add "api-version", valid_594147
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594148: Call_LoadBalancerNetworkInterfacesList_594141;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets associated load balancer network interfaces.
  ## 
  let valid = call_594148.validator(path, query, header, formData, body)
  let scheme = call_594148.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594148.url(scheme.get, call_594148.host, call_594148.base,
                         call_594148.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594148, url, valid)

proc call*(call_594149: Call_LoadBalancerNetworkInterfacesList_594141;
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
  var path_594150 = newJObject()
  var query_594151 = newJObject()
  add(path_594150, "resourceGroupName", newJString(resourceGroupName))
  add(query_594151, "api-version", newJString(apiVersion))
  add(path_594150, "loadBalancerName", newJString(loadBalancerName))
  add(path_594150, "subscriptionId", newJString(subscriptionId))
  result = call_594149.call(path_594150, query_594151, nil, nil, nil)

var loadBalancerNetworkInterfacesList* = Call_LoadBalancerNetworkInterfacesList_594141(
    name: "loadBalancerNetworkInterfacesList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/loadBalancers/{loadBalancerName}/networkInterfaces",
    validator: validate_LoadBalancerNetworkInterfacesList_594142, base: "",
    url: url_LoadBalancerNetworkInterfacesList_594143, schemes: {Scheme.Https})
type
  Call_LoadBalancerProbesList_594152 = ref object of OpenApiRestCall_593424
proc url_LoadBalancerProbesList_594154(protocol: Scheme; host: string; base: string;
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

proc validate_LoadBalancerProbesList_594153(path: JsonNode; query: JsonNode;
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
  var valid_594155 = path.getOrDefault("resourceGroupName")
  valid_594155 = validateParameter(valid_594155, JString, required = true,
                                 default = nil)
  if valid_594155 != nil:
    section.add "resourceGroupName", valid_594155
  var valid_594156 = path.getOrDefault("loadBalancerName")
  valid_594156 = validateParameter(valid_594156, JString, required = true,
                                 default = nil)
  if valid_594156 != nil:
    section.add "loadBalancerName", valid_594156
  var valid_594157 = path.getOrDefault("subscriptionId")
  valid_594157 = validateParameter(valid_594157, JString, required = true,
                                 default = nil)
  if valid_594157 != nil:
    section.add "subscriptionId", valid_594157
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594158 = query.getOrDefault("api-version")
  valid_594158 = validateParameter(valid_594158, JString, required = true,
                                 default = nil)
  if valid_594158 != nil:
    section.add "api-version", valid_594158
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594159: Call_LoadBalancerProbesList_594152; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all the load balancer probes.
  ## 
  let valid = call_594159.validator(path, query, header, formData, body)
  let scheme = call_594159.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594159.url(scheme.get, call_594159.host, call_594159.base,
                         call_594159.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594159, url, valid)

proc call*(call_594160: Call_LoadBalancerProbesList_594152;
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
  var path_594161 = newJObject()
  var query_594162 = newJObject()
  add(path_594161, "resourceGroupName", newJString(resourceGroupName))
  add(query_594162, "api-version", newJString(apiVersion))
  add(path_594161, "loadBalancerName", newJString(loadBalancerName))
  add(path_594161, "subscriptionId", newJString(subscriptionId))
  result = call_594160.call(path_594161, query_594162, nil, nil, nil)

var loadBalancerProbesList* = Call_LoadBalancerProbesList_594152(
    name: "loadBalancerProbesList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/loadBalancers/{loadBalancerName}/probes",
    validator: validate_LoadBalancerProbesList_594153, base: "",
    url: url_LoadBalancerProbesList_594154, schemes: {Scheme.Https})
type
  Call_LoadBalancerProbesGet_594163 = ref object of OpenApiRestCall_593424
proc url_LoadBalancerProbesGet_594165(protocol: Scheme; host: string; base: string;
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

proc validate_LoadBalancerProbesGet_594164(path: JsonNode; query: JsonNode;
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
  var valid_594166 = path.getOrDefault("resourceGroupName")
  valid_594166 = validateParameter(valid_594166, JString, required = true,
                                 default = nil)
  if valid_594166 != nil:
    section.add "resourceGroupName", valid_594166
  var valid_594167 = path.getOrDefault("probeName")
  valid_594167 = validateParameter(valid_594167, JString, required = true,
                                 default = nil)
  if valid_594167 != nil:
    section.add "probeName", valid_594167
  var valid_594168 = path.getOrDefault("loadBalancerName")
  valid_594168 = validateParameter(valid_594168, JString, required = true,
                                 default = nil)
  if valid_594168 != nil:
    section.add "loadBalancerName", valid_594168
  var valid_594169 = path.getOrDefault("subscriptionId")
  valid_594169 = validateParameter(valid_594169, JString, required = true,
                                 default = nil)
  if valid_594169 != nil:
    section.add "subscriptionId", valid_594169
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594170 = query.getOrDefault("api-version")
  valid_594170 = validateParameter(valid_594170, JString, required = true,
                                 default = nil)
  if valid_594170 != nil:
    section.add "api-version", valid_594170
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594171: Call_LoadBalancerProbesGet_594163; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets load balancer probe.
  ## 
  let valid = call_594171.validator(path, query, header, formData, body)
  let scheme = call_594171.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594171.url(scheme.get, call_594171.host, call_594171.base,
                         call_594171.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594171, url, valid)

proc call*(call_594172: Call_LoadBalancerProbesGet_594163;
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
  var path_594173 = newJObject()
  var query_594174 = newJObject()
  add(path_594173, "resourceGroupName", newJString(resourceGroupName))
  add(query_594174, "api-version", newJString(apiVersion))
  add(path_594173, "probeName", newJString(probeName))
  add(path_594173, "loadBalancerName", newJString(loadBalancerName))
  add(path_594173, "subscriptionId", newJString(subscriptionId))
  result = call_594172.call(path_594173, query_594174, nil, nil, nil)

var loadBalancerProbesGet* = Call_LoadBalancerProbesGet_594163(
    name: "loadBalancerProbesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/loadBalancers/{loadBalancerName}/probes/{probeName}",
    validator: validate_LoadBalancerProbesGet_594164, base: "",
    url: url_LoadBalancerProbesGet_594165, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
