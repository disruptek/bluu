
import
  json, options, hashes, uri, rest, os, uri, httpcore

## auto-generated via openapi macro
## title: SqlManagementClient
## version: 2015-05-01-preview
## termsOfService: (not provided)
## license: (not provided)
## 
## The Azure SQL Database management API provides a RESTful set of web APIs that interact with Azure SQL Database services to manage your databases. The API enables users to create, retrieve, update, and delete databases, servers, and other entities.
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

  OpenApiRestCall_563539 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_563539](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_563539): Option[Scheme] {.used.} =
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
  macServiceName = "sql-servers"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_ServersList_563761 = ref object of OpenApiRestCall_563539
proc url_ServersList_563763(protocol: Scheme; host: string; base: string;
                           route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Sql/servers")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServersList_563762(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a list of all servers in the subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_563938 = path.getOrDefault("subscriptionId")
  valid_563938 = validateParameter(valid_563938, JString, required = true,
                                 default = nil)
  if valid_563938 != nil:
    section.add "subscriptionId", valid_563938
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_563939 = query.getOrDefault("api-version")
  valid_563939 = validateParameter(valid_563939, JString, required = true,
                                 default = nil)
  if valid_563939 != nil:
    section.add "api-version", valid_563939
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_563962: Call_ServersList_563761; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a list of all servers in the subscription.
  ## 
  let valid = call_563962.validator(path, query, header, formData, body)
  let scheme = call_563962.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_563962.url(scheme.get, call_563962.host, call_563962.base,
                         call_563962.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_563962, url, valid)

proc call*(call_564033: Call_ServersList_563761; apiVersion: string;
          subscriptionId: string): Recallable =
  ## serversList
  ## Gets a list of all servers in the subscription.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  var path_564034 = newJObject()
  var query_564036 = newJObject()
  add(query_564036, "api-version", newJString(apiVersion))
  add(path_564034, "subscriptionId", newJString(subscriptionId))
  result = call_564033.call(path_564034, query_564036, nil, nil, nil)

var serversList* = Call_ServersList_563761(name: "serversList",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Sql/servers",
                                        validator: validate_ServersList_563762,
                                        base: "", url: url_ServersList_563763,
                                        schemes: {Scheme.Https})
type
  Call_ServersListByResourceGroup_564075 = ref object of OpenApiRestCall_563539
proc url_ServersListByResourceGroup_564077(protocol: Scheme; host: string;
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
        kind: ConstantSegment, value: "/providers/Microsoft.Sql/servers")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServersListByResourceGroup_564076(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a list of servers in a resource groups.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564078 = path.getOrDefault("subscriptionId")
  valid_564078 = validateParameter(valid_564078, JString, required = true,
                                 default = nil)
  if valid_564078 != nil:
    section.add "subscriptionId", valid_564078
  var valid_564079 = path.getOrDefault("resourceGroupName")
  valid_564079 = validateParameter(valid_564079, JString, required = true,
                                 default = nil)
  if valid_564079 != nil:
    section.add "resourceGroupName", valid_564079
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564080 = query.getOrDefault("api-version")
  valid_564080 = validateParameter(valid_564080, JString, required = true,
                                 default = nil)
  if valid_564080 != nil:
    section.add "api-version", valid_564080
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564081: Call_ServersListByResourceGroup_564075; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a list of servers in a resource groups.
  ## 
  let valid = call_564081.validator(path, query, header, formData, body)
  let scheme = call_564081.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564081.url(scheme.get, call_564081.host, call_564081.base,
                         call_564081.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564081, url, valid)

proc call*(call_564082: Call_ServersListByResourceGroup_564075; apiVersion: string;
          subscriptionId: string; resourceGroupName: string): Recallable =
  ## serversListByResourceGroup
  ## Gets a list of servers in a resource groups.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  var path_564083 = newJObject()
  var query_564084 = newJObject()
  add(query_564084, "api-version", newJString(apiVersion))
  add(path_564083, "subscriptionId", newJString(subscriptionId))
  add(path_564083, "resourceGroupName", newJString(resourceGroupName))
  result = call_564082.call(path_564083, query_564084, nil, nil, nil)

var serversListByResourceGroup* = Call_ServersListByResourceGroup_564075(
    name: "serversListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/servers",
    validator: validate_ServersListByResourceGroup_564076, base: "",
    url: url_ServersListByResourceGroup_564077, schemes: {Scheme.Https})
type
  Call_ServersCreateOrUpdate_564096 = ref object of OpenApiRestCall_563539
proc url_ServersCreateOrUpdate_564098(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serverName" in path, "`serverName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Sql/servers/"),
               (kind: VariableSegment, value: "serverName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServersCreateOrUpdate_564097(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates a server.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serverName: JString (required)
  ##             : The name of the server.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serverName` field"
  var valid_564099 = path.getOrDefault("serverName")
  valid_564099 = validateParameter(valid_564099, JString, required = true,
                                 default = nil)
  if valid_564099 != nil:
    section.add "serverName", valid_564099
  var valid_564100 = path.getOrDefault("subscriptionId")
  valid_564100 = validateParameter(valid_564100, JString, required = true,
                                 default = nil)
  if valid_564100 != nil:
    section.add "subscriptionId", valid_564100
  var valid_564101 = path.getOrDefault("resourceGroupName")
  valid_564101 = validateParameter(valid_564101, JString, required = true,
                                 default = nil)
  if valid_564101 != nil:
    section.add "resourceGroupName", valid_564101
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564102 = query.getOrDefault("api-version")
  valid_564102 = validateParameter(valid_564102, JString, required = true,
                                 default = nil)
  if valid_564102 != nil:
    section.add "api-version", valid_564102
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The requested server resource state.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564104: Call_ServersCreateOrUpdate_564096; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates a server.
  ## 
  let valid = call_564104.validator(path, query, header, formData, body)
  let scheme = call_564104.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564104.url(scheme.get, call_564104.host, call_564104.base,
                         call_564104.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564104, url, valid)

proc call*(call_564105: Call_ServersCreateOrUpdate_564096; apiVersion: string;
          serverName: string; subscriptionId: string; resourceGroupName: string;
          parameters: JsonNode): Recallable =
  ## serversCreateOrUpdate
  ## Creates or updates a server.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   serverName: string (required)
  ##             : The name of the server.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   parameters: JObject (required)
  ##             : The requested server resource state.
  var path_564106 = newJObject()
  var query_564107 = newJObject()
  var body_564108 = newJObject()
  add(query_564107, "api-version", newJString(apiVersion))
  add(path_564106, "serverName", newJString(serverName))
  add(path_564106, "subscriptionId", newJString(subscriptionId))
  add(path_564106, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564108 = parameters
  result = call_564105.call(path_564106, query_564107, nil, nil, body_564108)

var serversCreateOrUpdate* = Call_ServersCreateOrUpdate_564096(
    name: "serversCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/servers/{serverName}",
    validator: validate_ServersCreateOrUpdate_564097, base: "",
    url: url_ServersCreateOrUpdate_564098, schemes: {Scheme.Https})
type
  Call_ServersGet_564085 = ref object of OpenApiRestCall_563539
proc url_ServersGet_564087(protocol: Scheme; host: string; base: string; route: string;
                          path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serverName" in path, "`serverName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Sql/servers/"),
               (kind: VariableSegment, value: "serverName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServersGet_564086(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a server.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serverName: JString (required)
  ##             : The name of the server.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serverName` field"
  var valid_564088 = path.getOrDefault("serverName")
  valid_564088 = validateParameter(valid_564088, JString, required = true,
                                 default = nil)
  if valid_564088 != nil:
    section.add "serverName", valid_564088
  var valid_564089 = path.getOrDefault("subscriptionId")
  valid_564089 = validateParameter(valid_564089, JString, required = true,
                                 default = nil)
  if valid_564089 != nil:
    section.add "subscriptionId", valid_564089
  var valid_564090 = path.getOrDefault("resourceGroupName")
  valid_564090 = validateParameter(valid_564090, JString, required = true,
                                 default = nil)
  if valid_564090 != nil:
    section.add "resourceGroupName", valid_564090
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564091 = query.getOrDefault("api-version")
  valid_564091 = validateParameter(valid_564091, JString, required = true,
                                 default = nil)
  if valid_564091 != nil:
    section.add "api-version", valid_564091
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564092: Call_ServersGet_564085; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a server.
  ## 
  let valid = call_564092.validator(path, query, header, formData, body)
  let scheme = call_564092.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564092.url(scheme.get, call_564092.host, call_564092.base,
                         call_564092.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564092, url, valid)

proc call*(call_564093: Call_ServersGet_564085; apiVersion: string;
          serverName: string; subscriptionId: string; resourceGroupName: string): Recallable =
  ## serversGet
  ## Gets a server.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   serverName: string (required)
  ##             : The name of the server.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  var path_564094 = newJObject()
  var query_564095 = newJObject()
  add(query_564095, "api-version", newJString(apiVersion))
  add(path_564094, "serverName", newJString(serverName))
  add(path_564094, "subscriptionId", newJString(subscriptionId))
  add(path_564094, "resourceGroupName", newJString(resourceGroupName))
  result = call_564093.call(path_564094, query_564095, nil, nil, nil)

var serversGet* = Call_ServersGet_564085(name: "serversGet",
                                      meth: HttpMethod.HttpGet,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/servers/{serverName}",
                                      validator: validate_ServersGet_564086,
                                      base: "", url: url_ServersGet_564087,
                                      schemes: {Scheme.Https})
type
  Call_ServersUpdate_564120 = ref object of OpenApiRestCall_563539
proc url_ServersUpdate_564122(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serverName" in path, "`serverName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Sql/servers/"),
               (kind: VariableSegment, value: "serverName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServersUpdate_564121(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates a server.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serverName: JString (required)
  ##             : The name of the server.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serverName` field"
  var valid_564123 = path.getOrDefault("serverName")
  valid_564123 = validateParameter(valid_564123, JString, required = true,
                                 default = nil)
  if valid_564123 != nil:
    section.add "serverName", valid_564123
  var valid_564124 = path.getOrDefault("subscriptionId")
  valid_564124 = validateParameter(valid_564124, JString, required = true,
                                 default = nil)
  if valid_564124 != nil:
    section.add "subscriptionId", valid_564124
  var valid_564125 = path.getOrDefault("resourceGroupName")
  valid_564125 = validateParameter(valid_564125, JString, required = true,
                                 default = nil)
  if valid_564125 != nil:
    section.add "resourceGroupName", valid_564125
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564126 = query.getOrDefault("api-version")
  valid_564126 = validateParameter(valid_564126, JString, required = true,
                                 default = nil)
  if valid_564126 != nil:
    section.add "api-version", valid_564126
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The requested server resource state.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564128: Call_ServersUpdate_564120; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a server.
  ## 
  let valid = call_564128.validator(path, query, header, formData, body)
  let scheme = call_564128.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564128.url(scheme.get, call_564128.host, call_564128.base,
                         call_564128.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564128, url, valid)

proc call*(call_564129: Call_ServersUpdate_564120; apiVersion: string;
          serverName: string; subscriptionId: string; resourceGroupName: string;
          parameters: JsonNode): Recallable =
  ## serversUpdate
  ## Updates a server.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   serverName: string (required)
  ##             : The name of the server.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   parameters: JObject (required)
  ##             : The requested server resource state.
  var path_564130 = newJObject()
  var query_564131 = newJObject()
  var body_564132 = newJObject()
  add(query_564131, "api-version", newJString(apiVersion))
  add(path_564130, "serverName", newJString(serverName))
  add(path_564130, "subscriptionId", newJString(subscriptionId))
  add(path_564130, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564132 = parameters
  result = call_564129.call(path_564130, query_564131, nil, nil, body_564132)

var serversUpdate* = Call_ServersUpdate_564120(name: "serversUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/servers/{serverName}",
    validator: validate_ServersUpdate_564121, base: "", url: url_ServersUpdate_564122,
    schemes: {Scheme.Https})
type
  Call_ServersDelete_564109 = ref object of OpenApiRestCall_563539
proc url_ServersDelete_564111(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serverName" in path, "`serverName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Sql/servers/"),
               (kind: VariableSegment, value: "serverName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServersDelete_564110(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a server.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serverName: JString (required)
  ##             : The name of the server.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serverName` field"
  var valid_564112 = path.getOrDefault("serverName")
  valid_564112 = validateParameter(valid_564112, JString, required = true,
                                 default = nil)
  if valid_564112 != nil:
    section.add "serverName", valid_564112
  var valid_564113 = path.getOrDefault("subscriptionId")
  valid_564113 = validateParameter(valid_564113, JString, required = true,
                                 default = nil)
  if valid_564113 != nil:
    section.add "subscriptionId", valid_564113
  var valid_564114 = path.getOrDefault("resourceGroupName")
  valid_564114 = validateParameter(valid_564114, JString, required = true,
                                 default = nil)
  if valid_564114 != nil:
    section.add "resourceGroupName", valid_564114
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564115 = query.getOrDefault("api-version")
  valid_564115 = validateParameter(valid_564115, JString, required = true,
                                 default = nil)
  if valid_564115 != nil:
    section.add "api-version", valid_564115
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564116: Call_ServersDelete_564109; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a server.
  ## 
  let valid = call_564116.validator(path, query, header, formData, body)
  let scheme = call_564116.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564116.url(scheme.get, call_564116.host, call_564116.base,
                         call_564116.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564116, url, valid)

proc call*(call_564117: Call_ServersDelete_564109; apiVersion: string;
          serverName: string; subscriptionId: string; resourceGroupName: string): Recallable =
  ## serversDelete
  ## Deletes a server.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   serverName: string (required)
  ##             : The name of the server.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  var path_564118 = newJObject()
  var query_564119 = newJObject()
  add(query_564119, "api-version", newJString(apiVersion))
  add(path_564118, "serverName", newJString(serverName))
  add(path_564118, "subscriptionId", newJString(subscriptionId))
  add(path_564118, "resourceGroupName", newJString(resourceGroupName))
  result = call_564117.call(path_564118, query_564119, nil, nil, nil)

var serversDelete* = Call_ServersDelete_564109(name: "serversDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/servers/{serverName}",
    validator: validate_ServersDelete_564110, base: "", url: url_ServersDelete_564111,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
