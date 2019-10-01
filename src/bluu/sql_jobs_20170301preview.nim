
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

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
  macServiceName = "sql-jobs"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_JobAgentsListByServer_567879 = ref object of OpenApiRestCall_567657
proc url_JobAgentsListByServer_567881(protocol: Scheme; host: string; base: string;
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

proc validate_JobAgentsListByServer_567880(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a list of job agents in a server.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   serverName: JString (required)
  ##             : The name of the server.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568054 = path.getOrDefault("resourceGroupName")
  valid_568054 = validateParameter(valid_568054, JString, required = true,
                                 default = nil)
  if valid_568054 != nil:
    section.add "resourceGroupName", valid_568054
  var valid_568055 = path.getOrDefault("serverName")
  valid_568055 = validateParameter(valid_568055, JString, required = true,
                                 default = nil)
  if valid_568055 != nil:
    section.add "serverName", valid_568055
  var valid_568056 = path.getOrDefault("subscriptionId")
  valid_568056 = validateParameter(valid_568056, JString, required = true,
                                 default = nil)
  if valid_568056 != nil:
    section.add "subscriptionId", valid_568056
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568057 = query.getOrDefault("api-version")
  valid_568057 = validateParameter(valid_568057, JString, required = true,
                                 default = nil)
  if valid_568057 != nil:
    section.add "api-version", valid_568057
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568080: Call_JobAgentsListByServer_567879; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a list of job agents in a server.
  ## 
  let valid = call_568080.validator(path, query, header, formData, body)
  let scheme = call_568080.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568080.url(scheme.get, call_568080.host, call_568080.base,
                         call_568080.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568080, url, valid)

proc call*(call_568151: Call_JobAgentsListByServer_567879;
          resourceGroupName: string; apiVersion: string; serverName: string;
          subscriptionId: string): Recallable =
  ## jobAgentsListByServer
  ## Gets a list of job agents in a server.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   serverName: string (required)
  ##             : The name of the server.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  var path_568152 = newJObject()
  var query_568154 = newJObject()
  add(path_568152, "resourceGroupName", newJString(resourceGroupName))
  add(query_568154, "api-version", newJString(apiVersion))
  add(path_568152, "serverName", newJString(serverName))
  add(path_568152, "subscriptionId", newJString(subscriptionId))
  result = call_568151.call(path_568152, query_568154, nil, nil, nil)

var jobAgentsListByServer* = Call_JobAgentsListByServer_567879(
    name: "jobAgentsListByServer", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/servers/{serverName}/jobAgents",
    validator: validate_JobAgentsListByServer_567880, base: "",
    url: url_JobAgentsListByServer_567881, schemes: {Scheme.Https})
type
  Call_JobAgentsCreateOrUpdate_568205 = ref object of OpenApiRestCall_567657
proc url_JobAgentsCreateOrUpdate_568207(protocol: Scheme; host: string; base: string;
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

proc validate_JobAgentsCreateOrUpdate_568206(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates a job agent.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   serverName: JString (required)
  ##             : The name of the server.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   jobAgentName: JString (required)
  ##               : The name of the job agent to be created or updated.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568208 = path.getOrDefault("resourceGroupName")
  valid_568208 = validateParameter(valid_568208, JString, required = true,
                                 default = nil)
  if valid_568208 != nil:
    section.add "resourceGroupName", valid_568208
  var valid_568209 = path.getOrDefault("serverName")
  valid_568209 = validateParameter(valid_568209, JString, required = true,
                                 default = nil)
  if valid_568209 != nil:
    section.add "serverName", valid_568209
  var valid_568210 = path.getOrDefault("subscriptionId")
  valid_568210 = validateParameter(valid_568210, JString, required = true,
                                 default = nil)
  if valid_568210 != nil:
    section.add "subscriptionId", valid_568210
  var valid_568211 = path.getOrDefault("jobAgentName")
  valid_568211 = validateParameter(valid_568211, JString, required = true,
                                 default = nil)
  if valid_568211 != nil:
    section.add "jobAgentName", valid_568211
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568212 = query.getOrDefault("api-version")
  valid_568212 = validateParameter(valid_568212, JString, required = true,
                                 default = nil)
  if valid_568212 != nil:
    section.add "api-version", valid_568212
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

proc call*(call_568214: Call_JobAgentsCreateOrUpdate_568205; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates a job agent.
  ## 
  let valid = call_568214.validator(path, query, header, formData, body)
  let scheme = call_568214.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568214.url(scheme.get, call_568214.host, call_568214.base,
                         call_568214.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568214, url, valid)

proc call*(call_568215: Call_JobAgentsCreateOrUpdate_568205;
          resourceGroupName: string; apiVersion: string; serverName: string;
          subscriptionId: string; jobAgentName: string; parameters: JsonNode): Recallable =
  ## jobAgentsCreateOrUpdate
  ## Creates or updates a job agent.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   serverName: string (required)
  ##             : The name of the server.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   jobAgentName: string (required)
  ##               : The name of the job agent to be created or updated.
  ##   parameters: JObject (required)
  ##             : The requested job agent resource state.
  var path_568216 = newJObject()
  var query_568217 = newJObject()
  var body_568218 = newJObject()
  add(path_568216, "resourceGroupName", newJString(resourceGroupName))
  add(query_568217, "api-version", newJString(apiVersion))
  add(path_568216, "serverName", newJString(serverName))
  add(path_568216, "subscriptionId", newJString(subscriptionId))
  add(path_568216, "jobAgentName", newJString(jobAgentName))
  if parameters != nil:
    body_568218 = parameters
  result = call_568215.call(path_568216, query_568217, nil, nil, body_568218)

var jobAgentsCreateOrUpdate* = Call_JobAgentsCreateOrUpdate_568205(
    name: "jobAgentsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/servers/{serverName}/jobAgents/{jobAgentName}",
    validator: validate_JobAgentsCreateOrUpdate_568206, base: "",
    url: url_JobAgentsCreateOrUpdate_568207, schemes: {Scheme.Https})
type
  Call_JobAgentsGet_568193 = ref object of OpenApiRestCall_567657
proc url_JobAgentsGet_568195(protocol: Scheme; host: string; base: string;
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

proc validate_JobAgentsGet_568194(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a job agent.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   serverName: JString (required)
  ##             : The name of the server.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   jobAgentName: JString (required)
  ##               : The name of the job agent to be retrieved.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568196 = path.getOrDefault("resourceGroupName")
  valid_568196 = validateParameter(valid_568196, JString, required = true,
                                 default = nil)
  if valid_568196 != nil:
    section.add "resourceGroupName", valid_568196
  var valid_568197 = path.getOrDefault("serverName")
  valid_568197 = validateParameter(valid_568197, JString, required = true,
                                 default = nil)
  if valid_568197 != nil:
    section.add "serverName", valid_568197
  var valid_568198 = path.getOrDefault("subscriptionId")
  valid_568198 = validateParameter(valid_568198, JString, required = true,
                                 default = nil)
  if valid_568198 != nil:
    section.add "subscriptionId", valid_568198
  var valid_568199 = path.getOrDefault("jobAgentName")
  valid_568199 = validateParameter(valid_568199, JString, required = true,
                                 default = nil)
  if valid_568199 != nil:
    section.add "jobAgentName", valid_568199
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568200 = query.getOrDefault("api-version")
  valid_568200 = validateParameter(valid_568200, JString, required = true,
                                 default = nil)
  if valid_568200 != nil:
    section.add "api-version", valid_568200
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568201: Call_JobAgentsGet_568193; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a job agent.
  ## 
  let valid = call_568201.validator(path, query, header, formData, body)
  let scheme = call_568201.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568201.url(scheme.get, call_568201.host, call_568201.base,
                         call_568201.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568201, url, valid)

proc call*(call_568202: Call_JobAgentsGet_568193; resourceGroupName: string;
          apiVersion: string; serverName: string; subscriptionId: string;
          jobAgentName: string): Recallable =
  ## jobAgentsGet
  ## Gets a job agent.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   serverName: string (required)
  ##             : The name of the server.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   jobAgentName: string (required)
  ##               : The name of the job agent to be retrieved.
  var path_568203 = newJObject()
  var query_568204 = newJObject()
  add(path_568203, "resourceGroupName", newJString(resourceGroupName))
  add(query_568204, "api-version", newJString(apiVersion))
  add(path_568203, "serverName", newJString(serverName))
  add(path_568203, "subscriptionId", newJString(subscriptionId))
  add(path_568203, "jobAgentName", newJString(jobAgentName))
  result = call_568202.call(path_568203, query_568204, nil, nil, nil)

var jobAgentsGet* = Call_JobAgentsGet_568193(name: "jobAgentsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/servers/{serverName}/jobAgents/{jobAgentName}",
    validator: validate_JobAgentsGet_568194, base: "", url: url_JobAgentsGet_568195,
    schemes: {Scheme.Https})
type
  Call_JobAgentsUpdate_568231 = ref object of OpenApiRestCall_567657
proc url_JobAgentsUpdate_568233(protocol: Scheme; host: string; base: string;
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

proc validate_JobAgentsUpdate_568232(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Updates a job agent.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   serverName: JString (required)
  ##             : The name of the server.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   jobAgentName: JString (required)
  ##               : The name of the job agent to be updated.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568234 = path.getOrDefault("resourceGroupName")
  valid_568234 = validateParameter(valid_568234, JString, required = true,
                                 default = nil)
  if valid_568234 != nil:
    section.add "resourceGroupName", valid_568234
  var valid_568235 = path.getOrDefault("serverName")
  valid_568235 = validateParameter(valid_568235, JString, required = true,
                                 default = nil)
  if valid_568235 != nil:
    section.add "serverName", valid_568235
  var valid_568236 = path.getOrDefault("subscriptionId")
  valid_568236 = validateParameter(valid_568236, JString, required = true,
                                 default = nil)
  if valid_568236 != nil:
    section.add "subscriptionId", valid_568236
  var valid_568237 = path.getOrDefault("jobAgentName")
  valid_568237 = validateParameter(valid_568237, JString, required = true,
                                 default = nil)
  if valid_568237 != nil:
    section.add "jobAgentName", valid_568237
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
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
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The update to the job agent.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568240: Call_JobAgentsUpdate_568231; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a job agent.
  ## 
  let valid = call_568240.validator(path, query, header, formData, body)
  let scheme = call_568240.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568240.url(scheme.get, call_568240.host, call_568240.base,
                         call_568240.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568240, url, valid)

proc call*(call_568241: Call_JobAgentsUpdate_568231; resourceGroupName: string;
          apiVersion: string; serverName: string; subscriptionId: string;
          jobAgentName: string; parameters: JsonNode): Recallable =
  ## jobAgentsUpdate
  ## Updates a job agent.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   serverName: string (required)
  ##             : The name of the server.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   jobAgentName: string (required)
  ##               : The name of the job agent to be updated.
  ##   parameters: JObject (required)
  ##             : The update to the job agent.
  var path_568242 = newJObject()
  var query_568243 = newJObject()
  var body_568244 = newJObject()
  add(path_568242, "resourceGroupName", newJString(resourceGroupName))
  add(query_568243, "api-version", newJString(apiVersion))
  add(path_568242, "serverName", newJString(serverName))
  add(path_568242, "subscriptionId", newJString(subscriptionId))
  add(path_568242, "jobAgentName", newJString(jobAgentName))
  if parameters != nil:
    body_568244 = parameters
  result = call_568241.call(path_568242, query_568243, nil, nil, body_568244)

var jobAgentsUpdate* = Call_JobAgentsUpdate_568231(name: "jobAgentsUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/servers/{serverName}/jobAgents/{jobAgentName}",
    validator: validate_JobAgentsUpdate_568232, base: "", url: url_JobAgentsUpdate_568233,
    schemes: {Scheme.Https})
type
  Call_JobAgentsDelete_568219 = ref object of OpenApiRestCall_567657
proc url_JobAgentsDelete_568221(protocol: Scheme; host: string; base: string;
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

proc validate_JobAgentsDelete_568220(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Deletes a job agent.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   serverName: JString (required)
  ##             : The name of the server.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   jobAgentName: JString (required)
  ##               : The name of the job agent to be deleted.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568222 = path.getOrDefault("resourceGroupName")
  valid_568222 = validateParameter(valid_568222, JString, required = true,
                                 default = nil)
  if valid_568222 != nil:
    section.add "resourceGroupName", valid_568222
  var valid_568223 = path.getOrDefault("serverName")
  valid_568223 = validateParameter(valid_568223, JString, required = true,
                                 default = nil)
  if valid_568223 != nil:
    section.add "serverName", valid_568223
  var valid_568224 = path.getOrDefault("subscriptionId")
  valid_568224 = validateParameter(valid_568224, JString, required = true,
                                 default = nil)
  if valid_568224 != nil:
    section.add "subscriptionId", valid_568224
  var valid_568225 = path.getOrDefault("jobAgentName")
  valid_568225 = validateParameter(valid_568225, JString, required = true,
                                 default = nil)
  if valid_568225 != nil:
    section.add "jobAgentName", valid_568225
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568226 = query.getOrDefault("api-version")
  valid_568226 = validateParameter(valid_568226, JString, required = true,
                                 default = nil)
  if valid_568226 != nil:
    section.add "api-version", valid_568226
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568227: Call_JobAgentsDelete_568219; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a job agent.
  ## 
  let valid = call_568227.validator(path, query, header, formData, body)
  let scheme = call_568227.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568227.url(scheme.get, call_568227.host, call_568227.base,
                         call_568227.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568227, url, valid)

proc call*(call_568228: Call_JobAgentsDelete_568219; resourceGroupName: string;
          apiVersion: string; serverName: string; subscriptionId: string;
          jobAgentName: string): Recallable =
  ## jobAgentsDelete
  ## Deletes a job agent.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   serverName: string (required)
  ##             : The name of the server.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   jobAgentName: string (required)
  ##               : The name of the job agent to be deleted.
  var path_568229 = newJObject()
  var query_568230 = newJObject()
  add(path_568229, "resourceGroupName", newJString(resourceGroupName))
  add(query_568230, "api-version", newJString(apiVersion))
  add(path_568229, "serverName", newJString(serverName))
  add(path_568229, "subscriptionId", newJString(subscriptionId))
  add(path_568229, "jobAgentName", newJString(jobAgentName))
  result = call_568228.call(path_568229, query_568230, nil, nil, nil)

var jobAgentsDelete* = Call_JobAgentsDelete_568219(name: "jobAgentsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/servers/{serverName}/jobAgents/{jobAgentName}",
    validator: validate_JobAgentsDelete_568220, base: "", url: url_JobAgentsDelete_568221,
    schemes: {Scheme.Https})
type
  Call_JobCredentialsListByAgent_568245 = ref object of OpenApiRestCall_567657
proc url_JobCredentialsListByAgent_568247(protocol: Scheme; host: string;
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

proc validate_JobCredentialsListByAgent_568246(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a list of jobs credentials.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   serverName: JString (required)
  ##             : The name of the server.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   jobAgentName: JString (required)
  ##               : The name of the job agent.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568248 = path.getOrDefault("resourceGroupName")
  valid_568248 = validateParameter(valid_568248, JString, required = true,
                                 default = nil)
  if valid_568248 != nil:
    section.add "resourceGroupName", valid_568248
  var valid_568249 = path.getOrDefault("serverName")
  valid_568249 = validateParameter(valid_568249, JString, required = true,
                                 default = nil)
  if valid_568249 != nil:
    section.add "serverName", valid_568249
  var valid_568250 = path.getOrDefault("subscriptionId")
  valid_568250 = validateParameter(valid_568250, JString, required = true,
                                 default = nil)
  if valid_568250 != nil:
    section.add "subscriptionId", valid_568250
  var valid_568251 = path.getOrDefault("jobAgentName")
  valid_568251 = validateParameter(valid_568251, JString, required = true,
                                 default = nil)
  if valid_568251 != nil:
    section.add "jobAgentName", valid_568251
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568252 = query.getOrDefault("api-version")
  valid_568252 = validateParameter(valid_568252, JString, required = true,
                                 default = nil)
  if valid_568252 != nil:
    section.add "api-version", valid_568252
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568253: Call_JobCredentialsListByAgent_568245; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a list of jobs credentials.
  ## 
  let valid = call_568253.validator(path, query, header, formData, body)
  let scheme = call_568253.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568253.url(scheme.get, call_568253.host, call_568253.base,
                         call_568253.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568253, url, valid)

proc call*(call_568254: Call_JobCredentialsListByAgent_568245;
          resourceGroupName: string; apiVersion: string; serverName: string;
          subscriptionId: string; jobAgentName: string): Recallable =
  ## jobCredentialsListByAgent
  ## Gets a list of jobs credentials.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   serverName: string (required)
  ##             : The name of the server.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   jobAgentName: string (required)
  ##               : The name of the job agent.
  var path_568255 = newJObject()
  var query_568256 = newJObject()
  add(path_568255, "resourceGroupName", newJString(resourceGroupName))
  add(query_568256, "api-version", newJString(apiVersion))
  add(path_568255, "serverName", newJString(serverName))
  add(path_568255, "subscriptionId", newJString(subscriptionId))
  add(path_568255, "jobAgentName", newJString(jobAgentName))
  result = call_568254.call(path_568255, query_568256, nil, nil, nil)

var jobCredentialsListByAgent* = Call_JobCredentialsListByAgent_568245(
    name: "jobCredentialsListByAgent", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/servers/{serverName}/jobAgents/{jobAgentName}/credentials",
    validator: validate_JobCredentialsListByAgent_568246, base: "",
    url: url_JobCredentialsListByAgent_568247, schemes: {Scheme.Https})
type
  Call_JobCredentialsCreateOrUpdate_568270 = ref object of OpenApiRestCall_567657
proc url_JobCredentialsCreateOrUpdate_568272(protocol: Scheme; host: string;
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

proc validate_JobCredentialsCreateOrUpdate_568271(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates a job credential.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   serverName: JString (required)
  ##             : The name of the server.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   jobAgentName: JString (required)
  ##               : The name of the job agent.
  ##   credentialName: JString (required)
  ##                 : The name of the credential.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568273 = path.getOrDefault("resourceGroupName")
  valid_568273 = validateParameter(valid_568273, JString, required = true,
                                 default = nil)
  if valid_568273 != nil:
    section.add "resourceGroupName", valid_568273
  var valid_568274 = path.getOrDefault("serverName")
  valid_568274 = validateParameter(valid_568274, JString, required = true,
                                 default = nil)
  if valid_568274 != nil:
    section.add "serverName", valid_568274
  var valid_568275 = path.getOrDefault("subscriptionId")
  valid_568275 = validateParameter(valid_568275, JString, required = true,
                                 default = nil)
  if valid_568275 != nil:
    section.add "subscriptionId", valid_568275
  var valid_568276 = path.getOrDefault("jobAgentName")
  valid_568276 = validateParameter(valid_568276, JString, required = true,
                                 default = nil)
  if valid_568276 != nil:
    section.add "jobAgentName", valid_568276
  var valid_568277 = path.getOrDefault("credentialName")
  valid_568277 = validateParameter(valid_568277, JString, required = true,
                                 default = nil)
  if valid_568277 != nil:
    section.add "credentialName", valid_568277
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568278 = query.getOrDefault("api-version")
  valid_568278 = validateParameter(valid_568278, JString, required = true,
                                 default = nil)
  if valid_568278 != nil:
    section.add "api-version", valid_568278
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

proc call*(call_568280: Call_JobCredentialsCreateOrUpdate_568270; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates a job credential.
  ## 
  let valid = call_568280.validator(path, query, header, formData, body)
  let scheme = call_568280.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568280.url(scheme.get, call_568280.host, call_568280.base,
                         call_568280.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568280, url, valid)

proc call*(call_568281: Call_JobCredentialsCreateOrUpdate_568270;
          resourceGroupName: string; apiVersion: string; serverName: string;
          subscriptionId: string; jobAgentName: string; credentialName: string;
          parameters: JsonNode): Recallable =
  ## jobCredentialsCreateOrUpdate
  ## Creates or updates a job credential.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
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
  ##   parameters: JObject (required)
  ##             : The requested job credential state.
  var path_568282 = newJObject()
  var query_568283 = newJObject()
  var body_568284 = newJObject()
  add(path_568282, "resourceGroupName", newJString(resourceGroupName))
  add(query_568283, "api-version", newJString(apiVersion))
  add(path_568282, "serverName", newJString(serverName))
  add(path_568282, "subscriptionId", newJString(subscriptionId))
  add(path_568282, "jobAgentName", newJString(jobAgentName))
  add(path_568282, "credentialName", newJString(credentialName))
  if parameters != nil:
    body_568284 = parameters
  result = call_568281.call(path_568282, query_568283, nil, nil, body_568284)

var jobCredentialsCreateOrUpdate* = Call_JobCredentialsCreateOrUpdate_568270(
    name: "jobCredentialsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/servers/{serverName}/jobAgents/{jobAgentName}/credentials/{credentialName}",
    validator: validate_JobCredentialsCreateOrUpdate_568271, base: "",
    url: url_JobCredentialsCreateOrUpdate_568272, schemes: {Scheme.Https})
type
  Call_JobCredentialsGet_568257 = ref object of OpenApiRestCall_567657
proc url_JobCredentialsGet_568259(protocol: Scheme; host: string; base: string;
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

proc validate_JobCredentialsGet_568258(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Gets a jobs credential.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   serverName: JString (required)
  ##             : The name of the server.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   jobAgentName: JString (required)
  ##               : The name of the job agent.
  ##   credentialName: JString (required)
  ##                 : The name of the credential.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568260 = path.getOrDefault("resourceGroupName")
  valid_568260 = validateParameter(valid_568260, JString, required = true,
                                 default = nil)
  if valid_568260 != nil:
    section.add "resourceGroupName", valid_568260
  var valid_568261 = path.getOrDefault("serverName")
  valid_568261 = validateParameter(valid_568261, JString, required = true,
                                 default = nil)
  if valid_568261 != nil:
    section.add "serverName", valid_568261
  var valid_568262 = path.getOrDefault("subscriptionId")
  valid_568262 = validateParameter(valid_568262, JString, required = true,
                                 default = nil)
  if valid_568262 != nil:
    section.add "subscriptionId", valid_568262
  var valid_568263 = path.getOrDefault("jobAgentName")
  valid_568263 = validateParameter(valid_568263, JString, required = true,
                                 default = nil)
  if valid_568263 != nil:
    section.add "jobAgentName", valid_568263
  var valid_568264 = path.getOrDefault("credentialName")
  valid_568264 = validateParameter(valid_568264, JString, required = true,
                                 default = nil)
  if valid_568264 != nil:
    section.add "credentialName", valid_568264
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568265 = query.getOrDefault("api-version")
  valid_568265 = validateParameter(valid_568265, JString, required = true,
                                 default = nil)
  if valid_568265 != nil:
    section.add "api-version", valid_568265
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568266: Call_JobCredentialsGet_568257; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a jobs credential.
  ## 
  let valid = call_568266.validator(path, query, header, formData, body)
  let scheme = call_568266.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568266.url(scheme.get, call_568266.host, call_568266.base,
                         call_568266.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568266, url, valid)

proc call*(call_568267: Call_JobCredentialsGet_568257; resourceGroupName: string;
          apiVersion: string; serverName: string; subscriptionId: string;
          jobAgentName: string; credentialName: string): Recallable =
  ## jobCredentialsGet
  ## Gets a jobs credential.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
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
  var path_568268 = newJObject()
  var query_568269 = newJObject()
  add(path_568268, "resourceGroupName", newJString(resourceGroupName))
  add(query_568269, "api-version", newJString(apiVersion))
  add(path_568268, "serverName", newJString(serverName))
  add(path_568268, "subscriptionId", newJString(subscriptionId))
  add(path_568268, "jobAgentName", newJString(jobAgentName))
  add(path_568268, "credentialName", newJString(credentialName))
  result = call_568267.call(path_568268, query_568269, nil, nil, nil)

var jobCredentialsGet* = Call_JobCredentialsGet_568257(name: "jobCredentialsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/servers/{serverName}/jobAgents/{jobAgentName}/credentials/{credentialName}",
    validator: validate_JobCredentialsGet_568258, base: "",
    url: url_JobCredentialsGet_568259, schemes: {Scheme.Https})
type
  Call_JobCredentialsDelete_568285 = ref object of OpenApiRestCall_567657
proc url_JobCredentialsDelete_568287(protocol: Scheme; host: string; base: string;
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

proc validate_JobCredentialsDelete_568286(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a job credential.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   serverName: JString (required)
  ##             : The name of the server.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   jobAgentName: JString (required)
  ##               : The name of the job agent.
  ##   credentialName: JString (required)
  ##                 : The name of the credential.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568288 = path.getOrDefault("resourceGroupName")
  valid_568288 = validateParameter(valid_568288, JString, required = true,
                                 default = nil)
  if valid_568288 != nil:
    section.add "resourceGroupName", valid_568288
  var valid_568289 = path.getOrDefault("serverName")
  valid_568289 = validateParameter(valid_568289, JString, required = true,
                                 default = nil)
  if valid_568289 != nil:
    section.add "serverName", valid_568289
  var valid_568290 = path.getOrDefault("subscriptionId")
  valid_568290 = validateParameter(valid_568290, JString, required = true,
                                 default = nil)
  if valid_568290 != nil:
    section.add "subscriptionId", valid_568290
  var valid_568291 = path.getOrDefault("jobAgentName")
  valid_568291 = validateParameter(valid_568291, JString, required = true,
                                 default = nil)
  if valid_568291 != nil:
    section.add "jobAgentName", valid_568291
  var valid_568292 = path.getOrDefault("credentialName")
  valid_568292 = validateParameter(valid_568292, JString, required = true,
                                 default = nil)
  if valid_568292 != nil:
    section.add "credentialName", valid_568292
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568293 = query.getOrDefault("api-version")
  valid_568293 = validateParameter(valid_568293, JString, required = true,
                                 default = nil)
  if valid_568293 != nil:
    section.add "api-version", valid_568293
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568294: Call_JobCredentialsDelete_568285; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a job credential.
  ## 
  let valid = call_568294.validator(path, query, header, formData, body)
  let scheme = call_568294.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568294.url(scheme.get, call_568294.host, call_568294.base,
                         call_568294.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568294, url, valid)

proc call*(call_568295: Call_JobCredentialsDelete_568285;
          resourceGroupName: string; apiVersion: string; serverName: string;
          subscriptionId: string; jobAgentName: string; credentialName: string): Recallable =
  ## jobCredentialsDelete
  ## Deletes a job credential.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
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
  var path_568296 = newJObject()
  var query_568297 = newJObject()
  add(path_568296, "resourceGroupName", newJString(resourceGroupName))
  add(query_568297, "api-version", newJString(apiVersion))
  add(path_568296, "serverName", newJString(serverName))
  add(path_568296, "subscriptionId", newJString(subscriptionId))
  add(path_568296, "jobAgentName", newJString(jobAgentName))
  add(path_568296, "credentialName", newJString(credentialName))
  result = call_568295.call(path_568296, query_568297, nil, nil, nil)

var jobCredentialsDelete* = Call_JobCredentialsDelete_568285(
    name: "jobCredentialsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/servers/{serverName}/jobAgents/{jobAgentName}/credentials/{credentialName}",
    validator: validate_JobCredentialsDelete_568286, base: "",
    url: url_JobCredentialsDelete_568287, schemes: {Scheme.Https})
type
  Call_JobExecutionsListByAgent_568298 = ref object of OpenApiRestCall_567657
proc url_JobExecutionsListByAgent_568300(protocol: Scheme; host: string;
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

proc validate_JobExecutionsListByAgent_568299(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all executions in a job agent.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   serverName: JString (required)
  ##             : The name of the server.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   jobAgentName: JString (required)
  ##               : The name of the job agent.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568302 = path.getOrDefault("resourceGroupName")
  valid_568302 = validateParameter(valid_568302, JString, required = true,
                                 default = nil)
  if valid_568302 != nil:
    section.add "resourceGroupName", valid_568302
  var valid_568303 = path.getOrDefault("serverName")
  valid_568303 = validateParameter(valid_568303, JString, required = true,
                                 default = nil)
  if valid_568303 != nil:
    section.add "serverName", valid_568303
  var valid_568304 = path.getOrDefault("subscriptionId")
  valid_568304 = validateParameter(valid_568304, JString, required = true,
                                 default = nil)
  if valid_568304 != nil:
    section.add "subscriptionId", valid_568304
  var valid_568305 = path.getOrDefault("jobAgentName")
  valid_568305 = validateParameter(valid_568305, JString, required = true,
                                 default = nil)
  if valid_568305 != nil:
    section.add "jobAgentName", valid_568305
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  ##   $top: JInt
  ##       : The number of elements to return from the collection.
  ##   endTimeMax: JString
  ##             : If specified, only job executions completed before the specified time are included.
  ##   createTimeMax: JString
  ##                : If specified, only job executions created before the specified time are included.
  ##   $skip: JInt
  ##        : The number of elements in the collection to skip.
  ##   endTimeMin: JString
  ##             : If specified, only job executions completed at or after the specified time are included.
  ##   createTimeMin: JString
  ##                : If specified, only job executions created at or after the specified time are included.
  ##   isActive: JBool
  ##           : If specified, only active or only completed job executions are included.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568306 = query.getOrDefault("api-version")
  valid_568306 = validateParameter(valid_568306, JString, required = true,
                                 default = nil)
  if valid_568306 != nil:
    section.add "api-version", valid_568306
  var valid_568307 = query.getOrDefault("$top")
  valid_568307 = validateParameter(valid_568307, JInt, required = false, default = nil)
  if valid_568307 != nil:
    section.add "$top", valid_568307
  var valid_568308 = query.getOrDefault("endTimeMax")
  valid_568308 = validateParameter(valid_568308, JString, required = false,
                                 default = nil)
  if valid_568308 != nil:
    section.add "endTimeMax", valid_568308
  var valid_568309 = query.getOrDefault("createTimeMax")
  valid_568309 = validateParameter(valid_568309, JString, required = false,
                                 default = nil)
  if valid_568309 != nil:
    section.add "createTimeMax", valid_568309
  var valid_568310 = query.getOrDefault("$skip")
  valid_568310 = validateParameter(valid_568310, JInt, required = false, default = nil)
  if valid_568310 != nil:
    section.add "$skip", valid_568310
  var valid_568311 = query.getOrDefault("endTimeMin")
  valid_568311 = validateParameter(valid_568311, JString, required = false,
                                 default = nil)
  if valid_568311 != nil:
    section.add "endTimeMin", valid_568311
  var valid_568312 = query.getOrDefault("createTimeMin")
  valid_568312 = validateParameter(valid_568312, JString, required = false,
                                 default = nil)
  if valid_568312 != nil:
    section.add "createTimeMin", valid_568312
  var valid_568313 = query.getOrDefault("isActive")
  valid_568313 = validateParameter(valid_568313, JBool, required = false, default = nil)
  if valid_568313 != nil:
    section.add "isActive", valid_568313
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568314: Call_JobExecutionsListByAgent_568298; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all executions in a job agent.
  ## 
  let valid = call_568314.validator(path, query, header, formData, body)
  let scheme = call_568314.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568314.url(scheme.get, call_568314.host, call_568314.base,
                         call_568314.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568314, url, valid)

proc call*(call_568315: Call_JobExecutionsListByAgent_568298;
          resourceGroupName: string; apiVersion: string; serverName: string;
          subscriptionId: string; jobAgentName: string; Top: int = 0;
          endTimeMax: string = ""; createTimeMax: string = ""; Skip: int = 0;
          endTimeMin: string = ""; createTimeMin: string = ""; isActive: bool = false): Recallable =
  ## jobExecutionsListByAgent
  ## Lists all executions in a job agent.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   serverName: string (required)
  ##             : The name of the server.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   jobAgentName: string (required)
  ##               : The name of the job agent.
  ##   Top: int
  ##      : The number of elements to return from the collection.
  ##   endTimeMax: string
  ##             : If specified, only job executions completed before the specified time are included.
  ##   createTimeMax: string
  ##                : If specified, only job executions created before the specified time are included.
  ##   Skip: int
  ##       : The number of elements in the collection to skip.
  ##   endTimeMin: string
  ##             : If specified, only job executions completed at or after the specified time are included.
  ##   createTimeMin: string
  ##                : If specified, only job executions created at or after the specified time are included.
  ##   isActive: bool
  ##           : If specified, only active or only completed job executions are included.
  var path_568316 = newJObject()
  var query_568317 = newJObject()
  add(path_568316, "resourceGroupName", newJString(resourceGroupName))
  add(query_568317, "api-version", newJString(apiVersion))
  add(path_568316, "serverName", newJString(serverName))
  add(path_568316, "subscriptionId", newJString(subscriptionId))
  add(path_568316, "jobAgentName", newJString(jobAgentName))
  add(query_568317, "$top", newJInt(Top))
  add(query_568317, "endTimeMax", newJString(endTimeMax))
  add(query_568317, "createTimeMax", newJString(createTimeMax))
  add(query_568317, "$skip", newJInt(Skip))
  add(query_568317, "endTimeMin", newJString(endTimeMin))
  add(query_568317, "createTimeMin", newJString(createTimeMin))
  add(query_568317, "isActive", newJBool(isActive))
  result = call_568315.call(path_568316, query_568317, nil, nil, nil)

var jobExecutionsListByAgent* = Call_JobExecutionsListByAgent_568298(
    name: "jobExecutionsListByAgent", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/servers/{serverName}/jobAgents/{jobAgentName}/executions",
    validator: validate_JobExecutionsListByAgent_568299, base: "",
    url: url_JobExecutionsListByAgent_568300, schemes: {Scheme.Https})
type
  Call_JobsListByAgent_568318 = ref object of OpenApiRestCall_567657
proc url_JobsListByAgent_568320(protocol: Scheme; host: string; base: string;
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

proc validate_JobsListByAgent_568319(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Gets a list of jobs.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   serverName: JString (required)
  ##             : The name of the server.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   jobAgentName: JString (required)
  ##               : The name of the job agent.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568321 = path.getOrDefault("resourceGroupName")
  valid_568321 = validateParameter(valid_568321, JString, required = true,
                                 default = nil)
  if valid_568321 != nil:
    section.add "resourceGroupName", valid_568321
  var valid_568322 = path.getOrDefault("serverName")
  valid_568322 = validateParameter(valid_568322, JString, required = true,
                                 default = nil)
  if valid_568322 != nil:
    section.add "serverName", valid_568322
  var valid_568323 = path.getOrDefault("subscriptionId")
  valid_568323 = validateParameter(valid_568323, JString, required = true,
                                 default = nil)
  if valid_568323 != nil:
    section.add "subscriptionId", valid_568323
  var valid_568324 = path.getOrDefault("jobAgentName")
  valid_568324 = validateParameter(valid_568324, JString, required = true,
                                 default = nil)
  if valid_568324 != nil:
    section.add "jobAgentName", valid_568324
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568325 = query.getOrDefault("api-version")
  valid_568325 = validateParameter(valid_568325, JString, required = true,
                                 default = nil)
  if valid_568325 != nil:
    section.add "api-version", valid_568325
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568326: Call_JobsListByAgent_568318; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a list of jobs.
  ## 
  let valid = call_568326.validator(path, query, header, formData, body)
  let scheme = call_568326.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568326.url(scheme.get, call_568326.host, call_568326.base,
                         call_568326.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568326, url, valid)

proc call*(call_568327: Call_JobsListByAgent_568318; resourceGroupName: string;
          apiVersion: string; serverName: string; subscriptionId: string;
          jobAgentName: string): Recallable =
  ## jobsListByAgent
  ## Gets a list of jobs.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   serverName: string (required)
  ##             : The name of the server.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   jobAgentName: string (required)
  ##               : The name of the job agent.
  var path_568328 = newJObject()
  var query_568329 = newJObject()
  add(path_568328, "resourceGroupName", newJString(resourceGroupName))
  add(query_568329, "api-version", newJString(apiVersion))
  add(path_568328, "serverName", newJString(serverName))
  add(path_568328, "subscriptionId", newJString(subscriptionId))
  add(path_568328, "jobAgentName", newJString(jobAgentName))
  result = call_568327.call(path_568328, query_568329, nil, nil, nil)

var jobsListByAgent* = Call_JobsListByAgent_568318(name: "jobsListByAgent",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/servers/{serverName}/jobAgents/{jobAgentName}/jobs",
    validator: validate_JobsListByAgent_568319, base: "", url: url_JobsListByAgent_568320,
    schemes: {Scheme.Https})
type
  Call_JobsCreateOrUpdate_568343 = ref object of OpenApiRestCall_567657
proc url_JobsCreateOrUpdate_568345(protocol: Scheme; host: string; base: string;
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

proc validate_JobsCreateOrUpdate_568344(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Creates or updates a job.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   serverName: JString (required)
  ##             : The name of the server.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   jobAgentName: JString (required)
  ##               : The name of the job agent.
  ##   jobName: JString (required)
  ##          : The name of the job to get.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568346 = path.getOrDefault("resourceGroupName")
  valid_568346 = validateParameter(valid_568346, JString, required = true,
                                 default = nil)
  if valid_568346 != nil:
    section.add "resourceGroupName", valid_568346
  var valid_568347 = path.getOrDefault("serverName")
  valid_568347 = validateParameter(valid_568347, JString, required = true,
                                 default = nil)
  if valid_568347 != nil:
    section.add "serverName", valid_568347
  var valid_568348 = path.getOrDefault("subscriptionId")
  valid_568348 = validateParameter(valid_568348, JString, required = true,
                                 default = nil)
  if valid_568348 != nil:
    section.add "subscriptionId", valid_568348
  var valid_568349 = path.getOrDefault("jobAgentName")
  valid_568349 = validateParameter(valid_568349, JString, required = true,
                                 default = nil)
  if valid_568349 != nil:
    section.add "jobAgentName", valid_568349
  var valid_568350 = path.getOrDefault("jobName")
  valid_568350 = validateParameter(valid_568350, JString, required = true,
                                 default = nil)
  if valid_568350 != nil:
    section.add "jobName", valid_568350
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568351 = query.getOrDefault("api-version")
  valid_568351 = validateParameter(valid_568351, JString, required = true,
                                 default = nil)
  if valid_568351 != nil:
    section.add "api-version", valid_568351
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

proc call*(call_568353: Call_JobsCreateOrUpdate_568343; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates a job.
  ## 
  let valid = call_568353.validator(path, query, header, formData, body)
  let scheme = call_568353.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568353.url(scheme.get, call_568353.host, call_568353.base,
                         call_568353.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568353, url, valid)

proc call*(call_568354: Call_JobsCreateOrUpdate_568343; resourceGroupName: string;
          apiVersion: string; serverName: string; subscriptionId: string;
          jobAgentName: string; jobName: string; parameters: JsonNode): Recallable =
  ## jobsCreateOrUpdate
  ## Creates or updates a job.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   serverName: string (required)
  ##             : The name of the server.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   jobAgentName: string (required)
  ##               : The name of the job agent.
  ##   jobName: string (required)
  ##          : The name of the job to get.
  ##   parameters: JObject (required)
  ##             : The requested job state.
  var path_568355 = newJObject()
  var query_568356 = newJObject()
  var body_568357 = newJObject()
  add(path_568355, "resourceGroupName", newJString(resourceGroupName))
  add(query_568356, "api-version", newJString(apiVersion))
  add(path_568355, "serverName", newJString(serverName))
  add(path_568355, "subscriptionId", newJString(subscriptionId))
  add(path_568355, "jobAgentName", newJString(jobAgentName))
  add(path_568355, "jobName", newJString(jobName))
  if parameters != nil:
    body_568357 = parameters
  result = call_568354.call(path_568355, query_568356, nil, nil, body_568357)

var jobsCreateOrUpdate* = Call_JobsCreateOrUpdate_568343(
    name: "jobsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/servers/{serverName}/jobAgents/{jobAgentName}/jobs/{jobName}",
    validator: validate_JobsCreateOrUpdate_568344, base: "",
    url: url_JobsCreateOrUpdate_568345, schemes: {Scheme.Https})
type
  Call_JobsGet_568330 = ref object of OpenApiRestCall_567657
proc url_JobsGet_568332(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_JobsGet_568331(path: JsonNode; query: JsonNode; header: JsonNode;
                            formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a job.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   serverName: JString (required)
  ##             : The name of the server.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   jobAgentName: JString (required)
  ##               : The name of the job agent.
  ##   jobName: JString (required)
  ##          : The name of the job to get.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568333 = path.getOrDefault("resourceGroupName")
  valid_568333 = validateParameter(valid_568333, JString, required = true,
                                 default = nil)
  if valid_568333 != nil:
    section.add "resourceGroupName", valid_568333
  var valid_568334 = path.getOrDefault("serverName")
  valid_568334 = validateParameter(valid_568334, JString, required = true,
                                 default = nil)
  if valid_568334 != nil:
    section.add "serverName", valid_568334
  var valid_568335 = path.getOrDefault("subscriptionId")
  valid_568335 = validateParameter(valid_568335, JString, required = true,
                                 default = nil)
  if valid_568335 != nil:
    section.add "subscriptionId", valid_568335
  var valid_568336 = path.getOrDefault("jobAgentName")
  valid_568336 = validateParameter(valid_568336, JString, required = true,
                                 default = nil)
  if valid_568336 != nil:
    section.add "jobAgentName", valid_568336
  var valid_568337 = path.getOrDefault("jobName")
  valid_568337 = validateParameter(valid_568337, JString, required = true,
                                 default = nil)
  if valid_568337 != nil:
    section.add "jobName", valid_568337
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568338 = query.getOrDefault("api-version")
  valid_568338 = validateParameter(valid_568338, JString, required = true,
                                 default = nil)
  if valid_568338 != nil:
    section.add "api-version", valid_568338
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568339: Call_JobsGet_568330; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a job.
  ## 
  let valid = call_568339.validator(path, query, header, formData, body)
  let scheme = call_568339.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568339.url(scheme.get, call_568339.host, call_568339.base,
                         call_568339.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568339, url, valid)

proc call*(call_568340: Call_JobsGet_568330; resourceGroupName: string;
          apiVersion: string; serverName: string; subscriptionId: string;
          jobAgentName: string; jobName: string): Recallable =
  ## jobsGet
  ## Gets a job.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   serverName: string (required)
  ##             : The name of the server.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   jobAgentName: string (required)
  ##               : The name of the job agent.
  ##   jobName: string (required)
  ##          : The name of the job to get.
  var path_568341 = newJObject()
  var query_568342 = newJObject()
  add(path_568341, "resourceGroupName", newJString(resourceGroupName))
  add(query_568342, "api-version", newJString(apiVersion))
  add(path_568341, "serverName", newJString(serverName))
  add(path_568341, "subscriptionId", newJString(subscriptionId))
  add(path_568341, "jobAgentName", newJString(jobAgentName))
  add(path_568341, "jobName", newJString(jobName))
  result = call_568340.call(path_568341, query_568342, nil, nil, nil)

var jobsGet* = Call_JobsGet_568330(name: "jobsGet", meth: HttpMethod.HttpGet,
                                host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/servers/{serverName}/jobAgents/{jobAgentName}/jobs/{jobName}",
                                validator: validate_JobsGet_568331, base: "",
                                url: url_JobsGet_568332, schemes: {Scheme.Https})
type
  Call_JobsDelete_568358 = ref object of OpenApiRestCall_567657
proc url_JobsDelete_568360(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_JobsDelete_568359(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a job.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   serverName: JString (required)
  ##             : The name of the server.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   jobAgentName: JString (required)
  ##               : The name of the job agent.
  ##   jobName: JString (required)
  ##          : The name of the job to delete.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568361 = path.getOrDefault("resourceGroupName")
  valid_568361 = validateParameter(valid_568361, JString, required = true,
                                 default = nil)
  if valid_568361 != nil:
    section.add "resourceGroupName", valid_568361
  var valid_568362 = path.getOrDefault("serverName")
  valid_568362 = validateParameter(valid_568362, JString, required = true,
                                 default = nil)
  if valid_568362 != nil:
    section.add "serverName", valid_568362
  var valid_568363 = path.getOrDefault("subscriptionId")
  valid_568363 = validateParameter(valid_568363, JString, required = true,
                                 default = nil)
  if valid_568363 != nil:
    section.add "subscriptionId", valid_568363
  var valid_568364 = path.getOrDefault("jobAgentName")
  valid_568364 = validateParameter(valid_568364, JString, required = true,
                                 default = nil)
  if valid_568364 != nil:
    section.add "jobAgentName", valid_568364
  var valid_568365 = path.getOrDefault("jobName")
  valid_568365 = validateParameter(valid_568365, JString, required = true,
                                 default = nil)
  if valid_568365 != nil:
    section.add "jobName", valid_568365
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568366 = query.getOrDefault("api-version")
  valid_568366 = validateParameter(valid_568366, JString, required = true,
                                 default = nil)
  if valid_568366 != nil:
    section.add "api-version", valid_568366
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568367: Call_JobsDelete_568358; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a job.
  ## 
  let valid = call_568367.validator(path, query, header, formData, body)
  let scheme = call_568367.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568367.url(scheme.get, call_568367.host, call_568367.base,
                         call_568367.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568367, url, valid)

proc call*(call_568368: Call_JobsDelete_568358; resourceGroupName: string;
          apiVersion: string; serverName: string; subscriptionId: string;
          jobAgentName: string; jobName: string): Recallable =
  ## jobsDelete
  ## Deletes a job.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   serverName: string (required)
  ##             : The name of the server.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   jobAgentName: string (required)
  ##               : The name of the job agent.
  ##   jobName: string (required)
  ##          : The name of the job to delete.
  var path_568369 = newJObject()
  var query_568370 = newJObject()
  add(path_568369, "resourceGroupName", newJString(resourceGroupName))
  add(query_568370, "api-version", newJString(apiVersion))
  add(path_568369, "serverName", newJString(serverName))
  add(path_568369, "subscriptionId", newJString(subscriptionId))
  add(path_568369, "jobAgentName", newJString(jobAgentName))
  add(path_568369, "jobName", newJString(jobName))
  result = call_568368.call(path_568369, query_568370, nil, nil, nil)

var jobsDelete* = Call_JobsDelete_568358(name: "jobsDelete",
                                      meth: HttpMethod.HttpDelete,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/servers/{serverName}/jobAgents/{jobAgentName}/jobs/{jobName}",
                                      validator: validate_JobsDelete_568359,
                                      base: "", url: url_JobsDelete_568360,
                                      schemes: {Scheme.Https})
type
  Call_JobExecutionsListByJob_568371 = ref object of OpenApiRestCall_567657
proc url_JobExecutionsListByJob_568373(protocol: Scheme; host: string; base: string;
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

proc validate_JobExecutionsListByJob_568372(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists a job's executions.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   serverName: JString (required)
  ##             : The name of the server.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   jobAgentName: JString (required)
  ##               : The name of the job agent.
  ##   jobName: JString (required)
  ##          : The name of the job to get.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568374 = path.getOrDefault("resourceGroupName")
  valid_568374 = validateParameter(valid_568374, JString, required = true,
                                 default = nil)
  if valid_568374 != nil:
    section.add "resourceGroupName", valid_568374
  var valid_568375 = path.getOrDefault("serverName")
  valid_568375 = validateParameter(valid_568375, JString, required = true,
                                 default = nil)
  if valid_568375 != nil:
    section.add "serverName", valid_568375
  var valid_568376 = path.getOrDefault("subscriptionId")
  valid_568376 = validateParameter(valid_568376, JString, required = true,
                                 default = nil)
  if valid_568376 != nil:
    section.add "subscriptionId", valid_568376
  var valid_568377 = path.getOrDefault("jobAgentName")
  valid_568377 = validateParameter(valid_568377, JString, required = true,
                                 default = nil)
  if valid_568377 != nil:
    section.add "jobAgentName", valid_568377
  var valid_568378 = path.getOrDefault("jobName")
  valid_568378 = validateParameter(valid_568378, JString, required = true,
                                 default = nil)
  if valid_568378 != nil:
    section.add "jobName", valid_568378
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  ##   $top: JInt
  ##       : The number of elements to return from the collection.
  ##   endTimeMax: JString
  ##             : If specified, only job executions completed before the specified time are included.
  ##   createTimeMax: JString
  ##                : If specified, only job executions created before the specified time are included.
  ##   $skip: JInt
  ##        : The number of elements in the collection to skip.
  ##   endTimeMin: JString
  ##             : If specified, only job executions completed at or after the specified time are included.
  ##   createTimeMin: JString
  ##                : If specified, only job executions created at or after the specified time are included.
  ##   isActive: JBool
  ##           : If specified, only active or only completed job executions are included.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568379 = query.getOrDefault("api-version")
  valid_568379 = validateParameter(valid_568379, JString, required = true,
                                 default = nil)
  if valid_568379 != nil:
    section.add "api-version", valid_568379
  var valid_568380 = query.getOrDefault("$top")
  valid_568380 = validateParameter(valid_568380, JInt, required = false, default = nil)
  if valid_568380 != nil:
    section.add "$top", valid_568380
  var valid_568381 = query.getOrDefault("endTimeMax")
  valid_568381 = validateParameter(valid_568381, JString, required = false,
                                 default = nil)
  if valid_568381 != nil:
    section.add "endTimeMax", valid_568381
  var valid_568382 = query.getOrDefault("createTimeMax")
  valid_568382 = validateParameter(valid_568382, JString, required = false,
                                 default = nil)
  if valid_568382 != nil:
    section.add "createTimeMax", valid_568382
  var valid_568383 = query.getOrDefault("$skip")
  valid_568383 = validateParameter(valid_568383, JInt, required = false, default = nil)
  if valid_568383 != nil:
    section.add "$skip", valid_568383
  var valid_568384 = query.getOrDefault("endTimeMin")
  valid_568384 = validateParameter(valid_568384, JString, required = false,
                                 default = nil)
  if valid_568384 != nil:
    section.add "endTimeMin", valid_568384
  var valid_568385 = query.getOrDefault("createTimeMin")
  valid_568385 = validateParameter(valid_568385, JString, required = false,
                                 default = nil)
  if valid_568385 != nil:
    section.add "createTimeMin", valid_568385
  var valid_568386 = query.getOrDefault("isActive")
  valid_568386 = validateParameter(valid_568386, JBool, required = false, default = nil)
  if valid_568386 != nil:
    section.add "isActive", valid_568386
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568387: Call_JobExecutionsListByJob_568371; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists a job's executions.
  ## 
  let valid = call_568387.validator(path, query, header, formData, body)
  let scheme = call_568387.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568387.url(scheme.get, call_568387.host, call_568387.base,
                         call_568387.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568387, url, valid)

proc call*(call_568388: Call_JobExecutionsListByJob_568371;
          resourceGroupName: string; apiVersion: string; serverName: string;
          subscriptionId: string; jobAgentName: string; jobName: string; Top: int = 0;
          endTimeMax: string = ""; createTimeMax: string = ""; Skip: int = 0;
          endTimeMin: string = ""; createTimeMin: string = ""; isActive: bool = false): Recallable =
  ## jobExecutionsListByJob
  ## Lists a job's executions.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   serverName: string (required)
  ##             : The name of the server.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   jobAgentName: string (required)
  ##               : The name of the job agent.
  ##   jobName: string (required)
  ##          : The name of the job to get.
  ##   Top: int
  ##      : The number of elements to return from the collection.
  ##   endTimeMax: string
  ##             : If specified, only job executions completed before the specified time are included.
  ##   createTimeMax: string
  ##                : If specified, only job executions created before the specified time are included.
  ##   Skip: int
  ##       : The number of elements in the collection to skip.
  ##   endTimeMin: string
  ##             : If specified, only job executions completed at or after the specified time are included.
  ##   createTimeMin: string
  ##                : If specified, only job executions created at or after the specified time are included.
  ##   isActive: bool
  ##           : If specified, only active or only completed job executions are included.
  var path_568389 = newJObject()
  var query_568390 = newJObject()
  add(path_568389, "resourceGroupName", newJString(resourceGroupName))
  add(query_568390, "api-version", newJString(apiVersion))
  add(path_568389, "serverName", newJString(serverName))
  add(path_568389, "subscriptionId", newJString(subscriptionId))
  add(path_568389, "jobAgentName", newJString(jobAgentName))
  add(path_568389, "jobName", newJString(jobName))
  add(query_568390, "$top", newJInt(Top))
  add(query_568390, "endTimeMax", newJString(endTimeMax))
  add(query_568390, "createTimeMax", newJString(createTimeMax))
  add(query_568390, "$skip", newJInt(Skip))
  add(query_568390, "endTimeMin", newJString(endTimeMin))
  add(query_568390, "createTimeMin", newJString(createTimeMin))
  add(query_568390, "isActive", newJBool(isActive))
  result = call_568388.call(path_568389, query_568390, nil, nil, nil)

var jobExecutionsListByJob* = Call_JobExecutionsListByJob_568371(
    name: "jobExecutionsListByJob", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/servers/{serverName}/jobAgents/{jobAgentName}/jobs/{jobName}/executions",
    validator: validate_JobExecutionsListByJob_568372, base: "",
    url: url_JobExecutionsListByJob_568373, schemes: {Scheme.Https})
type
  Call_JobExecutionsCreateOrUpdate_568405 = ref object of OpenApiRestCall_567657
proc url_JobExecutionsCreateOrUpdate_568407(protocol: Scheme; host: string;
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

proc validate_JobExecutionsCreateOrUpdate_568406(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates a job execution.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   serverName: JString (required)
  ##             : The name of the server.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   jobAgentName: JString (required)
  ##               : The name of the job agent.
  ##   jobName: JString (required)
  ##          : The name of the job to get.
  ##   jobExecutionId: JString (required)
  ##                 : The job execution id to create the job execution under.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568408 = path.getOrDefault("resourceGroupName")
  valid_568408 = validateParameter(valid_568408, JString, required = true,
                                 default = nil)
  if valid_568408 != nil:
    section.add "resourceGroupName", valid_568408
  var valid_568409 = path.getOrDefault("serverName")
  valid_568409 = validateParameter(valid_568409, JString, required = true,
                                 default = nil)
  if valid_568409 != nil:
    section.add "serverName", valid_568409
  var valid_568410 = path.getOrDefault("subscriptionId")
  valid_568410 = validateParameter(valid_568410, JString, required = true,
                                 default = nil)
  if valid_568410 != nil:
    section.add "subscriptionId", valid_568410
  var valid_568411 = path.getOrDefault("jobAgentName")
  valid_568411 = validateParameter(valid_568411, JString, required = true,
                                 default = nil)
  if valid_568411 != nil:
    section.add "jobAgentName", valid_568411
  var valid_568412 = path.getOrDefault("jobName")
  valid_568412 = validateParameter(valid_568412, JString, required = true,
                                 default = nil)
  if valid_568412 != nil:
    section.add "jobName", valid_568412
  var valid_568413 = path.getOrDefault("jobExecutionId")
  valid_568413 = validateParameter(valid_568413, JString, required = true,
                                 default = nil)
  if valid_568413 != nil:
    section.add "jobExecutionId", valid_568413
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568414 = query.getOrDefault("api-version")
  valid_568414 = validateParameter(valid_568414, JString, required = true,
                                 default = nil)
  if valid_568414 != nil:
    section.add "api-version", valid_568414
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568415: Call_JobExecutionsCreateOrUpdate_568405; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates a job execution.
  ## 
  let valid = call_568415.validator(path, query, header, formData, body)
  let scheme = call_568415.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568415.url(scheme.get, call_568415.host, call_568415.base,
                         call_568415.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568415, url, valid)

proc call*(call_568416: Call_JobExecutionsCreateOrUpdate_568405;
          resourceGroupName: string; apiVersion: string; serverName: string;
          subscriptionId: string; jobAgentName: string; jobName: string;
          jobExecutionId: string): Recallable =
  ## jobExecutionsCreateOrUpdate
  ## Creates or updates a job execution.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   serverName: string (required)
  ##             : The name of the server.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   jobAgentName: string (required)
  ##               : The name of the job agent.
  ##   jobName: string (required)
  ##          : The name of the job to get.
  ##   jobExecutionId: string (required)
  ##                 : The job execution id to create the job execution under.
  var path_568417 = newJObject()
  var query_568418 = newJObject()
  add(path_568417, "resourceGroupName", newJString(resourceGroupName))
  add(query_568418, "api-version", newJString(apiVersion))
  add(path_568417, "serverName", newJString(serverName))
  add(path_568417, "subscriptionId", newJString(subscriptionId))
  add(path_568417, "jobAgentName", newJString(jobAgentName))
  add(path_568417, "jobName", newJString(jobName))
  add(path_568417, "jobExecutionId", newJString(jobExecutionId))
  result = call_568416.call(path_568417, query_568418, nil, nil, nil)

var jobExecutionsCreateOrUpdate* = Call_JobExecutionsCreateOrUpdate_568405(
    name: "jobExecutionsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/servers/{serverName}/jobAgents/{jobAgentName}/jobs/{jobName}/executions/{jobExecutionId}",
    validator: validate_JobExecutionsCreateOrUpdate_568406, base: "",
    url: url_JobExecutionsCreateOrUpdate_568407, schemes: {Scheme.Https})
type
  Call_JobExecutionsGet_568391 = ref object of OpenApiRestCall_567657
proc url_JobExecutionsGet_568393(protocol: Scheme; host: string; base: string;
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

proc validate_JobExecutionsGet_568392(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Gets a job execution.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   serverName: JString (required)
  ##             : The name of the server.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   jobAgentName: JString (required)
  ##               : The name of the job agent.
  ##   jobName: JString (required)
  ##          : The name of the job.
  ##   jobExecutionId: JString (required)
  ##                 : The id of the job execution
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568394 = path.getOrDefault("resourceGroupName")
  valid_568394 = validateParameter(valid_568394, JString, required = true,
                                 default = nil)
  if valid_568394 != nil:
    section.add "resourceGroupName", valid_568394
  var valid_568395 = path.getOrDefault("serverName")
  valid_568395 = validateParameter(valid_568395, JString, required = true,
                                 default = nil)
  if valid_568395 != nil:
    section.add "serverName", valid_568395
  var valid_568396 = path.getOrDefault("subscriptionId")
  valid_568396 = validateParameter(valid_568396, JString, required = true,
                                 default = nil)
  if valid_568396 != nil:
    section.add "subscriptionId", valid_568396
  var valid_568397 = path.getOrDefault("jobAgentName")
  valid_568397 = validateParameter(valid_568397, JString, required = true,
                                 default = nil)
  if valid_568397 != nil:
    section.add "jobAgentName", valid_568397
  var valid_568398 = path.getOrDefault("jobName")
  valid_568398 = validateParameter(valid_568398, JString, required = true,
                                 default = nil)
  if valid_568398 != nil:
    section.add "jobName", valid_568398
  var valid_568399 = path.getOrDefault("jobExecutionId")
  valid_568399 = validateParameter(valid_568399, JString, required = true,
                                 default = nil)
  if valid_568399 != nil:
    section.add "jobExecutionId", valid_568399
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568400 = query.getOrDefault("api-version")
  valid_568400 = validateParameter(valid_568400, JString, required = true,
                                 default = nil)
  if valid_568400 != nil:
    section.add "api-version", valid_568400
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568401: Call_JobExecutionsGet_568391; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a job execution.
  ## 
  let valid = call_568401.validator(path, query, header, formData, body)
  let scheme = call_568401.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568401.url(scheme.get, call_568401.host, call_568401.base,
                         call_568401.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568401, url, valid)

proc call*(call_568402: Call_JobExecutionsGet_568391; resourceGroupName: string;
          apiVersion: string; serverName: string; subscriptionId: string;
          jobAgentName: string; jobName: string; jobExecutionId: string): Recallable =
  ## jobExecutionsGet
  ## Gets a job execution.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   serverName: string (required)
  ##             : The name of the server.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   jobAgentName: string (required)
  ##               : The name of the job agent.
  ##   jobName: string (required)
  ##          : The name of the job.
  ##   jobExecutionId: string (required)
  ##                 : The id of the job execution
  var path_568403 = newJObject()
  var query_568404 = newJObject()
  add(path_568403, "resourceGroupName", newJString(resourceGroupName))
  add(query_568404, "api-version", newJString(apiVersion))
  add(path_568403, "serverName", newJString(serverName))
  add(path_568403, "subscriptionId", newJString(subscriptionId))
  add(path_568403, "jobAgentName", newJString(jobAgentName))
  add(path_568403, "jobName", newJString(jobName))
  add(path_568403, "jobExecutionId", newJString(jobExecutionId))
  result = call_568402.call(path_568403, query_568404, nil, nil, nil)

var jobExecutionsGet* = Call_JobExecutionsGet_568391(name: "jobExecutionsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/servers/{serverName}/jobAgents/{jobAgentName}/jobs/{jobName}/executions/{jobExecutionId}",
    validator: validate_JobExecutionsGet_568392, base: "",
    url: url_JobExecutionsGet_568393, schemes: {Scheme.Https})
type
  Call_JobExecutionsCancel_568419 = ref object of OpenApiRestCall_567657
proc url_JobExecutionsCancel_568421(protocol: Scheme; host: string; base: string;
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

proc validate_JobExecutionsCancel_568420(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Requests cancellation of a job execution.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   serverName: JString (required)
  ##             : The name of the server.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   jobAgentName: JString (required)
  ##               : The name of the job agent.
  ##   jobName: JString (required)
  ##          : The name of the job.
  ##   jobExecutionId: JString (required)
  ##                 : The id of the job execution to cancel.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568422 = path.getOrDefault("resourceGroupName")
  valid_568422 = validateParameter(valid_568422, JString, required = true,
                                 default = nil)
  if valid_568422 != nil:
    section.add "resourceGroupName", valid_568422
  var valid_568423 = path.getOrDefault("serverName")
  valid_568423 = validateParameter(valid_568423, JString, required = true,
                                 default = nil)
  if valid_568423 != nil:
    section.add "serverName", valid_568423
  var valid_568424 = path.getOrDefault("subscriptionId")
  valid_568424 = validateParameter(valid_568424, JString, required = true,
                                 default = nil)
  if valid_568424 != nil:
    section.add "subscriptionId", valid_568424
  var valid_568425 = path.getOrDefault("jobAgentName")
  valid_568425 = validateParameter(valid_568425, JString, required = true,
                                 default = nil)
  if valid_568425 != nil:
    section.add "jobAgentName", valid_568425
  var valid_568426 = path.getOrDefault("jobName")
  valid_568426 = validateParameter(valid_568426, JString, required = true,
                                 default = nil)
  if valid_568426 != nil:
    section.add "jobName", valid_568426
  var valid_568427 = path.getOrDefault("jobExecutionId")
  valid_568427 = validateParameter(valid_568427, JString, required = true,
                                 default = nil)
  if valid_568427 != nil:
    section.add "jobExecutionId", valid_568427
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568428 = query.getOrDefault("api-version")
  valid_568428 = validateParameter(valid_568428, JString, required = true,
                                 default = nil)
  if valid_568428 != nil:
    section.add "api-version", valid_568428
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568429: Call_JobExecutionsCancel_568419; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Requests cancellation of a job execution.
  ## 
  let valid = call_568429.validator(path, query, header, formData, body)
  let scheme = call_568429.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568429.url(scheme.get, call_568429.host, call_568429.base,
                         call_568429.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568429, url, valid)

proc call*(call_568430: Call_JobExecutionsCancel_568419; resourceGroupName: string;
          apiVersion: string; serverName: string; subscriptionId: string;
          jobAgentName: string; jobName: string; jobExecutionId: string): Recallable =
  ## jobExecutionsCancel
  ## Requests cancellation of a job execution.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   serverName: string (required)
  ##             : The name of the server.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   jobAgentName: string (required)
  ##               : The name of the job agent.
  ##   jobName: string (required)
  ##          : The name of the job.
  ##   jobExecutionId: string (required)
  ##                 : The id of the job execution to cancel.
  var path_568431 = newJObject()
  var query_568432 = newJObject()
  add(path_568431, "resourceGroupName", newJString(resourceGroupName))
  add(query_568432, "api-version", newJString(apiVersion))
  add(path_568431, "serverName", newJString(serverName))
  add(path_568431, "subscriptionId", newJString(subscriptionId))
  add(path_568431, "jobAgentName", newJString(jobAgentName))
  add(path_568431, "jobName", newJString(jobName))
  add(path_568431, "jobExecutionId", newJString(jobExecutionId))
  result = call_568430.call(path_568431, query_568432, nil, nil, nil)

var jobExecutionsCancel* = Call_JobExecutionsCancel_568419(
    name: "jobExecutionsCancel", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/servers/{serverName}/jobAgents/{jobAgentName}/jobs/{jobName}/executions/{jobExecutionId}/cancel",
    validator: validate_JobExecutionsCancel_568420, base: "",
    url: url_JobExecutionsCancel_568421, schemes: {Scheme.Https})
type
  Call_JobStepExecutionsListByJobExecution_568433 = ref object of OpenApiRestCall_567657
proc url_JobStepExecutionsListByJobExecution_568435(protocol: Scheme; host: string;
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

proc validate_JobStepExecutionsListByJobExecution_568434(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the step executions of a job execution.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   serverName: JString (required)
  ##             : The name of the server.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   jobAgentName: JString (required)
  ##               : The name of the job agent.
  ##   jobName: JString (required)
  ##          : The name of the job to get.
  ##   jobExecutionId: JString (required)
  ##                 : The id of the job execution
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568436 = path.getOrDefault("resourceGroupName")
  valid_568436 = validateParameter(valid_568436, JString, required = true,
                                 default = nil)
  if valid_568436 != nil:
    section.add "resourceGroupName", valid_568436
  var valid_568437 = path.getOrDefault("serverName")
  valid_568437 = validateParameter(valid_568437, JString, required = true,
                                 default = nil)
  if valid_568437 != nil:
    section.add "serverName", valid_568437
  var valid_568438 = path.getOrDefault("subscriptionId")
  valid_568438 = validateParameter(valid_568438, JString, required = true,
                                 default = nil)
  if valid_568438 != nil:
    section.add "subscriptionId", valid_568438
  var valid_568439 = path.getOrDefault("jobAgentName")
  valid_568439 = validateParameter(valid_568439, JString, required = true,
                                 default = nil)
  if valid_568439 != nil:
    section.add "jobAgentName", valid_568439
  var valid_568440 = path.getOrDefault("jobName")
  valid_568440 = validateParameter(valid_568440, JString, required = true,
                                 default = nil)
  if valid_568440 != nil:
    section.add "jobName", valid_568440
  var valid_568441 = path.getOrDefault("jobExecutionId")
  valid_568441 = validateParameter(valid_568441, JString, required = true,
                                 default = nil)
  if valid_568441 != nil:
    section.add "jobExecutionId", valid_568441
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  ##   $top: JInt
  ##       : The number of elements to return from the collection.
  ##   endTimeMax: JString
  ##             : If specified, only job executions completed before the specified time are included.
  ##   createTimeMax: JString
  ##                : If specified, only job executions created before the specified time are included.
  ##   $skip: JInt
  ##        : The number of elements in the collection to skip.
  ##   endTimeMin: JString
  ##             : If specified, only job executions completed at or after the specified time are included.
  ##   createTimeMin: JString
  ##                : If specified, only job executions created at or after the specified time are included.
  ##   isActive: JBool
  ##           : If specified, only active or only completed job executions are included.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568442 = query.getOrDefault("api-version")
  valid_568442 = validateParameter(valid_568442, JString, required = true,
                                 default = nil)
  if valid_568442 != nil:
    section.add "api-version", valid_568442
  var valid_568443 = query.getOrDefault("$top")
  valid_568443 = validateParameter(valid_568443, JInt, required = false, default = nil)
  if valid_568443 != nil:
    section.add "$top", valid_568443
  var valid_568444 = query.getOrDefault("endTimeMax")
  valid_568444 = validateParameter(valid_568444, JString, required = false,
                                 default = nil)
  if valid_568444 != nil:
    section.add "endTimeMax", valid_568444
  var valid_568445 = query.getOrDefault("createTimeMax")
  valid_568445 = validateParameter(valid_568445, JString, required = false,
                                 default = nil)
  if valid_568445 != nil:
    section.add "createTimeMax", valid_568445
  var valid_568446 = query.getOrDefault("$skip")
  valid_568446 = validateParameter(valid_568446, JInt, required = false, default = nil)
  if valid_568446 != nil:
    section.add "$skip", valid_568446
  var valid_568447 = query.getOrDefault("endTimeMin")
  valid_568447 = validateParameter(valid_568447, JString, required = false,
                                 default = nil)
  if valid_568447 != nil:
    section.add "endTimeMin", valid_568447
  var valid_568448 = query.getOrDefault("createTimeMin")
  valid_568448 = validateParameter(valid_568448, JString, required = false,
                                 default = nil)
  if valid_568448 != nil:
    section.add "createTimeMin", valid_568448
  var valid_568449 = query.getOrDefault("isActive")
  valid_568449 = validateParameter(valid_568449, JBool, required = false, default = nil)
  if valid_568449 != nil:
    section.add "isActive", valid_568449
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568450: Call_JobStepExecutionsListByJobExecution_568433;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the step executions of a job execution.
  ## 
  let valid = call_568450.validator(path, query, header, formData, body)
  let scheme = call_568450.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568450.url(scheme.get, call_568450.host, call_568450.base,
                         call_568450.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568450, url, valid)

proc call*(call_568451: Call_JobStepExecutionsListByJobExecution_568433;
          resourceGroupName: string; apiVersion: string; serverName: string;
          subscriptionId: string; jobAgentName: string; jobName: string;
          jobExecutionId: string; Top: int = 0; endTimeMax: string = "";
          createTimeMax: string = ""; Skip: int = 0; endTimeMin: string = "";
          createTimeMin: string = ""; isActive: bool = false): Recallable =
  ## jobStepExecutionsListByJobExecution
  ## Lists the step executions of a job execution.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   serverName: string (required)
  ##             : The name of the server.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   jobAgentName: string (required)
  ##               : The name of the job agent.
  ##   jobName: string (required)
  ##          : The name of the job to get.
  ##   Top: int
  ##      : The number of elements to return from the collection.
  ##   endTimeMax: string
  ##             : If specified, only job executions completed before the specified time are included.
  ##   createTimeMax: string
  ##                : If specified, only job executions created before the specified time are included.
  ##   Skip: int
  ##       : The number of elements in the collection to skip.
  ##   endTimeMin: string
  ##             : If specified, only job executions completed at or after the specified time are included.
  ##   jobExecutionId: string (required)
  ##                 : The id of the job execution
  ##   createTimeMin: string
  ##                : If specified, only job executions created at or after the specified time are included.
  ##   isActive: bool
  ##           : If specified, only active or only completed job executions are included.
  var path_568452 = newJObject()
  var query_568453 = newJObject()
  add(path_568452, "resourceGroupName", newJString(resourceGroupName))
  add(query_568453, "api-version", newJString(apiVersion))
  add(path_568452, "serverName", newJString(serverName))
  add(path_568452, "subscriptionId", newJString(subscriptionId))
  add(path_568452, "jobAgentName", newJString(jobAgentName))
  add(path_568452, "jobName", newJString(jobName))
  add(query_568453, "$top", newJInt(Top))
  add(query_568453, "endTimeMax", newJString(endTimeMax))
  add(query_568453, "createTimeMax", newJString(createTimeMax))
  add(query_568453, "$skip", newJInt(Skip))
  add(query_568453, "endTimeMin", newJString(endTimeMin))
  add(path_568452, "jobExecutionId", newJString(jobExecutionId))
  add(query_568453, "createTimeMin", newJString(createTimeMin))
  add(query_568453, "isActive", newJBool(isActive))
  result = call_568451.call(path_568452, query_568453, nil, nil, nil)

var jobStepExecutionsListByJobExecution* = Call_JobStepExecutionsListByJobExecution_568433(
    name: "jobStepExecutionsListByJobExecution", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/servers/{serverName}/jobAgents/{jobAgentName}/jobs/{jobName}/executions/{jobExecutionId}/steps",
    validator: validate_JobStepExecutionsListByJobExecution_568434, base: "",
    url: url_JobStepExecutionsListByJobExecution_568435, schemes: {Scheme.Https})
type
  Call_JobStepExecutionsGet_568454 = ref object of OpenApiRestCall_567657
proc url_JobStepExecutionsGet_568456(protocol: Scheme; host: string; base: string;
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

proc validate_JobStepExecutionsGet_568455(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a step execution of a job execution.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   serverName: JString (required)
  ##             : The name of the server.
  ##   stepName: JString (required)
  ##           : The name of the step.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   jobAgentName: JString (required)
  ##               : The name of the job agent.
  ##   jobName: JString (required)
  ##          : The name of the job to get.
  ##   jobExecutionId: JString (required)
  ##                 : The unique id of the job execution
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568457 = path.getOrDefault("resourceGroupName")
  valid_568457 = validateParameter(valid_568457, JString, required = true,
                                 default = nil)
  if valid_568457 != nil:
    section.add "resourceGroupName", valid_568457
  var valid_568458 = path.getOrDefault("serverName")
  valid_568458 = validateParameter(valid_568458, JString, required = true,
                                 default = nil)
  if valid_568458 != nil:
    section.add "serverName", valid_568458
  var valid_568459 = path.getOrDefault("stepName")
  valid_568459 = validateParameter(valid_568459, JString, required = true,
                                 default = nil)
  if valid_568459 != nil:
    section.add "stepName", valid_568459
  var valid_568460 = path.getOrDefault("subscriptionId")
  valid_568460 = validateParameter(valid_568460, JString, required = true,
                                 default = nil)
  if valid_568460 != nil:
    section.add "subscriptionId", valid_568460
  var valid_568461 = path.getOrDefault("jobAgentName")
  valid_568461 = validateParameter(valid_568461, JString, required = true,
                                 default = nil)
  if valid_568461 != nil:
    section.add "jobAgentName", valid_568461
  var valid_568462 = path.getOrDefault("jobName")
  valid_568462 = validateParameter(valid_568462, JString, required = true,
                                 default = nil)
  if valid_568462 != nil:
    section.add "jobName", valid_568462
  var valid_568463 = path.getOrDefault("jobExecutionId")
  valid_568463 = validateParameter(valid_568463, JString, required = true,
                                 default = nil)
  if valid_568463 != nil:
    section.add "jobExecutionId", valid_568463
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568464 = query.getOrDefault("api-version")
  valid_568464 = validateParameter(valid_568464, JString, required = true,
                                 default = nil)
  if valid_568464 != nil:
    section.add "api-version", valid_568464
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568465: Call_JobStepExecutionsGet_568454; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a step execution of a job execution.
  ## 
  let valid = call_568465.validator(path, query, header, formData, body)
  let scheme = call_568465.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568465.url(scheme.get, call_568465.host, call_568465.base,
                         call_568465.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568465, url, valid)

proc call*(call_568466: Call_JobStepExecutionsGet_568454;
          resourceGroupName: string; apiVersion: string; serverName: string;
          stepName: string; subscriptionId: string; jobAgentName: string;
          jobName: string; jobExecutionId: string): Recallable =
  ## jobStepExecutionsGet
  ## Gets a step execution of a job execution.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   serverName: string (required)
  ##             : The name of the server.
  ##   stepName: string (required)
  ##           : The name of the step.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   jobAgentName: string (required)
  ##               : The name of the job agent.
  ##   jobName: string (required)
  ##          : The name of the job to get.
  ##   jobExecutionId: string (required)
  ##                 : The unique id of the job execution
  var path_568467 = newJObject()
  var query_568468 = newJObject()
  add(path_568467, "resourceGroupName", newJString(resourceGroupName))
  add(query_568468, "api-version", newJString(apiVersion))
  add(path_568467, "serverName", newJString(serverName))
  add(path_568467, "stepName", newJString(stepName))
  add(path_568467, "subscriptionId", newJString(subscriptionId))
  add(path_568467, "jobAgentName", newJString(jobAgentName))
  add(path_568467, "jobName", newJString(jobName))
  add(path_568467, "jobExecutionId", newJString(jobExecutionId))
  result = call_568466.call(path_568467, query_568468, nil, nil, nil)

var jobStepExecutionsGet* = Call_JobStepExecutionsGet_568454(
    name: "jobStepExecutionsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/servers/{serverName}/jobAgents/{jobAgentName}/jobs/{jobName}/executions/{jobExecutionId}/steps/{stepName}",
    validator: validate_JobStepExecutionsGet_568455, base: "",
    url: url_JobStepExecutionsGet_568456, schemes: {Scheme.Https})
type
  Call_JobTargetExecutionsListByStep_568469 = ref object of OpenApiRestCall_567657
proc url_JobTargetExecutionsListByStep_568471(protocol: Scheme; host: string;
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

proc validate_JobTargetExecutionsListByStep_568470(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the target executions of a job step execution.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   serverName: JString (required)
  ##             : The name of the server.
  ##   stepName: JString (required)
  ##           : The name of the step.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   jobAgentName: JString (required)
  ##               : The name of the job agent.
  ##   jobName: JString (required)
  ##          : The name of the job to get.
  ##   jobExecutionId: JString (required)
  ##                 : The id of the job execution
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568472 = path.getOrDefault("resourceGroupName")
  valid_568472 = validateParameter(valid_568472, JString, required = true,
                                 default = nil)
  if valid_568472 != nil:
    section.add "resourceGroupName", valid_568472
  var valid_568473 = path.getOrDefault("serverName")
  valid_568473 = validateParameter(valid_568473, JString, required = true,
                                 default = nil)
  if valid_568473 != nil:
    section.add "serverName", valid_568473
  var valid_568474 = path.getOrDefault("stepName")
  valid_568474 = validateParameter(valid_568474, JString, required = true,
                                 default = nil)
  if valid_568474 != nil:
    section.add "stepName", valid_568474
  var valid_568475 = path.getOrDefault("subscriptionId")
  valid_568475 = validateParameter(valid_568475, JString, required = true,
                                 default = nil)
  if valid_568475 != nil:
    section.add "subscriptionId", valid_568475
  var valid_568476 = path.getOrDefault("jobAgentName")
  valid_568476 = validateParameter(valid_568476, JString, required = true,
                                 default = nil)
  if valid_568476 != nil:
    section.add "jobAgentName", valid_568476
  var valid_568477 = path.getOrDefault("jobName")
  valid_568477 = validateParameter(valid_568477, JString, required = true,
                                 default = nil)
  if valid_568477 != nil:
    section.add "jobName", valid_568477
  var valid_568478 = path.getOrDefault("jobExecutionId")
  valid_568478 = validateParameter(valid_568478, JString, required = true,
                                 default = nil)
  if valid_568478 != nil:
    section.add "jobExecutionId", valid_568478
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  ##   $top: JInt
  ##       : The number of elements to return from the collection.
  ##   endTimeMax: JString
  ##             : If specified, only job executions completed before the specified time are included.
  ##   createTimeMax: JString
  ##                : If specified, only job executions created before the specified time are included.
  ##   $skip: JInt
  ##        : The number of elements in the collection to skip.
  ##   endTimeMin: JString
  ##             : If specified, only job executions completed at or after the specified time are included.
  ##   createTimeMin: JString
  ##                : If specified, only job executions created at or after the specified time are included.
  ##   isActive: JBool
  ##           : If specified, only active or only completed job executions are included.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568479 = query.getOrDefault("api-version")
  valid_568479 = validateParameter(valid_568479, JString, required = true,
                                 default = nil)
  if valid_568479 != nil:
    section.add "api-version", valid_568479
  var valid_568480 = query.getOrDefault("$top")
  valid_568480 = validateParameter(valid_568480, JInt, required = false, default = nil)
  if valid_568480 != nil:
    section.add "$top", valid_568480
  var valid_568481 = query.getOrDefault("endTimeMax")
  valid_568481 = validateParameter(valid_568481, JString, required = false,
                                 default = nil)
  if valid_568481 != nil:
    section.add "endTimeMax", valid_568481
  var valid_568482 = query.getOrDefault("createTimeMax")
  valid_568482 = validateParameter(valid_568482, JString, required = false,
                                 default = nil)
  if valid_568482 != nil:
    section.add "createTimeMax", valid_568482
  var valid_568483 = query.getOrDefault("$skip")
  valid_568483 = validateParameter(valid_568483, JInt, required = false, default = nil)
  if valid_568483 != nil:
    section.add "$skip", valid_568483
  var valid_568484 = query.getOrDefault("endTimeMin")
  valid_568484 = validateParameter(valid_568484, JString, required = false,
                                 default = nil)
  if valid_568484 != nil:
    section.add "endTimeMin", valid_568484
  var valid_568485 = query.getOrDefault("createTimeMin")
  valid_568485 = validateParameter(valid_568485, JString, required = false,
                                 default = nil)
  if valid_568485 != nil:
    section.add "createTimeMin", valid_568485
  var valid_568486 = query.getOrDefault("isActive")
  valid_568486 = validateParameter(valid_568486, JBool, required = false, default = nil)
  if valid_568486 != nil:
    section.add "isActive", valid_568486
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568487: Call_JobTargetExecutionsListByStep_568469; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the target executions of a job step execution.
  ## 
  let valid = call_568487.validator(path, query, header, formData, body)
  let scheme = call_568487.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568487.url(scheme.get, call_568487.host, call_568487.base,
                         call_568487.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568487, url, valid)

proc call*(call_568488: Call_JobTargetExecutionsListByStep_568469;
          resourceGroupName: string; apiVersion: string; serverName: string;
          stepName: string; subscriptionId: string; jobAgentName: string;
          jobName: string; jobExecutionId: string; Top: int = 0;
          endTimeMax: string = ""; createTimeMax: string = ""; Skip: int = 0;
          endTimeMin: string = ""; createTimeMin: string = ""; isActive: bool = false): Recallable =
  ## jobTargetExecutionsListByStep
  ## Lists the target executions of a job step execution.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   serverName: string (required)
  ##             : The name of the server.
  ##   stepName: string (required)
  ##           : The name of the step.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   jobAgentName: string (required)
  ##               : The name of the job agent.
  ##   jobName: string (required)
  ##          : The name of the job to get.
  ##   Top: int
  ##      : The number of elements to return from the collection.
  ##   endTimeMax: string
  ##             : If specified, only job executions completed before the specified time are included.
  ##   createTimeMax: string
  ##                : If specified, only job executions created before the specified time are included.
  ##   Skip: int
  ##       : The number of elements in the collection to skip.
  ##   endTimeMin: string
  ##             : If specified, only job executions completed at or after the specified time are included.
  ##   jobExecutionId: string (required)
  ##                 : The id of the job execution
  ##   createTimeMin: string
  ##                : If specified, only job executions created at or after the specified time are included.
  ##   isActive: bool
  ##           : If specified, only active or only completed job executions are included.
  var path_568489 = newJObject()
  var query_568490 = newJObject()
  add(path_568489, "resourceGroupName", newJString(resourceGroupName))
  add(query_568490, "api-version", newJString(apiVersion))
  add(path_568489, "serverName", newJString(serverName))
  add(path_568489, "stepName", newJString(stepName))
  add(path_568489, "subscriptionId", newJString(subscriptionId))
  add(path_568489, "jobAgentName", newJString(jobAgentName))
  add(path_568489, "jobName", newJString(jobName))
  add(query_568490, "$top", newJInt(Top))
  add(query_568490, "endTimeMax", newJString(endTimeMax))
  add(query_568490, "createTimeMax", newJString(createTimeMax))
  add(query_568490, "$skip", newJInt(Skip))
  add(query_568490, "endTimeMin", newJString(endTimeMin))
  add(path_568489, "jobExecutionId", newJString(jobExecutionId))
  add(query_568490, "createTimeMin", newJString(createTimeMin))
  add(query_568490, "isActive", newJBool(isActive))
  result = call_568488.call(path_568489, query_568490, nil, nil, nil)

var jobTargetExecutionsListByStep* = Call_JobTargetExecutionsListByStep_568469(
    name: "jobTargetExecutionsListByStep", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/servers/{serverName}/jobAgents/{jobAgentName}/jobs/{jobName}/executions/{jobExecutionId}/steps/{stepName}/targets",
    validator: validate_JobTargetExecutionsListByStep_568470, base: "",
    url: url_JobTargetExecutionsListByStep_568471, schemes: {Scheme.Https})
type
  Call_JobTargetExecutionsGet_568491 = ref object of OpenApiRestCall_567657
proc url_JobTargetExecutionsGet_568493(protocol: Scheme; host: string; base: string;
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

proc validate_JobTargetExecutionsGet_568492(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a target execution.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   serverName: JString (required)
  ##             : The name of the server.
  ##   stepName: JString (required)
  ##           : The name of the step.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   jobAgentName: JString (required)
  ##               : The name of the job agent.
  ##   jobName: JString (required)
  ##          : The name of the job to get.
  ##   jobExecutionId: JString (required)
  ##                 : The unique id of the job execution
  ##   targetId: JString (required)
  ##           : The target id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568494 = path.getOrDefault("resourceGroupName")
  valid_568494 = validateParameter(valid_568494, JString, required = true,
                                 default = nil)
  if valid_568494 != nil:
    section.add "resourceGroupName", valid_568494
  var valid_568495 = path.getOrDefault("serverName")
  valid_568495 = validateParameter(valid_568495, JString, required = true,
                                 default = nil)
  if valid_568495 != nil:
    section.add "serverName", valid_568495
  var valid_568496 = path.getOrDefault("stepName")
  valid_568496 = validateParameter(valid_568496, JString, required = true,
                                 default = nil)
  if valid_568496 != nil:
    section.add "stepName", valid_568496
  var valid_568497 = path.getOrDefault("subscriptionId")
  valid_568497 = validateParameter(valid_568497, JString, required = true,
                                 default = nil)
  if valid_568497 != nil:
    section.add "subscriptionId", valid_568497
  var valid_568498 = path.getOrDefault("jobAgentName")
  valid_568498 = validateParameter(valid_568498, JString, required = true,
                                 default = nil)
  if valid_568498 != nil:
    section.add "jobAgentName", valid_568498
  var valid_568499 = path.getOrDefault("jobName")
  valid_568499 = validateParameter(valid_568499, JString, required = true,
                                 default = nil)
  if valid_568499 != nil:
    section.add "jobName", valid_568499
  var valid_568500 = path.getOrDefault("jobExecutionId")
  valid_568500 = validateParameter(valid_568500, JString, required = true,
                                 default = nil)
  if valid_568500 != nil:
    section.add "jobExecutionId", valid_568500
  var valid_568501 = path.getOrDefault("targetId")
  valid_568501 = validateParameter(valid_568501, JString, required = true,
                                 default = nil)
  if valid_568501 != nil:
    section.add "targetId", valid_568501
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568502 = query.getOrDefault("api-version")
  valid_568502 = validateParameter(valid_568502, JString, required = true,
                                 default = nil)
  if valid_568502 != nil:
    section.add "api-version", valid_568502
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568503: Call_JobTargetExecutionsGet_568491; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a target execution.
  ## 
  let valid = call_568503.validator(path, query, header, formData, body)
  let scheme = call_568503.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568503.url(scheme.get, call_568503.host, call_568503.base,
                         call_568503.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568503, url, valid)

proc call*(call_568504: Call_JobTargetExecutionsGet_568491;
          resourceGroupName: string; apiVersion: string; serverName: string;
          stepName: string; subscriptionId: string; jobAgentName: string;
          jobName: string; jobExecutionId: string; targetId: string): Recallable =
  ## jobTargetExecutionsGet
  ## Gets a target execution.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   serverName: string (required)
  ##             : The name of the server.
  ##   stepName: string (required)
  ##           : The name of the step.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   jobAgentName: string (required)
  ##               : The name of the job agent.
  ##   jobName: string (required)
  ##          : The name of the job to get.
  ##   jobExecutionId: string (required)
  ##                 : The unique id of the job execution
  ##   targetId: string (required)
  ##           : The target id.
  var path_568505 = newJObject()
  var query_568506 = newJObject()
  add(path_568505, "resourceGroupName", newJString(resourceGroupName))
  add(query_568506, "api-version", newJString(apiVersion))
  add(path_568505, "serverName", newJString(serverName))
  add(path_568505, "stepName", newJString(stepName))
  add(path_568505, "subscriptionId", newJString(subscriptionId))
  add(path_568505, "jobAgentName", newJString(jobAgentName))
  add(path_568505, "jobName", newJString(jobName))
  add(path_568505, "jobExecutionId", newJString(jobExecutionId))
  add(path_568505, "targetId", newJString(targetId))
  result = call_568504.call(path_568505, query_568506, nil, nil, nil)

var jobTargetExecutionsGet* = Call_JobTargetExecutionsGet_568491(
    name: "jobTargetExecutionsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/servers/{serverName}/jobAgents/{jobAgentName}/jobs/{jobName}/executions/{jobExecutionId}/steps/{stepName}/targets/{targetId}",
    validator: validate_JobTargetExecutionsGet_568492, base: "",
    url: url_JobTargetExecutionsGet_568493, schemes: {Scheme.Https})
type
  Call_JobTargetExecutionsListByJobExecution_568507 = ref object of OpenApiRestCall_567657
proc url_JobTargetExecutionsListByJobExecution_568509(protocol: Scheme;
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

proc validate_JobTargetExecutionsListByJobExecution_568508(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists target executions for all steps of a job execution.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   serverName: JString (required)
  ##             : The name of the server.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   jobAgentName: JString (required)
  ##               : The name of the job agent.
  ##   jobName: JString (required)
  ##          : The name of the job to get.
  ##   jobExecutionId: JString (required)
  ##                 : The id of the job execution
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568510 = path.getOrDefault("resourceGroupName")
  valid_568510 = validateParameter(valid_568510, JString, required = true,
                                 default = nil)
  if valid_568510 != nil:
    section.add "resourceGroupName", valid_568510
  var valid_568511 = path.getOrDefault("serverName")
  valid_568511 = validateParameter(valid_568511, JString, required = true,
                                 default = nil)
  if valid_568511 != nil:
    section.add "serverName", valid_568511
  var valid_568512 = path.getOrDefault("subscriptionId")
  valid_568512 = validateParameter(valid_568512, JString, required = true,
                                 default = nil)
  if valid_568512 != nil:
    section.add "subscriptionId", valid_568512
  var valid_568513 = path.getOrDefault("jobAgentName")
  valid_568513 = validateParameter(valid_568513, JString, required = true,
                                 default = nil)
  if valid_568513 != nil:
    section.add "jobAgentName", valid_568513
  var valid_568514 = path.getOrDefault("jobName")
  valid_568514 = validateParameter(valid_568514, JString, required = true,
                                 default = nil)
  if valid_568514 != nil:
    section.add "jobName", valid_568514
  var valid_568515 = path.getOrDefault("jobExecutionId")
  valid_568515 = validateParameter(valid_568515, JString, required = true,
                                 default = nil)
  if valid_568515 != nil:
    section.add "jobExecutionId", valid_568515
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  ##   $top: JInt
  ##       : The number of elements to return from the collection.
  ##   endTimeMax: JString
  ##             : If specified, only job executions completed before the specified time are included.
  ##   createTimeMax: JString
  ##                : If specified, only job executions created before the specified time are included.
  ##   $skip: JInt
  ##        : The number of elements in the collection to skip.
  ##   endTimeMin: JString
  ##             : If specified, only job executions completed at or after the specified time are included.
  ##   createTimeMin: JString
  ##                : If specified, only job executions created at or after the specified time are included.
  ##   isActive: JBool
  ##           : If specified, only active or only completed job executions are included.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568516 = query.getOrDefault("api-version")
  valid_568516 = validateParameter(valid_568516, JString, required = true,
                                 default = nil)
  if valid_568516 != nil:
    section.add "api-version", valid_568516
  var valid_568517 = query.getOrDefault("$top")
  valid_568517 = validateParameter(valid_568517, JInt, required = false, default = nil)
  if valid_568517 != nil:
    section.add "$top", valid_568517
  var valid_568518 = query.getOrDefault("endTimeMax")
  valid_568518 = validateParameter(valid_568518, JString, required = false,
                                 default = nil)
  if valid_568518 != nil:
    section.add "endTimeMax", valid_568518
  var valid_568519 = query.getOrDefault("createTimeMax")
  valid_568519 = validateParameter(valid_568519, JString, required = false,
                                 default = nil)
  if valid_568519 != nil:
    section.add "createTimeMax", valid_568519
  var valid_568520 = query.getOrDefault("$skip")
  valid_568520 = validateParameter(valid_568520, JInt, required = false, default = nil)
  if valid_568520 != nil:
    section.add "$skip", valid_568520
  var valid_568521 = query.getOrDefault("endTimeMin")
  valid_568521 = validateParameter(valid_568521, JString, required = false,
                                 default = nil)
  if valid_568521 != nil:
    section.add "endTimeMin", valid_568521
  var valid_568522 = query.getOrDefault("createTimeMin")
  valid_568522 = validateParameter(valid_568522, JString, required = false,
                                 default = nil)
  if valid_568522 != nil:
    section.add "createTimeMin", valid_568522
  var valid_568523 = query.getOrDefault("isActive")
  valid_568523 = validateParameter(valid_568523, JBool, required = false, default = nil)
  if valid_568523 != nil:
    section.add "isActive", valid_568523
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568524: Call_JobTargetExecutionsListByJobExecution_568507;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists target executions for all steps of a job execution.
  ## 
  let valid = call_568524.validator(path, query, header, formData, body)
  let scheme = call_568524.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568524.url(scheme.get, call_568524.host, call_568524.base,
                         call_568524.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568524, url, valid)

proc call*(call_568525: Call_JobTargetExecutionsListByJobExecution_568507;
          resourceGroupName: string; apiVersion: string; serverName: string;
          subscriptionId: string; jobAgentName: string; jobName: string;
          jobExecutionId: string; Top: int = 0; endTimeMax: string = "";
          createTimeMax: string = ""; Skip: int = 0; endTimeMin: string = "";
          createTimeMin: string = ""; isActive: bool = false): Recallable =
  ## jobTargetExecutionsListByJobExecution
  ## Lists target executions for all steps of a job execution.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   serverName: string (required)
  ##             : The name of the server.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   jobAgentName: string (required)
  ##               : The name of the job agent.
  ##   jobName: string (required)
  ##          : The name of the job to get.
  ##   Top: int
  ##      : The number of elements to return from the collection.
  ##   endTimeMax: string
  ##             : If specified, only job executions completed before the specified time are included.
  ##   createTimeMax: string
  ##                : If specified, only job executions created before the specified time are included.
  ##   Skip: int
  ##       : The number of elements in the collection to skip.
  ##   endTimeMin: string
  ##             : If specified, only job executions completed at or after the specified time are included.
  ##   jobExecutionId: string (required)
  ##                 : The id of the job execution
  ##   createTimeMin: string
  ##                : If specified, only job executions created at or after the specified time are included.
  ##   isActive: bool
  ##           : If specified, only active or only completed job executions are included.
  var path_568526 = newJObject()
  var query_568527 = newJObject()
  add(path_568526, "resourceGroupName", newJString(resourceGroupName))
  add(query_568527, "api-version", newJString(apiVersion))
  add(path_568526, "serverName", newJString(serverName))
  add(path_568526, "subscriptionId", newJString(subscriptionId))
  add(path_568526, "jobAgentName", newJString(jobAgentName))
  add(path_568526, "jobName", newJString(jobName))
  add(query_568527, "$top", newJInt(Top))
  add(query_568527, "endTimeMax", newJString(endTimeMax))
  add(query_568527, "createTimeMax", newJString(createTimeMax))
  add(query_568527, "$skip", newJInt(Skip))
  add(query_568527, "endTimeMin", newJString(endTimeMin))
  add(path_568526, "jobExecutionId", newJString(jobExecutionId))
  add(query_568527, "createTimeMin", newJString(createTimeMin))
  add(query_568527, "isActive", newJBool(isActive))
  result = call_568525.call(path_568526, query_568527, nil, nil, nil)

var jobTargetExecutionsListByJobExecution* = Call_JobTargetExecutionsListByJobExecution_568507(
    name: "jobTargetExecutionsListByJobExecution", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/servers/{serverName}/jobAgents/{jobAgentName}/jobs/{jobName}/executions/{jobExecutionId}/targets",
    validator: validate_JobTargetExecutionsListByJobExecution_568508, base: "",
    url: url_JobTargetExecutionsListByJobExecution_568509, schemes: {Scheme.Https})
type
  Call_JobExecutionsCreate_568528 = ref object of OpenApiRestCall_567657
proc url_JobExecutionsCreate_568530(protocol: Scheme; host: string; base: string;
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

proc validate_JobExecutionsCreate_568529(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Starts an elastic job execution.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   serverName: JString (required)
  ##             : The name of the server.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   jobAgentName: JString (required)
  ##               : The name of the job agent.
  ##   jobName: JString (required)
  ##          : The name of the job to get.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568531 = path.getOrDefault("resourceGroupName")
  valid_568531 = validateParameter(valid_568531, JString, required = true,
                                 default = nil)
  if valid_568531 != nil:
    section.add "resourceGroupName", valid_568531
  var valid_568532 = path.getOrDefault("serverName")
  valid_568532 = validateParameter(valid_568532, JString, required = true,
                                 default = nil)
  if valid_568532 != nil:
    section.add "serverName", valid_568532
  var valid_568533 = path.getOrDefault("subscriptionId")
  valid_568533 = validateParameter(valid_568533, JString, required = true,
                                 default = nil)
  if valid_568533 != nil:
    section.add "subscriptionId", valid_568533
  var valid_568534 = path.getOrDefault("jobAgentName")
  valid_568534 = validateParameter(valid_568534, JString, required = true,
                                 default = nil)
  if valid_568534 != nil:
    section.add "jobAgentName", valid_568534
  var valid_568535 = path.getOrDefault("jobName")
  valid_568535 = validateParameter(valid_568535, JString, required = true,
                                 default = nil)
  if valid_568535 != nil:
    section.add "jobName", valid_568535
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568536 = query.getOrDefault("api-version")
  valid_568536 = validateParameter(valid_568536, JString, required = true,
                                 default = nil)
  if valid_568536 != nil:
    section.add "api-version", valid_568536
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568537: Call_JobExecutionsCreate_568528; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Starts an elastic job execution.
  ## 
  let valid = call_568537.validator(path, query, header, formData, body)
  let scheme = call_568537.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568537.url(scheme.get, call_568537.host, call_568537.base,
                         call_568537.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568537, url, valid)

proc call*(call_568538: Call_JobExecutionsCreate_568528; resourceGroupName: string;
          apiVersion: string; serverName: string; subscriptionId: string;
          jobAgentName: string; jobName: string): Recallable =
  ## jobExecutionsCreate
  ## Starts an elastic job execution.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   serverName: string (required)
  ##             : The name of the server.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   jobAgentName: string (required)
  ##               : The name of the job agent.
  ##   jobName: string (required)
  ##          : The name of the job to get.
  var path_568539 = newJObject()
  var query_568540 = newJObject()
  add(path_568539, "resourceGroupName", newJString(resourceGroupName))
  add(query_568540, "api-version", newJString(apiVersion))
  add(path_568539, "serverName", newJString(serverName))
  add(path_568539, "subscriptionId", newJString(subscriptionId))
  add(path_568539, "jobAgentName", newJString(jobAgentName))
  add(path_568539, "jobName", newJString(jobName))
  result = call_568538.call(path_568539, query_568540, nil, nil, nil)

var jobExecutionsCreate* = Call_JobExecutionsCreate_568528(
    name: "jobExecutionsCreate", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/servers/{serverName}/jobAgents/{jobAgentName}/jobs/{jobName}/start",
    validator: validate_JobExecutionsCreate_568529, base: "",
    url: url_JobExecutionsCreate_568530, schemes: {Scheme.Https})
type
  Call_JobStepsListByJob_568541 = ref object of OpenApiRestCall_567657
proc url_JobStepsListByJob_568543(protocol: Scheme; host: string; base: string;
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

proc validate_JobStepsListByJob_568542(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Gets all job steps for a job's current version.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   serverName: JString (required)
  ##             : The name of the server.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   jobAgentName: JString (required)
  ##               : The name of the job agent.
  ##   jobName: JString (required)
  ##          : The name of the job to get.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568544 = path.getOrDefault("resourceGroupName")
  valid_568544 = validateParameter(valid_568544, JString, required = true,
                                 default = nil)
  if valid_568544 != nil:
    section.add "resourceGroupName", valid_568544
  var valid_568545 = path.getOrDefault("serverName")
  valid_568545 = validateParameter(valid_568545, JString, required = true,
                                 default = nil)
  if valid_568545 != nil:
    section.add "serverName", valid_568545
  var valid_568546 = path.getOrDefault("subscriptionId")
  valid_568546 = validateParameter(valid_568546, JString, required = true,
                                 default = nil)
  if valid_568546 != nil:
    section.add "subscriptionId", valid_568546
  var valid_568547 = path.getOrDefault("jobAgentName")
  valid_568547 = validateParameter(valid_568547, JString, required = true,
                                 default = nil)
  if valid_568547 != nil:
    section.add "jobAgentName", valid_568547
  var valid_568548 = path.getOrDefault("jobName")
  valid_568548 = validateParameter(valid_568548, JString, required = true,
                                 default = nil)
  if valid_568548 != nil:
    section.add "jobName", valid_568548
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568549 = query.getOrDefault("api-version")
  valid_568549 = validateParameter(valid_568549, JString, required = true,
                                 default = nil)
  if valid_568549 != nil:
    section.add "api-version", valid_568549
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568550: Call_JobStepsListByJob_568541; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all job steps for a job's current version.
  ## 
  let valid = call_568550.validator(path, query, header, formData, body)
  let scheme = call_568550.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568550.url(scheme.get, call_568550.host, call_568550.base,
                         call_568550.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568550, url, valid)

proc call*(call_568551: Call_JobStepsListByJob_568541; resourceGroupName: string;
          apiVersion: string; serverName: string; subscriptionId: string;
          jobAgentName: string; jobName: string): Recallable =
  ## jobStepsListByJob
  ## Gets all job steps for a job's current version.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   serverName: string (required)
  ##             : The name of the server.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   jobAgentName: string (required)
  ##               : The name of the job agent.
  ##   jobName: string (required)
  ##          : The name of the job to get.
  var path_568552 = newJObject()
  var query_568553 = newJObject()
  add(path_568552, "resourceGroupName", newJString(resourceGroupName))
  add(query_568553, "api-version", newJString(apiVersion))
  add(path_568552, "serverName", newJString(serverName))
  add(path_568552, "subscriptionId", newJString(subscriptionId))
  add(path_568552, "jobAgentName", newJString(jobAgentName))
  add(path_568552, "jobName", newJString(jobName))
  result = call_568551.call(path_568552, query_568553, nil, nil, nil)

var jobStepsListByJob* = Call_JobStepsListByJob_568541(name: "jobStepsListByJob",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/servers/{serverName}/jobAgents/{jobAgentName}/jobs/{jobName}/steps",
    validator: validate_JobStepsListByJob_568542, base: "",
    url: url_JobStepsListByJob_568543, schemes: {Scheme.Https})
type
  Call_JobStepsCreateOrUpdate_568568 = ref object of OpenApiRestCall_567657
proc url_JobStepsCreateOrUpdate_568570(protocol: Scheme; host: string; base: string;
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

proc validate_JobStepsCreateOrUpdate_568569(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates a job step. This will implicitly create a new job version.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   serverName: JString (required)
  ##             : The name of the server.
  ##   stepName: JString (required)
  ##           : The name of the job step.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   jobAgentName: JString (required)
  ##               : The name of the job agent.
  ##   jobName: JString (required)
  ##          : The name of the job.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568571 = path.getOrDefault("resourceGroupName")
  valid_568571 = validateParameter(valid_568571, JString, required = true,
                                 default = nil)
  if valid_568571 != nil:
    section.add "resourceGroupName", valid_568571
  var valid_568572 = path.getOrDefault("serverName")
  valid_568572 = validateParameter(valid_568572, JString, required = true,
                                 default = nil)
  if valid_568572 != nil:
    section.add "serverName", valid_568572
  var valid_568573 = path.getOrDefault("stepName")
  valid_568573 = validateParameter(valid_568573, JString, required = true,
                                 default = nil)
  if valid_568573 != nil:
    section.add "stepName", valid_568573
  var valid_568574 = path.getOrDefault("subscriptionId")
  valid_568574 = validateParameter(valid_568574, JString, required = true,
                                 default = nil)
  if valid_568574 != nil:
    section.add "subscriptionId", valid_568574
  var valid_568575 = path.getOrDefault("jobAgentName")
  valid_568575 = validateParameter(valid_568575, JString, required = true,
                                 default = nil)
  if valid_568575 != nil:
    section.add "jobAgentName", valid_568575
  var valid_568576 = path.getOrDefault("jobName")
  valid_568576 = validateParameter(valid_568576, JString, required = true,
                                 default = nil)
  if valid_568576 != nil:
    section.add "jobName", valid_568576
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568577 = query.getOrDefault("api-version")
  valid_568577 = validateParameter(valid_568577, JString, required = true,
                                 default = nil)
  if valid_568577 != nil:
    section.add "api-version", valid_568577
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

proc call*(call_568579: Call_JobStepsCreateOrUpdate_568568; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates a job step. This will implicitly create a new job version.
  ## 
  let valid = call_568579.validator(path, query, header, formData, body)
  let scheme = call_568579.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568579.url(scheme.get, call_568579.host, call_568579.base,
                         call_568579.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568579, url, valid)

proc call*(call_568580: Call_JobStepsCreateOrUpdate_568568;
          resourceGroupName: string; apiVersion: string; serverName: string;
          stepName: string; subscriptionId: string; jobAgentName: string;
          jobName: string; parameters: JsonNode): Recallable =
  ## jobStepsCreateOrUpdate
  ## Creates or updates a job step. This will implicitly create a new job version.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   serverName: string (required)
  ##             : The name of the server.
  ##   stepName: string (required)
  ##           : The name of the job step.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   jobAgentName: string (required)
  ##               : The name of the job agent.
  ##   jobName: string (required)
  ##          : The name of the job.
  ##   parameters: JObject (required)
  ##             : The requested state of the job step.
  var path_568581 = newJObject()
  var query_568582 = newJObject()
  var body_568583 = newJObject()
  add(path_568581, "resourceGroupName", newJString(resourceGroupName))
  add(query_568582, "api-version", newJString(apiVersion))
  add(path_568581, "serverName", newJString(serverName))
  add(path_568581, "stepName", newJString(stepName))
  add(path_568581, "subscriptionId", newJString(subscriptionId))
  add(path_568581, "jobAgentName", newJString(jobAgentName))
  add(path_568581, "jobName", newJString(jobName))
  if parameters != nil:
    body_568583 = parameters
  result = call_568580.call(path_568581, query_568582, nil, nil, body_568583)

var jobStepsCreateOrUpdate* = Call_JobStepsCreateOrUpdate_568568(
    name: "jobStepsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/servers/{serverName}/jobAgents/{jobAgentName}/jobs/{jobName}/steps/{stepName}",
    validator: validate_JobStepsCreateOrUpdate_568569, base: "",
    url: url_JobStepsCreateOrUpdate_568570, schemes: {Scheme.Https})
type
  Call_JobStepsGet_568554 = ref object of OpenApiRestCall_567657
proc url_JobStepsGet_568556(protocol: Scheme; host: string; base: string;
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

proc validate_JobStepsGet_568555(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a job step in a job's current version.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   serverName: JString (required)
  ##             : The name of the server.
  ##   stepName: JString (required)
  ##           : The name of the job step.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   jobAgentName: JString (required)
  ##               : The name of the job agent.
  ##   jobName: JString (required)
  ##          : The name of the job.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568557 = path.getOrDefault("resourceGroupName")
  valid_568557 = validateParameter(valid_568557, JString, required = true,
                                 default = nil)
  if valid_568557 != nil:
    section.add "resourceGroupName", valid_568557
  var valid_568558 = path.getOrDefault("serverName")
  valid_568558 = validateParameter(valid_568558, JString, required = true,
                                 default = nil)
  if valid_568558 != nil:
    section.add "serverName", valid_568558
  var valid_568559 = path.getOrDefault("stepName")
  valid_568559 = validateParameter(valid_568559, JString, required = true,
                                 default = nil)
  if valid_568559 != nil:
    section.add "stepName", valid_568559
  var valid_568560 = path.getOrDefault("subscriptionId")
  valid_568560 = validateParameter(valid_568560, JString, required = true,
                                 default = nil)
  if valid_568560 != nil:
    section.add "subscriptionId", valid_568560
  var valid_568561 = path.getOrDefault("jobAgentName")
  valid_568561 = validateParameter(valid_568561, JString, required = true,
                                 default = nil)
  if valid_568561 != nil:
    section.add "jobAgentName", valid_568561
  var valid_568562 = path.getOrDefault("jobName")
  valid_568562 = validateParameter(valid_568562, JString, required = true,
                                 default = nil)
  if valid_568562 != nil:
    section.add "jobName", valid_568562
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568563 = query.getOrDefault("api-version")
  valid_568563 = validateParameter(valid_568563, JString, required = true,
                                 default = nil)
  if valid_568563 != nil:
    section.add "api-version", valid_568563
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568564: Call_JobStepsGet_568554; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a job step in a job's current version.
  ## 
  let valid = call_568564.validator(path, query, header, formData, body)
  let scheme = call_568564.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568564.url(scheme.get, call_568564.host, call_568564.base,
                         call_568564.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568564, url, valid)

proc call*(call_568565: Call_JobStepsGet_568554; resourceGroupName: string;
          apiVersion: string; serverName: string; stepName: string;
          subscriptionId: string; jobAgentName: string; jobName: string): Recallable =
  ## jobStepsGet
  ## Gets a job step in a job's current version.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   serverName: string (required)
  ##             : The name of the server.
  ##   stepName: string (required)
  ##           : The name of the job step.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   jobAgentName: string (required)
  ##               : The name of the job agent.
  ##   jobName: string (required)
  ##          : The name of the job.
  var path_568566 = newJObject()
  var query_568567 = newJObject()
  add(path_568566, "resourceGroupName", newJString(resourceGroupName))
  add(query_568567, "api-version", newJString(apiVersion))
  add(path_568566, "serverName", newJString(serverName))
  add(path_568566, "stepName", newJString(stepName))
  add(path_568566, "subscriptionId", newJString(subscriptionId))
  add(path_568566, "jobAgentName", newJString(jobAgentName))
  add(path_568566, "jobName", newJString(jobName))
  result = call_568565.call(path_568566, query_568567, nil, nil, nil)

var jobStepsGet* = Call_JobStepsGet_568554(name: "jobStepsGet",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/servers/{serverName}/jobAgents/{jobAgentName}/jobs/{jobName}/steps/{stepName}",
                                        validator: validate_JobStepsGet_568555,
                                        base: "", url: url_JobStepsGet_568556,
                                        schemes: {Scheme.Https})
type
  Call_JobStepsDelete_568584 = ref object of OpenApiRestCall_567657
proc url_JobStepsDelete_568586(protocol: Scheme; host: string; base: string;
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

proc validate_JobStepsDelete_568585(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Deletes a job step. This will implicitly create a new job version.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   serverName: JString (required)
  ##             : The name of the server.
  ##   stepName: JString (required)
  ##           : The name of the job step to delete.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   jobAgentName: JString (required)
  ##               : The name of the job agent.
  ##   jobName: JString (required)
  ##          : The name of the job.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568587 = path.getOrDefault("resourceGroupName")
  valid_568587 = validateParameter(valid_568587, JString, required = true,
                                 default = nil)
  if valid_568587 != nil:
    section.add "resourceGroupName", valid_568587
  var valid_568588 = path.getOrDefault("serverName")
  valid_568588 = validateParameter(valid_568588, JString, required = true,
                                 default = nil)
  if valid_568588 != nil:
    section.add "serverName", valid_568588
  var valid_568589 = path.getOrDefault("stepName")
  valid_568589 = validateParameter(valid_568589, JString, required = true,
                                 default = nil)
  if valid_568589 != nil:
    section.add "stepName", valid_568589
  var valid_568590 = path.getOrDefault("subscriptionId")
  valid_568590 = validateParameter(valid_568590, JString, required = true,
                                 default = nil)
  if valid_568590 != nil:
    section.add "subscriptionId", valid_568590
  var valid_568591 = path.getOrDefault("jobAgentName")
  valid_568591 = validateParameter(valid_568591, JString, required = true,
                                 default = nil)
  if valid_568591 != nil:
    section.add "jobAgentName", valid_568591
  var valid_568592 = path.getOrDefault("jobName")
  valid_568592 = validateParameter(valid_568592, JString, required = true,
                                 default = nil)
  if valid_568592 != nil:
    section.add "jobName", valid_568592
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568593 = query.getOrDefault("api-version")
  valid_568593 = validateParameter(valid_568593, JString, required = true,
                                 default = nil)
  if valid_568593 != nil:
    section.add "api-version", valid_568593
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568594: Call_JobStepsDelete_568584; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a job step. This will implicitly create a new job version.
  ## 
  let valid = call_568594.validator(path, query, header, formData, body)
  let scheme = call_568594.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568594.url(scheme.get, call_568594.host, call_568594.base,
                         call_568594.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568594, url, valid)

proc call*(call_568595: Call_JobStepsDelete_568584; resourceGroupName: string;
          apiVersion: string; serverName: string; stepName: string;
          subscriptionId: string; jobAgentName: string; jobName: string): Recallable =
  ## jobStepsDelete
  ## Deletes a job step. This will implicitly create a new job version.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   serverName: string (required)
  ##             : The name of the server.
  ##   stepName: string (required)
  ##           : The name of the job step to delete.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   jobAgentName: string (required)
  ##               : The name of the job agent.
  ##   jobName: string (required)
  ##          : The name of the job.
  var path_568596 = newJObject()
  var query_568597 = newJObject()
  add(path_568596, "resourceGroupName", newJString(resourceGroupName))
  add(query_568597, "api-version", newJString(apiVersion))
  add(path_568596, "serverName", newJString(serverName))
  add(path_568596, "stepName", newJString(stepName))
  add(path_568596, "subscriptionId", newJString(subscriptionId))
  add(path_568596, "jobAgentName", newJString(jobAgentName))
  add(path_568596, "jobName", newJString(jobName))
  result = call_568595.call(path_568596, query_568597, nil, nil, nil)

var jobStepsDelete* = Call_JobStepsDelete_568584(name: "jobStepsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/servers/{serverName}/jobAgents/{jobAgentName}/jobs/{jobName}/steps/{stepName}",
    validator: validate_JobStepsDelete_568585, base: "", url: url_JobStepsDelete_568586,
    schemes: {Scheme.Https})
type
  Call_JobVersionsListByJob_568598 = ref object of OpenApiRestCall_567657
proc url_JobVersionsListByJob_568600(protocol: Scheme; host: string; base: string;
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

proc validate_JobVersionsListByJob_568599(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all versions of a job.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   serverName: JString (required)
  ##             : The name of the server.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   jobAgentName: JString (required)
  ##               : The name of the job agent.
  ##   jobName: JString (required)
  ##          : The name of the job to get.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568601 = path.getOrDefault("resourceGroupName")
  valid_568601 = validateParameter(valid_568601, JString, required = true,
                                 default = nil)
  if valid_568601 != nil:
    section.add "resourceGroupName", valid_568601
  var valid_568602 = path.getOrDefault("serverName")
  valid_568602 = validateParameter(valid_568602, JString, required = true,
                                 default = nil)
  if valid_568602 != nil:
    section.add "serverName", valid_568602
  var valid_568603 = path.getOrDefault("subscriptionId")
  valid_568603 = validateParameter(valid_568603, JString, required = true,
                                 default = nil)
  if valid_568603 != nil:
    section.add "subscriptionId", valid_568603
  var valid_568604 = path.getOrDefault("jobAgentName")
  valid_568604 = validateParameter(valid_568604, JString, required = true,
                                 default = nil)
  if valid_568604 != nil:
    section.add "jobAgentName", valid_568604
  var valid_568605 = path.getOrDefault("jobName")
  valid_568605 = validateParameter(valid_568605, JString, required = true,
                                 default = nil)
  if valid_568605 != nil:
    section.add "jobName", valid_568605
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568606 = query.getOrDefault("api-version")
  valid_568606 = validateParameter(valid_568606, JString, required = true,
                                 default = nil)
  if valid_568606 != nil:
    section.add "api-version", valid_568606
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568607: Call_JobVersionsListByJob_568598; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all versions of a job.
  ## 
  let valid = call_568607.validator(path, query, header, formData, body)
  let scheme = call_568607.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568607.url(scheme.get, call_568607.host, call_568607.base,
                         call_568607.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568607, url, valid)

proc call*(call_568608: Call_JobVersionsListByJob_568598;
          resourceGroupName: string; apiVersion: string; serverName: string;
          subscriptionId: string; jobAgentName: string; jobName: string): Recallable =
  ## jobVersionsListByJob
  ## Gets all versions of a job.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   serverName: string (required)
  ##             : The name of the server.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   jobAgentName: string (required)
  ##               : The name of the job agent.
  ##   jobName: string (required)
  ##          : The name of the job to get.
  var path_568609 = newJObject()
  var query_568610 = newJObject()
  add(path_568609, "resourceGroupName", newJString(resourceGroupName))
  add(query_568610, "api-version", newJString(apiVersion))
  add(path_568609, "serverName", newJString(serverName))
  add(path_568609, "subscriptionId", newJString(subscriptionId))
  add(path_568609, "jobAgentName", newJString(jobAgentName))
  add(path_568609, "jobName", newJString(jobName))
  result = call_568608.call(path_568609, query_568610, nil, nil, nil)

var jobVersionsListByJob* = Call_JobVersionsListByJob_568598(
    name: "jobVersionsListByJob", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/servers/{serverName}/jobAgents/{jobAgentName}/jobs/{jobName}/versions",
    validator: validate_JobVersionsListByJob_568599, base: "",
    url: url_JobVersionsListByJob_568600, schemes: {Scheme.Https})
type
  Call_JobVersionsGet_568611 = ref object of OpenApiRestCall_567657
proc url_JobVersionsGet_568613(protocol: Scheme; host: string; base: string;
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

proc validate_JobVersionsGet_568612(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Gets a job version.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   serverName: JString (required)
  ##             : The name of the server.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   jobAgentName: JString (required)
  ##               : The name of the job agent.
  ##   jobName: JString (required)
  ##          : The name of the job.
  ##   jobVersion: JInt (required)
  ##             : The version of the job to get.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568614 = path.getOrDefault("resourceGroupName")
  valid_568614 = validateParameter(valid_568614, JString, required = true,
                                 default = nil)
  if valid_568614 != nil:
    section.add "resourceGroupName", valid_568614
  var valid_568615 = path.getOrDefault("serverName")
  valid_568615 = validateParameter(valid_568615, JString, required = true,
                                 default = nil)
  if valid_568615 != nil:
    section.add "serverName", valid_568615
  var valid_568616 = path.getOrDefault("subscriptionId")
  valid_568616 = validateParameter(valid_568616, JString, required = true,
                                 default = nil)
  if valid_568616 != nil:
    section.add "subscriptionId", valid_568616
  var valid_568617 = path.getOrDefault("jobAgentName")
  valid_568617 = validateParameter(valid_568617, JString, required = true,
                                 default = nil)
  if valid_568617 != nil:
    section.add "jobAgentName", valid_568617
  var valid_568618 = path.getOrDefault("jobName")
  valid_568618 = validateParameter(valid_568618, JString, required = true,
                                 default = nil)
  if valid_568618 != nil:
    section.add "jobName", valid_568618
  var valid_568619 = path.getOrDefault("jobVersion")
  valid_568619 = validateParameter(valid_568619, JInt, required = true, default = nil)
  if valid_568619 != nil:
    section.add "jobVersion", valid_568619
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568620 = query.getOrDefault("api-version")
  valid_568620 = validateParameter(valid_568620, JString, required = true,
                                 default = nil)
  if valid_568620 != nil:
    section.add "api-version", valid_568620
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568621: Call_JobVersionsGet_568611; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a job version.
  ## 
  let valid = call_568621.validator(path, query, header, formData, body)
  let scheme = call_568621.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568621.url(scheme.get, call_568621.host, call_568621.base,
                         call_568621.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568621, url, valid)

proc call*(call_568622: Call_JobVersionsGet_568611; resourceGroupName: string;
          apiVersion: string; serverName: string; subscriptionId: string;
          jobAgentName: string; jobName: string; jobVersion: int): Recallable =
  ## jobVersionsGet
  ## Gets a job version.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   serverName: string (required)
  ##             : The name of the server.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   jobAgentName: string (required)
  ##               : The name of the job agent.
  ##   jobName: string (required)
  ##          : The name of the job.
  ##   jobVersion: int (required)
  ##             : The version of the job to get.
  var path_568623 = newJObject()
  var query_568624 = newJObject()
  add(path_568623, "resourceGroupName", newJString(resourceGroupName))
  add(query_568624, "api-version", newJString(apiVersion))
  add(path_568623, "serverName", newJString(serverName))
  add(path_568623, "subscriptionId", newJString(subscriptionId))
  add(path_568623, "jobAgentName", newJString(jobAgentName))
  add(path_568623, "jobName", newJString(jobName))
  add(path_568623, "jobVersion", newJInt(jobVersion))
  result = call_568622.call(path_568623, query_568624, nil, nil, nil)

var jobVersionsGet* = Call_JobVersionsGet_568611(name: "jobVersionsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/servers/{serverName}/jobAgents/{jobAgentName}/jobs/{jobName}/versions/{jobVersion}",
    validator: validate_JobVersionsGet_568612, base: "", url: url_JobVersionsGet_568613,
    schemes: {Scheme.Https})
type
  Call_JobStepsListByVersion_568625 = ref object of OpenApiRestCall_567657
proc url_JobStepsListByVersion_568627(protocol: Scheme; host: string; base: string;
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

proc validate_JobStepsListByVersion_568626(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all job steps in the specified job version.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   serverName: JString (required)
  ##             : The name of the server.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   jobAgentName: JString (required)
  ##               : The name of the job agent.
  ##   jobName: JString (required)
  ##          : The name of the job to get.
  ##   jobVersion: JInt (required)
  ##             : The version of the job to get.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568628 = path.getOrDefault("resourceGroupName")
  valid_568628 = validateParameter(valid_568628, JString, required = true,
                                 default = nil)
  if valid_568628 != nil:
    section.add "resourceGroupName", valid_568628
  var valid_568629 = path.getOrDefault("serverName")
  valid_568629 = validateParameter(valid_568629, JString, required = true,
                                 default = nil)
  if valid_568629 != nil:
    section.add "serverName", valid_568629
  var valid_568630 = path.getOrDefault("subscriptionId")
  valid_568630 = validateParameter(valid_568630, JString, required = true,
                                 default = nil)
  if valid_568630 != nil:
    section.add "subscriptionId", valid_568630
  var valid_568631 = path.getOrDefault("jobAgentName")
  valid_568631 = validateParameter(valid_568631, JString, required = true,
                                 default = nil)
  if valid_568631 != nil:
    section.add "jobAgentName", valid_568631
  var valid_568632 = path.getOrDefault("jobName")
  valid_568632 = validateParameter(valid_568632, JString, required = true,
                                 default = nil)
  if valid_568632 != nil:
    section.add "jobName", valid_568632
  var valid_568633 = path.getOrDefault("jobVersion")
  valid_568633 = validateParameter(valid_568633, JInt, required = true, default = nil)
  if valid_568633 != nil:
    section.add "jobVersion", valid_568633
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568634 = query.getOrDefault("api-version")
  valid_568634 = validateParameter(valid_568634, JString, required = true,
                                 default = nil)
  if valid_568634 != nil:
    section.add "api-version", valid_568634
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568635: Call_JobStepsListByVersion_568625; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all job steps in the specified job version.
  ## 
  let valid = call_568635.validator(path, query, header, formData, body)
  let scheme = call_568635.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568635.url(scheme.get, call_568635.host, call_568635.base,
                         call_568635.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568635, url, valid)

proc call*(call_568636: Call_JobStepsListByVersion_568625;
          resourceGroupName: string; apiVersion: string; serverName: string;
          subscriptionId: string; jobAgentName: string; jobName: string;
          jobVersion: int): Recallable =
  ## jobStepsListByVersion
  ## Gets all job steps in the specified job version.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   serverName: string (required)
  ##             : The name of the server.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   jobAgentName: string (required)
  ##               : The name of the job agent.
  ##   jobName: string (required)
  ##          : The name of the job to get.
  ##   jobVersion: int (required)
  ##             : The version of the job to get.
  var path_568637 = newJObject()
  var query_568638 = newJObject()
  add(path_568637, "resourceGroupName", newJString(resourceGroupName))
  add(query_568638, "api-version", newJString(apiVersion))
  add(path_568637, "serverName", newJString(serverName))
  add(path_568637, "subscriptionId", newJString(subscriptionId))
  add(path_568637, "jobAgentName", newJString(jobAgentName))
  add(path_568637, "jobName", newJString(jobName))
  add(path_568637, "jobVersion", newJInt(jobVersion))
  result = call_568636.call(path_568637, query_568638, nil, nil, nil)

var jobStepsListByVersion* = Call_JobStepsListByVersion_568625(
    name: "jobStepsListByVersion", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/servers/{serverName}/jobAgents/{jobAgentName}/jobs/{jobName}/versions/{jobVersion}/steps",
    validator: validate_JobStepsListByVersion_568626, base: "",
    url: url_JobStepsListByVersion_568627, schemes: {Scheme.Https})
type
  Call_JobStepsGetByVersion_568639 = ref object of OpenApiRestCall_567657
proc url_JobStepsGetByVersion_568641(protocol: Scheme; host: string; base: string;
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

proc validate_JobStepsGetByVersion_568640(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the specified version of a job step.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   serverName: JString (required)
  ##             : The name of the server.
  ##   stepName: JString (required)
  ##           : The name of the job step.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   jobAgentName: JString (required)
  ##               : The name of the job agent.
  ##   jobName: JString (required)
  ##          : The name of the job.
  ##   jobVersion: JInt (required)
  ##             : The version of the job to get.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568642 = path.getOrDefault("resourceGroupName")
  valid_568642 = validateParameter(valid_568642, JString, required = true,
                                 default = nil)
  if valid_568642 != nil:
    section.add "resourceGroupName", valid_568642
  var valid_568643 = path.getOrDefault("serverName")
  valid_568643 = validateParameter(valid_568643, JString, required = true,
                                 default = nil)
  if valid_568643 != nil:
    section.add "serverName", valid_568643
  var valid_568644 = path.getOrDefault("stepName")
  valid_568644 = validateParameter(valid_568644, JString, required = true,
                                 default = nil)
  if valid_568644 != nil:
    section.add "stepName", valid_568644
  var valid_568645 = path.getOrDefault("subscriptionId")
  valid_568645 = validateParameter(valid_568645, JString, required = true,
                                 default = nil)
  if valid_568645 != nil:
    section.add "subscriptionId", valid_568645
  var valid_568646 = path.getOrDefault("jobAgentName")
  valid_568646 = validateParameter(valid_568646, JString, required = true,
                                 default = nil)
  if valid_568646 != nil:
    section.add "jobAgentName", valid_568646
  var valid_568647 = path.getOrDefault("jobName")
  valid_568647 = validateParameter(valid_568647, JString, required = true,
                                 default = nil)
  if valid_568647 != nil:
    section.add "jobName", valid_568647
  var valid_568648 = path.getOrDefault("jobVersion")
  valid_568648 = validateParameter(valid_568648, JInt, required = true, default = nil)
  if valid_568648 != nil:
    section.add "jobVersion", valid_568648
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568649 = query.getOrDefault("api-version")
  valid_568649 = validateParameter(valid_568649, JString, required = true,
                                 default = nil)
  if valid_568649 != nil:
    section.add "api-version", valid_568649
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568650: Call_JobStepsGetByVersion_568639; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the specified version of a job step.
  ## 
  let valid = call_568650.validator(path, query, header, formData, body)
  let scheme = call_568650.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568650.url(scheme.get, call_568650.host, call_568650.base,
                         call_568650.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568650, url, valid)

proc call*(call_568651: Call_JobStepsGetByVersion_568639;
          resourceGroupName: string; apiVersion: string; serverName: string;
          stepName: string; subscriptionId: string; jobAgentName: string;
          jobName: string; jobVersion: int): Recallable =
  ## jobStepsGetByVersion
  ## Gets the specified version of a job step.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   serverName: string (required)
  ##             : The name of the server.
  ##   stepName: string (required)
  ##           : The name of the job step.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   jobAgentName: string (required)
  ##               : The name of the job agent.
  ##   jobName: string (required)
  ##          : The name of the job.
  ##   jobVersion: int (required)
  ##             : The version of the job to get.
  var path_568652 = newJObject()
  var query_568653 = newJObject()
  add(path_568652, "resourceGroupName", newJString(resourceGroupName))
  add(query_568653, "api-version", newJString(apiVersion))
  add(path_568652, "serverName", newJString(serverName))
  add(path_568652, "stepName", newJString(stepName))
  add(path_568652, "subscriptionId", newJString(subscriptionId))
  add(path_568652, "jobAgentName", newJString(jobAgentName))
  add(path_568652, "jobName", newJString(jobName))
  add(path_568652, "jobVersion", newJInt(jobVersion))
  result = call_568651.call(path_568652, query_568653, nil, nil, nil)

var jobStepsGetByVersion* = Call_JobStepsGetByVersion_568639(
    name: "jobStepsGetByVersion", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/servers/{serverName}/jobAgents/{jobAgentName}/jobs/{jobName}/versions/{jobVersion}/steps/{stepName}",
    validator: validate_JobStepsGetByVersion_568640, base: "",
    url: url_JobStepsGetByVersion_568641, schemes: {Scheme.Https})
type
  Call_JobTargetGroupsListByAgent_568654 = ref object of OpenApiRestCall_567657
proc url_JobTargetGroupsListByAgent_568656(protocol: Scheme; host: string;
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

proc validate_JobTargetGroupsListByAgent_568655(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all target groups in an agent.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   serverName: JString (required)
  ##             : The name of the server.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   jobAgentName: JString (required)
  ##               : The name of the job agent.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568657 = path.getOrDefault("resourceGroupName")
  valid_568657 = validateParameter(valid_568657, JString, required = true,
                                 default = nil)
  if valid_568657 != nil:
    section.add "resourceGroupName", valid_568657
  var valid_568658 = path.getOrDefault("serverName")
  valid_568658 = validateParameter(valid_568658, JString, required = true,
                                 default = nil)
  if valid_568658 != nil:
    section.add "serverName", valid_568658
  var valid_568659 = path.getOrDefault("subscriptionId")
  valid_568659 = validateParameter(valid_568659, JString, required = true,
                                 default = nil)
  if valid_568659 != nil:
    section.add "subscriptionId", valid_568659
  var valid_568660 = path.getOrDefault("jobAgentName")
  valid_568660 = validateParameter(valid_568660, JString, required = true,
                                 default = nil)
  if valid_568660 != nil:
    section.add "jobAgentName", valid_568660
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568661 = query.getOrDefault("api-version")
  valid_568661 = validateParameter(valid_568661, JString, required = true,
                                 default = nil)
  if valid_568661 != nil:
    section.add "api-version", valid_568661
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568662: Call_JobTargetGroupsListByAgent_568654; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all target groups in an agent.
  ## 
  let valid = call_568662.validator(path, query, header, formData, body)
  let scheme = call_568662.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568662.url(scheme.get, call_568662.host, call_568662.base,
                         call_568662.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568662, url, valid)

proc call*(call_568663: Call_JobTargetGroupsListByAgent_568654;
          resourceGroupName: string; apiVersion: string; serverName: string;
          subscriptionId: string; jobAgentName: string): Recallable =
  ## jobTargetGroupsListByAgent
  ## Gets all target groups in an agent.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   serverName: string (required)
  ##             : The name of the server.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   jobAgentName: string (required)
  ##               : The name of the job agent.
  var path_568664 = newJObject()
  var query_568665 = newJObject()
  add(path_568664, "resourceGroupName", newJString(resourceGroupName))
  add(query_568665, "api-version", newJString(apiVersion))
  add(path_568664, "serverName", newJString(serverName))
  add(path_568664, "subscriptionId", newJString(subscriptionId))
  add(path_568664, "jobAgentName", newJString(jobAgentName))
  result = call_568663.call(path_568664, query_568665, nil, nil, nil)

var jobTargetGroupsListByAgent* = Call_JobTargetGroupsListByAgent_568654(
    name: "jobTargetGroupsListByAgent", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/servers/{serverName}/jobAgents/{jobAgentName}/targetGroups",
    validator: validate_JobTargetGroupsListByAgent_568655, base: "",
    url: url_JobTargetGroupsListByAgent_568656, schemes: {Scheme.Https})
type
  Call_JobTargetGroupsCreateOrUpdate_568679 = ref object of OpenApiRestCall_567657
proc url_JobTargetGroupsCreateOrUpdate_568681(protocol: Scheme; host: string;
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

proc validate_JobTargetGroupsCreateOrUpdate_568680(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates a target group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   serverName: JString (required)
  ##             : The name of the server.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   jobAgentName: JString (required)
  ##               : The name of the job agent.
  ##   targetGroupName: JString (required)
  ##                  : The name of the target group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568682 = path.getOrDefault("resourceGroupName")
  valid_568682 = validateParameter(valid_568682, JString, required = true,
                                 default = nil)
  if valid_568682 != nil:
    section.add "resourceGroupName", valid_568682
  var valid_568683 = path.getOrDefault("serverName")
  valid_568683 = validateParameter(valid_568683, JString, required = true,
                                 default = nil)
  if valid_568683 != nil:
    section.add "serverName", valid_568683
  var valid_568684 = path.getOrDefault("subscriptionId")
  valid_568684 = validateParameter(valid_568684, JString, required = true,
                                 default = nil)
  if valid_568684 != nil:
    section.add "subscriptionId", valid_568684
  var valid_568685 = path.getOrDefault("jobAgentName")
  valid_568685 = validateParameter(valid_568685, JString, required = true,
                                 default = nil)
  if valid_568685 != nil:
    section.add "jobAgentName", valid_568685
  var valid_568686 = path.getOrDefault("targetGroupName")
  valid_568686 = validateParameter(valid_568686, JString, required = true,
                                 default = nil)
  if valid_568686 != nil:
    section.add "targetGroupName", valid_568686
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568687 = query.getOrDefault("api-version")
  valid_568687 = validateParameter(valid_568687, JString, required = true,
                                 default = nil)
  if valid_568687 != nil:
    section.add "api-version", valid_568687
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

proc call*(call_568689: Call_JobTargetGroupsCreateOrUpdate_568679; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates a target group.
  ## 
  let valid = call_568689.validator(path, query, header, formData, body)
  let scheme = call_568689.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568689.url(scheme.get, call_568689.host, call_568689.base,
                         call_568689.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568689, url, valid)

proc call*(call_568690: Call_JobTargetGroupsCreateOrUpdate_568679;
          resourceGroupName: string; apiVersion: string; serverName: string;
          subscriptionId: string; jobAgentName: string; targetGroupName: string;
          parameters: JsonNode): Recallable =
  ## jobTargetGroupsCreateOrUpdate
  ## Creates or updates a target group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
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
  ##   parameters: JObject (required)
  ##             : The requested state of the target group.
  var path_568691 = newJObject()
  var query_568692 = newJObject()
  var body_568693 = newJObject()
  add(path_568691, "resourceGroupName", newJString(resourceGroupName))
  add(query_568692, "api-version", newJString(apiVersion))
  add(path_568691, "serverName", newJString(serverName))
  add(path_568691, "subscriptionId", newJString(subscriptionId))
  add(path_568691, "jobAgentName", newJString(jobAgentName))
  add(path_568691, "targetGroupName", newJString(targetGroupName))
  if parameters != nil:
    body_568693 = parameters
  result = call_568690.call(path_568691, query_568692, nil, nil, body_568693)

var jobTargetGroupsCreateOrUpdate* = Call_JobTargetGroupsCreateOrUpdate_568679(
    name: "jobTargetGroupsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/servers/{serverName}/jobAgents/{jobAgentName}/targetGroups/{targetGroupName}",
    validator: validate_JobTargetGroupsCreateOrUpdate_568680, base: "",
    url: url_JobTargetGroupsCreateOrUpdate_568681, schemes: {Scheme.Https})
type
  Call_JobTargetGroupsGet_568666 = ref object of OpenApiRestCall_567657
proc url_JobTargetGroupsGet_568668(protocol: Scheme; host: string; base: string;
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

proc validate_JobTargetGroupsGet_568667(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Gets a target group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   serverName: JString (required)
  ##             : The name of the server.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   jobAgentName: JString (required)
  ##               : The name of the job agent.
  ##   targetGroupName: JString (required)
  ##                  : The name of the target group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568669 = path.getOrDefault("resourceGroupName")
  valid_568669 = validateParameter(valid_568669, JString, required = true,
                                 default = nil)
  if valid_568669 != nil:
    section.add "resourceGroupName", valid_568669
  var valid_568670 = path.getOrDefault("serverName")
  valid_568670 = validateParameter(valid_568670, JString, required = true,
                                 default = nil)
  if valid_568670 != nil:
    section.add "serverName", valid_568670
  var valid_568671 = path.getOrDefault("subscriptionId")
  valid_568671 = validateParameter(valid_568671, JString, required = true,
                                 default = nil)
  if valid_568671 != nil:
    section.add "subscriptionId", valid_568671
  var valid_568672 = path.getOrDefault("jobAgentName")
  valid_568672 = validateParameter(valid_568672, JString, required = true,
                                 default = nil)
  if valid_568672 != nil:
    section.add "jobAgentName", valid_568672
  var valid_568673 = path.getOrDefault("targetGroupName")
  valid_568673 = validateParameter(valid_568673, JString, required = true,
                                 default = nil)
  if valid_568673 != nil:
    section.add "targetGroupName", valid_568673
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568674 = query.getOrDefault("api-version")
  valid_568674 = validateParameter(valid_568674, JString, required = true,
                                 default = nil)
  if valid_568674 != nil:
    section.add "api-version", valid_568674
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568675: Call_JobTargetGroupsGet_568666; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a target group.
  ## 
  let valid = call_568675.validator(path, query, header, formData, body)
  let scheme = call_568675.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568675.url(scheme.get, call_568675.host, call_568675.base,
                         call_568675.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568675, url, valid)

proc call*(call_568676: Call_JobTargetGroupsGet_568666; resourceGroupName: string;
          apiVersion: string; serverName: string; subscriptionId: string;
          jobAgentName: string; targetGroupName: string): Recallable =
  ## jobTargetGroupsGet
  ## Gets a target group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
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
  var path_568677 = newJObject()
  var query_568678 = newJObject()
  add(path_568677, "resourceGroupName", newJString(resourceGroupName))
  add(query_568678, "api-version", newJString(apiVersion))
  add(path_568677, "serverName", newJString(serverName))
  add(path_568677, "subscriptionId", newJString(subscriptionId))
  add(path_568677, "jobAgentName", newJString(jobAgentName))
  add(path_568677, "targetGroupName", newJString(targetGroupName))
  result = call_568676.call(path_568677, query_568678, nil, nil, nil)

var jobTargetGroupsGet* = Call_JobTargetGroupsGet_568666(
    name: "jobTargetGroupsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/servers/{serverName}/jobAgents/{jobAgentName}/targetGroups/{targetGroupName}",
    validator: validate_JobTargetGroupsGet_568667, base: "",
    url: url_JobTargetGroupsGet_568668, schemes: {Scheme.Https})
type
  Call_JobTargetGroupsDelete_568694 = ref object of OpenApiRestCall_567657
proc url_JobTargetGroupsDelete_568696(protocol: Scheme; host: string; base: string;
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

proc validate_JobTargetGroupsDelete_568695(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a target group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   serverName: JString (required)
  ##             : The name of the server.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   jobAgentName: JString (required)
  ##               : The name of the job agent.
  ##   targetGroupName: JString (required)
  ##                  : The name of the target group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568697 = path.getOrDefault("resourceGroupName")
  valid_568697 = validateParameter(valid_568697, JString, required = true,
                                 default = nil)
  if valid_568697 != nil:
    section.add "resourceGroupName", valid_568697
  var valid_568698 = path.getOrDefault("serverName")
  valid_568698 = validateParameter(valid_568698, JString, required = true,
                                 default = nil)
  if valid_568698 != nil:
    section.add "serverName", valid_568698
  var valid_568699 = path.getOrDefault("subscriptionId")
  valid_568699 = validateParameter(valid_568699, JString, required = true,
                                 default = nil)
  if valid_568699 != nil:
    section.add "subscriptionId", valid_568699
  var valid_568700 = path.getOrDefault("jobAgentName")
  valid_568700 = validateParameter(valid_568700, JString, required = true,
                                 default = nil)
  if valid_568700 != nil:
    section.add "jobAgentName", valid_568700
  var valid_568701 = path.getOrDefault("targetGroupName")
  valid_568701 = validateParameter(valid_568701, JString, required = true,
                                 default = nil)
  if valid_568701 != nil:
    section.add "targetGroupName", valid_568701
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568702 = query.getOrDefault("api-version")
  valid_568702 = validateParameter(valid_568702, JString, required = true,
                                 default = nil)
  if valid_568702 != nil:
    section.add "api-version", valid_568702
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568703: Call_JobTargetGroupsDelete_568694; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a target group.
  ## 
  let valid = call_568703.validator(path, query, header, formData, body)
  let scheme = call_568703.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568703.url(scheme.get, call_568703.host, call_568703.base,
                         call_568703.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568703, url, valid)

proc call*(call_568704: Call_JobTargetGroupsDelete_568694;
          resourceGroupName: string; apiVersion: string; serverName: string;
          subscriptionId: string; jobAgentName: string; targetGroupName: string): Recallable =
  ## jobTargetGroupsDelete
  ## Deletes a target group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
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
  var path_568705 = newJObject()
  var query_568706 = newJObject()
  add(path_568705, "resourceGroupName", newJString(resourceGroupName))
  add(query_568706, "api-version", newJString(apiVersion))
  add(path_568705, "serverName", newJString(serverName))
  add(path_568705, "subscriptionId", newJString(subscriptionId))
  add(path_568705, "jobAgentName", newJString(jobAgentName))
  add(path_568705, "targetGroupName", newJString(targetGroupName))
  result = call_568704.call(path_568705, query_568706, nil, nil, nil)

var jobTargetGroupsDelete* = Call_JobTargetGroupsDelete_568694(
    name: "jobTargetGroupsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/servers/{serverName}/jobAgents/{jobAgentName}/targetGroups/{targetGroupName}",
    validator: validate_JobTargetGroupsDelete_568695, base: "",
    url: url_JobTargetGroupsDelete_568696, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
