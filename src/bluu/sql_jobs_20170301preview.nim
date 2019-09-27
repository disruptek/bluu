
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

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
  macServiceName = "sql-jobs"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_JobAgentsListByServer_593646 = ref object of OpenApiRestCall_593424
proc url_JobAgentsListByServer_593648(protocol: Scheme; host: string; base: string;
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

proc validate_JobAgentsListByServer_593647(path: JsonNode; query: JsonNode;
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
  var valid_593821 = path.getOrDefault("resourceGroupName")
  valid_593821 = validateParameter(valid_593821, JString, required = true,
                                 default = nil)
  if valid_593821 != nil:
    section.add "resourceGroupName", valid_593821
  var valid_593822 = path.getOrDefault("serverName")
  valid_593822 = validateParameter(valid_593822, JString, required = true,
                                 default = nil)
  if valid_593822 != nil:
    section.add "serverName", valid_593822
  var valid_593823 = path.getOrDefault("subscriptionId")
  valid_593823 = validateParameter(valid_593823, JString, required = true,
                                 default = nil)
  if valid_593823 != nil:
    section.add "subscriptionId", valid_593823
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593824 = query.getOrDefault("api-version")
  valid_593824 = validateParameter(valid_593824, JString, required = true,
                                 default = nil)
  if valid_593824 != nil:
    section.add "api-version", valid_593824
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593847: Call_JobAgentsListByServer_593646; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a list of job agents in a server.
  ## 
  let valid = call_593847.validator(path, query, header, formData, body)
  let scheme = call_593847.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593847.url(scheme.get, call_593847.host, call_593847.base,
                         call_593847.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593847, url, valid)

proc call*(call_593918: Call_JobAgentsListByServer_593646;
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
  var path_593919 = newJObject()
  var query_593921 = newJObject()
  add(path_593919, "resourceGroupName", newJString(resourceGroupName))
  add(query_593921, "api-version", newJString(apiVersion))
  add(path_593919, "serverName", newJString(serverName))
  add(path_593919, "subscriptionId", newJString(subscriptionId))
  result = call_593918.call(path_593919, query_593921, nil, nil, nil)

var jobAgentsListByServer* = Call_JobAgentsListByServer_593646(
    name: "jobAgentsListByServer", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/servers/{serverName}/jobAgents",
    validator: validate_JobAgentsListByServer_593647, base: "",
    url: url_JobAgentsListByServer_593648, schemes: {Scheme.Https})
type
  Call_JobAgentsCreateOrUpdate_593972 = ref object of OpenApiRestCall_593424
proc url_JobAgentsCreateOrUpdate_593974(protocol: Scheme; host: string; base: string;
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

proc validate_JobAgentsCreateOrUpdate_593973(path: JsonNode; query: JsonNode;
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
  var valid_593975 = path.getOrDefault("resourceGroupName")
  valid_593975 = validateParameter(valid_593975, JString, required = true,
                                 default = nil)
  if valid_593975 != nil:
    section.add "resourceGroupName", valid_593975
  var valid_593976 = path.getOrDefault("serverName")
  valid_593976 = validateParameter(valid_593976, JString, required = true,
                                 default = nil)
  if valid_593976 != nil:
    section.add "serverName", valid_593976
  var valid_593977 = path.getOrDefault("subscriptionId")
  valid_593977 = validateParameter(valid_593977, JString, required = true,
                                 default = nil)
  if valid_593977 != nil:
    section.add "subscriptionId", valid_593977
  var valid_593978 = path.getOrDefault("jobAgentName")
  valid_593978 = validateParameter(valid_593978, JString, required = true,
                                 default = nil)
  if valid_593978 != nil:
    section.add "jobAgentName", valid_593978
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593979 = query.getOrDefault("api-version")
  valid_593979 = validateParameter(valid_593979, JString, required = true,
                                 default = nil)
  if valid_593979 != nil:
    section.add "api-version", valid_593979
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

proc call*(call_593981: Call_JobAgentsCreateOrUpdate_593972; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates a job agent.
  ## 
  let valid = call_593981.validator(path, query, header, formData, body)
  let scheme = call_593981.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593981.url(scheme.get, call_593981.host, call_593981.base,
                         call_593981.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593981, url, valid)

proc call*(call_593982: Call_JobAgentsCreateOrUpdate_593972;
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
  var path_593983 = newJObject()
  var query_593984 = newJObject()
  var body_593985 = newJObject()
  add(path_593983, "resourceGroupName", newJString(resourceGroupName))
  add(query_593984, "api-version", newJString(apiVersion))
  add(path_593983, "serverName", newJString(serverName))
  add(path_593983, "subscriptionId", newJString(subscriptionId))
  add(path_593983, "jobAgentName", newJString(jobAgentName))
  if parameters != nil:
    body_593985 = parameters
  result = call_593982.call(path_593983, query_593984, nil, nil, body_593985)

var jobAgentsCreateOrUpdate* = Call_JobAgentsCreateOrUpdate_593972(
    name: "jobAgentsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/servers/{serverName}/jobAgents/{jobAgentName}",
    validator: validate_JobAgentsCreateOrUpdate_593973, base: "",
    url: url_JobAgentsCreateOrUpdate_593974, schemes: {Scheme.Https})
type
  Call_JobAgentsGet_593960 = ref object of OpenApiRestCall_593424
proc url_JobAgentsGet_593962(protocol: Scheme; host: string; base: string;
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

proc validate_JobAgentsGet_593961(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_593963 = path.getOrDefault("resourceGroupName")
  valid_593963 = validateParameter(valid_593963, JString, required = true,
                                 default = nil)
  if valid_593963 != nil:
    section.add "resourceGroupName", valid_593963
  var valid_593964 = path.getOrDefault("serverName")
  valid_593964 = validateParameter(valid_593964, JString, required = true,
                                 default = nil)
  if valid_593964 != nil:
    section.add "serverName", valid_593964
  var valid_593965 = path.getOrDefault("subscriptionId")
  valid_593965 = validateParameter(valid_593965, JString, required = true,
                                 default = nil)
  if valid_593965 != nil:
    section.add "subscriptionId", valid_593965
  var valid_593966 = path.getOrDefault("jobAgentName")
  valid_593966 = validateParameter(valid_593966, JString, required = true,
                                 default = nil)
  if valid_593966 != nil:
    section.add "jobAgentName", valid_593966
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593967 = query.getOrDefault("api-version")
  valid_593967 = validateParameter(valid_593967, JString, required = true,
                                 default = nil)
  if valid_593967 != nil:
    section.add "api-version", valid_593967
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593968: Call_JobAgentsGet_593960; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a job agent.
  ## 
  let valid = call_593968.validator(path, query, header, formData, body)
  let scheme = call_593968.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593968.url(scheme.get, call_593968.host, call_593968.base,
                         call_593968.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593968, url, valid)

proc call*(call_593969: Call_JobAgentsGet_593960; resourceGroupName: string;
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
  var path_593970 = newJObject()
  var query_593971 = newJObject()
  add(path_593970, "resourceGroupName", newJString(resourceGroupName))
  add(query_593971, "api-version", newJString(apiVersion))
  add(path_593970, "serverName", newJString(serverName))
  add(path_593970, "subscriptionId", newJString(subscriptionId))
  add(path_593970, "jobAgentName", newJString(jobAgentName))
  result = call_593969.call(path_593970, query_593971, nil, nil, nil)

var jobAgentsGet* = Call_JobAgentsGet_593960(name: "jobAgentsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/servers/{serverName}/jobAgents/{jobAgentName}",
    validator: validate_JobAgentsGet_593961, base: "", url: url_JobAgentsGet_593962,
    schemes: {Scheme.Https})
type
  Call_JobAgentsUpdate_593998 = ref object of OpenApiRestCall_593424
proc url_JobAgentsUpdate_594000(protocol: Scheme; host: string; base: string;
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

proc validate_JobAgentsUpdate_593999(path: JsonNode; query: JsonNode;
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
  var valid_594001 = path.getOrDefault("resourceGroupName")
  valid_594001 = validateParameter(valid_594001, JString, required = true,
                                 default = nil)
  if valid_594001 != nil:
    section.add "resourceGroupName", valid_594001
  var valid_594002 = path.getOrDefault("serverName")
  valid_594002 = validateParameter(valid_594002, JString, required = true,
                                 default = nil)
  if valid_594002 != nil:
    section.add "serverName", valid_594002
  var valid_594003 = path.getOrDefault("subscriptionId")
  valid_594003 = validateParameter(valid_594003, JString, required = true,
                                 default = nil)
  if valid_594003 != nil:
    section.add "subscriptionId", valid_594003
  var valid_594004 = path.getOrDefault("jobAgentName")
  valid_594004 = validateParameter(valid_594004, JString, required = true,
                                 default = nil)
  if valid_594004 != nil:
    section.add "jobAgentName", valid_594004
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594005 = query.getOrDefault("api-version")
  valid_594005 = validateParameter(valid_594005, JString, required = true,
                                 default = nil)
  if valid_594005 != nil:
    section.add "api-version", valid_594005
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

proc call*(call_594007: Call_JobAgentsUpdate_593998; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a job agent.
  ## 
  let valid = call_594007.validator(path, query, header, formData, body)
  let scheme = call_594007.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594007.url(scheme.get, call_594007.host, call_594007.base,
                         call_594007.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594007, url, valid)

proc call*(call_594008: Call_JobAgentsUpdate_593998; resourceGroupName: string;
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
  var path_594009 = newJObject()
  var query_594010 = newJObject()
  var body_594011 = newJObject()
  add(path_594009, "resourceGroupName", newJString(resourceGroupName))
  add(query_594010, "api-version", newJString(apiVersion))
  add(path_594009, "serverName", newJString(serverName))
  add(path_594009, "subscriptionId", newJString(subscriptionId))
  add(path_594009, "jobAgentName", newJString(jobAgentName))
  if parameters != nil:
    body_594011 = parameters
  result = call_594008.call(path_594009, query_594010, nil, nil, body_594011)

var jobAgentsUpdate* = Call_JobAgentsUpdate_593998(name: "jobAgentsUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/servers/{serverName}/jobAgents/{jobAgentName}",
    validator: validate_JobAgentsUpdate_593999, base: "", url: url_JobAgentsUpdate_594000,
    schemes: {Scheme.Https})
type
  Call_JobAgentsDelete_593986 = ref object of OpenApiRestCall_593424
proc url_JobAgentsDelete_593988(protocol: Scheme; host: string; base: string;
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

proc validate_JobAgentsDelete_593987(path: JsonNode; query: JsonNode;
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
  var valid_593989 = path.getOrDefault("resourceGroupName")
  valid_593989 = validateParameter(valid_593989, JString, required = true,
                                 default = nil)
  if valid_593989 != nil:
    section.add "resourceGroupName", valid_593989
  var valid_593990 = path.getOrDefault("serverName")
  valid_593990 = validateParameter(valid_593990, JString, required = true,
                                 default = nil)
  if valid_593990 != nil:
    section.add "serverName", valid_593990
  var valid_593991 = path.getOrDefault("subscriptionId")
  valid_593991 = validateParameter(valid_593991, JString, required = true,
                                 default = nil)
  if valid_593991 != nil:
    section.add "subscriptionId", valid_593991
  var valid_593992 = path.getOrDefault("jobAgentName")
  valid_593992 = validateParameter(valid_593992, JString, required = true,
                                 default = nil)
  if valid_593992 != nil:
    section.add "jobAgentName", valid_593992
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593993 = query.getOrDefault("api-version")
  valid_593993 = validateParameter(valid_593993, JString, required = true,
                                 default = nil)
  if valid_593993 != nil:
    section.add "api-version", valid_593993
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593994: Call_JobAgentsDelete_593986; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a job agent.
  ## 
  let valid = call_593994.validator(path, query, header, formData, body)
  let scheme = call_593994.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593994.url(scheme.get, call_593994.host, call_593994.base,
                         call_593994.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593994, url, valid)

proc call*(call_593995: Call_JobAgentsDelete_593986; resourceGroupName: string;
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
  var path_593996 = newJObject()
  var query_593997 = newJObject()
  add(path_593996, "resourceGroupName", newJString(resourceGroupName))
  add(query_593997, "api-version", newJString(apiVersion))
  add(path_593996, "serverName", newJString(serverName))
  add(path_593996, "subscriptionId", newJString(subscriptionId))
  add(path_593996, "jobAgentName", newJString(jobAgentName))
  result = call_593995.call(path_593996, query_593997, nil, nil, nil)

var jobAgentsDelete* = Call_JobAgentsDelete_593986(name: "jobAgentsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/servers/{serverName}/jobAgents/{jobAgentName}",
    validator: validate_JobAgentsDelete_593987, base: "", url: url_JobAgentsDelete_593988,
    schemes: {Scheme.Https})
type
  Call_JobCredentialsListByAgent_594012 = ref object of OpenApiRestCall_593424
proc url_JobCredentialsListByAgent_594014(protocol: Scheme; host: string;
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

proc validate_JobCredentialsListByAgent_594013(path: JsonNode; query: JsonNode;
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
  var valid_594015 = path.getOrDefault("resourceGroupName")
  valid_594015 = validateParameter(valid_594015, JString, required = true,
                                 default = nil)
  if valid_594015 != nil:
    section.add "resourceGroupName", valid_594015
  var valid_594016 = path.getOrDefault("serverName")
  valid_594016 = validateParameter(valid_594016, JString, required = true,
                                 default = nil)
  if valid_594016 != nil:
    section.add "serverName", valid_594016
  var valid_594017 = path.getOrDefault("subscriptionId")
  valid_594017 = validateParameter(valid_594017, JString, required = true,
                                 default = nil)
  if valid_594017 != nil:
    section.add "subscriptionId", valid_594017
  var valid_594018 = path.getOrDefault("jobAgentName")
  valid_594018 = validateParameter(valid_594018, JString, required = true,
                                 default = nil)
  if valid_594018 != nil:
    section.add "jobAgentName", valid_594018
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594019 = query.getOrDefault("api-version")
  valid_594019 = validateParameter(valid_594019, JString, required = true,
                                 default = nil)
  if valid_594019 != nil:
    section.add "api-version", valid_594019
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594020: Call_JobCredentialsListByAgent_594012; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a list of jobs credentials.
  ## 
  let valid = call_594020.validator(path, query, header, formData, body)
  let scheme = call_594020.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594020.url(scheme.get, call_594020.host, call_594020.base,
                         call_594020.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594020, url, valid)

proc call*(call_594021: Call_JobCredentialsListByAgent_594012;
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
  var path_594022 = newJObject()
  var query_594023 = newJObject()
  add(path_594022, "resourceGroupName", newJString(resourceGroupName))
  add(query_594023, "api-version", newJString(apiVersion))
  add(path_594022, "serverName", newJString(serverName))
  add(path_594022, "subscriptionId", newJString(subscriptionId))
  add(path_594022, "jobAgentName", newJString(jobAgentName))
  result = call_594021.call(path_594022, query_594023, nil, nil, nil)

var jobCredentialsListByAgent* = Call_JobCredentialsListByAgent_594012(
    name: "jobCredentialsListByAgent", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/servers/{serverName}/jobAgents/{jobAgentName}/credentials",
    validator: validate_JobCredentialsListByAgent_594013, base: "",
    url: url_JobCredentialsListByAgent_594014, schemes: {Scheme.Https})
type
  Call_JobCredentialsCreateOrUpdate_594037 = ref object of OpenApiRestCall_593424
proc url_JobCredentialsCreateOrUpdate_594039(protocol: Scheme; host: string;
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

proc validate_JobCredentialsCreateOrUpdate_594038(path: JsonNode; query: JsonNode;
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
  var valid_594040 = path.getOrDefault("resourceGroupName")
  valid_594040 = validateParameter(valid_594040, JString, required = true,
                                 default = nil)
  if valid_594040 != nil:
    section.add "resourceGroupName", valid_594040
  var valid_594041 = path.getOrDefault("serverName")
  valid_594041 = validateParameter(valid_594041, JString, required = true,
                                 default = nil)
  if valid_594041 != nil:
    section.add "serverName", valid_594041
  var valid_594042 = path.getOrDefault("subscriptionId")
  valid_594042 = validateParameter(valid_594042, JString, required = true,
                                 default = nil)
  if valid_594042 != nil:
    section.add "subscriptionId", valid_594042
  var valid_594043 = path.getOrDefault("jobAgentName")
  valid_594043 = validateParameter(valid_594043, JString, required = true,
                                 default = nil)
  if valid_594043 != nil:
    section.add "jobAgentName", valid_594043
  var valid_594044 = path.getOrDefault("credentialName")
  valid_594044 = validateParameter(valid_594044, JString, required = true,
                                 default = nil)
  if valid_594044 != nil:
    section.add "credentialName", valid_594044
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594045 = query.getOrDefault("api-version")
  valid_594045 = validateParameter(valid_594045, JString, required = true,
                                 default = nil)
  if valid_594045 != nil:
    section.add "api-version", valid_594045
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

proc call*(call_594047: Call_JobCredentialsCreateOrUpdate_594037; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates a job credential.
  ## 
  let valid = call_594047.validator(path, query, header, formData, body)
  let scheme = call_594047.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594047.url(scheme.get, call_594047.host, call_594047.base,
                         call_594047.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594047, url, valid)

proc call*(call_594048: Call_JobCredentialsCreateOrUpdate_594037;
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
  var path_594049 = newJObject()
  var query_594050 = newJObject()
  var body_594051 = newJObject()
  add(path_594049, "resourceGroupName", newJString(resourceGroupName))
  add(query_594050, "api-version", newJString(apiVersion))
  add(path_594049, "serverName", newJString(serverName))
  add(path_594049, "subscriptionId", newJString(subscriptionId))
  add(path_594049, "jobAgentName", newJString(jobAgentName))
  add(path_594049, "credentialName", newJString(credentialName))
  if parameters != nil:
    body_594051 = parameters
  result = call_594048.call(path_594049, query_594050, nil, nil, body_594051)

var jobCredentialsCreateOrUpdate* = Call_JobCredentialsCreateOrUpdate_594037(
    name: "jobCredentialsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/servers/{serverName}/jobAgents/{jobAgentName}/credentials/{credentialName}",
    validator: validate_JobCredentialsCreateOrUpdate_594038, base: "",
    url: url_JobCredentialsCreateOrUpdate_594039, schemes: {Scheme.Https})
type
  Call_JobCredentialsGet_594024 = ref object of OpenApiRestCall_593424
proc url_JobCredentialsGet_594026(protocol: Scheme; host: string; base: string;
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

proc validate_JobCredentialsGet_594025(path: JsonNode; query: JsonNode;
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
  var valid_594027 = path.getOrDefault("resourceGroupName")
  valid_594027 = validateParameter(valid_594027, JString, required = true,
                                 default = nil)
  if valid_594027 != nil:
    section.add "resourceGroupName", valid_594027
  var valid_594028 = path.getOrDefault("serverName")
  valid_594028 = validateParameter(valid_594028, JString, required = true,
                                 default = nil)
  if valid_594028 != nil:
    section.add "serverName", valid_594028
  var valid_594029 = path.getOrDefault("subscriptionId")
  valid_594029 = validateParameter(valid_594029, JString, required = true,
                                 default = nil)
  if valid_594029 != nil:
    section.add "subscriptionId", valid_594029
  var valid_594030 = path.getOrDefault("jobAgentName")
  valid_594030 = validateParameter(valid_594030, JString, required = true,
                                 default = nil)
  if valid_594030 != nil:
    section.add "jobAgentName", valid_594030
  var valid_594031 = path.getOrDefault("credentialName")
  valid_594031 = validateParameter(valid_594031, JString, required = true,
                                 default = nil)
  if valid_594031 != nil:
    section.add "credentialName", valid_594031
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594032 = query.getOrDefault("api-version")
  valid_594032 = validateParameter(valid_594032, JString, required = true,
                                 default = nil)
  if valid_594032 != nil:
    section.add "api-version", valid_594032
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594033: Call_JobCredentialsGet_594024; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a jobs credential.
  ## 
  let valid = call_594033.validator(path, query, header, formData, body)
  let scheme = call_594033.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594033.url(scheme.get, call_594033.host, call_594033.base,
                         call_594033.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594033, url, valid)

proc call*(call_594034: Call_JobCredentialsGet_594024; resourceGroupName: string;
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
  var path_594035 = newJObject()
  var query_594036 = newJObject()
  add(path_594035, "resourceGroupName", newJString(resourceGroupName))
  add(query_594036, "api-version", newJString(apiVersion))
  add(path_594035, "serverName", newJString(serverName))
  add(path_594035, "subscriptionId", newJString(subscriptionId))
  add(path_594035, "jobAgentName", newJString(jobAgentName))
  add(path_594035, "credentialName", newJString(credentialName))
  result = call_594034.call(path_594035, query_594036, nil, nil, nil)

var jobCredentialsGet* = Call_JobCredentialsGet_594024(name: "jobCredentialsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/servers/{serverName}/jobAgents/{jobAgentName}/credentials/{credentialName}",
    validator: validate_JobCredentialsGet_594025, base: "",
    url: url_JobCredentialsGet_594026, schemes: {Scheme.Https})
type
  Call_JobCredentialsDelete_594052 = ref object of OpenApiRestCall_593424
proc url_JobCredentialsDelete_594054(protocol: Scheme; host: string; base: string;
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

proc validate_JobCredentialsDelete_594053(path: JsonNode; query: JsonNode;
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
  var valid_594055 = path.getOrDefault("resourceGroupName")
  valid_594055 = validateParameter(valid_594055, JString, required = true,
                                 default = nil)
  if valid_594055 != nil:
    section.add "resourceGroupName", valid_594055
  var valid_594056 = path.getOrDefault("serverName")
  valid_594056 = validateParameter(valid_594056, JString, required = true,
                                 default = nil)
  if valid_594056 != nil:
    section.add "serverName", valid_594056
  var valid_594057 = path.getOrDefault("subscriptionId")
  valid_594057 = validateParameter(valid_594057, JString, required = true,
                                 default = nil)
  if valid_594057 != nil:
    section.add "subscriptionId", valid_594057
  var valid_594058 = path.getOrDefault("jobAgentName")
  valid_594058 = validateParameter(valid_594058, JString, required = true,
                                 default = nil)
  if valid_594058 != nil:
    section.add "jobAgentName", valid_594058
  var valid_594059 = path.getOrDefault("credentialName")
  valid_594059 = validateParameter(valid_594059, JString, required = true,
                                 default = nil)
  if valid_594059 != nil:
    section.add "credentialName", valid_594059
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594060 = query.getOrDefault("api-version")
  valid_594060 = validateParameter(valid_594060, JString, required = true,
                                 default = nil)
  if valid_594060 != nil:
    section.add "api-version", valid_594060
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594061: Call_JobCredentialsDelete_594052; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a job credential.
  ## 
  let valid = call_594061.validator(path, query, header, formData, body)
  let scheme = call_594061.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594061.url(scheme.get, call_594061.host, call_594061.base,
                         call_594061.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594061, url, valid)

proc call*(call_594062: Call_JobCredentialsDelete_594052;
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
  var path_594063 = newJObject()
  var query_594064 = newJObject()
  add(path_594063, "resourceGroupName", newJString(resourceGroupName))
  add(query_594064, "api-version", newJString(apiVersion))
  add(path_594063, "serverName", newJString(serverName))
  add(path_594063, "subscriptionId", newJString(subscriptionId))
  add(path_594063, "jobAgentName", newJString(jobAgentName))
  add(path_594063, "credentialName", newJString(credentialName))
  result = call_594062.call(path_594063, query_594064, nil, nil, nil)

var jobCredentialsDelete* = Call_JobCredentialsDelete_594052(
    name: "jobCredentialsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/servers/{serverName}/jobAgents/{jobAgentName}/credentials/{credentialName}",
    validator: validate_JobCredentialsDelete_594053, base: "",
    url: url_JobCredentialsDelete_594054, schemes: {Scheme.Https})
type
  Call_JobExecutionsListByAgent_594065 = ref object of OpenApiRestCall_593424
proc url_JobExecutionsListByAgent_594067(protocol: Scheme; host: string;
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

proc validate_JobExecutionsListByAgent_594066(path: JsonNode; query: JsonNode;
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
  var valid_594069 = path.getOrDefault("resourceGroupName")
  valid_594069 = validateParameter(valid_594069, JString, required = true,
                                 default = nil)
  if valid_594069 != nil:
    section.add "resourceGroupName", valid_594069
  var valid_594070 = path.getOrDefault("serverName")
  valid_594070 = validateParameter(valid_594070, JString, required = true,
                                 default = nil)
  if valid_594070 != nil:
    section.add "serverName", valid_594070
  var valid_594071 = path.getOrDefault("subscriptionId")
  valid_594071 = validateParameter(valid_594071, JString, required = true,
                                 default = nil)
  if valid_594071 != nil:
    section.add "subscriptionId", valid_594071
  var valid_594072 = path.getOrDefault("jobAgentName")
  valid_594072 = validateParameter(valid_594072, JString, required = true,
                                 default = nil)
  if valid_594072 != nil:
    section.add "jobAgentName", valid_594072
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
  var valid_594073 = query.getOrDefault("api-version")
  valid_594073 = validateParameter(valid_594073, JString, required = true,
                                 default = nil)
  if valid_594073 != nil:
    section.add "api-version", valid_594073
  var valid_594074 = query.getOrDefault("$top")
  valid_594074 = validateParameter(valid_594074, JInt, required = false, default = nil)
  if valid_594074 != nil:
    section.add "$top", valid_594074
  var valid_594075 = query.getOrDefault("endTimeMax")
  valid_594075 = validateParameter(valid_594075, JString, required = false,
                                 default = nil)
  if valid_594075 != nil:
    section.add "endTimeMax", valid_594075
  var valid_594076 = query.getOrDefault("createTimeMax")
  valid_594076 = validateParameter(valid_594076, JString, required = false,
                                 default = nil)
  if valid_594076 != nil:
    section.add "createTimeMax", valid_594076
  var valid_594077 = query.getOrDefault("$skip")
  valid_594077 = validateParameter(valid_594077, JInt, required = false, default = nil)
  if valid_594077 != nil:
    section.add "$skip", valid_594077
  var valid_594078 = query.getOrDefault("endTimeMin")
  valid_594078 = validateParameter(valid_594078, JString, required = false,
                                 default = nil)
  if valid_594078 != nil:
    section.add "endTimeMin", valid_594078
  var valid_594079 = query.getOrDefault("createTimeMin")
  valid_594079 = validateParameter(valid_594079, JString, required = false,
                                 default = nil)
  if valid_594079 != nil:
    section.add "createTimeMin", valid_594079
  var valid_594080 = query.getOrDefault("isActive")
  valid_594080 = validateParameter(valid_594080, JBool, required = false, default = nil)
  if valid_594080 != nil:
    section.add "isActive", valid_594080
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594081: Call_JobExecutionsListByAgent_594065; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all executions in a job agent.
  ## 
  let valid = call_594081.validator(path, query, header, formData, body)
  let scheme = call_594081.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594081.url(scheme.get, call_594081.host, call_594081.base,
                         call_594081.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594081, url, valid)

proc call*(call_594082: Call_JobExecutionsListByAgent_594065;
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
  var path_594083 = newJObject()
  var query_594084 = newJObject()
  add(path_594083, "resourceGroupName", newJString(resourceGroupName))
  add(query_594084, "api-version", newJString(apiVersion))
  add(path_594083, "serverName", newJString(serverName))
  add(path_594083, "subscriptionId", newJString(subscriptionId))
  add(path_594083, "jobAgentName", newJString(jobAgentName))
  add(query_594084, "$top", newJInt(Top))
  add(query_594084, "endTimeMax", newJString(endTimeMax))
  add(query_594084, "createTimeMax", newJString(createTimeMax))
  add(query_594084, "$skip", newJInt(Skip))
  add(query_594084, "endTimeMin", newJString(endTimeMin))
  add(query_594084, "createTimeMin", newJString(createTimeMin))
  add(query_594084, "isActive", newJBool(isActive))
  result = call_594082.call(path_594083, query_594084, nil, nil, nil)

var jobExecutionsListByAgent* = Call_JobExecutionsListByAgent_594065(
    name: "jobExecutionsListByAgent", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/servers/{serverName}/jobAgents/{jobAgentName}/executions",
    validator: validate_JobExecutionsListByAgent_594066, base: "",
    url: url_JobExecutionsListByAgent_594067, schemes: {Scheme.Https})
type
  Call_JobsListByAgent_594085 = ref object of OpenApiRestCall_593424
proc url_JobsListByAgent_594087(protocol: Scheme; host: string; base: string;
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

proc validate_JobsListByAgent_594086(path: JsonNode; query: JsonNode;
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
  var valid_594088 = path.getOrDefault("resourceGroupName")
  valid_594088 = validateParameter(valid_594088, JString, required = true,
                                 default = nil)
  if valid_594088 != nil:
    section.add "resourceGroupName", valid_594088
  var valid_594089 = path.getOrDefault("serverName")
  valid_594089 = validateParameter(valid_594089, JString, required = true,
                                 default = nil)
  if valid_594089 != nil:
    section.add "serverName", valid_594089
  var valid_594090 = path.getOrDefault("subscriptionId")
  valid_594090 = validateParameter(valid_594090, JString, required = true,
                                 default = nil)
  if valid_594090 != nil:
    section.add "subscriptionId", valid_594090
  var valid_594091 = path.getOrDefault("jobAgentName")
  valid_594091 = validateParameter(valid_594091, JString, required = true,
                                 default = nil)
  if valid_594091 != nil:
    section.add "jobAgentName", valid_594091
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594092 = query.getOrDefault("api-version")
  valid_594092 = validateParameter(valid_594092, JString, required = true,
                                 default = nil)
  if valid_594092 != nil:
    section.add "api-version", valid_594092
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594093: Call_JobsListByAgent_594085; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a list of jobs.
  ## 
  let valid = call_594093.validator(path, query, header, formData, body)
  let scheme = call_594093.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594093.url(scheme.get, call_594093.host, call_594093.base,
                         call_594093.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594093, url, valid)

proc call*(call_594094: Call_JobsListByAgent_594085; resourceGroupName: string;
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
  var path_594095 = newJObject()
  var query_594096 = newJObject()
  add(path_594095, "resourceGroupName", newJString(resourceGroupName))
  add(query_594096, "api-version", newJString(apiVersion))
  add(path_594095, "serverName", newJString(serverName))
  add(path_594095, "subscriptionId", newJString(subscriptionId))
  add(path_594095, "jobAgentName", newJString(jobAgentName))
  result = call_594094.call(path_594095, query_594096, nil, nil, nil)

var jobsListByAgent* = Call_JobsListByAgent_594085(name: "jobsListByAgent",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/servers/{serverName}/jobAgents/{jobAgentName}/jobs",
    validator: validate_JobsListByAgent_594086, base: "", url: url_JobsListByAgent_594087,
    schemes: {Scheme.Https})
type
  Call_JobsCreateOrUpdate_594110 = ref object of OpenApiRestCall_593424
proc url_JobsCreateOrUpdate_594112(protocol: Scheme; host: string; base: string;
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

proc validate_JobsCreateOrUpdate_594111(path: JsonNode; query: JsonNode;
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
  var valid_594113 = path.getOrDefault("resourceGroupName")
  valid_594113 = validateParameter(valid_594113, JString, required = true,
                                 default = nil)
  if valid_594113 != nil:
    section.add "resourceGroupName", valid_594113
  var valid_594114 = path.getOrDefault("serverName")
  valid_594114 = validateParameter(valid_594114, JString, required = true,
                                 default = nil)
  if valid_594114 != nil:
    section.add "serverName", valid_594114
  var valid_594115 = path.getOrDefault("subscriptionId")
  valid_594115 = validateParameter(valid_594115, JString, required = true,
                                 default = nil)
  if valid_594115 != nil:
    section.add "subscriptionId", valid_594115
  var valid_594116 = path.getOrDefault("jobAgentName")
  valid_594116 = validateParameter(valid_594116, JString, required = true,
                                 default = nil)
  if valid_594116 != nil:
    section.add "jobAgentName", valid_594116
  var valid_594117 = path.getOrDefault("jobName")
  valid_594117 = validateParameter(valid_594117, JString, required = true,
                                 default = nil)
  if valid_594117 != nil:
    section.add "jobName", valid_594117
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594118 = query.getOrDefault("api-version")
  valid_594118 = validateParameter(valid_594118, JString, required = true,
                                 default = nil)
  if valid_594118 != nil:
    section.add "api-version", valid_594118
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

proc call*(call_594120: Call_JobsCreateOrUpdate_594110; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates a job.
  ## 
  let valid = call_594120.validator(path, query, header, formData, body)
  let scheme = call_594120.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594120.url(scheme.get, call_594120.host, call_594120.base,
                         call_594120.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594120, url, valid)

proc call*(call_594121: Call_JobsCreateOrUpdate_594110; resourceGroupName: string;
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
  var path_594122 = newJObject()
  var query_594123 = newJObject()
  var body_594124 = newJObject()
  add(path_594122, "resourceGroupName", newJString(resourceGroupName))
  add(query_594123, "api-version", newJString(apiVersion))
  add(path_594122, "serverName", newJString(serverName))
  add(path_594122, "subscriptionId", newJString(subscriptionId))
  add(path_594122, "jobAgentName", newJString(jobAgentName))
  add(path_594122, "jobName", newJString(jobName))
  if parameters != nil:
    body_594124 = parameters
  result = call_594121.call(path_594122, query_594123, nil, nil, body_594124)

var jobsCreateOrUpdate* = Call_JobsCreateOrUpdate_594110(
    name: "jobsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/servers/{serverName}/jobAgents/{jobAgentName}/jobs/{jobName}",
    validator: validate_JobsCreateOrUpdate_594111, base: "",
    url: url_JobsCreateOrUpdate_594112, schemes: {Scheme.Https})
type
  Call_JobsGet_594097 = ref object of OpenApiRestCall_593424
proc url_JobsGet_594099(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_JobsGet_594098(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594100 = path.getOrDefault("resourceGroupName")
  valid_594100 = validateParameter(valid_594100, JString, required = true,
                                 default = nil)
  if valid_594100 != nil:
    section.add "resourceGroupName", valid_594100
  var valid_594101 = path.getOrDefault("serverName")
  valid_594101 = validateParameter(valid_594101, JString, required = true,
                                 default = nil)
  if valid_594101 != nil:
    section.add "serverName", valid_594101
  var valid_594102 = path.getOrDefault("subscriptionId")
  valid_594102 = validateParameter(valid_594102, JString, required = true,
                                 default = nil)
  if valid_594102 != nil:
    section.add "subscriptionId", valid_594102
  var valid_594103 = path.getOrDefault("jobAgentName")
  valid_594103 = validateParameter(valid_594103, JString, required = true,
                                 default = nil)
  if valid_594103 != nil:
    section.add "jobAgentName", valid_594103
  var valid_594104 = path.getOrDefault("jobName")
  valid_594104 = validateParameter(valid_594104, JString, required = true,
                                 default = nil)
  if valid_594104 != nil:
    section.add "jobName", valid_594104
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594105 = query.getOrDefault("api-version")
  valid_594105 = validateParameter(valid_594105, JString, required = true,
                                 default = nil)
  if valid_594105 != nil:
    section.add "api-version", valid_594105
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594106: Call_JobsGet_594097; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a job.
  ## 
  let valid = call_594106.validator(path, query, header, formData, body)
  let scheme = call_594106.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594106.url(scheme.get, call_594106.host, call_594106.base,
                         call_594106.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594106, url, valid)

proc call*(call_594107: Call_JobsGet_594097; resourceGroupName: string;
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
  var path_594108 = newJObject()
  var query_594109 = newJObject()
  add(path_594108, "resourceGroupName", newJString(resourceGroupName))
  add(query_594109, "api-version", newJString(apiVersion))
  add(path_594108, "serverName", newJString(serverName))
  add(path_594108, "subscriptionId", newJString(subscriptionId))
  add(path_594108, "jobAgentName", newJString(jobAgentName))
  add(path_594108, "jobName", newJString(jobName))
  result = call_594107.call(path_594108, query_594109, nil, nil, nil)

var jobsGet* = Call_JobsGet_594097(name: "jobsGet", meth: HttpMethod.HttpGet,
                                host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/servers/{serverName}/jobAgents/{jobAgentName}/jobs/{jobName}",
                                validator: validate_JobsGet_594098, base: "",
                                url: url_JobsGet_594099, schemes: {Scheme.Https})
type
  Call_JobsDelete_594125 = ref object of OpenApiRestCall_593424
proc url_JobsDelete_594127(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_JobsDelete_594126(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594128 = path.getOrDefault("resourceGroupName")
  valid_594128 = validateParameter(valid_594128, JString, required = true,
                                 default = nil)
  if valid_594128 != nil:
    section.add "resourceGroupName", valid_594128
  var valid_594129 = path.getOrDefault("serverName")
  valid_594129 = validateParameter(valid_594129, JString, required = true,
                                 default = nil)
  if valid_594129 != nil:
    section.add "serverName", valid_594129
  var valid_594130 = path.getOrDefault("subscriptionId")
  valid_594130 = validateParameter(valid_594130, JString, required = true,
                                 default = nil)
  if valid_594130 != nil:
    section.add "subscriptionId", valid_594130
  var valid_594131 = path.getOrDefault("jobAgentName")
  valid_594131 = validateParameter(valid_594131, JString, required = true,
                                 default = nil)
  if valid_594131 != nil:
    section.add "jobAgentName", valid_594131
  var valid_594132 = path.getOrDefault("jobName")
  valid_594132 = validateParameter(valid_594132, JString, required = true,
                                 default = nil)
  if valid_594132 != nil:
    section.add "jobName", valid_594132
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594133 = query.getOrDefault("api-version")
  valid_594133 = validateParameter(valid_594133, JString, required = true,
                                 default = nil)
  if valid_594133 != nil:
    section.add "api-version", valid_594133
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594134: Call_JobsDelete_594125; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a job.
  ## 
  let valid = call_594134.validator(path, query, header, formData, body)
  let scheme = call_594134.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594134.url(scheme.get, call_594134.host, call_594134.base,
                         call_594134.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594134, url, valid)

proc call*(call_594135: Call_JobsDelete_594125; resourceGroupName: string;
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
  var path_594136 = newJObject()
  var query_594137 = newJObject()
  add(path_594136, "resourceGroupName", newJString(resourceGroupName))
  add(query_594137, "api-version", newJString(apiVersion))
  add(path_594136, "serverName", newJString(serverName))
  add(path_594136, "subscriptionId", newJString(subscriptionId))
  add(path_594136, "jobAgentName", newJString(jobAgentName))
  add(path_594136, "jobName", newJString(jobName))
  result = call_594135.call(path_594136, query_594137, nil, nil, nil)

var jobsDelete* = Call_JobsDelete_594125(name: "jobsDelete",
                                      meth: HttpMethod.HttpDelete,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/servers/{serverName}/jobAgents/{jobAgentName}/jobs/{jobName}",
                                      validator: validate_JobsDelete_594126,
                                      base: "", url: url_JobsDelete_594127,
                                      schemes: {Scheme.Https})
type
  Call_JobExecutionsListByJob_594138 = ref object of OpenApiRestCall_593424
proc url_JobExecutionsListByJob_594140(protocol: Scheme; host: string; base: string;
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

proc validate_JobExecutionsListByJob_594139(path: JsonNode; query: JsonNode;
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
  var valid_594141 = path.getOrDefault("resourceGroupName")
  valid_594141 = validateParameter(valid_594141, JString, required = true,
                                 default = nil)
  if valid_594141 != nil:
    section.add "resourceGroupName", valid_594141
  var valid_594142 = path.getOrDefault("serverName")
  valid_594142 = validateParameter(valid_594142, JString, required = true,
                                 default = nil)
  if valid_594142 != nil:
    section.add "serverName", valid_594142
  var valid_594143 = path.getOrDefault("subscriptionId")
  valid_594143 = validateParameter(valid_594143, JString, required = true,
                                 default = nil)
  if valid_594143 != nil:
    section.add "subscriptionId", valid_594143
  var valid_594144 = path.getOrDefault("jobAgentName")
  valid_594144 = validateParameter(valid_594144, JString, required = true,
                                 default = nil)
  if valid_594144 != nil:
    section.add "jobAgentName", valid_594144
  var valid_594145 = path.getOrDefault("jobName")
  valid_594145 = validateParameter(valid_594145, JString, required = true,
                                 default = nil)
  if valid_594145 != nil:
    section.add "jobName", valid_594145
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
  var valid_594146 = query.getOrDefault("api-version")
  valid_594146 = validateParameter(valid_594146, JString, required = true,
                                 default = nil)
  if valid_594146 != nil:
    section.add "api-version", valid_594146
  var valid_594147 = query.getOrDefault("$top")
  valid_594147 = validateParameter(valid_594147, JInt, required = false, default = nil)
  if valid_594147 != nil:
    section.add "$top", valid_594147
  var valid_594148 = query.getOrDefault("endTimeMax")
  valid_594148 = validateParameter(valid_594148, JString, required = false,
                                 default = nil)
  if valid_594148 != nil:
    section.add "endTimeMax", valid_594148
  var valid_594149 = query.getOrDefault("createTimeMax")
  valid_594149 = validateParameter(valid_594149, JString, required = false,
                                 default = nil)
  if valid_594149 != nil:
    section.add "createTimeMax", valid_594149
  var valid_594150 = query.getOrDefault("$skip")
  valid_594150 = validateParameter(valid_594150, JInt, required = false, default = nil)
  if valid_594150 != nil:
    section.add "$skip", valid_594150
  var valid_594151 = query.getOrDefault("endTimeMin")
  valid_594151 = validateParameter(valid_594151, JString, required = false,
                                 default = nil)
  if valid_594151 != nil:
    section.add "endTimeMin", valid_594151
  var valid_594152 = query.getOrDefault("createTimeMin")
  valid_594152 = validateParameter(valid_594152, JString, required = false,
                                 default = nil)
  if valid_594152 != nil:
    section.add "createTimeMin", valid_594152
  var valid_594153 = query.getOrDefault("isActive")
  valid_594153 = validateParameter(valid_594153, JBool, required = false, default = nil)
  if valid_594153 != nil:
    section.add "isActive", valid_594153
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594154: Call_JobExecutionsListByJob_594138; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists a job's executions.
  ## 
  let valid = call_594154.validator(path, query, header, formData, body)
  let scheme = call_594154.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594154.url(scheme.get, call_594154.host, call_594154.base,
                         call_594154.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594154, url, valid)

proc call*(call_594155: Call_JobExecutionsListByJob_594138;
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
  var path_594156 = newJObject()
  var query_594157 = newJObject()
  add(path_594156, "resourceGroupName", newJString(resourceGroupName))
  add(query_594157, "api-version", newJString(apiVersion))
  add(path_594156, "serverName", newJString(serverName))
  add(path_594156, "subscriptionId", newJString(subscriptionId))
  add(path_594156, "jobAgentName", newJString(jobAgentName))
  add(path_594156, "jobName", newJString(jobName))
  add(query_594157, "$top", newJInt(Top))
  add(query_594157, "endTimeMax", newJString(endTimeMax))
  add(query_594157, "createTimeMax", newJString(createTimeMax))
  add(query_594157, "$skip", newJInt(Skip))
  add(query_594157, "endTimeMin", newJString(endTimeMin))
  add(query_594157, "createTimeMin", newJString(createTimeMin))
  add(query_594157, "isActive", newJBool(isActive))
  result = call_594155.call(path_594156, query_594157, nil, nil, nil)

var jobExecutionsListByJob* = Call_JobExecutionsListByJob_594138(
    name: "jobExecutionsListByJob", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/servers/{serverName}/jobAgents/{jobAgentName}/jobs/{jobName}/executions",
    validator: validate_JobExecutionsListByJob_594139, base: "",
    url: url_JobExecutionsListByJob_594140, schemes: {Scheme.Https})
type
  Call_JobExecutionsCreateOrUpdate_594172 = ref object of OpenApiRestCall_593424
proc url_JobExecutionsCreateOrUpdate_594174(protocol: Scheme; host: string;
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

proc validate_JobExecutionsCreateOrUpdate_594173(path: JsonNode; query: JsonNode;
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
  var valid_594175 = path.getOrDefault("resourceGroupName")
  valid_594175 = validateParameter(valid_594175, JString, required = true,
                                 default = nil)
  if valid_594175 != nil:
    section.add "resourceGroupName", valid_594175
  var valid_594176 = path.getOrDefault("serverName")
  valid_594176 = validateParameter(valid_594176, JString, required = true,
                                 default = nil)
  if valid_594176 != nil:
    section.add "serverName", valid_594176
  var valid_594177 = path.getOrDefault("subscriptionId")
  valid_594177 = validateParameter(valid_594177, JString, required = true,
                                 default = nil)
  if valid_594177 != nil:
    section.add "subscriptionId", valid_594177
  var valid_594178 = path.getOrDefault("jobAgentName")
  valid_594178 = validateParameter(valid_594178, JString, required = true,
                                 default = nil)
  if valid_594178 != nil:
    section.add "jobAgentName", valid_594178
  var valid_594179 = path.getOrDefault("jobName")
  valid_594179 = validateParameter(valid_594179, JString, required = true,
                                 default = nil)
  if valid_594179 != nil:
    section.add "jobName", valid_594179
  var valid_594180 = path.getOrDefault("jobExecutionId")
  valid_594180 = validateParameter(valid_594180, JString, required = true,
                                 default = nil)
  if valid_594180 != nil:
    section.add "jobExecutionId", valid_594180
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594181 = query.getOrDefault("api-version")
  valid_594181 = validateParameter(valid_594181, JString, required = true,
                                 default = nil)
  if valid_594181 != nil:
    section.add "api-version", valid_594181
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594182: Call_JobExecutionsCreateOrUpdate_594172; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates a job execution.
  ## 
  let valid = call_594182.validator(path, query, header, formData, body)
  let scheme = call_594182.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594182.url(scheme.get, call_594182.host, call_594182.base,
                         call_594182.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594182, url, valid)

proc call*(call_594183: Call_JobExecutionsCreateOrUpdate_594172;
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
  var path_594184 = newJObject()
  var query_594185 = newJObject()
  add(path_594184, "resourceGroupName", newJString(resourceGroupName))
  add(query_594185, "api-version", newJString(apiVersion))
  add(path_594184, "serverName", newJString(serverName))
  add(path_594184, "subscriptionId", newJString(subscriptionId))
  add(path_594184, "jobAgentName", newJString(jobAgentName))
  add(path_594184, "jobName", newJString(jobName))
  add(path_594184, "jobExecutionId", newJString(jobExecutionId))
  result = call_594183.call(path_594184, query_594185, nil, nil, nil)

var jobExecutionsCreateOrUpdate* = Call_JobExecutionsCreateOrUpdate_594172(
    name: "jobExecutionsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/servers/{serverName}/jobAgents/{jobAgentName}/jobs/{jobName}/executions/{jobExecutionId}",
    validator: validate_JobExecutionsCreateOrUpdate_594173, base: "",
    url: url_JobExecutionsCreateOrUpdate_594174, schemes: {Scheme.Https})
type
  Call_JobExecutionsGet_594158 = ref object of OpenApiRestCall_593424
proc url_JobExecutionsGet_594160(protocol: Scheme; host: string; base: string;
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

proc validate_JobExecutionsGet_594159(path: JsonNode; query: JsonNode;
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
  var valid_594161 = path.getOrDefault("resourceGroupName")
  valid_594161 = validateParameter(valid_594161, JString, required = true,
                                 default = nil)
  if valid_594161 != nil:
    section.add "resourceGroupName", valid_594161
  var valid_594162 = path.getOrDefault("serverName")
  valid_594162 = validateParameter(valid_594162, JString, required = true,
                                 default = nil)
  if valid_594162 != nil:
    section.add "serverName", valid_594162
  var valid_594163 = path.getOrDefault("subscriptionId")
  valid_594163 = validateParameter(valid_594163, JString, required = true,
                                 default = nil)
  if valid_594163 != nil:
    section.add "subscriptionId", valid_594163
  var valid_594164 = path.getOrDefault("jobAgentName")
  valid_594164 = validateParameter(valid_594164, JString, required = true,
                                 default = nil)
  if valid_594164 != nil:
    section.add "jobAgentName", valid_594164
  var valid_594165 = path.getOrDefault("jobName")
  valid_594165 = validateParameter(valid_594165, JString, required = true,
                                 default = nil)
  if valid_594165 != nil:
    section.add "jobName", valid_594165
  var valid_594166 = path.getOrDefault("jobExecutionId")
  valid_594166 = validateParameter(valid_594166, JString, required = true,
                                 default = nil)
  if valid_594166 != nil:
    section.add "jobExecutionId", valid_594166
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594167 = query.getOrDefault("api-version")
  valid_594167 = validateParameter(valid_594167, JString, required = true,
                                 default = nil)
  if valid_594167 != nil:
    section.add "api-version", valid_594167
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594168: Call_JobExecutionsGet_594158; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a job execution.
  ## 
  let valid = call_594168.validator(path, query, header, formData, body)
  let scheme = call_594168.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594168.url(scheme.get, call_594168.host, call_594168.base,
                         call_594168.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594168, url, valid)

proc call*(call_594169: Call_JobExecutionsGet_594158; resourceGroupName: string;
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
  var path_594170 = newJObject()
  var query_594171 = newJObject()
  add(path_594170, "resourceGroupName", newJString(resourceGroupName))
  add(query_594171, "api-version", newJString(apiVersion))
  add(path_594170, "serverName", newJString(serverName))
  add(path_594170, "subscriptionId", newJString(subscriptionId))
  add(path_594170, "jobAgentName", newJString(jobAgentName))
  add(path_594170, "jobName", newJString(jobName))
  add(path_594170, "jobExecutionId", newJString(jobExecutionId))
  result = call_594169.call(path_594170, query_594171, nil, nil, nil)

var jobExecutionsGet* = Call_JobExecutionsGet_594158(name: "jobExecutionsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/servers/{serverName}/jobAgents/{jobAgentName}/jobs/{jobName}/executions/{jobExecutionId}",
    validator: validate_JobExecutionsGet_594159, base: "",
    url: url_JobExecutionsGet_594160, schemes: {Scheme.Https})
type
  Call_JobExecutionsCancel_594186 = ref object of OpenApiRestCall_593424
proc url_JobExecutionsCancel_594188(protocol: Scheme; host: string; base: string;
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

proc validate_JobExecutionsCancel_594187(path: JsonNode; query: JsonNode;
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
  var valid_594189 = path.getOrDefault("resourceGroupName")
  valid_594189 = validateParameter(valid_594189, JString, required = true,
                                 default = nil)
  if valid_594189 != nil:
    section.add "resourceGroupName", valid_594189
  var valid_594190 = path.getOrDefault("serverName")
  valid_594190 = validateParameter(valid_594190, JString, required = true,
                                 default = nil)
  if valid_594190 != nil:
    section.add "serverName", valid_594190
  var valid_594191 = path.getOrDefault("subscriptionId")
  valid_594191 = validateParameter(valid_594191, JString, required = true,
                                 default = nil)
  if valid_594191 != nil:
    section.add "subscriptionId", valid_594191
  var valid_594192 = path.getOrDefault("jobAgentName")
  valid_594192 = validateParameter(valid_594192, JString, required = true,
                                 default = nil)
  if valid_594192 != nil:
    section.add "jobAgentName", valid_594192
  var valid_594193 = path.getOrDefault("jobName")
  valid_594193 = validateParameter(valid_594193, JString, required = true,
                                 default = nil)
  if valid_594193 != nil:
    section.add "jobName", valid_594193
  var valid_594194 = path.getOrDefault("jobExecutionId")
  valid_594194 = validateParameter(valid_594194, JString, required = true,
                                 default = nil)
  if valid_594194 != nil:
    section.add "jobExecutionId", valid_594194
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594195 = query.getOrDefault("api-version")
  valid_594195 = validateParameter(valid_594195, JString, required = true,
                                 default = nil)
  if valid_594195 != nil:
    section.add "api-version", valid_594195
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594196: Call_JobExecutionsCancel_594186; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Requests cancellation of a job execution.
  ## 
  let valid = call_594196.validator(path, query, header, formData, body)
  let scheme = call_594196.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594196.url(scheme.get, call_594196.host, call_594196.base,
                         call_594196.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594196, url, valid)

proc call*(call_594197: Call_JobExecutionsCancel_594186; resourceGroupName: string;
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
  var path_594198 = newJObject()
  var query_594199 = newJObject()
  add(path_594198, "resourceGroupName", newJString(resourceGroupName))
  add(query_594199, "api-version", newJString(apiVersion))
  add(path_594198, "serverName", newJString(serverName))
  add(path_594198, "subscriptionId", newJString(subscriptionId))
  add(path_594198, "jobAgentName", newJString(jobAgentName))
  add(path_594198, "jobName", newJString(jobName))
  add(path_594198, "jobExecutionId", newJString(jobExecutionId))
  result = call_594197.call(path_594198, query_594199, nil, nil, nil)

var jobExecutionsCancel* = Call_JobExecutionsCancel_594186(
    name: "jobExecutionsCancel", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/servers/{serverName}/jobAgents/{jobAgentName}/jobs/{jobName}/executions/{jobExecutionId}/cancel",
    validator: validate_JobExecutionsCancel_594187, base: "",
    url: url_JobExecutionsCancel_594188, schemes: {Scheme.Https})
type
  Call_JobStepExecutionsListByJobExecution_594200 = ref object of OpenApiRestCall_593424
proc url_JobStepExecutionsListByJobExecution_594202(protocol: Scheme; host: string;
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

proc validate_JobStepExecutionsListByJobExecution_594201(path: JsonNode;
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
  var valid_594203 = path.getOrDefault("resourceGroupName")
  valid_594203 = validateParameter(valid_594203, JString, required = true,
                                 default = nil)
  if valid_594203 != nil:
    section.add "resourceGroupName", valid_594203
  var valid_594204 = path.getOrDefault("serverName")
  valid_594204 = validateParameter(valid_594204, JString, required = true,
                                 default = nil)
  if valid_594204 != nil:
    section.add "serverName", valid_594204
  var valid_594205 = path.getOrDefault("subscriptionId")
  valid_594205 = validateParameter(valid_594205, JString, required = true,
                                 default = nil)
  if valid_594205 != nil:
    section.add "subscriptionId", valid_594205
  var valid_594206 = path.getOrDefault("jobAgentName")
  valid_594206 = validateParameter(valid_594206, JString, required = true,
                                 default = nil)
  if valid_594206 != nil:
    section.add "jobAgentName", valid_594206
  var valid_594207 = path.getOrDefault("jobName")
  valid_594207 = validateParameter(valid_594207, JString, required = true,
                                 default = nil)
  if valid_594207 != nil:
    section.add "jobName", valid_594207
  var valid_594208 = path.getOrDefault("jobExecutionId")
  valid_594208 = validateParameter(valid_594208, JString, required = true,
                                 default = nil)
  if valid_594208 != nil:
    section.add "jobExecutionId", valid_594208
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
  var valid_594209 = query.getOrDefault("api-version")
  valid_594209 = validateParameter(valid_594209, JString, required = true,
                                 default = nil)
  if valid_594209 != nil:
    section.add "api-version", valid_594209
  var valid_594210 = query.getOrDefault("$top")
  valid_594210 = validateParameter(valid_594210, JInt, required = false, default = nil)
  if valid_594210 != nil:
    section.add "$top", valid_594210
  var valid_594211 = query.getOrDefault("endTimeMax")
  valid_594211 = validateParameter(valid_594211, JString, required = false,
                                 default = nil)
  if valid_594211 != nil:
    section.add "endTimeMax", valid_594211
  var valid_594212 = query.getOrDefault("createTimeMax")
  valid_594212 = validateParameter(valid_594212, JString, required = false,
                                 default = nil)
  if valid_594212 != nil:
    section.add "createTimeMax", valid_594212
  var valid_594213 = query.getOrDefault("$skip")
  valid_594213 = validateParameter(valid_594213, JInt, required = false, default = nil)
  if valid_594213 != nil:
    section.add "$skip", valid_594213
  var valid_594214 = query.getOrDefault("endTimeMin")
  valid_594214 = validateParameter(valid_594214, JString, required = false,
                                 default = nil)
  if valid_594214 != nil:
    section.add "endTimeMin", valid_594214
  var valid_594215 = query.getOrDefault("createTimeMin")
  valid_594215 = validateParameter(valid_594215, JString, required = false,
                                 default = nil)
  if valid_594215 != nil:
    section.add "createTimeMin", valid_594215
  var valid_594216 = query.getOrDefault("isActive")
  valid_594216 = validateParameter(valid_594216, JBool, required = false, default = nil)
  if valid_594216 != nil:
    section.add "isActive", valid_594216
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594217: Call_JobStepExecutionsListByJobExecution_594200;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the step executions of a job execution.
  ## 
  let valid = call_594217.validator(path, query, header, formData, body)
  let scheme = call_594217.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594217.url(scheme.get, call_594217.host, call_594217.base,
                         call_594217.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594217, url, valid)

proc call*(call_594218: Call_JobStepExecutionsListByJobExecution_594200;
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
  var path_594219 = newJObject()
  var query_594220 = newJObject()
  add(path_594219, "resourceGroupName", newJString(resourceGroupName))
  add(query_594220, "api-version", newJString(apiVersion))
  add(path_594219, "serverName", newJString(serverName))
  add(path_594219, "subscriptionId", newJString(subscriptionId))
  add(path_594219, "jobAgentName", newJString(jobAgentName))
  add(path_594219, "jobName", newJString(jobName))
  add(query_594220, "$top", newJInt(Top))
  add(query_594220, "endTimeMax", newJString(endTimeMax))
  add(query_594220, "createTimeMax", newJString(createTimeMax))
  add(query_594220, "$skip", newJInt(Skip))
  add(query_594220, "endTimeMin", newJString(endTimeMin))
  add(path_594219, "jobExecutionId", newJString(jobExecutionId))
  add(query_594220, "createTimeMin", newJString(createTimeMin))
  add(query_594220, "isActive", newJBool(isActive))
  result = call_594218.call(path_594219, query_594220, nil, nil, nil)

var jobStepExecutionsListByJobExecution* = Call_JobStepExecutionsListByJobExecution_594200(
    name: "jobStepExecutionsListByJobExecution", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/servers/{serverName}/jobAgents/{jobAgentName}/jobs/{jobName}/executions/{jobExecutionId}/steps",
    validator: validate_JobStepExecutionsListByJobExecution_594201, base: "",
    url: url_JobStepExecutionsListByJobExecution_594202, schemes: {Scheme.Https})
type
  Call_JobStepExecutionsGet_594221 = ref object of OpenApiRestCall_593424
proc url_JobStepExecutionsGet_594223(protocol: Scheme; host: string; base: string;
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

proc validate_JobStepExecutionsGet_594222(path: JsonNode; query: JsonNode;
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
  var valid_594224 = path.getOrDefault("resourceGroupName")
  valid_594224 = validateParameter(valid_594224, JString, required = true,
                                 default = nil)
  if valid_594224 != nil:
    section.add "resourceGroupName", valid_594224
  var valid_594225 = path.getOrDefault("serverName")
  valid_594225 = validateParameter(valid_594225, JString, required = true,
                                 default = nil)
  if valid_594225 != nil:
    section.add "serverName", valid_594225
  var valid_594226 = path.getOrDefault("stepName")
  valid_594226 = validateParameter(valid_594226, JString, required = true,
                                 default = nil)
  if valid_594226 != nil:
    section.add "stepName", valid_594226
  var valid_594227 = path.getOrDefault("subscriptionId")
  valid_594227 = validateParameter(valid_594227, JString, required = true,
                                 default = nil)
  if valid_594227 != nil:
    section.add "subscriptionId", valid_594227
  var valid_594228 = path.getOrDefault("jobAgentName")
  valid_594228 = validateParameter(valid_594228, JString, required = true,
                                 default = nil)
  if valid_594228 != nil:
    section.add "jobAgentName", valid_594228
  var valid_594229 = path.getOrDefault("jobName")
  valid_594229 = validateParameter(valid_594229, JString, required = true,
                                 default = nil)
  if valid_594229 != nil:
    section.add "jobName", valid_594229
  var valid_594230 = path.getOrDefault("jobExecutionId")
  valid_594230 = validateParameter(valid_594230, JString, required = true,
                                 default = nil)
  if valid_594230 != nil:
    section.add "jobExecutionId", valid_594230
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594231 = query.getOrDefault("api-version")
  valid_594231 = validateParameter(valid_594231, JString, required = true,
                                 default = nil)
  if valid_594231 != nil:
    section.add "api-version", valid_594231
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594232: Call_JobStepExecutionsGet_594221; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a step execution of a job execution.
  ## 
  let valid = call_594232.validator(path, query, header, formData, body)
  let scheme = call_594232.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594232.url(scheme.get, call_594232.host, call_594232.base,
                         call_594232.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594232, url, valid)

proc call*(call_594233: Call_JobStepExecutionsGet_594221;
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
  var path_594234 = newJObject()
  var query_594235 = newJObject()
  add(path_594234, "resourceGroupName", newJString(resourceGroupName))
  add(query_594235, "api-version", newJString(apiVersion))
  add(path_594234, "serverName", newJString(serverName))
  add(path_594234, "stepName", newJString(stepName))
  add(path_594234, "subscriptionId", newJString(subscriptionId))
  add(path_594234, "jobAgentName", newJString(jobAgentName))
  add(path_594234, "jobName", newJString(jobName))
  add(path_594234, "jobExecutionId", newJString(jobExecutionId))
  result = call_594233.call(path_594234, query_594235, nil, nil, nil)

var jobStepExecutionsGet* = Call_JobStepExecutionsGet_594221(
    name: "jobStepExecutionsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/servers/{serverName}/jobAgents/{jobAgentName}/jobs/{jobName}/executions/{jobExecutionId}/steps/{stepName}",
    validator: validate_JobStepExecutionsGet_594222, base: "",
    url: url_JobStepExecutionsGet_594223, schemes: {Scheme.Https})
type
  Call_JobTargetExecutionsListByStep_594236 = ref object of OpenApiRestCall_593424
proc url_JobTargetExecutionsListByStep_594238(protocol: Scheme; host: string;
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

proc validate_JobTargetExecutionsListByStep_594237(path: JsonNode; query: JsonNode;
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
  var valid_594239 = path.getOrDefault("resourceGroupName")
  valid_594239 = validateParameter(valid_594239, JString, required = true,
                                 default = nil)
  if valid_594239 != nil:
    section.add "resourceGroupName", valid_594239
  var valid_594240 = path.getOrDefault("serverName")
  valid_594240 = validateParameter(valid_594240, JString, required = true,
                                 default = nil)
  if valid_594240 != nil:
    section.add "serverName", valid_594240
  var valid_594241 = path.getOrDefault("stepName")
  valid_594241 = validateParameter(valid_594241, JString, required = true,
                                 default = nil)
  if valid_594241 != nil:
    section.add "stepName", valid_594241
  var valid_594242 = path.getOrDefault("subscriptionId")
  valid_594242 = validateParameter(valid_594242, JString, required = true,
                                 default = nil)
  if valid_594242 != nil:
    section.add "subscriptionId", valid_594242
  var valid_594243 = path.getOrDefault("jobAgentName")
  valid_594243 = validateParameter(valid_594243, JString, required = true,
                                 default = nil)
  if valid_594243 != nil:
    section.add "jobAgentName", valid_594243
  var valid_594244 = path.getOrDefault("jobName")
  valid_594244 = validateParameter(valid_594244, JString, required = true,
                                 default = nil)
  if valid_594244 != nil:
    section.add "jobName", valid_594244
  var valid_594245 = path.getOrDefault("jobExecutionId")
  valid_594245 = validateParameter(valid_594245, JString, required = true,
                                 default = nil)
  if valid_594245 != nil:
    section.add "jobExecutionId", valid_594245
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
  var valid_594246 = query.getOrDefault("api-version")
  valid_594246 = validateParameter(valid_594246, JString, required = true,
                                 default = nil)
  if valid_594246 != nil:
    section.add "api-version", valid_594246
  var valid_594247 = query.getOrDefault("$top")
  valid_594247 = validateParameter(valid_594247, JInt, required = false, default = nil)
  if valid_594247 != nil:
    section.add "$top", valid_594247
  var valid_594248 = query.getOrDefault("endTimeMax")
  valid_594248 = validateParameter(valid_594248, JString, required = false,
                                 default = nil)
  if valid_594248 != nil:
    section.add "endTimeMax", valid_594248
  var valid_594249 = query.getOrDefault("createTimeMax")
  valid_594249 = validateParameter(valid_594249, JString, required = false,
                                 default = nil)
  if valid_594249 != nil:
    section.add "createTimeMax", valid_594249
  var valid_594250 = query.getOrDefault("$skip")
  valid_594250 = validateParameter(valid_594250, JInt, required = false, default = nil)
  if valid_594250 != nil:
    section.add "$skip", valid_594250
  var valid_594251 = query.getOrDefault("endTimeMin")
  valid_594251 = validateParameter(valid_594251, JString, required = false,
                                 default = nil)
  if valid_594251 != nil:
    section.add "endTimeMin", valid_594251
  var valid_594252 = query.getOrDefault("createTimeMin")
  valid_594252 = validateParameter(valid_594252, JString, required = false,
                                 default = nil)
  if valid_594252 != nil:
    section.add "createTimeMin", valid_594252
  var valid_594253 = query.getOrDefault("isActive")
  valid_594253 = validateParameter(valid_594253, JBool, required = false, default = nil)
  if valid_594253 != nil:
    section.add "isActive", valid_594253
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594254: Call_JobTargetExecutionsListByStep_594236; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the target executions of a job step execution.
  ## 
  let valid = call_594254.validator(path, query, header, formData, body)
  let scheme = call_594254.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594254.url(scheme.get, call_594254.host, call_594254.base,
                         call_594254.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594254, url, valid)

proc call*(call_594255: Call_JobTargetExecutionsListByStep_594236;
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
  var path_594256 = newJObject()
  var query_594257 = newJObject()
  add(path_594256, "resourceGroupName", newJString(resourceGroupName))
  add(query_594257, "api-version", newJString(apiVersion))
  add(path_594256, "serverName", newJString(serverName))
  add(path_594256, "stepName", newJString(stepName))
  add(path_594256, "subscriptionId", newJString(subscriptionId))
  add(path_594256, "jobAgentName", newJString(jobAgentName))
  add(path_594256, "jobName", newJString(jobName))
  add(query_594257, "$top", newJInt(Top))
  add(query_594257, "endTimeMax", newJString(endTimeMax))
  add(query_594257, "createTimeMax", newJString(createTimeMax))
  add(query_594257, "$skip", newJInt(Skip))
  add(query_594257, "endTimeMin", newJString(endTimeMin))
  add(path_594256, "jobExecutionId", newJString(jobExecutionId))
  add(query_594257, "createTimeMin", newJString(createTimeMin))
  add(query_594257, "isActive", newJBool(isActive))
  result = call_594255.call(path_594256, query_594257, nil, nil, nil)

var jobTargetExecutionsListByStep* = Call_JobTargetExecutionsListByStep_594236(
    name: "jobTargetExecutionsListByStep", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/servers/{serverName}/jobAgents/{jobAgentName}/jobs/{jobName}/executions/{jobExecutionId}/steps/{stepName}/targets",
    validator: validate_JobTargetExecutionsListByStep_594237, base: "",
    url: url_JobTargetExecutionsListByStep_594238, schemes: {Scheme.Https})
type
  Call_JobTargetExecutionsGet_594258 = ref object of OpenApiRestCall_593424
proc url_JobTargetExecutionsGet_594260(protocol: Scheme; host: string; base: string;
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

proc validate_JobTargetExecutionsGet_594259(path: JsonNode; query: JsonNode;
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
  var valid_594261 = path.getOrDefault("resourceGroupName")
  valid_594261 = validateParameter(valid_594261, JString, required = true,
                                 default = nil)
  if valid_594261 != nil:
    section.add "resourceGroupName", valid_594261
  var valid_594262 = path.getOrDefault("serverName")
  valid_594262 = validateParameter(valid_594262, JString, required = true,
                                 default = nil)
  if valid_594262 != nil:
    section.add "serverName", valid_594262
  var valid_594263 = path.getOrDefault("stepName")
  valid_594263 = validateParameter(valid_594263, JString, required = true,
                                 default = nil)
  if valid_594263 != nil:
    section.add "stepName", valid_594263
  var valid_594264 = path.getOrDefault("subscriptionId")
  valid_594264 = validateParameter(valid_594264, JString, required = true,
                                 default = nil)
  if valid_594264 != nil:
    section.add "subscriptionId", valid_594264
  var valid_594265 = path.getOrDefault("jobAgentName")
  valid_594265 = validateParameter(valid_594265, JString, required = true,
                                 default = nil)
  if valid_594265 != nil:
    section.add "jobAgentName", valid_594265
  var valid_594266 = path.getOrDefault("jobName")
  valid_594266 = validateParameter(valid_594266, JString, required = true,
                                 default = nil)
  if valid_594266 != nil:
    section.add "jobName", valid_594266
  var valid_594267 = path.getOrDefault("jobExecutionId")
  valid_594267 = validateParameter(valid_594267, JString, required = true,
                                 default = nil)
  if valid_594267 != nil:
    section.add "jobExecutionId", valid_594267
  var valid_594268 = path.getOrDefault("targetId")
  valid_594268 = validateParameter(valid_594268, JString, required = true,
                                 default = nil)
  if valid_594268 != nil:
    section.add "targetId", valid_594268
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594269 = query.getOrDefault("api-version")
  valid_594269 = validateParameter(valid_594269, JString, required = true,
                                 default = nil)
  if valid_594269 != nil:
    section.add "api-version", valid_594269
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594270: Call_JobTargetExecutionsGet_594258; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a target execution.
  ## 
  let valid = call_594270.validator(path, query, header, formData, body)
  let scheme = call_594270.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594270.url(scheme.get, call_594270.host, call_594270.base,
                         call_594270.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594270, url, valid)

proc call*(call_594271: Call_JobTargetExecutionsGet_594258;
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
  var path_594272 = newJObject()
  var query_594273 = newJObject()
  add(path_594272, "resourceGroupName", newJString(resourceGroupName))
  add(query_594273, "api-version", newJString(apiVersion))
  add(path_594272, "serverName", newJString(serverName))
  add(path_594272, "stepName", newJString(stepName))
  add(path_594272, "subscriptionId", newJString(subscriptionId))
  add(path_594272, "jobAgentName", newJString(jobAgentName))
  add(path_594272, "jobName", newJString(jobName))
  add(path_594272, "jobExecutionId", newJString(jobExecutionId))
  add(path_594272, "targetId", newJString(targetId))
  result = call_594271.call(path_594272, query_594273, nil, nil, nil)

var jobTargetExecutionsGet* = Call_JobTargetExecutionsGet_594258(
    name: "jobTargetExecutionsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/servers/{serverName}/jobAgents/{jobAgentName}/jobs/{jobName}/executions/{jobExecutionId}/steps/{stepName}/targets/{targetId}",
    validator: validate_JobTargetExecutionsGet_594259, base: "",
    url: url_JobTargetExecutionsGet_594260, schemes: {Scheme.Https})
type
  Call_JobTargetExecutionsListByJobExecution_594274 = ref object of OpenApiRestCall_593424
proc url_JobTargetExecutionsListByJobExecution_594276(protocol: Scheme;
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

proc validate_JobTargetExecutionsListByJobExecution_594275(path: JsonNode;
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
  var valid_594277 = path.getOrDefault("resourceGroupName")
  valid_594277 = validateParameter(valid_594277, JString, required = true,
                                 default = nil)
  if valid_594277 != nil:
    section.add "resourceGroupName", valid_594277
  var valid_594278 = path.getOrDefault("serverName")
  valid_594278 = validateParameter(valid_594278, JString, required = true,
                                 default = nil)
  if valid_594278 != nil:
    section.add "serverName", valid_594278
  var valid_594279 = path.getOrDefault("subscriptionId")
  valid_594279 = validateParameter(valid_594279, JString, required = true,
                                 default = nil)
  if valid_594279 != nil:
    section.add "subscriptionId", valid_594279
  var valid_594280 = path.getOrDefault("jobAgentName")
  valid_594280 = validateParameter(valid_594280, JString, required = true,
                                 default = nil)
  if valid_594280 != nil:
    section.add "jobAgentName", valid_594280
  var valid_594281 = path.getOrDefault("jobName")
  valid_594281 = validateParameter(valid_594281, JString, required = true,
                                 default = nil)
  if valid_594281 != nil:
    section.add "jobName", valid_594281
  var valid_594282 = path.getOrDefault("jobExecutionId")
  valid_594282 = validateParameter(valid_594282, JString, required = true,
                                 default = nil)
  if valid_594282 != nil:
    section.add "jobExecutionId", valid_594282
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
  var valid_594283 = query.getOrDefault("api-version")
  valid_594283 = validateParameter(valid_594283, JString, required = true,
                                 default = nil)
  if valid_594283 != nil:
    section.add "api-version", valid_594283
  var valid_594284 = query.getOrDefault("$top")
  valid_594284 = validateParameter(valid_594284, JInt, required = false, default = nil)
  if valid_594284 != nil:
    section.add "$top", valid_594284
  var valid_594285 = query.getOrDefault("endTimeMax")
  valid_594285 = validateParameter(valid_594285, JString, required = false,
                                 default = nil)
  if valid_594285 != nil:
    section.add "endTimeMax", valid_594285
  var valid_594286 = query.getOrDefault("createTimeMax")
  valid_594286 = validateParameter(valid_594286, JString, required = false,
                                 default = nil)
  if valid_594286 != nil:
    section.add "createTimeMax", valid_594286
  var valid_594287 = query.getOrDefault("$skip")
  valid_594287 = validateParameter(valid_594287, JInt, required = false, default = nil)
  if valid_594287 != nil:
    section.add "$skip", valid_594287
  var valid_594288 = query.getOrDefault("endTimeMin")
  valid_594288 = validateParameter(valid_594288, JString, required = false,
                                 default = nil)
  if valid_594288 != nil:
    section.add "endTimeMin", valid_594288
  var valid_594289 = query.getOrDefault("createTimeMin")
  valid_594289 = validateParameter(valid_594289, JString, required = false,
                                 default = nil)
  if valid_594289 != nil:
    section.add "createTimeMin", valid_594289
  var valid_594290 = query.getOrDefault("isActive")
  valid_594290 = validateParameter(valid_594290, JBool, required = false, default = nil)
  if valid_594290 != nil:
    section.add "isActive", valid_594290
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594291: Call_JobTargetExecutionsListByJobExecution_594274;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists target executions for all steps of a job execution.
  ## 
  let valid = call_594291.validator(path, query, header, formData, body)
  let scheme = call_594291.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594291.url(scheme.get, call_594291.host, call_594291.base,
                         call_594291.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594291, url, valid)

proc call*(call_594292: Call_JobTargetExecutionsListByJobExecution_594274;
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
  var path_594293 = newJObject()
  var query_594294 = newJObject()
  add(path_594293, "resourceGroupName", newJString(resourceGroupName))
  add(query_594294, "api-version", newJString(apiVersion))
  add(path_594293, "serverName", newJString(serverName))
  add(path_594293, "subscriptionId", newJString(subscriptionId))
  add(path_594293, "jobAgentName", newJString(jobAgentName))
  add(path_594293, "jobName", newJString(jobName))
  add(query_594294, "$top", newJInt(Top))
  add(query_594294, "endTimeMax", newJString(endTimeMax))
  add(query_594294, "createTimeMax", newJString(createTimeMax))
  add(query_594294, "$skip", newJInt(Skip))
  add(query_594294, "endTimeMin", newJString(endTimeMin))
  add(path_594293, "jobExecutionId", newJString(jobExecutionId))
  add(query_594294, "createTimeMin", newJString(createTimeMin))
  add(query_594294, "isActive", newJBool(isActive))
  result = call_594292.call(path_594293, query_594294, nil, nil, nil)

var jobTargetExecutionsListByJobExecution* = Call_JobTargetExecutionsListByJobExecution_594274(
    name: "jobTargetExecutionsListByJobExecution", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/servers/{serverName}/jobAgents/{jobAgentName}/jobs/{jobName}/executions/{jobExecutionId}/targets",
    validator: validate_JobTargetExecutionsListByJobExecution_594275, base: "",
    url: url_JobTargetExecutionsListByJobExecution_594276, schemes: {Scheme.Https})
type
  Call_JobExecutionsCreate_594295 = ref object of OpenApiRestCall_593424
proc url_JobExecutionsCreate_594297(protocol: Scheme; host: string; base: string;
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

proc validate_JobExecutionsCreate_594296(path: JsonNode; query: JsonNode;
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
  var valid_594298 = path.getOrDefault("resourceGroupName")
  valid_594298 = validateParameter(valid_594298, JString, required = true,
                                 default = nil)
  if valid_594298 != nil:
    section.add "resourceGroupName", valid_594298
  var valid_594299 = path.getOrDefault("serverName")
  valid_594299 = validateParameter(valid_594299, JString, required = true,
                                 default = nil)
  if valid_594299 != nil:
    section.add "serverName", valid_594299
  var valid_594300 = path.getOrDefault("subscriptionId")
  valid_594300 = validateParameter(valid_594300, JString, required = true,
                                 default = nil)
  if valid_594300 != nil:
    section.add "subscriptionId", valid_594300
  var valid_594301 = path.getOrDefault("jobAgentName")
  valid_594301 = validateParameter(valid_594301, JString, required = true,
                                 default = nil)
  if valid_594301 != nil:
    section.add "jobAgentName", valid_594301
  var valid_594302 = path.getOrDefault("jobName")
  valid_594302 = validateParameter(valid_594302, JString, required = true,
                                 default = nil)
  if valid_594302 != nil:
    section.add "jobName", valid_594302
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594303 = query.getOrDefault("api-version")
  valid_594303 = validateParameter(valid_594303, JString, required = true,
                                 default = nil)
  if valid_594303 != nil:
    section.add "api-version", valid_594303
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594304: Call_JobExecutionsCreate_594295; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Starts an elastic job execution.
  ## 
  let valid = call_594304.validator(path, query, header, formData, body)
  let scheme = call_594304.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594304.url(scheme.get, call_594304.host, call_594304.base,
                         call_594304.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594304, url, valid)

proc call*(call_594305: Call_JobExecutionsCreate_594295; resourceGroupName: string;
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
  var path_594306 = newJObject()
  var query_594307 = newJObject()
  add(path_594306, "resourceGroupName", newJString(resourceGroupName))
  add(query_594307, "api-version", newJString(apiVersion))
  add(path_594306, "serverName", newJString(serverName))
  add(path_594306, "subscriptionId", newJString(subscriptionId))
  add(path_594306, "jobAgentName", newJString(jobAgentName))
  add(path_594306, "jobName", newJString(jobName))
  result = call_594305.call(path_594306, query_594307, nil, nil, nil)

var jobExecutionsCreate* = Call_JobExecutionsCreate_594295(
    name: "jobExecutionsCreate", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/servers/{serverName}/jobAgents/{jobAgentName}/jobs/{jobName}/start",
    validator: validate_JobExecutionsCreate_594296, base: "",
    url: url_JobExecutionsCreate_594297, schemes: {Scheme.Https})
type
  Call_JobStepsListByJob_594308 = ref object of OpenApiRestCall_593424
proc url_JobStepsListByJob_594310(protocol: Scheme; host: string; base: string;
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

proc validate_JobStepsListByJob_594309(path: JsonNode; query: JsonNode;
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
  var valid_594311 = path.getOrDefault("resourceGroupName")
  valid_594311 = validateParameter(valid_594311, JString, required = true,
                                 default = nil)
  if valid_594311 != nil:
    section.add "resourceGroupName", valid_594311
  var valid_594312 = path.getOrDefault("serverName")
  valid_594312 = validateParameter(valid_594312, JString, required = true,
                                 default = nil)
  if valid_594312 != nil:
    section.add "serverName", valid_594312
  var valid_594313 = path.getOrDefault("subscriptionId")
  valid_594313 = validateParameter(valid_594313, JString, required = true,
                                 default = nil)
  if valid_594313 != nil:
    section.add "subscriptionId", valid_594313
  var valid_594314 = path.getOrDefault("jobAgentName")
  valid_594314 = validateParameter(valid_594314, JString, required = true,
                                 default = nil)
  if valid_594314 != nil:
    section.add "jobAgentName", valid_594314
  var valid_594315 = path.getOrDefault("jobName")
  valid_594315 = validateParameter(valid_594315, JString, required = true,
                                 default = nil)
  if valid_594315 != nil:
    section.add "jobName", valid_594315
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594316 = query.getOrDefault("api-version")
  valid_594316 = validateParameter(valid_594316, JString, required = true,
                                 default = nil)
  if valid_594316 != nil:
    section.add "api-version", valid_594316
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594317: Call_JobStepsListByJob_594308; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all job steps for a job's current version.
  ## 
  let valid = call_594317.validator(path, query, header, formData, body)
  let scheme = call_594317.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594317.url(scheme.get, call_594317.host, call_594317.base,
                         call_594317.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594317, url, valid)

proc call*(call_594318: Call_JobStepsListByJob_594308; resourceGroupName: string;
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
  var path_594319 = newJObject()
  var query_594320 = newJObject()
  add(path_594319, "resourceGroupName", newJString(resourceGroupName))
  add(query_594320, "api-version", newJString(apiVersion))
  add(path_594319, "serverName", newJString(serverName))
  add(path_594319, "subscriptionId", newJString(subscriptionId))
  add(path_594319, "jobAgentName", newJString(jobAgentName))
  add(path_594319, "jobName", newJString(jobName))
  result = call_594318.call(path_594319, query_594320, nil, nil, nil)

var jobStepsListByJob* = Call_JobStepsListByJob_594308(name: "jobStepsListByJob",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/servers/{serverName}/jobAgents/{jobAgentName}/jobs/{jobName}/steps",
    validator: validate_JobStepsListByJob_594309, base: "",
    url: url_JobStepsListByJob_594310, schemes: {Scheme.Https})
type
  Call_JobStepsCreateOrUpdate_594335 = ref object of OpenApiRestCall_593424
proc url_JobStepsCreateOrUpdate_594337(protocol: Scheme; host: string; base: string;
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

proc validate_JobStepsCreateOrUpdate_594336(path: JsonNode; query: JsonNode;
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
  var valid_594338 = path.getOrDefault("resourceGroupName")
  valid_594338 = validateParameter(valid_594338, JString, required = true,
                                 default = nil)
  if valid_594338 != nil:
    section.add "resourceGroupName", valid_594338
  var valid_594339 = path.getOrDefault("serverName")
  valid_594339 = validateParameter(valid_594339, JString, required = true,
                                 default = nil)
  if valid_594339 != nil:
    section.add "serverName", valid_594339
  var valid_594340 = path.getOrDefault("stepName")
  valid_594340 = validateParameter(valid_594340, JString, required = true,
                                 default = nil)
  if valid_594340 != nil:
    section.add "stepName", valid_594340
  var valid_594341 = path.getOrDefault("subscriptionId")
  valid_594341 = validateParameter(valid_594341, JString, required = true,
                                 default = nil)
  if valid_594341 != nil:
    section.add "subscriptionId", valid_594341
  var valid_594342 = path.getOrDefault("jobAgentName")
  valid_594342 = validateParameter(valid_594342, JString, required = true,
                                 default = nil)
  if valid_594342 != nil:
    section.add "jobAgentName", valid_594342
  var valid_594343 = path.getOrDefault("jobName")
  valid_594343 = validateParameter(valid_594343, JString, required = true,
                                 default = nil)
  if valid_594343 != nil:
    section.add "jobName", valid_594343
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594344 = query.getOrDefault("api-version")
  valid_594344 = validateParameter(valid_594344, JString, required = true,
                                 default = nil)
  if valid_594344 != nil:
    section.add "api-version", valid_594344
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

proc call*(call_594346: Call_JobStepsCreateOrUpdate_594335; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates a job step. This will implicitly create a new job version.
  ## 
  let valid = call_594346.validator(path, query, header, formData, body)
  let scheme = call_594346.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594346.url(scheme.get, call_594346.host, call_594346.base,
                         call_594346.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594346, url, valid)

proc call*(call_594347: Call_JobStepsCreateOrUpdate_594335;
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
  var path_594348 = newJObject()
  var query_594349 = newJObject()
  var body_594350 = newJObject()
  add(path_594348, "resourceGroupName", newJString(resourceGroupName))
  add(query_594349, "api-version", newJString(apiVersion))
  add(path_594348, "serverName", newJString(serverName))
  add(path_594348, "stepName", newJString(stepName))
  add(path_594348, "subscriptionId", newJString(subscriptionId))
  add(path_594348, "jobAgentName", newJString(jobAgentName))
  add(path_594348, "jobName", newJString(jobName))
  if parameters != nil:
    body_594350 = parameters
  result = call_594347.call(path_594348, query_594349, nil, nil, body_594350)

var jobStepsCreateOrUpdate* = Call_JobStepsCreateOrUpdate_594335(
    name: "jobStepsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/servers/{serverName}/jobAgents/{jobAgentName}/jobs/{jobName}/steps/{stepName}",
    validator: validate_JobStepsCreateOrUpdate_594336, base: "",
    url: url_JobStepsCreateOrUpdate_594337, schemes: {Scheme.Https})
type
  Call_JobStepsGet_594321 = ref object of OpenApiRestCall_593424
proc url_JobStepsGet_594323(protocol: Scheme; host: string; base: string;
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

proc validate_JobStepsGet_594322(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594324 = path.getOrDefault("resourceGroupName")
  valid_594324 = validateParameter(valid_594324, JString, required = true,
                                 default = nil)
  if valid_594324 != nil:
    section.add "resourceGroupName", valid_594324
  var valid_594325 = path.getOrDefault("serverName")
  valid_594325 = validateParameter(valid_594325, JString, required = true,
                                 default = nil)
  if valid_594325 != nil:
    section.add "serverName", valid_594325
  var valid_594326 = path.getOrDefault("stepName")
  valid_594326 = validateParameter(valid_594326, JString, required = true,
                                 default = nil)
  if valid_594326 != nil:
    section.add "stepName", valid_594326
  var valid_594327 = path.getOrDefault("subscriptionId")
  valid_594327 = validateParameter(valid_594327, JString, required = true,
                                 default = nil)
  if valid_594327 != nil:
    section.add "subscriptionId", valid_594327
  var valid_594328 = path.getOrDefault("jobAgentName")
  valid_594328 = validateParameter(valid_594328, JString, required = true,
                                 default = nil)
  if valid_594328 != nil:
    section.add "jobAgentName", valid_594328
  var valid_594329 = path.getOrDefault("jobName")
  valid_594329 = validateParameter(valid_594329, JString, required = true,
                                 default = nil)
  if valid_594329 != nil:
    section.add "jobName", valid_594329
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594330 = query.getOrDefault("api-version")
  valid_594330 = validateParameter(valid_594330, JString, required = true,
                                 default = nil)
  if valid_594330 != nil:
    section.add "api-version", valid_594330
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594331: Call_JobStepsGet_594321; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a job step in a job's current version.
  ## 
  let valid = call_594331.validator(path, query, header, formData, body)
  let scheme = call_594331.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594331.url(scheme.get, call_594331.host, call_594331.base,
                         call_594331.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594331, url, valid)

proc call*(call_594332: Call_JobStepsGet_594321; resourceGroupName: string;
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
  var path_594333 = newJObject()
  var query_594334 = newJObject()
  add(path_594333, "resourceGroupName", newJString(resourceGroupName))
  add(query_594334, "api-version", newJString(apiVersion))
  add(path_594333, "serverName", newJString(serverName))
  add(path_594333, "stepName", newJString(stepName))
  add(path_594333, "subscriptionId", newJString(subscriptionId))
  add(path_594333, "jobAgentName", newJString(jobAgentName))
  add(path_594333, "jobName", newJString(jobName))
  result = call_594332.call(path_594333, query_594334, nil, nil, nil)

var jobStepsGet* = Call_JobStepsGet_594321(name: "jobStepsGet",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/servers/{serverName}/jobAgents/{jobAgentName}/jobs/{jobName}/steps/{stepName}",
                                        validator: validate_JobStepsGet_594322,
                                        base: "", url: url_JobStepsGet_594323,
                                        schemes: {Scheme.Https})
type
  Call_JobStepsDelete_594351 = ref object of OpenApiRestCall_593424
proc url_JobStepsDelete_594353(protocol: Scheme; host: string; base: string;
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

proc validate_JobStepsDelete_594352(path: JsonNode; query: JsonNode;
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
  var valid_594354 = path.getOrDefault("resourceGroupName")
  valid_594354 = validateParameter(valid_594354, JString, required = true,
                                 default = nil)
  if valid_594354 != nil:
    section.add "resourceGroupName", valid_594354
  var valid_594355 = path.getOrDefault("serverName")
  valid_594355 = validateParameter(valid_594355, JString, required = true,
                                 default = nil)
  if valid_594355 != nil:
    section.add "serverName", valid_594355
  var valid_594356 = path.getOrDefault("stepName")
  valid_594356 = validateParameter(valid_594356, JString, required = true,
                                 default = nil)
  if valid_594356 != nil:
    section.add "stepName", valid_594356
  var valid_594357 = path.getOrDefault("subscriptionId")
  valid_594357 = validateParameter(valid_594357, JString, required = true,
                                 default = nil)
  if valid_594357 != nil:
    section.add "subscriptionId", valid_594357
  var valid_594358 = path.getOrDefault("jobAgentName")
  valid_594358 = validateParameter(valid_594358, JString, required = true,
                                 default = nil)
  if valid_594358 != nil:
    section.add "jobAgentName", valid_594358
  var valid_594359 = path.getOrDefault("jobName")
  valid_594359 = validateParameter(valid_594359, JString, required = true,
                                 default = nil)
  if valid_594359 != nil:
    section.add "jobName", valid_594359
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594360 = query.getOrDefault("api-version")
  valid_594360 = validateParameter(valid_594360, JString, required = true,
                                 default = nil)
  if valid_594360 != nil:
    section.add "api-version", valid_594360
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594361: Call_JobStepsDelete_594351; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a job step. This will implicitly create a new job version.
  ## 
  let valid = call_594361.validator(path, query, header, formData, body)
  let scheme = call_594361.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594361.url(scheme.get, call_594361.host, call_594361.base,
                         call_594361.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594361, url, valid)

proc call*(call_594362: Call_JobStepsDelete_594351; resourceGroupName: string;
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
  var path_594363 = newJObject()
  var query_594364 = newJObject()
  add(path_594363, "resourceGroupName", newJString(resourceGroupName))
  add(query_594364, "api-version", newJString(apiVersion))
  add(path_594363, "serverName", newJString(serverName))
  add(path_594363, "stepName", newJString(stepName))
  add(path_594363, "subscriptionId", newJString(subscriptionId))
  add(path_594363, "jobAgentName", newJString(jobAgentName))
  add(path_594363, "jobName", newJString(jobName))
  result = call_594362.call(path_594363, query_594364, nil, nil, nil)

var jobStepsDelete* = Call_JobStepsDelete_594351(name: "jobStepsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/servers/{serverName}/jobAgents/{jobAgentName}/jobs/{jobName}/steps/{stepName}",
    validator: validate_JobStepsDelete_594352, base: "", url: url_JobStepsDelete_594353,
    schemes: {Scheme.Https})
type
  Call_JobVersionsListByJob_594365 = ref object of OpenApiRestCall_593424
proc url_JobVersionsListByJob_594367(protocol: Scheme; host: string; base: string;
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

proc validate_JobVersionsListByJob_594366(path: JsonNode; query: JsonNode;
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
  var valid_594368 = path.getOrDefault("resourceGroupName")
  valid_594368 = validateParameter(valid_594368, JString, required = true,
                                 default = nil)
  if valid_594368 != nil:
    section.add "resourceGroupName", valid_594368
  var valid_594369 = path.getOrDefault("serverName")
  valid_594369 = validateParameter(valid_594369, JString, required = true,
                                 default = nil)
  if valid_594369 != nil:
    section.add "serverName", valid_594369
  var valid_594370 = path.getOrDefault("subscriptionId")
  valid_594370 = validateParameter(valid_594370, JString, required = true,
                                 default = nil)
  if valid_594370 != nil:
    section.add "subscriptionId", valid_594370
  var valid_594371 = path.getOrDefault("jobAgentName")
  valid_594371 = validateParameter(valid_594371, JString, required = true,
                                 default = nil)
  if valid_594371 != nil:
    section.add "jobAgentName", valid_594371
  var valid_594372 = path.getOrDefault("jobName")
  valid_594372 = validateParameter(valid_594372, JString, required = true,
                                 default = nil)
  if valid_594372 != nil:
    section.add "jobName", valid_594372
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594373 = query.getOrDefault("api-version")
  valid_594373 = validateParameter(valid_594373, JString, required = true,
                                 default = nil)
  if valid_594373 != nil:
    section.add "api-version", valid_594373
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594374: Call_JobVersionsListByJob_594365; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all versions of a job.
  ## 
  let valid = call_594374.validator(path, query, header, formData, body)
  let scheme = call_594374.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594374.url(scheme.get, call_594374.host, call_594374.base,
                         call_594374.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594374, url, valid)

proc call*(call_594375: Call_JobVersionsListByJob_594365;
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
  var path_594376 = newJObject()
  var query_594377 = newJObject()
  add(path_594376, "resourceGroupName", newJString(resourceGroupName))
  add(query_594377, "api-version", newJString(apiVersion))
  add(path_594376, "serverName", newJString(serverName))
  add(path_594376, "subscriptionId", newJString(subscriptionId))
  add(path_594376, "jobAgentName", newJString(jobAgentName))
  add(path_594376, "jobName", newJString(jobName))
  result = call_594375.call(path_594376, query_594377, nil, nil, nil)

var jobVersionsListByJob* = Call_JobVersionsListByJob_594365(
    name: "jobVersionsListByJob", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/servers/{serverName}/jobAgents/{jobAgentName}/jobs/{jobName}/versions",
    validator: validate_JobVersionsListByJob_594366, base: "",
    url: url_JobVersionsListByJob_594367, schemes: {Scheme.Https})
type
  Call_JobVersionsGet_594378 = ref object of OpenApiRestCall_593424
proc url_JobVersionsGet_594380(protocol: Scheme; host: string; base: string;
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

proc validate_JobVersionsGet_594379(path: JsonNode; query: JsonNode;
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
  var valid_594381 = path.getOrDefault("resourceGroupName")
  valid_594381 = validateParameter(valid_594381, JString, required = true,
                                 default = nil)
  if valid_594381 != nil:
    section.add "resourceGroupName", valid_594381
  var valid_594382 = path.getOrDefault("serverName")
  valid_594382 = validateParameter(valid_594382, JString, required = true,
                                 default = nil)
  if valid_594382 != nil:
    section.add "serverName", valid_594382
  var valid_594383 = path.getOrDefault("subscriptionId")
  valid_594383 = validateParameter(valid_594383, JString, required = true,
                                 default = nil)
  if valid_594383 != nil:
    section.add "subscriptionId", valid_594383
  var valid_594384 = path.getOrDefault("jobAgentName")
  valid_594384 = validateParameter(valid_594384, JString, required = true,
                                 default = nil)
  if valid_594384 != nil:
    section.add "jobAgentName", valid_594384
  var valid_594385 = path.getOrDefault("jobName")
  valid_594385 = validateParameter(valid_594385, JString, required = true,
                                 default = nil)
  if valid_594385 != nil:
    section.add "jobName", valid_594385
  var valid_594386 = path.getOrDefault("jobVersion")
  valid_594386 = validateParameter(valid_594386, JInt, required = true, default = nil)
  if valid_594386 != nil:
    section.add "jobVersion", valid_594386
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594387 = query.getOrDefault("api-version")
  valid_594387 = validateParameter(valid_594387, JString, required = true,
                                 default = nil)
  if valid_594387 != nil:
    section.add "api-version", valid_594387
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594388: Call_JobVersionsGet_594378; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a job version.
  ## 
  let valid = call_594388.validator(path, query, header, formData, body)
  let scheme = call_594388.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594388.url(scheme.get, call_594388.host, call_594388.base,
                         call_594388.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594388, url, valid)

proc call*(call_594389: Call_JobVersionsGet_594378; resourceGroupName: string;
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
  var path_594390 = newJObject()
  var query_594391 = newJObject()
  add(path_594390, "resourceGroupName", newJString(resourceGroupName))
  add(query_594391, "api-version", newJString(apiVersion))
  add(path_594390, "serverName", newJString(serverName))
  add(path_594390, "subscriptionId", newJString(subscriptionId))
  add(path_594390, "jobAgentName", newJString(jobAgentName))
  add(path_594390, "jobName", newJString(jobName))
  add(path_594390, "jobVersion", newJInt(jobVersion))
  result = call_594389.call(path_594390, query_594391, nil, nil, nil)

var jobVersionsGet* = Call_JobVersionsGet_594378(name: "jobVersionsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/servers/{serverName}/jobAgents/{jobAgentName}/jobs/{jobName}/versions/{jobVersion}",
    validator: validate_JobVersionsGet_594379, base: "", url: url_JobVersionsGet_594380,
    schemes: {Scheme.Https})
type
  Call_JobStepsListByVersion_594392 = ref object of OpenApiRestCall_593424
proc url_JobStepsListByVersion_594394(protocol: Scheme; host: string; base: string;
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

proc validate_JobStepsListByVersion_594393(path: JsonNode; query: JsonNode;
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
  var valid_594395 = path.getOrDefault("resourceGroupName")
  valid_594395 = validateParameter(valid_594395, JString, required = true,
                                 default = nil)
  if valid_594395 != nil:
    section.add "resourceGroupName", valid_594395
  var valid_594396 = path.getOrDefault("serverName")
  valid_594396 = validateParameter(valid_594396, JString, required = true,
                                 default = nil)
  if valid_594396 != nil:
    section.add "serverName", valid_594396
  var valid_594397 = path.getOrDefault("subscriptionId")
  valid_594397 = validateParameter(valid_594397, JString, required = true,
                                 default = nil)
  if valid_594397 != nil:
    section.add "subscriptionId", valid_594397
  var valid_594398 = path.getOrDefault("jobAgentName")
  valid_594398 = validateParameter(valid_594398, JString, required = true,
                                 default = nil)
  if valid_594398 != nil:
    section.add "jobAgentName", valid_594398
  var valid_594399 = path.getOrDefault("jobName")
  valid_594399 = validateParameter(valid_594399, JString, required = true,
                                 default = nil)
  if valid_594399 != nil:
    section.add "jobName", valid_594399
  var valid_594400 = path.getOrDefault("jobVersion")
  valid_594400 = validateParameter(valid_594400, JInt, required = true, default = nil)
  if valid_594400 != nil:
    section.add "jobVersion", valid_594400
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594401 = query.getOrDefault("api-version")
  valid_594401 = validateParameter(valid_594401, JString, required = true,
                                 default = nil)
  if valid_594401 != nil:
    section.add "api-version", valid_594401
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594402: Call_JobStepsListByVersion_594392; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all job steps in the specified job version.
  ## 
  let valid = call_594402.validator(path, query, header, formData, body)
  let scheme = call_594402.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594402.url(scheme.get, call_594402.host, call_594402.base,
                         call_594402.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594402, url, valid)

proc call*(call_594403: Call_JobStepsListByVersion_594392;
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
  var path_594404 = newJObject()
  var query_594405 = newJObject()
  add(path_594404, "resourceGroupName", newJString(resourceGroupName))
  add(query_594405, "api-version", newJString(apiVersion))
  add(path_594404, "serverName", newJString(serverName))
  add(path_594404, "subscriptionId", newJString(subscriptionId))
  add(path_594404, "jobAgentName", newJString(jobAgentName))
  add(path_594404, "jobName", newJString(jobName))
  add(path_594404, "jobVersion", newJInt(jobVersion))
  result = call_594403.call(path_594404, query_594405, nil, nil, nil)

var jobStepsListByVersion* = Call_JobStepsListByVersion_594392(
    name: "jobStepsListByVersion", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/servers/{serverName}/jobAgents/{jobAgentName}/jobs/{jobName}/versions/{jobVersion}/steps",
    validator: validate_JobStepsListByVersion_594393, base: "",
    url: url_JobStepsListByVersion_594394, schemes: {Scheme.Https})
type
  Call_JobStepsGetByVersion_594406 = ref object of OpenApiRestCall_593424
proc url_JobStepsGetByVersion_594408(protocol: Scheme; host: string; base: string;
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

proc validate_JobStepsGetByVersion_594407(path: JsonNode; query: JsonNode;
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
  var valid_594409 = path.getOrDefault("resourceGroupName")
  valid_594409 = validateParameter(valid_594409, JString, required = true,
                                 default = nil)
  if valid_594409 != nil:
    section.add "resourceGroupName", valid_594409
  var valid_594410 = path.getOrDefault("serverName")
  valid_594410 = validateParameter(valid_594410, JString, required = true,
                                 default = nil)
  if valid_594410 != nil:
    section.add "serverName", valid_594410
  var valid_594411 = path.getOrDefault("stepName")
  valid_594411 = validateParameter(valid_594411, JString, required = true,
                                 default = nil)
  if valid_594411 != nil:
    section.add "stepName", valid_594411
  var valid_594412 = path.getOrDefault("subscriptionId")
  valid_594412 = validateParameter(valid_594412, JString, required = true,
                                 default = nil)
  if valid_594412 != nil:
    section.add "subscriptionId", valid_594412
  var valid_594413 = path.getOrDefault("jobAgentName")
  valid_594413 = validateParameter(valid_594413, JString, required = true,
                                 default = nil)
  if valid_594413 != nil:
    section.add "jobAgentName", valid_594413
  var valid_594414 = path.getOrDefault("jobName")
  valid_594414 = validateParameter(valid_594414, JString, required = true,
                                 default = nil)
  if valid_594414 != nil:
    section.add "jobName", valid_594414
  var valid_594415 = path.getOrDefault("jobVersion")
  valid_594415 = validateParameter(valid_594415, JInt, required = true, default = nil)
  if valid_594415 != nil:
    section.add "jobVersion", valid_594415
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594416 = query.getOrDefault("api-version")
  valid_594416 = validateParameter(valid_594416, JString, required = true,
                                 default = nil)
  if valid_594416 != nil:
    section.add "api-version", valid_594416
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594417: Call_JobStepsGetByVersion_594406; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the specified version of a job step.
  ## 
  let valid = call_594417.validator(path, query, header, formData, body)
  let scheme = call_594417.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594417.url(scheme.get, call_594417.host, call_594417.base,
                         call_594417.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594417, url, valid)

proc call*(call_594418: Call_JobStepsGetByVersion_594406;
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
  var path_594419 = newJObject()
  var query_594420 = newJObject()
  add(path_594419, "resourceGroupName", newJString(resourceGroupName))
  add(query_594420, "api-version", newJString(apiVersion))
  add(path_594419, "serverName", newJString(serverName))
  add(path_594419, "stepName", newJString(stepName))
  add(path_594419, "subscriptionId", newJString(subscriptionId))
  add(path_594419, "jobAgentName", newJString(jobAgentName))
  add(path_594419, "jobName", newJString(jobName))
  add(path_594419, "jobVersion", newJInt(jobVersion))
  result = call_594418.call(path_594419, query_594420, nil, nil, nil)

var jobStepsGetByVersion* = Call_JobStepsGetByVersion_594406(
    name: "jobStepsGetByVersion", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/servers/{serverName}/jobAgents/{jobAgentName}/jobs/{jobName}/versions/{jobVersion}/steps/{stepName}",
    validator: validate_JobStepsGetByVersion_594407, base: "",
    url: url_JobStepsGetByVersion_594408, schemes: {Scheme.Https})
type
  Call_JobTargetGroupsListByAgent_594421 = ref object of OpenApiRestCall_593424
proc url_JobTargetGroupsListByAgent_594423(protocol: Scheme; host: string;
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

proc validate_JobTargetGroupsListByAgent_594422(path: JsonNode; query: JsonNode;
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
  var valid_594424 = path.getOrDefault("resourceGroupName")
  valid_594424 = validateParameter(valid_594424, JString, required = true,
                                 default = nil)
  if valid_594424 != nil:
    section.add "resourceGroupName", valid_594424
  var valid_594425 = path.getOrDefault("serverName")
  valid_594425 = validateParameter(valid_594425, JString, required = true,
                                 default = nil)
  if valid_594425 != nil:
    section.add "serverName", valid_594425
  var valid_594426 = path.getOrDefault("subscriptionId")
  valid_594426 = validateParameter(valid_594426, JString, required = true,
                                 default = nil)
  if valid_594426 != nil:
    section.add "subscriptionId", valid_594426
  var valid_594427 = path.getOrDefault("jobAgentName")
  valid_594427 = validateParameter(valid_594427, JString, required = true,
                                 default = nil)
  if valid_594427 != nil:
    section.add "jobAgentName", valid_594427
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594428 = query.getOrDefault("api-version")
  valid_594428 = validateParameter(valid_594428, JString, required = true,
                                 default = nil)
  if valid_594428 != nil:
    section.add "api-version", valid_594428
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594429: Call_JobTargetGroupsListByAgent_594421; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all target groups in an agent.
  ## 
  let valid = call_594429.validator(path, query, header, formData, body)
  let scheme = call_594429.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594429.url(scheme.get, call_594429.host, call_594429.base,
                         call_594429.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594429, url, valid)

proc call*(call_594430: Call_JobTargetGroupsListByAgent_594421;
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
  var path_594431 = newJObject()
  var query_594432 = newJObject()
  add(path_594431, "resourceGroupName", newJString(resourceGroupName))
  add(query_594432, "api-version", newJString(apiVersion))
  add(path_594431, "serverName", newJString(serverName))
  add(path_594431, "subscriptionId", newJString(subscriptionId))
  add(path_594431, "jobAgentName", newJString(jobAgentName))
  result = call_594430.call(path_594431, query_594432, nil, nil, nil)

var jobTargetGroupsListByAgent* = Call_JobTargetGroupsListByAgent_594421(
    name: "jobTargetGroupsListByAgent", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/servers/{serverName}/jobAgents/{jobAgentName}/targetGroups",
    validator: validate_JobTargetGroupsListByAgent_594422, base: "",
    url: url_JobTargetGroupsListByAgent_594423, schemes: {Scheme.Https})
type
  Call_JobTargetGroupsCreateOrUpdate_594446 = ref object of OpenApiRestCall_593424
proc url_JobTargetGroupsCreateOrUpdate_594448(protocol: Scheme; host: string;
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

proc validate_JobTargetGroupsCreateOrUpdate_594447(path: JsonNode; query: JsonNode;
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
  var valid_594449 = path.getOrDefault("resourceGroupName")
  valid_594449 = validateParameter(valid_594449, JString, required = true,
                                 default = nil)
  if valid_594449 != nil:
    section.add "resourceGroupName", valid_594449
  var valid_594450 = path.getOrDefault("serverName")
  valid_594450 = validateParameter(valid_594450, JString, required = true,
                                 default = nil)
  if valid_594450 != nil:
    section.add "serverName", valid_594450
  var valid_594451 = path.getOrDefault("subscriptionId")
  valid_594451 = validateParameter(valid_594451, JString, required = true,
                                 default = nil)
  if valid_594451 != nil:
    section.add "subscriptionId", valid_594451
  var valid_594452 = path.getOrDefault("jobAgentName")
  valid_594452 = validateParameter(valid_594452, JString, required = true,
                                 default = nil)
  if valid_594452 != nil:
    section.add "jobAgentName", valid_594452
  var valid_594453 = path.getOrDefault("targetGroupName")
  valid_594453 = validateParameter(valid_594453, JString, required = true,
                                 default = nil)
  if valid_594453 != nil:
    section.add "targetGroupName", valid_594453
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594454 = query.getOrDefault("api-version")
  valid_594454 = validateParameter(valid_594454, JString, required = true,
                                 default = nil)
  if valid_594454 != nil:
    section.add "api-version", valid_594454
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

proc call*(call_594456: Call_JobTargetGroupsCreateOrUpdate_594446; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates a target group.
  ## 
  let valid = call_594456.validator(path, query, header, formData, body)
  let scheme = call_594456.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594456.url(scheme.get, call_594456.host, call_594456.base,
                         call_594456.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594456, url, valid)

proc call*(call_594457: Call_JobTargetGroupsCreateOrUpdate_594446;
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
  var path_594458 = newJObject()
  var query_594459 = newJObject()
  var body_594460 = newJObject()
  add(path_594458, "resourceGroupName", newJString(resourceGroupName))
  add(query_594459, "api-version", newJString(apiVersion))
  add(path_594458, "serverName", newJString(serverName))
  add(path_594458, "subscriptionId", newJString(subscriptionId))
  add(path_594458, "jobAgentName", newJString(jobAgentName))
  add(path_594458, "targetGroupName", newJString(targetGroupName))
  if parameters != nil:
    body_594460 = parameters
  result = call_594457.call(path_594458, query_594459, nil, nil, body_594460)

var jobTargetGroupsCreateOrUpdate* = Call_JobTargetGroupsCreateOrUpdate_594446(
    name: "jobTargetGroupsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/servers/{serverName}/jobAgents/{jobAgentName}/targetGroups/{targetGroupName}",
    validator: validate_JobTargetGroupsCreateOrUpdate_594447, base: "",
    url: url_JobTargetGroupsCreateOrUpdate_594448, schemes: {Scheme.Https})
type
  Call_JobTargetGroupsGet_594433 = ref object of OpenApiRestCall_593424
proc url_JobTargetGroupsGet_594435(protocol: Scheme; host: string; base: string;
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

proc validate_JobTargetGroupsGet_594434(path: JsonNode; query: JsonNode;
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
  var valid_594436 = path.getOrDefault("resourceGroupName")
  valid_594436 = validateParameter(valid_594436, JString, required = true,
                                 default = nil)
  if valid_594436 != nil:
    section.add "resourceGroupName", valid_594436
  var valid_594437 = path.getOrDefault("serverName")
  valid_594437 = validateParameter(valid_594437, JString, required = true,
                                 default = nil)
  if valid_594437 != nil:
    section.add "serverName", valid_594437
  var valid_594438 = path.getOrDefault("subscriptionId")
  valid_594438 = validateParameter(valid_594438, JString, required = true,
                                 default = nil)
  if valid_594438 != nil:
    section.add "subscriptionId", valid_594438
  var valid_594439 = path.getOrDefault("jobAgentName")
  valid_594439 = validateParameter(valid_594439, JString, required = true,
                                 default = nil)
  if valid_594439 != nil:
    section.add "jobAgentName", valid_594439
  var valid_594440 = path.getOrDefault("targetGroupName")
  valid_594440 = validateParameter(valid_594440, JString, required = true,
                                 default = nil)
  if valid_594440 != nil:
    section.add "targetGroupName", valid_594440
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594441 = query.getOrDefault("api-version")
  valid_594441 = validateParameter(valid_594441, JString, required = true,
                                 default = nil)
  if valid_594441 != nil:
    section.add "api-version", valid_594441
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594442: Call_JobTargetGroupsGet_594433; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a target group.
  ## 
  let valid = call_594442.validator(path, query, header, formData, body)
  let scheme = call_594442.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594442.url(scheme.get, call_594442.host, call_594442.base,
                         call_594442.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594442, url, valid)

proc call*(call_594443: Call_JobTargetGroupsGet_594433; resourceGroupName: string;
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
  var path_594444 = newJObject()
  var query_594445 = newJObject()
  add(path_594444, "resourceGroupName", newJString(resourceGroupName))
  add(query_594445, "api-version", newJString(apiVersion))
  add(path_594444, "serverName", newJString(serverName))
  add(path_594444, "subscriptionId", newJString(subscriptionId))
  add(path_594444, "jobAgentName", newJString(jobAgentName))
  add(path_594444, "targetGroupName", newJString(targetGroupName))
  result = call_594443.call(path_594444, query_594445, nil, nil, nil)

var jobTargetGroupsGet* = Call_JobTargetGroupsGet_594433(
    name: "jobTargetGroupsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/servers/{serverName}/jobAgents/{jobAgentName}/targetGroups/{targetGroupName}",
    validator: validate_JobTargetGroupsGet_594434, base: "",
    url: url_JobTargetGroupsGet_594435, schemes: {Scheme.Https})
type
  Call_JobTargetGroupsDelete_594461 = ref object of OpenApiRestCall_593424
proc url_JobTargetGroupsDelete_594463(protocol: Scheme; host: string; base: string;
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

proc validate_JobTargetGroupsDelete_594462(path: JsonNode; query: JsonNode;
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
  var valid_594464 = path.getOrDefault("resourceGroupName")
  valid_594464 = validateParameter(valid_594464, JString, required = true,
                                 default = nil)
  if valid_594464 != nil:
    section.add "resourceGroupName", valid_594464
  var valid_594465 = path.getOrDefault("serverName")
  valid_594465 = validateParameter(valid_594465, JString, required = true,
                                 default = nil)
  if valid_594465 != nil:
    section.add "serverName", valid_594465
  var valid_594466 = path.getOrDefault("subscriptionId")
  valid_594466 = validateParameter(valid_594466, JString, required = true,
                                 default = nil)
  if valid_594466 != nil:
    section.add "subscriptionId", valid_594466
  var valid_594467 = path.getOrDefault("jobAgentName")
  valid_594467 = validateParameter(valid_594467, JString, required = true,
                                 default = nil)
  if valid_594467 != nil:
    section.add "jobAgentName", valid_594467
  var valid_594468 = path.getOrDefault("targetGroupName")
  valid_594468 = validateParameter(valid_594468, JString, required = true,
                                 default = nil)
  if valid_594468 != nil:
    section.add "targetGroupName", valid_594468
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594469 = query.getOrDefault("api-version")
  valid_594469 = validateParameter(valid_594469, JString, required = true,
                                 default = nil)
  if valid_594469 != nil:
    section.add "api-version", valid_594469
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594470: Call_JobTargetGroupsDelete_594461; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a target group.
  ## 
  let valid = call_594470.validator(path, query, header, formData, body)
  let scheme = call_594470.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594470.url(scheme.get, call_594470.host, call_594470.base,
                         call_594470.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594470, url, valid)

proc call*(call_594471: Call_JobTargetGroupsDelete_594461;
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
  var path_594472 = newJObject()
  var query_594473 = newJObject()
  add(path_594472, "resourceGroupName", newJString(resourceGroupName))
  add(query_594473, "api-version", newJString(apiVersion))
  add(path_594472, "serverName", newJString(serverName))
  add(path_594472, "subscriptionId", newJString(subscriptionId))
  add(path_594472, "jobAgentName", newJString(jobAgentName))
  add(path_594472, "targetGroupName", newJString(targetGroupName))
  result = call_594471.call(path_594472, query_594473, nil, nil, nil)

var jobTargetGroupsDelete* = Call_JobTargetGroupsDelete_594461(
    name: "jobTargetGroupsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/servers/{serverName}/jobAgents/{jobAgentName}/targetGroups/{targetGroupName}",
    validator: validate_JobTargetGroupsDelete_594462, base: "",
    url: url_JobTargetGroupsDelete_594463, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
