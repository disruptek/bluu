
import
  json, options, hashes, uri, rest, os, uri, httpcore

## auto-generated via openapi macro
## title: SqlManagementClient
## version: 2017-03-01-preview
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
  macServiceName = "sql-jobs"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_JobAgentsListByServer_563777 = ref object of OpenApiRestCall_563555
proc url_JobAgentsListByServer_563779(protocol: Scheme; host: string; base: string;
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
               (kind: VariableSegment, value: "serverName"),
               (kind: ConstantSegment, value: "/jobAgents")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_JobAgentsListByServer_563778(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a list of job agents in a server.
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
  var valid_563954 = path.getOrDefault("serverName")
  valid_563954 = validateParameter(valid_563954, JString, required = true,
                                 default = nil)
  if valid_563954 != nil:
    section.add "serverName", valid_563954
  var valid_563955 = path.getOrDefault("subscriptionId")
  valid_563955 = validateParameter(valid_563955, JString, required = true,
                                 default = nil)
  if valid_563955 != nil:
    section.add "subscriptionId", valid_563955
  var valid_563956 = path.getOrDefault("resourceGroupName")
  valid_563956 = validateParameter(valid_563956, JString, required = true,
                                 default = nil)
  if valid_563956 != nil:
    section.add "resourceGroupName", valid_563956
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
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

proc call*(call_563980: Call_JobAgentsListByServer_563777; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a list of job agents in a server.
  ## 
  let valid = call_563980.validator(path, query, header, formData, body)
  let scheme = call_563980.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_563980.url(scheme.get, call_563980.host, call_563980.base,
                         call_563980.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_563980, url, valid)

proc call*(call_564051: Call_JobAgentsListByServer_563777; apiVersion: string;
          serverName: string; subscriptionId: string; resourceGroupName: string): Recallable =
  ## jobAgentsListByServer
  ## Gets a list of job agents in a server.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   serverName: string (required)
  ##             : The name of the server.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  var path_564052 = newJObject()
  var query_564054 = newJObject()
  add(query_564054, "api-version", newJString(apiVersion))
  add(path_564052, "serverName", newJString(serverName))
  add(path_564052, "subscriptionId", newJString(subscriptionId))
  add(path_564052, "resourceGroupName", newJString(resourceGroupName))
  result = call_564051.call(path_564052, query_564054, nil, nil, nil)

var jobAgentsListByServer* = Call_JobAgentsListByServer_563777(
    name: "jobAgentsListByServer", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/servers/{serverName}/jobAgents",
    validator: validate_JobAgentsListByServer_563778, base: "",
    url: url_JobAgentsListByServer_563779, schemes: {Scheme.Https})
type
  Call_JobAgentsCreateOrUpdate_564105 = ref object of OpenApiRestCall_563555
proc url_JobAgentsCreateOrUpdate_564107(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serverName" in path, "`serverName` is a required path parameter"
  assert "jobAgentName" in path, "`jobAgentName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Sql/servers/"),
               (kind: VariableSegment, value: "serverName"),
               (kind: ConstantSegment, value: "/jobAgents/"),
               (kind: VariableSegment, value: "jobAgentName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_JobAgentsCreateOrUpdate_564106(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates a job agent.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serverName: JString (required)
  ##             : The name of the server.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   jobAgentName: JString (required)
  ##               : The name of the job agent to be created or updated.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serverName` field"
  var valid_564108 = path.getOrDefault("serverName")
  valid_564108 = validateParameter(valid_564108, JString, required = true,
                                 default = nil)
  if valid_564108 != nil:
    section.add "serverName", valid_564108
  var valid_564109 = path.getOrDefault("subscriptionId")
  valid_564109 = validateParameter(valid_564109, JString, required = true,
                                 default = nil)
  if valid_564109 != nil:
    section.add "subscriptionId", valid_564109
  var valid_564110 = path.getOrDefault("jobAgentName")
  valid_564110 = validateParameter(valid_564110, JString, required = true,
                                 default = nil)
  if valid_564110 != nil:
    section.add "jobAgentName", valid_564110
  var valid_564111 = path.getOrDefault("resourceGroupName")
  valid_564111 = validateParameter(valid_564111, JString, required = true,
                                 default = nil)
  if valid_564111 != nil:
    section.add "resourceGroupName", valid_564111
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564112 = query.getOrDefault("api-version")
  valid_564112 = validateParameter(valid_564112, JString, required = true,
                                 default = nil)
  if valid_564112 != nil:
    section.add "api-version", valid_564112
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The requested job agent resource state.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564114: Call_JobAgentsCreateOrUpdate_564105; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates a job agent.
  ## 
  let valid = call_564114.validator(path, query, header, formData, body)
  let scheme = call_564114.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564114.url(scheme.get, call_564114.host, call_564114.base,
                         call_564114.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564114, url, valid)

proc call*(call_564115: Call_JobAgentsCreateOrUpdate_564105; apiVersion: string;
          serverName: string; subscriptionId: string; jobAgentName: string;
          resourceGroupName: string; parameters: JsonNode): Recallable =
  ## jobAgentsCreateOrUpdate
  ## Creates or updates a job agent.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   serverName: string (required)
  ##             : The name of the server.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   jobAgentName: string (required)
  ##               : The name of the job agent to be created or updated.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   parameters: JObject (required)
  ##             : The requested job agent resource state.
  var path_564116 = newJObject()
  var query_564117 = newJObject()
  var body_564118 = newJObject()
  add(query_564117, "api-version", newJString(apiVersion))
  add(path_564116, "serverName", newJString(serverName))
  add(path_564116, "subscriptionId", newJString(subscriptionId))
  add(path_564116, "jobAgentName", newJString(jobAgentName))
  add(path_564116, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564118 = parameters
  result = call_564115.call(path_564116, query_564117, nil, nil, body_564118)

var jobAgentsCreateOrUpdate* = Call_JobAgentsCreateOrUpdate_564105(
    name: "jobAgentsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/servers/{serverName}/jobAgents/{jobAgentName}",
    validator: validate_JobAgentsCreateOrUpdate_564106, base: "",
    url: url_JobAgentsCreateOrUpdate_564107, schemes: {Scheme.Https})
type
  Call_JobAgentsGet_564093 = ref object of OpenApiRestCall_563555
proc url_JobAgentsGet_564095(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serverName" in path, "`serverName` is a required path parameter"
  assert "jobAgentName" in path, "`jobAgentName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Sql/servers/"),
               (kind: VariableSegment, value: "serverName"),
               (kind: ConstantSegment, value: "/jobAgents/"),
               (kind: VariableSegment, value: "jobAgentName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_JobAgentsGet_564094(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a job agent.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serverName: JString (required)
  ##             : The name of the server.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   jobAgentName: JString (required)
  ##               : The name of the job agent to be retrieved.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serverName` field"
  var valid_564096 = path.getOrDefault("serverName")
  valid_564096 = validateParameter(valid_564096, JString, required = true,
                                 default = nil)
  if valid_564096 != nil:
    section.add "serverName", valid_564096
  var valid_564097 = path.getOrDefault("subscriptionId")
  valid_564097 = validateParameter(valid_564097, JString, required = true,
                                 default = nil)
  if valid_564097 != nil:
    section.add "subscriptionId", valid_564097
  var valid_564098 = path.getOrDefault("jobAgentName")
  valid_564098 = validateParameter(valid_564098, JString, required = true,
                                 default = nil)
  if valid_564098 != nil:
    section.add "jobAgentName", valid_564098
  var valid_564099 = path.getOrDefault("resourceGroupName")
  valid_564099 = validateParameter(valid_564099, JString, required = true,
                                 default = nil)
  if valid_564099 != nil:
    section.add "resourceGroupName", valid_564099
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564100 = query.getOrDefault("api-version")
  valid_564100 = validateParameter(valid_564100, JString, required = true,
                                 default = nil)
  if valid_564100 != nil:
    section.add "api-version", valid_564100
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564101: Call_JobAgentsGet_564093; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a job agent.
  ## 
  let valid = call_564101.validator(path, query, header, formData, body)
  let scheme = call_564101.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564101.url(scheme.get, call_564101.host, call_564101.base,
                         call_564101.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564101, url, valid)

proc call*(call_564102: Call_JobAgentsGet_564093; apiVersion: string;
          serverName: string; subscriptionId: string; jobAgentName: string;
          resourceGroupName: string): Recallable =
  ## jobAgentsGet
  ## Gets a job agent.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   serverName: string (required)
  ##             : The name of the server.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   jobAgentName: string (required)
  ##               : The name of the job agent to be retrieved.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  var path_564103 = newJObject()
  var query_564104 = newJObject()
  add(query_564104, "api-version", newJString(apiVersion))
  add(path_564103, "serverName", newJString(serverName))
  add(path_564103, "subscriptionId", newJString(subscriptionId))
  add(path_564103, "jobAgentName", newJString(jobAgentName))
  add(path_564103, "resourceGroupName", newJString(resourceGroupName))
  result = call_564102.call(path_564103, query_564104, nil, nil, nil)

var jobAgentsGet* = Call_JobAgentsGet_564093(name: "jobAgentsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/servers/{serverName}/jobAgents/{jobAgentName}",
    validator: validate_JobAgentsGet_564094, base: "", url: url_JobAgentsGet_564095,
    schemes: {Scheme.Https})
type
  Call_JobAgentsUpdate_564131 = ref object of OpenApiRestCall_563555
proc url_JobAgentsUpdate_564133(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serverName" in path, "`serverName` is a required path parameter"
  assert "jobAgentName" in path, "`jobAgentName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Sql/servers/"),
               (kind: VariableSegment, value: "serverName"),
               (kind: ConstantSegment, value: "/jobAgents/"),
               (kind: VariableSegment, value: "jobAgentName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_JobAgentsUpdate_564132(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Updates a job agent.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serverName: JString (required)
  ##             : The name of the server.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   jobAgentName: JString (required)
  ##               : The name of the job agent to be updated.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serverName` field"
  var valid_564134 = path.getOrDefault("serverName")
  valid_564134 = validateParameter(valid_564134, JString, required = true,
                                 default = nil)
  if valid_564134 != nil:
    section.add "serverName", valid_564134
  var valid_564135 = path.getOrDefault("subscriptionId")
  valid_564135 = validateParameter(valid_564135, JString, required = true,
                                 default = nil)
  if valid_564135 != nil:
    section.add "subscriptionId", valid_564135
  var valid_564136 = path.getOrDefault("jobAgentName")
  valid_564136 = validateParameter(valid_564136, JString, required = true,
                                 default = nil)
  if valid_564136 != nil:
    section.add "jobAgentName", valid_564136
  var valid_564137 = path.getOrDefault("resourceGroupName")
  valid_564137 = validateParameter(valid_564137, JString, required = true,
                                 default = nil)
  if valid_564137 != nil:
    section.add "resourceGroupName", valid_564137
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564138 = query.getOrDefault("api-version")
  valid_564138 = validateParameter(valid_564138, JString, required = true,
                                 default = nil)
  if valid_564138 != nil:
    section.add "api-version", valid_564138
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The update to the job agent.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564140: Call_JobAgentsUpdate_564131; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a job agent.
  ## 
  let valid = call_564140.validator(path, query, header, formData, body)
  let scheme = call_564140.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564140.url(scheme.get, call_564140.host, call_564140.base,
                         call_564140.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564140, url, valid)

proc call*(call_564141: Call_JobAgentsUpdate_564131; apiVersion: string;
          serverName: string; subscriptionId: string; jobAgentName: string;
          resourceGroupName: string; parameters: JsonNode): Recallable =
  ## jobAgentsUpdate
  ## Updates a job agent.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   serverName: string (required)
  ##             : The name of the server.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   jobAgentName: string (required)
  ##               : The name of the job agent to be updated.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   parameters: JObject (required)
  ##             : The update to the job agent.
  var path_564142 = newJObject()
  var query_564143 = newJObject()
  var body_564144 = newJObject()
  add(query_564143, "api-version", newJString(apiVersion))
  add(path_564142, "serverName", newJString(serverName))
  add(path_564142, "subscriptionId", newJString(subscriptionId))
  add(path_564142, "jobAgentName", newJString(jobAgentName))
  add(path_564142, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564144 = parameters
  result = call_564141.call(path_564142, query_564143, nil, nil, body_564144)

var jobAgentsUpdate* = Call_JobAgentsUpdate_564131(name: "jobAgentsUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/servers/{serverName}/jobAgents/{jobAgentName}",
    validator: validate_JobAgentsUpdate_564132, base: "", url: url_JobAgentsUpdate_564133,
    schemes: {Scheme.Https})
type
  Call_JobAgentsDelete_564119 = ref object of OpenApiRestCall_563555
proc url_JobAgentsDelete_564121(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serverName" in path, "`serverName` is a required path parameter"
  assert "jobAgentName" in path, "`jobAgentName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Sql/servers/"),
               (kind: VariableSegment, value: "serverName"),
               (kind: ConstantSegment, value: "/jobAgents/"),
               (kind: VariableSegment, value: "jobAgentName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_JobAgentsDelete_564120(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Deletes a job agent.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serverName: JString (required)
  ##             : The name of the server.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   jobAgentName: JString (required)
  ##               : The name of the job agent to be deleted.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serverName` field"
  var valid_564122 = path.getOrDefault("serverName")
  valid_564122 = validateParameter(valid_564122, JString, required = true,
                                 default = nil)
  if valid_564122 != nil:
    section.add "serverName", valid_564122
  var valid_564123 = path.getOrDefault("subscriptionId")
  valid_564123 = validateParameter(valid_564123, JString, required = true,
                                 default = nil)
  if valid_564123 != nil:
    section.add "subscriptionId", valid_564123
  var valid_564124 = path.getOrDefault("jobAgentName")
  valid_564124 = validateParameter(valid_564124, JString, required = true,
                                 default = nil)
  if valid_564124 != nil:
    section.add "jobAgentName", valid_564124
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
  if body != nil:
    result.add "body", body

proc call*(call_564127: Call_JobAgentsDelete_564119; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a job agent.
  ## 
  let valid = call_564127.validator(path, query, header, formData, body)
  let scheme = call_564127.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564127.url(scheme.get, call_564127.host, call_564127.base,
                         call_564127.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564127, url, valid)

proc call*(call_564128: Call_JobAgentsDelete_564119; apiVersion: string;
          serverName: string; subscriptionId: string; jobAgentName: string;
          resourceGroupName: string): Recallable =
  ## jobAgentsDelete
  ## Deletes a job agent.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   serverName: string (required)
  ##             : The name of the server.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   jobAgentName: string (required)
  ##               : The name of the job agent to be deleted.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  var path_564129 = newJObject()
  var query_564130 = newJObject()
  add(query_564130, "api-version", newJString(apiVersion))
  add(path_564129, "serverName", newJString(serverName))
  add(path_564129, "subscriptionId", newJString(subscriptionId))
  add(path_564129, "jobAgentName", newJString(jobAgentName))
  add(path_564129, "resourceGroupName", newJString(resourceGroupName))
  result = call_564128.call(path_564129, query_564130, nil, nil, nil)

var jobAgentsDelete* = Call_JobAgentsDelete_564119(name: "jobAgentsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/servers/{serverName}/jobAgents/{jobAgentName}",
    validator: validate_JobAgentsDelete_564120, base: "", url: url_JobAgentsDelete_564121,
    schemes: {Scheme.Https})
type
  Call_JobCredentialsListByAgent_564145 = ref object of OpenApiRestCall_563555
proc url_JobCredentialsListByAgent_564147(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serverName" in path, "`serverName` is a required path parameter"
  assert "jobAgentName" in path, "`jobAgentName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Sql/servers/"),
               (kind: VariableSegment, value: "serverName"),
               (kind: ConstantSegment, value: "/jobAgents/"),
               (kind: VariableSegment, value: "jobAgentName"),
               (kind: ConstantSegment, value: "/credentials")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_JobCredentialsListByAgent_564146(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a list of jobs credentials.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serverName: JString (required)
  ##             : The name of the server.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   jobAgentName: JString (required)
  ##               : The name of the job agent.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serverName` field"
  var valid_564148 = path.getOrDefault("serverName")
  valid_564148 = validateParameter(valid_564148, JString, required = true,
                                 default = nil)
  if valid_564148 != nil:
    section.add "serverName", valid_564148
  var valid_564149 = path.getOrDefault("subscriptionId")
  valid_564149 = validateParameter(valid_564149, JString, required = true,
                                 default = nil)
  if valid_564149 != nil:
    section.add "subscriptionId", valid_564149
  var valid_564150 = path.getOrDefault("jobAgentName")
  valid_564150 = validateParameter(valid_564150, JString, required = true,
                                 default = nil)
  if valid_564150 != nil:
    section.add "jobAgentName", valid_564150
  var valid_564151 = path.getOrDefault("resourceGroupName")
  valid_564151 = validateParameter(valid_564151, JString, required = true,
                                 default = nil)
  if valid_564151 != nil:
    section.add "resourceGroupName", valid_564151
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564152 = query.getOrDefault("api-version")
  valid_564152 = validateParameter(valid_564152, JString, required = true,
                                 default = nil)
  if valid_564152 != nil:
    section.add "api-version", valid_564152
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564153: Call_JobCredentialsListByAgent_564145; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a list of jobs credentials.
  ## 
  let valid = call_564153.validator(path, query, header, formData, body)
  let scheme = call_564153.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564153.url(scheme.get, call_564153.host, call_564153.base,
                         call_564153.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564153, url, valid)

proc call*(call_564154: Call_JobCredentialsListByAgent_564145; apiVersion: string;
          serverName: string; subscriptionId: string; jobAgentName: string;
          resourceGroupName: string): Recallable =
  ## jobCredentialsListByAgent
  ## Gets a list of jobs credentials.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   serverName: string (required)
  ##             : The name of the server.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   jobAgentName: string (required)
  ##               : The name of the job agent.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  var path_564155 = newJObject()
  var query_564156 = newJObject()
  add(query_564156, "api-version", newJString(apiVersion))
  add(path_564155, "serverName", newJString(serverName))
  add(path_564155, "subscriptionId", newJString(subscriptionId))
  add(path_564155, "jobAgentName", newJString(jobAgentName))
  add(path_564155, "resourceGroupName", newJString(resourceGroupName))
  result = call_564154.call(path_564155, query_564156, nil, nil, nil)

var jobCredentialsListByAgent* = Call_JobCredentialsListByAgent_564145(
    name: "jobCredentialsListByAgent", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/servers/{serverName}/jobAgents/{jobAgentName}/credentials",
    validator: validate_JobCredentialsListByAgent_564146, base: "",
    url: url_JobCredentialsListByAgent_564147, schemes: {Scheme.Https})
type
  Call_JobCredentialsCreateOrUpdate_564170 = ref object of OpenApiRestCall_563555
proc url_JobCredentialsCreateOrUpdate_564172(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serverName" in path, "`serverName` is a required path parameter"
  assert "jobAgentName" in path, "`jobAgentName` is a required path parameter"
  assert "credentialName" in path, "`credentialName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Sql/servers/"),
               (kind: VariableSegment, value: "serverName"),
               (kind: ConstantSegment, value: "/jobAgents/"),
               (kind: VariableSegment, value: "jobAgentName"),
               (kind: ConstantSegment, value: "/credentials/"),
               (kind: VariableSegment, value: "credentialName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_JobCredentialsCreateOrUpdate_564171(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates a job credential.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serverName: JString (required)
  ##             : The name of the server.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   jobAgentName: JString (required)
  ##               : The name of the job agent.
  ##   credentialName: JString (required)
  ##                 : The name of the credential.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serverName` field"
  var valid_564173 = path.getOrDefault("serverName")
  valid_564173 = validateParameter(valid_564173, JString, required = true,
                                 default = nil)
  if valid_564173 != nil:
    section.add "serverName", valid_564173
  var valid_564174 = path.getOrDefault("subscriptionId")
  valid_564174 = validateParameter(valid_564174, JString, required = true,
                                 default = nil)
  if valid_564174 != nil:
    section.add "subscriptionId", valid_564174
  var valid_564175 = path.getOrDefault("jobAgentName")
  valid_564175 = validateParameter(valid_564175, JString, required = true,
                                 default = nil)
  if valid_564175 != nil:
    section.add "jobAgentName", valid_564175
  var valid_564176 = path.getOrDefault("credentialName")
  valid_564176 = validateParameter(valid_564176, JString, required = true,
                                 default = nil)
  if valid_564176 != nil:
    section.add "credentialName", valid_564176
  var valid_564177 = path.getOrDefault("resourceGroupName")
  valid_564177 = validateParameter(valid_564177, JString, required = true,
                                 default = nil)
  if valid_564177 != nil:
    section.add "resourceGroupName", valid_564177
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564178 = query.getOrDefault("api-version")
  valid_564178 = validateParameter(valid_564178, JString, required = true,
                                 default = nil)
  if valid_564178 != nil:
    section.add "api-version", valid_564178
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The requested job credential state.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564180: Call_JobCredentialsCreateOrUpdate_564170; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates a job credential.
  ## 
  let valid = call_564180.validator(path, query, header, formData, body)
  let scheme = call_564180.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564180.url(scheme.get, call_564180.host, call_564180.base,
                         call_564180.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564180, url, valid)

proc call*(call_564181: Call_JobCredentialsCreateOrUpdate_564170;
          apiVersion: string; serverName: string; subscriptionId: string;
          jobAgentName: string; credentialName: string; resourceGroupName: string;
          parameters: JsonNode): Recallable =
  ## jobCredentialsCreateOrUpdate
  ## Creates or updates a job credential.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   serverName: string (required)
  ##             : The name of the server.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   jobAgentName: string (required)
  ##               : The name of the job agent.
  ##   credentialName: string (required)
  ##                 : The name of the credential.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   parameters: JObject (required)
  ##             : The requested job credential state.
  var path_564182 = newJObject()
  var query_564183 = newJObject()
  var body_564184 = newJObject()
  add(query_564183, "api-version", newJString(apiVersion))
  add(path_564182, "serverName", newJString(serverName))
  add(path_564182, "subscriptionId", newJString(subscriptionId))
  add(path_564182, "jobAgentName", newJString(jobAgentName))
  add(path_564182, "credentialName", newJString(credentialName))
  add(path_564182, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564184 = parameters
  result = call_564181.call(path_564182, query_564183, nil, nil, body_564184)

var jobCredentialsCreateOrUpdate* = Call_JobCredentialsCreateOrUpdate_564170(
    name: "jobCredentialsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/servers/{serverName}/jobAgents/{jobAgentName}/credentials/{credentialName}",
    validator: validate_JobCredentialsCreateOrUpdate_564171, base: "",
    url: url_JobCredentialsCreateOrUpdate_564172, schemes: {Scheme.Https})
type
  Call_JobCredentialsGet_564157 = ref object of OpenApiRestCall_563555
proc url_JobCredentialsGet_564159(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serverName" in path, "`serverName` is a required path parameter"
  assert "jobAgentName" in path, "`jobAgentName` is a required path parameter"
  assert "credentialName" in path, "`credentialName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Sql/servers/"),
               (kind: VariableSegment, value: "serverName"),
               (kind: ConstantSegment, value: "/jobAgents/"),
               (kind: VariableSegment, value: "jobAgentName"),
               (kind: ConstantSegment, value: "/credentials/"),
               (kind: VariableSegment, value: "credentialName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_JobCredentialsGet_564158(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Gets a jobs credential.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serverName: JString (required)
  ##             : The name of the server.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   jobAgentName: JString (required)
  ##               : The name of the job agent.
  ##   credentialName: JString (required)
  ##                 : The name of the credential.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serverName` field"
  var valid_564160 = path.getOrDefault("serverName")
  valid_564160 = validateParameter(valid_564160, JString, required = true,
                                 default = nil)
  if valid_564160 != nil:
    section.add "serverName", valid_564160
  var valid_564161 = path.getOrDefault("subscriptionId")
  valid_564161 = validateParameter(valid_564161, JString, required = true,
                                 default = nil)
  if valid_564161 != nil:
    section.add "subscriptionId", valid_564161
  var valid_564162 = path.getOrDefault("jobAgentName")
  valid_564162 = validateParameter(valid_564162, JString, required = true,
                                 default = nil)
  if valid_564162 != nil:
    section.add "jobAgentName", valid_564162
  var valid_564163 = path.getOrDefault("credentialName")
  valid_564163 = validateParameter(valid_564163, JString, required = true,
                                 default = nil)
  if valid_564163 != nil:
    section.add "credentialName", valid_564163
  var valid_564164 = path.getOrDefault("resourceGroupName")
  valid_564164 = validateParameter(valid_564164, JString, required = true,
                                 default = nil)
  if valid_564164 != nil:
    section.add "resourceGroupName", valid_564164
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564165 = query.getOrDefault("api-version")
  valid_564165 = validateParameter(valid_564165, JString, required = true,
                                 default = nil)
  if valid_564165 != nil:
    section.add "api-version", valid_564165
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564166: Call_JobCredentialsGet_564157; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a jobs credential.
  ## 
  let valid = call_564166.validator(path, query, header, formData, body)
  let scheme = call_564166.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564166.url(scheme.get, call_564166.host, call_564166.base,
                         call_564166.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564166, url, valid)

proc call*(call_564167: Call_JobCredentialsGet_564157; apiVersion: string;
          serverName: string; subscriptionId: string; jobAgentName: string;
          credentialName: string; resourceGroupName: string): Recallable =
  ## jobCredentialsGet
  ## Gets a jobs credential.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   serverName: string (required)
  ##             : The name of the server.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   jobAgentName: string (required)
  ##               : The name of the job agent.
  ##   credentialName: string (required)
  ##                 : The name of the credential.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  var path_564168 = newJObject()
  var query_564169 = newJObject()
  add(query_564169, "api-version", newJString(apiVersion))
  add(path_564168, "serverName", newJString(serverName))
  add(path_564168, "subscriptionId", newJString(subscriptionId))
  add(path_564168, "jobAgentName", newJString(jobAgentName))
  add(path_564168, "credentialName", newJString(credentialName))
  add(path_564168, "resourceGroupName", newJString(resourceGroupName))
  result = call_564167.call(path_564168, query_564169, nil, nil, nil)

var jobCredentialsGet* = Call_JobCredentialsGet_564157(name: "jobCredentialsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/servers/{serverName}/jobAgents/{jobAgentName}/credentials/{credentialName}",
    validator: validate_JobCredentialsGet_564158, base: "",
    url: url_JobCredentialsGet_564159, schemes: {Scheme.Https})
type
  Call_JobCredentialsDelete_564185 = ref object of OpenApiRestCall_563555
proc url_JobCredentialsDelete_564187(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serverName" in path, "`serverName` is a required path parameter"
  assert "jobAgentName" in path, "`jobAgentName` is a required path parameter"
  assert "credentialName" in path, "`credentialName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Sql/servers/"),
               (kind: VariableSegment, value: "serverName"),
               (kind: ConstantSegment, value: "/jobAgents/"),
               (kind: VariableSegment, value: "jobAgentName"),
               (kind: ConstantSegment, value: "/credentials/"),
               (kind: VariableSegment, value: "credentialName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_JobCredentialsDelete_564186(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a job credential.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serverName: JString (required)
  ##             : The name of the server.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   jobAgentName: JString (required)
  ##               : The name of the job agent.
  ##   credentialName: JString (required)
  ##                 : The name of the credential.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serverName` field"
  var valid_564188 = path.getOrDefault("serverName")
  valid_564188 = validateParameter(valid_564188, JString, required = true,
                                 default = nil)
  if valid_564188 != nil:
    section.add "serverName", valid_564188
  var valid_564189 = path.getOrDefault("subscriptionId")
  valid_564189 = validateParameter(valid_564189, JString, required = true,
                                 default = nil)
  if valid_564189 != nil:
    section.add "subscriptionId", valid_564189
  var valid_564190 = path.getOrDefault("jobAgentName")
  valid_564190 = validateParameter(valid_564190, JString, required = true,
                                 default = nil)
  if valid_564190 != nil:
    section.add "jobAgentName", valid_564190
  var valid_564191 = path.getOrDefault("credentialName")
  valid_564191 = validateParameter(valid_564191, JString, required = true,
                                 default = nil)
  if valid_564191 != nil:
    section.add "credentialName", valid_564191
  var valid_564192 = path.getOrDefault("resourceGroupName")
  valid_564192 = validateParameter(valid_564192, JString, required = true,
                                 default = nil)
  if valid_564192 != nil:
    section.add "resourceGroupName", valid_564192
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
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

proc call*(call_564194: Call_JobCredentialsDelete_564185; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a job credential.
  ## 
  let valid = call_564194.validator(path, query, header, formData, body)
  let scheme = call_564194.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564194.url(scheme.get, call_564194.host, call_564194.base,
                         call_564194.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564194, url, valid)

proc call*(call_564195: Call_JobCredentialsDelete_564185; apiVersion: string;
          serverName: string; subscriptionId: string; jobAgentName: string;
          credentialName: string; resourceGroupName: string): Recallable =
  ## jobCredentialsDelete
  ## Deletes a job credential.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   serverName: string (required)
  ##             : The name of the server.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   jobAgentName: string (required)
  ##               : The name of the job agent.
  ##   credentialName: string (required)
  ##                 : The name of the credential.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  var path_564196 = newJObject()
  var query_564197 = newJObject()
  add(query_564197, "api-version", newJString(apiVersion))
  add(path_564196, "serverName", newJString(serverName))
  add(path_564196, "subscriptionId", newJString(subscriptionId))
  add(path_564196, "jobAgentName", newJString(jobAgentName))
  add(path_564196, "credentialName", newJString(credentialName))
  add(path_564196, "resourceGroupName", newJString(resourceGroupName))
  result = call_564195.call(path_564196, query_564197, nil, nil, nil)

var jobCredentialsDelete* = Call_JobCredentialsDelete_564185(
    name: "jobCredentialsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/servers/{serverName}/jobAgents/{jobAgentName}/credentials/{credentialName}",
    validator: validate_JobCredentialsDelete_564186, base: "",
    url: url_JobCredentialsDelete_564187, schemes: {Scheme.Https})
type
  Call_JobExecutionsListByAgent_564198 = ref object of OpenApiRestCall_563555
proc url_JobExecutionsListByAgent_564200(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serverName" in path, "`serverName` is a required path parameter"
  assert "jobAgentName" in path, "`jobAgentName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Sql/servers/"),
               (kind: VariableSegment, value: "serverName"),
               (kind: ConstantSegment, value: "/jobAgents/"),
               (kind: VariableSegment, value: "jobAgentName"),
               (kind: ConstantSegment, value: "/executions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_JobExecutionsListByAgent_564199(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all executions in a job agent.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serverName: JString (required)
  ##             : The name of the server.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   jobAgentName: JString (required)
  ##               : The name of the job agent.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serverName` field"
  var valid_564202 = path.getOrDefault("serverName")
  valid_564202 = validateParameter(valid_564202, JString, required = true,
                                 default = nil)
  if valid_564202 != nil:
    section.add "serverName", valid_564202
  var valid_564203 = path.getOrDefault("subscriptionId")
  valid_564203 = validateParameter(valid_564203, JString, required = true,
                                 default = nil)
  if valid_564203 != nil:
    section.add "subscriptionId", valid_564203
  var valid_564204 = path.getOrDefault("jobAgentName")
  valid_564204 = validateParameter(valid_564204, JString, required = true,
                                 default = nil)
  if valid_564204 != nil:
    section.add "jobAgentName", valid_564204
  var valid_564205 = path.getOrDefault("resourceGroupName")
  valid_564205 = validateParameter(valid_564205, JString, required = true,
                                 default = nil)
  if valid_564205 != nil:
    section.add "resourceGroupName", valid_564205
  result.add "path", section
  ## parameters in `query` object:
  ##   $top: JInt
  ##       : The number of elements to return from the collection.
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  ##   endTimeMin: JString
  ##             : If specified, only job executions completed at or after the specified time are included.
  ##   isActive: JBool
  ##           : If specified, only active or only completed job executions are included.
  ##   createTimeMin: JString
  ##                : If specified, only job executions created at or after the specified time are included.
  ##   $skip: JInt
  ##        : The number of elements in the collection to skip.
  ##   createTimeMax: JString
  ##                : If specified, only job executions created before the specified time are included.
  ##   endTimeMax: JString
  ##             : If specified, only job executions completed before the specified time are included.
  section = newJObject()
  var valid_564206 = query.getOrDefault("$top")
  valid_564206 = validateParameter(valid_564206, JInt, required = false, default = nil)
  if valid_564206 != nil:
    section.add "$top", valid_564206
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564207 = query.getOrDefault("api-version")
  valid_564207 = validateParameter(valid_564207, JString, required = true,
                                 default = nil)
  if valid_564207 != nil:
    section.add "api-version", valid_564207
  var valid_564208 = query.getOrDefault("endTimeMin")
  valid_564208 = validateParameter(valid_564208, JString, required = false,
                                 default = nil)
  if valid_564208 != nil:
    section.add "endTimeMin", valid_564208
  var valid_564209 = query.getOrDefault("isActive")
  valid_564209 = validateParameter(valid_564209, JBool, required = false, default = nil)
  if valid_564209 != nil:
    section.add "isActive", valid_564209
  var valid_564210 = query.getOrDefault("createTimeMin")
  valid_564210 = validateParameter(valid_564210, JString, required = false,
                                 default = nil)
  if valid_564210 != nil:
    section.add "createTimeMin", valid_564210
  var valid_564211 = query.getOrDefault("$skip")
  valid_564211 = validateParameter(valid_564211, JInt, required = false, default = nil)
  if valid_564211 != nil:
    section.add "$skip", valid_564211
  var valid_564212 = query.getOrDefault("createTimeMax")
  valid_564212 = validateParameter(valid_564212, JString, required = false,
                                 default = nil)
  if valid_564212 != nil:
    section.add "createTimeMax", valid_564212
  var valid_564213 = query.getOrDefault("endTimeMax")
  valid_564213 = validateParameter(valid_564213, JString, required = false,
                                 default = nil)
  if valid_564213 != nil:
    section.add "endTimeMax", valid_564213
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564214: Call_JobExecutionsListByAgent_564198; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all executions in a job agent.
  ## 
  let valid = call_564214.validator(path, query, header, formData, body)
  let scheme = call_564214.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564214.url(scheme.get, call_564214.host, call_564214.base,
                         call_564214.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564214, url, valid)

proc call*(call_564215: Call_JobExecutionsListByAgent_564198; apiVersion: string;
          serverName: string; subscriptionId: string; jobAgentName: string;
          resourceGroupName: string; Top: int = 0; endTimeMin: string = "";
          isActive: bool = false; createTimeMin: string = ""; Skip: int = 0;
          createTimeMax: string = ""; endTimeMax: string = ""): Recallable =
  ## jobExecutionsListByAgent
  ## Lists all executions in a job agent.
  ##   Top: int
  ##      : The number of elements to return from the collection.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   endTimeMin: string
  ##             : If specified, only job executions completed at or after the specified time are included.
  ##   serverName: string (required)
  ##             : The name of the server.
  ##   isActive: bool
  ##           : If specified, only active or only completed job executions are included.
  ##   createTimeMin: string
  ##                : If specified, only job executions created at or after the specified time are included.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   jobAgentName: string (required)
  ##               : The name of the job agent.
  ##   Skip: int
  ##       : The number of elements in the collection to skip.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   createTimeMax: string
  ##                : If specified, only job executions created before the specified time are included.
  ##   endTimeMax: string
  ##             : If specified, only job executions completed before the specified time are included.
  var path_564216 = newJObject()
  var query_564217 = newJObject()
  add(query_564217, "$top", newJInt(Top))
  add(query_564217, "api-version", newJString(apiVersion))
  add(query_564217, "endTimeMin", newJString(endTimeMin))
  add(path_564216, "serverName", newJString(serverName))
  add(query_564217, "isActive", newJBool(isActive))
  add(query_564217, "createTimeMin", newJString(createTimeMin))
  add(path_564216, "subscriptionId", newJString(subscriptionId))
  add(path_564216, "jobAgentName", newJString(jobAgentName))
  add(query_564217, "$skip", newJInt(Skip))
  add(path_564216, "resourceGroupName", newJString(resourceGroupName))
  add(query_564217, "createTimeMax", newJString(createTimeMax))
  add(query_564217, "endTimeMax", newJString(endTimeMax))
  result = call_564215.call(path_564216, query_564217, nil, nil, nil)

var jobExecutionsListByAgent* = Call_JobExecutionsListByAgent_564198(
    name: "jobExecutionsListByAgent", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/servers/{serverName}/jobAgents/{jobAgentName}/executions",
    validator: validate_JobExecutionsListByAgent_564199, base: "",
    url: url_JobExecutionsListByAgent_564200, schemes: {Scheme.Https})
type
  Call_JobsListByAgent_564218 = ref object of OpenApiRestCall_563555
proc url_JobsListByAgent_564220(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serverName" in path, "`serverName` is a required path parameter"
  assert "jobAgentName" in path, "`jobAgentName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Sql/servers/"),
               (kind: VariableSegment, value: "serverName"),
               (kind: ConstantSegment, value: "/jobAgents/"),
               (kind: VariableSegment, value: "jobAgentName"),
               (kind: ConstantSegment, value: "/jobs")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_JobsListByAgent_564219(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Gets a list of jobs.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serverName: JString (required)
  ##             : The name of the server.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   jobAgentName: JString (required)
  ##               : The name of the job agent.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serverName` field"
  var valid_564221 = path.getOrDefault("serverName")
  valid_564221 = validateParameter(valid_564221, JString, required = true,
                                 default = nil)
  if valid_564221 != nil:
    section.add "serverName", valid_564221
  var valid_564222 = path.getOrDefault("subscriptionId")
  valid_564222 = validateParameter(valid_564222, JString, required = true,
                                 default = nil)
  if valid_564222 != nil:
    section.add "subscriptionId", valid_564222
  var valid_564223 = path.getOrDefault("jobAgentName")
  valid_564223 = validateParameter(valid_564223, JString, required = true,
                                 default = nil)
  if valid_564223 != nil:
    section.add "jobAgentName", valid_564223
  var valid_564224 = path.getOrDefault("resourceGroupName")
  valid_564224 = validateParameter(valid_564224, JString, required = true,
                                 default = nil)
  if valid_564224 != nil:
    section.add "resourceGroupName", valid_564224
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564225 = query.getOrDefault("api-version")
  valid_564225 = validateParameter(valid_564225, JString, required = true,
                                 default = nil)
  if valid_564225 != nil:
    section.add "api-version", valid_564225
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564226: Call_JobsListByAgent_564218; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a list of jobs.
  ## 
  let valid = call_564226.validator(path, query, header, formData, body)
  let scheme = call_564226.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564226.url(scheme.get, call_564226.host, call_564226.base,
                         call_564226.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564226, url, valid)

proc call*(call_564227: Call_JobsListByAgent_564218; apiVersion: string;
          serverName: string; subscriptionId: string; jobAgentName: string;
          resourceGroupName: string): Recallable =
  ## jobsListByAgent
  ## Gets a list of jobs.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   serverName: string (required)
  ##             : The name of the server.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   jobAgentName: string (required)
  ##               : The name of the job agent.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  var path_564228 = newJObject()
  var query_564229 = newJObject()
  add(query_564229, "api-version", newJString(apiVersion))
  add(path_564228, "serverName", newJString(serverName))
  add(path_564228, "subscriptionId", newJString(subscriptionId))
  add(path_564228, "jobAgentName", newJString(jobAgentName))
  add(path_564228, "resourceGroupName", newJString(resourceGroupName))
  result = call_564227.call(path_564228, query_564229, nil, nil, nil)

var jobsListByAgent* = Call_JobsListByAgent_564218(name: "jobsListByAgent",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/servers/{serverName}/jobAgents/{jobAgentName}/jobs",
    validator: validate_JobsListByAgent_564219, base: "", url: url_JobsListByAgent_564220,
    schemes: {Scheme.Https})
type
  Call_JobsCreateOrUpdate_564243 = ref object of OpenApiRestCall_563555
proc url_JobsCreateOrUpdate_564245(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serverName" in path, "`serverName` is a required path parameter"
  assert "jobAgentName" in path, "`jobAgentName` is a required path parameter"
  assert "jobName" in path, "`jobName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Sql/servers/"),
               (kind: VariableSegment, value: "serverName"),
               (kind: ConstantSegment, value: "/jobAgents/"),
               (kind: VariableSegment, value: "jobAgentName"),
               (kind: ConstantSegment, value: "/jobs/"),
               (kind: VariableSegment, value: "jobName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_JobsCreateOrUpdate_564244(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Creates or updates a job.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serverName: JString (required)
  ##             : The name of the server.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   jobAgentName: JString (required)
  ##               : The name of the job agent.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   jobName: JString (required)
  ##          : The name of the job to get.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serverName` field"
  var valid_564246 = path.getOrDefault("serverName")
  valid_564246 = validateParameter(valid_564246, JString, required = true,
                                 default = nil)
  if valid_564246 != nil:
    section.add "serverName", valid_564246
  var valid_564247 = path.getOrDefault("subscriptionId")
  valid_564247 = validateParameter(valid_564247, JString, required = true,
                                 default = nil)
  if valid_564247 != nil:
    section.add "subscriptionId", valid_564247
  var valid_564248 = path.getOrDefault("jobAgentName")
  valid_564248 = validateParameter(valid_564248, JString, required = true,
                                 default = nil)
  if valid_564248 != nil:
    section.add "jobAgentName", valid_564248
  var valid_564249 = path.getOrDefault("resourceGroupName")
  valid_564249 = validateParameter(valid_564249, JString, required = true,
                                 default = nil)
  if valid_564249 != nil:
    section.add "resourceGroupName", valid_564249
  var valid_564250 = path.getOrDefault("jobName")
  valid_564250 = validateParameter(valid_564250, JString, required = true,
                                 default = nil)
  if valid_564250 != nil:
    section.add "jobName", valid_564250
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564251 = query.getOrDefault("api-version")
  valid_564251 = validateParameter(valid_564251, JString, required = true,
                                 default = nil)
  if valid_564251 != nil:
    section.add "api-version", valid_564251
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The requested job state.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564253: Call_JobsCreateOrUpdate_564243; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates a job.
  ## 
  let valid = call_564253.validator(path, query, header, formData, body)
  let scheme = call_564253.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564253.url(scheme.get, call_564253.host, call_564253.base,
                         call_564253.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564253, url, valid)

proc call*(call_564254: Call_JobsCreateOrUpdate_564243; apiVersion: string;
          serverName: string; subscriptionId: string; jobAgentName: string;
          resourceGroupName: string; parameters: JsonNode; jobName: string): Recallable =
  ## jobsCreateOrUpdate
  ## Creates or updates a job.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   serverName: string (required)
  ##             : The name of the server.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   jobAgentName: string (required)
  ##               : The name of the job agent.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   parameters: JObject (required)
  ##             : The requested job state.
  ##   jobName: string (required)
  ##          : The name of the job to get.
  var path_564255 = newJObject()
  var query_564256 = newJObject()
  var body_564257 = newJObject()
  add(query_564256, "api-version", newJString(apiVersion))
  add(path_564255, "serverName", newJString(serverName))
  add(path_564255, "subscriptionId", newJString(subscriptionId))
  add(path_564255, "jobAgentName", newJString(jobAgentName))
  add(path_564255, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564257 = parameters
  add(path_564255, "jobName", newJString(jobName))
  result = call_564254.call(path_564255, query_564256, nil, nil, body_564257)

var jobsCreateOrUpdate* = Call_JobsCreateOrUpdate_564243(
    name: "jobsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/servers/{serverName}/jobAgents/{jobAgentName}/jobs/{jobName}",
    validator: validate_JobsCreateOrUpdate_564244, base: "",
    url: url_JobsCreateOrUpdate_564245, schemes: {Scheme.Https})
type
  Call_JobsGet_564230 = ref object of OpenApiRestCall_563555
proc url_JobsGet_564232(protocol: Scheme; host: string; base: string; route: string;
                       path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serverName" in path, "`serverName` is a required path parameter"
  assert "jobAgentName" in path, "`jobAgentName` is a required path parameter"
  assert "jobName" in path, "`jobName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Sql/servers/"),
               (kind: VariableSegment, value: "serverName"),
               (kind: ConstantSegment, value: "/jobAgents/"),
               (kind: VariableSegment, value: "jobAgentName"),
               (kind: ConstantSegment, value: "/jobs/"),
               (kind: VariableSegment, value: "jobName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_JobsGet_564231(path: JsonNode; query: JsonNode; header: JsonNode;
                            formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a job.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serverName: JString (required)
  ##             : The name of the server.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   jobAgentName: JString (required)
  ##               : The name of the job agent.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   jobName: JString (required)
  ##          : The name of the job to get.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serverName` field"
  var valid_564233 = path.getOrDefault("serverName")
  valid_564233 = validateParameter(valid_564233, JString, required = true,
                                 default = nil)
  if valid_564233 != nil:
    section.add "serverName", valid_564233
  var valid_564234 = path.getOrDefault("subscriptionId")
  valid_564234 = validateParameter(valid_564234, JString, required = true,
                                 default = nil)
  if valid_564234 != nil:
    section.add "subscriptionId", valid_564234
  var valid_564235 = path.getOrDefault("jobAgentName")
  valid_564235 = validateParameter(valid_564235, JString, required = true,
                                 default = nil)
  if valid_564235 != nil:
    section.add "jobAgentName", valid_564235
  var valid_564236 = path.getOrDefault("resourceGroupName")
  valid_564236 = validateParameter(valid_564236, JString, required = true,
                                 default = nil)
  if valid_564236 != nil:
    section.add "resourceGroupName", valid_564236
  var valid_564237 = path.getOrDefault("jobName")
  valid_564237 = validateParameter(valid_564237, JString, required = true,
                                 default = nil)
  if valid_564237 != nil:
    section.add "jobName", valid_564237
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564238 = query.getOrDefault("api-version")
  valid_564238 = validateParameter(valid_564238, JString, required = true,
                                 default = nil)
  if valid_564238 != nil:
    section.add "api-version", valid_564238
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564239: Call_JobsGet_564230; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a job.
  ## 
  let valid = call_564239.validator(path, query, header, formData, body)
  let scheme = call_564239.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564239.url(scheme.get, call_564239.host, call_564239.base,
                         call_564239.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564239, url, valid)

proc call*(call_564240: Call_JobsGet_564230; apiVersion: string; serverName: string;
          subscriptionId: string; jobAgentName: string; resourceGroupName: string;
          jobName: string): Recallable =
  ## jobsGet
  ## Gets a job.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   serverName: string (required)
  ##             : The name of the server.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   jobAgentName: string (required)
  ##               : The name of the job agent.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   jobName: string (required)
  ##          : The name of the job to get.
  var path_564241 = newJObject()
  var query_564242 = newJObject()
  add(query_564242, "api-version", newJString(apiVersion))
  add(path_564241, "serverName", newJString(serverName))
  add(path_564241, "subscriptionId", newJString(subscriptionId))
  add(path_564241, "jobAgentName", newJString(jobAgentName))
  add(path_564241, "resourceGroupName", newJString(resourceGroupName))
  add(path_564241, "jobName", newJString(jobName))
  result = call_564240.call(path_564241, query_564242, nil, nil, nil)

var jobsGet* = Call_JobsGet_564230(name: "jobsGet", meth: HttpMethod.HttpGet,
                                host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/servers/{serverName}/jobAgents/{jobAgentName}/jobs/{jobName}",
                                validator: validate_JobsGet_564231, base: "",
                                url: url_JobsGet_564232, schemes: {Scheme.Https})
type
  Call_JobsDelete_564258 = ref object of OpenApiRestCall_563555
proc url_JobsDelete_564260(protocol: Scheme; host: string; base: string; route: string;
                          path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serverName" in path, "`serverName` is a required path parameter"
  assert "jobAgentName" in path, "`jobAgentName` is a required path parameter"
  assert "jobName" in path, "`jobName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Sql/servers/"),
               (kind: VariableSegment, value: "serverName"),
               (kind: ConstantSegment, value: "/jobAgents/"),
               (kind: VariableSegment, value: "jobAgentName"),
               (kind: ConstantSegment, value: "/jobs/"),
               (kind: VariableSegment, value: "jobName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_JobsDelete_564259(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a job.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serverName: JString (required)
  ##             : The name of the server.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   jobAgentName: JString (required)
  ##               : The name of the job agent.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   jobName: JString (required)
  ##          : The name of the job to delete.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serverName` field"
  var valid_564261 = path.getOrDefault("serverName")
  valid_564261 = validateParameter(valid_564261, JString, required = true,
                                 default = nil)
  if valid_564261 != nil:
    section.add "serverName", valid_564261
  var valid_564262 = path.getOrDefault("subscriptionId")
  valid_564262 = validateParameter(valid_564262, JString, required = true,
                                 default = nil)
  if valid_564262 != nil:
    section.add "subscriptionId", valid_564262
  var valid_564263 = path.getOrDefault("jobAgentName")
  valid_564263 = validateParameter(valid_564263, JString, required = true,
                                 default = nil)
  if valid_564263 != nil:
    section.add "jobAgentName", valid_564263
  var valid_564264 = path.getOrDefault("resourceGroupName")
  valid_564264 = validateParameter(valid_564264, JString, required = true,
                                 default = nil)
  if valid_564264 != nil:
    section.add "resourceGroupName", valid_564264
  var valid_564265 = path.getOrDefault("jobName")
  valid_564265 = validateParameter(valid_564265, JString, required = true,
                                 default = nil)
  if valid_564265 != nil:
    section.add "jobName", valid_564265
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564266 = query.getOrDefault("api-version")
  valid_564266 = validateParameter(valid_564266, JString, required = true,
                                 default = nil)
  if valid_564266 != nil:
    section.add "api-version", valid_564266
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564267: Call_JobsDelete_564258; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a job.
  ## 
  let valid = call_564267.validator(path, query, header, formData, body)
  let scheme = call_564267.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564267.url(scheme.get, call_564267.host, call_564267.base,
                         call_564267.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564267, url, valid)

proc call*(call_564268: Call_JobsDelete_564258; apiVersion: string;
          serverName: string; subscriptionId: string; jobAgentName: string;
          resourceGroupName: string; jobName: string): Recallable =
  ## jobsDelete
  ## Deletes a job.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   serverName: string (required)
  ##             : The name of the server.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   jobAgentName: string (required)
  ##               : The name of the job agent.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   jobName: string (required)
  ##          : The name of the job to delete.
  var path_564269 = newJObject()
  var query_564270 = newJObject()
  add(query_564270, "api-version", newJString(apiVersion))
  add(path_564269, "serverName", newJString(serverName))
  add(path_564269, "subscriptionId", newJString(subscriptionId))
  add(path_564269, "jobAgentName", newJString(jobAgentName))
  add(path_564269, "resourceGroupName", newJString(resourceGroupName))
  add(path_564269, "jobName", newJString(jobName))
  result = call_564268.call(path_564269, query_564270, nil, nil, nil)

var jobsDelete* = Call_JobsDelete_564258(name: "jobsDelete",
                                      meth: HttpMethod.HttpDelete,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/servers/{serverName}/jobAgents/{jobAgentName}/jobs/{jobName}",
                                      validator: validate_JobsDelete_564259,
                                      base: "", url: url_JobsDelete_564260,
                                      schemes: {Scheme.Https})
type
  Call_JobExecutionsListByJob_564271 = ref object of OpenApiRestCall_563555
proc url_JobExecutionsListByJob_564273(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serverName" in path, "`serverName` is a required path parameter"
  assert "jobAgentName" in path, "`jobAgentName` is a required path parameter"
  assert "jobName" in path, "`jobName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Sql/servers/"),
               (kind: VariableSegment, value: "serverName"),
               (kind: ConstantSegment, value: "/jobAgents/"),
               (kind: VariableSegment, value: "jobAgentName"),
               (kind: ConstantSegment, value: "/jobs/"),
               (kind: VariableSegment, value: "jobName"),
               (kind: ConstantSegment, value: "/executions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_JobExecutionsListByJob_564272(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists a job's executions.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serverName: JString (required)
  ##             : The name of the server.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   jobAgentName: JString (required)
  ##               : The name of the job agent.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   jobName: JString (required)
  ##          : The name of the job to get.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serverName` field"
  var valid_564274 = path.getOrDefault("serverName")
  valid_564274 = validateParameter(valid_564274, JString, required = true,
                                 default = nil)
  if valid_564274 != nil:
    section.add "serverName", valid_564274
  var valid_564275 = path.getOrDefault("subscriptionId")
  valid_564275 = validateParameter(valid_564275, JString, required = true,
                                 default = nil)
  if valid_564275 != nil:
    section.add "subscriptionId", valid_564275
  var valid_564276 = path.getOrDefault("jobAgentName")
  valid_564276 = validateParameter(valid_564276, JString, required = true,
                                 default = nil)
  if valid_564276 != nil:
    section.add "jobAgentName", valid_564276
  var valid_564277 = path.getOrDefault("resourceGroupName")
  valid_564277 = validateParameter(valid_564277, JString, required = true,
                                 default = nil)
  if valid_564277 != nil:
    section.add "resourceGroupName", valid_564277
  var valid_564278 = path.getOrDefault("jobName")
  valid_564278 = validateParameter(valid_564278, JString, required = true,
                                 default = nil)
  if valid_564278 != nil:
    section.add "jobName", valid_564278
  result.add "path", section
  ## parameters in `query` object:
  ##   $top: JInt
  ##       : The number of elements to return from the collection.
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  ##   endTimeMin: JString
  ##             : If specified, only job executions completed at or after the specified time are included.
  ##   isActive: JBool
  ##           : If specified, only active or only completed job executions are included.
  ##   createTimeMin: JString
  ##                : If specified, only job executions created at or after the specified time are included.
  ##   $skip: JInt
  ##        : The number of elements in the collection to skip.
  ##   createTimeMax: JString
  ##                : If specified, only job executions created before the specified time are included.
  ##   endTimeMax: JString
  ##             : If specified, only job executions completed before the specified time are included.
  section = newJObject()
  var valid_564279 = query.getOrDefault("$top")
  valid_564279 = validateParameter(valid_564279, JInt, required = false, default = nil)
  if valid_564279 != nil:
    section.add "$top", valid_564279
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564280 = query.getOrDefault("api-version")
  valid_564280 = validateParameter(valid_564280, JString, required = true,
                                 default = nil)
  if valid_564280 != nil:
    section.add "api-version", valid_564280
  var valid_564281 = query.getOrDefault("endTimeMin")
  valid_564281 = validateParameter(valid_564281, JString, required = false,
                                 default = nil)
  if valid_564281 != nil:
    section.add "endTimeMin", valid_564281
  var valid_564282 = query.getOrDefault("isActive")
  valid_564282 = validateParameter(valid_564282, JBool, required = false, default = nil)
  if valid_564282 != nil:
    section.add "isActive", valid_564282
  var valid_564283 = query.getOrDefault("createTimeMin")
  valid_564283 = validateParameter(valid_564283, JString, required = false,
                                 default = nil)
  if valid_564283 != nil:
    section.add "createTimeMin", valid_564283
  var valid_564284 = query.getOrDefault("$skip")
  valid_564284 = validateParameter(valid_564284, JInt, required = false, default = nil)
  if valid_564284 != nil:
    section.add "$skip", valid_564284
  var valid_564285 = query.getOrDefault("createTimeMax")
  valid_564285 = validateParameter(valid_564285, JString, required = false,
                                 default = nil)
  if valid_564285 != nil:
    section.add "createTimeMax", valid_564285
  var valid_564286 = query.getOrDefault("endTimeMax")
  valid_564286 = validateParameter(valid_564286, JString, required = false,
                                 default = nil)
  if valid_564286 != nil:
    section.add "endTimeMax", valid_564286
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564287: Call_JobExecutionsListByJob_564271; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists a job's executions.
  ## 
  let valid = call_564287.validator(path, query, header, formData, body)
  let scheme = call_564287.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564287.url(scheme.get, call_564287.host, call_564287.base,
                         call_564287.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564287, url, valid)

proc call*(call_564288: Call_JobExecutionsListByJob_564271; apiVersion: string;
          serverName: string; subscriptionId: string; jobAgentName: string;
          resourceGroupName: string; jobName: string; Top: int = 0;
          endTimeMin: string = ""; isActive: bool = false; createTimeMin: string = "";
          Skip: int = 0; createTimeMax: string = ""; endTimeMax: string = ""): Recallable =
  ## jobExecutionsListByJob
  ## Lists a job's executions.
  ##   Top: int
  ##      : The number of elements to return from the collection.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   endTimeMin: string
  ##             : If specified, only job executions completed at or after the specified time are included.
  ##   serverName: string (required)
  ##             : The name of the server.
  ##   isActive: bool
  ##           : If specified, only active or only completed job executions are included.
  ##   createTimeMin: string
  ##                : If specified, only job executions created at or after the specified time are included.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   jobAgentName: string (required)
  ##               : The name of the job agent.
  ##   Skip: int
  ##       : The number of elements in the collection to skip.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   createTimeMax: string
  ##                : If specified, only job executions created before the specified time are included.
  ##   endTimeMax: string
  ##             : If specified, only job executions completed before the specified time are included.
  ##   jobName: string (required)
  ##          : The name of the job to get.
  var path_564289 = newJObject()
  var query_564290 = newJObject()
  add(query_564290, "$top", newJInt(Top))
  add(query_564290, "api-version", newJString(apiVersion))
  add(query_564290, "endTimeMin", newJString(endTimeMin))
  add(path_564289, "serverName", newJString(serverName))
  add(query_564290, "isActive", newJBool(isActive))
  add(query_564290, "createTimeMin", newJString(createTimeMin))
  add(path_564289, "subscriptionId", newJString(subscriptionId))
  add(path_564289, "jobAgentName", newJString(jobAgentName))
  add(query_564290, "$skip", newJInt(Skip))
  add(path_564289, "resourceGroupName", newJString(resourceGroupName))
  add(query_564290, "createTimeMax", newJString(createTimeMax))
  add(query_564290, "endTimeMax", newJString(endTimeMax))
  add(path_564289, "jobName", newJString(jobName))
  result = call_564288.call(path_564289, query_564290, nil, nil, nil)

var jobExecutionsListByJob* = Call_JobExecutionsListByJob_564271(
    name: "jobExecutionsListByJob", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/servers/{serverName}/jobAgents/{jobAgentName}/jobs/{jobName}/executions",
    validator: validate_JobExecutionsListByJob_564272, base: "",
    url: url_JobExecutionsListByJob_564273, schemes: {Scheme.Https})
type
  Call_JobExecutionsCreateOrUpdate_564305 = ref object of OpenApiRestCall_563555
proc url_JobExecutionsCreateOrUpdate_564307(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serverName" in path, "`serverName` is a required path parameter"
  assert "jobAgentName" in path, "`jobAgentName` is a required path parameter"
  assert "jobName" in path, "`jobName` is a required path parameter"
  assert "jobExecutionId" in path, "`jobExecutionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Sql/servers/"),
               (kind: VariableSegment, value: "serverName"),
               (kind: ConstantSegment, value: "/jobAgents/"),
               (kind: VariableSegment, value: "jobAgentName"),
               (kind: ConstantSegment, value: "/jobs/"),
               (kind: VariableSegment, value: "jobName"),
               (kind: ConstantSegment, value: "/executions/"),
               (kind: VariableSegment, value: "jobExecutionId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_JobExecutionsCreateOrUpdate_564306(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates a job execution.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serverName: JString (required)
  ##             : The name of the server.
  ##   jobExecutionId: JString (required)
  ##                 : The job execution id to create the job execution under.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   jobAgentName: JString (required)
  ##               : The name of the job agent.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   jobName: JString (required)
  ##          : The name of the job to get.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serverName` field"
  var valid_564308 = path.getOrDefault("serverName")
  valid_564308 = validateParameter(valid_564308, JString, required = true,
                                 default = nil)
  if valid_564308 != nil:
    section.add "serverName", valid_564308
  var valid_564309 = path.getOrDefault("jobExecutionId")
  valid_564309 = validateParameter(valid_564309, JString, required = true,
                                 default = nil)
  if valid_564309 != nil:
    section.add "jobExecutionId", valid_564309
  var valid_564310 = path.getOrDefault("subscriptionId")
  valid_564310 = validateParameter(valid_564310, JString, required = true,
                                 default = nil)
  if valid_564310 != nil:
    section.add "subscriptionId", valid_564310
  var valid_564311 = path.getOrDefault("jobAgentName")
  valid_564311 = validateParameter(valid_564311, JString, required = true,
                                 default = nil)
  if valid_564311 != nil:
    section.add "jobAgentName", valid_564311
  var valid_564312 = path.getOrDefault("resourceGroupName")
  valid_564312 = validateParameter(valid_564312, JString, required = true,
                                 default = nil)
  if valid_564312 != nil:
    section.add "resourceGroupName", valid_564312
  var valid_564313 = path.getOrDefault("jobName")
  valid_564313 = validateParameter(valid_564313, JString, required = true,
                                 default = nil)
  if valid_564313 != nil:
    section.add "jobName", valid_564313
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564314 = query.getOrDefault("api-version")
  valid_564314 = validateParameter(valid_564314, JString, required = true,
                                 default = nil)
  if valid_564314 != nil:
    section.add "api-version", valid_564314
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564315: Call_JobExecutionsCreateOrUpdate_564305; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates a job execution.
  ## 
  let valid = call_564315.validator(path, query, header, formData, body)
  let scheme = call_564315.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564315.url(scheme.get, call_564315.host, call_564315.base,
                         call_564315.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564315, url, valid)

proc call*(call_564316: Call_JobExecutionsCreateOrUpdate_564305;
          apiVersion: string; serverName: string; jobExecutionId: string;
          subscriptionId: string; jobAgentName: string; resourceGroupName: string;
          jobName: string): Recallable =
  ## jobExecutionsCreateOrUpdate
  ## Creates or updates a job execution.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   serverName: string (required)
  ##             : The name of the server.
  ##   jobExecutionId: string (required)
  ##                 : The job execution id to create the job execution under.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   jobAgentName: string (required)
  ##               : The name of the job agent.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   jobName: string (required)
  ##          : The name of the job to get.
  var path_564317 = newJObject()
  var query_564318 = newJObject()
  add(query_564318, "api-version", newJString(apiVersion))
  add(path_564317, "serverName", newJString(serverName))
  add(path_564317, "jobExecutionId", newJString(jobExecutionId))
  add(path_564317, "subscriptionId", newJString(subscriptionId))
  add(path_564317, "jobAgentName", newJString(jobAgentName))
  add(path_564317, "resourceGroupName", newJString(resourceGroupName))
  add(path_564317, "jobName", newJString(jobName))
  result = call_564316.call(path_564317, query_564318, nil, nil, nil)

var jobExecutionsCreateOrUpdate* = Call_JobExecutionsCreateOrUpdate_564305(
    name: "jobExecutionsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/servers/{serverName}/jobAgents/{jobAgentName}/jobs/{jobName}/executions/{jobExecutionId}",
    validator: validate_JobExecutionsCreateOrUpdate_564306, base: "",
    url: url_JobExecutionsCreateOrUpdate_564307, schemes: {Scheme.Https})
type
  Call_JobExecutionsGet_564291 = ref object of OpenApiRestCall_563555
proc url_JobExecutionsGet_564293(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serverName" in path, "`serverName` is a required path parameter"
  assert "jobAgentName" in path, "`jobAgentName` is a required path parameter"
  assert "jobName" in path, "`jobName` is a required path parameter"
  assert "jobExecutionId" in path, "`jobExecutionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Sql/servers/"),
               (kind: VariableSegment, value: "serverName"),
               (kind: ConstantSegment, value: "/jobAgents/"),
               (kind: VariableSegment, value: "jobAgentName"),
               (kind: ConstantSegment, value: "/jobs/"),
               (kind: VariableSegment, value: "jobName"),
               (kind: ConstantSegment, value: "/executions/"),
               (kind: VariableSegment, value: "jobExecutionId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_JobExecutionsGet_564292(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Gets a job execution.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serverName: JString (required)
  ##             : The name of the server.
  ##   jobExecutionId: JString (required)
  ##                 : The id of the job execution
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   jobAgentName: JString (required)
  ##               : The name of the job agent.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   jobName: JString (required)
  ##          : The name of the job.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serverName` field"
  var valid_564294 = path.getOrDefault("serverName")
  valid_564294 = validateParameter(valid_564294, JString, required = true,
                                 default = nil)
  if valid_564294 != nil:
    section.add "serverName", valid_564294
  var valid_564295 = path.getOrDefault("jobExecutionId")
  valid_564295 = validateParameter(valid_564295, JString, required = true,
                                 default = nil)
  if valid_564295 != nil:
    section.add "jobExecutionId", valid_564295
  var valid_564296 = path.getOrDefault("subscriptionId")
  valid_564296 = validateParameter(valid_564296, JString, required = true,
                                 default = nil)
  if valid_564296 != nil:
    section.add "subscriptionId", valid_564296
  var valid_564297 = path.getOrDefault("jobAgentName")
  valid_564297 = validateParameter(valid_564297, JString, required = true,
                                 default = nil)
  if valid_564297 != nil:
    section.add "jobAgentName", valid_564297
  var valid_564298 = path.getOrDefault("resourceGroupName")
  valid_564298 = validateParameter(valid_564298, JString, required = true,
                                 default = nil)
  if valid_564298 != nil:
    section.add "resourceGroupName", valid_564298
  var valid_564299 = path.getOrDefault("jobName")
  valid_564299 = validateParameter(valid_564299, JString, required = true,
                                 default = nil)
  if valid_564299 != nil:
    section.add "jobName", valid_564299
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564300 = query.getOrDefault("api-version")
  valid_564300 = validateParameter(valid_564300, JString, required = true,
                                 default = nil)
  if valid_564300 != nil:
    section.add "api-version", valid_564300
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564301: Call_JobExecutionsGet_564291; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a job execution.
  ## 
  let valid = call_564301.validator(path, query, header, formData, body)
  let scheme = call_564301.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564301.url(scheme.get, call_564301.host, call_564301.base,
                         call_564301.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564301, url, valid)

proc call*(call_564302: Call_JobExecutionsGet_564291; apiVersion: string;
          serverName: string; jobExecutionId: string; subscriptionId: string;
          jobAgentName: string; resourceGroupName: string; jobName: string): Recallable =
  ## jobExecutionsGet
  ## Gets a job execution.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   serverName: string (required)
  ##             : The name of the server.
  ##   jobExecutionId: string (required)
  ##                 : The id of the job execution
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   jobAgentName: string (required)
  ##               : The name of the job agent.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   jobName: string (required)
  ##          : The name of the job.
  var path_564303 = newJObject()
  var query_564304 = newJObject()
  add(query_564304, "api-version", newJString(apiVersion))
  add(path_564303, "serverName", newJString(serverName))
  add(path_564303, "jobExecutionId", newJString(jobExecutionId))
  add(path_564303, "subscriptionId", newJString(subscriptionId))
  add(path_564303, "jobAgentName", newJString(jobAgentName))
  add(path_564303, "resourceGroupName", newJString(resourceGroupName))
  add(path_564303, "jobName", newJString(jobName))
  result = call_564302.call(path_564303, query_564304, nil, nil, nil)

var jobExecutionsGet* = Call_JobExecutionsGet_564291(name: "jobExecutionsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/servers/{serverName}/jobAgents/{jobAgentName}/jobs/{jobName}/executions/{jobExecutionId}",
    validator: validate_JobExecutionsGet_564292, base: "",
    url: url_JobExecutionsGet_564293, schemes: {Scheme.Https})
type
  Call_JobExecutionsCancel_564319 = ref object of OpenApiRestCall_563555
proc url_JobExecutionsCancel_564321(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serverName" in path, "`serverName` is a required path parameter"
  assert "jobAgentName" in path, "`jobAgentName` is a required path parameter"
  assert "jobName" in path, "`jobName` is a required path parameter"
  assert "jobExecutionId" in path, "`jobExecutionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Sql/servers/"),
               (kind: VariableSegment, value: "serverName"),
               (kind: ConstantSegment, value: "/jobAgents/"),
               (kind: VariableSegment, value: "jobAgentName"),
               (kind: ConstantSegment, value: "/jobs/"),
               (kind: VariableSegment, value: "jobName"),
               (kind: ConstantSegment, value: "/executions/"),
               (kind: VariableSegment, value: "jobExecutionId"),
               (kind: ConstantSegment, value: "/cancel")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_JobExecutionsCancel_564320(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Requests cancellation of a job execution.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serverName: JString (required)
  ##             : The name of the server.
  ##   jobExecutionId: JString (required)
  ##                 : The id of the job execution to cancel.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   jobAgentName: JString (required)
  ##               : The name of the job agent.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   jobName: JString (required)
  ##          : The name of the job.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serverName` field"
  var valid_564322 = path.getOrDefault("serverName")
  valid_564322 = validateParameter(valid_564322, JString, required = true,
                                 default = nil)
  if valid_564322 != nil:
    section.add "serverName", valid_564322
  var valid_564323 = path.getOrDefault("jobExecutionId")
  valid_564323 = validateParameter(valid_564323, JString, required = true,
                                 default = nil)
  if valid_564323 != nil:
    section.add "jobExecutionId", valid_564323
  var valid_564324 = path.getOrDefault("subscriptionId")
  valid_564324 = validateParameter(valid_564324, JString, required = true,
                                 default = nil)
  if valid_564324 != nil:
    section.add "subscriptionId", valid_564324
  var valid_564325 = path.getOrDefault("jobAgentName")
  valid_564325 = validateParameter(valid_564325, JString, required = true,
                                 default = nil)
  if valid_564325 != nil:
    section.add "jobAgentName", valid_564325
  var valid_564326 = path.getOrDefault("resourceGroupName")
  valid_564326 = validateParameter(valid_564326, JString, required = true,
                                 default = nil)
  if valid_564326 != nil:
    section.add "resourceGroupName", valid_564326
  var valid_564327 = path.getOrDefault("jobName")
  valid_564327 = validateParameter(valid_564327, JString, required = true,
                                 default = nil)
  if valid_564327 != nil:
    section.add "jobName", valid_564327
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564328 = query.getOrDefault("api-version")
  valid_564328 = validateParameter(valid_564328, JString, required = true,
                                 default = nil)
  if valid_564328 != nil:
    section.add "api-version", valid_564328
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564329: Call_JobExecutionsCancel_564319; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Requests cancellation of a job execution.
  ## 
  let valid = call_564329.validator(path, query, header, formData, body)
  let scheme = call_564329.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564329.url(scheme.get, call_564329.host, call_564329.base,
                         call_564329.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564329, url, valid)

proc call*(call_564330: Call_JobExecutionsCancel_564319; apiVersion: string;
          serverName: string; jobExecutionId: string; subscriptionId: string;
          jobAgentName: string; resourceGroupName: string; jobName: string): Recallable =
  ## jobExecutionsCancel
  ## Requests cancellation of a job execution.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   serverName: string (required)
  ##             : The name of the server.
  ##   jobExecutionId: string (required)
  ##                 : The id of the job execution to cancel.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   jobAgentName: string (required)
  ##               : The name of the job agent.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   jobName: string (required)
  ##          : The name of the job.
  var path_564331 = newJObject()
  var query_564332 = newJObject()
  add(query_564332, "api-version", newJString(apiVersion))
  add(path_564331, "serverName", newJString(serverName))
  add(path_564331, "jobExecutionId", newJString(jobExecutionId))
  add(path_564331, "subscriptionId", newJString(subscriptionId))
  add(path_564331, "jobAgentName", newJString(jobAgentName))
  add(path_564331, "resourceGroupName", newJString(resourceGroupName))
  add(path_564331, "jobName", newJString(jobName))
  result = call_564330.call(path_564331, query_564332, nil, nil, nil)

var jobExecutionsCancel* = Call_JobExecutionsCancel_564319(
    name: "jobExecutionsCancel", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/servers/{serverName}/jobAgents/{jobAgentName}/jobs/{jobName}/executions/{jobExecutionId}/cancel",
    validator: validate_JobExecutionsCancel_564320, base: "",
    url: url_JobExecutionsCancel_564321, schemes: {Scheme.Https})
type
  Call_JobStepExecutionsListByJobExecution_564333 = ref object of OpenApiRestCall_563555
proc url_JobStepExecutionsListByJobExecution_564335(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serverName" in path, "`serverName` is a required path parameter"
  assert "jobAgentName" in path, "`jobAgentName` is a required path parameter"
  assert "jobName" in path, "`jobName` is a required path parameter"
  assert "jobExecutionId" in path, "`jobExecutionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Sql/servers/"),
               (kind: VariableSegment, value: "serverName"),
               (kind: ConstantSegment, value: "/jobAgents/"),
               (kind: VariableSegment, value: "jobAgentName"),
               (kind: ConstantSegment, value: "/jobs/"),
               (kind: VariableSegment, value: "jobName"),
               (kind: ConstantSegment, value: "/executions/"),
               (kind: VariableSegment, value: "jobExecutionId"),
               (kind: ConstantSegment, value: "/steps")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_JobStepExecutionsListByJobExecution_564334(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the step executions of a job execution.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serverName: JString (required)
  ##             : The name of the server.
  ##   jobExecutionId: JString (required)
  ##                 : The id of the job execution
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   jobAgentName: JString (required)
  ##               : The name of the job agent.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   jobName: JString (required)
  ##          : The name of the job to get.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serverName` field"
  var valid_564336 = path.getOrDefault("serverName")
  valid_564336 = validateParameter(valid_564336, JString, required = true,
                                 default = nil)
  if valid_564336 != nil:
    section.add "serverName", valid_564336
  var valid_564337 = path.getOrDefault("jobExecutionId")
  valid_564337 = validateParameter(valid_564337, JString, required = true,
                                 default = nil)
  if valid_564337 != nil:
    section.add "jobExecutionId", valid_564337
  var valid_564338 = path.getOrDefault("subscriptionId")
  valid_564338 = validateParameter(valid_564338, JString, required = true,
                                 default = nil)
  if valid_564338 != nil:
    section.add "subscriptionId", valid_564338
  var valid_564339 = path.getOrDefault("jobAgentName")
  valid_564339 = validateParameter(valid_564339, JString, required = true,
                                 default = nil)
  if valid_564339 != nil:
    section.add "jobAgentName", valid_564339
  var valid_564340 = path.getOrDefault("resourceGroupName")
  valid_564340 = validateParameter(valid_564340, JString, required = true,
                                 default = nil)
  if valid_564340 != nil:
    section.add "resourceGroupName", valid_564340
  var valid_564341 = path.getOrDefault("jobName")
  valid_564341 = validateParameter(valid_564341, JString, required = true,
                                 default = nil)
  if valid_564341 != nil:
    section.add "jobName", valid_564341
  result.add "path", section
  ## parameters in `query` object:
  ##   $top: JInt
  ##       : The number of elements to return from the collection.
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  ##   endTimeMin: JString
  ##             : If specified, only job executions completed at or after the specified time are included.
  ##   isActive: JBool
  ##           : If specified, only active or only completed job executions are included.
  ##   createTimeMin: JString
  ##                : If specified, only job executions created at or after the specified time are included.
  ##   $skip: JInt
  ##        : The number of elements in the collection to skip.
  ##   createTimeMax: JString
  ##                : If specified, only job executions created before the specified time are included.
  ##   endTimeMax: JString
  ##             : If specified, only job executions completed before the specified time are included.
  section = newJObject()
  var valid_564342 = query.getOrDefault("$top")
  valid_564342 = validateParameter(valid_564342, JInt, required = false, default = nil)
  if valid_564342 != nil:
    section.add "$top", valid_564342
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564343 = query.getOrDefault("api-version")
  valid_564343 = validateParameter(valid_564343, JString, required = true,
                                 default = nil)
  if valid_564343 != nil:
    section.add "api-version", valid_564343
  var valid_564344 = query.getOrDefault("endTimeMin")
  valid_564344 = validateParameter(valid_564344, JString, required = false,
                                 default = nil)
  if valid_564344 != nil:
    section.add "endTimeMin", valid_564344
  var valid_564345 = query.getOrDefault("isActive")
  valid_564345 = validateParameter(valid_564345, JBool, required = false, default = nil)
  if valid_564345 != nil:
    section.add "isActive", valid_564345
  var valid_564346 = query.getOrDefault("createTimeMin")
  valid_564346 = validateParameter(valid_564346, JString, required = false,
                                 default = nil)
  if valid_564346 != nil:
    section.add "createTimeMin", valid_564346
  var valid_564347 = query.getOrDefault("$skip")
  valid_564347 = validateParameter(valid_564347, JInt, required = false, default = nil)
  if valid_564347 != nil:
    section.add "$skip", valid_564347
  var valid_564348 = query.getOrDefault("createTimeMax")
  valid_564348 = validateParameter(valid_564348, JString, required = false,
                                 default = nil)
  if valid_564348 != nil:
    section.add "createTimeMax", valid_564348
  var valid_564349 = query.getOrDefault("endTimeMax")
  valid_564349 = validateParameter(valid_564349, JString, required = false,
                                 default = nil)
  if valid_564349 != nil:
    section.add "endTimeMax", valid_564349
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564350: Call_JobStepExecutionsListByJobExecution_564333;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the step executions of a job execution.
  ## 
  let valid = call_564350.validator(path, query, header, formData, body)
  let scheme = call_564350.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564350.url(scheme.get, call_564350.host, call_564350.base,
                         call_564350.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564350, url, valid)

proc call*(call_564351: Call_JobStepExecutionsListByJobExecution_564333;
          apiVersion: string; serverName: string; jobExecutionId: string;
          subscriptionId: string; jobAgentName: string; resourceGroupName: string;
          jobName: string; Top: int = 0; endTimeMin: string = ""; isActive: bool = false;
          createTimeMin: string = ""; Skip: int = 0; createTimeMax: string = "";
          endTimeMax: string = ""): Recallable =
  ## jobStepExecutionsListByJobExecution
  ## Lists the step executions of a job execution.
  ##   Top: int
  ##      : The number of elements to return from the collection.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   endTimeMin: string
  ##             : If specified, only job executions completed at or after the specified time are included.
  ##   serverName: string (required)
  ##             : The name of the server.
  ##   isActive: bool
  ##           : If specified, only active or only completed job executions are included.
  ##   jobExecutionId: string (required)
  ##                 : The id of the job execution
  ##   createTimeMin: string
  ##                : If specified, only job executions created at or after the specified time are included.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   jobAgentName: string (required)
  ##               : The name of the job agent.
  ##   Skip: int
  ##       : The number of elements in the collection to skip.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   createTimeMax: string
  ##                : If specified, only job executions created before the specified time are included.
  ##   endTimeMax: string
  ##             : If specified, only job executions completed before the specified time are included.
  ##   jobName: string (required)
  ##          : The name of the job to get.
  var path_564352 = newJObject()
  var query_564353 = newJObject()
  add(query_564353, "$top", newJInt(Top))
  add(query_564353, "api-version", newJString(apiVersion))
  add(query_564353, "endTimeMin", newJString(endTimeMin))
  add(path_564352, "serverName", newJString(serverName))
  add(query_564353, "isActive", newJBool(isActive))
  add(path_564352, "jobExecutionId", newJString(jobExecutionId))
  add(query_564353, "createTimeMin", newJString(createTimeMin))
  add(path_564352, "subscriptionId", newJString(subscriptionId))
  add(path_564352, "jobAgentName", newJString(jobAgentName))
  add(query_564353, "$skip", newJInt(Skip))
  add(path_564352, "resourceGroupName", newJString(resourceGroupName))
  add(query_564353, "createTimeMax", newJString(createTimeMax))
  add(query_564353, "endTimeMax", newJString(endTimeMax))
  add(path_564352, "jobName", newJString(jobName))
  result = call_564351.call(path_564352, query_564353, nil, nil, nil)

var jobStepExecutionsListByJobExecution* = Call_JobStepExecutionsListByJobExecution_564333(
    name: "jobStepExecutionsListByJobExecution", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/servers/{serverName}/jobAgents/{jobAgentName}/jobs/{jobName}/executions/{jobExecutionId}/steps",
    validator: validate_JobStepExecutionsListByJobExecution_564334, base: "",
    url: url_JobStepExecutionsListByJobExecution_564335, schemes: {Scheme.Https})
type
  Call_JobStepExecutionsGet_564354 = ref object of OpenApiRestCall_563555
proc url_JobStepExecutionsGet_564356(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serverName" in path, "`serverName` is a required path parameter"
  assert "jobAgentName" in path, "`jobAgentName` is a required path parameter"
  assert "jobName" in path, "`jobName` is a required path parameter"
  assert "jobExecutionId" in path, "`jobExecutionId` is a required path parameter"
  assert "stepName" in path, "`stepName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Sql/servers/"),
               (kind: VariableSegment, value: "serverName"),
               (kind: ConstantSegment, value: "/jobAgents/"),
               (kind: VariableSegment, value: "jobAgentName"),
               (kind: ConstantSegment, value: "/jobs/"),
               (kind: VariableSegment, value: "jobName"),
               (kind: ConstantSegment, value: "/executions/"),
               (kind: VariableSegment, value: "jobExecutionId"),
               (kind: ConstantSegment, value: "/steps/"),
               (kind: VariableSegment, value: "stepName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_JobStepExecutionsGet_564355(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a step execution of a job execution.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serverName: JString (required)
  ##             : The name of the server.
  ##   jobExecutionId: JString (required)
  ##                 : The unique id of the job execution
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   jobAgentName: JString (required)
  ##               : The name of the job agent.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   stepName: JString (required)
  ##           : The name of the step.
  ##   jobName: JString (required)
  ##          : The name of the job to get.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serverName` field"
  var valid_564357 = path.getOrDefault("serverName")
  valid_564357 = validateParameter(valid_564357, JString, required = true,
                                 default = nil)
  if valid_564357 != nil:
    section.add "serverName", valid_564357
  var valid_564358 = path.getOrDefault("jobExecutionId")
  valid_564358 = validateParameter(valid_564358, JString, required = true,
                                 default = nil)
  if valid_564358 != nil:
    section.add "jobExecutionId", valid_564358
  var valid_564359 = path.getOrDefault("subscriptionId")
  valid_564359 = validateParameter(valid_564359, JString, required = true,
                                 default = nil)
  if valid_564359 != nil:
    section.add "subscriptionId", valid_564359
  var valid_564360 = path.getOrDefault("jobAgentName")
  valid_564360 = validateParameter(valid_564360, JString, required = true,
                                 default = nil)
  if valid_564360 != nil:
    section.add "jobAgentName", valid_564360
  var valid_564361 = path.getOrDefault("resourceGroupName")
  valid_564361 = validateParameter(valid_564361, JString, required = true,
                                 default = nil)
  if valid_564361 != nil:
    section.add "resourceGroupName", valid_564361
  var valid_564362 = path.getOrDefault("stepName")
  valid_564362 = validateParameter(valid_564362, JString, required = true,
                                 default = nil)
  if valid_564362 != nil:
    section.add "stepName", valid_564362
  var valid_564363 = path.getOrDefault("jobName")
  valid_564363 = validateParameter(valid_564363, JString, required = true,
                                 default = nil)
  if valid_564363 != nil:
    section.add "jobName", valid_564363
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564364 = query.getOrDefault("api-version")
  valid_564364 = validateParameter(valid_564364, JString, required = true,
                                 default = nil)
  if valid_564364 != nil:
    section.add "api-version", valid_564364
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564365: Call_JobStepExecutionsGet_564354; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a step execution of a job execution.
  ## 
  let valid = call_564365.validator(path, query, header, formData, body)
  let scheme = call_564365.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564365.url(scheme.get, call_564365.host, call_564365.base,
                         call_564365.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564365, url, valid)

proc call*(call_564366: Call_JobStepExecutionsGet_564354; apiVersion: string;
          serverName: string; jobExecutionId: string; subscriptionId: string;
          jobAgentName: string; resourceGroupName: string; stepName: string;
          jobName: string): Recallable =
  ## jobStepExecutionsGet
  ## Gets a step execution of a job execution.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   serverName: string (required)
  ##             : The name of the server.
  ##   jobExecutionId: string (required)
  ##                 : The unique id of the job execution
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   jobAgentName: string (required)
  ##               : The name of the job agent.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   stepName: string (required)
  ##           : The name of the step.
  ##   jobName: string (required)
  ##          : The name of the job to get.
  var path_564367 = newJObject()
  var query_564368 = newJObject()
  add(query_564368, "api-version", newJString(apiVersion))
  add(path_564367, "serverName", newJString(serverName))
  add(path_564367, "jobExecutionId", newJString(jobExecutionId))
  add(path_564367, "subscriptionId", newJString(subscriptionId))
  add(path_564367, "jobAgentName", newJString(jobAgentName))
  add(path_564367, "resourceGroupName", newJString(resourceGroupName))
  add(path_564367, "stepName", newJString(stepName))
  add(path_564367, "jobName", newJString(jobName))
  result = call_564366.call(path_564367, query_564368, nil, nil, nil)

var jobStepExecutionsGet* = Call_JobStepExecutionsGet_564354(
    name: "jobStepExecutionsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/servers/{serverName}/jobAgents/{jobAgentName}/jobs/{jobName}/executions/{jobExecutionId}/steps/{stepName}",
    validator: validate_JobStepExecutionsGet_564355, base: "",
    url: url_JobStepExecutionsGet_564356, schemes: {Scheme.Https})
type
  Call_JobTargetExecutionsListByStep_564369 = ref object of OpenApiRestCall_563555
proc url_JobTargetExecutionsListByStep_564371(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serverName" in path, "`serverName` is a required path parameter"
  assert "jobAgentName" in path, "`jobAgentName` is a required path parameter"
  assert "jobName" in path, "`jobName` is a required path parameter"
  assert "jobExecutionId" in path, "`jobExecutionId` is a required path parameter"
  assert "stepName" in path, "`stepName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Sql/servers/"),
               (kind: VariableSegment, value: "serverName"),
               (kind: ConstantSegment, value: "/jobAgents/"),
               (kind: VariableSegment, value: "jobAgentName"),
               (kind: ConstantSegment, value: "/jobs/"),
               (kind: VariableSegment, value: "jobName"),
               (kind: ConstantSegment, value: "/executions/"),
               (kind: VariableSegment, value: "jobExecutionId"),
               (kind: ConstantSegment, value: "/steps/"),
               (kind: VariableSegment, value: "stepName"),
               (kind: ConstantSegment, value: "/targets")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_JobTargetExecutionsListByStep_564370(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the target executions of a job step execution.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serverName: JString (required)
  ##             : The name of the server.
  ##   jobExecutionId: JString (required)
  ##                 : The id of the job execution
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   jobAgentName: JString (required)
  ##               : The name of the job agent.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   stepName: JString (required)
  ##           : The name of the step.
  ##   jobName: JString (required)
  ##          : The name of the job to get.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serverName` field"
  var valid_564372 = path.getOrDefault("serverName")
  valid_564372 = validateParameter(valid_564372, JString, required = true,
                                 default = nil)
  if valid_564372 != nil:
    section.add "serverName", valid_564372
  var valid_564373 = path.getOrDefault("jobExecutionId")
  valid_564373 = validateParameter(valid_564373, JString, required = true,
                                 default = nil)
  if valid_564373 != nil:
    section.add "jobExecutionId", valid_564373
  var valid_564374 = path.getOrDefault("subscriptionId")
  valid_564374 = validateParameter(valid_564374, JString, required = true,
                                 default = nil)
  if valid_564374 != nil:
    section.add "subscriptionId", valid_564374
  var valid_564375 = path.getOrDefault("jobAgentName")
  valid_564375 = validateParameter(valid_564375, JString, required = true,
                                 default = nil)
  if valid_564375 != nil:
    section.add "jobAgentName", valid_564375
  var valid_564376 = path.getOrDefault("resourceGroupName")
  valid_564376 = validateParameter(valid_564376, JString, required = true,
                                 default = nil)
  if valid_564376 != nil:
    section.add "resourceGroupName", valid_564376
  var valid_564377 = path.getOrDefault("stepName")
  valid_564377 = validateParameter(valid_564377, JString, required = true,
                                 default = nil)
  if valid_564377 != nil:
    section.add "stepName", valid_564377
  var valid_564378 = path.getOrDefault("jobName")
  valid_564378 = validateParameter(valid_564378, JString, required = true,
                                 default = nil)
  if valid_564378 != nil:
    section.add "jobName", valid_564378
  result.add "path", section
  ## parameters in `query` object:
  ##   $top: JInt
  ##       : The number of elements to return from the collection.
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  ##   endTimeMin: JString
  ##             : If specified, only job executions completed at or after the specified time are included.
  ##   isActive: JBool
  ##           : If specified, only active or only completed job executions are included.
  ##   createTimeMin: JString
  ##                : If specified, only job executions created at or after the specified time are included.
  ##   $skip: JInt
  ##        : The number of elements in the collection to skip.
  ##   createTimeMax: JString
  ##                : If specified, only job executions created before the specified time are included.
  ##   endTimeMax: JString
  ##             : If specified, only job executions completed before the specified time are included.
  section = newJObject()
  var valid_564379 = query.getOrDefault("$top")
  valid_564379 = validateParameter(valid_564379, JInt, required = false, default = nil)
  if valid_564379 != nil:
    section.add "$top", valid_564379
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564380 = query.getOrDefault("api-version")
  valid_564380 = validateParameter(valid_564380, JString, required = true,
                                 default = nil)
  if valid_564380 != nil:
    section.add "api-version", valid_564380
  var valid_564381 = query.getOrDefault("endTimeMin")
  valid_564381 = validateParameter(valid_564381, JString, required = false,
                                 default = nil)
  if valid_564381 != nil:
    section.add "endTimeMin", valid_564381
  var valid_564382 = query.getOrDefault("isActive")
  valid_564382 = validateParameter(valid_564382, JBool, required = false, default = nil)
  if valid_564382 != nil:
    section.add "isActive", valid_564382
  var valid_564383 = query.getOrDefault("createTimeMin")
  valid_564383 = validateParameter(valid_564383, JString, required = false,
                                 default = nil)
  if valid_564383 != nil:
    section.add "createTimeMin", valid_564383
  var valid_564384 = query.getOrDefault("$skip")
  valid_564384 = validateParameter(valid_564384, JInt, required = false, default = nil)
  if valid_564384 != nil:
    section.add "$skip", valid_564384
  var valid_564385 = query.getOrDefault("createTimeMax")
  valid_564385 = validateParameter(valid_564385, JString, required = false,
                                 default = nil)
  if valid_564385 != nil:
    section.add "createTimeMax", valid_564385
  var valid_564386 = query.getOrDefault("endTimeMax")
  valid_564386 = validateParameter(valid_564386, JString, required = false,
                                 default = nil)
  if valid_564386 != nil:
    section.add "endTimeMax", valid_564386
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564387: Call_JobTargetExecutionsListByStep_564369; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the target executions of a job step execution.
  ## 
  let valid = call_564387.validator(path, query, header, formData, body)
  let scheme = call_564387.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564387.url(scheme.get, call_564387.host, call_564387.base,
                         call_564387.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564387, url, valid)

proc call*(call_564388: Call_JobTargetExecutionsListByStep_564369;
          apiVersion: string; serverName: string; jobExecutionId: string;
          subscriptionId: string; jobAgentName: string; resourceGroupName: string;
          stepName: string; jobName: string; Top: int = 0; endTimeMin: string = "";
          isActive: bool = false; createTimeMin: string = ""; Skip: int = 0;
          createTimeMax: string = ""; endTimeMax: string = ""): Recallable =
  ## jobTargetExecutionsListByStep
  ## Lists the target executions of a job step execution.
  ##   Top: int
  ##      : The number of elements to return from the collection.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   endTimeMin: string
  ##             : If specified, only job executions completed at or after the specified time are included.
  ##   serverName: string (required)
  ##             : The name of the server.
  ##   isActive: bool
  ##           : If specified, only active or only completed job executions are included.
  ##   jobExecutionId: string (required)
  ##                 : The id of the job execution
  ##   createTimeMin: string
  ##                : If specified, only job executions created at or after the specified time are included.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   jobAgentName: string (required)
  ##               : The name of the job agent.
  ##   Skip: int
  ##       : The number of elements in the collection to skip.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   stepName: string (required)
  ##           : The name of the step.
  ##   createTimeMax: string
  ##                : If specified, only job executions created before the specified time are included.
  ##   endTimeMax: string
  ##             : If specified, only job executions completed before the specified time are included.
  ##   jobName: string (required)
  ##          : The name of the job to get.
  var path_564389 = newJObject()
  var query_564390 = newJObject()
  add(query_564390, "$top", newJInt(Top))
  add(query_564390, "api-version", newJString(apiVersion))
  add(query_564390, "endTimeMin", newJString(endTimeMin))
  add(path_564389, "serverName", newJString(serverName))
  add(query_564390, "isActive", newJBool(isActive))
  add(path_564389, "jobExecutionId", newJString(jobExecutionId))
  add(query_564390, "createTimeMin", newJString(createTimeMin))
  add(path_564389, "subscriptionId", newJString(subscriptionId))
  add(path_564389, "jobAgentName", newJString(jobAgentName))
  add(query_564390, "$skip", newJInt(Skip))
  add(path_564389, "resourceGroupName", newJString(resourceGroupName))
  add(path_564389, "stepName", newJString(stepName))
  add(query_564390, "createTimeMax", newJString(createTimeMax))
  add(query_564390, "endTimeMax", newJString(endTimeMax))
  add(path_564389, "jobName", newJString(jobName))
  result = call_564388.call(path_564389, query_564390, nil, nil, nil)

var jobTargetExecutionsListByStep* = Call_JobTargetExecutionsListByStep_564369(
    name: "jobTargetExecutionsListByStep", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/servers/{serverName}/jobAgents/{jobAgentName}/jobs/{jobName}/executions/{jobExecutionId}/steps/{stepName}/targets",
    validator: validate_JobTargetExecutionsListByStep_564370, base: "",
    url: url_JobTargetExecutionsListByStep_564371, schemes: {Scheme.Https})
type
  Call_JobTargetExecutionsGet_564391 = ref object of OpenApiRestCall_563555
proc url_JobTargetExecutionsGet_564393(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serverName" in path, "`serverName` is a required path parameter"
  assert "jobAgentName" in path, "`jobAgentName` is a required path parameter"
  assert "jobName" in path, "`jobName` is a required path parameter"
  assert "jobExecutionId" in path, "`jobExecutionId` is a required path parameter"
  assert "stepName" in path, "`stepName` is a required path parameter"
  assert "targetId" in path, "`targetId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Sql/servers/"),
               (kind: VariableSegment, value: "serverName"),
               (kind: ConstantSegment, value: "/jobAgents/"),
               (kind: VariableSegment, value: "jobAgentName"),
               (kind: ConstantSegment, value: "/jobs/"),
               (kind: VariableSegment, value: "jobName"),
               (kind: ConstantSegment, value: "/executions/"),
               (kind: VariableSegment, value: "jobExecutionId"),
               (kind: ConstantSegment, value: "/steps/"),
               (kind: VariableSegment, value: "stepName"),
               (kind: ConstantSegment, value: "/targets/"),
               (kind: VariableSegment, value: "targetId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_JobTargetExecutionsGet_564392(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a target execution.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serverName: JString (required)
  ##             : The name of the server.
  ##   targetId: JString (required)
  ##           : The target id.
  ##   jobExecutionId: JString (required)
  ##                 : The unique id of the job execution
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   jobAgentName: JString (required)
  ##               : The name of the job agent.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   stepName: JString (required)
  ##           : The name of the step.
  ##   jobName: JString (required)
  ##          : The name of the job to get.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serverName` field"
  var valid_564394 = path.getOrDefault("serverName")
  valid_564394 = validateParameter(valid_564394, JString, required = true,
                                 default = nil)
  if valid_564394 != nil:
    section.add "serverName", valid_564394
  var valid_564395 = path.getOrDefault("targetId")
  valid_564395 = validateParameter(valid_564395, JString, required = true,
                                 default = nil)
  if valid_564395 != nil:
    section.add "targetId", valid_564395
  var valid_564396 = path.getOrDefault("jobExecutionId")
  valid_564396 = validateParameter(valid_564396, JString, required = true,
                                 default = nil)
  if valid_564396 != nil:
    section.add "jobExecutionId", valid_564396
  var valid_564397 = path.getOrDefault("subscriptionId")
  valid_564397 = validateParameter(valid_564397, JString, required = true,
                                 default = nil)
  if valid_564397 != nil:
    section.add "subscriptionId", valid_564397
  var valid_564398 = path.getOrDefault("jobAgentName")
  valid_564398 = validateParameter(valid_564398, JString, required = true,
                                 default = nil)
  if valid_564398 != nil:
    section.add "jobAgentName", valid_564398
  var valid_564399 = path.getOrDefault("resourceGroupName")
  valid_564399 = validateParameter(valid_564399, JString, required = true,
                                 default = nil)
  if valid_564399 != nil:
    section.add "resourceGroupName", valid_564399
  var valid_564400 = path.getOrDefault("stepName")
  valid_564400 = validateParameter(valid_564400, JString, required = true,
                                 default = nil)
  if valid_564400 != nil:
    section.add "stepName", valid_564400
  var valid_564401 = path.getOrDefault("jobName")
  valid_564401 = validateParameter(valid_564401, JString, required = true,
                                 default = nil)
  if valid_564401 != nil:
    section.add "jobName", valid_564401
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564402 = query.getOrDefault("api-version")
  valid_564402 = validateParameter(valid_564402, JString, required = true,
                                 default = nil)
  if valid_564402 != nil:
    section.add "api-version", valid_564402
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564403: Call_JobTargetExecutionsGet_564391; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a target execution.
  ## 
  let valid = call_564403.validator(path, query, header, formData, body)
  let scheme = call_564403.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564403.url(scheme.get, call_564403.host, call_564403.base,
                         call_564403.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564403, url, valid)

proc call*(call_564404: Call_JobTargetExecutionsGet_564391; apiVersion: string;
          serverName: string; targetId: string; jobExecutionId: string;
          subscriptionId: string; jobAgentName: string; resourceGroupName: string;
          stepName: string; jobName: string): Recallable =
  ## jobTargetExecutionsGet
  ## Gets a target execution.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   serverName: string (required)
  ##             : The name of the server.
  ##   targetId: string (required)
  ##           : The target id.
  ##   jobExecutionId: string (required)
  ##                 : The unique id of the job execution
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   jobAgentName: string (required)
  ##               : The name of the job agent.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   stepName: string (required)
  ##           : The name of the step.
  ##   jobName: string (required)
  ##          : The name of the job to get.
  var path_564405 = newJObject()
  var query_564406 = newJObject()
  add(query_564406, "api-version", newJString(apiVersion))
  add(path_564405, "serverName", newJString(serverName))
  add(path_564405, "targetId", newJString(targetId))
  add(path_564405, "jobExecutionId", newJString(jobExecutionId))
  add(path_564405, "subscriptionId", newJString(subscriptionId))
  add(path_564405, "jobAgentName", newJString(jobAgentName))
  add(path_564405, "resourceGroupName", newJString(resourceGroupName))
  add(path_564405, "stepName", newJString(stepName))
  add(path_564405, "jobName", newJString(jobName))
  result = call_564404.call(path_564405, query_564406, nil, nil, nil)

var jobTargetExecutionsGet* = Call_JobTargetExecutionsGet_564391(
    name: "jobTargetExecutionsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/servers/{serverName}/jobAgents/{jobAgentName}/jobs/{jobName}/executions/{jobExecutionId}/steps/{stepName}/targets/{targetId}",
    validator: validate_JobTargetExecutionsGet_564392, base: "",
    url: url_JobTargetExecutionsGet_564393, schemes: {Scheme.Https})
type
  Call_JobTargetExecutionsListByJobExecution_564407 = ref object of OpenApiRestCall_563555
proc url_JobTargetExecutionsListByJobExecution_564409(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serverName" in path, "`serverName` is a required path parameter"
  assert "jobAgentName" in path, "`jobAgentName` is a required path parameter"
  assert "jobName" in path, "`jobName` is a required path parameter"
  assert "jobExecutionId" in path, "`jobExecutionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Sql/servers/"),
               (kind: VariableSegment, value: "serverName"),
               (kind: ConstantSegment, value: "/jobAgents/"),
               (kind: VariableSegment, value: "jobAgentName"),
               (kind: ConstantSegment, value: "/jobs/"),
               (kind: VariableSegment, value: "jobName"),
               (kind: ConstantSegment, value: "/executions/"),
               (kind: VariableSegment, value: "jobExecutionId"),
               (kind: ConstantSegment, value: "/targets")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_JobTargetExecutionsListByJobExecution_564408(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists target executions for all steps of a job execution.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serverName: JString (required)
  ##             : The name of the server.
  ##   jobExecutionId: JString (required)
  ##                 : The id of the job execution
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   jobAgentName: JString (required)
  ##               : The name of the job agent.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   jobName: JString (required)
  ##          : The name of the job to get.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serverName` field"
  var valid_564410 = path.getOrDefault("serverName")
  valid_564410 = validateParameter(valid_564410, JString, required = true,
                                 default = nil)
  if valid_564410 != nil:
    section.add "serverName", valid_564410
  var valid_564411 = path.getOrDefault("jobExecutionId")
  valid_564411 = validateParameter(valid_564411, JString, required = true,
                                 default = nil)
  if valid_564411 != nil:
    section.add "jobExecutionId", valid_564411
  var valid_564412 = path.getOrDefault("subscriptionId")
  valid_564412 = validateParameter(valid_564412, JString, required = true,
                                 default = nil)
  if valid_564412 != nil:
    section.add "subscriptionId", valid_564412
  var valid_564413 = path.getOrDefault("jobAgentName")
  valid_564413 = validateParameter(valid_564413, JString, required = true,
                                 default = nil)
  if valid_564413 != nil:
    section.add "jobAgentName", valid_564413
  var valid_564414 = path.getOrDefault("resourceGroupName")
  valid_564414 = validateParameter(valid_564414, JString, required = true,
                                 default = nil)
  if valid_564414 != nil:
    section.add "resourceGroupName", valid_564414
  var valid_564415 = path.getOrDefault("jobName")
  valid_564415 = validateParameter(valid_564415, JString, required = true,
                                 default = nil)
  if valid_564415 != nil:
    section.add "jobName", valid_564415
  result.add "path", section
  ## parameters in `query` object:
  ##   $top: JInt
  ##       : The number of elements to return from the collection.
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  ##   endTimeMin: JString
  ##             : If specified, only job executions completed at or after the specified time are included.
  ##   isActive: JBool
  ##           : If specified, only active or only completed job executions are included.
  ##   createTimeMin: JString
  ##                : If specified, only job executions created at or after the specified time are included.
  ##   $skip: JInt
  ##        : The number of elements in the collection to skip.
  ##   createTimeMax: JString
  ##                : If specified, only job executions created before the specified time are included.
  ##   endTimeMax: JString
  ##             : If specified, only job executions completed before the specified time are included.
  section = newJObject()
  var valid_564416 = query.getOrDefault("$top")
  valid_564416 = validateParameter(valid_564416, JInt, required = false, default = nil)
  if valid_564416 != nil:
    section.add "$top", valid_564416
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564417 = query.getOrDefault("api-version")
  valid_564417 = validateParameter(valid_564417, JString, required = true,
                                 default = nil)
  if valid_564417 != nil:
    section.add "api-version", valid_564417
  var valid_564418 = query.getOrDefault("endTimeMin")
  valid_564418 = validateParameter(valid_564418, JString, required = false,
                                 default = nil)
  if valid_564418 != nil:
    section.add "endTimeMin", valid_564418
  var valid_564419 = query.getOrDefault("isActive")
  valid_564419 = validateParameter(valid_564419, JBool, required = false, default = nil)
  if valid_564419 != nil:
    section.add "isActive", valid_564419
  var valid_564420 = query.getOrDefault("createTimeMin")
  valid_564420 = validateParameter(valid_564420, JString, required = false,
                                 default = nil)
  if valid_564420 != nil:
    section.add "createTimeMin", valid_564420
  var valid_564421 = query.getOrDefault("$skip")
  valid_564421 = validateParameter(valid_564421, JInt, required = false, default = nil)
  if valid_564421 != nil:
    section.add "$skip", valid_564421
  var valid_564422 = query.getOrDefault("createTimeMax")
  valid_564422 = validateParameter(valid_564422, JString, required = false,
                                 default = nil)
  if valid_564422 != nil:
    section.add "createTimeMax", valid_564422
  var valid_564423 = query.getOrDefault("endTimeMax")
  valid_564423 = validateParameter(valid_564423, JString, required = false,
                                 default = nil)
  if valid_564423 != nil:
    section.add "endTimeMax", valid_564423
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564424: Call_JobTargetExecutionsListByJobExecution_564407;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists target executions for all steps of a job execution.
  ## 
  let valid = call_564424.validator(path, query, header, formData, body)
  let scheme = call_564424.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564424.url(scheme.get, call_564424.host, call_564424.base,
                         call_564424.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564424, url, valid)

proc call*(call_564425: Call_JobTargetExecutionsListByJobExecution_564407;
          apiVersion: string; serverName: string; jobExecutionId: string;
          subscriptionId: string; jobAgentName: string; resourceGroupName: string;
          jobName: string; Top: int = 0; endTimeMin: string = ""; isActive: bool = false;
          createTimeMin: string = ""; Skip: int = 0; createTimeMax: string = "";
          endTimeMax: string = ""): Recallable =
  ## jobTargetExecutionsListByJobExecution
  ## Lists target executions for all steps of a job execution.
  ##   Top: int
  ##      : The number of elements to return from the collection.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   endTimeMin: string
  ##             : If specified, only job executions completed at or after the specified time are included.
  ##   serverName: string (required)
  ##             : The name of the server.
  ##   isActive: bool
  ##           : If specified, only active or only completed job executions are included.
  ##   jobExecutionId: string (required)
  ##                 : The id of the job execution
  ##   createTimeMin: string
  ##                : If specified, only job executions created at or after the specified time are included.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   jobAgentName: string (required)
  ##               : The name of the job agent.
  ##   Skip: int
  ##       : The number of elements in the collection to skip.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   createTimeMax: string
  ##                : If specified, only job executions created before the specified time are included.
  ##   endTimeMax: string
  ##             : If specified, only job executions completed before the specified time are included.
  ##   jobName: string (required)
  ##          : The name of the job to get.
  var path_564426 = newJObject()
  var query_564427 = newJObject()
  add(query_564427, "$top", newJInt(Top))
  add(query_564427, "api-version", newJString(apiVersion))
  add(query_564427, "endTimeMin", newJString(endTimeMin))
  add(path_564426, "serverName", newJString(serverName))
  add(query_564427, "isActive", newJBool(isActive))
  add(path_564426, "jobExecutionId", newJString(jobExecutionId))
  add(query_564427, "createTimeMin", newJString(createTimeMin))
  add(path_564426, "subscriptionId", newJString(subscriptionId))
  add(path_564426, "jobAgentName", newJString(jobAgentName))
  add(query_564427, "$skip", newJInt(Skip))
  add(path_564426, "resourceGroupName", newJString(resourceGroupName))
  add(query_564427, "createTimeMax", newJString(createTimeMax))
  add(query_564427, "endTimeMax", newJString(endTimeMax))
  add(path_564426, "jobName", newJString(jobName))
  result = call_564425.call(path_564426, query_564427, nil, nil, nil)

var jobTargetExecutionsListByJobExecution* = Call_JobTargetExecutionsListByJobExecution_564407(
    name: "jobTargetExecutionsListByJobExecution", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/servers/{serverName}/jobAgents/{jobAgentName}/jobs/{jobName}/executions/{jobExecutionId}/targets",
    validator: validate_JobTargetExecutionsListByJobExecution_564408, base: "",
    url: url_JobTargetExecutionsListByJobExecution_564409, schemes: {Scheme.Https})
type
  Call_JobExecutionsCreate_564428 = ref object of OpenApiRestCall_563555
proc url_JobExecutionsCreate_564430(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serverName" in path, "`serverName` is a required path parameter"
  assert "jobAgentName" in path, "`jobAgentName` is a required path parameter"
  assert "jobName" in path, "`jobName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Sql/servers/"),
               (kind: VariableSegment, value: "serverName"),
               (kind: ConstantSegment, value: "/jobAgents/"),
               (kind: VariableSegment, value: "jobAgentName"),
               (kind: ConstantSegment, value: "/jobs/"),
               (kind: VariableSegment, value: "jobName"),
               (kind: ConstantSegment, value: "/start")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_JobExecutionsCreate_564429(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Starts an elastic job execution.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serverName: JString (required)
  ##             : The name of the server.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   jobAgentName: JString (required)
  ##               : The name of the job agent.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   jobName: JString (required)
  ##          : The name of the job to get.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serverName` field"
  var valid_564431 = path.getOrDefault("serverName")
  valid_564431 = validateParameter(valid_564431, JString, required = true,
                                 default = nil)
  if valid_564431 != nil:
    section.add "serverName", valid_564431
  var valid_564432 = path.getOrDefault("subscriptionId")
  valid_564432 = validateParameter(valid_564432, JString, required = true,
                                 default = nil)
  if valid_564432 != nil:
    section.add "subscriptionId", valid_564432
  var valid_564433 = path.getOrDefault("jobAgentName")
  valid_564433 = validateParameter(valid_564433, JString, required = true,
                                 default = nil)
  if valid_564433 != nil:
    section.add "jobAgentName", valid_564433
  var valid_564434 = path.getOrDefault("resourceGroupName")
  valid_564434 = validateParameter(valid_564434, JString, required = true,
                                 default = nil)
  if valid_564434 != nil:
    section.add "resourceGroupName", valid_564434
  var valid_564435 = path.getOrDefault("jobName")
  valid_564435 = validateParameter(valid_564435, JString, required = true,
                                 default = nil)
  if valid_564435 != nil:
    section.add "jobName", valid_564435
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564436 = query.getOrDefault("api-version")
  valid_564436 = validateParameter(valid_564436, JString, required = true,
                                 default = nil)
  if valid_564436 != nil:
    section.add "api-version", valid_564436
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564437: Call_JobExecutionsCreate_564428; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Starts an elastic job execution.
  ## 
  let valid = call_564437.validator(path, query, header, formData, body)
  let scheme = call_564437.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564437.url(scheme.get, call_564437.host, call_564437.base,
                         call_564437.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564437, url, valid)

proc call*(call_564438: Call_JobExecutionsCreate_564428; apiVersion: string;
          serverName: string; subscriptionId: string; jobAgentName: string;
          resourceGroupName: string; jobName: string): Recallable =
  ## jobExecutionsCreate
  ## Starts an elastic job execution.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   serverName: string (required)
  ##             : The name of the server.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   jobAgentName: string (required)
  ##               : The name of the job agent.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   jobName: string (required)
  ##          : The name of the job to get.
  var path_564439 = newJObject()
  var query_564440 = newJObject()
  add(query_564440, "api-version", newJString(apiVersion))
  add(path_564439, "serverName", newJString(serverName))
  add(path_564439, "subscriptionId", newJString(subscriptionId))
  add(path_564439, "jobAgentName", newJString(jobAgentName))
  add(path_564439, "resourceGroupName", newJString(resourceGroupName))
  add(path_564439, "jobName", newJString(jobName))
  result = call_564438.call(path_564439, query_564440, nil, nil, nil)

var jobExecutionsCreate* = Call_JobExecutionsCreate_564428(
    name: "jobExecutionsCreate", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/servers/{serverName}/jobAgents/{jobAgentName}/jobs/{jobName}/start",
    validator: validate_JobExecutionsCreate_564429, base: "",
    url: url_JobExecutionsCreate_564430, schemes: {Scheme.Https})
type
  Call_JobStepsListByJob_564441 = ref object of OpenApiRestCall_563555
proc url_JobStepsListByJob_564443(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serverName" in path, "`serverName` is a required path parameter"
  assert "jobAgentName" in path, "`jobAgentName` is a required path parameter"
  assert "jobName" in path, "`jobName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Sql/servers/"),
               (kind: VariableSegment, value: "serverName"),
               (kind: ConstantSegment, value: "/jobAgents/"),
               (kind: VariableSegment, value: "jobAgentName"),
               (kind: ConstantSegment, value: "/jobs/"),
               (kind: VariableSegment, value: "jobName"),
               (kind: ConstantSegment, value: "/steps")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_JobStepsListByJob_564442(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Gets all job steps for a job's current version.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serverName: JString (required)
  ##             : The name of the server.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   jobAgentName: JString (required)
  ##               : The name of the job agent.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   jobName: JString (required)
  ##          : The name of the job to get.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serverName` field"
  var valid_564444 = path.getOrDefault("serverName")
  valid_564444 = validateParameter(valid_564444, JString, required = true,
                                 default = nil)
  if valid_564444 != nil:
    section.add "serverName", valid_564444
  var valid_564445 = path.getOrDefault("subscriptionId")
  valid_564445 = validateParameter(valid_564445, JString, required = true,
                                 default = nil)
  if valid_564445 != nil:
    section.add "subscriptionId", valid_564445
  var valid_564446 = path.getOrDefault("jobAgentName")
  valid_564446 = validateParameter(valid_564446, JString, required = true,
                                 default = nil)
  if valid_564446 != nil:
    section.add "jobAgentName", valid_564446
  var valid_564447 = path.getOrDefault("resourceGroupName")
  valid_564447 = validateParameter(valid_564447, JString, required = true,
                                 default = nil)
  if valid_564447 != nil:
    section.add "resourceGroupName", valid_564447
  var valid_564448 = path.getOrDefault("jobName")
  valid_564448 = validateParameter(valid_564448, JString, required = true,
                                 default = nil)
  if valid_564448 != nil:
    section.add "jobName", valid_564448
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564449 = query.getOrDefault("api-version")
  valid_564449 = validateParameter(valid_564449, JString, required = true,
                                 default = nil)
  if valid_564449 != nil:
    section.add "api-version", valid_564449
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564450: Call_JobStepsListByJob_564441; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all job steps for a job's current version.
  ## 
  let valid = call_564450.validator(path, query, header, formData, body)
  let scheme = call_564450.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564450.url(scheme.get, call_564450.host, call_564450.base,
                         call_564450.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564450, url, valid)

proc call*(call_564451: Call_JobStepsListByJob_564441; apiVersion: string;
          serverName: string; subscriptionId: string; jobAgentName: string;
          resourceGroupName: string; jobName: string): Recallable =
  ## jobStepsListByJob
  ## Gets all job steps for a job's current version.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   serverName: string (required)
  ##             : The name of the server.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   jobAgentName: string (required)
  ##               : The name of the job agent.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   jobName: string (required)
  ##          : The name of the job to get.
  var path_564452 = newJObject()
  var query_564453 = newJObject()
  add(query_564453, "api-version", newJString(apiVersion))
  add(path_564452, "serverName", newJString(serverName))
  add(path_564452, "subscriptionId", newJString(subscriptionId))
  add(path_564452, "jobAgentName", newJString(jobAgentName))
  add(path_564452, "resourceGroupName", newJString(resourceGroupName))
  add(path_564452, "jobName", newJString(jobName))
  result = call_564451.call(path_564452, query_564453, nil, nil, nil)

var jobStepsListByJob* = Call_JobStepsListByJob_564441(name: "jobStepsListByJob",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/servers/{serverName}/jobAgents/{jobAgentName}/jobs/{jobName}/steps",
    validator: validate_JobStepsListByJob_564442, base: "",
    url: url_JobStepsListByJob_564443, schemes: {Scheme.Https})
type
  Call_JobStepsCreateOrUpdate_564468 = ref object of OpenApiRestCall_563555
proc url_JobStepsCreateOrUpdate_564470(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serverName" in path, "`serverName` is a required path parameter"
  assert "jobAgentName" in path, "`jobAgentName` is a required path parameter"
  assert "jobName" in path, "`jobName` is a required path parameter"
  assert "stepName" in path, "`stepName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Sql/servers/"),
               (kind: VariableSegment, value: "serverName"),
               (kind: ConstantSegment, value: "/jobAgents/"),
               (kind: VariableSegment, value: "jobAgentName"),
               (kind: ConstantSegment, value: "/jobs/"),
               (kind: VariableSegment, value: "jobName"),
               (kind: ConstantSegment, value: "/steps/"),
               (kind: VariableSegment, value: "stepName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_JobStepsCreateOrUpdate_564469(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates a job step. This will implicitly create a new job version.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serverName: JString (required)
  ##             : The name of the server.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   jobAgentName: JString (required)
  ##               : The name of the job agent.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   stepName: JString (required)
  ##           : The name of the job step.
  ##   jobName: JString (required)
  ##          : The name of the job.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serverName` field"
  var valid_564471 = path.getOrDefault("serverName")
  valid_564471 = validateParameter(valid_564471, JString, required = true,
                                 default = nil)
  if valid_564471 != nil:
    section.add "serverName", valid_564471
  var valid_564472 = path.getOrDefault("subscriptionId")
  valid_564472 = validateParameter(valid_564472, JString, required = true,
                                 default = nil)
  if valid_564472 != nil:
    section.add "subscriptionId", valid_564472
  var valid_564473 = path.getOrDefault("jobAgentName")
  valid_564473 = validateParameter(valid_564473, JString, required = true,
                                 default = nil)
  if valid_564473 != nil:
    section.add "jobAgentName", valid_564473
  var valid_564474 = path.getOrDefault("resourceGroupName")
  valid_564474 = validateParameter(valid_564474, JString, required = true,
                                 default = nil)
  if valid_564474 != nil:
    section.add "resourceGroupName", valid_564474
  var valid_564475 = path.getOrDefault("stepName")
  valid_564475 = validateParameter(valid_564475, JString, required = true,
                                 default = nil)
  if valid_564475 != nil:
    section.add "stepName", valid_564475
  var valid_564476 = path.getOrDefault("jobName")
  valid_564476 = validateParameter(valid_564476, JString, required = true,
                                 default = nil)
  if valid_564476 != nil:
    section.add "jobName", valid_564476
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564477 = query.getOrDefault("api-version")
  valid_564477 = validateParameter(valid_564477, JString, required = true,
                                 default = nil)
  if valid_564477 != nil:
    section.add "api-version", valid_564477
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The requested state of the job step.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564479: Call_JobStepsCreateOrUpdate_564468; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates a job step. This will implicitly create a new job version.
  ## 
  let valid = call_564479.validator(path, query, header, formData, body)
  let scheme = call_564479.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564479.url(scheme.get, call_564479.host, call_564479.base,
                         call_564479.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564479, url, valid)

proc call*(call_564480: Call_JobStepsCreateOrUpdate_564468; apiVersion: string;
          serverName: string; subscriptionId: string; jobAgentName: string;
          resourceGroupName: string; stepName: string; parameters: JsonNode;
          jobName: string): Recallable =
  ## jobStepsCreateOrUpdate
  ## Creates or updates a job step. This will implicitly create a new job version.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   serverName: string (required)
  ##             : The name of the server.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   jobAgentName: string (required)
  ##               : The name of the job agent.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   stepName: string (required)
  ##           : The name of the job step.
  ##   parameters: JObject (required)
  ##             : The requested state of the job step.
  ##   jobName: string (required)
  ##          : The name of the job.
  var path_564481 = newJObject()
  var query_564482 = newJObject()
  var body_564483 = newJObject()
  add(query_564482, "api-version", newJString(apiVersion))
  add(path_564481, "serverName", newJString(serverName))
  add(path_564481, "subscriptionId", newJString(subscriptionId))
  add(path_564481, "jobAgentName", newJString(jobAgentName))
  add(path_564481, "resourceGroupName", newJString(resourceGroupName))
  add(path_564481, "stepName", newJString(stepName))
  if parameters != nil:
    body_564483 = parameters
  add(path_564481, "jobName", newJString(jobName))
  result = call_564480.call(path_564481, query_564482, nil, nil, body_564483)

var jobStepsCreateOrUpdate* = Call_JobStepsCreateOrUpdate_564468(
    name: "jobStepsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/servers/{serverName}/jobAgents/{jobAgentName}/jobs/{jobName}/steps/{stepName}",
    validator: validate_JobStepsCreateOrUpdate_564469, base: "",
    url: url_JobStepsCreateOrUpdate_564470, schemes: {Scheme.Https})
type
  Call_JobStepsGet_564454 = ref object of OpenApiRestCall_563555
proc url_JobStepsGet_564456(protocol: Scheme; host: string; base: string;
                           route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serverName" in path, "`serverName` is a required path parameter"
  assert "jobAgentName" in path, "`jobAgentName` is a required path parameter"
  assert "jobName" in path, "`jobName` is a required path parameter"
  assert "stepName" in path, "`stepName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Sql/servers/"),
               (kind: VariableSegment, value: "serverName"),
               (kind: ConstantSegment, value: "/jobAgents/"),
               (kind: VariableSegment, value: "jobAgentName"),
               (kind: ConstantSegment, value: "/jobs/"),
               (kind: VariableSegment, value: "jobName"),
               (kind: ConstantSegment, value: "/steps/"),
               (kind: VariableSegment, value: "stepName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_JobStepsGet_564455(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a job step in a job's current version.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serverName: JString (required)
  ##             : The name of the server.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   jobAgentName: JString (required)
  ##               : The name of the job agent.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   stepName: JString (required)
  ##           : The name of the job step.
  ##   jobName: JString (required)
  ##          : The name of the job.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serverName` field"
  var valid_564457 = path.getOrDefault("serverName")
  valid_564457 = validateParameter(valid_564457, JString, required = true,
                                 default = nil)
  if valid_564457 != nil:
    section.add "serverName", valid_564457
  var valid_564458 = path.getOrDefault("subscriptionId")
  valid_564458 = validateParameter(valid_564458, JString, required = true,
                                 default = nil)
  if valid_564458 != nil:
    section.add "subscriptionId", valid_564458
  var valid_564459 = path.getOrDefault("jobAgentName")
  valid_564459 = validateParameter(valid_564459, JString, required = true,
                                 default = nil)
  if valid_564459 != nil:
    section.add "jobAgentName", valid_564459
  var valid_564460 = path.getOrDefault("resourceGroupName")
  valid_564460 = validateParameter(valid_564460, JString, required = true,
                                 default = nil)
  if valid_564460 != nil:
    section.add "resourceGroupName", valid_564460
  var valid_564461 = path.getOrDefault("stepName")
  valid_564461 = validateParameter(valid_564461, JString, required = true,
                                 default = nil)
  if valid_564461 != nil:
    section.add "stepName", valid_564461
  var valid_564462 = path.getOrDefault("jobName")
  valid_564462 = validateParameter(valid_564462, JString, required = true,
                                 default = nil)
  if valid_564462 != nil:
    section.add "jobName", valid_564462
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564463 = query.getOrDefault("api-version")
  valid_564463 = validateParameter(valid_564463, JString, required = true,
                                 default = nil)
  if valid_564463 != nil:
    section.add "api-version", valid_564463
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564464: Call_JobStepsGet_564454; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a job step in a job's current version.
  ## 
  let valid = call_564464.validator(path, query, header, formData, body)
  let scheme = call_564464.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564464.url(scheme.get, call_564464.host, call_564464.base,
                         call_564464.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564464, url, valid)

proc call*(call_564465: Call_JobStepsGet_564454; apiVersion: string;
          serverName: string; subscriptionId: string; jobAgentName: string;
          resourceGroupName: string; stepName: string; jobName: string): Recallable =
  ## jobStepsGet
  ## Gets a job step in a job's current version.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   serverName: string (required)
  ##             : The name of the server.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   jobAgentName: string (required)
  ##               : The name of the job agent.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   stepName: string (required)
  ##           : The name of the job step.
  ##   jobName: string (required)
  ##          : The name of the job.
  var path_564466 = newJObject()
  var query_564467 = newJObject()
  add(query_564467, "api-version", newJString(apiVersion))
  add(path_564466, "serverName", newJString(serverName))
  add(path_564466, "subscriptionId", newJString(subscriptionId))
  add(path_564466, "jobAgentName", newJString(jobAgentName))
  add(path_564466, "resourceGroupName", newJString(resourceGroupName))
  add(path_564466, "stepName", newJString(stepName))
  add(path_564466, "jobName", newJString(jobName))
  result = call_564465.call(path_564466, query_564467, nil, nil, nil)

var jobStepsGet* = Call_JobStepsGet_564454(name: "jobStepsGet",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/servers/{serverName}/jobAgents/{jobAgentName}/jobs/{jobName}/steps/{stepName}",
                                        validator: validate_JobStepsGet_564455,
                                        base: "", url: url_JobStepsGet_564456,
                                        schemes: {Scheme.Https})
type
  Call_JobStepsDelete_564484 = ref object of OpenApiRestCall_563555
proc url_JobStepsDelete_564486(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serverName" in path, "`serverName` is a required path parameter"
  assert "jobAgentName" in path, "`jobAgentName` is a required path parameter"
  assert "jobName" in path, "`jobName` is a required path parameter"
  assert "stepName" in path, "`stepName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Sql/servers/"),
               (kind: VariableSegment, value: "serverName"),
               (kind: ConstantSegment, value: "/jobAgents/"),
               (kind: VariableSegment, value: "jobAgentName"),
               (kind: ConstantSegment, value: "/jobs/"),
               (kind: VariableSegment, value: "jobName"),
               (kind: ConstantSegment, value: "/steps/"),
               (kind: VariableSegment, value: "stepName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_JobStepsDelete_564485(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Deletes a job step. This will implicitly create a new job version.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serverName: JString (required)
  ##             : The name of the server.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   jobAgentName: JString (required)
  ##               : The name of the job agent.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   stepName: JString (required)
  ##           : The name of the job step to delete.
  ##   jobName: JString (required)
  ##          : The name of the job.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serverName` field"
  var valid_564487 = path.getOrDefault("serverName")
  valid_564487 = validateParameter(valid_564487, JString, required = true,
                                 default = nil)
  if valid_564487 != nil:
    section.add "serverName", valid_564487
  var valid_564488 = path.getOrDefault("subscriptionId")
  valid_564488 = validateParameter(valid_564488, JString, required = true,
                                 default = nil)
  if valid_564488 != nil:
    section.add "subscriptionId", valid_564488
  var valid_564489 = path.getOrDefault("jobAgentName")
  valid_564489 = validateParameter(valid_564489, JString, required = true,
                                 default = nil)
  if valid_564489 != nil:
    section.add "jobAgentName", valid_564489
  var valid_564490 = path.getOrDefault("resourceGroupName")
  valid_564490 = validateParameter(valid_564490, JString, required = true,
                                 default = nil)
  if valid_564490 != nil:
    section.add "resourceGroupName", valid_564490
  var valid_564491 = path.getOrDefault("stepName")
  valid_564491 = validateParameter(valid_564491, JString, required = true,
                                 default = nil)
  if valid_564491 != nil:
    section.add "stepName", valid_564491
  var valid_564492 = path.getOrDefault("jobName")
  valid_564492 = validateParameter(valid_564492, JString, required = true,
                                 default = nil)
  if valid_564492 != nil:
    section.add "jobName", valid_564492
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564493 = query.getOrDefault("api-version")
  valid_564493 = validateParameter(valid_564493, JString, required = true,
                                 default = nil)
  if valid_564493 != nil:
    section.add "api-version", valid_564493
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564494: Call_JobStepsDelete_564484; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a job step. This will implicitly create a new job version.
  ## 
  let valid = call_564494.validator(path, query, header, formData, body)
  let scheme = call_564494.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564494.url(scheme.get, call_564494.host, call_564494.base,
                         call_564494.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564494, url, valid)

proc call*(call_564495: Call_JobStepsDelete_564484; apiVersion: string;
          serverName: string; subscriptionId: string; jobAgentName: string;
          resourceGroupName: string; stepName: string; jobName: string): Recallable =
  ## jobStepsDelete
  ## Deletes a job step. This will implicitly create a new job version.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   serverName: string (required)
  ##             : The name of the server.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   jobAgentName: string (required)
  ##               : The name of the job agent.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   stepName: string (required)
  ##           : The name of the job step to delete.
  ##   jobName: string (required)
  ##          : The name of the job.
  var path_564496 = newJObject()
  var query_564497 = newJObject()
  add(query_564497, "api-version", newJString(apiVersion))
  add(path_564496, "serverName", newJString(serverName))
  add(path_564496, "subscriptionId", newJString(subscriptionId))
  add(path_564496, "jobAgentName", newJString(jobAgentName))
  add(path_564496, "resourceGroupName", newJString(resourceGroupName))
  add(path_564496, "stepName", newJString(stepName))
  add(path_564496, "jobName", newJString(jobName))
  result = call_564495.call(path_564496, query_564497, nil, nil, nil)

var jobStepsDelete* = Call_JobStepsDelete_564484(name: "jobStepsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/servers/{serverName}/jobAgents/{jobAgentName}/jobs/{jobName}/steps/{stepName}",
    validator: validate_JobStepsDelete_564485, base: "", url: url_JobStepsDelete_564486,
    schemes: {Scheme.Https})
type
  Call_JobVersionsListByJob_564498 = ref object of OpenApiRestCall_563555
proc url_JobVersionsListByJob_564500(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serverName" in path, "`serverName` is a required path parameter"
  assert "jobAgentName" in path, "`jobAgentName` is a required path parameter"
  assert "jobName" in path, "`jobName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Sql/servers/"),
               (kind: VariableSegment, value: "serverName"),
               (kind: ConstantSegment, value: "/jobAgents/"),
               (kind: VariableSegment, value: "jobAgentName"),
               (kind: ConstantSegment, value: "/jobs/"),
               (kind: VariableSegment, value: "jobName"),
               (kind: ConstantSegment, value: "/versions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_JobVersionsListByJob_564499(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all versions of a job.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serverName: JString (required)
  ##             : The name of the server.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   jobAgentName: JString (required)
  ##               : The name of the job agent.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   jobName: JString (required)
  ##          : The name of the job to get.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serverName` field"
  var valid_564501 = path.getOrDefault("serverName")
  valid_564501 = validateParameter(valid_564501, JString, required = true,
                                 default = nil)
  if valid_564501 != nil:
    section.add "serverName", valid_564501
  var valid_564502 = path.getOrDefault("subscriptionId")
  valid_564502 = validateParameter(valid_564502, JString, required = true,
                                 default = nil)
  if valid_564502 != nil:
    section.add "subscriptionId", valid_564502
  var valid_564503 = path.getOrDefault("jobAgentName")
  valid_564503 = validateParameter(valid_564503, JString, required = true,
                                 default = nil)
  if valid_564503 != nil:
    section.add "jobAgentName", valid_564503
  var valid_564504 = path.getOrDefault("resourceGroupName")
  valid_564504 = validateParameter(valid_564504, JString, required = true,
                                 default = nil)
  if valid_564504 != nil:
    section.add "resourceGroupName", valid_564504
  var valid_564505 = path.getOrDefault("jobName")
  valid_564505 = validateParameter(valid_564505, JString, required = true,
                                 default = nil)
  if valid_564505 != nil:
    section.add "jobName", valid_564505
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564506 = query.getOrDefault("api-version")
  valid_564506 = validateParameter(valid_564506, JString, required = true,
                                 default = nil)
  if valid_564506 != nil:
    section.add "api-version", valid_564506
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564507: Call_JobVersionsListByJob_564498; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all versions of a job.
  ## 
  let valid = call_564507.validator(path, query, header, formData, body)
  let scheme = call_564507.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564507.url(scheme.get, call_564507.host, call_564507.base,
                         call_564507.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564507, url, valid)

proc call*(call_564508: Call_JobVersionsListByJob_564498; apiVersion: string;
          serverName: string; subscriptionId: string; jobAgentName: string;
          resourceGroupName: string; jobName: string): Recallable =
  ## jobVersionsListByJob
  ## Gets all versions of a job.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   serverName: string (required)
  ##             : The name of the server.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   jobAgentName: string (required)
  ##               : The name of the job agent.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   jobName: string (required)
  ##          : The name of the job to get.
  var path_564509 = newJObject()
  var query_564510 = newJObject()
  add(query_564510, "api-version", newJString(apiVersion))
  add(path_564509, "serverName", newJString(serverName))
  add(path_564509, "subscriptionId", newJString(subscriptionId))
  add(path_564509, "jobAgentName", newJString(jobAgentName))
  add(path_564509, "resourceGroupName", newJString(resourceGroupName))
  add(path_564509, "jobName", newJString(jobName))
  result = call_564508.call(path_564509, query_564510, nil, nil, nil)

var jobVersionsListByJob* = Call_JobVersionsListByJob_564498(
    name: "jobVersionsListByJob", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/servers/{serverName}/jobAgents/{jobAgentName}/jobs/{jobName}/versions",
    validator: validate_JobVersionsListByJob_564499, base: "",
    url: url_JobVersionsListByJob_564500, schemes: {Scheme.Https})
type
  Call_JobVersionsGet_564511 = ref object of OpenApiRestCall_563555
proc url_JobVersionsGet_564513(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serverName" in path, "`serverName` is a required path parameter"
  assert "jobAgentName" in path, "`jobAgentName` is a required path parameter"
  assert "jobName" in path, "`jobName` is a required path parameter"
  assert "jobVersion" in path, "`jobVersion` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Sql/servers/"),
               (kind: VariableSegment, value: "serverName"),
               (kind: ConstantSegment, value: "/jobAgents/"),
               (kind: VariableSegment, value: "jobAgentName"),
               (kind: ConstantSegment, value: "/jobs/"),
               (kind: VariableSegment, value: "jobName"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "jobVersion")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_JobVersionsGet_564512(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Gets a job version.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serverName: JString (required)
  ##             : The name of the server.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   jobVersion: JInt (required)
  ##             : The version of the job to get.
  ##   jobAgentName: JString (required)
  ##               : The name of the job agent.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   jobName: JString (required)
  ##          : The name of the job.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serverName` field"
  var valid_564514 = path.getOrDefault("serverName")
  valid_564514 = validateParameter(valid_564514, JString, required = true,
                                 default = nil)
  if valid_564514 != nil:
    section.add "serverName", valid_564514
  var valid_564515 = path.getOrDefault("subscriptionId")
  valid_564515 = validateParameter(valid_564515, JString, required = true,
                                 default = nil)
  if valid_564515 != nil:
    section.add "subscriptionId", valid_564515
  var valid_564516 = path.getOrDefault("jobVersion")
  valid_564516 = validateParameter(valid_564516, JInt, required = true, default = nil)
  if valid_564516 != nil:
    section.add "jobVersion", valid_564516
  var valid_564517 = path.getOrDefault("jobAgentName")
  valid_564517 = validateParameter(valid_564517, JString, required = true,
                                 default = nil)
  if valid_564517 != nil:
    section.add "jobAgentName", valid_564517
  var valid_564518 = path.getOrDefault("resourceGroupName")
  valid_564518 = validateParameter(valid_564518, JString, required = true,
                                 default = nil)
  if valid_564518 != nil:
    section.add "resourceGroupName", valid_564518
  var valid_564519 = path.getOrDefault("jobName")
  valid_564519 = validateParameter(valid_564519, JString, required = true,
                                 default = nil)
  if valid_564519 != nil:
    section.add "jobName", valid_564519
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564520 = query.getOrDefault("api-version")
  valid_564520 = validateParameter(valid_564520, JString, required = true,
                                 default = nil)
  if valid_564520 != nil:
    section.add "api-version", valid_564520
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564521: Call_JobVersionsGet_564511; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a job version.
  ## 
  let valid = call_564521.validator(path, query, header, formData, body)
  let scheme = call_564521.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564521.url(scheme.get, call_564521.host, call_564521.base,
                         call_564521.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564521, url, valid)

proc call*(call_564522: Call_JobVersionsGet_564511; apiVersion: string;
          serverName: string; subscriptionId: string; jobVersion: int;
          jobAgentName: string; resourceGroupName: string; jobName: string): Recallable =
  ## jobVersionsGet
  ## Gets a job version.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   serverName: string (required)
  ##             : The name of the server.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   jobVersion: int (required)
  ##             : The version of the job to get.
  ##   jobAgentName: string (required)
  ##               : The name of the job agent.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   jobName: string (required)
  ##          : The name of the job.
  var path_564523 = newJObject()
  var query_564524 = newJObject()
  add(query_564524, "api-version", newJString(apiVersion))
  add(path_564523, "serverName", newJString(serverName))
  add(path_564523, "subscriptionId", newJString(subscriptionId))
  add(path_564523, "jobVersion", newJInt(jobVersion))
  add(path_564523, "jobAgentName", newJString(jobAgentName))
  add(path_564523, "resourceGroupName", newJString(resourceGroupName))
  add(path_564523, "jobName", newJString(jobName))
  result = call_564522.call(path_564523, query_564524, nil, nil, nil)

var jobVersionsGet* = Call_JobVersionsGet_564511(name: "jobVersionsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/servers/{serverName}/jobAgents/{jobAgentName}/jobs/{jobName}/versions/{jobVersion}",
    validator: validate_JobVersionsGet_564512, base: "", url: url_JobVersionsGet_564513,
    schemes: {Scheme.Https})
type
  Call_JobStepsListByVersion_564525 = ref object of OpenApiRestCall_563555
proc url_JobStepsListByVersion_564527(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serverName" in path, "`serverName` is a required path parameter"
  assert "jobAgentName" in path, "`jobAgentName` is a required path parameter"
  assert "jobName" in path, "`jobName` is a required path parameter"
  assert "jobVersion" in path, "`jobVersion` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Sql/servers/"),
               (kind: VariableSegment, value: "serverName"),
               (kind: ConstantSegment, value: "/jobAgents/"),
               (kind: VariableSegment, value: "jobAgentName"),
               (kind: ConstantSegment, value: "/jobs/"),
               (kind: VariableSegment, value: "jobName"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "jobVersion"),
               (kind: ConstantSegment, value: "/steps")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_JobStepsListByVersion_564526(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all job steps in the specified job version.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serverName: JString (required)
  ##             : The name of the server.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   jobVersion: JInt (required)
  ##             : The version of the job to get.
  ##   jobAgentName: JString (required)
  ##               : The name of the job agent.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   jobName: JString (required)
  ##          : The name of the job to get.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serverName` field"
  var valid_564528 = path.getOrDefault("serverName")
  valid_564528 = validateParameter(valid_564528, JString, required = true,
                                 default = nil)
  if valid_564528 != nil:
    section.add "serverName", valid_564528
  var valid_564529 = path.getOrDefault("subscriptionId")
  valid_564529 = validateParameter(valid_564529, JString, required = true,
                                 default = nil)
  if valid_564529 != nil:
    section.add "subscriptionId", valid_564529
  var valid_564530 = path.getOrDefault("jobVersion")
  valid_564530 = validateParameter(valid_564530, JInt, required = true, default = nil)
  if valid_564530 != nil:
    section.add "jobVersion", valid_564530
  var valid_564531 = path.getOrDefault("jobAgentName")
  valid_564531 = validateParameter(valid_564531, JString, required = true,
                                 default = nil)
  if valid_564531 != nil:
    section.add "jobAgentName", valid_564531
  var valid_564532 = path.getOrDefault("resourceGroupName")
  valid_564532 = validateParameter(valid_564532, JString, required = true,
                                 default = nil)
  if valid_564532 != nil:
    section.add "resourceGroupName", valid_564532
  var valid_564533 = path.getOrDefault("jobName")
  valid_564533 = validateParameter(valid_564533, JString, required = true,
                                 default = nil)
  if valid_564533 != nil:
    section.add "jobName", valid_564533
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564534 = query.getOrDefault("api-version")
  valid_564534 = validateParameter(valid_564534, JString, required = true,
                                 default = nil)
  if valid_564534 != nil:
    section.add "api-version", valid_564534
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564535: Call_JobStepsListByVersion_564525; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all job steps in the specified job version.
  ## 
  let valid = call_564535.validator(path, query, header, formData, body)
  let scheme = call_564535.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564535.url(scheme.get, call_564535.host, call_564535.base,
                         call_564535.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564535, url, valid)

proc call*(call_564536: Call_JobStepsListByVersion_564525; apiVersion: string;
          serverName: string; subscriptionId: string; jobVersion: int;
          jobAgentName: string; resourceGroupName: string; jobName: string): Recallable =
  ## jobStepsListByVersion
  ## Gets all job steps in the specified job version.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   serverName: string (required)
  ##             : The name of the server.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   jobVersion: int (required)
  ##             : The version of the job to get.
  ##   jobAgentName: string (required)
  ##               : The name of the job agent.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   jobName: string (required)
  ##          : The name of the job to get.
  var path_564537 = newJObject()
  var query_564538 = newJObject()
  add(query_564538, "api-version", newJString(apiVersion))
  add(path_564537, "serverName", newJString(serverName))
  add(path_564537, "subscriptionId", newJString(subscriptionId))
  add(path_564537, "jobVersion", newJInt(jobVersion))
  add(path_564537, "jobAgentName", newJString(jobAgentName))
  add(path_564537, "resourceGroupName", newJString(resourceGroupName))
  add(path_564537, "jobName", newJString(jobName))
  result = call_564536.call(path_564537, query_564538, nil, nil, nil)

var jobStepsListByVersion* = Call_JobStepsListByVersion_564525(
    name: "jobStepsListByVersion", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/servers/{serverName}/jobAgents/{jobAgentName}/jobs/{jobName}/versions/{jobVersion}/steps",
    validator: validate_JobStepsListByVersion_564526, base: "",
    url: url_JobStepsListByVersion_564527, schemes: {Scheme.Https})
type
  Call_JobStepsGetByVersion_564539 = ref object of OpenApiRestCall_563555
proc url_JobStepsGetByVersion_564541(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serverName" in path, "`serverName` is a required path parameter"
  assert "jobAgentName" in path, "`jobAgentName` is a required path parameter"
  assert "jobName" in path, "`jobName` is a required path parameter"
  assert "jobVersion" in path, "`jobVersion` is a required path parameter"
  assert "stepName" in path, "`stepName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Sql/servers/"),
               (kind: VariableSegment, value: "serverName"),
               (kind: ConstantSegment, value: "/jobAgents/"),
               (kind: VariableSegment, value: "jobAgentName"),
               (kind: ConstantSegment, value: "/jobs/"),
               (kind: VariableSegment, value: "jobName"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "jobVersion"),
               (kind: ConstantSegment, value: "/steps/"),
               (kind: VariableSegment, value: "stepName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_JobStepsGetByVersion_564540(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the specified version of a job step.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serverName: JString (required)
  ##             : The name of the server.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   jobVersion: JInt (required)
  ##             : The version of the job to get.
  ##   jobAgentName: JString (required)
  ##               : The name of the job agent.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   stepName: JString (required)
  ##           : The name of the job step.
  ##   jobName: JString (required)
  ##          : The name of the job.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serverName` field"
  var valid_564542 = path.getOrDefault("serverName")
  valid_564542 = validateParameter(valid_564542, JString, required = true,
                                 default = nil)
  if valid_564542 != nil:
    section.add "serverName", valid_564542
  var valid_564543 = path.getOrDefault("subscriptionId")
  valid_564543 = validateParameter(valid_564543, JString, required = true,
                                 default = nil)
  if valid_564543 != nil:
    section.add "subscriptionId", valid_564543
  var valid_564544 = path.getOrDefault("jobVersion")
  valid_564544 = validateParameter(valid_564544, JInt, required = true, default = nil)
  if valid_564544 != nil:
    section.add "jobVersion", valid_564544
  var valid_564545 = path.getOrDefault("jobAgentName")
  valid_564545 = validateParameter(valid_564545, JString, required = true,
                                 default = nil)
  if valid_564545 != nil:
    section.add "jobAgentName", valid_564545
  var valid_564546 = path.getOrDefault("resourceGroupName")
  valid_564546 = validateParameter(valid_564546, JString, required = true,
                                 default = nil)
  if valid_564546 != nil:
    section.add "resourceGroupName", valid_564546
  var valid_564547 = path.getOrDefault("stepName")
  valid_564547 = validateParameter(valid_564547, JString, required = true,
                                 default = nil)
  if valid_564547 != nil:
    section.add "stepName", valid_564547
  var valid_564548 = path.getOrDefault("jobName")
  valid_564548 = validateParameter(valid_564548, JString, required = true,
                                 default = nil)
  if valid_564548 != nil:
    section.add "jobName", valid_564548
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564549 = query.getOrDefault("api-version")
  valid_564549 = validateParameter(valid_564549, JString, required = true,
                                 default = nil)
  if valid_564549 != nil:
    section.add "api-version", valid_564549
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564550: Call_JobStepsGetByVersion_564539; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the specified version of a job step.
  ## 
  let valid = call_564550.validator(path, query, header, formData, body)
  let scheme = call_564550.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564550.url(scheme.get, call_564550.host, call_564550.base,
                         call_564550.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564550, url, valid)

proc call*(call_564551: Call_JobStepsGetByVersion_564539; apiVersion: string;
          serverName: string; subscriptionId: string; jobVersion: int;
          jobAgentName: string; resourceGroupName: string; stepName: string;
          jobName: string): Recallable =
  ## jobStepsGetByVersion
  ## Gets the specified version of a job step.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   serverName: string (required)
  ##             : The name of the server.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   jobVersion: int (required)
  ##             : The version of the job to get.
  ##   jobAgentName: string (required)
  ##               : The name of the job agent.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   stepName: string (required)
  ##           : The name of the job step.
  ##   jobName: string (required)
  ##          : The name of the job.
  var path_564552 = newJObject()
  var query_564553 = newJObject()
  add(query_564553, "api-version", newJString(apiVersion))
  add(path_564552, "serverName", newJString(serverName))
  add(path_564552, "subscriptionId", newJString(subscriptionId))
  add(path_564552, "jobVersion", newJInt(jobVersion))
  add(path_564552, "jobAgentName", newJString(jobAgentName))
  add(path_564552, "resourceGroupName", newJString(resourceGroupName))
  add(path_564552, "stepName", newJString(stepName))
  add(path_564552, "jobName", newJString(jobName))
  result = call_564551.call(path_564552, query_564553, nil, nil, nil)

var jobStepsGetByVersion* = Call_JobStepsGetByVersion_564539(
    name: "jobStepsGetByVersion", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/servers/{serverName}/jobAgents/{jobAgentName}/jobs/{jobName}/versions/{jobVersion}/steps/{stepName}",
    validator: validate_JobStepsGetByVersion_564540, base: "",
    url: url_JobStepsGetByVersion_564541, schemes: {Scheme.Https})
type
  Call_JobTargetGroupsListByAgent_564554 = ref object of OpenApiRestCall_563555
proc url_JobTargetGroupsListByAgent_564556(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serverName" in path, "`serverName` is a required path parameter"
  assert "jobAgentName" in path, "`jobAgentName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Sql/servers/"),
               (kind: VariableSegment, value: "serverName"),
               (kind: ConstantSegment, value: "/jobAgents/"),
               (kind: VariableSegment, value: "jobAgentName"),
               (kind: ConstantSegment, value: "/targetGroups")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_JobTargetGroupsListByAgent_564555(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all target groups in an agent.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serverName: JString (required)
  ##             : The name of the server.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   jobAgentName: JString (required)
  ##               : The name of the job agent.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serverName` field"
  var valid_564557 = path.getOrDefault("serverName")
  valid_564557 = validateParameter(valid_564557, JString, required = true,
                                 default = nil)
  if valid_564557 != nil:
    section.add "serverName", valid_564557
  var valid_564558 = path.getOrDefault("subscriptionId")
  valid_564558 = validateParameter(valid_564558, JString, required = true,
                                 default = nil)
  if valid_564558 != nil:
    section.add "subscriptionId", valid_564558
  var valid_564559 = path.getOrDefault("jobAgentName")
  valid_564559 = validateParameter(valid_564559, JString, required = true,
                                 default = nil)
  if valid_564559 != nil:
    section.add "jobAgentName", valid_564559
  var valid_564560 = path.getOrDefault("resourceGroupName")
  valid_564560 = validateParameter(valid_564560, JString, required = true,
                                 default = nil)
  if valid_564560 != nil:
    section.add "resourceGroupName", valid_564560
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564561 = query.getOrDefault("api-version")
  valid_564561 = validateParameter(valid_564561, JString, required = true,
                                 default = nil)
  if valid_564561 != nil:
    section.add "api-version", valid_564561
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564562: Call_JobTargetGroupsListByAgent_564554; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all target groups in an agent.
  ## 
  let valid = call_564562.validator(path, query, header, formData, body)
  let scheme = call_564562.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564562.url(scheme.get, call_564562.host, call_564562.base,
                         call_564562.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564562, url, valid)

proc call*(call_564563: Call_JobTargetGroupsListByAgent_564554; apiVersion: string;
          serverName: string; subscriptionId: string; jobAgentName: string;
          resourceGroupName: string): Recallable =
  ## jobTargetGroupsListByAgent
  ## Gets all target groups in an agent.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   serverName: string (required)
  ##             : The name of the server.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   jobAgentName: string (required)
  ##               : The name of the job agent.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  var path_564564 = newJObject()
  var query_564565 = newJObject()
  add(query_564565, "api-version", newJString(apiVersion))
  add(path_564564, "serverName", newJString(serverName))
  add(path_564564, "subscriptionId", newJString(subscriptionId))
  add(path_564564, "jobAgentName", newJString(jobAgentName))
  add(path_564564, "resourceGroupName", newJString(resourceGroupName))
  result = call_564563.call(path_564564, query_564565, nil, nil, nil)

var jobTargetGroupsListByAgent* = Call_JobTargetGroupsListByAgent_564554(
    name: "jobTargetGroupsListByAgent", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/servers/{serverName}/jobAgents/{jobAgentName}/targetGroups",
    validator: validate_JobTargetGroupsListByAgent_564555, base: "",
    url: url_JobTargetGroupsListByAgent_564556, schemes: {Scheme.Https})
type
  Call_JobTargetGroupsCreateOrUpdate_564579 = ref object of OpenApiRestCall_563555
proc url_JobTargetGroupsCreateOrUpdate_564581(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serverName" in path, "`serverName` is a required path parameter"
  assert "jobAgentName" in path, "`jobAgentName` is a required path parameter"
  assert "targetGroupName" in path, "`targetGroupName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Sql/servers/"),
               (kind: VariableSegment, value: "serverName"),
               (kind: ConstantSegment, value: "/jobAgents/"),
               (kind: VariableSegment, value: "jobAgentName"),
               (kind: ConstantSegment, value: "/targetGroups/"),
               (kind: VariableSegment, value: "targetGroupName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_JobTargetGroupsCreateOrUpdate_564580(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates a target group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serverName: JString (required)
  ##             : The name of the server.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   jobAgentName: JString (required)
  ##               : The name of the job agent.
  ##   targetGroupName: JString (required)
  ##                  : The name of the target group.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serverName` field"
  var valid_564582 = path.getOrDefault("serverName")
  valid_564582 = validateParameter(valid_564582, JString, required = true,
                                 default = nil)
  if valid_564582 != nil:
    section.add "serverName", valid_564582
  var valid_564583 = path.getOrDefault("subscriptionId")
  valid_564583 = validateParameter(valid_564583, JString, required = true,
                                 default = nil)
  if valid_564583 != nil:
    section.add "subscriptionId", valid_564583
  var valid_564584 = path.getOrDefault("jobAgentName")
  valid_564584 = validateParameter(valid_564584, JString, required = true,
                                 default = nil)
  if valid_564584 != nil:
    section.add "jobAgentName", valid_564584
  var valid_564585 = path.getOrDefault("targetGroupName")
  valid_564585 = validateParameter(valid_564585, JString, required = true,
                                 default = nil)
  if valid_564585 != nil:
    section.add "targetGroupName", valid_564585
  var valid_564586 = path.getOrDefault("resourceGroupName")
  valid_564586 = validateParameter(valid_564586, JString, required = true,
                                 default = nil)
  if valid_564586 != nil:
    section.add "resourceGroupName", valid_564586
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564587 = query.getOrDefault("api-version")
  valid_564587 = validateParameter(valid_564587, JString, required = true,
                                 default = nil)
  if valid_564587 != nil:
    section.add "api-version", valid_564587
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The requested state of the target group.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564589: Call_JobTargetGroupsCreateOrUpdate_564579; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates a target group.
  ## 
  let valid = call_564589.validator(path, query, header, formData, body)
  let scheme = call_564589.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564589.url(scheme.get, call_564589.host, call_564589.base,
                         call_564589.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564589, url, valid)

proc call*(call_564590: Call_JobTargetGroupsCreateOrUpdate_564579;
          apiVersion: string; serverName: string; subscriptionId: string;
          jobAgentName: string; targetGroupName: string; resourceGroupName: string;
          parameters: JsonNode): Recallable =
  ## jobTargetGroupsCreateOrUpdate
  ## Creates or updates a target group.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   serverName: string (required)
  ##             : The name of the server.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   jobAgentName: string (required)
  ##               : The name of the job agent.
  ##   targetGroupName: string (required)
  ##                  : The name of the target group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   parameters: JObject (required)
  ##             : The requested state of the target group.
  var path_564591 = newJObject()
  var query_564592 = newJObject()
  var body_564593 = newJObject()
  add(query_564592, "api-version", newJString(apiVersion))
  add(path_564591, "serverName", newJString(serverName))
  add(path_564591, "subscriptionId", newJString(subscriptionId))
  add(path_564591, "jobAgentName", newJString(jobAgentName))
  add(path_564591, "targetGroupName", newJString(targetGroupName))
  add(path_564591, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564593 = parameters
  result = call_564590.call(path_564591, query_564592, nil, nil, body_564593)

var jobTargetGroupsCreateOrUpdate* = Call_JobTargetGroupsCreateOrUpdate_564579(
    name: "jobTargetGroupsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/servers/{serverName}/jobAgents/{jobAgentName}/targetGroups/{targetGroupName}",
    validator: validate_JobTargetGroupsCreateOrUpdate_564580, base: "",
    url: url_JobTargetGroupsCreateOrUpdate_564581, schemes: {Scheme.Https})
type
  Call_JobTargetGroupsGet_564566 = ref object of OpenApiRestCall_563555
proc url_JobTargetGroupsGet_564568(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serverName" in path, "`serverName` is a required path parameter"
  assert "jobAgentName" in path, "`jobAgentName` is a required path parameter"
  assert "targetGroupName" in path, "`targetGroupName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Sql/servers/"),
               (kind: VariableSegment, value: "serverName"),
               (kind: ConstantSegment, value: "/jobAgents/"),
               (kind: VariableSegment, value: "jobAgentName"),
               (kind: ConstantSegment, value: "/targetGroups/"),
               (kind: VariableSegment, value: "targetGroupName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_JobTargetGroupsGet_564567(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Gets a target group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serverName: JString (required)
  ##             : The name of the server.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   jobAgentName: JString (required)
  ##               : The name of the job agent.
  ##   targetGroupName: JString (required)
  ##                  : The name of the target group.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serverName` field"
  var valid_564569 = path.getOrDefault("serverName")
  valid_564569 = validateParameter(valid_564569, JString, required = true,
                                 default = nil)
  if valid_564569 != nil:
    section.add "serverName", valid_564569
  var valid_564570 = path.getOrDefault("subscriptionId")
  valid_564570 = validateParameter(valid_564570, JString, required = true,
                                 default = nil)
  if valid_564570 != nil:
    section.add "subscriptionId", valid_564570
  var valid_564571 = path.getOrDefault("jobAgentName")
  valid_564571 = validateParameter(valid_564571, JString, required = true,
                                 default = nil)
  if valid_564571 != nil:
    section.add "jobAgentName", valid_564571
  var valid_564572 = path.getOrDefault("targetGroupName")
  valid_564572 = validateParameter(valid_564572, JString, required = true,
                                 default = nil)
  if valid_564572 != nil:
    section.add "targetGroupName", valid_564572
  var valid_564573 = path.getOrDefault("resourceGroupName")
  valid_564573 = validateParameter(valid_564573, JString, required = true,
                                 default = nil)
  if valid_564573 != nil:
    section.add "resourceGroupName", valid_564573
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564574 = query.getOrDefault("api-version")
  valid_564574 = validateParameter(valid_564574, JString, required = true,
                                 default = nil)
  if valid_564574 != nil:
    section.add "api-version", valid_564574
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564575: Call_JobTargetGroupsGet_564566; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a target group.
  ## 
  let valid = call_564575.validator(path, query, header, formData, body)
  let scheme = call_564575.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564575.url(scheme.get, call_564575.host, call_564575.base,
                         call_564575.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564575, url, valid)

proc call*(call_564576: Call_JobTargetGroupsGet_564566; apiVersion: string;
          serverName: string; subscriptionId: string; jobAgentName: string;
          targetGroupName: string; resourceGroupName: string): Recallable =
  ## jobTargetGroupsGet
  ## Gets a target group.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   serverName: string (required)
  ##             : The name of the server.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   jobAgentName: string (required)
  ##               : The name of the job agent.
  ##   targetGroupName: string (required)
  ##                  : The name of the target group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  var path_564577 = newJObject()
  var query_564578 = newJObject()
  add(query_564578, "api-version", newJString(apiVersion))
  add(path_564577, "serverName", newJString(serverName))
  add(path_564577, "subscriptionId", newJString(subscriptionId))
  add(path_564577, "jobAgentName", newJString(jobAgentName))
  add(path_564577, "targetGroupName", newJString(targetGroupName))
  add(path_564577, "resourceGroupName", newJString(resourceGroupName))
  result = call_564576.call(path_564577, query_564578, nil, nil, nil)

var jobTargetGroupsGet* = Call_JobTargetGroupsGet_564566(
    name: "jobTargetGroupsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/servers/{serverName}/jobAgents/{jobAgentName}/targetGroups/{targetGroupName}",
    validator: validate_JobTargetGroupsGet_564567, base: "",
    url: url_JobTargetGroupsGet_564568, schemes: {Scheme.Https})
type
  Call_JobTargetGroupsDelete_564594 = ref object of OpenApiRestCall_563555
proc url_JobTargetGroupsDelete_564596(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serverName" in path, "`serverName` is a required path parameter"
  assert "jobAgentName" in path, "`jobAgentName` is a required path parameter"
  assert "targetGroupName" in path, "`targetGroupName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Sql/servers/"),
               (kind: VariableSegment, value: "serverName"),
               (kind: ConstantSegment, value: "/jobAgents/"),
               (kind: VariableSegment, value: "jobAgentName"),
               (kind: ConstantSegment, value: "/targetGroups/"),
               (kind: VariableSegment, value: "targetGroupName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_JobTargetGroupsDelete_564595(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a target group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serverName: JString (required)
  ##             : The name of the server.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   jobAgentName: JString (required)
  ##               : The name of the job agent.
  ##   targetGroupName: JString (required)
  ##                  : The name of the target group.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serverName` field"
  var valid_564597 = path.getOrDefault("serverName")
  valid_564597 = validateParameter(valid_564597, JString, required = true,
                                 default = nil)
  if valid_564597 != nil:
    section.add "serverName", valid_564597
  var valid_564598 = path.getOrDefault("subscriptionId")
  valid_564598 = validateParameter(valid_564598, JString, required = true,
                                 default = nil)
  if valid_564598 != nil:
    section.add "subscriptionId", valid_564598
  var valid_564599 = path.getOrDefault("jobAgentName")
  valid_564599 = validateParameter(valid_564599, JString, required = true,
                                 default = nil)
  if valid_564599 != nil:
    section.add "jobAgentName", valid_564599
  var valid_564600 = path.getOrDefault("targetGroupName")
  valid_564600 = validateParameter(valid_564600, JString, required = true,
                                 default = nil)
  if valid_564600 != nil:
    section.add "targetGroupName", valid_564600
  var valid_564601 = path.getOrDefault("resourceGroupName")
  valid_564601 = validateParameter(valid_564601, JString, required = true,
                                 default = nil)
  if valid_564601 != nil:
    section.add "resourceGroupName", valid_564601
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564602 = query.getOrDefault("api-version")
  valid_564602 = validateParameter(valid_564602, JString, required = true,
                                 default = nil)
  if valid_564602 != nil:
    section.add "api-version", valid_564602
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564603: Call_JobTargetGroupsDelete_564594; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a target group.
  ## 
  let valid = call_564603.validator(path, query, header, formData, body)
  let scheme = call_564603.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564603.url(scheme.get, call_564603.host, call_564603.base,
                         call_564603.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564603, url, valid)

proc call*(call_564604: Call_JobTargetGroupsDelete_564594; apiVersion: string;
          serverName: string; subscriptionId: string; jobAgentName: string;
          targetGroupName: string; resourceGroupName: string): Recallable =
  ## jobTargetGroupsDelete
  ## Deletes a target group.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   serverName: string (required)
  ##             : The name of the server.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   jobAgentName: string (required)
  ##               : The name of the job agent.
  ##   targetGroupName: string (required)
  ##                  : The name of the target group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  var path_564605 = newJObject()
  var query_564606 = newJObject()
  add(query_564606, "api-version", newJString(apiVersion))
  add(path_564605, "serverName", newJString(serverName))
  add(path_564605, "subscriptionId", newJString(subscriptionId))
  add(path_564605, "jobAgentName", newJString(jobAgentName))
  add(path_564605, "targetGroupName", newJString(targetGroupName))
  add(path_564605, "resourceGroupName", newJString(resourceGroupName))
  result = call_564604.call(path_564605, query_564606, nil, nil, nil)

var jobTargetGroupsDelete* = Call_JobTargetGroupsDelete_564594(
    name: "jobTargetGroupsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/servers/{serverName}/jobAgents/{jobAgentName}/targetGroups/{targetGroupName}",
    validator: validate_JobTargetGroupsDelete_564595, base: "",
    url: url_JobTargetGroupsDelete_564596, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
